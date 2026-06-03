# Team Original

Multi-agent team pipeline scaffolds for bootstrapping AI-assisted
workflows. One script, three pipelines — each generates a full directory
of agent instructions, artifact templates, and orchestration guides
tailored to a different goal.

## Pipelines

| Command | Purpose |
| ------- | ------- |
| `./init-pipeline.sh research` | Research-to-PPT pipeline |
| `./init-pipeline.sh software` | Software development pipeline |
| `./init-pipeline.sh study` | Learning guide builder |

### research

```text
Step -2: Value Assessment  →  "Should we research this?"
          ROI · alternatives · expert gaps · GO/NO-GO decision
          (skippable if topic is pre-approved)
           ↓
Step -1: Brainstorming      →  "What exactly should we research?"
          Problem reframes · assumptions · analogies · directions
          (skippable if topic is well-defined)
           ↓
Step 0:  Question Architect →  Research framework design
           ↓
Step 1:  3× Parallel Researchers   (technical · strategic · contrarian)
           ↓
Step 2:  Synthesis + Knowledge Gap Map
           ↓
Step 3:  Analyst (first pass)
           ↓
Step 4:  Devil's Advocate
           ↓
Step 5:  Analyst (revision)
           ↓
Step 6:  Narrative Architect + Diagram Specs
           ↓
Step 7:  PPT Build (Cowork)
```

**What's new**: The pipeline now starts with two upstream steps that answer
"whether" and "what" before investing in "how". Step -2 (Value Assessor)
evaluates if the research is worth doing at all — forcing explicit
consideration of ROI, alternatives, and expert input gaps. Step -1
(Brainstorming) explores open-ended problems from multiple perspectives
before decomposing them into researchable questions.

### software

Requirements → QA review → architecture (optional) → QA review →
coding → test case development → testing → report.

### study

Topic decomposition → multi-lens resource curation → 7-day study plan
draft → bias review → final polished output package.

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

```text
.
├── init-pipeline.sh          # Main scaffold script
├── .github/workflows/ci.yml  # CI: shellcheck + markdownlint
├── CLAUDE.md                 # AI assistant guide
├── README.md
└── LICENSE
```

After running `init-pipeline.sh`, the generated project will contain:

```text
.
├── CLAUDE.md                 # Orchestration guide
├── CLAUDE-RESUME.md          # Resume point if interrupted
├── COWORK.md                 # Cowork build guide (research)
├── input.md                  # Your project brief
├── agents/                   # Agent instruction files
├── artifacts/                # Intermediate and final outputs
├── output/                   # Final deliverables (study)
└── diagrams/                 # Diagram specs and outputs (research)
```

## Contributing

All changes must go through pull requests.
Direct pushes to `main` are not allowed.

1. Create a feature branch
2. Make your changes
3. Open a PR against `main`
4. CI must pass (shellcheck + markdownlint)

## License

MIT — see [LICENSE](LICENSE).
