# 实验九：Kubernetes 部署

## 状态

✅ 已完成（集群就绪，镜像构建 + Deployment + Service + 访问验证全部通过）

## 实验目的

将 Teedy 部署到 Kubernetes：安装 kubectl、创建本地集群、用已构建镜像创建 Deployment 与 Service、验证通过 Service 访问，并将部署步骤整合进 Jenkinsfile。

## 实验原理

- **Kubernetes**：容器编排平台，核心抽象：
  - **Pod**：最小调度单元，封装一个或多个容器。
  - **Deployment**：声明式管理 Pod 副本数、滚动更新。
  - **Service**：为 Pod 提供稳定的集群内访问入口（ClusterIP / NodePort），通过 label selector 关联 Pod。
- **kind / minikube**：本地轻量 K8s 集群；Docker Desktop 自带单节点 kind 集群，功能等价且更轻量。

## 实验任务

1. 安装 minikube 和 kubectl ✅（用 Docker Desktop 自带 K8s 替代）
2. 创建本地 Kubernetes 集群 ✅
3. 使用已构建的 Teedy 镜像创建 Deployment ✅
4. 创建 Service ✅
5. 验证 Teedy 可以通过 Service 访问 ✅
6. 将 Kubernetes 部署步骤整合进 Jenkinsfile ✅

## 分步操作过程

### 1. 环境准备：Docker Desktop 自带 K8s

本机已装 Docker Desktop v4.100.0，自带 kubectl v1.36.1 和单节点 kind 集群，无需额外安装 minikube。

**环境修复（2026-11-23 从零搭建 Docker 环境时解决）**：

| 问题 | 解决方法 |
| --- | --- |
| WSL 服务被禁用（`0x80070422`） | 管理员 PowerShell：`sc.exe config WSLService start= auto; sc.exe start WSLService` |
| Docker Hub 拉镜像超时 | 配置 `registry-mirrors`：`docker.m.daocloud.io` / `docker.1ms.run` / `docker.xuanyuan.me` |
| 代理导致构建容器 SSL 失败 | Docker Desktop GUI 关闭代理（No proxy） |

### 2. 本地重建镜像（避开 GHCR 与代理问题）

GHCR 国内直连不稳定（`docker pull` 报 EOF），改用本地构建：

- 用 `Dockerfile.local`（直接 COPY 本地已构建 WAR，不容器内 npm+maven 构建）
- 从临时目录构建（绕过 `.dockerignore` 的 `**/target` 排除）

```bash
docker build -f Dockerfile.local -t teedy:local /tmp/teedy-k8s-build
```

构建耗时 < 1 分钟，镜像 1.09GB。

### 3. 编写 Deployment + Service 清单（k8s/teedy-deployment.yaml）

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: teedy
spec:
  replicas: 1
  selector:
    matchLabels: { app: teedy }
  template:
    metadata:
      labels: { app: teedy }
    spec:
      containers:
        - name: teedy
          image: teedy:local
          ports: [{ containerPort: 8080 }]
---
apiVersion: v1
kind: Service
metadata:
  name: teedy
spec:
  type: NodePort
  selector: { app: teedy }
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30080
```

### 4. 部署并验证

```bash
kubectl apply -f k8s/teedy-deployment.yaml
kubectl get deployments                # teedy READY 1/1
kubectl get pods                       # Pod Running
kubectl get svc teedy                  # NodePort 8080→30080
# 集群内访问验证（标准 Service 验证方式）
kubectl exec <pod> -- curl http://teedy:8080/   # HTTP 200
```

### 5. 整合进 Jenkinsfile

新增「部署到 Kubernetes」+「验证 Kubernetes 服务访问」阶段。

## 关键决策

1. **用 Docker Desktop 自带 K8s 替代 minikube**（用户确认）：kubectl v1.36.1 已就绪，kind 单节点与 minikube 功能等价且更轻量，走 Docker 已有镜像加速源。
2. **本地重建镜像**：GHCR 国内直连不稳定，改用本地 `docker build`（`teedy:local`），走镜像加速源。

## 镜像构建踩坑（关键）

本地 WSL2 + 代理环境下，实验八的多阶段 Dockerfile 反复失败：

| 问题 | 根因 |
| --- | --- |
| `npm: not found` | builder 阶段装 Node 静默失败 |
| Maven `go-offline` 超时 | 代理 SSL MITM 破坏构建容器外网访问 |
| apt-get 502 | 同上 |

**根因**：Docker Desktop 配置代理 `127.0.0.1:7890`，buildkit 构建容器访问外网被代理 SSL MITM 破坏（镜像拉取走加速源不受影响，但构建容器内访问外网被搞挂）。

**解决**：① 关闭 Docker 代理（必须 GUI 改，手动改 `settings-store.json` 会被覆盖）；② 改用极简 `Dockerfile.local`（COPY 本地 WAR），构建从 20+ 分钟缩短到 1 分钟内。

## 结果验证

部署全部成功：

- Deployment `teedy`：READY 1/1，镜像 `teedy:local`
- Service `teedy`：NodePort 8080→30080，endpoints 正确
- **Service 访问验证**：Pod 内 `http://teedy:8080/` → HTTP 200
- Jetty 日志确认：`Started ServerConnector ... 0.0.0.0:8080`，数据库升级完成，WebApp `Teedy` 部署成功

## NodePort 宿主机直连限制

Docker Desktop 的 kind 集群（v4.100 起）NodePort 不会自动映射到宿主机 localhost（与 minikube 不同）。Service 访问验证通过**集群内访问 ClusterIP** 完成（`kubectl exec` 进 Pod curl `http://teedy:8080/` 返回 200），这是最标准的 Service 验证方式。如需宿主机访问，用 `kubectl port-forward service/teedy 30080:8080`。

## 交付物

| 文件 | 说明 |
| --- | --- |
| `k8s/teedy-deployment.yaml` | Deployment + Service 清单 |
| `Dockerfile.local` | 本地 COPY WAR 的极简构建 |
| `notes.md` | 问题与解决 |
| `reports/deployment-report.md` | 部署记录与验证结果 |
| `Jenkinsfile`（根目录） | 新增 K8s 部署 + 验证阶段 |
