# 实验二：Git 版本控制操作实验记录

> 阶段性归档：2026-10-13（Asia/Shanghai）。学号：1260101027；姓名：汤鑫。
> 本次只归档已完成流程，不修改登录页或业务源码。

## 1. 实验目的

通过 Teedy 学习提交历史查看、工作区审计、暂存、提交和推送，理解分支分叉、stash、rebase、冲突处理及 GitHub 邮箱隐私保护，形成可追溯的实验记录。

## 2. 实验环境与证据范围

| 项目 | 本次核验结果 |
| --- | --- |
| 宿主环境 | Windows + WSL；实验一原记录为 Windows 11 + WSL2 |
| WSL 发行版 | Ubuntu 26.04.1 LTS |
| Git 版本 | 2.53.0 |
| 实际仓库路径 | `/home/tang/Research/Teedy` |
| 分支 | `master` |
| origin fetch / push | `git@github.com:tangx2872-svg/Teedy.git` |
| user.name | `tangx2872-svg` |
| user.email | `256494934+tangx2872-svg@users.noreply.github.com` |

Windows 的 `D:\Research\Teedy` 与 WSL 主目录中的仓库是独立副本。本次针对 WSL 仓库，不将 Windows JDK 安装情况当作 WSL 环境证据，也未重新构建、启动 Teedy 或检查运行工具版本。

**证据说明：** GitHub 页面操作、早期报错与手工操作按用户提供的历史事实整理，未保留的原始输出不补造。本次实际核验 Git 状态、远程配置、提交、reflog、stash 和 fetch 后的 origin/master。

初始工作区干净；fetch 后 HEAD 与 origin/master 均为 `fbd274504da49f0b134656df08e685f69a165bb0`。实验一提交为 `60901b9f`，任务（2）的当前有效提交为 `fbd27450`。

## 3. 教材任务

1. 在 GitHub 查看 Teedy 提交历史和部分 commit。
2. 在 README 添加学号，commit 并 push 至个人仓库。
3. 在登录页 Logo 下方添加学号，运行并在浏览器验证，再单独 commit + push，使用详细提交说明。

课程项目的小组仓库与多人协作属于另一部分，不在本次范围内。

## 4. 当前完成进度

| 任务 | 状态 | 依据 |
| --- | --- | --- |
| （1）查看提交历史 | 完成 | 用户已查看 master 的 Commits 和部分提交 |
| （2）README 添加学号并推送 | 完成 | 本次核验 fbd27450 的内容及远程历史 |
| （3）修改登录页并验证、推送 | 未开始 / 待完成 | 本次不执行 |
| 阶段性归档 | 本文及 README 入口已整理 | commit 和 push 结果以最终报告、Git 历史为准 |

**审计补充：** 当前任务（2）提交仍残留一行 `<<<<<<< HEAD`。因此不能把历史处理写成“全部冲突标记已删除”。本次归档仅移除这行标记，保留实验一正文及学号姓名，不影响任务（2）已经完成的事实。

## 5. 查看 GitHub commit 历史

用户进入 [个人仓库](https://github.com/tangx2872-svg/Teedy) master 的 Commits，查看了 `60901b9f 完善实验一 README 并添加图片` 及上游 Teedy 提交。

commit 是一次版本快照，并保存作者、提交说明和父提交关系。GitHub Commits 页面可以查看 message、作者、时间和 hash；进入单个提交可查看文件差异，通常红色表示删除、绿色表示新增。本次未重新操作浏览器，任务（1）依据用户操作记录。

## 6. 本地工作区审计

此前执行：

```bash
cd ~/Research/Teedy
pwd
git status
git diff README.md
```

目录确认为 `/home/tang/Research/Teedy`。当时存在 README 修改、`docs-web/src/main/webapp/package-lock.json` 修改和未跟踪 `data/`。查看差异后发现 README 混入无关内容，因此用户执行 `git restore README.md` 恢复，再准备实验修改。

restore 会丢弃指定文件的未暂存修改，必须先确认内容不需要保留。本次未再次执行 restore。提交前应先 status、diff，不应直接 add 全部文件。

## 7. README 添加学号和姓名

用户只暂存 README：

```bash
git add README.md
git status
```

确认只有 README 位于 Changes to be committed，锁文件和 data 未进入提交。本次核验最终文件实际内容为：

```markdown
## 实验二信息

学号：1260101027

姓名：汤鑫
```

实际标题为“实验二信息”，与历史流程示例中的“实验信息”略有差异，以当前文件为准。有效提交为 `fbd27450 实验二：在 README 中添加学号和姓名`。

## 8. Git 作者身份配置

第一次 commit 出现 `Author identity unknown`，因为 WSL Git 尚未配置身份。用户先配置身份创建提交，后续为隐私保护改用：

```bash
git config user.name "tangx2872-svg"
git config user.email "256494934+tangx2872-svg@users.noreply.github.com"
```

不加 --global 时为仓库级配置。本次确认配置正确，当前任务（2）提交的 Author 和 Commit 均为 noreply，不展示曾使用的真实邮箱。

## 9. GitHub SSH 配置

origin 最初为 HTTPS，push 提示 Username / Password。用户检查 `ls -la ~/.ssh` 时目录不存在，随后用 `ssh-keygen -t ed25519 -C "..."` 生成密钥，将公钥添加到 GitHub SSH Keys，再执行：

```bash
ssh -T git@github.com
```

用户记录返回：

```text
Hi tangx2872-svg! You've successfully authenticated, but GitHub does not provide shell access.
```

表示认证成功，GitHub 不提供交互式 shell 不是故障。生成命令中的注释只作占位，不代表原始实际注释，也不要求再次生成密钥。随后：

```bash
git remote set-url origin git@github.com:tangx2872-svg/Teedy.git
git remote -v
```

本次核验 fetch/push 均为 SSH 地址且 fetch 成功。私钥 `~/.ssh/id_ed25519` 仅用于本机认证，公钥 `id_ed25519.pub` 用于 GitHub 配置；两者均不提交，不在本文展示内容。本次没有读取私钥。

## 10. 本地与远程 diverged

首次 SSH push 报 `master -> master (fetch first)`。用户执行：

```bash
git fetch origin
git log --oneline --graph --decorate --all -15
```

发现当时本地 `c3132b21`（实验二）与远程 `60901b9f`（实验一）均基于 `4b2aa0d0`，历史分叉。远程包含本地没有的有效提交，应先检查再整合，不能 force push 覆盖实验一。

c3132b21 仅为当时历史线索，不是当前有效实验二 hash。

## 11. git stash 的作用与保存状态

为保护运行产物，用户执行：

```bash
git stash push -u -m "临时保存Teedy运行产生的文件"
git status
```

stash 保存未提交改动；-u 包括未跟踪文件，不包括默认忽略的文件。用户确认工作区干净后进行 rebase。

本次初始审计仍存在 `stash@{0}: On master: 临时保存Teedy运行产生的文件`，对象为 `f88dd6f9315db0bc9783795d2e822685bb0de381`。工作区干净不表示运行数据被删除。本次不 apply、pop、drop 或 clear，也不把 stash 内容加入归档；需要恢复时另行检查。

## 12. git fetch 与 git rebase

fetch 获取远程提交并更新远程跟踪引用，不直接整合当前工作区。用户保护工作区后执行：

```bash
git rebase origin/master
```

将本地实验二提交重放到远程实验一之后。父提交改变会改变 commit hash。本地 reflog 核验到旧提交 c3132b21、rebase 后 a6170bdf、amend 后 fbd27450，支持这一处理链。

## 13. README 冲突产生原因与解决

远程有完整实验一记录，本地在旧 README 尾部添加学号姓名，rebase 出现 content conflict。用户保留实验一及个人信息，处理冲突后执行：

```bash
git add README.md
git rebase --continue
```

用户记录最终 Successfully rebased，历史变为实验一之后接实验二。**但本次 git show 确认仍残留一行冲突起始标记**，说明 rebase 完成不等于正文完全正确。

本次仅清除这行 `<<<<<<< HEAD`，不改写实验一内容，并检查行首的起始、分隔、结束冲突标记。正文提及标记时采用行内代码，不保存独立冲突行。

## 14. GH007 邮箱隐私问题

rebase 后 push 报：

```text
GH007: Your push would publish a private email address.
```

用户开启邮箱隐私及阻止命令行推送泄露邮箱的选项。已有提交仍带私人邮箱，仅修改配置不会修改已有 commit，于是执行：

```bash
git config user.email "256494934+tangx2872-svg@users.noreply.github.com"
git commit --amend --reset-author --no-edit
git log -1 --format=full
```

amend 替换最后一个提交，reset-author 使用当前身份，no-edit 保留说明。此操作发生在成功推送之前，不关闭隐私保护，也不需要强制推送。本次确认当前提交作者及提交者均为 noreply。

## 15. 最终 push 验证及本次归档

用户执行 `git push origin master` 成功，记录输出范围 `60901b9f..fbd27450 master -> master`。本次重新 fetch 后核验远程包含任务（2），且实验一仍为其父提交。

本次归档提交说明固定为：

```text
docs: 记录实验二 Git 版本控制操作流程
```

不预填本次归档自身 hash 或宣称尚未执行的 push 成功，结果以最终报告、远程分支及 Git 历史为准。最终核验命令：

```bash
git status
git log --oneline --graph --decorate -8
git remote -v
git stash list
git rev-parse HEAD origin/master
git ls-remote origin refs/heads/master
git show --stat HEAD
```

文档采用已有 docs 目录，与实验一图片同属记录资料。因 docs/* 被忽略，只在 .gitignore 放行 `!docs/experiment-02-git.md`，不扩大其他文件的跟踪范围。README 仅移除一行残留标记并追加短入口。

## 16. 核心 Git 命令

| 命令 | 含义及本次作用 |
| --- | --- |
| git status | 查看分支、工作区和暂存区，判断哪些文件属于本次提交。 |
| git diff | 默认看未暂存的已跟踪改动；--cached 看待提交内容。新建未跟踪文档需另行读取或暂存后查看。 |
| git add | 将指定路径当前内容加入暂存区，本次明确列出文件。 |
| git commit | 将暂存内容保存为本地快照，记录说明、身份和父提交。 |
| git fetch | 获取远程对象并更新远程跟踪引用，不自动整合当前分支。 |
| git pull | 获取后整合，使用 merge 或 rebase 取决于参数和配置；本次没有把 pull 写成实际已执行。 |
| git rebase | 将本地提交重放到新基点，可能产生冲突并改变 hash。 |
| git push | 将本地提交及分支更新送至远程，正常快进推送保留远程历史。 |
| git stash | 暂存未提交改动，-u 包括未跟踪文件，本次保留原 stash。 |
| git log | 查看历史，--graph --decorate --all 用于分析分支关系。 |
| git remote | 查看或设置远程地址，本次从 HTTPS 改为 SSH。 |

## 17. 问题—原因—解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| Author identity unknown | Git 未配置作者身份 | 设置 user.name 和 user.email，最终采用 noreply |
| push 要求 Username / Password | origin 采用 HTTPS 认证方式 | 配置 SSH key 并切换 origin 为 SSH |
| rejected (fetch first) | 远程有本地缺失的新提交，历史分叉 | fetch、查看分支图、保护工作区后 rebase |
| README content conflict | 本地与远程改动重叠 | 人工保留有效内容，add 后 rebase --continue；本次补清残留标记 |
| GH007 private email | 已有 commit 暴露受保护邮箱 | 设置 noreply，并 amend --reset-author 修正元数据 |

SSH 是本次选择的方案，HTTPS 本身不是错误，本文不把此流程当作唯一认证方法。

## 18. Git 工作流与实验收获

`Working Tree → Staging Area → Local Repository → Remote Repository`

工作区是正在编辑的文件；暂存区是下一次提交的内容清单；本地仓库存储版本历史；远程仓库用于共享提交。保存文件不等于 commit，commit 不等于 push。

本次工作流：

`修改文件 → status / diff → add 指定文件 → diff --cached → commit → fetch → 检查历史 → 必要时 rebase → push`

fetch 可以提前执行，rebase 仅在需要整合时使用。提交前不应无脑 add .，否则可能暂存锁文件、运行数据或其他无关内容。冲突解决后既要检查 Git 状态也要检查正文，成功提示不能代替内容审计。保留用户数据与 stash、使用 noreply、避免 force push，使操作既可追溯又尊重原有历史。

## 19. 尚未完成的任务

- 教材任务（3）：修改 Teedy 登录页，在 Logo 下方添加学号。
- 为任务（3）本地运行 Teedy，并在浏览器验证修改后的页面。
- 为该登录页修改单独 commit + push，使用详细提交说明。

实验一的历史启动及页面验证已完成，但不能据此认定任务（3）的修改后验证也完成。本次不继续以上步骤。
