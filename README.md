# Team Original

Multi-agent team pipeline scaffolds for bootstrapping AI-assisted workflows. One script, three pipelines — each generates a full directory of agent instructions, artifact templates, and orchestration guides tailored to a different goal.

## Pipelines

| Command | Purpose |
|---|---|
| `./init-pipeline.sh research` | Research-to-PPT pipeline — multi-lens research → analysis → narrative → PPT build |
| `./init-pipeline.sh software` | Software development pipeline — requirements → architecture → coding → testing |
| `./init-pipeline.sh study` | Learning guide builder — topic decomposition → resource curation → 7-day study plan |

## Quick Start

```bash
# Scaffold a research project in the current directory
./init-pipeline.sh research

# Edit the generated input.md with your topic
# Then open Claude Code and say:
#   Read CLAUDE.md and start the pipeline
```

## Requirements

- Bash 4+
- Python 3 (for file generation during scaffold)
- [Claude Code](https://claude.ai/code) or compatible AI coding assistant

## Repository Structure

```
.
├── init-pipeline.sh          # Main scaffold script
├── .github/workflows/ci.yml  # CI: shellcheck + markdownlint
└── README.md
```

After running `init-pipeline.sh`, the generated project will contain:

```
.
├── CLAUDE.md                 # Orchestration guide for the pipeline
├── CLAUDE-RESUME.md          # Resume point if pipeline is interrupted
├── COWORK.md                 # Cowork-specific build guide (research pipeline)
├── input.md                  # Your project brief
├── agents/                   # Agent instruction files (one per subagent)
├── artifacts/                # Intermediate and final outputs
├── output/                   # Final deliverables (study pipeline)
└── diagrams/                 # Diagram specs and outputs (research pipeline)
```

## Contributing

This repo requires all changes to go through pull requests. Direct pushes to `main` are not allowed.

1. Create a feature branch
2. Make your changes
3. Open a PR against `main`
4. CI must pass (shellcheck + markdownlint)

## License

Internal use.
