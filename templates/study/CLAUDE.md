## Session startup (ALWAYS run first — before any response)
## Session startup (ALWAYS run first)

When your session starts:
1. Read `CLAUDE-RESUME.md` for current status.
2. Check `input/README.md` for new materials.
3. Act: Complete->offer supplement/refresh, In-progress->offer resume, Fresh->wait.

---

# Learning Guide Builder Orchestrator

Multi-agent learning pipeline (6 agents). Topic -> 7-day study plan + resources + self-assessment.

---

## Pipeline overview

Step 0: Learning Architect -> knowledge map STOP: confirm -> Step 1: 3x parallel curators (Authority, Community, Critical) -> Step 2: Study Plan Design STOP: review -> Step 3: Bias Review -> Step 4: Final Revision -> output/

**Source materials**: `input/README.md` -- check before each step.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| 0 | learning-architect | opus | input.md + input/README.md | artifacts/00-learning-framework.md |
| 1a | authority-curator | sonnet | 00-learning-framework.md + input.md + input/README.md | artifacts/01a-authority-resources.md |
| 1b | community-curator | sonnet | 00-learning-framework.md + input.md + input/README.md | artifacts/01b-community-resources.md |
| 1c | critical-curator | sonnet | 00-learning-framework.md + input.md + input/README.md | artifacts/01c-critical-perspectives.md |
| 2 | *(Claude Code directly)* | -- | 01a/b/c + 00-learning-framework.md + input/README.md | artifacts/02-study-plan-draft.md |
| 3 | bias-reviewer | sonnet | 02-study-plan-draft.md + 01a/b/c + input/README.md | artifacts/03-bias-review.md |
| 4 | curriculum-editor | opus | 03-bias-review.md + 02-study-plan-draft.md + input/README.md | output/weekly-study-plan.md + output/resource-index.md + output/self-assessment.md |

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
| 0 | Learning Architect | opus |
| 1 | 3x Curators (parallel) | sonnet |
| 3 | Bias Reviewer | sonnet |
| 4 | Curriculum Editor | opus |

Wait for reply before Step 0.
</important>

---

<important if="you are running Step 0 (Learning Architect)">

### Step 0: Learning Architect

Agent: `learning-architect` (opus). Input: `input.md`. Output: `artifacts/00-learning-framework.md`.

**-> STOP**. Show knowledge map. Ask: "Proceed to resource curation?"
</important>

---

<important if="you are running Step 1 (Multi-Lens Curation)">

### Step 1: 3x Parallel Curators

Launch authority, community, critical curators (all sonnet) simultaneously. Each reads `artifacts/00-learning-framework.md` + `input.md`.
</important>

---

<important if="you are running Step 2 (Study Plan Design)">

### Step 2: Study Plan Design

Write `artifacts/02-study-plan-draft.md` directly. Structure: 7 days, each with topic, resources, exercises, estimated time.

**-> STOP**. Show draft. Ask "Adjustments?" before bias review.
</important>

---

<important if="you are running Steps 3-4 (Review & Finalize)">

### Steps 3-4: Review & Finalize

- **Step 3**: `bias-reviewer` (sonnet) -> `artifacts/03-bias-review.md`
- **Step 4**: `curriculum-editor` (opus) -> final `output/` package. Address all bias items.

**-> DONE**. Final package: `output/weekly-study-plan.md`, `output/resource-index.md`, `output/self-assessment.md`.
</important>

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md`: step completion, settings, user edits.

---

<important if="you are starting, resuming, or proceeding between steps">

## Rules

- Announce each step before starting.
- Verify artifact exists before next step.
- Parallel only at Step 1; all others sequential.
- Do not modify completed artifacts without telling user.
- **Source materials**: check `input/README.md` before each step. Save discoveries to `input/` and update manifest.
</important>