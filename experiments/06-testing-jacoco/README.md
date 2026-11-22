# 实验六：软件测试与覆盖率

## 状态

✅ 已完成

## 实验任务

1. 使用 Maven 运行全部测试。 ✅（23 测试，20 通过，3 失败如实记录）
2. 验证如何运行指定测试及跳过测试。 ✅（`-Dtest` / `-DskipTests`）
3. 生成 Surefire 测试报告。 ✅
4. 分析测试成功率及执行耗时。 ✅
5. 配置 JaCoCo Maven 插件。 ✅（0.8.11）
6. 生成测试覆盖率报告。 ✅
7. 分析模块、类及方法覆盖率。 ✅
8. 选择一个覆盖率较低的类，编写有效测试。 ✅（LocaleUtil，0% → 91.7%）
9. 重新运行 JaCoCo，对比覆盖率变化。 ✅

## 核心成果

- 配置 JaCoCo 插件（prepare-agent + report），生成覆盖率报告。
- 选择 0% 覆盖的 `LocaleUtil` 编写 4 个有效测试，行覆盖率提升至 91.7%。
- docs-core 总体行覆盖率 24.6% → 24.8%。

## 纪律要求

已遵守：记录真实测试结果（3 个基线失败如实记录，未编造、未虚增覆盖率）。

## 产出清单

| 产出 | 文件 |
| --- | --- |
| 测试与覆盖率报告 | `reports/testing-coverage.md` |
| 问题记录 | `notes.md` |
| 新增测试代码 | `docs-core/src/test/java/com/sismics/util/TestLocaleUtil.java` |

## 相关目录

- `reports/`：测试报告与覆盖率对比
- `notes.md`：问题与解决
