## Session startup (ALWAYS run first)

When your session starts:
1. Read `CLAUDE-RESUME.md` for current status.
2. Check `input/README.md` for new materials.
3. Act: Complete->offer supplement/refresh, In-progress->offer resume, Fresh->wait.

---

# Software Development Pipeline Orchestrator

Multi-agent software pipeline (7 agents). Requirements -> Architecture -> Code -> Test -> Report.

---

## Agent roster

| Step | Agent | Reads | Writes |
|---|---|---|---|
| 1 | requirements | artifacts/00-user-brief.md + input/README.md | artifacts/01-requirements.md |
| 1b | requirements-qa | 01-requirements.md + 00-user-brief.md + input/README.md | artifacts/01-requirements-qa.md |
| 2 | architect | 01-requirements-qa.md + input/README.md | artifacts/02-architecture.md |
| 2b | architect-qa | 02-architecture.md + 01-requirements-qa.md + input/README.md | artifacts/02-architecture-qa.md |
| 3 | coder | 02-architecture-qa.md + 01-requirements-qa.md + input/README.md | code in artifacts/src/ |
| 3b | testcase-dev | 01-requirements-qa.md + 02-architecture-qa.md + input/README.md | artifacts/03-test-cases.md |
| 4 | tester | artifacts/src/ + 03-test-cases.md + input/README.md | artifacts/04-report.md |

**Source materials**: `input/README.md` -- check before each step.

---

## How to run agents

Use **Agent** tool subagents. Include absolute project path:
```
Read agents/<name>/CLAUDE.md for your full instructions.
Project root: <absolute path>
```

Steps are sequential. Verify each artifact exists before next step. QA agents (1b, 2b, 4) check for Critical/Contradiction issues -- fix before proceeding.

---

<important if="you are starting the pipeline for the first time or the user asks to change models">

## Model confirmation

| Step | Agent | Default |
|---|---|---|
| 1 | requirements | sonnet |
| 1b | requirements-qa | sonnet |
| 2 | architect | opus |
| 2b | architect-qa | sonnet |
| 3 | coder | opus |
| 3b | testcase-dev | sonnet |
| 4 | tester | sonnet |

Ask: "Architect step optional -- skip or run?" Wait for reply. Record in `artifacts/00-pipeline-log.md`.
</important>

---

<important if="you are running Step 1 (Requirements)">

### Step 1: Requirements

Agent: `requirements` (sonnet). Input: `artifacts/00-user-brief.md`. Output: `artifacts/01-requirements.md`.
</important>

---

<important if="you are running Step 1b (Requirements QA)">

### Step 1b: Requirements QA

Agent: `requirements-qa` (sonnet). Input: `artifacts/01-requirements.md`. Output: `artifacts/01-requirements-qa.md`.
Fix Critical issues before proceeding.
</important>

---

<important if="you are running Step 2 (Architecture)">

### Step 2: Architecture

Agent: `architect` (opus). Input: `artifacts/01-requirements-qa.md`. Output: `artifacts/02-architecture.md`.
Skip if user declined architect step.
</important>

---

<important if="you are running Step 2b (Architecture QA)">

### Step 2b: Architecture QA

Agent: `architect-qa` (sonnet). Input: `artifacts/02-architecture.md`. Output: `artifacts/02-architecture-qa.md`.
</important>

---

<important if="you are running Step 3 (Coding)">

### Step 3: Coding

Agent: `coder` (opus). Input: `artifacts/02-architecture-qa.md`. Output: code in `artifacts/src/`.
</important>

---

<important if="you are running Step 3b (Test Cases)">

### Step 3b: Test Case Development

Agent: `testcase-dev` (sonnet). Input: `artifacts/01-requirements-qa.md` + `artifacts/02-architecture-qa.md`. Output: `artifacts/03-test-cases.md`.
</important>

---

<important if="you are running Step 4 (Testing)">

### Step 4: Testing

Agent: `tester` (sonnet). Input: `artifacts/src/` + `artifacts/03-test-cases.md`. Output: `artifacts/04-report.md`.
Run all test cases. Report pass/fail per case. Final recommendation: PASS or FAIL.

**-> DONE**. Show report summary.
</important>

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md`: step completion, settings, QA issues found/fixed.

---

<important if="you are starting, resuming, or proceeding between steps">

## Rules

- Announce each step before starting.
- Verify artifact exists before next step.
- QA Critical issues block progression -- fix first.
- Do not modify completed artifacts without telling user.
- **Source materials**: check `input/README.md` before each step. Save discoveries to `input/` and update manifest.
</important>