# Changelog

All notable changes to the `team-original` project.

---

## [2026-07-02] — Scaffold Smoke Test

### Added

- `test/smoke-test.sh`: smoke test that runs `init-pipeline.sh` for all six
  pipeline types (`research`, `software`, `study`, `coding`, `tech`,
  `explore`) in isolated temp directories and asserts that the critical
  orchestration files are present. Catches scaffold-generation regressions
  (e.g. Python `SyntaxError`) that `shellcheck` / `markdownlint` cannot
  detect. Exit code 0 = all pass, 1 = any failure.
- CI (`ci.yml`): new `smoke-test` job runs `bash test/smoke-test.sh` on
  every push/PR to `main`, alongside the existing `shellcheck` and
  `markdownlint` jobs.
- `CLAUDE.md`: documented the smoke-test requirement under "Repository
  conventions" and updated the "When editing init-pipeline.sh" guidance to
  reference `bash test/smoke-test.sh` instead of manual ad-hoc testing.

---

## [2026-07-01] — Image Caption Typography + Scaffold Generation Fix

### Fixed (broken scaffold generation — research/tech pipelines could not be created)

- The previous "Rights Footer Enforcement & AI Image Language Fix" changes
  inserted new lines into **single-quoted** Python strings using literal
  newlines. A Python single-quoted `'...'` string cannot span physical lines,
  so `./init-pipeline.sh research` and `./init-pipeline.sh tech` aborted with
  `SyntaxError: unterminated string literal` and generated **no orchestrator
  `CLAUDE.md` and no agent files**. Three insertions were affected:
  `narrative-architect` (research copy), `COWORK.md` rule 8 (research + tech),
  and the `STEP7-GUIDE.md` Stage D checklist item (research + tech). All are
  now rejoined onto a single physical line with literal `\n` escapes.
- CI never caught this because it only lints (`shellcheck` + `markdownlint`)
  and never executes the generator. Verified the fix by running
  `./init-pipeline.sh` for research, tech, and explore — all now exit 0 and
  emit a complete project.

### Added (caption / figure typography for PDF output)

- **PDF recipe** (research / tech / explore): step 2 now prescribes image-caption
  typography — captions render lighter (`font-weight: 300`), italic, and slightly
  smaller (`0.85em`) than body text, while figure/section titles stay bold
  (`h1..h4 { font-weight: 700 }`). CSS selector covers `figure figcaption`,
  `.fig-caption`, and `p > em:only-child` so the existing `*…*` markdown captions
  are styled automatically.
- **visual-enhancer agent**: added a "Caption styling" rule instructing
  captions to stay wrapped in a single `*…*` emphasis (never bold, never body
  size) so they pick up the PDF recipe's caption CSS.

Root cause: the PDF recipe specified a font stack but gave no typographic
guidance, so captions rendered at body weight/size. The bold, light, and italic
Source Serif 4 weights were already installed (`ensure_fonts` copies the full
OTF set); CJK light
weight comes from the Source Han Serif variable weight axis (no true italic — Chromium
synthesizes an oblique slant). The gap was documentation/CSS, not font availability.

---

## [2026-07-01] — Rights Footer Enforcement & AI Image Language Fix

### Fixed (rights footer skipped during PDF/PPT generation)

- **PDF recipe** (research / tech / explore): step 4 changed from descriptive
  ("Rights footer on every page: render...") to mandatory ("**MUST** include rights
  footer... This step is mandatory — do NOT skip."). Step 6 verification also
  hardened with explicit MUST language and a per-item checklist.
- **STEP7-GUIDE.md** (research / tech): added "Rights footer visible on every slide"
  to the Stage D Review Checklist so the PPT-building agent checks it during the
  review gate. Design Rules rights footer note upgraded to "**Rights footer (MUST)**"
  with mandatory language.
- **COWORK.md** (research / tech): added rule 8 — "Rights footer (MUST)" — making
  rights footer verification a mandatory rule the Cowork agent must follow before
  final approval.

Root cause: the rights footer instruction was a narrative description without
"MUST" language, was absent from the Stage D Review Checklist (the definitive
"done" gate), and was absent from COWORK.md entirely. Agents treated it as
optional and skipped it.

### Fixed (AI-generated images in English despite Chinese reports)

- **visual-enhancer agent**: added instruction to read `artifact-language` from
  `artifacts/00-pipeline-log.md`. All AI image prompts MUST use labels matching
  the report language. The 5-part prompt framework now uses a parameterized
  `{artifact-language from pipeline log}` placeholder instead of hardcoded
  "Chinese labels". Example prompt annotated with language-matching instruction.
- **narrative-architect agent** (research / tech): added "Language (MUST)" directive
  for diagram specs — all diagram labels, annotations, and text MUST match the slide
  language from pipeline log. Never default to English for Chinese decks.

Root cause: both agents hardcoded "Chinese labels" in their prompt construction
guidance but never read the pipeline log to know the actual target language. When
the report was Chinese, generated images often came out in English because the
prompts didn't enforce language.

---

## [2026-07-01] — Default Fonts, Brand Rights Footer & Storytelling Reference

### Added (`init-pipeline.sh`)

- **Default rich-text fonts**: new `ensure_fonts()` helper runs on every invocation
  (before the pipeline `case`). It installs **Source Han Serif SC** (CJK) and
  **Source Serif 4** (Latin) from `assets/fonts/` into the user font dir
  (`~/Library/Fonts` on macOS, `~/.local/share/fonts` on Linux) when missing,
  runs `fc-cache` if available, and is idempotent. Failures warn and never abort
  scaffolding. Requires `SCRIPT_DIR`/`ASSETS_DIR` (also added) so the script can
  locate its own `assets/`.
- **Per-project brand + storytelling assets**: new `install_richtext_assets()`
  helper (called by `research`, `tech`, `explore`) copies
  `assets/brand/rights.template.md` → `docs/rights.template.md`, copies the entire
  boss_dai corpus (style guide + ~530 articles) → `docs/boss_dai/`, and generates
  `docs/STORYTELLING-REFERENCE.md`. The corpus is **bundled into each project**
  so it is fully self-contained and works when run from any directory (no
  dependency on the team-original repo's absolute path).
- **Distilled 戴老板 writing-style guide** (`docs/boss_dai/dai-writing-style.md`,
  sourced from `assets/articles/boss_dai/`): a new fixed reference covering the
  起承转合 structure, argument tactics, language register, and things to avoid,
  extracted from the original corpus so storytelling output no longer depends
  on a small random sample.
- **Storytelling flow hardened**: instead of "skim 2–3 articles," the
  reference now requires reading the fixed style guide first, then **5**
  topic-matched articles, then drafting style-application notes before
  writing — reducing output variance.

### Changed (rich-text output recipes)

- The shared **PDF generation recipe** (research / tech / explore, now identical)
  defaults to the CJK stack `'Source Han Serif SC', 'Source Han Serif SC VF',
  'PingFang SC', 'Noto Sans CJK SC'` and Latin `'Source Serif 4'`, adds an
  opt-in storytelling-tone step (饭桶戴老板 voice via `docs/STORYTELLING-REFERENCE.md`),
  and a rights footer step (render `docs/rights.template.md` with the run's actual
  model names into a running page footer).
- **PPT build guide** (`docs/STEP7-GUIDE.md`, research + tech copies): design-rules
  CJK font changed from Microsoft YaHei to **Source Han Serif SC**, added
  **Source Serif 4** as the Latin body font (applied via `theme1.xml` fontScheme),
  and added a rights-footer note.

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
