# 实验二：Git 版本控制

## 实验目的

通过 Teedy 学习提交历史查看、工作区审计、暂存、提交与推送，理解分支分叉（diverged）、stash、rebase、冲突处理及 GitHub 邮箱隐私保护。

## 实验原理

Git 是分布式版本控制系统，核心对象模型为「工作区 → 暂存区（index）→ 本地仓库 → 远程仓库」四层。本实验覆盖的典型操作与知识点：

- **提交历史查看**：`git log` / `git show` 追踪每次提交的变更。
- **工作区审计**：`git status` / `git diff` 查看未暂存与未提交的改动。
- **提交与推送**：`git add`（暂存）→ `git commit`（提交）→ `git push`（推送远程）。
- **分叉与同步**：本地与远程各自有新提交时产生 diverged，需 `git pull`（fast-forward 或 merge）解决。
- **隐私保护**：GitHub 的 `noreply` 邮箱可避免公开真实邮箱（`GH007` 报错即因推送包含隐私邮箱被拦截）。

## 教材任务

1. 在 GitHub 查看 Teedy 提交历史和部分 commit。
2. 在 README 添加学号，commit 并 push 至个人仓库。
3. 在登录页 Logo 下方添加学号，运行并在浏览器验证，再单独 commit + push，使用详细提交说明。

## 分步操作过程

### 任务(1) 查看提交历史

```bash
git log --oneline          # 简要历史
git log --graph --all      # 分支图
git show <commit-hash>     # 查看某次提交的完整变更
```

### 任务(2) README 添加学号并推送

```bash
# 在 README.md 中添加学号 1260101027
git add README.md
git commit -m "在 README 添加学号"
git push origin master
```

### 任务(3) 登录页 Logo 下加学号

- **目标文件**：`docs-web/src/main/webapp/src/partial/docs/login.html`
- **改动位置**：Logo（`img/title.png`）下方添加学号 `1260101027`。

改动后重新构建前端并验证：

```bash
cd docs-web/src/main/webapp
npm install
./node_modules/.bin/grunt          # ngtemplates 将模板预编译进 dist/docs.min.js
```

启动后访问登录页，确认学号在 Logo 下方渲染。验证通过后单独提交：

```bash
git add docs-web/src/main/webapp/src/partial/docs/login.html
git commit -m "实验二任务3：登录页 Logo 下方添加学号"   # 详细提交说明
git push origin master
```

### Git 身份与远程配置

```bash
# 切换远程为 HTTPS（原 SSH 在换环境后不可用）
git remote set-url origin https://github.com/tangx2872-svg/Teedy.git

# 使用 noreply 邮箱保护隐私
git config user.name  "tangx2872-svg"
git config user.email "256494934+tangx2872-svg@users.noreply.github.com"
```

## 完成状态

| 任务 | 状态 | 有效提交 |
| --- | --- | --- |
| (1) 查看提交历史 | ✅ 已完成 | — |
| (2) README 添加学号并推送 | ✅ 已完成 | `fbd27450` |
| 记录 Git 操作流程 | ✅ 已完成 | `3a0f723e` |
| (3) 登录页 Logo 下加学号 | ✅ 已完成 | `7b18e3a4` |

## 结果验证

- 学号 `1260101027` 已通过 Grunt `ngtemplates` 任务预编译进 `dist/docs.min.js` 的 Angular `$templateCache`，浏览器加载登录页时在 Logo 下方渲染。
- 远程推送后检查 `git log origin/master` 确认提交已同步。

## 问题与解决（关键踩坑）

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| `mvn: command not found` | Windows 原生环境未装 Maven（历史实验在 WSL 完成） | 安装 Maven 3.9.9 并配置环境变量 |
| 本地落后远程 2 个提交 | 换环境后本地停在旧提交 | `git pull origin master`（fast-forward，无分叉） |
| `package-lock.json` 格式变化 | `npm install` 触发 lockfileVersion 升级 | `git restore` 还原，不提交无关变更 |
| GH007 邮箱隐私 | 推送含真实邮箱被 GitHub 拦截 | 改用 noreply 邮箱 + 重写历史 |

## 相关文件

- `docs/experiment-02-git.md`：实验二完整归档（261 行，含 stash/rebase/冲突解决全流程）。
- `docs-web/src/main/webapp/src/partial/docs/login.html`：登录页模板。
- `docs-web/src/main/webapp/src/index.html`：前端入口。
