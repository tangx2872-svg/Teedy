# 实验六 notes.md — 问题与解决

## 本轮问题与解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 3 个基线测试失败 | JDK 11 + 依赖版本与原始开发环境差异 | 如实记录，不掩盖、不跳过、不虚增；用 `-Dmaven.test.failure.ignore=true` 让构建继续收集覆盖率 |
| docs-web / docs-web-common 测试未运行（Tests run: 0） | surefire 3.0.0 对这两个模块用了 JUnitPlatformProvider，但测试是 JUnit 4 写的，provider 检测异常 | 记录为技术发现；实验六核心覆盖率用 docs-core（13 个测试类、19 个测试）完成 |

## 3 个基线失败详情

| 测试 | 失败原因 | 根因 |
| --- | --- | --- |
| `TestMimeTypeUtil.test:42` | expected `<text/csv>` but was `<application/vnd.ms-excel>` | JDK 11 的 `Files.probeContentType()` 对 .csv 返回 ms-excel，与原始环境（旧 JDK）MIME 映射不同 |
| `TestPdfFormatHandler.testIssue373` | PDF 文本提取不含预期德语词 | PDFBox 版本差异导致 `extractContent` 提取结果变化 |
| `TestFileUtil.extractContentScannedPdf:75` | 扫描件 PDF 文本提取断言失败 | 同上，PDF 提取版本差异 |

> 这 3 个失败均为**基线环境相关**，修复需改依赖版本（违反「不随意升级依赖」原则）或改断言（掩盖问题），故如实记录、不处理。

## 基线覆盖率（docs-core）

| 指标 | 覆盖率 |
| --- | --- |
| 指令 INSTRUCTION | 27.4%（5633/20523） |
| 行 LINE | 24.6%（1272/5178） |
| 分支 BRANCH | 21.9% |
| 方法 METHOD | 25.1% |
| 类 CLASS | 40.3%（75/186） |

## 关键配置

- JaCoCo 插件 0.8.11，`prepare-agent` + `report`（绑定 test 阶段）。
- 覆盖率报告位置：`docs-core/target/site/jacoco/jacoco.xml`（XML）+ `index.html`（HTML）。
