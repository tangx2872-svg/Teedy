# 实验九：Kubernetes 部署

## 状态

✅ 已完成（集群就绪，镜像构建 + Deployment + Service + 访问验证全部通过）

## 实验任务

1. 安装 minikube 和 kubectl
2. 创建本地 Kubernetes 集群
3. 使用已构建的 Teedy 镜像创建 Deployment
4. 创建 Service
5. 验证 Teedy 可以通过 Service 访问
6. 将 Kubernetes 部署步骤整合进 Jenkinsfile

## 交付物

| 文件 | 说明 |
| --- | --- |
| `k8s/teedy-deployment.yaml` | Deployment + Service 清单 |
| `notes.md` | 问题与解决 |
| `reports/` | 部署记录与验证结果 |
| `Jenkinsfile`（根目录） | 新增 K8s 部署 + 验证阶段 |

## 关键决策

1. **用 Docker Desktop 自带 K8s 替代 minikube**（用户确认）：kubectl v1.36.1
   已随 Docker Desktop 就绪，kind 单节点集群与 minikube 功能等价且更轻量。
2. **本地重建镜像**：GHCR 国内直连不稳定（`docker pull` 报 EOF），改用
   本地 `docker build`（`teedy:local`），走镜像加速源。

## 验证结果

部署全部成功，详见 `reports/deployment-report.md`：

- Deployment `teedy`：READY 1/1
- Service `teedy`：NodePort 8080→30080
- **Service 访问验证**：Pod 内 `http://teedy:8080/` → HTTP 200
