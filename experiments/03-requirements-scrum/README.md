# 实验三：软件需求与 Scrum

## 状态

✅ 已完成

## 实验目的

运用 Scrum 敏捷方法对 Teedy 进行需求分析：体验功能、梳理功能性与非功能性需求、将主要功能分解为用户故事，并在 GitHub Projects 中搭建 Scrum 看板进行迭代管理。

## 实验原理

Scrum 是一种轻量级敏捷框架，核心要素包括：

- **Product Backlog**：按优先级排序的需求列表（本实验以用户故事 User Story 表达）。
- **用户故事**：以「作为<角色>，我希望<功能>，以便<价值>」的格式描述需求。
- **Sprint**：固定时长的迭代周期，从 Backlog 选取任务推进。
- **看板（Board）**：可视化工作流，典型列如 User Story / Todo / In Progress / Done。

GitHub Projects 提供内置看板，可直接关联仓库，把需求管理与代码托管结合。

## 实验任务

1. 实际体验 Teedy 功能。 ✅
2. 列举功能性需求与非功能性需求。 ✅
3. 选择至少三个主要功能。 ✅
4. 将功能分解为用户故事。 ✅
5. 在 GitHub 创建 Projects 项目看板，并关联 Teedy 仓库。 ✅
6. 将用户故事添加至 User Story 栏。 ✅
7. 将用户故事拆分成可执行任务，添加至 Todo 栏。 ✅
8. 设置 In Progress 和 Done 栏，记录实际执行进度。 ✅

## 分步操作过程

### 1. 基于真实源码梳理功能

不凭空编造需求，而是从 Teedy 真实源码入手：
- 分析 REST 资源层 **17 个 Resource 类** + 前端控制器 + DAO。
- 选定三大核心功能：**文档上传与版本管理、文档检索、文档管理（含标签与权限）**。

### 2. 需求分类

- **功能性需求**：文档上传/下载、版本管理、全文检索（OCR + 索引）、标签、权限控制等。
- **非功能性需求**：性能（检索响应）、安全（鉴权）、可扩展性（插件/模块化）、可维护性等。

### 3. 分解用户故事与任务

- 分解出 **11 个用户故事（US-1 ~ US-11）** 与 **11 个可执行任务（T-1 ~ T-11）**，见 `reports/requirements-analysis.md`。

### 4. 在 GitHub Projects 创建看板

由于本地无 `gh` CLI 与可用 GitHub API token，改为在 GitHub 网页端手动创建看板（我提供完整分步指引 `reports/scrum-board-guide.md`），操作后截图归档。

**关键操作要点**：
- 必须从 **Teedy 仓库的 Projects 页**创建，确保关联 `tangx2872-svg/Teedy`（而非用户级 Projects）。
- 添加卡片用 **「Create a draft」（Ctrl+D）**，而非「Create new issue」（后者会产生仓库 Issue）。
- 多张卡片须**逐条粘贴 + 回车**，一次性粘贴多条会合并成一张长卡片。

### 5. 录入看板并记录进度

- 将 11 个用户故事录入 User Story 栏，拆分的任务录入 Todo 栏。
- 设置 In Progress / Done 栏，把正在做与已完成的任务移动到对应列。

## 结果验证

- 看板共 **22 张草稿卡片**（US×11 + Todo×8 + InProgress×2 + Done×1），仓库 Issue 新增 0（草稿卡片不产生 Issue）。
- 看板地址：https://github.com/users/tangx2872-svg/projects/4

## 问题与解决（关键踩坑）

| 问题 | 原因 | 解决方法 |
| --- | --- | --- |
| 无法自动创建看板 | 无 `gh` CLI、无可用 token（credential manager 仅存 git 专用 HTTPS 凭证） | 改由用户网页端手动创建，我提供分步指引 + 截图归档 |
| 误用「Create new issue」 | 点栏内 `+` 后选了第一个选项 | 改用「Create a draft」（Ctrl+D） |
| 多条变一张长卡片 | 多条文字粘进同一输入框 | 逐条粘贴 + 回车 |
| 看板关联错仓库 | 在用户级 Projects 入口创建 | 从 Teedy 仓库 Projects 页创建 |

## 相关目录

- `screenshots/`：看板与操作截图
- `reports/requirements-analysis.md`：需求分析报告（功能/非功能需求 + 用户故事分解）
- `reports/scrum-board-guide.md`：看板操作指引
- `reports/scrum-board-result.md`：看板完成记录
- `notes.md`：问题与解决
