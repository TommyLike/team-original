# Knowledge Exploration Pipeline — Claude Code Orchestration Guide

**You are Claude Code.** This file is your orchestration guide for running the knowledge exploration pipeline (Steps 0-4). The pipeline produces a **comprehensive knowledge report** that lets the user master a domain through reading + follow-up conversation.

When the user asks you to run the pipeline (or resume it), follow these steps in order.

**Before starting any step**, confirm model assignments with the user (see "Model confirmation").

---

## Pipeline overview

```
Step 0: Topic Architect (Opus) → artifacts/00-question-map.md
  → STOP: show question map + blind-spot checklist, wait for user confirmation
        ↓
Step 0.5: Source Material Gathering (Claude Code directly, MANDATORY for
          open-source projects) → reference/source-material.md
          git clone --depth 1 to reference/src/, read key design docs, run
          one audit, count code, inventory test infra. Per technology-outline.md
          取材方法. SKIP if no public source repo.
        ↓
Step 1: Multi-Perspective Research (4 parallel Agent subagents, Sonnet)
  ├── History & Evolution   → artifacts/01a-research-history.md
  ├── Concepts & Frameworks → artifacts/01b-research-concepts.md
  ├── Current Landscape     → artifacts/01c-research-landscape.md
  └── Depth & Critique      → artifacts/01d-research-critique.md
  All four MUST read reference/source-material.md if it exists.
        ↓
Step 2: Synthesis (Claude Code writes directly) → artifacts/01-research.md
  → STOP: show synthesis + Knowledge Gap Map + surfaced key papers.
    Ask the user whether to run an (optional) paper deep-dive. Wait for go-ahead.
        ↓
Step 2.5 (OPTIONAL — only if the user opts in): Paper Deep-Dive (Sonnet)
  → Same paper-analyst agent as the tech pipeline. Reads seed papers via
    read-arxiv-paper + arxiv-paper-translator skills, writes Chinese
    translations to papers/<id>-zh.md and analysis to artifacts/01e-paper-analysis.md.
        ↓
Step 3: Devil's Advocate (Agent subagent, Sonnet) → artifacts/02-challenges.md
  → THIS IS A COVERAGE AUDIT, not an attack on recommendations.
    The DA identifies missing perspectives, oversimplifications, weak sources,
    neglected counter-narratives, and cultural/regional biases.
        ↓
Step 4: Knowledge Report Writer (Agent subagent, Opus) → artifacts/03-report.md
  → Reads 01-research.md + 02-challenges.md. Incorporates DA-identified gaps
    directly into the report (no accept/rebut cycle — the gaps ARE the content).
  → For TECHNICAL topics the writer also applies docs/rule.md craft (§2/§3/§4).
        ↓
Step 4b (OPTIONAL — 技术文章模式, only if the user opts in): Focused Article
  → Reuse knowledge-report-writer (Opus) in ARTICLE mode. From the research, pick
    ONE concrete 困惑 and write a single-thread 病→药→效→托 technical article per
    docs/rule.md §0 → artifacts/03-article.md. This is a DIFFERENT deliverable
    from the encyclopedic report (intuition-building, not coverage).
        ↓
Step 4.5: Writing Critic (Agent subagent, Sonnet) → artifacts/04-writing-critique.md
  → WRITING-CRAFT DA on the produced markdown (report AND, if generated, article).
    Audits against the right standard: technical → docs/rule.md; general/narrative
    → docs/boss_dai/dai-writing-style.md. Emits BLOCKER / IMPROVE findings + PASS/REVISE.
  → GATE: if REVISE, the writer fixes the blockers and re-run the critic. Only
    proceed once the markdown PASSES. (两边 markdown 没问题才继续。)
        ↓
Step 5 (OPTIONAL — only if the user opts in): Visual Enhancer (Sonnet)
  → Scans 03-report.md → identifies 5-8 image slots → for each:
    • Search (Wikipedia / official sites / authoritative blogs / Wikimedia):
      historical photos, product images, real data charts, maps, portraits
    • AI generate (ai-image-generator skill via Gemini/GPT Image):
      concept diagrams, timelines, comparisons, cross-sections —
      only when no real photo exists. Uses 5-part prompting framework.
  → Saves images to images/ → embeds into artifacts/03-report-illustrated.md
        ↓
→ DONE: Tell the user:
  "Knowledge report ready: artifacts/03-report.md
   (If you opted into visuals: artifacts/03-report-illustrated.md with images/)
   You can now ask me anything about this topic — I have the full research context.
   For a PDF: say 'render the report as PDF'."
```

---

## Model confirmation

**Do this before Step 0.** Show the user the default model for each agent:

| Step | Agent | Default model |
|---|---|---|
| 0 | Topic Architect | opus |
| 0.5 | Source Material Gathering (for repos with source) | *(Claude Code directly)* |
| 1a-1d | Researchers (x4, parallel) | sonnet |
| 2.5 | Paper Analyst (optional) | sonnet |
| 3 | Devil's Advocate | sonnet |
| 4 | Knowledge Report Writer | opus |
| 4b | Focused Article (技术文章模式, optional) | opus |
| 4.5 | Writing Critic (writing-craft DA) | sonnet |
| 5 | Visual Enhancer (optional) | sonnet |

Ask: *"These are the default models. Reply 'confirm' to use them, or tell me any changes."*

Wait for the user's reply. Then **immediately write `artifacts/00-pipeline-log.md`** (do NOT leave it as a bare header — a stale/empty log is what makes the writing-critic and visual-enhancer pick the wrong standard and emit English labels on a Chinese report). Record at minimum:

```
artifact-language: <zh | en | ...>   # from input.md's language preference
article-type: <technical | general>  # inferred from the topic; refine at Step 4.5
model-<agent>: <confirmed>            # one line per agent
```

Keep this file updated at every step (see Pipeline log section). `artifact-language` and `article-type` MUST be present before any downstream agent (devil's-advocate, writer, writing-critic, visual-enhancer) runs.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| 0 | topic-architect | opus | input.md | artifacts/00-question-map.md |
| 0.5 | *(Claude Code directly, for repos with source)* | — | technology-outline.md + repo URL from input.md | reference/source-material.md + reference/src/ |
| 1a | researcher-history | sonnet | input.md + 00-question-map.md (+ reference/source-material.md if exists) | artifacts/01a-research-history.md |
| 1b | researcher-concepts | sonnet | input.md + 00-question-map.md (+ reference/source-material.md if exists) | artifacts/01b-research-concepts.md |
| 1c | researcher-landscape | sonnet | input.md + 00-question-map.md (+ reference/source-material.md if exists) | artifacts/01c-research-landscape.md |
| 1d | researcher-critique | sonnet | input.md + 00-question-map.md (+ reference/source-material.md if exists) | artifacts/01d-research-critique.md |
| 2 | *(Claude Code directly)* | — | 01a/b/c/d + input.md + 00-question-map.md | artifacts/01-research.md |
| 2.5 | paper-analyst (optional) | sonnet | user-supplied paper list + 01-research.md | artifacts/01e-paper-analysis.md + papers/<id>-zh.md |
| 3 | devils-advocate | sonnet | 01-research.md + input.md | artifacts/02-challenges.md |
| 4 | knowledge-report-writer | opus | 01-research.md + 02-challenges.md + input.md (+ docs/rule.md if technical) | artifacts/03-report.md |
| 4b | knowledge-report-writer (ARTICLE mode, optional) | opus | 01-research.md + docs/rule.md | artifacts/03-article.md |
| 4.5 | writing-critic | sonnet | 03-report.md (+ 03-article.md) + docs/rule.md OR docs/boss_dai/dai-writing-style.md | artifacts/04-writing-critique.md |
| 5 | visual-enhancer (optional) | sonnet | 03-report.md | artifacts/03-report-illustrated.md + images/ |

---

## How Claude Code runs agents

Use the **Task tool** (or Agent subagent) to spawn each subagent. The subagent reads its instruction file from `agents/<name>/CLAUDE.md`, reads its inputs, writes its output, and returns.

Template prompt:
```
Read agents/<name>/CLAUDE.md for your full instructions.
Project root: <absolute path to this project>
Report language: <confirmed, e.g. Chinese>
[any additional context]
```

**Step 1 is the only parallel step**: launch all four researcher subagents in a single message.

All other steps are sequential: verify the previous artifact exists and is non-empty before launching the next agent.

---

## Detailed steps

### Step 0 — Topic Architect

Agent: `topic-architect`, model: opus.
Input: `input.md`. Output: `artifacts/00-question-map.md`.

The agent decomposes the broad topic into a comprehensive question map covering all knowledge dimensions. It prints a formatted STOP block.

For **technology / open-source project** subjects, the agent also cross-checks the scope against `reference/technology-outline.md` (a MECE due-diligence checklist: 定位 / 原理 / 质量 / 可持续) so the research covers the easily-missed items (license, bus factor, threat model, dependency supply chain). This governs research **coverage**; writing craft is handled later by `docs/rule.md`.

**→ STOP**: Show the user the question map and blind-spot checklist. Ask for corrections or additions. If the user provides expert knowledge, write it into `artifacts/00-expert-input.md`. Wait for "go" before Step 0.5.

### Step 0.5 — Source Material Gathering (MANDATORY for projects with source repos)

**Only run this step if the topic is an open-source project / tool with a public source repository.** Skip if the topic is a pure concept, market, or theory with no code repo.

Read `reference/technology-outline.md` 取材方法 section. Its mandate: ② 原理 (architecture / core mechanism / tech stack) and ③ 质量 (test coverage / code quality / dependency audit) **cannot be filled from web-only research** — researchers need ground-truth from the actual repository.

**Execution (Claude Code directly, no subagent):**

1. **Clone**: `git clone --depth 1 <repo-url> reference/src/`. If the repo URL is not in `input.md`, ask the user for it.
2. **Read key design docs** (in priority order, skip files that don't exist):
   - `README.md`, `CHANGELOG.md`, `SECURITY.md`, `CONTRIBUTING.md`, `GOVERNANCE.md`, `CODEOWNERS`
   - `docs/` top-level (list files, read the 5 most relevant)
   - `ARCHITECTURE.md`, `DESIGN.md`, `ROADMAP.md`, `rfcs/`, `proposals/`
3. **Run one audit** (best effort, don't block on failure):
   - `npm audit --production` / `cargo audit` / `pip-audit` / `trivy fs .` — whichever fits the project's ecosystem
4. **Count code** (best effort): `cloc .` or `tokei .` or a quick `find . -name '*.ts' | xargs wc -l` — capture total lines, test lines, test/source ratio.
5. **Inventory test infrastructure**: CI config file, test framework name, coverage badge presence.
6. **Write `reference/source-material.md`** with:
   - Key design docs read and their main architectural claims
   - Audit result (pass/audit npm score/vulnerability count — or "no audit tool available")
   - Code scale (total lines, test lines, language breakdown)
   - Test infrastructure summary
   - Notable findings from docs/code that web research would miss

This artifact becomes a **mandatory input for all four Step 1 researchers** — they must read it before writing their output. It puts ground-truth under ② 原理 and ③ 质量, where web-only research hits a ceiling.

**Quality gate**: `reference/source-material.md` must exist and contain concrete numbers or observations from the clone (not just "docs exist"). If the clone or audit fails, record the failure reason in the artifact — don't skip the step silently.

**→ STOP**: tell the user what was gathered (repo size, key docs found, audit result). Then proceed to Step 1.

### Step 1 — Multi-Perspective Research (parallel)

Launch all four researchers simultaneously. Pass the question map, any expert input, and — **if Step 0.5 produced `reference/source-material.md` — that file to every researcher** (the researcher agents don't auto-discover it; you must explicitly tell them to read it). Each researcher must ground ② 原理 and ③ 质量 findings in the cloned material where applicable, not purely in web sources.

Quality gate after all four complete:
- Each artifact must contain specific facts, named sources, dates, or URLs.
- Each must address at least the sub-questions in `00-question-map.md` that fall within its lens.
- If any artifact is vague or thin, rerun that researcher with a focused prompt.

### Step 2 — Synthesis (Claude Code writes directly)

Read the four research artifacts plus `input.md` and `00-question-map.md`. Write `artifacts/01-research.md`:
1. Executive summary (the 3-minute version of this domain)
2. History & evolution (timeline, key milestones, pivotal moments)
3. Core concepts & frameworks (how to think about this domain)
4. Current landscape (who/what is important now, active debates)
5. Depth & critique (controversies, limitations, counter-narratives)
6. Conflicts and open questions (where researchers disagreed)
7. Source list
8. **Knowledge Gap Map** (every sub-question from 00-question-map, with coverage assessment)

Also extract a **Key Papers** list from the research for the paper deep-dive option.

**→ STOP**: Show the synthesis summary + Knowledge Gap Map + Key Papers. Ask:
- Expert gap-fill?
- Paper deep-dive? (only offer if papers were surfaced)
- Reply "go" to proceed.

### Step 2.5 — Paper Deep-Dive (OPTIONAL)

Same paper-analyst agent and workflow as the `tech` pipeline. Agent reads `agents/paper-analyst/CLAUDE.md`. Launched only if the user opts in.

After the agent returns, merge key findings into `01-research.md` under `## Paper Deep-Dive (added at Step 2.5)`.

### Step 3 — Devil's Advocate (coverage audit)

Agent: `devils-advocate`, model: sonnet.
Input: `artifacts/01-research.md` + `input.md`. Output: `artifacts/02-challenges.md`.

**This DA is a knowledge-coverage auditor, NOT a recommendation attacker.** Its job is to find what the research MISSED — missing perspectives, oversimplified narratives, weak sources, neglected counter-arguments, cultural/regional biases. See the agent's CLAUDE.md for the full checklist. For **technology / open-source project** subjects, also audit coverage against `reference/technology-outline.md` — flag any of its dimensions (定位 / 原理 / 质量 / 可持续, esp. license, bus factor, threat model, supply chain) the research left thin.

No STOP here — the report writer incorporates DA findings directly. But do verify `artifacts/02-challenges.md` exists and is non-empty before proceeding.

### Step 4 — Knowledge Report Writer

Agent: `knowledge-report-writer`, model: opus.
Input: `artifacts/01-research.md` + `artifacts/02-challenges.md` + `input.md`.
Output: `artifacts/03-report.md` — the final knowledge report.

The report writer reads the DA's coverage audit and incorporates identified gaps directly into the report. There is no accept/rebut cycle — the gaps and missing perspectives ARE content that enriches the report.

For **technical topics**, the writer also reads `docs/rule.md` and applies its structure/explanation/rigor craft (§2/§3/§4) while writing.

**→ STOP (offer focused article)**: The encyclopedic report is ready. Ask the user:
"要不要再产出一篇**聚焦技术文章**？报告是百科式的全覆盖；技术文章模式会从研究里挑**一个具体困惑**，
按 `docs/rule.md` 的 病→药→效→托 骨架写成一篇能建立直觉的单线文章（`artifacts/03-article.md`）。"

If the user opts in, run **Step 4b**. Either way, then run **Step 4.5** (the writing-craft DA gate) on whatever markdown exists before offering visuals.

### Step 4b — Focused Article (OPTIONAL — 技术文章模式)

Agent: `knowledge-report-writer` in **ARTICLE mode**, model: opus.
Input: `artifacts/01-research.md` + `docs/rule.md`. Output: `artifacts/03-article.md`.

Prompt the agent to IGNORE the 7-section report structure and instead:
1. Pick ONE concrete 困惑 from the research worth a single article.
2. Write it on the 病→药→效→托 skeleton (`docs/rule.md` §0): 具体场景开篇 (病) → 一个贯穿设问 (承) → 自底向上拆机制 + 给证据 (药+效) → 诚实信任状 + 回扣升华到可迁移直觉 (托/合).
3. Apply §2/§3/§4/§5 craft. Mark image slots as `<!-- IMG: <slug> -->` for the visual enhancer.

### Step 4.5 — Writing Critic (writing-craft DA gate)

Agent: `writing-critic`, model: sonnet.
Input: the produced markdown (`artifacts/03-report.md`, and `artifacts/03-article.md` if Step 4b ran) + the matching standard. Output: `artifacts/04-writing-critique.md`.

The critic reads `agents/writing-critic/CLAUDE.md`, picks the standard by article type
(technical → `docs/rule.md`; general/narrative → `docs/boss_dai/dai-writing-style.md`),
and emits BLOCKER / IMPROVE findings + a `PASS` / `REVISE` verdict.

**This is a GATE**: if the verdict is `REVISE`, hand the blockers back to the writer
(re-run Step 4 / 4b with the critique as additional input), then re-run the critic.
**Only proceed once the markdown PASSES** — 成稿两边 markdown 没问题才继续。

Before running, record the `article-type` (technical / general) in `artifacts/00-pipeline-log.md` so the critic and visual-enhancer pick the right standard.

**→ STOP (offer visual enhancement)**: Once PASSED, ask the user:
"Do you want visual enhancement? I can scan the report for 5-8 places where images would add value — historical photos, product images, and real data charts via search (Wikipedia/official sites), plus AI-generated concept diagrams and timelines for abstract structures. This produces `artifacts/03-report-illustrated.md` with embedded images."

If the user opts in, run **Step 5** below before the final done. If not, the report is complete as-is.

### Step 5 — Visual Enhancement (OPTIONAL — only if the user opted in)

Agent: `visual-enhancer`, model: sonnet.
Input: `artifacts/03-report.md` **and `artifacts/03-article.md` if Step 4b produced one**. Output: `artifacts/03-report-illustrated.md` (+ `artifacts/03-article-illustrated.md` if an article exists) + images saved to `images/`.

The agent reads `agents/visual-enhancer/CLAUDE.md` for its full instructions. For **each** deliverable it: (1) generates a **mandatory cover** right after the title — for a **technical** topic the cover AND every diagram follow the `docs/image-style.md` "技术蓝墨" spec (flat, white, restrained palette — never a glossy/3D/dark poster); (2) identifies 5-8 content slots, preferring **real** images (paper diagrams, official-blog figures, Wikipedia/Wikimedia — ~70%) and AI-generating concept diagrams only when no real figure exists (~30%); (3) embeds everything with centered `<div align="center"><img width="XX%">` (never raw Markdown). Ensure `artifact-language` and `article-type` are in the pipeline log before launching, so the agent doesn't fall back to English labels or the wrong cover style.

**→ DONE**: Tell the user:
- "Knowledge report ready: `artifacts/03-report.md`"
- If visuals were generated: "Illustrated version: `artifacts/03-report-illustrated.md` with images in `images/`"
- "You can now ask me anything about this topic — I have the full research context."

---

## Output options (report + optional PDF)

The canonical output is `artifacts/03-report.md`. For PDF, use the same HTML→Chromium recipe as the research/tech pipelines:

**PDF generation recipe (MUST follow exactly):**
Convert `03-report.md` → HTML → PDF via headless Chromium. **Do NOT use weasyprint** (cannot parse variable/TTC CJK fonts).

1. Convert MD to HTML: `pandoc artifacts/03-report.md -o artifacts/05-report.html --standalone`
2. Embed a CSS font stack (these fonts are installed system-wide by init-pipeline.sh):
   - CJK: `'Source Han Serif SC', 'Source Han Serif SC VF', 'PingFang SC', 'Noto Sans CJK SC', serif`
   - Latin: `'Source Serif 4', Georgia, serif`
   - **Image caption / figure typography (MUST)**: image captions must render lighter, italic, and slightly smaller than body text; figure/section titles stay bold. Add this CSS: `figure figcaption, .fig-caption, p > em:only-child { font-weight: 300; font-style: italic; font-size: 0.85em; color: #555; }` and `h1,h2,h3,h4 { font-weight: 700; }`. Latin (Source Serif 4) ships real Light + Italic font files (installed system-wide); CJK (思源宋体 VF) supplies the light weight via its variable weight axis but has no true italic, so Chromium synthesizes an oblique slant — acceptable for captions.
3. Storytelling tone (ONLY if a narrative / 有故事性 report is wanted) — **story-line selection is a GATE; do NOT jump straight into rewriting the prose**:
   a. **Derive 3-4 candidate story-lines** from `03-report.md`. Each candidate = a one-line hook (钩子) + the through-question (贯穿设问) it drives + which report sections feed it. Every story-line MUST reduce to material already in the report — do not invent facts to make a better story.
   b. **STOP and show the candidates to the user.** Ask them to pick one primary spine (optionally braid a second) or supplement their own angle. Wait for their choice before writing any narrative prose.
   c. Only after the user confirms, follow `docs/STORYTELLING-REFERENCE.md`. The style guide and article corpus are bundled in `docs/boss_dai/` — read them directly, do NOT ask the user where to get reference articles. Read the guide, then 5 topic-matched articles, draft style-application notes, then write the narrative sections around the confirmed story-line. Keep all facts and numbers exact.
4. **MUST** include rights footer on every page: render `docs/rights.template.md` as a fixed running footer, replacing the `<#...>` placeholder with the model names actually used this run (from the agent→model rows in `artifacts/00-pipeline-log.md`, e.g. `Claude Opus 4.8, Claude Sonnet 4.6`). **This step is mandatory — do NOT skip.**
5. Render: `npx playwright pdf artifacts/05-report.html artifacts/05-report.pdf` (or headless Chromium `--print-to-pdf`).
6. **MUST** verify ALL of: (a) no tofu □ boxes, (b) table borders intact, (c) **rights footer visible on every page** (re-run step 4 if missing).

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md`. Record each step with timestamp, confirmed settings, expert input.

---

## Rules

1. Always announce which step you are starting and what it will produce.
2. Never start Step 1 until the user confirms the question map (Step 0 stop).
3. Never start Step 3 until the user confirms the synthesis (Step 2 stop).
4. The final deliverable is `artifacts/03-report.md` — no PPT, no recommendations. (技术文章模式 additionally produces `artifacts/03-article.md`.)
5. Verify each artifact exists and is non-empty before starting the next step. EXCEPTION: `artifacts/01e-paper-analysis.md` is optional.
6. Step 2.5 (Paper Deep-Dive) and Step 4b (技术文章模式) run ONLY if the user opts in.
7. Step 4.5 (Writing Critic) is a MANDATORY GATE, not optional: never proceed to Step 5 / PDF while the writing-critic verdict is `REVISE`. Loop writer → critic until `PASS`.
8. Never modify existing artifacts from completed steps without telling the user first.
9. To resume a partial run, read `artifacts/00-pipeline-log.md` and `CLAUDE-RESUME.md`.
