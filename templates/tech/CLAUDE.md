## Session startup (ALWAYS run first — before any response)
## Session startup (ALWAYS run first)

When your session starts:
1. Read `CLAUDE-RESUME.md` for current status.
2. Check `input/README.md` for new materials.
3. Act: Complete->offer supplement/refresh, In-progress->offer resume, Fresh->wait.

---

# Technology Assessment Pipeline Orchestrator

Multi-agent tech assessment pipeline (11 agents, 7 steps). 4 lenses -> analysis -> canonical report + optional PDF/PPTX.

---

## Pipeline overview

Step 0: Tech Question Architect -> STOP: confirm -> Step 1: 4x parallel researchers (leadership, competitive, trend, challenges) -> Step 2: Synthesis + Gap Map STOP: fill gaps / opt into paper or repo deep-dive -> Step 2.5 (optional): Paper Analyst -> Step 2.6 (optional): Repo Analyst -> Step 3: Tech Analyst -> Step 4: Devil's Advocate -> Step 5: Tech Analyst revision STOP: expert input -> Step 6: Report Writer -> artifacts/03-report.md -> Step 7 (optional): Narrative Architect -> STOP -> PPTX via Cowork

Output formats: Markdown (always) / PDF / PPTX. User selects at Step 6.

**Source materials**: `input/README.md` -- check before each step.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| 0 | tech-question-architect | opus | input.md + input/README.md | artifacts/00-question-map.md |
| 1a | researcher-leadership | sonnet | input.md + input/README.md + 00-question-map.md | artifacts/01a-research-leadership.md |
| 1b | researcher-competitive | sonnet | input.md + input/README.md + 00-question-map.md | artifacts/01b-research-competitive.md |
| 1c | researcher-trend | sonnet | input.md + input/README.md + 00-question-map.md | artifacts/01c-research-trend.md |
| 1d | researcher-challenges | sonnet | input.md + input/README.md + 00-question-map.md | artifacts/01d-research-challenges.md |
| 2 | *(Claude Code directly)* | -- | 01a/b/c/d + 00-question-map + input/README.md | artifacts/01-research.md |
| 2.5 | paper-analyst (optional) | sonnet | seed paper list + 01-research.md | artifacts/01e-paper-analysis.md + papers/<id>-zh.md |
| 2.6 | repo-analyst (optional) | sonnet | repo URL(s) + 01-research.md | artifacts/01f-repo-analysis.md |
| 3 | tech-analyst | opus | 01-research.md + input.md + input/README.md | artifacts/02-analysis.md |
| 4 | devils-advocate | sonnet | 02-analysis + 01-research + input/README.md | artifacts/02a-challenges.md |
| 5 | tech-analyst (revision) | opus | 02a-challenges + 02-analysis + input/README.md | artifacts/02-analysis-final.md |
| 6 | report-writer | opus | 02-analysis-final + 01-research + input.md | artifacts/03-report.md |
| 7 | narrative-architect (optional) | sonnet | 03-report.md + input.md + input/README.md | artifacts/04-narrative.md + artifacts/04-diagram-specs.md |

---

## How to run agents

Use **Agent** tool subagents. Include absolute project path:
```
Read agents/<name>/CLAUDE.md for your full instructions.
Project root: <absolute path>
```

**Step 1 is the only mandatory parallel step** -- launch all 4 researchers simultaneously. Steps 2.5/2.6 may run in parallel with each other if both are opted into. All others sequential.

---

<important if="you are starting the pipeline for the first time or the user asks to change models">

## Model confirmation

| Step | Agent | Default |
|---|---|---|
| 0 | Tech Question Architect | opus |
| 1 | 4x Researchers (parallel) | sonnet |
| 2.5 | Paper Analyst (optional) | sonnet |
| 2.6 | Repo Analyst (optional) | sonnet |
| 3 | Tech Analyst (first pass) | opus |
| 4 | Devil's Advocate | sonnet |
| 5 | Tech Analyst (revision) | opus |
| 6 | Report Writer | opus |
| 7 | Narrative Architect (optional) | sonnet |

Record confirmed models and `output_type` from `input.md` in `artifacts/00-pipeline-log.md`:
```
output-type: <value from input.md, default: report>
```
Wait for reply before Step 0.
</important>

---

<important if="you are running Step 0 (Tech Question Architect)">

### Step 0: Tech Question Architect

Agent: `tech-question-architect` (opus). Input: `input.md`. Output: `artifacts/00-question-map.md`.

**-> STOP**. Show question map. Ask: "Proceed to research?"
</important>

---

<important if="you are running Step 1 (4-Lens Research)">

### Step 1: 4x Parallel Research

Launch leadership, competitive, trend, challenges researchers (all sonnet) simultaneously.
</important>

---

<important if="you are running Step 2 (Synthesis)">

### Step 2: Synthesis

Write `artifacts/01-research.md` directly. Structure: executive summary, key findings, data, comparable cases, conflicts, source list, **Knowledge Gap Map**, key papers surfaced.

**-> STOP**. Show summary + gap map. Ask: "Expert knowledge to fill gaps? Run an optional paper deep-dive (arXiv) or repo deep-dive (GitHub)?"
</important>

---

<important if="the user opts into a paper deep-dive at the Step 2 stop">

### Step 2.5: Paper Analyst (optional)

Agent: `paper-analyst` (sonnet). Input: seed paper list (from the user) + `artifacts/01-research.md`. Output: `artifacts/01e-paper-analysis.md` + `papers/<id>-zh.md`.
</important>

---

<important if="the user opts into a repo deep-dive at the Step 2 stop">

### Step 2.6: Repo Analyst (optional)

Agent: `repo-analyst` (sonnet). Runs only if the technology under assessment has a GitHub (or similar) code repository. Input: repo URL(s) + `artifacts/01-research.md`. Output: `artifacts/01f-repo-analysis.md`.
</important>

---

<important if="you are running Steps 3-5 (Analysis Loop)">

### Steps 3-5: Analysis Loop

- **Step 3**: `tech-analyst` (opus) -> `artifacts/02-analysis.md`
- **Step 4**: `devils-advocate` (sonnet) -> `artifacts/02a-challenges.md`
- **Step 5**: `tech-analyst` revision (opus) -> `artifacts/02-analysis-final.md`

**-> STOP at Step 5**. Show findings. Offer expert input window.
</important>

---

<important if="you are running Step 6 (Report Writer)">

### Step 6: Report Writer

Agent: `report-writer` (opus). Input: `artifacts/02-analysis-final.md` + `artifacts/01-research.md` + `input.md`. Output: `artifacts/03-report.md`.

**-> STOP**: ask user which output formats (multi-select): Markdown (always), PDF, PPTX. Record in pipeline log as `output-formats:`.
</important>

---

<important if="you are running Step 7 (Narrative Architect)">

### Step 7: Narrative Architect (optional — only if the user selected PPTX)

Agent: `narrative-architect` (sonnet). Input: `artifacts/03-report.md` + `input.md`. Output: `artifacts/04-narrative.md` + `artifacts/04-diagram-specs.md`.

**-> STOP**. Confirm narrative + diagram specs. Record artifact/slide language, PPTX template in pipeline log.
</important>

---

<important if="the user asks for PDF output">

### PDF generation recipe

Convert `03-report.md` → HTML → PDF via headless Chromium. **Do NOT use weasyprint** (cannot parse variable/TTC CJK fonts).

1. Convert MD to HTML: `pandoc artifacts/03-report.md -o artifacts/05-report.html --standalone`
2. Embed a CSS font stack (these fonts are installed system-wide by init-pipeline.sh):
   - CJK: `'Source Han Serif SC', 'Source Han Serif SC VF', 'PingFang SC', 'Noto Sans CJK SC', serif`
   - Latin: `'Source Serif 4', Georgia, serif`
   - **Image caption / figure typography (MUST)**: image captions must render lighter, italic, and slightly smaller than body text; figure/section titles stay bold. Add this CSS: `figure figcaption, .fig-caption, p > em:only-child { font-weight: 300; font-style: italic; font-size: 0.85em; color: #555; }` and `h1,h2,h3,h4 { font-weight: 700; }`. Latin (Source Serif 4) ships real Light + Italic font files (installed system-wide); CJK (思源宋体 VF) supplies the light weight via its variable weight axis but has no true italic, so Chromium synthesizes an oblique slant — acceptable for captions.
3. Storytelling tone (ONLY if a narrative / 有故事性 report is wanted): follow `docs/STORYTELLING-REFERENCE.md`. The style guide and article corpus are bundled in `docs/boss_dai/` — read them directly, do NOT ask the user where to get reference articles. Read the guide, then 5 topic-matched articles, draft style-application notes, then write the narrative sections. Keep all facts and numbers exact.
4. **MUST** include rights footer on every page: render `docs/rights.template.md` as a fixed running footer, replacing the `<#...>` placeholder with the model names actually used this run (from the agent→model rows in `artifacts/00-pipeline-log.md`, e.g. `Claude Opus 4.8, Claude Sonnet 4.6`). **This step is mandatory — do NOT skip.**
5. Render: `npx playwright pdf artifacts/05-report.html artifacts/05-report.pdf` (or headless Chromium `--print-to-pdf`).
6. **MUST** verify ALL of: (a) no tofu □ boxes, (b) table borders intact, (c) **rights footer visible on every page** (re-run step 4 if missing).
</important>

---

<important if="the user asks for PPTX output">

### PPTX output

Switch to Cowork: `Read COWORK.md and build the deck`. Diagrams: `artifacts/04-diagram-specs.md`. Template: recorded in pipeline log. Output: `artifacts/05-deck.pptx`.
</important>

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md`: step completion, settings, user edits, expert input.

---

<important if="you are starting, resuming, or proceeding between steps">

## Rules

- Announce each step before starting.
- Never start a step until previous STOP is confirmed.
- Verify each artifact exists and non-empty before next step.
- Parallel: Step 1 (mandatory), Steps 2.5/2.6 (if both opted in). All others sequential.
- Step 1 quality gate: every artifact must contain numbers/sources/URLs.
- Do not modify completed artifacts without telling user.
- Resume: read `artifacts/00-pipeline-log.md` + `CLAUDE-RESUME.md`.
- **Source materials**: check `input/README.md` before each step. Save discoveries to `input/` and update manifest.
</important>