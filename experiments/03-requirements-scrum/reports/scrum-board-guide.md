# 实验三：GitHub Projects 看板操作指引

> 学号：1260101027；姓名：汤鑫。按此指引在 GitHub 网页创建看板，操作完截图存档。

## 一、创建看板（Projects）

1. 打开你的仓库：https://github.com/tangx2872-svg/Teedy
2. 顶部点击 **Projects** 标签页。
3. 点击 **New project**（新建项目）。
4. 选择模板：**Board**（看板视图）——这正是 Scrum 需要的三栏看板。
5. 项目名称建议填：`Teedy - 智能软件工程实验` 或 `Teedy Scrum Board`。
6. 点击 **Create project** 完成创建。
7. 确认看板已自动**关联 Teedy 仓库**（Projects 创建于仓库下即自动关联）。

## 二、配置看板栏（Status 字段）

看板模板默认有 `Todo`、`In Progress`、`Done` 三栏。按教材要求增加 `User Story` 栏：

1. 点击看板右上角 **+ New column / 栏设置**（或在 Status 字段下拉里 **Edit options**）。
2. 新增一栏，命名为 **User Story**，并把它拖到最左侧（第一栏）。
3. 最终栏顺序应为：**User Story → Todo → In Progress → Done**。

> 提示：GitHub Projects (v2) 的栏由「Status」字段的选项驱动。若默认只有 Todo/In Progress/Done，需要在 Status 字段设置里添加 `User Story` 选项。

## 三、录入用户故事（User Story 栏）

在 **User Story** 栏新建以下条目（标题用「US-N」前缀，正文可写「作为…我想要…以便…」）：

1. US-1 用户上传文件（PDF/图片/Office）
2. US-2 查看文件历史版本
3. US-3 上传文档新版本
4. US-4 重命名已上传文件
5. US-5 关键词全文搜索
6. US-6 按标签筛选文档
7. US-7 多条件组合筛选
8. US-8 创建/编辑文档
9. US-9 为文档添加标签
10. US-10 设置文档访问权限
11. US-11 删除文档

## 四、录入可执行任务（Todo 栏）

在 **Todo** 栏新建以下条目（关联到对应用户故事，可用 Issue 或直接作为 item）：

1. T-1 实现文件上传接口与存储
2. T-2 实现文件版本记录与列表查询
3. T-3 实现新版本上传与覆盖逻辑
4. T-4 实现文件重命名
5. T-5 实现全文索引与关键词搜索
6. T-6 实现按标签筛选查询
7. T-7 实现多条件组合查询
8. T-8 实现文档创建/编辑表单
9. T-9 实现文档标签关联
10. T-10 实现 ACL 权限配置界面
11. T-11 实现文档删除与回收

## 五、模拟执行进度（In Progress / Done）

为体现 Scrum 实际执行进度，把部分任务移动：

- 移动 2~3 个任务到 **In Progress**（如 T-1、T-5、T-8，表示「正在实现」）。
- 移动 1~2 个已完成的到 **Done**（如 T-2「版本记录」、T-6「标签筛选」，Teedy 源码中已有实现）。

> 说明：Teedy 是成熟开源项目，上述功能源码中已基本实现。此处以「需求分析 + 看板管理」演示 Scrum 流程，不必真的写新代码。

## 六、截图清单

操作完成后，请截取并保存以下截图（放到 `experiments/03-requirements-scrum/screenshots/`）：

1. **看板全貌**：四栏（User Story / Todo / In Progress / Done）+ 各条目。
2. **关联仓库确认**：看板显示关联 Teedy 仓库的位置（Projects 页面顶部或设置）。
3. **单个用户故事详情**：展开任意 US 条目，展示标题与描述。

截图文件命名建议：`board-overview.png`、`board-repo-link.png`、`user-story-detail.png`。

## 七、完成后的操作

截图保存好后告诉我，我会：
1. 把截图归档到 `experiments/03-requirements-scrum/screenshots/`。
2. 更新实验三 README、notes.md、PROGRESS.md。
3. 提交并推送实验三记录到 GitHub。
