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
- Test by running `./init-pipeline.sh research` in a temp directory and
  verify all files are generated correctly

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

- **Agent files** (e.g. `paper-analyst`, `devils-advocate`): copy the
  `files['agents/<name>/CLAUDE.md']` entry verbatim between case blocks.
  When fixing a bug in one copy, fix ALL copies.
- **PDF generation recipe**: the HTML→Chromium recipe in the Step 7
  output gate must stay identical across `research`, `tech`, and `explore`.
- **COWORK.md / STEP7-GUIDE.md**: shared between `research` and `tech`.
  When adding to a new case, copy from an existing case and update only
  artifact name references (e.g. `03-narrative.md` → `04-narrative.md`).

### Known design debt

- The research/tech case blocks share ~80% of their Layer-1 research
  engine (question-architect, parallel researchers, analyst, DA,
  report-writer). Phase 2 (deferred) would lift these into shared shell
  functions to eliminate copy-paste maintenance.
- `COWORK.md` and `docs/STEP7-GUIDE.md` are duplicated between research
  and tech cases. A future refactor should emit them from a shared block.
