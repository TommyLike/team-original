# 技术调研对象
[Name the specific technology / approach / product to assess]

# 背景与目的
[Why this assessment matters — what decision it will inform, what problem it addresses]

# 对比范围
[Competitors / alternatives / substitute technologies to compare against]

# 关注重点
[Which lenses matter most and any specifics:
 技术领先性 (leadership & maturity) / 竞品对比 (competitive) / 趋势推断 (trend) / 关键难点 (challenges)]

# 参考信息
[URLs, repos, papers, benchmarks, standards, docs to consult]

# Output type
output_type: report | decision | learning | sharing
report (默认) — 正式评估报告，含结论和建议
decision — 决策支持，方案对比和推荐
learning — 个人学习总结，关注方法收获
sharing — 知识分享，关注亮点和讨论

# Style (optional)
style: [exact skill name or keyword, or leave blank for defaults]

# 调研要求
[Depth, audience, language, citation style, trend time-horizon, etc.]

# Source materials (input/)
Place raw materials in the `input/` directory, organized by type:
- `input/pdf/` — PDF papers, reports, documentation
- `input/web/` — web page snapshots (Markdown format)
- `input/repo/` — git repository clones or references

See `input/README.md` for the full manifest. Agents will discover,
save, and catalog materials here throughout the pipeline.
