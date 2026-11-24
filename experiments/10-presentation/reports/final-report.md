# 《智能软件工程》Teedy 项目实验汇报

> 课程：研究生《智能软件工程》
> 基础项目：Teedy（开源文档管理系统）
> 个人仓库：https://github.com/tangx2872-svg/Teedy
> 学号：1260101027　姓名：汤鑫
> 汇报日期：2026-11-24

---

## 一、项目介绍

**Teedy** 是一款开源的企业级文档管理系统（Document Management System，DMS），采用 Java 编写，基于标准的 Java EE / Maven 技术栈。它提供了文档上传、OCR 识别、全文检索、标签分类、权限控制、工作流审批、多用户协作等完整的文档全生命周期管理能力，是一套结构清晰、模块化良好、适合作为软件工程实践教学载体的真实开源项目。

本课程围绕 Teedy 展开，依次完成从「环境搭建 → 版本控制 → 需求与 Scrum → 架构分析 → 构建与文档 → 测试与覆盖率 → CI/CD → 容器化 → 编排部署」九个递进式实验，完整走通了现代软件工程从开发到交付部署的全流程。

| 项目要素 | 内容 |
| --- | --- |
| 上游仓库 | https://github.com/sustech-cs304/Teedy |
| 个人仓库 | https://github.com/tangx2872-svg/Teedy（master 分支） |
| 技术栈 | Java 11 · Maven · Spring · Hibernate · Jetty · PostgreSQL · Elasticsearch |
| 模块结构 | 多模块 Maven 工程（core / web / 等） |

---

## 二、实验一：安装与运行

**目标**：Fork/Clone 项目，完成本地构建，启动服务并登录验证。

**成果**：
- Fork 上游仓库并 Clone 到本地（Windows 原生环境）。
- 配置 JDK 11 与 Maven，完成全量构建。
- 启动 Jetty 内嵌服务，访问登录页成功登录，验证系统可用。

**关键记录**：有效提交 `60901b9f`，完善实验一 README 并附运行截图。

---

## 三、实验二：Git 版本控制

**目标**：掌握 Git 分支、提交、推送等基本操作，并完成个性化改动。

**成果**：
1. 查看并理解项目提交历史。
2. 在 README 中添加学号并推送（提交 `fbd27450`）。
3. 在登录页 Logo 下方添加学号显示（提交 `7b18e3a4`）。
4. 记录完整 Git 操作流程（提交 `3a0f723e`）。

**关键记录**：远程切换到 HTTPS 地址；Git 身份使用 GitHub noreply 邮箱保护隐私（`GH007` 问题已处理并归档于 `docs/experiment-02-git.md`）。

---

## 四、实验三：软件需求与 Scrum

**目标**：运用 Scrum 敏捷方法对 Teedy 进行需求分析。

**成果**：
- 编写用户故事与需求分析文档。
- 在 GitHub Projects 中搭建 Scrum 看板（projects/4，共 22 张卡片），组织 Backlog / Sprint 迭代管理。

**关键记录**：看板卡片完整，涵盖功能需求、缺陷与改进项。

---

## 五、实验四：软件架构与 UML

**目标**：分析 Teedy 的模块结构与 Java 包结构，绘制 UML 图。

**成果**：
- 梳理 Teedy 多模块 Maven 结构及核心 Java 包职责。
- 使用 PlantUML 绘制 4 张 UML 图（含包图、类图、类关系等），并产出架构分析报告。

**关键记录**：架构报告与 UML 图归档于 `experiments/04-architecture-uml/`。

---

## 六、实验五：Maven 与 JavaDoc

**目标**：理解 Maven 构建生命周期，实现 JavaDoc 自动生成。

**成果**：
- 阅读根目录及三个子模块的 `pom.xml`，理清模块依赖与构建顺序。
- 理解 Maven 构建生命周期（compile → test → package → install → deploy）。
- 将 JavaDoc 插件绑定到 `package` 阶段，实现文档自动生成。

**关键记录**：有效提交 `e2ccd90e`。

---

## 七、实验六：软件测试与覆盖率

**目标**：运行测试、理解测试命令，并通过 JaCoCo 提升覆盖率。

**成果**：
1. 运行全部测试：23 个测试，20 通过、3 失败（上游基线失败，如实记录）。
2. 验证运行指定测试（`-Dtest`）与跳过测试（`-DskipTests`）的用法。
3. 引入 JaCoCo 覆盖率统计，针对 `LocaleUtil` 编写测试，使其覆盖率由 0% 提升至 91.7%，总体行覆盖率达 24.8%。

**关键记录**：有效提交 `e42b4835`。

---

## 八、实验七：CI/CD

**目标**：为项目搭建持续集成/持续交付流水线。

**成果**：
- **GitHub Actions**（`.github/workflows/ci.yml`）：搭建 compile → PMD 静态检查 → test → install → 归档 → 检查测试结果六大环节的 CI 流水线，经六次迭代修复后全流程跑通。
- **PMD 静态代码检查**：在 `pom.xml` 中集成 maven-pmd-plugin（bestpractices + errorprone 规则集）。
- **Jenkinsfile**：编写声明式 Pipeline，覆盖 CI/CD 全流程。
- 流水线如实反映测试结果（3 个上游失败测试标红），5 类 artifact 归档成功。

**关键记录**：有效提交 `fe2b6342` → `4acd30f0`；关键修复包括 PMD 改为仅生成报告、`package` 改 `install` 解决跨模块依赖、归档步骤加 `if: !cancelled()`。

---

## 九、实验八：Docker 容器化

**目标**：将 Teedy 容器化并推送镜像。

**成果**：
- 编写多阶段构建 `Dockerfile`（builder：maven + node22 → runtime：temurin11-jdk + Jetty11）。
- 编写 `docker-compose.yml`（宿主机 8888 → 容器 8080）。
- 编写 `.github/workflows/docker.yml`：CI 中构建 → 运行 → 验证 → 推送 GHCR 全链路。
- 镜像成功推送至 `ghcr.io/tangx2872-svg/teedy:latest`。

**关键记录**：有效提交 `5a9f9ff5` → `cdcc57bc`；关键修复包括 Jetty 运行阶段 JRE→JDK、GHCR 镜像名小写、`docker run` 引用一致性；本机 Docker 环境从零搭建（WSL 服务、镜像加速源、代理关闭等连环问题均已解决并归档）。

---

## 十、实验九：Kubernetes 部署

**目标**：将 Teedy 部署到 Kubernetes 集群并验证访问。

**成果**：
1. 采用 Docker Desktop 自带 K8s（替代 minikube），kubectl v1.36.1，单节点集群。
2. 编写 `k8s/teedy-deployment.yaml`：Deployment（replicas=1）+ Service（NodePort 8080→30080）。
3. 本地重建镜像（`teedy:local`），完成部署。
4. 验证：Deployment READY 1/1，Pod 内 `http://teedy:8080/` 返回 HTTP 200。
5. Jenkinsfile 新增「部署到 Kubernetes」+「验证 Kubernetes 服务访问」阶段。

**关键记录**：有效提交 `f6809827`；NodePort 30080 宿主机直连受 Docker Desktop kind 已知限制影响，改用集群内 ClusterIP 访问验证。

---

## 十一、实验成果与问题总结

### 11.1 成果总览

| # | 实验 | 核心成果 | 有效提交 |
| --- | --- | --- | --- |
| 1 | 安装与运行 | 构建 + 启动 + 登录 | `60901b9f` |
| 2 | Git 版本控制 | 提交历史 / README 学号 / 登录页学号 | `fbd27450` 等 |
| 3 | 需求与 Scrum | 用户故事 + GitHub Projects 看板（22 卡片） | 看板 projects/4 |
| 4 | 架构与 UML | 4 张 PlantUML 图 + 架构报告 | — |
| 5 | Maven 与 JavaDoc | JavaDoc 自动生成（绑定 package） | `e2ccd90e` |
| 6 | 测试与覆盖率 | JaCoCo，LocaleUtil 0%→91.7% | `e42b4835` |
| 7 | CI/CD | GitHub Actions 六环节流水线 + Jenkinsfile | `fe2b6342`→`4acd30f0` |
| 8 | Docker | 多阶段构建 + 推 GHCR | `5a9f9ff5`→`cdcc57bc` |
| 9 | Kubernetes | Deployment/Service + 访问验证 | `f6809827` |

### 11.2 主要收获

1. **完整 DevOps 链路**：从源码管理、构建测试到容器化、编排部署，全流程贯通。
2. **真实项目实践**：基于真实开源项目，遇到并解决了大量工程实际问题（跨模块依赖、CI 环境差异、国内镜像/网络等）。
3. **工具链掌握**：Git / Maven / JUnit / JaCoCo / PMD / Jenkins / GitHub Actions / Docker / Kubernetes。

### 11.3 遗留问题与说明

- 测试环节存在 3 个上游基线失败用例（`TestMimeTypeUtil`、`TestPdfFormatHandler#testIssue373`、`TestFileUtil`），非本次改动引入，如实记录未强行掩盖。
- Docker Desktop 的 kind 集群 NodePort 宿主机直连存在已知限制，K8s 访问验证采用集群内方式完成。
- 部分环节受国内网络环境影响（镜像拉取、GHCR 访问），通过配置镜像加速源与本地构建解决。

---

## 十二、结论

通过 Teedy 这一真实开源项目，完整实践了《智能软件工程》课程的核心方法论与工具链：从需求分析（Scrum）、架构设计（UML）、构建与文档（Maven/JavaDoc）、质量保障（测试/JaCoCo/PMD），到工程化交付（CI/CD、Docker、Kubernetes）。九个实验层层递进、环环相扣，形成了「需求 → 设计 → 实现 → 测试 → 集成 → 部署 → 编排」的完整闭环，达到了课程预期的实践目标。
