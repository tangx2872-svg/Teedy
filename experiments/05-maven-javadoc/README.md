# 实验五：Maven 与 JavaDoc

## 状态

✅ 已完成

## 实验任务

1. 阅读根目录及三个模块的 pom.xml。 ✅
2. 理解 Maven 构建生命周期、模块依赖和构建顺序。 ✅
3. 修改 Maven 配置，使正常构建过程同时生成 JavaDoc。 ✅
4. 实际执行构建并验证文档输出。 ✅
5. 记录命令、配置及生成文档的位置。 ✅

## 核心成果

- 在根 `pom.xml` 添加 `maven-javadoc-plugin`（3.6.3），绑定 `package` 阶段。
- 配置 `javadoc` + `jar` 两个 goal：生成 HTML 文档 + `-javadoc.jar`。
- `doclint=none` 规避 Java 11 严格校验。
- 构建验证：`mvn clean package -DskipTests` → BUILD SUCCESS，三模块均生成 JavaDoc。

## 产出清单

| 产出 | 文件 |
| --- | --- |
| JavaDoc 生成报告 | `reports/javadoc-generation.md` |
| 问题记录 | `notes.md` |

> JavaDoc 产物位于各模块 `target/site/apidocs/`（HTML）和 `target/*-javadoc.jar`，均被 `.gitignore` 忽略，不提交到仓库。

## 相关目录

- `reports/`：JavaDoc 生成记录
- `notes.md`：问题与解决
