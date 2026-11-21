# 实验三 notes.md — 问题与解决

## 本轮问题与解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 无法自动创建 GitHub Projects 看板 | 本地无 `gh` CLI，无可用 GitHub token（credential manager 中仅存 git 专用 HTTPS 凭证，且 API 写操作需认证） | 改为用户手动在 GitHub 网页创建看板，我提供完整分步指引（`reports/scrum-board-guide.md`），操作完截图归档 |

## 需求分析要点

- 基于 Teedy 真实源码（REST 资源层 17 个 Resource 类 + 前端控制器 + DAO）梳理功能，不编造。
- 选定三大核心功能：文档上传与版本管理、文档检索、文档管理（含标签与权限）。
- 分解出 11 个用户故事（US-1 ~ US-11）、11 个可执行任务（T-1 ~ T-11）。

## 待办

- 用户完成网页看板操作后，归档截图并提交实验三记录。
