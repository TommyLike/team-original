# Changelog

All notable changes to the `team-original` project.

---

## [2026-06-12] — Session Startup + Iterative Research + CHANGELOG.md

**Commit**: `94959f1`

### Added
- Session startup auto-detection block in all 5 orchestrator `CLAUDE.md` files
- When Claude Code starts, automatically detects: Complete/Fresh/In-progress
- Iterative research: supplement (standalone) or refresh (update main) mode
- `CHANGELOG.md` — full history from initial commit to present
- Project `CLAUDE.md` updated with changelog rule and session startup docs

### Changed
- Every future commit/PR must update `CHANGELOG.md`

---

## [2026-06-11] — Input Directory + Refactoring

**Commit**: `d3a6529`

### Added
- `input/{pdf,web,repo}` directories generated for all 5 pipelines
- `input/README.md` manifest template — agents catalog discovered materials
- Source materials section in `input.md` templates
- Orchestrator `CLAUDE.md` agent roster references `input/README.md`
- Source materials rule: agents must check, save, and update input manifest

### Changed
- Refactored `init-pipeline.sh`: 3 shared bash functions (`init_pipeline_log`, `init_empty_artifacts`, `write_resume_file`) applied to all 5 pipelines
- Standardized software branch Python scaffolding (`with open` → `open().write()`)
- Software branch heredoc delimiter (`'EOF'` → `'INPUTEOF'`)

### Fixed
- Added missing `CLAUDE-RESUME.md` to software pipeline

---

## [2026-06-10] — Tech Pipeline Fixes

**Commits**: `3aff170`, `148aee7`

### Fixed
- Prescribe exact PDF generation recipe for CJK reliability in tech and research pipelines
- Enforce mandatory Skill tool usage in paper-analyst agent

---

## [2026-06-09] — Tech Assessment Pipeline

**Commit**: `8826abf`

### Added
- Tech assessment pipeline (`./init-pipeline.sh tech`)
- Decoupled research output formats (Markdown / PDF / PPTX)

---

## [2026-06-05] — Coding Pipeline

**Commit**: `24a3bd9`

### Added
- Open source codebase deep analysis pipeline (`./init-pipeline.sh coding`)
- 5 agents: Project Surveyor, Architecture Mapper, Module Deep-Diver, Literature Analyst, Design Interpreter

---

## [2026-06-03] — Research Pipeline Enhancement

**Commits**: `766dec9`, `1dce0b0`, `64e75e8`

### Added
- Step -2: Value Assessor — evaluates ROI, alternatives, expert gaps before research
- Step -1: Brainstorming — multi-perspective problem reframing
- Updated README with new pipeline flow diagram

---

## [2026-05-23] — Initial Release

**Commits**: `55a33fb`, `c036056`, `a8a8ce3`

### Added
- Initial `init-pipeline.sh` with 3 pipelines (research, software, study)
- `README.md`, `CLAUDE.md`, MIT `LICENSE`
- CI workflow (shellcheck + markdownlint)
