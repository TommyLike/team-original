# Changelog

All notable changes to the `team-original` project.

---

## [2026-07-05] — 病药效托 Skeleton, 技术蓝墨 Palette, Writing-Critic DA, Ray v3

### Changed (technical writing handbook — `rule.md` → v0.4)

- Added **§0 「文章骨架：病→药→效→托」** — an end-to-end narrative skeleton placed
  before the craft sections. Maps 病/药/效/托 onto 起承转合 and onto the existing
  handbook sections; redefines the technical "托" as an **honest trust signal**
  (real-system anchoring + reproducible entry + candid boundaries), not a shill;
  and swaps "大格局出" for "小切口进 → **通用直觉出**".
- Expanded **§5 风格** with "借鉴叙事笔法：拿来 vs 不拿来" — borrows the dai
  (饭桶戴老板) narrative craft that helps technical writing (concrete-scene opening,
  one through-line question, per-section hook sentences, 剥削/deep-on-one-point,
  克制/restraint) while explicitly **excluding** the parts that don't fit technical
  articles (国运/时代/周期/人性/产业兴衰 grand sublimation, 闲笔 digressive openings,
  history/politics analogies as main argument, heavy classical-style pastiche).

### Changed (illustration spec — `image-style.md` → "技术蓝墨")

- Replaced the vivid Grootendorst palette (鲜紫/品红/青绿, too attention-grabbing)
  with a restrained **engineering palette**: one cool family (钢蓝 `#2F6FB0` /
  淡蓝灰 `#D3E0EC` / 冷灰盒 `#EBEEF2` / 沉青 `#3F8F8A` / 灰绿 `#5A8F6B` / 墨黑
  `#1B2430`) **plus one warm accent** (赭红 `#B0553F`) used at most twice per
  diagram (one marker + one annotation). Grouping containers now use a dashed
  muted-teal border only (no black outer box). The "one-color-per-concept" and
  thick-outline discipline is kept; only the values changed.

### Added (explore pipeline — 中档 upgrade + writing-craft DA gate)

- **`writing-critic`** agent (`templates/explore/agents/writing-critic/`) — a NEW
  writing-craft devil's advocate that audits the produced markdown against the
  right standard by article type: **technical → `docs/rule.md`**, **general/narrative
  → `docs/boss_dai/dai-writing-style.md`**. Emits BLOCKER/IMPROVE findings + a
  PASS/REVISE verdict. It is a **mandatory gate**: the pipeline loops writer→critic
  until PASS before rendering/illustration (成稿两边 markdown 没问题才继续).
- **技术文章模式 (Step 4b, optional)** — reuses `knowledge-report-writer` in ARTICLE
  mode to produce a focused single-thread 病→药→效→托 article (`artifacts/03-article.md`),
  distinct from the encyclopedic report.
- `knowledge-report-writer` now reads `docs/rule.md` and applies its structure/
  explanation/rigor craft when the topic is technical.
- `install_tech_visual_style()` (in `lib/common.sh`) now also bundles
  `assets/articles/technology/rule.md` → `docs/rule.md` so the writing-critic and
  report writer have the handbook available in generated projects.
- `templates/explore/reference/technology-outline.md` — a MECE research-scope
  checklist for technology / open-source project subjects (定位 / 原理 / 质量 /
  可持续). Wired into `topic-architect` (cross-checks research scope, incl. license,
  bus factor, threat model, supply chain) and the coverage devil's advocate (audits
  against it). This governs research **coverage**; `docs/rule.md` governs writing
  **craft** — the two dimensions are kept separate by design.
- Orchestrator (`templates/explore/CLAUDE.md`) updated: pipeline diagram, model
  table, agent roster, detailed Steps 4b/4.5, and the gate rule.

### Added (article-demo — Ray v3)

- `assets/articles/technology/article-demo/v3/` — the Ray article rewritten on the
  病→药→效→托 skeleton: concrete-scene opening + per-section hooks; **adds the "效"**
  (§六: what each of the three designs actually saves) and **"托"** (§七: real
  adopters + a runnable minimal example + candid boundaries) that v2 lacked; ending
  sublimates to transferable design intuition. All 10 diagrams regenerated in the
  "技术蓝墨" palette (new `tools/gen-images-v3.py` + `prompts-*-v3.json`), fixing v2's
  two figure bugs (small-object Y placement in stage 5; inconsistent node borders).
  New `pdf-v3.css` matches the palette; `build-pdf.sh` takes an optional CSS arg.
  Rendered `v3/Ray-architecture-v3.pdf` for the v1→v3 comparison.

---

## [2026-07-05] — Technical Visual-Guide Illustration Style

### Added (technical article + illustration style reference)

- Archived 6 reference articles (Maarten Grootendorst's "A Visual Guide to ..."
  series: quantization, MoE, Mamba, reasoning LLMs, LLM agents, diffusion) under
  `assets/articles/technology/sources/` — cleaned markdown + image manifests +
  a representative image sample per article.
- `assets/articles/technology/image-style.md` — a distilled, executable spec for
  the "Visual Guide" illustration style: palette (with hex), rounded-box + thick-
  black-outline shape language, one-color-per-concept encoding, annotation
  conventions, and a **reusable Gemini STYLE prompt block**. Verified with
  `gemini-3-pro-image`: the same STYLE block produced consistent, clearly-labeled
  diagrams across three test topics (attention / MoE / quantization) — MoE and
  quantization came out near-identical to the source figures.
- `assets/articles/technology/rule.md` — distilled two new writing sections from
  the same articles: "讲解：自底向上建立直觉" (concept-sequencing techniques —
  problem-first opening, simple-to-complex ordering, up-front decomposition map,
  anchoring abstractions to concrete systems, question-titled sections,
  intuition-over-completeness) and "用图解释：Visual Guide 手法" (visual-explanation
  method). Version bumped to v0.3.

### Changed (explore pipeline wiring)

- `lib/common.sh`: new `install_tech_visual_style()` helper that bundles
  `image-style.md` into a generated project's `docs/`.
- `init-pipeline.sh` (explore case): calls `install_tech_visual_style` so explore
  projects ship `docs/image-style.md` (explore-only — the pipeline with the
  visual-enhancer).
- `templates/explore/agents/visual-enhancer/CLAUDE.md`: for technical topics,
  images now follow an explicit **source priority** — first try a real figure
  from a credible source (paper / official docs / authoritative blog / Wikimedia,
  cited); only if none exists, AI-generate, and then it MUST follow the bundled
  `docs/image-style.md` (append its STYLE block to every prompt) using
  `gemini-3-pro-image` — verified to render short labels reliably, so GPT Image
  is no longer required for labeled Visual-Guide diagrams.
- `image-style.md` / `rule.md`: added the same source-priority rule (prefer real
  authoritative images with attribution; AI generation is the styled fallback).
- `CLAUDE.md`: documented `install_tech_visual_style()` under Rich-text assets.

---

## [2026-07-02] — Externalize Scaffold Content to templates/

### Changed (major refactor — no behavior change)

- Split the 5739-line `init-pipeline.sh` into three parts:
  - `init-pipeline.sh` (~290 lines) — thin dispatcher: per-pipeline `case`
    block doing only dynamic setup (`copy_template`, empty dirs, artifact
    placeholders, `CLAUDE-RESUME.md`, summary echo).
  - `lib/common.sh` (~130 lines) — shared shell helpers (`usage`,
    `copy_template`, `init_pipeline_log`, `init_empty_artifacts`,
    `write_resume_file`, `ensure_fonts`, `install_richtext_assets`).
  - `templates/<type>/` — all static scaffold content (58 agent/orchestration
    files + input templates) extracted from the old embedded Python
    `files = {}` blocks into plain files, the new source of truth.
- The old `python3 << 'PYEOF'` heredocs that embedded content as Python
  strings are gone. This removes the entire `SyntaxError: unterminated string
  literal` class of bug and makes the content readable, diffable, and
  editable as normal files.
- **Verified behavior-preserving**: all six pipelines were generated before
  and after the refactor and diffed **byte-identical** (file contents AND
  full directory trees, including empty dirs). Extraction was done
  programmatically with round-trip verification.
- `.markdownlint-cli2.jsonc`: added `templates/**` to ignores — the payload
  is delivered content, not repo documentation, and does not follow the
  repo's markdown style. (Enabling lint/format on the payload is a separate
  deferred decision.)
- `CLAUDE.md`: rewrote the architecture / "When editing" / "Adding a new
  pipeline" / "Shared components" sections to describe the templates-based
  structure; replaced the PYEOF/`files = {}` guidance.

---

## [2026-07-02] — Triple-Quote Hardening + Shared-Agent Doc Fix

### Changed (root-cause fix for the SyntaxError class of regressions)

- Converted the last 6 `files['...']` assignments in `init-pipeline.sh`
  from single-/double-quoted single-line strings to triple-quoted strings
  (`agents/analyst`, `agents/narrative-architect`, and the `COWORK.md` +
  `docs/STEP7-GUIDE.md` pairs in both `research` and `tech`). Single-quoted
  strings cannot span physical lines, so editing them by inserting a real
  newline caused `SyntaxError: unterminated string literal` and aborted the
  whole scaffold — the exact regression fixed reactively in the previous PR.
  All 52 `files[]` entries are now triple-quoted. The conversion was done
  programmatically and verified to produce **byte-identical** generated
  output (research + tech projects diffed clean).
- `CLAUDE.md`: added a rule under "When editing init-pipeline.sh" requiring
  all `files[]` entries to use triple-quoted strings, to prevent the
  single-quoted multi-line regression from recurring.

### Fixed (misleading maintenance guidance)

- `CLAUDE.md` "Shared components" claimed the shared agents
  (`paper-analyst`, `devils-advocate`, `report-writer`,
  `narrative-architect`) are copied "verbatim" and must be kept identical.
  An audit showed they are in fact **intentional per-pipeline variants**
  (e.g. `devils-advocate` attacks a tech assessment in `tech` but audits
  knowledge coverage in `explore`), with deliberately different content and
  artifact numbering. Rewrote the guidance to describe them as tailored
  variants sharing a skeleton: fix structural/mechanical bugs across all
  copies, but preserve each variant's intentional wording. No functional
  drift bug was found — this is a documentation-accuracy fix.

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
