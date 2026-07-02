#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ASSETS_DIR and TEMPLATES_DIR are consumed by the helpers in lib/common.sh
# (sourced below); exported so shellcheck sees them as used externally.
export ASSETS_DIR="$SCRIPT_DIR/assets"
export TEMPLATES_DIR="$SCRIPT_DIR/templates"

# shellcheck source=lib/common.sh
. "$SCRIPT_DIR/lib/common.sh"

[ $# -eq 0 ] && usage

# --- Pipeline branches ---
#
# Each branch copies its static scaffold from templates/<type>/ (agent
# instruction files, orchestration CLAUDE.md, input templates) and then
# performs the small amount of dynamic setup that cannot live in a static
# file: empty working directories, empty artifact placeholders, the pipeline
# log, and the CLAUDE-RESUME.md status file.

echo "Checking default rich-text fonts..."
ensure_fonts

case "$1" in
    research)
        echo "Setting up Cowork research pipeline in current directory..."

        copy_template research
        install_richtext_assets
        mkdir -p artifacts/versions artifacts/slide-screenshots memory
        mkdir -p diagrams/src
        mkdir -p input/pdf input/web input/repo

        init_pipeline_log
        init_empty_artifacts \
            artifacts/00-value-assessment.md \
            artifacts/00-brainstorm-output.md \
            artifacts/00-question-map.md \
            artifacts/01a-research-technical.md \
            artifacts/01b-research-strategic.md \
            artifacts/01c-research-contrarian.md \
            artifacts/01-research.md \
            artifacts/02-analysis.md \
            artifacts/02a-challenges.md \
            artifacts/02-analysis-final.md \
            artifacts/03-narrative.md \
            artifacts/03-diagram-specs.md

        write_resume_file \
            "Step -2 — Value Assessment (Claude Code phase)" \
            "## Phases\n- **Claude Code** (Steps -2–6): value assessment, brainstorming, question design, research, analysis, canonical report — run with: Read CLAUDE.md and start the pipeline\n- **Step 7 — Output**: Markdown (always) / PDF / PPTX (PPTX via Cowork: Read COWORK.md and build the deck)"

        echo ""
        echo "Research pipeline ready (two-phase: Claude Code research + Cowork PPT)."
        echo ""
        echo "Phase 1 (Claude Code, Steps -2–6):"
        echo "  Step -2: Value Assessor — evaluates ROI, alternatives, expert gaps → GO/NO-GO decision"
        echo "           (auto-skipped if topic is already approved/validated)"
        echo "  Step -1: Brainstorming Agent — explores problem space, generates research directions → STOP"
        echo "           (auto-skipped if topic is already well-defined)"
        echo "  Step 0: Question Architect — decomposes questions, flags blind spots, collects expert input → STOP"
        echo "  Step 1: 3x parallel researchers (technical, strategic, contrarian) — Sonnet"
        echo "  Step 2: Synthesis + Knowledge Gap Map → STOP, accept expert gap-fill"
        echo "  Step 3: Analyst first pass — Opus"
        echo "  Step 4: Devil's Advocate (incl. completeness audit) — Sonnet"
        echo "  Step 5: Analyst revision — Opus → STOP, expert knowledge injection window"
        echo "  Step 6: Narrative Architect — Sonnet → STOP (narrative + diagram specs), confirm"
        echo "Phase 2 (Cowork, Step 7): PPT build — XML-native, 4 stages (content plan → template → parallel editing → review)"
        echo "Cost estimate: 5 Opus + 4 Sonnet (full pipeline with value assessment and brainstorming)."
        echo ""
        echo "Next steps:"
        echo "  1. Edit input.md with your research topic, impact, and alternatives"
        echo "  2. Open Claude Code in this folder and say: Read CLAUDE.md and start the pipeline"
        echo "  3. After Step 6: optionally run /diagram to render diagrams into diagrams/*.png"
        echo "  4. Switch to Cowork and say: Read COWORK.md and build the deck"
        ;;

    software)
        echo "Setting up software development pipeline in current directory..."

        copy_template software
        mkdir -p artifacts/src
        mkdir -p input/pdf input/web input/repo

        init_pipeline_log
        init_empty_artifacts \
            artifacts/01-requirements.md \
            artifacts/01-requirements-qa.md \
            artifacts/02-architecture.md \
            artifacts/02-architecture-qa.md \
            artifacts/03-test-cases.md \
            artifacts/04-report.md

        write_resume_file \
            "Step 1 — Requirements Agent" \
            "## Pipeline steps\n- **Step 1**: Requirements Agent — generates structured requirements\n- **Step 1b**: Requirements QA Agent — reviews requirements\n- **Step 2**: Architect Agent — designs system architecture (optional)\n- **Step 2b**: Architect QA Agent — reviews architecture\n- **Step 3**: Coder Agent — implements code in artifacts/src/\n- **Step 3b**: Testcase Developer — writes test cases\n- **Step 4**: Tester Agent — runs tests, produces report\n\n## How to run\nOpen Claude Code in this folder and say: \`Read CLAUDE.md and start the pipeline\`"

        echo ""
        echo "Software development pipeline ready."
        echo ""
        echo "Created structure:"
        find . -type f -name "*.md" | sort
        echo ""
        echo "Agents: requirements → requirements-qa → architect (optional) → architect-qa → coder → testcase-dev → tester"
        echo "QA agents catch Critical/Contradiction issues before proceeding."
        echo "Code output: artifacts/src/"
        echo ""
        echo "Next step: fill in artifacts/00-user-brief.md, then say: Read CLAUDE.md and start the pipeline"
        ;;

    study)
        echo "Setting up Learning Guide Builder pipeline in current directory..."

        copy_template study
        mkdir -p artifacts output
        mkdir -p input/pdf input/web input/repo

        init_pipeline_log
        init_empty_artifacts \
            artifacts/00-learning-framework.md \
            artifacts/01a-authority-resources.md \
            artifacts/01b-community-resources.md \
            artifacts/01c-critical-perspectives.md \
            artifacts/02-study-plan-draft.md \
            artifacts/03-bias-review.md \
            output/weekly-study-plan.md \
            output/resource-index.md \
            output/self-assessment.md

        write_resume_file \
            "Step 0 — Learning Architect" \
            "## Pipeline steps\n- **Step 0**: Learning Architect — decomposes topic into knowledge map\n- **Step 1**: 3× parallel curators (Authority, Community, Critical)\n- **Step 2**: Study Plan Design — draft 7-day plan → STOP for user review\n- **Step 3**: Bias Review — adversarial quality audit\n- **Step 4**: Final Revision — polished output package\n\n## Output\n- \`output/weekly-study-plan.md\` — 7-day structured learning plan\n- \`output/resource-index.md\` — annotated resource catalog\n- \`output/self-assessment.md\` — comprehensive self-check and mini-project\n\n## How to run\nOpen Claude Code in this folder and say: \`Read CLAUDE.md and start the pipeline\`"

        echo ""
        echo "Learning Guide Builder pipeline ready."
        echo ""
        echo "Pipeline steps:"
        echo "  Step 0: Learning Architect — decomposes topic into knowledge map → STOP"
        echo "  Step 1: 3× parallel curators (Authority, Community, Critical) — Sonnet"
        echo "  Step 2: Study Plan Design — draft 7-day plan → STOP for user review"
        echo "  Step 3: Bias Review — adversarial quality audit — Sonnet"
        echo "  Step 4: Final Revision — polished output package — Opus"
        echo "Cost estimate: 2 Opus + 4 Sonnet."
        echo ""
        echo "Output files (in output/):"
        echo "  weekly-study-plan.md  — 7-day structured learning plan"
        echo "  resource-index.md     — annotated resource catalog"
        echo "  self-assessment.md    — comprehensive self-check and mini-project"
        echo ""
        echo "Next steps:"
        echo "  1. Edit input.md with your learning topic"
        echo "  2. Open Claude Code in this folder and say: Read CLAUDE.md and start the pipeline"
        ;;

    coding)
        echo "Setting up Codebase Deep Analysis pipeline in current directory..."

        copy_template coding
        mkdir -p artifacts diagrams/src
        mkdir -p input/pdf input/web input/repo

        init_pipeline_log
        init_empty_artifacts \
            artifacts/00-overview.md \
            artifacts/01-architecture.md \
            artifacts/01-module-analysis.md \
            artifacts/01-literature-review.md \
            artifacts/02-design-decisions.md \
            artifacts/03-final-report.md

        write_resume_file \
            "Step 0 — Project Surveyor" \
            "## Pipeline steps\n- **Step 0**: Project Surveyor — repo overview and scope confirmation\n- **Step 1**: 3× parallel agents (Architecture Mapper, Module Deep-Diver, Literature & Context Analyst)\n- **Step 2**: Design Interpreter — design decisions, trade-offs, evolution\n- **Step 3**: Synthesis — final onboarding report with diagram specs\n\n## How to run\nOpen Claude Code in this folder and say: \`Read CLAUDE.md and start the pipeline\`"

        echo ""
        echo "Codebase Deep Analysis pipeline ready."
        echo ""
        echo "Pipeline steps:"
        echo "  Step 0: Project Surveyor — repo overview, community health, key modules → STOP"
        echo "  Step 1: 3× parallel agents (Architecture Mapper + Module Deep-Diver + Literature & Context Analyst)"
        echo "  Step 2: Design Interpreter — design philosophy, key decisions, trade-offs, evolution → STOP"
        echo "  Step 3: Synthesis — final onboarding report with diagram specs"
        echo "Cost estimate: 3 Opus + 2 Sonnet."
        echo ""
        echo "Output:"
        echo "  artifacts/03-final-report.md — complete onboarding report (9 sections)"
        echo ""
        echo "Next steps:"
        echo "  1. Edit input.md with the repo URL and your interests"
        echo "  2. Open Claude Code in this folder and say: Read CLAUDE.md and start the pipeline"
        ;;

    tech)
        echo "Setting up technology assessment research pipeline in current directory..."

        copy_template tech
        install_richtext_assets
        mkdir -p artifacts/versions memory papers
        mkdir -p diagrams/src artifacts/slide-screenshots
        mkdir -p input/pdf input/web input/repo

        init_pipeline_log
        init_empty_artifacts \
            artifacts/00-question-map.md \
            artifacts/01a-research-leadership.md \
            artifacts/01b-research-competitive.md \
            artifacts/01c-research-trend.md \
            artifacts/01d-research-challenges.md \
            artifacts/01e-paper-analysis.md \
            artifacts/01f-repo-analysis.md \
            artifacts/01-research.md \
            artifacts/02-analysis.md \
            artifacts/02a-challenges.md \
            artifacts/02-analysis-final.md \
            artifacts/03-report.md \
            artifacts/04-narrative.md \
            artifacts/04-diagram-specs.md

        write_resume_file \
            "Step 0 — Tech Question Architect" \
            "## Phases\n- **Claude Code** (Steps 0-6): question design, 4-lens research, analysis, canonical technical report — run with: Read CLAUDE.md and start the pipeline\n- **Step 7 — Output**: Markdown (always) / PDF / PPTX (PPTX via Cowork: Read COWORK.md and build the deck)"

        echo ""
        echo "Technology assessment research pipeline ready (canonical report + Step 7 output selection: md / pdf / pptx)."
        echo ""
        echo "Pipeline steps (Claude Code, Steps 0-6):"
        echo "  Step 0: Tech Question Architect — decomposes questions, flags tech blind spots → STOP"
        echo "  Step 1: 4x parallel researchers (leadership, competitive, trend, challenges) — Sonnet"
        echo "  Step 2: Synthesis + Knowledge Gap Map + key-papers list → STOP, expert gap-fill + paper deep-dive prompt"
        echo "  Step 2.5 (OPTIONAL, user-gated): Paper Analyst — reads/translates seed papers to papers/<id>-zh.md — Sonnet"
        echo "  Step 2.6 (OPTIONAL, user-gated): Repo Analyst — analyzes GitHub specs/RFCs/issues → 01f-repo-analysis.md — Sonnet"
        echo "  Step 3: Tech Analyst first pass — Opus"
        echo "  Step 4: Devil's Advocate (incl. completeness audit) — Sonnet"
        echo "  Step 5: Tech Analyst revision — Opus → STOP, expert knowledge injection window"
        echo "  Step 6: Report Writer — Opus → artifacts/03-report.md"
        echo "Cost estimate: 3 Opus + 5 Sonnet (+1 Sonnet each if paper / repo deep-dive runs)."
        echo ""
        echo "Steps 0-6 produce artifacts/03-report.md (canonical technical assessment report)."
        echo "Step 7 lets you pick outputs: Markdown (always) / PDF (HTML->PDF) / PPTX (Narrative Architect, Sonnet)."
        echo "PPTX hands off to Cowork: open Cowork and say 'Read COWORK.md and build the deck'."
        echo ""
        echo "Next steps:"
        echo "  1. Edit input.md with your technology assessment target"
        echo "  2. Open Claude Code in this folder and say: Read CLAUDE.md and start the pipeline"
        ;;

    explore)
        echo "Setting up knowledge exploration & mastery pipeline in current directory..."

        copy_template explore
        install_richtext_assets
        mkdir -p artifacts/versions memory papers images

        echo "# Pipeline log" > artifacts/00-pipeline-log.md
        : > artifacts/00-question-map.md
        : > artifacts/01a-research-history.md
        : > artifacts/01b-research-concepts.md
        : > artifacts/01c-research-landscape.md
        : > artifacts/01d-research-critique.md
        : > artifacts/01e-paper-analysis.md
        : > artifacts/01-research.md
        : > artifacts/02-challenges.md
        : > artifacts/03-report.md
        : > artifacts/03-report-illustrated.md
        printf '# CLAUDE-RESUME.md\n\n## Current status\n\n**Next step**: Step 0 — Topic Architect\n\n## Phases\n- **Claude Code** (Steps 0-5): topic decomposition, 4-lens research, synthesis, devil'\''s advocate, knowledge report, visual enhancement\n- Run with: Read CLAUDE.md and start the pipeline\n- Final deliverables: artifacts/03-report.md (text report) + artifacts/03-report-illustrated.md (illustrated version, if Step 5 opted in)\n' > CLAUDE-RESUME.md

        echo ""
        echo "Knowledge exploration & mastery pipeline ready (report output)."
        echo ""
        echo "Pipeline steps (Claude Code, Steps 0-4):"
        echo "  Step 0: Topic Architect — decomposes topic into question map → STOP"
        echo "  Step 1: 4x parallel researchers (history, concepts, landscape, critique) — Sonnet"
        echo "  Step 2: Synthesis + Knowledge Gap Map → STOP, expert gap-fill + paper deep-dive option"
        echo "  Step 2.5 (OPTIONAL): Paper Analyst — reads/translates papers via Skill tool — Sonnet"
        echo "  Step 3: Devil's Advocate — knowledge coverage audit (NOT recommendation attack) — Sonnet"
        echo "  Step 4: Knowledge Report Writer — Opus → artifacts/03-report.md"
        echo "  Step 5 (OPTIONAL): Visual Enhancer — adds 5-8 images (search + AI generate) → 03-report-illustrated.md — Sonnet"
        echo "Cost estimate: 2 Opus + 5 Sonnet (+1 Sonnet if paper deep-dive runs, +1 Sonnet if visual enhancement runs)."
        echo ""
        echo "Final deliverable: artifacts/03-report.md (knowledge mastery report)"
        echo "After the report: you can ask follow-up questions — the full research context is available."
        echo ""
        echo "Next steps:"
        echo "  1. Edit input.md with your topic"
        echo "  2. Open Claude Code in this folder and say: Read CLAUDE.md and start the pipeline"
        ;;
    *)
        usage
        ;;
esac
