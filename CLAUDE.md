# CLAUDE.md

## About this repo

This is the **team-original** repository — a collection of pre-built
multi-agent pipeline scaffolds for AI-assisted workflows. The entry point
is `init-pipeline.sh`, which generates a complete project structure
including agent instruction files, artifact templates, and orchestration
guides.

## Available pipelines

- **research** — Multi-lens research pipeline producing a PPT-ready deck
- **software** — Multi-agent software development pipeline
  (requirements → architecture → code → test)
- **study** — Learning guide builder producing a 7-day study plan
- **coding** — Open source codebase deep analysis pipeline
- **tech** — Technology assessment research pipeline (report output)
- **explore** — Knowledge exploration & mastery pipeline (report output, any topic)

## How to use

```bash
./init-pipeline.sh <research|software|study|coding|tech|explore>
```

Each pipeline generates a self-contained project directory with its own
`CLAUDE.md` orchestration guide. After scaffolding, edit the generated
`input.md` with your project details, then run the pipeline by telling
Claude Code: `Read CLAUDE.md and start the pipeline`.

## Repository conventions

- All changes must go through PRs — direct pushes to `main` are blocked
- CI validates shell scripts with `shellcheck` and markdown with
  `markdownlint`
- The `init-pipeline.sh` script uses `set -e` and must pass shellcheck
- **CHANGELOG.md**: Every commit or PR that changes functionality MUST
  update `CHANGELOG.md`. Group entries by date, describe what changed per
  commit. Use the existing date-heading format.
- **Smoke test**: Every commit that touches `init-pipeline.sh` MUST pass
  the scaffold smoke test before submission. Run it locally with
  `bash test/smoke-test.sh`. The test scaffolds all six pipeline types in
  temp directories and asserts that the critical orchestration files are
  generated without error. CI also runs this test automatically on every PR.

## Session startup (for generated pipeline projects)

Generated pipeline `CLAUDE.md` orchestrators include a session startup
block. When Claude Code starts in a pipeline project:

1. Read `CLAUDE-RESUME.md` for current status
2. If Complete → check `input/` for new materials → offer supplement/refresh
3. If in-progress → report current step, offer resume
4. If fresh (Step -2) → pipeline not started, wait for user

No separate command needed — detection runs automatically on session start.

## When editing init-pipeline.sh

- The script generates agent instruction files via embedded Python to
  avoid heredoc escaping issues
- Keep Python-generated content in the `PYEOF` blocks — do not use shell
  heredocs for multi-line files with special characters
- **Always assign `files['...']` entries with triple-quoted strings**
  (`"""..."""`). A single- or double-quoted string cannot span physical
  lines, so inserting a real newline into one produces
  `SyntaxError: unterminated string literal` and the ENTIRE scaffold fails
  to generate. Every `files[]` entry is triple-quoted today — keep it that
  way; never introduce a single-quoted multi-line-content string.
- After editing, run `bash test/smoke-test.sh` to verify all six pipeline
  types scaffold correctly (see **Smoke test** under Repository conventions)

## Adding a new pipeline

When adding a new pipeline type to `init-pipeline.sh`:

1. **Update `usage()`** — add the new pipeline name to the help text
2. **Add a new `case` block** before the `*)` fallback
3. **Update `README.md`**: add to the pipeline table, add a flow diagram
   section, update the generated project structure if needed, increment
   the count ("six pipelines" → "seven pipelines", etc.)
4. **Update `CLAUDE.md`** (this file): add to the available pipelines list
5. **Update `CHANGELOG.md`**: log the addition under the current date

### Case block checklist

Each new pipeline case must:

- Create `agents/<name>/` directories for each agent
- Create `artifacts/` placeholder files (`: > artifacts/...`)
- Write `input.md` template via shell heredoc
- Write `CLAUDE-RESUME.md` with current status
- Write all agent instruction files + the orchestration `CLAUDE.md` via
  `python3 << 'PYEOF'` (follow the `files = {}` pattern)
- Print a summary `echo` block (pipeline name, steps, cost estimate, next steps)

### Shared components

When two or more pipelines use the same agent or output recipe:

- **Agent files** (e.g. `paper-analyst`, `devils-advocate`,
  `report-writer`, `narrative-architect`): these are **per-pipeline
  tailored variants**, NOT verbatim copies. They share a common role and
  section skeleton, but the domain-specific content is deliberately
  customized per pipeline (e.g. `devils-advocate` attacks a *technology
  assessment* in `tech` but audits *knowledge coverage* in `explore`;
  `report-writer` emits a research report in `research` vs a maturity /
  competitive assessment in `tech`). Artifact names and numbering also
  differ per pipeline by design. So: do NOT blindly overwrite one copy with
  another. When fixing a **structural or mechanical** bug that applies to
  all of them (a wrong shared artifact path, the single-quoted-string
  SyntaxError pattern, a broken instruction common to every variant), audit
  and fix EVERY copy — but preserve each variant's intentional per-pipeline
  wording.
- **PDF generation recipe**: the HTML→Chromium recipe in the Step 7
  output gate must stay identical across `research`, `tech`, and `explore`.
  It bakes in the default font stack (Source Han Serif SC / Source Serif 4),
  the opt-in storytelling-tone step, and the rights-footer step — keep all
  three copies in sync.
- **COWORK.md / STEP7-GUIDE.md**: shared between `research` and `tech`.
  When adding to a new case, copy from an existing case and update only
  artifact name references (e.g. `03-narrative.md` → `04-narrative.md`).

### Rich-text assets (`assets/`)

- `ensure_fonts()` (top of `init-pipeline.sh`) installs the default fonts on
  every run: **Source Han Serif SC** (CJK) + **Source Serif 4** (Latin). It is
  idempotent and never aborts scaffolding on failure.
- `install_richtext_assets()` copies `assets/brand/rights.template.md`, copies the
  full boss_dai corpus (style guide + ~530 articles) into `docs/boss_dai/`, and
  generates `docs/STORYTELLING-REFERENCE.md` (project-relative paths only). The
  corpus is bundled so the generated project is self-contained and does not depend
  on the team-original repo's absolute path. Call it from any new pipeline that
  produces PDF/PPTX/Word output.
- Both helpers rely on `SCRIPT_DIR`/`ASSETS_DIR` to locate `assets/` regardless
  of the current working directory.

### Known design debt

- The research/tech case blocks share ~80% of their Layer-1 research
  engine (question-architect, parallel researchers, analyst, DA,
  report-writer). Phase 2 (deferred) would lift these into shared shell
  functions to eliminate copy-paste maintenance.
- `COWORK.md` and `docs/STEP7-GUIDE.md` are duplicated between research
  and tech cases. A future refactor should emit them from a shared block.
