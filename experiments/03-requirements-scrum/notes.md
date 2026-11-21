# 实验三 notes.md — 问题与解决

## 本轮问题与解决

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 无法自动创建 GitHub Projects 看板 | 本地无 `gh` CLI，无可用 GitHub token（credential manager 中仅存 git 专用 HTTPS 凭证，且 API 写操作需认证） | 改为用户手动在 GitHub 网页创建看板，我提供完整分步指引（`reports/scrum-board-guide.md`），操作完截图归档 |

## 需求分析要点

- 基于 Teedy 真实源码（REST 资源层 17 个 Resource 类 + 前端控制器 + DAO）梳理功能，不编造。
- 选定三大核心功能：文档上传与版本管理、文档检索、文档管理（含标签与权限）。
- 分解出 11 个用户故事（US-1 ~ US-11）、11 个可执行任务（T-1 ~ T-11）。

## 看板录入过程的踩坑记录

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 误用「Create new issue」添加卡片 | 点栏内 `+` 后选了第一个选项 | 应选「Create a draft」（Ctrl+D），普通草稿卡片不产生仓库 Issue |
| 一次性粘贴 11 条变成单张长卡片 | 把多条文字粘进同一输入框 | 必须逐条粘贴 + 回车，每条生成独立卡片 |
| 首次看板关联错仓库 | 在错误入口（用户级 Projects）创建 | 从 Teedy 仓库的 Projects 页创建，确保关联 tangx2872-svg/Teedy |

## 最终结果

- 22 张草稿卡片（US×11 + Todo×8 + InProgress×2 + Done×1），仓库 Issue 新增 0。
- 看板：https://github.com/users/tangx2872-svg/projects/4
