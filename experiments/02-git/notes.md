# 实验二 notes.md — 问题与解决

## 任务(3) 登录页 Logo 下加学号

### 本轮问题与解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 本地 `mvn: command not found` | Windows 原生环境未安装 Maven（历史实验在 WSL 完成） | 下载 Apache Maven 3.9.9 到 `D:\tools\apache-maven-3.9.9`，配置 MAVEN_HOME 与 PATH |
| 本地落后远程 2 个提交 | 换环境后本地停在 `60901b9f`，远程已推进到 `3a0f723e` | `git pull origin master`（fast-forward，无分叉） |

### 任务(3) 构建与验证记录

| 步骤 | 命令 | 结果 |
| --- | --- | --- |
| 后端构建 | `mvn clean -DskipTests install`（根目录） | BUILD SUCCESS，Docs Parent/Core/Web Commons/Web 四模块成功，6m50s |
| 前端依赖 | `npm install`（docs-web/src/main/webapp） | 285 包安装完成 |
| 前端构建 | `./node_modules/.bin/grunt`（默认任务） | Done，生成 dist/ |
| 启动服务 | `mvn jetty:run`（docs-web） | Jetty 监听 0.0.0.0:8080，上下文 /docs-web |
| 访问验证 | `http://localhost:8080/docs-web/dist/` | HTTP 200，dist/docs.min.js 含「学号：1260101027」 |

**验证结论**：学号 `1260101027` 已通过 Grunt `ngtemplates` 任务预编译进 `dist/docs.min.js` 的 Angular `$templateCache`，浏览器加载登录页时会在 Logo 下方渲染出学号。

**环境注意**：本次为 Windows 原生环境（非 WSL），Maven 3.9.9 + JDK 11。dev 模式登录页入口为 `/docs-web/dist/`（dist 目录），而非 README 历史记录的 `/docs-web/`（历史环境差异）。

**npm 锁文件**：`npm install` 触发 package-lock.json 的 lockfileVersion 格式变化，已 `git restore` 还原，不提交 npm 版本差异产生的无关变更。
