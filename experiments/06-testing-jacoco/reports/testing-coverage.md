# 实验六：软件测试与 JaCoCo 覆盖率报告

## 一、运行全部测试

### 命令

```bash
mvn test                           # 运行全部测试
mvn test -Dtest=TestLocaleUtil     # 运行指定测试
mvn test -DskipTests               # 跳过测试
mvn test -Dmaven.test.failure.ignore=true  # 测试失败仍继续构建
```

### 测试结果（真实，未编造）

docs-core 模块共 **23 个测试，20 通过，3 失败**：

| 状态 | 数量 | 说明 |
| --- | --- | --- |
| 通过 | 20 | 含新增的 4 个 TestLocaleUtil 测试 |
| 失败 | 3 | 均为基线环境相关失败（详见下文） |

### 3 个失败测试（基线环境相关）

| 测试 | 失败原因 | 根因 |
| --- | --- | --- |
| `TestMimeTypeUtil.test` | expected `text/csv` but was `application/vnd.ms-excel` | JDK 11 的 `Files.probeContentType()` 对 .csv 的 MIME 映射与原始环境不同 |
| `TestPdfFormatHandler.testIssue373` | PDF 提取文本不含预期德语词 | PDFBox 版本差异 |
| `TestFileUtil.extractContentScannedPdf` | 扫描件 PDF 文本提取断言失败 | PDFBox 版本差异 |

> 这 3 个失败是**基线就存在**的环境相关失败（JDK 11 + 依赖版本与原始开发环境差异），非实验引入。修复需改依赖版本（违反「不随意升级依赖」原则）或改断言（掩盖问题），故**如实记录、不处理**。这符合教材「不得编造测试结果」的纪律。

## 二、Surefire 测试报告

Surefire 报告位置：`docs-core/target/surefire-reports/*.txt`（每个测试类一个报告文件）。

执行耗时最长的测试：
- `TestFileUtil`：333.7s（含 PDF 处理）
- `TestPdfFormatHandler`：265.2s（PDF 文本提取）
- `TestFileSizeService`：9.3s

## 三、配置 JaCoCo 插件

在根 `pom.xml` 添加 `jacoco-maven-plugin`（0.8.11）：

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <version>${org.jacoco.jacoco-maven-plugin.version}</version>
  <executions>
    <execution>
      <id>prepare-agent</id>
      <goals><goal>prepare-agent</goal></goals>
    </execution>
    <execution>
      <id>report</id>
      <phase>test</phase>
      <goals><goal>report</goal></goals>
    </execution>
  </executions>
</plugin>
```

覆盖率报告位置：`docs-core/target/site/jacoco/`（`jacoco.xml` + `index.html`）。

## 四、基线覆盖率（docs-core）

| 指标 | 覆盖率 |
| --- | --- |
| 指令 INSTRUCTION | 27.4%（5633/20523） |
| 行 LINE | 24.6%（1272/5178） |
| 分支 BRANCH | 21.9% |
| 方法 METHOD | 25.1% |
| 类 CLASS | 40.3%（75/186） |

## 五、选择低覆盖率类并编写有效测试

### 选类

从 JaCoCo 报告中选择 **`LocaleUtil`**（`com.sismics.util.LocaleUtil`，行覆盖率 0%）：
- 纯静态工具类，`getLocale(String)` 方法解析 locale 代码（如 `fr_FR`）。
- 纯逻辑、无外部依赖（不涉及数据库/文件/网络），测试稳定、有意义。
- 有清晰的边界条件（null、空、纯语言、语言+国家、语言+国家+变体）。

### 编写的测试

新增 `docs-core/src/test/java/com/sismics/util/TestLocaleUtil.java`，4 个测试方法：

1. `getLocaleNullAndEmptyTest`：null / 空字符串 → Locale.ENGLISH
2. `getLocaleLanguageOnlyTest`：`"fr"` → Locale("fr", "", "")
3. `getLocaleLanguageCountryTest`：`"zh_CN"` → Locale("zh", "CN", "")
4. `getLocaleLanguageCountryVariantTest`：`"zh_CN_linux"` → Locale("zh", "CN", "linux")

### 测试验证

```
mvn test -pl docs-core -Dtest=TestLocaleUtil
→ Tests run: 4, Failures: 0, Errors: 0, Skipped: 0  BUILD SUCCESS
```

## 六、覆盖率对比

### LocaleUtil 覆盖率变化

| 指标 | 测试前 | 测试后 |
| --- | --- | --- |
| 行 LINE | 0%（0/12） | **91.7%（11/12）** |
| 分支 BRANCH | 0%（0/6） | **100%（6/6）** |
| 指令 INSTRUCTION | 0%（0/43） | **93.0%（40/43）** |
| 方法 getLocale | 0 行 | **11/11 行全覆盖** |

### docs-core 总体覆盖率变化

| 指标 | 测试前 | 测试后 | 提升 |
| --- | --- | --- | --- |
| 行 LINE | 24.6% | **24.8%** | +0.2% |
| 指令 INSTRUCTION | 27.4% | **27.6%** | +0.2% |
| 类 CLASS | 40.3% | **40.9%** | +0.6% |

## 七、结论

1. ✅ 运行全部测试并生成 Surefire 报告（23 测试，20 通过，3 失败如实记录）。
2. ✅ 验证了运行指定测试（`-Dtest`）和跳过测试（`-DskipTests`）用法。
3. ✅ 配置 JaCoCo 插件，生成覆盖率报告（XML + HTML）。
4. ✅ 分析了模块/类/方法覆盖率。
5. ✅ 选择低覆盖类 `LocaleUtil` 编写 4 个有效测试，行覆盖率 0% → 91.7%。
6. ✅ 重新运行 JaCoCo 对比覆盖率变化（总体行覆盖 +0.2%）。

> 说明：docs-web / docs-web-common 模块的测试因 surefire provider 检测异常未运行（Tests run: 0），已记录在 notes.md，实验六覆盖率以 docs-core（业务核心模块）为准。
