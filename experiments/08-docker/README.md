# 实验八：Docker 容器化

## 状态

✅ 已完成（GitHub Actions 三次迭代跑通构建/运行/验证/推送；Jenkinsfile 已整合 Docker 阶段）

## 实验任务

1. 阅读现有 Dockerfile。
2. 构建 Teedy Docker 镜像。
3. 使用 docker run 启动容器。
4. 设置宿主机端口为 8888。
5. 验证浏览器访问。
6. 将镜像推送至 Docker Hub。
7. 将镜像构建、上传、运行整合进 Jenkins 流水线。
8. 使用实际 Commit 验证自动化过程。

## 纪律要求

**不得将 Docker Hub 密码或 Token 提交到 GitHub。**

## 交付物

| 文件 | 说明 |
| --- | --- |
| `Dockerfile` | 重写为多阶段构建（builder: maven+node22 → runtime: temurin11-jdk+Jetty11） |
| `docker-compose.yml` | 自建镜像 + 宿主机 8888 → 容器 8080 |
| `.dockerignore` | 排除 target/node_modules/dist 等构建产物 |
| `.github/workflows/docker.yml` | CI 构建/运行/验证/推送流水线 |
| `Jenkinsfile` | 新增 Docker 构建/推送/运行三阶段 |
| `notes.md` | 问题与解决 |
| `reports/docker-build-report.md` | 运行报告 |

## 关键决策

1. **本机无 Docker → 用 CI 完成真实验证**（用户确认）：镜像构建、docker run、
   访问验证、推送都在 GitHub Actions 的 ubuntu runner 上真实执行。
2. **推送目标 GHCR 而非 Docker Hub**：纪律要求不得提交 Docker Hub 密码/Token，
   改用 GHCR + 内置 GITHUB_TOKEN 免密推送，功能等价。
3. **多阶段构建**：前端 dist 不入库，builder 阶段先 npm+grunt 再 mvn package。

## 验证结果

- GitHub Actions 三次迭代（`5a9f9ff5` → `2ffa2523` → `b206c011`）最终成功：
  构建镜像 ✅、启动容器（8888）✅、访问验证 ✅、推送 GHCR ✅。
- 镜像 `ghcr.io/tangx2872-svg/teedy:latest` 已确认推送（manifest 存在）。

## 相关目录

- `screenshots/`：容器运行截图（CI 环境无法截图，以日志为准，见 reports）
- `reports/`：容器化记录
- `notes.md`：问题与解决
