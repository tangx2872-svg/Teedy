# 实验二：Git 版本控制

## 实验目的

通过 Teedy 学习提交历史查看、工作区审计、暂存、提交与推送，理解分支分叉、stash、rebase、冲突处理及 GitHub 邮箱隐私保护。

## 教材任务

1. 在 GitHub 查看 Teedy 提交历史和部分 commit。
2. 在 README 添加学号，commit 并 push 至个人仓库。
3. 在登录页 Logo 下方添加学号，运行并在浏览器验证，再单独 commit + push，使用详细提交说明。

## 完成状态

| 任务 | 状态 | 有效提交 |
| --- | --- | --- |
| (1) 查看提交历史 | ✅ 已完成 | — |
| (2) README 添加学号并推送 | ✅ 已完成 | `fbd27450` |
| 记录 Git 操作流程 | ✅ 已完成 | `3a0f723e` |
| (3) 登录页 Logo 下加学号 | ✅ 已完成 | 待提交 |

## 详细操作记录

完整操作流程、问题与解决方案见 `docs/experiment-02-git.md`（261 行详尽归档），涵盖：提交历史查看、工作区审计、README 加学号、Git 身份配置、SSH 配置、diverged 处理、stash、rebase、冲突解决、GH007 邮箱隐私、最终 push 验证等。

## 任务(3) 说明

- **目标文件**：`docs-web/src/main/webapp/src/partial/docs/login.html`
- **改动位置**：Logo（`img/title.png`）下方添加学号 `1260101027`。
- **验证方式**：重新构建 → 运行 → 浏览器确认可见 → 单独 commit + push（详细提交说明）。

## 相关文件

- `docs/experiment-02-git.md`：实验二完整归档。
- `docs-web/src/main/webapp/src/partial/docs/login.html`：登录页模板。
- `docs-web/src/main/webapp/src/index.html`：前端入口。
