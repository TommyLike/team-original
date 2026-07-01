# Changelog

All notable changes to the `team-original` project.

---

## [2026-07-01] — Tech Pipeline Orchestrator Fix

**Commit**: `f49b576`

### Fixed (Tech Pipeline Orchestrator)

- Orchestrator `CLAUDE.md` referenced non-existent agents
  (`researcher-technical`/`market`/`risk`/`architectural`, generic `analyst`)
  instead of the actual generated agents
  (`researcher-leadership`/`competitive`/`trend`/`challenges`, `tech-analyst`) —
  the pipeline would fail at Step 1 and at Steps 3-5
- `paper-analyst` and `repo-analyst` were generated but never referenced in the
  orchestrator's step flow — wired in as optional Steps 2.5/2.6, gated behind
  the Step 2 STOP
- Orchestrator claimed "No PPTX output for tech pipeline" despite
  `narrative-architect`, `COWORK.md`, and `docs/STEP7-GUIDE.md` already
  supporting a PPTX build via Cowork — added Step 7 to the pipeline overview,
  agent roster, model confirmation table, and rules, matching the research
  pipeline's pattern
- Added `artifacts/04-narrative.md` / `artifacts/04-diagram-specs.md`
  placeholders and `agents/narrative-architect` scaffolding to match

---

## [2026-06-29] — Knowledge Exploration Pipeline

**Commits**: `8ac5cde`, `0ee2288`

### Added (Explore Pipeline)

- New `explore` pipeline (`./init-pipeline.sh explore`) — general-purpose
  knowledge mastery pipeline for any topic
- Topic Architect → 4-lens parallel research (history, concepts, landscape,
  critique) → synthesis → optional paper deep-dive → Devil's Advocate
  (repurposed as a knowledge-coverage auditor, not a recommendation attacker)
  → Knowledge Report Writer
- Output: `artifacts/03-report.md` — text report only, no PPT, no
  recommendations
- README and root `CLAUDE.md` updated for the sixth pipeline and modification
  conventions

### Fixed (Documentation)

- This addition was never logged in `CHANGELOG.md` at merge time (PR #11),
  despite the project's own rule requiring every functional commit/PR to
  update it — backfilled here

---

## [2026-06-12] — Output Type + 4 Presentation Styles

**Commit**: `310ba58`

### Added (Output Types)

- `output_type` field to research and tech pipeline `input.md` templates
- 4 types: report (汇报), decision (决策), learning (学习总结), sharing (分享)
- Report Writer agents: 4-type report structure switch with `important-if` blocks
- Orchestrator records `output_type` in pipeline log at model confirmation
- PPT/PDF available for all types

---

## [2026-06-12] — Orchestrator Optimization with important-if

**Commit**: `3c8c022`

### Changed (Orchestrator Optimization)

- Applied `improve-claude-md` skill principles to all 5 orchestrators
- Session startup stays bare, steps wrapped in `<important if>` blocks
- Model confirmation + PDF/PPTX recipes wrapped as conditional blocks
- Research: 522→230 lines (-56%), Study: 264→124 (-53%)
- Coding: 266→123 (-54%), Tech: 379→158 (-58%)
- `init-pipeline.sh`: 4398→3661 lines (-737, -17%)
- 41 `<important if>` blocks across all pipelines

---

## [2026-06-12] — Session Startup + Iterative Research

**Commit**: `94959f1`

### Added (Session Startup)

- Session startup auto-detection in all 5 orchestrator `CLAUDE.md` files
- Automatic status detection on session start: Complete / Fresh / In-progress
- Iterative research: supplement (standalone) or refresh (update main) mode
- `CHANGELOG.md` — full history from initial commit to present
- Project `CLAUDE.md` updated with changelog rule and session startup docs

### Changed (Session Startup)

- Every future commit/PR must update `CHANGELOG.md`

---

## [2026-06-11] — Input Directory + Refactoring

**Commit**: `d3a6529`

### Added (Input Directory)

- `input/{pdf,web,repo}` directories generated for all 5 pipelines
- `input/README.md` manifest template — agents catalog discovered materials
- Source materials section in `input.md` templates
- Orchestrator `CLAUDE.md` agent roster references `input/README.md`
- Source materials rule: agents check, save, and update input manifest

### Changed (Refactoring)

- 3 shared bash functions applied to all 5 pipelines in `init-pipeline.sh`
- Standardized software branch Python scaffolding
- Software branch heredoc delimiter unified

### Fixed (Refactoring)

- Added missing `CLAUDE-RESUME.md` to software pipeline

---

## [2026-06-10] — Tech Pipeline Fixes

**Commits**: `3aff170`, `148aee7`

### Fixed (Tech Pipeline)

- Prescribe exact PDF generation recipe for CJK reliability
- Enforce mandatory Skill tool usage in paper-analyst agent

---

## [2026-06-09] — Tech Assessment Pipeline

**Commit**: `8826abf`

### Added (Tech Pipeline)

- Tech assessment pipeline (`./init-pipeline.sh tech`)
- Decoupled research output formats (Markdown / PDF / PPTX)

---

## [2026-06-05] — Coding Pipeline

**Commit**: `24a3bd9`

### Added (Coding Pipeline)

- Open source codebase deep analysis pipeline
- 5 agents: Project Surveyor, Architecture Mapper, Module Deep-Diver,
  Literature Analyst, Design Interpreter

---

## [2026-06-03] — Research Pipeline Enhancement

**Commits**: `766dec9`, `1dce0b0`, `64e75e8`

### Added (Research Pipeline)

- Step -2: Value Assessor — evaluates ROI, alternatives, expert gaps
- Step -1: Brainstorming — multi-perspective problem reframing
- Updated README with new pipeline flow diagram

---

## [2026-05-23] — Initial Release

**Commits**: `55a33fb`, `c036056`, `a8a8ce3`

### Added (Initial)

- Initial `init-pipeline.sh` with 3 pipelines (research, software, study)
- `README.md`, `CLAUDE.md`, MIT `LICENSE`
- CI workflow (shellcheck + markdownlint)
