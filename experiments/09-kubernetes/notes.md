# 实验九：Kubernetes 部署 — 问题与解决

## 一、任务清单

1. 安装 minikube 和 kubectl
2. 创建本地 Kubernetes 集群
3. 使用已构建的 Teedy 镜像创建 Deployment
4. 创建 Service
5. 验证 Teedy 可以通过 Service 访问
6. 将 Kubernetes 部署步骤整合进 Jenkinsfile

## 二、关键决策

### 决策 1：用 Docker Desktop 自带 K8s 替代 minikube（用户确认）

实验要求"安装 minikube 和 kubectl"。但本机已装 Docker Desktop v4.100.0，
自带 kubectl v1.36.1 和单节点 kind 集群。经用户确认，采用 Docker Desktop
自带 K8s（kind 单节点），理由：

- kubectl 已就绪（无需额外安装）
- kind 单节点集群与 minikube 功能等价，更轻量
- 走 Docker 已有的镜像加速源，避免 minikube 在 Windows+代理环境的镜像拉取问题

### 决策 2：本地重新构建镜像，而非从 GHCR 拉取

实验八已将镜像推到 GHCR（`ghcr.io/tangx2872-svg/teedy:latest`），但：
- GHCR 国内直连不稳定（`docker pull` 报 `EOF` 错误）
- GHCR 无国内加速源

因此实验九改用**本地重新构建**镜像（`teedy:local`），用实验八的多阶段
Dockerfile，走镜像加速源（DaoCloud 等）构建，更可靠。

## 三、环境修复记录（2026-11-23）

实验九开始前，本机 Docker 环境从零搭建，遇到并解决了以下问题：

1. **WSL 服务被禁用**（`WSLService` Disabled，报错 `0x80070422`）
   → 管理员 PowerShell：`sc.exe config WSLService start= auto; sc.exe start WSLService`
2. **Docker Hub 拉镜像超时**（`auth.docker.io` 走代理不稳定）
   → 配置 `registry-mirrors`（`C:\Users\Lenovo\.docker\daemon.json`）：
     `docker.m.daocloud.io` / `docker.1ms.run` / `docker.xuanyuan.me`
3. **代理配置**（`settings-store.json`）：
   `OverrideProxyHTTP/HTTPS = http://127.0.0.1:7890`

详见 `experiments/ENVIRONMENT.md`。

## 四、集群信息

- 类型：kind（Docker Desktop 托管），单节点
- 节点：`desktop-control-plane`，v1.36.1，containerd 2.3.1
- kubectl 上下文：`docker-desktop`

## 五、验证结果

### 集群与部署

- 节点 `desktop-control-plane`：Ready，v1.36.1，containerd 2.3.1
- Deployment `teedy`：READY 1/1，镜像 `teedy:local`
- Service `teedy`：NodePort 8080→30080，endpoints 正确
- **Service 访问验证**：Pod 内 `http://teedy:8080/` → HTTP 200

### Teedy 应用在 K8s 中完整启动

Jetty 日志确认：`Started ServerConnector ... 0.0.0.0:8080`，数据库升级完成，
WebApp `Teedy` 部署成功。

## 六、镜像构建踩坑（关键）

### 问题：本地 WSL2 + 代理环境下多阶段构建反复失败

实验八的 Dockerfile 在 CI（GitHub Actions ubuntu）能成功，但本地构建反复失败：

1. **`npm: not found`**：builder 阶段安装 Node.js（`curl nodesource | bash`）
   静默失败，导致 npm 未装上。
2. **Maven `go-offline` 超时**：`Connect to repo.maven.apache.org:443 ... Read timed out`。
3. **apt-get 502**：`security.ubuntu.com ... 502 Bad Gateway`。

### 根因

Docker Desktop 配置了代理 `127.0.0.1:7890`（FlClash），导致 buildkit 构建容器
访问外网（nodesource / maven central / ubuntu 源）时被代理 SSL MITM 破坏，
表现为 SSL 握手失败 / 连接超时 / 502。

镜像拉取不受影响（走 `registry-mirrors` 国内加速源直连），但**构建容器内的
外网访问**被代理搞挂。

### 解决

1. **关闭 Docker 代理**：Docker Desktop GUI → Settings → Resources → Proxies →
   No proxy（注意：手动改 `settings-store.json` 会被运行中的 Docker Desktop
   覆盖，必须通过 GUI 改）。
2. **改用极简 Dockerfile**（`Dockerfile.local`）：不再容器内 npm install +
   maven 构建，直接 COPY 本地已构建的 WAR（`docs-web/target/*.war`），
   构建从 20+ 分钟缩短到 1 分钟内。
   - 注意：`.dockerignore` 的 `**/target` 会排除 WAR，需从独立临时目录构建。

### 最终方案

- 用 `Dockerfile.local`（COPY 本地 WAR）从临时目录构建 `teedy:local`
- 构建耗时 < 1 分钟，镜像 1.09GB
- 本地 `docker run` 验证 + K8s 部署均成功

## 七、NodePort 宿主机直连限制

Docker Desktop 的 kind 集群（v4.100 起）NodePort 不会自动映射到宿主机
localhost（与 minikube 不同）。Service 访问验证通过**集群内访问 ClusterIP**
完成（`kubectl exec` 进 Pod curl `http://teedy:8080/` 返回 200），这是最标准
的 Service 验证方式。如需宿主机访问，用 `kubectl port-forward service/teedy 30080:8080`。
