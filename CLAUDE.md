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

## Architecture

The scaffolder is split into three parts:

- **`init-pipeline.sh`** — thin dispatcher (~290 lines). Sets `SCRIPT_DIR` /
  `ASSETS_DIR` / `TEMPLATES_DIR`, sources `lib/common.sh`, then a `case`
  block per pipeline. Each case does only the **dynamic** setup: copies the
  static scaffold with `copy_template <type>`, makes empty working dirs,
  creates empty artifact placeholders, writes `CLAUDE-RESUME.md`, and prints
  the summary.
- **`lib/common.sh`** — shared shell helpers: `usage`, `copy_template`,
  `init_pipeline_log`, `init_empty_artifacts`, `write_resume_file`,
  `ensure_fonts`, `install_richtext_assets`. Sourced by `init-pipeline.sh`;
  relies on `ASSETS_DIR` / `TEMPLATES_DIR` being exported by the caller.
- **`templates/<type>/`** — the **static payload** for each pipeline: agent
  instruction files (`agents/<name>/CLAUDE.md`), the orchestration
  `CLAUDE.md`, `input.md`, `COWORK.md`, `docs/STEP7-GUIDE.md`, etc. These
  are plain files, copied verbatim into the generated project by
  `copy_template`. This is the source of truth for all static content.

> **History**: static content used to be embedded inside the shell script as
> Python `files = {}` dicts written via `python3 << 'PYEOF'` heredocs. That
> made the script ~5700 lines, unreadable, and prone to
> `SyntaxError: unterminated string literal` when content strings were edited.
> Externalizing to `templates/` eliminated that entire class of bug.

## When editing init-pipeline.sh

- **Edit content in `templates/`, not the shell script.** To change an
  agent's instructions or an orchestration guide, edit the corresponding
  file under `templates/<type>/`. The shell script no longer contains any
  scaffold content.
- Only touch `init-pipeline.sh` / `lib/common.sh` for **dynamic behavior**
  (which dirs to create, which artifacts to init, the resume file, summary
  echo). Both must pass `shellcheck`.
- After any change, run `bash test/smoke-test.sh` to verify all six pipeline
  types scaffold correctly (see **Smoke test** under Repository conventions).

## Adding a new pipeline

When adding a new pipeline type:

1. **Create `templates/<name>/`** — add the orchestration `CLAUDE.md`, the
   `agents/<name>/CLAUDE.md` instruction files, `input.md`, and any other
   static files (`COWORK.md`, `docs/STEP7-GUIDE.md`, …) as plain files.
2. **Update `usage()`** in `lib/common.sh` — add the new name to help text.
3. **Add a `case` block** in `init-pipeline.sh` before the `*)` fallback
   (see checklist below).
4. **Update `README.md`**: add to the pipeline table, add a flow diagram
   section, update the generated project structure if needed, increment
   the count ("six pipelines" → "seven pipelines", etc.).
5. **Update `CLAUDE.md`** (this file): add to the available pipelines list.
6. **Update `CHANGELOG.md`**: log the addition under the current date.

### Case block checklist

Each new pipeline case is short — it does only dynamic setup:

- `copy_template <name>` — copies everything static from `templates/<name>/`
- `mkdir -p …` for empty working dirs not carried by templates
  (e.g. `artifacts/src`, `input/pdf`, `diagrams/src`)
- `init_pipeline_log` and `init_empty_artifacts …` for the empty artifacts
- `write_resume_file "<next step>" "<body>"` for `CLAUDE-RESUME.md`
- `install_richtext_assets` if the pipeline produces PDF/PPTX/Word output
- a summary `echo` block (pipeline name, steps, cost estimate, next steps)

### Shared components

- **Agent files** (e.g. `paper-analyst`, `devils-advocate`,
  `report-writer`, `narrative-architect`): these live as **separate files
  per pipeline** under `templates/<type>/agents/…` and are **per-pipeline
  tailored variants**, NOT identical copies. They share a role/section
  skeleton, but the domain content is deliberately customized (e.g.
  `devils-advocate` attacks a *technology assessment* in `tech` but audits
  *knowledge coverage* in `explore`; `report-writer` emits a research report
  in `research` vs a maturity/competitive assessment in `tech`). Artifact
  names and numbering also differ by design. So do NOT blindly copy one over
  another. When fixing a bug common to all variants (a wrong shared artifact
  path, a broken instruction in every copy), audit and fix each template
  file — but preserve each variant's intentional wording.
- **PDF generation recipe**: the HTML→Chromium recipe embedded in the Step 7
  output gate must stay identical across `templates/research`,
  `templates/tech`, and `templates/explore`. It bakes in the default font
  stack (Source Han Serif SC / Source Serif 4), the opt-in storytelling-tone
  step, and the rights-footer step — keep all three copies in sync.
- **COWORK.md / STEP7-GUIDE.md**: shared between `templates/research` and
  `templates/tech` (byte-identical). When adding to a new pipeline, copy the
  file and update only artifact-name references.

### Rich-text assets (`assets/`)

- `ensure_fonts()` (in `lib/common.sh`) installs the default fonts on every
  run: **Source Han Serif SC** (CJK) + **Source Serif 4** (Latin). Idempotent;
  never aborts scaffolding on failure.
- `install_richtext_assets()` copies `assets/brand/rights.template.md`, copies
  the full boss_dai corpus (style guide + ~530 articles) into `docs/boss_dai/`,
  and generates `docs/STORYTELLING-REFERENCE.md` (project-relative paths only).
  The corpus is bundled so the generated project is self-contained. Call it
  from any new pipeline that produces PDF/PPTX/Word output.
- `install_tech_visual_style()` copies
  `assets/articles/technology/image-style.md` into `docs/image-style.md`. This is
  the "Visual Guide" illustration spec (palette + reusable Gemini STYLE prompt)
  used by the **explore** pipeline's `visual-enhancer` for technical-topic
  diagrams. Currently called only from the explore case.
- These helpers rely on `ASSETS_DIR` to locate `assets/` regardless of the
  current working directory.

### `templates/` is payload, not repo docs

`templates/**` is excluded from `markdownlint` (see
`.markdownlint-cli2.jsonc`) — it is content delivered into generated
projects, not documentation of this repo, and does not follow the repo's
markdown style. Linting/formatting the payload is a separate deferred
decision, not a requirement for changes here.

### Known design debt

- `templates/research` and `templates/tech` still duplicate ~80% of their
  Layer-1 research-engine agents and their `COWORK.md` / `STEP7-GUIDE.md`.
  Now that content is in plain files, a future refactor could share them via
  a `templates/_shared/` dir + a copy/compose step in `copy_template`.
