# 实验五：Maven 与 JavaDoc

## 状态

✅ 已完成

## 实验目的

理解 Maven 构建生命周期、模块依赖与构建顺序，并修改 Maven 配置使正常构建过程自动生成 JavaDoc 文档。

## 实验原理

- **Maven 构建生命周期**：标准三套生命周期——`clean` / `default` / `site`。`default` 生命周期核心阶段依次为：
  `validate → compile → test → package → verify → install → deploy`。
  每个阶段会依次触发之前的阶段（如执行 `package` 会先执行 `compile`、`test`）。
- **多模块构建（reactor）**：父 POM 的 `<modules>` 声明子模块，构建时按依赖顺序编译。
- **JavaDoc**：JDK 自带工具，从源码的 Javadoc 注释生成 HTML API 文档。`maven-javadoc-plugin` 将其集成到 Maven 生命周期中。

## 实验任务

1. 阅读根目录及三个模块的 pom.xml。 ✅
2. 理解 Maven 构建生命周期、模块依赖和构建顺序。 ✅
3. 修改 Maven 配置，使正常构建过程同时生成 JavaDoc。 ✅
4. 实际执行构建并验证文档输出。 ✅
5. 记录命令、配置及生成文档的位置。 ✅

## 分步操作过程

### 1. 阅读 pom.xml，梳理模块依赖

- `docs-parent`（父 POM）：统一声明依赖版本、插件版本、`<modules>`。
- 依赖关系：`docs-web` 依赖 `docs-core` 与 `docs-web-common`；`docs-web-common` 依赖 `docs-core`。
- 构建顺序：reactor 按依赖拓扑排序，`docs-core` → `docs-web-common` → `docs-web`。

### 2. 配置 maven-javadoc-plugin

在根 `pom.xml` 添加 `maven-javadoc-plugin`（版本 3.6.3，兼容 Java 11），绑定到 `package` 阶段，配置两个 goal：

- `javadoc`：生成 HTML 文档到 `target/site/apidocs/`
- `jar`：打包 `-javadoc.jar`

关键配置规避 Java 11 严格校验：

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-javadoc-plugin</artifactId>
  <version>3.6.3</version>
  <configuration>
    <doclint>none</doclint>          <!-- 关闭 doclint 严格校验 -->
    <failOnError>false</failOnError> <!-- 缺注释不中断构建 -->
  </configuration>
  <executions>
    <execution>
      <id>attach-javadocs</id>
      <phase>package</phase>          <!-- 绑定到 package 阶段 -->
      <goals><goal>jar</goal></goals>
    </execution>
  </executions>
</plugin>
```

### 3. 执行构建并验证

```bash
mvn clean package -DskipTests
```

结果：`BUILD SUCCESS`，三模块均自动生成 JavaDoc。

## 结果验证

| 模块 | HTML 文档数 | javadoc jar |
| --- | --- | --- |
| docs-core | 460 个 HTML | ✅ |
| docs-web-common | 58 个 HTML | ✅ |
| docs-web | 61 个 HTML | ✅ |

- 文档位置：各模块 `target/site/apidocs/`（HTML）+ `target/*-javadoc.jar`。
- 因 `target/` 被 `.gitignore` 忽略，JavaDoc 产物不入库，仅保留配置与记录。

## 问题与解决（关键踩坑）

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| Java 11 doclint 中断生成 | 源码 Javadoc 注释不完整，doclint 严格校验报错 | `<doclint>none</doclint>` + `<failOnError>false</failOnError>` |
| 构建日志中文乱码 | Windows 控制台默认 GBK 编码 | 仅影响控制台显示，生成的 HTML 为 UTF-8 正常，无需处理 |

## 相关目录

- `reports/javadoc-generation.md`：JavaDoc 生成记录
- `notes.md`：问题与解决
