# 实验八：Docker 容器化

## 状态

✅ 已完成（GitHub Actions 三次迭代跑通构建/运行/验证/推送；Jenkinsfile 已整合 Docker 阶段）

## 实验目的

将 Teedy 容器化：阅读现有 Dockerfile、构建镜像、`docker run` 启动容器、设置宿主机端口 8888、验证浏览器访问、推送镜像，并将镜像构建/上传/运行整合进 Jenkins 流水线。

## 实验原理

- **Docker 镜像**：分层文件系统，包含运行应用所需的完整环境（OS、JDK、Jetty、依赖、应用 WAR）。
- **多阶段构建（multi-stage build）**：builder 阶段完成编译打包（体积大、含工具链），runtime 阶段只拷贝运行所需产物（体积小、更安全），两者共享同一 Dockerfile。
- **容器化关键**：前端 `dist/` 是 grunt 构建产物、不入库，因此必须在 builder 阶段先 `npm install` + `grunt` 再 `mvn package`。

## 实验任务

1. 阅读现有 Dockerfile。 ✅
2. 构建 Teedy Docker 镜像。 ✅
3. 使用 docker run 启动容器。 ✅
4. 设置宿主机端口为 8888。 ✅
5. 验证浏览器访问。 ✅
6. 将镜像推送至 Docker Hub。 ✅（改用 GHCR）
7. 将镜像构建、上传、运行整合进 Jenkins 流水线。 ✅
8. 使用实际 Commit 验证自动化过程。 ✅

## 分步操作过程

### 1. 重写 Dockerfile 为多阶段构建

- **builder**：`maven:3.9-eclipse-temurin-11` + 安装 node 22 → 拷贝 pom 预下载依赖（层缓存）→ 拷贝源码 → `npm install` + `grunt` → `mvn package -DskipTests`
- **runtime**：`eclipse-temurin:11-jdk` + ffmpeg/mediainfo/tesseract（多语言 OCR）+ Jetty 11 → 拷贝 `docs.xml` + `docs-web-*.war` → EXPOSE 8080

### 2. 编写 docker-compose.yml

```yaml
services:
  teedy:
    image: ghcr.io/tangx2872-svg/teedy:latest
    build: .
    ports:
      - "8888:8080"          # 宿主机 8888 → 容器 8080
    volumes:
      - ./docs/data:/data     # 对应 docs.xml 的 docs.home=/data
```

### 3. 编写 docker.yml（GitHub Actions）

- 触发：push（master，paths 过滤 Docker 相关文件）+ workflow_dispatch
- `permissions: packages: write`（推 GHCR）
- 步骤：检出 → setup-buildx → 登录 GHCR → metadata → **构建镜像**（push:false + load:true）→ **docker run -p 8888:8080** → **curl 验证** → **推送镜像**（push:true）
- tag：`type=sha` + `latest`

### 4. 整合进 Jenkinsfile

新增 3 个 stage：构建 Docker 镜像 / 推送 Docker 镜像 / 运行容器（端口 8888），推送用 `withCredentials` 注入凭据、`docker login --password-stdin`，不将 Token 明文写入。

## 关键决策

1. **本机无 Docker → 用 CI 完成真实验证**（用户确认）：镜像构建、docker run、访问验证、推送都在 GitHub Actions 的 ubuntu runner 上真实执行。
2. **推送目标 GHCR 而非 Docker Hub**：纪律要求不得提交 Docker Hub 密码/Token，改用 GHCR + 内置 GITHUB_TOKEN 免密推送，功能等价。
3. **多阶段构建**：前端 dist 不入库，builder 阶段先 npm+grunt 再 mvn package。
4. **Node 用 22**：与本地已验证的 node v22.22.2 + npm 10.9.7 一致，避免 grunt 1.x 兼容问题。

## 云端迭代修复记录（三次）

| 迭代 | 提交 | 问题 | 修复 |
| --- | --- | --- | --- |
| 1 | `5a9f9ff5` | Jetty `start.jar --add-modules` 需要 JDK（JRE 报 exit 1）；WORKDIR 把 jetty.home 当 base | 改用 `11-jdk` + `WORKDIR /app` 作 base |
| 2 | `2ffa2523` | docker run exit 125（GHCR 要求镜像名小写） | `IMAGE_NAME = github.repository_owner/teedy` |
| 3 | `b206c011` | 最终成功 | 镜像名小写化 + 统一引用 |

## 结果验证

GitHub Actions 三次迭代最终完整成功：

- 构建 Docker 镜像 ✅
- 启动容器（`docker run -d -p 8888:8080`）✅
- 验证容器可访问（curl 探测 8888）✅
- 推送镜像至 GHCR（`ghcr.io/tangx2872-svg/teedy:latest`，manifest 已确认）✅

## 经验教训

1. **JRE ≠ JDK**：Jetty/Tomcat 等需 `start.jar --add-modules` 初始化的场景，运行镜像也要用 JDK。
2. **GHCR 镜像名必须小写**：`github.repository` 可能含大写，需显式小写化。
3. **Jetty home/base 分离**：`/opt/jetty` 是 home，工作目录（base）应另设。
4. 本机无 Docker 时，用 GitHub Actions 的 ubuntu runner 完成真实验证是可行替代，但「本地通过」假设在 CI 首跑必然暴露差异，需迭代。

## 纪律要求

**未提交任何 Docker Hub 密码/Token**：镜像推 GHCR，凭据用 `GITHUB_TOKEN`（CI 内置）与 Jenkins `withCredentials`，均不落盘、不入库；`.dockerignore` 排除 `target/`、`node_modules/`、`dist/`、`.git/`。

## 交付物

| 文件 | 说明 |
| --- | --- |
| `Dockerfile` | 多阶段构建（builder: maven+node22 → runtime: temurin11-jdk+Jetty11） |
| `docker-compose.yml` | 宿主机 8888 → 容器 8080 |
| `.dockerignore` | 排除构建产物 |
| `.github/workflows/docker.yml` | CI 构建/运行/验证/推送 |
| `Jenkinsfile` | 新增 Docker 构建/推送/运行三阶段 |
| `notes.md` | 问题与解决 |
| `reports/docker-build-report.md` | 运行报告 |

## 相关目录

- `screenshots/`：容器运行截图（CI 环境无法截图，以日志为准，见 reports）
- `reports/`：容器化记录
- `notes.md`：问题与解决
