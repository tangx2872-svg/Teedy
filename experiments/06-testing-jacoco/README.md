# 实验六：软件测试与覆盖率

## 状态

✅ 已完成

## 实验目的

掌握 Maven 测试执行与覆盖率统计：运行全部测试、理解指定/跳过测试的命令，配置 JaCoCo 生成覆盖率报告，并针对低覆盖类编写有效测试以提升覆盖率。

## 实验原理

- **Surefire**：Maven 默认的测试执行插件，在 `test` 阶段运行 `src/test/java` 下的单元测试（JUnit 4 写的测试）。
- **JaCoCo**：Java 代码覆盖率工具，通过 `prepare-agent`（字节码插桩）+ `report`（生成报告）两个 goal 统计覆盖率。
- **覆盖率指标**：指令（INSTRUCTION）、行（LINE）、分支（BRANCH）、方法（METHOD）、类（CLASS）。

## 实验任务

1. 使用 Maven 运行全部测试。 ✅（23 测试，20 通过，3 失败如实记录）
2. 验证如何运行指定测试及跳过测试。 ✅（`-Dtest` / `-DskipTests`）
3. 生成 Surefire 测试报告。 ✅
4. 分析测试成功率及执行耗时。 ✅
5. 配置 JaCoCo Maven 插件。 ✅（0.8.11）
6. 生成测试覆盖率报告。 ✅
7. 分析模块、类及方法覆盖率。 ✅
8. 选择一个覆盖率较低的类，编写有效测试。 ✅（LocaleUtil，0% → 91.7%）
9. 重新运行 JaCoCo，对比覆盖率变化。 ✅

## 分步操作过程

### 1. 运行全部测试

```bash
mvn test
```

结果：共 23 个测试，20 通过、3 失败（均为上游基线失败，如实记录）。

### 2. 指定测试与跳过测试

```bash
mvn test -Dtest=LocaleUtilTest        # 只运行指定测试类
mvn test -DskipTests                  # 跳过测试
```

### 3. 配置 JaCoCo 插件

在根 `pom.xml` 添加 `jacoco-maven-plugin`（0.8.11），绑定 `prepare-agent` 到 `test` 前、`report` 到 `test` 后：

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>0.8.11</version>
  <executions>
    <execution><goals><goal>prepare-agent</goal></goals></execution>
    <execution><id>report</id><phase>test</phase>
      <goals><goal>report</goal></goals></execution>
  </executions>
</plugin>
```

### 4. 分析覆盖率，定位低覆盖类

基线覆盖率（docs-core）：指令 27.4%、行 24.6%、分支 21.9%、方法 25.1%、类 40.3%（75/186）。

### 5. 选择 `LocaleUtil` 编写测试

`LocaleUtil` 覆盖率为 0%，为其编写 **4 个有效测试**（`docs-core/src/test/java/com/sismics/util/TestLocaleUtil.java`），覆盖其不同分支逻辑。

### 6. 重新运行并对比

```bash
mvn test -Dmaven.test.failure.ignore=true   # 忽略 3 个基线失败，继续收集覆盖率
```

## 结果验证

- `LocaleUtil` 行覆盖率 **0% → 91.7%**。
- docs-core 总体行覆盖率 **24.6% → 24.8%**。
- 覆盖率报告位置：`docs-core/target/site/jacoco/index.html`（HTML）+ `jacoco.xml`（XML）。

## 3 个基线失败详情（如实记录）

| 测试 | 失败原因 | 根因 |
| --- | --- | --- |
| `TestMimeTypeUtil.test:42` | expected `<text/csv>` but was `<application/vnd.ms-excel>` | JDK 11 的 `Files.probeContentType()` 对 .csv 返回 ms-excel，与旧 JDK 的 MIME 映射不同 |
| `TestPdfFormatHandler.testIssue373` | PDF 文本提取不含预期德语词 | PDFBox 版本差异导致提取结果变化 |
| `TestFileUtil.extractContentScannedPdf:75` | 扫描件 PDF 文本提取断言失败 | 同上，PDF 提取版本差异 |

> 这 3 个失败均为**基线环境相关**（JDK/依赖版本差异），修复需改依赖版本（违反「不随意升级依赖」）或改断言（掩盖问题），故如实记录、不处理。

## 问题与解决（关键踩坑）

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 3 个基线测试失败 | JDK 11 + 依赖版本与原始环境差异 | 如实记录，用 `-Dmaven.test.failure.ignore=true` 继续收集覆盖率 |
| docs-web / docs-web-common 测试未运行（Tests run: 0） | surefire 3.0.0 用了 JUnitPlatformProvider，但测试是 JUnit 4 写的，provider 检测异常 | 记录为技术发现；覆盖率用 docs-core（13 个测试类、19 个测试）完成 |

## 纪律要求

已遵守：记录真实测试结果（3 个基线失败如实记录，未编造、未虚增覆盖率）。

## 相关目录

- `reports/testing-coverage.md`：测试与覆盖率报告
- `notes.md`：问题与解决
- 新增测试代码：`docs-core/src/test/java/com/sismics/util/TestLocaleUtil.java`
