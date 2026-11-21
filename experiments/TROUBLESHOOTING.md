# 问题记录与解决方案（TROUBLESHOOTING）

> 汇总实验中遇到的报错及解决方案，避免重复踩坑。

## 实验一 / 实验二（历史遗留，已归档于 docs/experiment-02-git.md）

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| `Author identity unknown` | Git 未配置作者身份 | 设置 `user.name` / `user.email`（采用 noreply） |
| push 要求 Username / Password | origin 为 HTTPS | 配置 SSH key，切换 origin 为 SSH |
| `rejected (fetch first)` | 本地与远程历史分叉 | fetch → 查看分支图 → 保护工作区 → rebase |
| README content conflict | 本地与远程改动重叠 | 人工保留有效内容，`git add` 后 `rebase --continue` |
| `GH007: Your push would publish a private email` | 提交暴露受保护邮箱 | 设置 noreply + `commit --amend --reset-author` |

## 本轮（恢复实验）

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| `mvn: command not found` | Windows 环境 Maven 未安装 | 下载 Apache Maven 3.9.9 到 `D:\tools\`，配置 MAVEN_HOME 与 PATH |
| 本地落后远程 2 个提交（`behind 2`） | 换环境后本地未同步远程 | `git pull origin master`（fast-forward，无分叉） |

## 通用 Git 原则

- 提交前先 `git status` + `git diff`，不要无脑 `git add .`。
- 不提交 `target/`、`node_modules/`、临时数据库、密钥、`.vscode/` 等不必要文件。
- 禁止 force push；冲突先分析原因，保护本地成果。
- 不删除旧项目、不强制覆盖本地修改。
