# 《智能软件工程》Teedy 实验总目录

本目录用于统一管理《智能软件工程》课程配套实验的记录、代码改动、运行截图与提交历史。业务源码、Maven 配置、Jenkinsfile 等仍保留在 Teedy 原项目正确位置，本目录只存放**实验记录与说明**，不重复复制源码。

## 项目信息

- **课程**：研究生《智能软件工程》
- **基础项目**：Teedy（开源文档管理系统）
- **上游仓库**：https://github.com/sustech-cs304/Teedy
- **个人仓库**：https://github.com/tangx2872-svg/Teedy
- **学号**：1260101027
- **姓名**：汤鑫

## 各章实验目标

| 目录 | 实验 | 核心目标 | 状态 |
| --- | --- | --- | --- |
| [01-setup](01-setup/) | Teedy 安装与运行 | Fork/Clone、构建、启动、登录 | ✅ 已完成 |
| [02-git](02-git/) | Git 版本控制 | 提交历史、README 加学号、登录页加学号 | 🔄 进行中 |
| [03-requirements-scrum](03-requirements-scrum/) | 软件需求与 Scrum | 需求分析、用户故事、GitHub Projects 看板 | ⬜ 未开始 |
| [04-architecture-uml](04-architecture-uml/) | 软件架构与 UML | 包结构分析、UML 图、类关系 | ⬜ 未开始 |
| [05-maven-javadoc](05-maven-javadoc/) | Maven 与 JavaDoc | pom 分析、构建生命周期、自动生成 JavaDoc | ⬜ 未开始 |
| [06-testing-jacoco](06-testing-jacoco/) | 软件测试与覆盖率 | Surefire、JaCoCo、覆盖率提升 | ⬜ 未开始 |
| [07-ci-cd](07-ci-cd/) | CI/CD | Jenkins、GitHub Actions、Maven/PMD/测试流水线 | ⬜ 未开始 |
| [08-docker](08-docker/) | Docker 容器化 | 构建镜像、运行容器、推送 Docker Hub | ⬜ 未开始 |
| [09-kubernetes](09-kubernetes/) | Kubernetes 部署 | minikube、Deployment/Service、部署验证 | ⬜ 未开始 |
| [10-presentation](10-presentation/) | 项目汇报 | 汇总前九章成果，整理汇报材料 | ⬜ 未开始 |

## 目录约定

每个实验文件夹内部结构：

```
NN-xxx/
├── README.md        # 实验要求、原理、操作步骤和结果
├── screenshots/     # 真实运行截图
├── reports/         # 实验生成的报告
└── notes.md         # 遇到的问题及解决方法
```

## 核心导航文件

- [PROGRESS.md](PROGRESS.md)：当前实际进度、当前任务、下一步
- [ENVIRONMENT.md](ENVIRONMENT.md)：环境版本、依赖、启动命令
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)：报错及解决方案汇总

## 实验执行规则

1. 严格按照章节顺序推进。
2. 已完成的任务以核查和整理为主，不重复劳动。
3. 每次只推进一个明确的实验任务。
4. 修改代码之前，先说明修改目的和涉及文件。
5. 每个实验需要有真实的运行验证，不得伪造截图、测试结果或完成状态。
6. 每完成一个实验，更新 PROGRESS.md。
7. 每章使用独立、清晰的 Git Commit。
8. 验证通过后推送至个人 GitHub 仓库，推送后检查远程提交是否存在。
9. 不提交 target、node_modules、临时数据库、密钥等不必要文件。
10. 优先使用现有环境，不随意升级旧项目依赖。
