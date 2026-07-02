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
Step 1: Multi-Perspective Research (4 parallel Agent subagents, Sonnet)
  ├── History & Evolution   → artifacts/01a-research-history.md
  ├── Concepts & Frameworks → artifacts/01b-research-concepts.md
  ├── Current Landscape     → artifacts/01c-research-landscape.md
  └── Depth & Critique      → artifacts/01d-research-critique.md
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
| 1a-1d | Researchers (x4, parallel) | sonnet |
| 2.5 | Paper Analyst (optional) | sonnet |
| 3 | Devil's Advocate | sonnet |
| 4 | Knowledge Report Writer | opus |
| 5 | Visual Enhancer (optional) | sonnet |

Ask: *"These are the default models. Reply 'confirm' to use them, or tell me any changes."*

Wait for the user's reply. Record confirmed models in `artifacts/00-pipeline-log.md`.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| 0 | topic-architect | opus | input.md | artifacts/00-question-map.md |
| 1a | researcher-history | sonnet | input.md + 00-question-map.md | artifacts/01a-research-history.md |
| 1b | researcher-concepts | sonnet | input.md + 00-question-map.md | artifacts/01b-research-concepts.md |
| 1c | researcher-landscape | sonnet | input.md + 00-question-map.md | artifacts/01c-research-landscape.md |
| 1d | researcher-critique | sonnet | input.md + 00-question-map.md | artifacts/01d-research-critique.md |
| 2 | *(Claude Code directly)* | — | 01a/b/c/d + input.md + 00-question-map.md | artifacts/01-research.md |
| 2.5 | paper-analyst (optional) | sonnet | user-supplied paper list + 01-research.md | artifacts/01e-paper-analysis.md + papers/<id>-zh.md |
| 3 | devils-advocate | sonnet | 01-research.md + input.md | artifacts/02-challenges.md |
| 4 | knowledge-report-writer | opus | 01-research.md + 02-challenges.md + input.md | artifacts/03-report.md |
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

**→ STOP**: Show the user the question map and blind-spot checklist. Ask for corrections or additions. If the user provides expert knowledge, write it into `artifacts/00-expert-input.md`. Wait for "go" before Step 1.

### Step 1 — Multi-Perspective Research (parallel)

Launch all four researchers simultaneously. Pass the question map and any expert input to each.

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

**This DA is a knowledge-coverage auditor, NOT a recommendation attacker.** Its job is to find what the research MISSED — missing perspectives, oversimplified narratives, weak sources, neglected counter-arguments, cultural/regional biases. See the agent's CLAUDE.md for the full checklist.

No STOP here — the report writer incorporates DA findings directly. But do verify `artifacts/02-challenges.md` exists and is non-empty before proceeding.

### Step 4 — Knowledge Report Writer

Agent: `knowledge-report-writer`, model: opus.
Input: `artifacts/01-research.md` + `artifacts/02-challenges.md` + `input.md`.
Output: `artifacts/03-report.md` — the final knowledge report.

The report writer reads the DA's coverage audit and incorporates identified gaps directly into the report. There is no accept/rebut cycle — the gaps and missing perspectives ARE content that enriches the report.

**→ STOP (offer visual enhancement)**: The report is ready. Ask the user:
"Do you want visual enhancement? I can scan the report for 5-8 places where images would add value — historical photos, product images, and real data charts via search (Wikipedia/official sites), plus AI-generated concept diagrams and timelines for abstract structures. This produces `artifacts/03-report-illustrated.md` with embedded images."

If the user opts in, run **Step 5** below before the final done. If not, the report is complete as-is.

### Step 5 — Visual Enhancement (OPTIONAL — only if the user opted in)

Agent: `visual-enhancer`, model: sonnet.
Input: `artifacts/03-report.md`. Output: `artifacts/03-report-illustrated.md` + images saved to `images/`.

The agent reads `agents/visual-enhancer/CLAUDE.md` for its full instructions. It scans the report, identifies 5-8 image slots, searches for real images (Wikipedia, official sites, authoritative blogs, Wikimedia Commons — never random social media), and generates concept diagrams only when no real photo exists. All images are saved to `images/` and embedded into the illustrated report.

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
3. Storytelling tone (ONLY if a narrative / 有故事性 report is wanted): follow `docs/STORYTELLING-REFERENCE.md`. The style guide and article corpus are bundled in `docs/boss_dai/` — read them directly, do NOT ask the user where to get reference articles. Read the guide, then 5 topic-matched articles, draft style-application notes, then write the narrative sections. Keep all facts and numbers exact.
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
4. The final deliverable is `artifacts/03-report.md` — no PPT, no recommendations.
5. Verify each artifact exists and is non-empty before starting the next step. EXCEPTION: `artifacts/01e-paper-analysis.md` is optional.
6. Step 2.5 (Paper Deep-Dive) runs ONLY if the user opts in at the Step 2 stop.
7. Never modify existing artifacts from completed steps without telling the user first.
8. To resume a partial run, read `artifacts/00-pipeline-log.md` and `CLAUDE-RESUME.md`.
