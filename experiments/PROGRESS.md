# 实验进度总览（PROGRESS）

> 本文件是跨会话恢复实验的**唯一进度真源**。后续 Codex 会话（无论是否更换会话）读取本文件与根目录 `AGENTS.md` 即可继续，无需重新介绍项目。

## 当前状态

- **当前任务**：实验十 —— 项目汇报/总结（已完成）。
- **下一步**：全部 10 个实验已全部完成，项目收官。
- **最后更新**：2026-11-24

## 各章进度明细

| 实验 | 任务 | 状态 | 有效提交 / 依据 |
| --- | --- | --- | --- |
| 实验一：安装与运行 | Fork/Clone、构建、启动、登录 | ✅ 已完成 | `60901b9f` |
| 实验二：Git 版本控制 | (1) 查看提交历史 | ✅ 已完成 | 用户已查看 |
| 实验二 | (2) README 添加学号并推送 | ✅ 已完成 | `fbd27450` |
| 实验二 | 记录 Git 操作流程 | ✅ 已完成 | `3a0f723e` |
| 实验二 | (3) 登录页 Logo 下加学号 | ✅ 已完成 | `7b18e3a4` |
| 实验三：需求与 Scrum | GitHub Projects 看板 | ✅ 已完成 | 看板 projects/4（22 张卡片） |
| 实验四：架构与 UML | UML 图 | ✅ 已完成 | 4 张 PlantUML 图 + 架构报告 |
| 实验五：Maven 与 JavaDoc | 自动生成 JavaDoc | ✅ 已完成 | javadoc 插件绑定 package 阶段 |
| 实验六：测试与覆盖率 | JaCoCo 覆盖率提升 | ✅ 已完成 | LocaleUtil 0%→91.7%，总体行覆盖 24.8% |
| 实验七：CI/CD | Jenkins + GitHub Actions | ✅ 已完成 | `fe2b6342`→`d5bd61f2`（GitHub Actions 跑通，Jenkinsfile 已编写） |
| 实验八：Docker | 容器化 + 推送 | ✅ 已完成 | `5a9f9ff5`→`b206c011`（多阶段构建+8888+推 GHCR） |
| 实验九：Kubernetes | 部署验证 | ✅ 已完成 | Docker Desktop K8s 单节点 + Deployment/Service + Service 访问 HTTP 200 |
| 实验十：项目汇报 | 汇总汇报 | ✅ 已完成 | `reports/final-report.md`（九章成果汇总 + 问题总结） |

## 关键事实备忘

- 学号 `1260101027`，姓名 `汤鑫`（以 README 与 `docs/experiment-02-git.md` 为准，不得自行编造）。
- 远程仓库 `tangx2872-svg/Teedy`，master 分支；origin 为 HTTPS 地址 `https://github.com/tangx2872-svg/Teedy.git`（原 SSH 已在 11-22 切换为 HTTPS）。
- Git 身份：`user.name=tangx2872-svg`，`user.email=256494934+tangx2872-svg@users.noreply.github.com`（noreply，保护隐私）。
- 历史遗留：曾出现本地与远程 diverged、README 冲突、package-lock.json 变化、GH007 邮箱隐私，均已处理并归档于 `docs/experiment-02-git.md`。
- 环境注意：本地为 **Windows 原生**（非 WSL），仓库路径 `D:\Research\Teedy`；Maven 曾缺失，已在本轮重新安装 3.9.9（见 ENVIRONMENT.md）。

## 里程碑计划

| 里程碑 | 日期 |
| --- | --- |
| 恢复环境 + 实验二（登录页显示学号） | 11-21 |
| 实验三（GitHub Scrum 看板） | 11-22 |
| 实验四（UML 架构图） | 11-23 |
| 实验五（自动生成 JavaDoc） | 11-24 |
| 实验六（测试覆盖率提升） | 11-25 |
| 实验七（CI/CD 流水线） | 11-26 |
| 实验八（Docker 容器运行） | 11-27 |
| 实验九（Kubernetes 部署） | 11-28 |
| 实验十（整理实验汇报） | 11-29 |
