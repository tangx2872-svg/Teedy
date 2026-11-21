# 实验二 notes.md — 问题与解决

## 任务(3) 登录页 Logo 下加学号

### 本轮问题与解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 本地 `mvn: command not found` | Windows 原生环境未安装 Maven（历史实验在 WSL 完成） | 下载 Apache Maven 3.9.9 到 `D:\tools\apache-maven-3.9.9`，配置 MAVEN_HOME 与 PATH |
| 本地落后远程 2 个提交 | 换环境后本地停在 `60901b9f`，远程已推进到 `3a0f723e` | `git pull origin master`（fast-forward，无分叉） |

### 待记录（构建运行时补充）

- 重新构建命令及结果。
- 运行启动方式及端口。
- 浏览器验证结果（截图存 `screenshots/`）。
