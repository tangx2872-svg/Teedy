# 实验八 Docker 容器化运行报告

## 概览

| 项 | 值 |
| --- | --- |
| 构建方式 | 多阶段 Dockerfile（builder: maven+node22 → runtime: temurin11-jdk+Jetty11） |
| 镜像名 | `ghcr.io/tangx2872-svg/teedy` |
| 宿主机端口 | 8888（→ 容器内 Jetty 8080） |
| 验证平台 | GitHub Actions `ubuntu-latest`（本机无 Docker，用 CI 完成真实验证） |

## GitHub Actions 运行记录（三次迭代，最终成功）

### Run 1 — `5a9f9ff5`（初始 Dockerfile）· 结论：failure

| 步骤 | 结果 |
| --- | --- |
| 检出 / Buildx / 登录 GHCR / 元数据 | ✅ success |
| 构建 Docker 镜像 | ❌ failure |
| 启动容器 / 验证 / 推送 | ⏭️ skipped |

**根因**：runtime 阶段用 `eclipse-temurin:11-jre`，Jetty 11 的
`start.jar --add-modules` 需要 **JDK**（非 JRE）初始化模块，报 `exit code: 1`。
同时 `WORKDIR /opt/jetty` 把 home 当 base 用，不符合 Jetty home/base 分离设计。

### Run 2 — `2ffa2523`（JRE→JDK + home/base 分离）· 结论：failure

| 步骤 | 结果 |
| --- | --- |
| 构建 Docker 镜像 | ✅ success |
| 启动容器（端口 8888） | ❌ failure（`docker run` exit 125） |
| 验证 / 推送 | ⏭️ skipped |

**根因**：`IMAGE_NAME = ${{ github.repository }}`（含大写 `Teedy`），GHCR 要求
镜像名小写，导致 docker run 引用镜像时 exit 125（daemon 错误）。

### Run 3 — `b206c011`（镜像名小写化）· 结论：**success** ✅

| 步骤 | 结果 |
| --- | --- |
| 构建 Docker 镜像 | ✅ success |
| 启动容器（端口 8888） | ✅ success |
| 验证容器可访问（端口 8888） | ✅ success |
| 推送镜像至 GHCR | ✅ success |

**总耗时**：1m 3s（镜像层已缓存）。

## 任务对照

| 实验任务 | 完成情况 |
| --- | --- |
| 1. 阅读现有 Dockerfile | ✅ 已读（原单阶段 ubuntu+Jetty，EXPOSE 8080） |
| 2. 构建 Teedy Docker 镜像 | ✅ CI 多阶段构建成功 |
| 3. docker run 启动容器 | ✅ `docker run -d -p 8888:8080` 成功 |
| 4. 设置宿主机端口 8888 | ✅ compose `8888:8080` + CI `-p 8888:8080` |
| 5. 验证浏览器访问 | ✅ CI 中 curl 探测 8888 端口成功 |
| 6. 推送镜像 | ✅ 推送至 GHCR（`ghcr.io/tangx2872-svg/teedy:latest`，manifest 已确认） |
| 7. Jenkins 流水线整合 | ✅ Jenkinsfile 新增构建/推送/运行三阶段 |
| 8. 实际 Commit 验证 | ✅ 三次 commit 迭代，最终 CI 全绿 |

## 镜像验证证据

通过 GHCR registry API（匿名 token）确认 `ghcr.io/tangx2872-svg/teedy:latest`
manifest 存在，返回 OCI index，含多平台 `architecture`/`os` 信息。

> 注：任务 6 原要求「推送至 Docker Hub」，因纪律要求不得提交 Docker Hub 密码/Token，
> 改用 GHCR（GitHub Container Registry）+ 内置 GITHUB_TOKEN 免密推送，功能等价。

## 结论

- Docker 多阶段构建镜像、运行容器（8888 端口）、访问验证、推送 GHCR 已**真实跑通**。
- 全程未提交任何密码/Token，符合纪律要求。
- 三次迭代解决两类「本地无 Docker 无法预演」的云端问题：Jetty JRE/JDK 差异、
  GHCR 镜像名大小写。
