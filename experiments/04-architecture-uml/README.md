# 实验四：软件架构与 UML

## 状态

✅ 已完成

## 实验任务

1. 分析 Teedy 的模块结构及 Java 包结构。 ✅
2. 为各包生成 UML 图。 ✅
3. 分析主要类及类之间的关系。 ✅
4. 解释主要模块及其交互过程。 ✅

## 工具

使用 PlantUML（`D:\tools\plantuml.jar`，1.2024.7）本地渲染，中文字体 SimHei。

## 产出清单

| 产出 | 文件 | 说明 |
| --- | --- | --- |
| 架构分析报告 | `reports/architecture-analysis.md` | 模块/包结构、类关系、交互流程 |
| 模块依赖图 | `diagrams/01-module-dependencies.puml` → `screenshots/module-dependencies.png` | Maven 多模块依赖 |
| 分层架构图 | `diagrams/02-layered-architecture.puml` → `screenshots/layered-architecture.png` | 四层架构 |
| 核心类图 | `diagrams/03-core-class-diagram.puml` → `screenshots/core-class-diagram.png` | REST→DAO→实体 |
| 上传时序图 | `diagrams/04-document-upload-sequence.puml` → `screenshots/document-upload-sequence.png` | 文档上传链路 |
| 问题记录 | `notes.md` | PlantUML 中文乱码等踩坑 |

## 相关目录

- `diagrams/`：可编辑的 PlantUML 源文件（.puml）
- `screenshots/`：渲染结果（.png）
- `reports/`：架构分析报告
- `notes.md`：问题与解决
