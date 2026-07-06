## Session startup (ALWAYS run first — before any response)
## Session startup (ALWAYS run first)

When your session starts:

1. Read `CLAUDE-RESUME.md` for current status.
2. Check `input/README.md` for new materials.
3. Act: Complete→offer supplement/refresh, In-progress→offer resume, Fresh→wait.

---

# Research Pipeline Orchestrator

Multi-agent research pipeline (10 agents, 7 steps). Generates research report + optional PDF/PPTX.

**Before starting**: confirm model assignments with user (see Model confirmation).

---

## Pipeline overview

```
Step -2: Value Assessor → STOP: GO/NO-GO → -1: Brainstorming → STOP: confirm → 
Step 0: Question Architect → STOP: confirm → Step 1: 3× parallel researchers → 
Step 2: Synthesis + Gap Map → STOP: fill gaps → Step 3: Analyst → 
Step 4: Devil's Advocate → Step 5: Analysis revision → STOP: expert input → 
Step 6: Report Writer → Step 7: Narrative Architect → STOP → OUTPUT
```

Output formats: Markdown (always) / PDF / PPTX. User selects at Step 7.

**Source materials**: `input/README.md` — check before each step.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| -2 | value-assessor | opus | input.md + input/README.md | artifacts/00-value-assessment.md |
| -1 | brainstorming | opus | input.md + input/README.md + 00-value-assessment.md | artifacts/00-brainstorm-output.md |
| 0 | question-architect | opus | input.md + input/README.md + 00-brainstorm-output.md | artifacts/00-question-map.md |
| 1a | researcher-technical | sonnet | input.md + input/README.md + 00-question-map.md | artifacts/01a-research-technical.md |
| 1b | researcher-strategic | sonnet | input.md + input/README.md + 00-question-map.md | artifacts/01b-research-strategic.md |
| 1c | researcher-contrarian | sonnet | input.md + input/README.md + 00-question-map.md | artifacts/01c-research-contrarian.md |
| 2 | *(Claude Code directly)* | — | 01a/b/c + input.md + input/README.md + 00-question-map.md | artifacts/01-research.md |
| 3 | analyst | opus | 01-research.md + input.md + input/README.md | artifacts/02-analysis.md |
| 4 | devils-advocate | sonnet | 02-analysis.md + 01-research.md + input.md + input/README.md | artifacts/02a-challenges.md |
| 5 | analyst (revision) | opus | 02a-challenges.md + 02-analysis.md + input/README.md | artifacts/02-analysis-final.md |
| 6 | report-writer | opus | 02-analysis-final.md + 01-research.md + input.md + input/README.md | artifacts/03-report.md |
| 7 | narrative-architect | sonnet | 03-report.md + input.md + input/README.md | artifacts/04-narrative.md + artifacts/04-diagram-specs.md |

---

## How to run agents

Use **Agent** tool subagents. Include absolute project path in every prompt:
```
Read agents/<name>/CLAUDE.md for your full instructions.
Project root: <absolute path>
```

**Step 1 is the only parallel step** — launch all 3 researchers in one message. All other steps are sequential: verify previous artifact exists before proceeding.

---

<important if="you are starting the pipeline for the first time or the user asks to change models">

## Model confirmation

Show user defaults, ask to confirm or change:

| Step | Agent | Default |
|---|---|---|
| -2 | Value Assessor | opus |
| -1 | Brainstorming | opus |
| 0 | Question Architect | opus |
| 1 | 3× Researchers (parallel) | sonnet |
| 3 | Analyst (first pass) | opus |
| 4 | Devil's Advocate | sonnet |
| 5 | Analyst (revision) | opus |
| 6 | Report Writer | opus |
| 7 | Narrative Architect | sonnet |

Record confirmed models and `output_type` from `input.md` in `artifacts/00-pipeline-log.md`:
```
model-value-assessor: <confirmed>
output-type: <value from input.md, default: report>
```
Wait for reply before Step -2.
</important>

---

<important if="you are running Step -2 (Value Assessment)">

### Step -2: Value Assessor

Agent: `value-assessor` (opus). Input: `input.md`. Output: `artifacts/00-value-assessment.md`.

**Skip option**: if topic is pre-approved, offer to skip ("this still helps surface expert gaps — run or skip?"). If skipped, create `artifacts/00-value-assessment.md` with `# Value Assessment skipped`.

Launch: `Read agents/value-assessor/CLAUDE.md. Project root: <path>`

**→ STOP** after completion. Show: recommendation (GO/CONDITIONAL/PIVOT/NO-GO), expert gaps, alternatives. Ask: "Proceed to brainstorming?"
</important>

---

<important if="you are running Step -1 (Brainstorming)">

### Step -1: Brainstorming

Agent: `brainstorming` (opus). Input: `input.md` + `artifacts/00-value-assessment.md`. Output: `artifacts/00-brainstorm-output.md`.

**Skip option**: if topic is well-defined, offer to skip. If skipped, create `artifacts/00-brainstorm-output.md` with `# Brainstorming skipped`.

Launch: `Read agents/brainstorming/CLAUDE.md. Project root: <path>`

**→ STOP**. Show: problem diagnosis, top directions, assumptions. Ask: "Proceed to question design?"
</important>

---

<important if="you are running Step 0 (Question Architect)">

### Step 0: Question Architect

Agent: `question-architect` (opus). Input: `input.md` + `artifacts/00-brainstorm-output.md`. Output: `artifacts/00-question-map.md`.

**→ STOP**. Show question map + [Expert input needed] items. If user provides expert input, save to `artifacts/00-expert-input.md`. Ask: "Proceed to research?"
</important>

---

<important if="you are running Step 1 (Multi-Lens Research)">

### Step 1: 3× Parallel Research

Launch `researcher-technical`, `researcher-strategic`, `researcher-contrarian` (all sonnet) simultaneously. Pass `artifacts/00-question-map.md` + `artifacts/00-expert-input.md` if exists.

Quality gate: each artifact must contain specific numbers, named sources, or URLs. Rerun thin artifacts with focused prompts.
</important>

---

<important if="you are running Step 2 (Synthesis)">

### Step 2: Synthesis

Write `artifacts/01-research.md` directly. Structure: executive summary → key findings → data/evidence → comparable cases → conflicts → source list → **Knowledge Gap Map** (table: Question | Coverage | Notes, mark items ★ Expert needed or ✗ Not found).

**→ STOP**. Show summary + gap map. Ask: "Expert knowledge to fill gaps? Reply 'go' to proceed."
</important>

---

<important if="you are running Steps 3-5 (Analysis)">

### Steps 3-5: Analysis Loop

- **Step 3**: `analyst` (opus) → `artifacts/02-analysis.md`
- **Step 4**: `devils-advocate` (sonnet) → `artifacts/02a-challenges.md`
- **Step 5**: `analyst` revision (opus) → `artifacts/02-analysis-final.md`. Every challenge in 02a must be addressed.

**→ STOP at Step 5**. Show final recommendations. Offer expert knowledge injection window (last cheap point to add domain input before narrative).
</important>

---

<important if="you are running Step 6 (Report Writer)">

### Step 6: Report Writer

Agent: `report-writer` (opus). Input: `artifacts/02-analysis-final.md` + `artifacts/01-research.md` + `input.md`. Output: `artifacts/03-report.md`.

**→ STOP**: ask user which output formats (multi-select): Markdown (always), PDF, PPTX. Record in pipeline log as `output-formats:`.
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
3. Storytelling tone (ONLY if a narrative / 有故事性 report is wanted) — **story-line selection is a GATE; do NOT jump straight into rewriting the prose**:
   a. **Derive 3-4 candidate story-lines** from `03-report.md`. Each candidate = a one-line hook (钩子) + the through-question (贯穿设问) it drives + which report sections feed it. Every story-line MUST reduce to material already in the report — do not invent facts to make a better story.
   b. **STOP and show the candidates to the user.** Ask them to pick one primary spine (optionally braid a second) or supplement their own angle. Wait for their choice before writing any narrative prose.
   c. Only after the user confirms, follow `docs/STORYTELLING-REFERENCE.md`. The style guide and article corpus are bundled in `docs/boss_dai/` — read them directly, do NOT ask the user where to get reference articles. Read the guide, then 5 topic-matched articles, draft style-application notes, then write the narrative sections around the confirmed story-line. Keep all facts and numbers exact.
4. **MUST** include rights footer on every page: render `docs/rights.template.md` as a fixed running footer, replacing the `<#...>` placeholder with the model names actually used this run (from the agent→model rows in `artifacts/00-pipeline-log.md`, e.g. `Claude Opus 4.8, Claude Sonnet 4.6`). **This step is mandatory — do NOT skip.**
5. Render: `npx playwright pdf artifacts/05-report.html artifacts/05-report.pdf` (or headless Chromium `--print-to-pdf`).
6. **MUST** verify ALL of: (a) no tofu □ boxes, (b) table borders intact, (c) **rights footer visible on every page** (re-run step 4 if missing).
</important>

---

<important if="you are running Step 7 (Narrative Architect)">

### Step 7: Narrative Architect

Agent: `narrative-architect` (sonnet). Input: `artifacts/03-report.md` + `input.md`. Output: `artifacts/04-narrative.md` + `artifacts/04-diagram-specs.md`.

**→ STOP**. Confirm narrative + diagram specs. Record artifact/slide language, PPTX template in pipeline log.

**→ DONE**: Tell user about next steps (Option A: `/diagram` → Cowork, Option B: Cowork directly).
</important>

---

<important if="the user asks for PPTX output">

### PPTX output

Switch to Cowork: `Read COWORK.md and build the deck`. Diagrams: `artifacts/04-diagram-specs.md`. Template: recorded in pipeline log. Output: `artifacts/05-deck.pptx`.
</important>

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md`: step completion timestamps, confirmed settings, user edits, expert input.

---

<important if="you are starting, resuming, or proceeding between steps">

## Rules

- Announce each step before starting.
- Never start a step until previous step's STOP is confirmed (or step is skipped).
- Verify each artifact exists and non-empty before next step.
- Parallel only at Step 1; all others sequential.
- Step 1 quality gate: every artifact must contain numbers/sources/URLs. Rerun if thin.
- Do not modify completed artifacts without telling user.
- Resume: read `artifacts/00-pipeline-log.md` + `CLAUDE-RESUME.md`.
- **Source materials**: check `input/README.md` before each step. Save discoveries to `input/` and update manifest.
</important>