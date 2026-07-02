## Session startup (ALWAYS run first — before any response)
## Session startup (ALWAYS run first)

When your session starts:
1. Read `CLAUDE-RESUME.md` for current status.
2. Check `input/README.md` for new materials.
3. Act: Complete->offer supplement/refresh, In-progress->offer resume, Fresh->wait.

---

# Codebase Deep Analysis Orchestrator

Multi-agent codebase analysis pipeline (5 agents). Repo -> Architecture -> Modules -> Literature -> Design -> Report.

---

## Pipeline overview

Step 0: Project Surveyor -> repo overview STOP: confirm -> Step 1: 3x parallel (Architecture Mapper, Module Deep-Diver, Literature Analyst) -> Step 2: Design Interpreter STOP: review -> Step 3: Synthesis -> artifacts/03-final-report.md

**Source materials**: `input/README.md` -- check before each step.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| 0 | project-surveyor | opus | input.md + input/README.md | artifacts/00-overview.md |
| 1a | architecture-mapper | opus | input.md + input/README.md + 00-overview.md | artifacts/01-architecture.md |
| 1b | module-deepdiver | sonnet | input.md + input/README.md + 00-overview.md | artifacts/01-module-analysis.md |
| 1c | literature-analyst | sonnet | input.md + input/README.md + 00-overview.md | artifacts/01-literature-review.md |
| 2 | design-interpreter | opus | 01-arch + 01-module + 01-lit + input/README.md | artifacts/02-design-decisions.md |
| 3 | *(Claude Code directly)* | -- | 02-design-decisions + 01-* + input/README.md | artifacts/03-final-report.md |

---

## How to run agents

Use **Agent** tool subagents. Include absolute project path:
```
Read agents/<name>/CLAUDE.md for your full instructions.
Project root: <absolute path>
```

**Step 1 is the only parallel step**. All others sequential.

---

<important if="you are starting the pipeline for the first time or the user asks to change models">

## Model confirmation

| Step | Agent | Default |
|---|---|---|
| 0 | Project Surveyor | opus |
| 1a | Architecture Mapper | opus |
| 1b | Module Deep-Diver | sonnet |
| 1c | Literature Analyst | sonnet |
| 2 | Design Interpreter | opus |

Wait for reply before Step 0.
</important>

---

<important if="you are running Step 0 (Project Surveyor)">

### Step 0: Project Surveyor

Agent: `project-surveyor` (opus). Input: `input.md` (repo_url). Output: `artifacts/00-overview.md`.

**-> STOP**. Show overview + community health. Confirm analysis scope.
</important>

---

<important if="you are running Step 1 (Multi-Lens Analysis)">

### Step 1: 3x Parallel Analysis

Launch architecture, module, literature agents simultaneously. Each reads `input.md` + `artifacts/00-overview.md`.
</important>

---

<important if="you are running Step 2 (Design Interpreter)">

### Step 2: Design Interpreter

Agent: `design-interpreter` (opus). Input: all Step 1 artifacts. Output: `artifacts/02-design-decisions.md`.

**-> STOP**. Show design philosophy, key decisions, trade-offs. User reviews before synthesis.
</important>

---

<important if="you are running Step 3 (Synthesis)">

### Step 3: Synthesis

Write `artifacts/03-final-report.md` directly. Structure: architecture overview, module deep-dive, design decisions, literature summary, diagram specs, quick-start guide.

**-> DONE**. Report ready.
</important>

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md`.

---

<important if="you are starting, resuming, or proceeding between steps">

## Rules

- Announce each step before starting.
- Verify artifact exists before next step.
- Parallel only at Step 1; all others sequential.
- Do not modify completed artifacts without telling user.
- **Source materials**: check `input/README.md` before each step. Save discoveries to `input/` and update manifest.
</important>