# 实验四 notes.md — 问题与解决

## 本轮问题与解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 无 PlantUML 工具 | 环境无 plantuml 命令、无 jar、无 graphviz、无 Docker | 从 Maven Central 下载 `plantuml-1.2024.7.jar`（21MB）到 `D:\tools\plantuml.jar`，用 `java -jar` 本地渲染 |
| GitHub Release 下载极慢 | GitHub release 源在国内网络慢（10 分钟未完成） | 改用 Maven Central（repo1.maven.org），速度快（约 1 分钟） |
| PlantUML 中文乱码（方块） | 默认字体不支持中文 | 在 `.puml` 内加 `skinparam defaultFontName "SimHei"`（黑体，Windows 自带），并放在 `!theme plain` **之后**（否则被 theme 重置） |
| `component "x" as y <<标签>>` 尖括号乱码 | `«»` 尖括号在 SimHei 字体缺字形 | 改为把中文说明直接写进组件名，如 `component "docs-core（后端核心）" as core` |
| 全角括号 `（后端核心）` 紧跟 `as core` 报语法错误 | PlantUML 解析限制 | 把全角括号放进引号内的组件名，而非 `as` 别名之后 |

## 关键经验

- PlantUML 中文字体必须用 `skinparam defaultFontName`（写进 .puml），命令行 `-SdefaultFontName` / `-Dfontname` 均无效。
- `skinparam` 要放在 `!theme plain` 之后，否则被主题覆盖。
- 渲染命令：`java -jar plantuml.jar -charset UTF-8 -tpng -o <输出目录> <输入.puml>`。

## 架构分析要点

- 多模块：docs-parent（父 POM）→ docs-core / docs-web-common / docs-web 三模块。
- 实体用字符串外键（userId/fileId）而非 JPA @ManyToOne，由 DAO 手动 join——这是 Teedy 的设计特点。
- DAO 通过 `ThreadLocalContext.get().getEntityManager()` 获取 EntityManager（线程本地上下文模式）。
- REST 资源类均继承 `BaseResource`（鉴权基类）。
