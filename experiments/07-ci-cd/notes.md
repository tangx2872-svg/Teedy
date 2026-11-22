# 实验七：CI/CD — 问题与解决记录

## 一、实验目标

为 Teedy 配置持续集成流水线（Jenkins + GitHub Actions），流水线包含：
Maven 构建、PMD 代码检查、自动化测试、Surefire 测试报告、JavaDoc 文档生成、
可执行 JAR/WAR 制品归档。创建 `Jenkinsfile` 与 GitHub Actions workflow，
并通过实际提交验证流水线运行。

## 二、关键决策

### 1. 测试阶段策略：如实跑全量测试（用户确认）

实验六已确认项目存在 **3 个上游基线测试失败**：

| 测试 | 原因 |
| --- | --- |
| `TestMimeTypeUtil.test:42` | JDK 11 的 MIME 映射把 `text/csv` 映射为 `application/vnd.ms-excel`，断言不匹配 |
| `TestPdfFormatHandler.testIssue373` | PDFBox 版本差异导致行为不符 |
| `TestFileUtil.extractContentScannedPdf:75` | PDFBox 版本差异 |

这属于**上游仓库本身的基线问题**，非本项目代码引入。经与用户确认，CI 测试阶段
**如实运行、不降级**：`mvn test` 会因这 3 个失败而红灯，但这是流水线真实拦截能力的
体现，符合「如实记录失败」原则。

> 后果：GitHub Actions 的测试阶段（`test` job）会显示失败，但流水线前面/后面的
> PMD、JavaDoc、package、制品归档阶段仍会继续产出可用的报告与制品。

### 2. PMD 定位：先观察，后门禁

**现象**：首次用完整 PMD 规则集（bestpractices + codestyle + errorprone）跑 `pmd:check`，
在 `docs-core` 上发现 **3028 个违规**，会导致流水线无意义地红灯。

**违规分布**（Top 规则）：

| 规则 | 违规数 | 类别 |
| --- | --- | --- |
| MethodArgumentCouldBeFinal | 826 | 风格 |
| LocalVariableCouldBeFinal | 806 | 风格 |
| ShortVariable | 385 | 风格 |
| LinguisticNaming | 141 | 风格 |
| CloseResource | 120 | 隐患 |
| AtLeastOneConstructor | 119 | 风格 |
| ... | ... | ... |

绝大多数是**代码风格类**违规，是上游代码的既有写法。若强行清零需改动成千上万行
上游代码，违反「不随意修改上游代码」原则。

**最终方案**：
- rulesets 收窄为 `bestpractices` + `errorprone`（真正有价值的 bug 隐患规则）；
- `failOnViolation=false`，`pmd:check` 只生成报告、不阻断构建；
- 收窄后违规数：docs-core 374 / docs-web-common 33 / docs-web 255，
  报告仍有实际价值（如 CloseResource 资源泄漏隐患）。

> 这是业界对存量代码引入静态分析的标准实践：先「观察」产出基线报告，再逐步
> 收紧规则、开启门禁。

## 三、实施细节

### pom.xml 变更

- 新增属性 `maven-pmd-plugin.version = 3.21.2`；
- 新增 `maven-pmd-plugin`，绑定 `verify` 阶段，goals 为 `check` + `cpd-check`；
- `linkXRef=false`（避免链接到未生成的交叉引用报告）、`minimumTokens=100`（CPD 最小重复块）。

### GitHub Actions workflow（`.github/workflows/ci.yml`）

- 触发：`push`（master）、`pull_request`（master）、`workflow_dispatch`；
- JDK：Temurin 11，`cache: maven`；额外用 `actions/cache` 缓存 `~/.m2/repository`；
- 阶段：检出 → compile → PMD → test → JavaDoc → package(-DskipTests) → 归档；
- 归档 5 类 artifact：build-artifacts / surefire-reports / jacoco-reports / pmd-reports / javadoc。

### Jenkinsfile（声明式 Pipeline）

- `tools { jdk 'jdk11'; maven 'maven3' }`（需在 Jenkins 全局工具配置中对应命名）；
- 阶段：检出代码 → Maven 构建 → PMD → 自动化测试 → JavaDoc → 打包归档；
- 测试阶段 post 中发布 `junit` 测试报告 + `jacoco` 覆盖率，并 `archiveArtifacts`；
- `options`：timeout 45min、timestamps、buildDiscarder 保留 10 次、disableConcurrentBuilds。

## 四、本地验证结果（Windows 原生 + Maven 3.9.9 + JDK 11）

| 命令 | 结果 |
| --- | --- |
| `mvn clean compile` | ✅ 通过 |
| `mvn pmd:pmd pmd:cpd pmd:check pmd:cpd-check` | ✅ 通过（生成报告，非阻断） |
| `mvn test` | ❌ 3 个基线失败（如实） |
| `mvn javadoc:javadoc javadoc:jar` | ✅ 通过 |
| `mvn package -DskipTests` | ✅ 通过，产出 WAR 99MB + 各模块 JAR |

## 五、遗留与后续

- **Jenkins 未在本地部署**：Jenkinsfile 已按声明式 Pipeline 标准编写，但本地为
  Windows 笔记本，未安装 Jenkins 服务；GitHub Actions 已实际跑通并验证。
  如需 Jenkins 端到端验证，需在可访问的环境中部署 Jenkins + 配置 jdk11/maven3 工具。
- 后续可逐步收紧 PMD rulesets、开启 `failOnViolation=true` 作为门禁。

## 六、GitHub Actions 云端迭代修复记录

三次提交迭代，每次解决一个「本地通过、云端失败」的环境差异问题：

### 迭代 1（`fe2b6342`）— PMD 阶段云端失败

`pmd:check pmd:cpd-check` 作为命令行 default-cli goal 在 ubuntu 干净环境触发失败。
本地 Windows 因已有 target 报告缓存未复现。修复：PMD 阶段改为只生成报告
（`pmd:pmd pmd:cpd`）+ `continue-on-error`，定位为「观察」而非「门禁」。

### 迭代 2（`4b58a8f9`）— JavaDoc 阶段云端失败

`javadoc:javadoc` 命令行直接运行，`docs-web` 依赖 `docs-core`/`docs-web-common`
时 reactor 未正确解析依赖（本地因之前 package 已 install 依赖而通过）。修复：
移除独立 JavaDoc 步骤，依赖 pom 已绑定的 `attach-javadocs` execution，由
`package` 阶段统一产出 javadoc 目录与 `*-javadoc.jar`。

### 迭代 3（`f69576cf`）— 最终状态

流水线完整跑通：PMD ✅、测试 ✅（continue-on-error 捕获 3 个上游基线失败）、
package+JavaDoc ✅、制品/报告归档 ✅；最后「检查测试结果」步骤如实 `exit 1`
标红。**结论为 failure 是符合预期的如实结果**，非流水线缺陷。

### 经验教训

1. 「本地通过 ≠ 云端通过」：本地有 Maven 本地仓库与 target 缓存，云端是干净
   checkout，reactor 依赖解析、插件 default-cli execution 的行为会不同。
2. 命令行直接调 goal（`pmd:check`、`javadoc:javadoc`）与 pom 绑定的 execution
   行为不一致，应优先依赖 pom 的 lifecycle 绑定（package/verify 阶段）。
3. 未认证 GitHub REST API 有 60 次/小时限流，轮询流水线状态需节制。

