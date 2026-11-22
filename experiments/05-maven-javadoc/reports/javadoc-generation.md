# 实验五：Maven 构建与 JavaDoc 生成报告

## 一、Maven 多模块结构与构建生命周期

### 模块依赖与构建顺序

Teedy 是 Maven 多模块工程，根 POM 为 `docs-parent`（packaging=pom），`<modules>` 定义三个子模块，构建按**依赖顺序**进行：

```
docs-parent（父 POM，聚合）
├── docs-core        （jar，无内部依赖，最先构建）
├── docs-web-common  （jar，依赖 docs-core）
└── docs-web         （war，依赖 docs-core + docs-web-common）
```

构建顺序：**docs-core → docs-web-common → docs-web**（Maven 自动按依赖拓扑排序）。

### Maven 生命周期理解

| 阶段 | 作用 | 本次实验使用 |
| --- | --- | --- |
| `validate` | 校验项目配置 | ✅ 验证 pom 语法 |
| `compile` | 编译源码 | ✅（package 内含） |
| `test` | 运行单元测试 | ⏭ 用 `-DskipTests` 跳过 |
| `package` | 打包（jar/war） | ✅ 触发 JavaDoc 生成 |
| `install` | 安装到本地仓库 | （历史构建使用） |

## 二、修改 Maven 配置生成 JavaDoc

### 修改位置

在根 `pom.xml` 的 `<properties>` 增加插件版本，在 `<build><plugins>` 增加 `maven-javadoc-plugin`。

### 修改内容

```xml
<!-- properties 中 -->
<org.apache.maven.plugins.maven-javadoc-plugin.version>3.6.3</org.apache.maven.plugins.maven-javadoc-plugin.version>

<!-- build/plugins 中 -->
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-javadoc-plugin</artifactId>
  <version>${org.apache.maven.plugins.maven-javadoc-plugin.version}</version>
  <configuration>
    <encoding>UTF-8</encoding>
    <charset>UTF-8</charset>
    <docencoding>UTF-8</docencoding>
    <doclint>none</doclint>
    <failOnError>false</failOnError>
  </configuration>
  <executions>
    <execution>
      <id>attach-javadocs</id>
      <phase>package</phase>
      <goals>
        <goal>javadoc</goal>
        <goal>jar</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

### 关键配置说明

| 配置 | 作用 |
| --- | --- |
| `<phase>package</phase>` | 绑定到 package 阶段，使**正常构建自动生成 JavaDoc** |
| `<goal>javadoc</goal>` | 生成 HTML 文档到 `target/site/apidocs/` |
| `<goal>jar</goal>` | 同时打包 `-javadoc.jar` |
| `<doclint>none</doclint>` | 关闭 Java 11 的 doclint 严格校验（Teedy 源码未写完整 Javadoc 注释，开启会报错中断构建） |
| `<failOnError>false</failOnError>` | 个别类文档问题不阻断构建 |

## 三、构建命令与结果

### 命令

```bash
mvn clean package -DskipTests   # 完整构建 + 生成 JavaDoc（跳过测试）
```

### 构建结果

```
Docs Parent    ........................................ SUCCESS
Docs Core      ........................................ SUCCESS
Docs Web Commons ...................................... SUCCESS
Docs Web       ........................................ SUCCESS
BUILD SUCCESS
Total time: 05:12 min
```

## 四、JavaDoc 输出位置与内容

### 输出位置

| 模块 | HTML 文档目录 | javadoc jar | HTML 数量 |
| --- | --- | --- | --- |
| docs-core | `docs-core/target/site/apidocs/` | `docs-core-1.12-SNAPSHOT-javadoc.jar`（1.5MB） | 460 |
| docs-web-common | `docs-web-common/target/site/apidocs/` | `docs-web-common-1.12-SNAPSHOT-javadoc.jar`（413KB） | 58 |
| docs-web | `docs-web/target/site/apidocs/` | `docs-web-1.12-SNAPSHOT-javadoc.jar`（433KB） | 61 |

### docs-core JavaDoc 覆盖的包（16 个）

`constant`、`dao`、`dao.criteria`、`dao.dto`、`event`、`listener.async`、`model.context`、`model.jpa`、`service`、`util`、`util.action`、`util.authentication`、`util.format`、`util.indexing`、`util.jpa`、`util.pdf`

### 关键类文档（举例）

- `DocumentDao`：`docs-core/target/site/apidocs/com/sismics/docs/core/dao/DocumentDao.html`
- `Document` 实体：`docs-core/target/site/apidocs/com/sismics/docs/core/model/jpa/Document.html`
- `DocumentResource`：`docs-web/target/site/apidocs/com/sismics/docs/rest/resource/DocumentResource.html`

## 五、验证结论

1. ✅ 正常 `mvn package` 构建会自动生成 JavaDoc（绑定 package 阶段）。
2. ✅ 三个模块均生成 `target/site/apidocs/` HTML 文档。
3. ✅ 三个模块均生成 `-javadoc.jar` 制品。
4. ✅ JavaDoc 内容完整（docs-core 覆盖 16 个包、460 个 HTML）。

## 六、遇到的问题

| 问题 | 解决 |
| --- | --- |
| Java 11 doclint 严格校验可能导致构建失败（Teedy 源码未写完整 Javadoc） | 配置 `<doclint>none</doclint>` + `<failOnError>false</failOnError>` |
| 构建日志中文乱码 | Windows 控制台 GBK 编码显示问题，实际生成的 HTML 文件为 UTF-8 编码、内容正常 |
