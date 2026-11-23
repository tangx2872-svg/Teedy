# 实验九：Kubernetes 部署报告

## 部署概览

| 项目 | 值 |
| --- | --- |
| 集群类型 | Docker Desktop 内置 kind（单节点） |
| Kubernetes 版本 | v1.36.1 |
| 节点 | `desktop-control-plane`（control-plane，Ready） |
| 容器运行时 | containerd 2.3.1 |
| 镜像 | `teedy:local`（本地构建，1.09GB） |
| Deployment | `teedy`（replicas=1，READY 1/1） |
| Service | `teedy`（NodePort，8080→30080） |
| 访问验证 | Pod 内 `http://teedy:8080/` → HTTP 200 |

## 六项任务完成情况

1. ✅ **安装 kubectl**：v1.36.1（Docker Desktop 自带，无需另装 minikube，见下方决策）
2. ✅ **创建本地集群**：Docker Desktop kind 单节点集群（`Cluster: Active`）
3. ✅ **创建 Deployment**：`k8s/teedy-deployment.yaml`，镜像 `teedy:local`
4. ✅ **创建 Service**：NodePort 类型，selector `app=teedy`
5. ✅ **验证 Service 访问**：Pod 内访问 ClusterIP 返回 HTTP 200
6. ✅ **Jenkinsfile 整合**：新增「部署到 Kubernetes」+「验证 Kubernetes 服务访问」阶段

## 部署命令

```bash
# 应用部署清单
kubectl apply -f experiments/09-kubernetes/k8s/teedy-deployment.yaml

# 查看状态
kubectl get deployment teedy
kubectl get pods -l app=teedy
kubectl get svc teedy

# 验证 Service 访问（Pod 内）
kubectl exec <pod> -- curl -s -o /dev/null -w '%{http_code}' http://teedy:8080/
```

## 验证结果（真实输出）

### Pod 状态
```
NAME                     READY   STATUS    RESTARTS   AGE
teedy-84cd9696f8-p7whj   1/1     Running   0          55s
```

### Service
```
NAME    TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
teedy   NodePort   10.96.48.245   <none>        8080:30080/TCP   2m34s
```

### Service 访问验证（Pod 内 curl ClusterIP）
```
HTTP 200
```

### Teedy 应用日志（Jetty 启动成功）
```
Started ServerConnector@...{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
Started Server@...{STARTING}[11.0.20,sto=5000]
```

## 关键决策与踩坑记录

详见 `notes.md`，核心几点：

1. **Docker Desktop 自带 K8s 替代 minikube**（用户确认）
2. **本地重建镜像**（GHCR 直连不稳定）
3. **镜像构建方案演变**：多阶段构建（容器内 npm/maven）→ 因代理 SSL MITM
   失败 → 改用「COPY 本地已构建 WAR」的极简 Dockerfile，1 分钟完成构建
4. **Docker 代理是罪魁祸首**：`127.0.0.1:7890` 代理导致容器内访问外网
   （nodesource/maven central）SSL 握手失败/超时，通过 GUI 关闭代理解决
5. **NodePort 宿主机直连限制**：Docker Desktop kind 集群的 NodePort 不会
   自动映射到宿主机 localhost（与 minikube 不同），需 `port-forward` 或
   从集群内访问验证 Service
