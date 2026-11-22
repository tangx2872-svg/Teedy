# 实验七：CI/CD

## 状态

🟡 进行中（GitHub Actions 已跑通全部阶段；最终结论因 3 个上游基线测试失败而如实标红）

## 实验任务

分别使用 Jenkins 和 GitHub Actions 为 Teedy 设置持续集成流水线，流水线包含：

- Maven 构建
- PMD 代码检查
- 自动化测试
- Surefire 测试报告
- JavaDoc 文档生成
- 可执行 JAR 和相关构建制品归档

创建 Jenkinsfile 和 GitHub Actions workflow，通过实际提交验证流水线是否运行成功。

## 交付物

| 文件 | 说明 |
| --- | --- |
| `Jenkinsfile` | 声明式 Pipeline（构建/PMD/测试/JaCoCo/JavaDoc/归档） |
| `.github/workflows/ci.yml` | GitHub Actions 流水线（push/PR/workflow_dispatch 触发） |
| `pom.xml` | 新增 `maven-pmd-plugin`（bestpractices+errorprone，非阻断） |
| `notes.md` | 问题与解决（测试策略、PMD 定位） |
| `reports/` | 流水线运行报告 |

## 关键决策

1. **测试如实运行**：3 个上游基线测试失败（MimeTypeUtil/PDFBox）不做降级，
   流水线如实红灯，体现真实拦截能力（用户确认）。
2. **PMD 先观察后门禁**：完整规则集有 3028 个风格类违规，收窄为
   bestpractices+errorprone 且 `failOnViolation=false`，只出报告不阻断。

## 验证结果

- 本地命令链全部验证通过（见 `notes.md` 第四节）。
- GitHub Actions 三次迭代（`fe2b6342` → `4b58a8f9` → `f69576cf`）已跑通全部
  阶段，最终如实标红（上游 3 个基线测试失败），详见 `reports/ci-pipeline-report.md`。

## 相关目录

- `reports/`：流水线运行报告
- `notes.md`：问题与解决
