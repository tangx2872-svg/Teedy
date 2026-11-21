# AGENTS.md — 项目工作规则（供后续会话读取）

本文件是《智能软件工程》Teedy 实验项目的持久化工作规则。任何后续会话（包括更换会话后）接手本任务时，**先读本文件 + `experiments/PROGRESS.md`**，即可恢复进度并继续，无需用户重新介绍项目。

## 一、项目是什么

- 研究生《智能软件工程》课程配套实验，基于开源文档管理系统 **Teedy**，按教材附录完成第 1～10 章实验。
- 上游仓库：`https://github.com/sustech-cs304/Teedy`
- 个人仓库：`https://github.com/tangx2872-svg/Teedy`（master 分支，SSH origin）
- 学号 `1260101027`，姓名 `汤鑫`。

## 二、如何恢复进度

1. 读 `experiments/PROGRESS.md` 找到「当前任务」和「下一步」。
2. 读 `experiments/ENVIRONMENT.md` 确认环境与命令。
3. 读 `experiments/TROUBLESHOOTING.md` 避免重复踩坑。
4. 检查 git 状态：`git status`、`git remote -v`、`git branch -avv`、`git log --oneline -15`、`git stash list`，必要时 `git fetch` 同步远程。
5. 从 PROGRESS.md 标记的第一个未完成任务开始执行。

## 三、实验执行规则（务必遵守）

1. 严格按照章节顺序推进，每次只推进一个明确的实验任务。
2. 已完成任务以核查和整理为主，**不重复劳动**。
3. 修改代码前先说明修改目的和涉及文件。
4. 每个实验必须有真实运行验证；**不得伪造截图、测试结果或完成状态**。
5. 每完成一个实验，更新 `experiments/PROGRESS.md`。
6. 每章使用独立、清晰的 Git Commit，验证通过后 push，并检查远程提交存在。
7. 不提交 `target/`、`node_modules/`、临时数据库、密钥、`.vscode/` 等文件。
8. 优先使用现有环境，不随意升级旧项目依赖。
9. 教材「实验任务」与「课程项目」分开记录；当前优先完成 Teedy 实验任务，小组课程项目暂不重复创建。
10. 业务源码、Maven 配置、Jenkinsfile 保留在原项目正确位置，`experiments/` 只放记录，不复制源码。

## 四、关键事实备忘

- Git 身份：`user.name=tangx2872-svg`，`user.email=256494934+tangx2872-svg@users.noreply.github.com`（noreply）。
- 已完成提交：`60901b9f`（实验一）、`fbd27450`（实验二 README 加学号）、`3a0f723e`（实验二 Git 操作记录）。
- 历史遗留问题（diverged、README 冲突、GH007 邮箱）均已处理，详见 `docs/experiment-02-git.md`。
- 本地环境为 Windows 原生，仓库路径 `D:\Research\Teedy`（与历史 WSL 路径 `/home/tang/Research/Teedy` 是独立副本）。

## 五、推进方式

- 用户说「继续下一个实验」时，读本文件 + `experiments/PROGRESS.md`，从第一个未完成任务开始执行，无需重新介绍项目。
- 用户要求汇报时，以 PROGRESS.md 和各章 README/notes 为准，如实汇报，不夸大完成度。
