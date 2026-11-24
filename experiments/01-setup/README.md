# 实验一：Teedy 安装与运行

## 实验目的

掌握开源项目的 Fork、Clone、依赖安装、构建与本地运行流程，通过浏览器访问并登录 Teedy 文档管理系统，理解一个真实 Java Web 项目的完整启动链路。

## 实验原理

Teedy 是一个 **Java EE 多模块 Maven 项目**，采用「后端 Spring/Hibernate + 内嵌 Jetty 容器 + 前端 AngularJS（Grunt 构建）」的架构：

- **后端**：`docs-core`（核心业务 + DAO）、`docs-web-common`（Web 公共层）、`docs-web`（REST 资源层 + Web 入口）三个 Maven 模块，父 POM 为 `docs-parent`。
- **前端**：`docs-web/src/main/webapp` 下的 AngularJS 单页应用，由 `npm install` 安装依赖、`grunt` 编译打包到 `dist/` 目录。
- **运行方式**：`mvn jetty:run` 启动内嵌 Jetty，监听 `8080` 端口，前端入口在 `/docs-web/dist/`。

因此「安装与运行」的完整链路是：**Clone 源码 → 安装 JDK/Maven → 后端 `mvn install` → 前端 `npm install` + `grunt` → `mvn jetty:run` 启动 → 浏览器访问**。

## 分步操作过程

### 1. Fork 并 Clone 项目

1. 在 GitHub 上 Fork 上游仓库 `sustech-cs304/Teedy` 到个人账号 `tangx2872-svg`。
2. Clone 到本地（Windows 原生环境，仓库路径 `D:\Research\Teedy`）：

```bash
git clone https://github.com/tangx2872-svg/Teedy.git
```

### 2. 安装依赖（JDK 11 + Maven）

- JDK：`JDK 11`（项目 `pom.xml` 声明的编译目标）。
- Maven：Windows 原生环境未预装，下载 Apache Maven 3.9.9 到 `D:\tools\apache-maven-3.9.9`，配置 `MAVEN_HOME` 与 `PATH` 环境变量。

### 3. 后端构建

在项目根目录执行（跳过测试以加快首轮构建）：

```bash
mvn clean -DskipTests install
```

结果：`BUILD SUCCESS`，`docs-parent` / `docs-core` / `docs-web-common` / `docs-web` 四模块全部构建成功（约 6m50s）。

### 4. 前端依赖安装与构建

```bash
cd docs-web/src/main/webapp
npm install                                  # 安装 285 个前端依赖包
./node_modules/.bin/grunt                    # 默认任务，编译生成 dist/
```

### 5. 启动服务

```bash
cd ../..                                    # 回到 docs-web 模块
mvn jetty:run
```

Jetty 监听 `0.0.0.0:8080`，上下文路径为 `/docs-web`。

### 6. 浏览器访问验证

访问 `http://localhost:8080/docs-web/dist/`，返回 **HTTP 200**，登录页正常渲染，可完成登录并体验基本功能。

## 结果验证

| 步骤 | 命令 | 结果 |
| --- | --- | --- |
| 后端构建 | `mvn clean -DskipTests install` | ✅ BUILD SUCCESS，四模块成功 |
| 前端依赖 | `npm install` | ✅ 285 包安装完成 |
| 前端构建 | `./node_modules/.bin/grunt` | ✅ 生成 dist/ |
| 启动服务 | `mvn jetty:run` | ✅ Jetty 监听 8080 |
| 访问验证 | 浏览器打开登录页 | ✅ HTTP 200，登录页正常 |

## 关键结论与说明

- Web 服务启动完成，浏览器能正常打开 Teedy 页面。
- 登录、上传、检索等操作当时未留存完整证据，未写成"已验证通过"（详见根目录 README 说明）。
- **环境注意**：dev 模式登录页入口为 `/docs-web/dist/`（dist 目录），与历史 WSL 环境的 `/docs-web/` 存在差异，属环境差异而非错误。

## 相关文件

- 根目录 `README.md`：实验一完整记录（含三张 Mermaid 图与两张真实运行图片）。
- `docs/images/`：实验一真实运行截图。
