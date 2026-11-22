# 实验五 notes.md — 问题与解决

## 本轮问题与解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| Java 11 doclint 可能中断 JavaDoc 生成 | Teedy 源码未写完整 Javadoc 注释，JDK 11 的 doclint 严格校验会报错 | 在 maven-javadoc-plugin 配置 `<doclint>none</doclint>` + `<failOnError>false</failOnError>` |
| 构建日志中文乱码 | Windows 控制台默认 GBK 编码 | 仅影响控制台显示，实际生成的 HTML 为 UTF-8，内容正常，无需处理 |

## 关键配置要点

- maven-javadoc-plugin 绑定到 `package` 阶段，使正常构建自动生成 JavaDoc。
- 用 `javadoc` + `jar` 两个 goal：前者生成 `target/site/apidocs/` HTML，后者打包 `-javadoc.jar`。
- 插件版本 3.6.3（兼容 Java 11）。

## 验证结果

- `mvn clean package -DskipTests` → BUILD SUCCESS。
- 三模块均生成 HTML 文档（docs-core 460 / docs-web-common 58 / docs-web 61 个 HTML）和 javadoc jar。
