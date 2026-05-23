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

## How to use

```bash
./init-pipeline.sh <research|software|study>
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

## When editing init-pipeline.sh

- The script generates agent instruction files via embedded Python to
  avoid heredoc escaping issues
- Keep Python-generated content in the `PYEOF` blocks — do not use shell
  heredocs for multi-line files with special characters
- Test by running `./init-pipeline.sh research` in a temp directory and
  verify all files are generated correctly
