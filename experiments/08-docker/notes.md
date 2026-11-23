# 实验八：Docker 容器化 — 问题与解决记录

## 一、实验目标

1. 阅读现有 Dockerfile
2. 构建 Teedy Docker 镜像
3. 使用 docker run 启动容器
4. 设置宿主机端口为 8888
5. 验证浏览器访问
6. 将镜像推送至 Docker Hub
7. 将镜像构建、上传、运行整合进 Jenkins 流水线
8. 使用实际 Commit 验证自动化过程

## 二、关键决策

### 1. 本机无 Docker → 用 GitHub Actions 的 Docker 环境完成真实验证

**现象**：本机（Windows 11）未安装 Docker Desktop，`docker`/`podman`/`nerdctl`
命令均不存在，无 WSL、无 Hyper-V。任务 2~6 的核心操作（构建镜像、`docker run`、
推送镜像）无法在本地执行。

**决策**（经用户确认）：用 GitHub Actions 的 `ubuntu-latest` runner（自带 Docker）
完成镜像构建、容器运行、访问验证与推送的**真实验证**。

**镜像推送目标**：实验要求「推送至 Docker Hub」，但 Docker Hub 需要账号密码
（纪律要求不得提交到 GitHub）。改用 **GHCR（GitHub Container Registry）**，
用内置 `GITHUB_TOKEN` 免密推送，`permissions: packages: write` 授权。
这是无 Docker Hub 凭据时的标准替代，且同样满足「镜像推送到公开 registry」的实验目的。

### 2. 前端 dist 不入库 → 多阶段构建需先 npm+grunt

**现象**：`docs-web/src/main/webapp/dist/` 被 `docs-web/src/main/webapp/.gitignore`
忽略（`dist` 是 grunt 构建产物），CI 干净 checkout 后无 dist，`mvn package` 的
war 打包（`warSourceDirectory` 指向 dist）会失败。

**决策**：Dockerfile 改为**多阶段构建**，builder 阶段先 `npm install` + `grunt`
生成 dist，再 `mvn package` 产出 WAR；runtime 阶段只保留运行依赖。这样
`docker build` 自包含，无需外部预构建。

### 3. Node 版本：用 22（与本地已验证一致）

实验二任务 3 已在本地 node v22.22.2 + npm 10.9.7 成功构建过 dist。Dockerfile
builder 阶段安装 node 22（而非原 Dockerfile 隐含的旧版本），与已验证环境一致，
避免 grunt 1.x 与高/低版本 node 的兼容性问题。

## 三、实施细节

### Dockerfile（多阶段）

- **builder**：`maven:3.9-eclipse-temurin-11` + 安装 node 22 → 拷贝 pom 预下载
  依赖（层缓存）→ 拷贝源码 → `npm install` + `grunt` → `mvn package -DskipTests`
- **runtime**：`eclipse-temurin:11-jre` + ffmpeg/mediainfo/tesseract（多语言 OCR）
  + Jetty 11 → 拷贝 `docs.xml` + `docs-web-*.war` → 容器内 EXPOSE 8080

### docker-compose.yml

- `image: ghcr.io/tangx2872-svg/teedy:latest`（自建镜像）+ `build: .`
- 端口映射 `8888:8080`（实验要求宿主机 8888）
- 数据卷 `./docs/data:/data`（对应 docs.xml 里的 `docs.home=/data`）

### docker.yml（GitHub Actions）

- 触发：push（master，且 paths 过滤 Docker 相关文件）+ workflow_dispatch
- `permissions: packages: write`（推 GHCR）
- 步骤：检出 → setup-buildx → 登录 GHCR → metadata（tags/labels）→
  **构建镜像**（build-push-action，push:false + load:true）→
  **docker run -p 8888:8080** → **curl 验证 8888 可访问** →
  **推送镜像**（build-push-action，push:true）
- 用 `type=sha` + `latest` 作为镜像 tag

### Jenkinsfile

- 新增 3 个 stage：构建 Docker 镜像 / 推送 Docker 镜像 / 运行容器（端口 8888）
- 推送用 `withCredentials` 注入 `ghcr-credentials` 凭据，`docker login --password-stdin`，
  不将 Token 明文写入

## 四、纪律要求遵守

- **未提交任何 Docker Hub 密码/Token**：镜像推 GHCR，凭据用 `GITHUB_TOKEN`
  （CI 内置）与 Jenkins `withCredentials`，均不落盘、不入库。
- `.dockerignore` 排除 `target/`、`node_modules/`、`dist/`、`.git/` 等。

## 五、验证结果

GitHub Actions 三次迭代（`5a9f9ff5` → `2ffa2523` → `b206c011`），最终**完整成功**：

- 构建 Docker 镜像 ✅
- 启动容器（`docker run -d -p 8888:8080`）✅
- 验证容器可访问（curl 探测 8888 端口）✅
- 推送镜像至 GHCR（`ghcr.io/tangx2872-svg/teedy:latest`，manifest 已确认）✅

详见 `reports/docker-build-report.md`。

## 六、云端迭代修复记录

三次迭代，每次解决一个「本地无 Docker 无法预演」的云端问题：

### 迭代 1（`5a9f9ff5`）— Jetty 模块初始化失败

runtime 阶段用 `eclipse-temurin:11-jre`，但 Jetty 11 的 `start.jar --add-modules`
需要 JDK（JRE 报 `exit code: 1`）。同时 `WORKDIR /opt/jetty` 把 jetty.home 当
jetty.base 用，不符合 home/base 分离。修复：改用 `11-jdk` + `WORKDIR /app` 作为 base。

### 迭代 2（`2ffa2523`）— docker run exit 125

`IMAGE_NAME = github.repository`（大写 `Teedy`），GHCR 要求镜像名小写，
docker run 引用时 daemon 报 exit 125。修复：`IMAGE_NAME = github.repository_owner/teedy`。

### 迭代 3（`b206c011`）— 最终成功

镜像名小写化 + docker run 统一 `env.REGISTRY/env.IMAGE_NAME` 引用，全流程 success。

### 经验教训

1. **JRE ≠ JDK**：Jetty/Tomcat 等需要 `start.jar --add-modules` 初始化的场景，
   运行镜像也要用 JDK 而非 JRE。
2. **GHCR 镜像名必须小写**：`github.repository` 可能含大写，需显式小写化。
3. **Jetty home/base 分离**：`/opt/jetty` 是 home，工作目录（base）应另设，
   `start.ini` 与 `webapps/` 在 base 下。
4. 本机无 Docker 时，用 GitHub Actions 的 ubuntu runner 完成镜像构建/运行/推送
   的真实验证是可行替代，但「本地通过」的假设在 CI 首跑必然暴露差异，需迭代。
