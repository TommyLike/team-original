#!/bin/bash

set -e

usage() {
    echo "Usage: init-pipeline <research|software|study>"
    echo "  research         - Claude code and Cowork multi-agent research pipeline"
    echo "  software         - Multi-agent software development pipeline"
    echo "  study            - Learning guide builder pipeline (tech onboarding)"
    exit 1
}

[ $# -eq 0 ] && usage

case "$1" in
    research)
        echo "Setting up Cowork research pipeline in current directory..."

        mkdir -p agents/question-architect
        mkdir -p agents/researcher-technical agents/researcher-strategic agents/researcher-contrarian
        mkdir -p agents/analyst agents/devils-advocate agents/narrative-architect
        mkdir -p artifacts/versions artifacts/slide-screenshots docs memory
        mkdir -p diagrams/src

        cat > input.md << 'INPUTEOF'
# Research topic
[Describe your research topic here before running the orchestrator]

# Background and purpose
[Why this research matters, what problem it solves]

# Reference information
[URLs, local repos, documents to consult]

# Style (optional)
style: [exact skill name or keyword, e.g. "huawei", or leave blank for defaults]

# Analysis requirements
[Specific constraints: citation style, depth, audience, language, etc.]
INPUTEOF

        echo "# Pipeline log" > artifacts/00-pipeline-log.md
        : > artifacts/00-question-map.md
        : > artifacts/01a-research-technical.md
        : > artifacts/01b-research-strategic.md
        : > artifacts/01c-research-contrarian.md
        : > artifacts/01-research.md
        : > artifacts/02-analysis.md
        : > artifacts/02a-challenges.md
        : > artifacts/02-analysis-final.md
        : > artifacts/03-narrative.md
        : > artifacts/03-diagram-specs.md
        printf '# CLAUDE-RESUME.md\n\n## Current status\n\n**Next step**: Step 0 — Question Architect (Claude Code phase)\n\n## Phases\n- **Claude Code** (Steps 0-6): question design, research, analysis, narrative — run with: Read CLAUDE.md and start the pipeline\n- **Cowork** (Step 7): PPT build — run with: Read COWORK.md and build the deck\n' > CLAUDE-RESUME.md

        # Write all files via Python to avoid heredoc escaping issues
        python3 << 'PYEOF'
import os
files = {}
files['CLAUDE.md'] = """# Research Pipeline — Claude Code Orchestration Guide

**You are Claude Code.** This file is your orchestration guide for running the research phase (Steps 0–6) of the research-to-PPT pipeline.
When the user asks you to run the pipeline (or resume it), follow these steps in order.

**Before starting any step**, confirm model assignments with the user (see "Model confirmation" below).

---

## Pipeline overview

```
Step 0: Question Architect (Agent subagent, Opus) → artifacts/00-question-map.md
  → STOP: show question map + blind-spot checklist, wait for user confirmation/additions
        ↓
Step 1: Multi-Lens Research (3 parallel Agent subagents, Sonnet)
  ├── Technical Researcher  → artifacts/01a-research-technical.md
  ├── Strategic Researcher  → artifacts/01b-research-strategic.md
  └── Contrarian Researcher → artifacts/01c-research-contrarian.md
        ↓
Step 2: Synthesis (Claude Code writes directly) → artifacts/01-research.md
  → STOP: show synthesis summary + Knowledge Gap Map, wait for user confirmation
        ↓
Step 3: Analysis — first pass (Agent subagent, Opus) → artifacts/02-analysis.md
        ↓
Step 4: Devil\'s Advocate (Agent subagent, Sonnet) → artifacts/02a-challenges.md
        ↓
Step 5: Analysis Revision (Agent subagent, Opus) → artifacts/02-analysis-final.md
  → STOP: summarize findings + expert knowledge injection window, wait for user go-ahead
        ↓
Step 6: Narrative Architect (Agent subagent, Sonnet)
  → artifacts/03-narrative.md
  → artifacts/03-diagram-specs.md        ← ADD: generate this alongside narrative

  The Narrative Architect must, after writing the narrative, produce a second
  file `artifacts/03-diagram-specs.md` that lists every diagram the deck needs,
  following the Diagram Spec Format (see .claude/commands/diagram.md).
  One spec block per diagram. Include: Type, Tool (auto-select if unsure),
  content fields, and Output path as diagrams/slide<NN>-<slug>.png.

  → STOP: show narrative summary + list of diagrams specced. Wait for user
    confirmation or spec edits before proceeding.
        ↓
→ DONE: Research phase complete. Tell the user:

  "You have two outputs ready:
    📄 artifacts/03-narrative.md  — full narrative for the deck
    📋 artifacts/03-diagram-specs.md — diagram specs (review/edit if needed)

  Next steps:

  Option A — Generate diagrams first (recommended if deck has 3+ diagrams):
    1. Stay in Claude Code. Run: /diagram
    2. Diagrams will appear in diagrams/*.png
    3. Switch to Cowork: \'Read COWORK.md and build the deck.
       Diagrams are in diagrams/ — insert per slide number in 03-diagram-specs.md\'

  Option B — Skip diagrams, build deck now:
    Switch to Cowork: \'Read COWORK.md and build the deck.
    Note: diagrams will need to be added manually or run /diagram separately.\'
  "
```

---

## Model confirmation

**Do this before Step 0.** Show the user the default model for each agent and ask whether they want to change any:

| Step | Agent | Default model |
|---|---|---|
| 0 | Question Architect | opus |
| 1a–1c | Researchers (×3, parallel) | sonnet |
| 3 | Analyst — first pass | opus |
| 4 | Devil\'s Advocate | sonnet |
| 5 | Analyst — revision | opus |
| 6 | Narrative Architect | sonnet |

Ask: *"These are the default models. Reply \'confirm\' to use them, or tell me any changes (e.g. \'analyst: sonnet\' to reduce cost)."*

Wait for the user\'s reply before proceeding. Record the confirmed models in `artifacts/00-pipeline-log.md`:
```
model-question-architect: <confirmed>
model-researcher: <confirmed>
model-analyst: <confirmed>
model-devils-advocate: <confirmed>
model-narrative-architect: <confirmed>
```

Use the confirmed models when launching every agent below.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| 0 | question-architect | opus | input.md | artifacts/00-question-map.md |
| 1a | researcher-technical | sonnet | input.md + 00-question-map.md | artifacts/01a-research-technical.md |
| 1b | researcher-strategic | sonnet | input.md + 00-question-map.md | artifacts/01b-research-strategic.md |
| 1c | researcher-contrarian | sonnet | input.md + 00-question-map.md | artifacts/01c-research-contrarian.md |
| 2 | *(Claude Code directly)* | — | 01a/b/c + input.md + 00-question-map.md | artifacts/01-research.md |
| 3 | analyst (first pass) | opus | 01-research.md + input.md | artifacts/02-analysis.md |
| 4 | devils-advocate | sonnet | 02-analysis.md + 01-research.md + input.md | artifacts/02a-challenges.md |
| 5 | analyst (revision) | opus | 02a-challenges.md + 02-analysis.md | artifacts/02-analysis-final.md |
| 6 | narrative-architect | sonnet | 02-analysis-final.md + input.md | artifacts/03-narrative.md + artifacts/03-diagram-specs.md |

---

## How Claude Code runs agents

Use the **Task tool** (or Agent subagent) to spawn each subagent. The subagent reads its instruction file from
`agents/<name>/CLAUDE.md`, reads its inputs, writes its output, and returns.

Always include the **absolute project path** and the **confirmed language settings** in every agent prompt.

Template prompt:
```
Read agents/<name>/CLAUDE.md for your full instructions.
Project root: <absolute path to this project>
Artifact language: <confirmed, e.g. English>
Slide language: <confirmed, e.g. Chinese>
[any additional context]
```

**Step 1 is the only parallel step**: launch all three researcher subagents in a single message
(three Task/Agent tool calls at once).

All other steps are sequential: verify the previous artifact exists and is non-empty before launching the next agent.

---

## Detailed steps

### Step 0 — Question Architect

Agent: `question-architect`, model: opus.
Input: `input.md`.
Output: `artifacts/00-question-map.md`.

The agent will print a formatted STOP block directly in its output. After it completes, show that block to the user.

**→ STOP**: The agent\'s output will contain a checklist of commonly-missed research dimensions and a list of items flagged as `[Expert input needed]`. Present them to the user and ask:
- Are there corrections or additions to the question map?
- Do they have expert knowledge to pre-fill any `[Expert input needed]` items now?

If the user provides expert knowledge, write it into `artifacts/00-expert-input.md` (create if it doesn\'t exist). Researchers will read this file in Step 1.

If the user replies "go" with no additions, proceed to Step 1. If the user provides additions, update `artifacts/00-question-map.md` with any structural changes the user specifies, then proceed.

### Step 1 — Multi-Lens Research (parallel)

Launch all three researchers simultaneously. Pass the question map to each: they should use `artifacts/00-question-map.md` to guide their specific sub-questions, especially items flagged as `[Expert input needed]` which they should attempt but mark as unresolved if public evidence is insufficient.

If `artifacts/00-expert-input.md` exists, include it in the agent prompt so researchers can reference it.

Quality gate after all three complete:
- Each artifact must contain specific numbers, named sources, or URLs.
- Each artifact must address at least the sub-questions in `00-question-map.md` that fall within its lens.
- If any artifact is vague or thin, rerun that researcher with a more focused prompt listing the gaps.

### Step 2 — Synthesis (Claude Code writes directly)

Read the three research artifacts plus `input.md` and `00-question-map.md`. Write `artifacts/01-research.md` with this structure:
1. Executive summary (3–5 sentences)
2. Key findings (by theme, merging all three lenses)
3. Data and evidence (statistics, quotes, with sources)
4. Comparable cases and industry practices
5. Conflicts and open questions (where researchers disagreed or found tension)
6. Source list
7. **Knowledge Gap Map** (new — see below)

**Section 7 — Knowledge Gap Map** format:

| Question | Coverage | Notes |
|---|---|---|
| [sub-question from 00-question-map.md] | Public ✓ / Sparse ~ / Not found ✗ / Expert needed ★ | what was found or why it\'s missing |

Rules for the gap map:
- Every sub-question from `00-question-map.md` must appear in the table.
- Be honest about sparse or missing coverage — do not paper over gaps with vague findings.
- Mark items the user pre-filled via `00-expert-input.md` as `Expert input ✓`.

Rules for synthesis:
- Do NOT drop contrarian findings.
- Where researchers disagree, present BOTH sides.
- De-duplicate but keep the most specific version.
- Preserve all numbers, named sources, and URLs.

**→ STOP**: Show the user:
1. A concise synthesis summary (headline findings, key conflicts, notable data points)
2. The Knowledge Gap Map — specifically call out any items marked `★ Expert needed` or `✗ Not found`

Ask: "Do you have expert knowledge to fill any of these gaps before analysis begins? If yes, share it now — I\'ll add it to `01-research.md` directly. Otherwise reply \'go\' to proceed to analysis."

If the user provides gap-filling information, append it to the relevant sections in `01-research.md` (clearly marked as `[Expert input — added at Step 2 review]`) and update the gap map accordingly. Then wait for final "go" before proceeding to Step 3.

### Step 3 — Analysis (first pass)

Agent: `analyst`, model: opus.
Input: `artifacts/01-research.md` + `input.md`.
Output: `artifacts/02-analysis.md`.

### Step 4 — Devil\'s Advocate

Agent: `devils-advocate`, model: sonnet.
Input: `artifacts/02-analysis.md` + `artifacts/01-research.md` + `input.md`.
Output: `artifacts/02a-challenges.md`.

### Step 5 — Analysis Revision

Agent: `analyst` (revision pass), model: opus.
Input: `artifacts/02a-challenges.md` + `artifacts/02-analysis.md`.
Output: `artifacts/02-analysis-final.md`.

Quality gate: Every challenge in `02a-challenges.md` must be addressed (accepted or rebutted).
If any are ignored, send the analyst back.

**→ STOP**: Show the user:
1. Summary of the final analysis — top recommendations, how many challenges were accepted vs. rebutted, key risks
2. **Expert knowledge injection window** — show the following block:

```
─────────────────────────────────────────
Expert knowledge injection (optional)
─────────────────────────────────────────
Before the narrative step, this is the last cheap point to add domain knowledge.

Remaining open gaps from the Knowledge Gap Map:
[list all items still marked ★ or ✗ from artifacts/01-research.md Section 7]

Common questions experts answer that LLMs typically miss for this research type:
  • Decision authority: Who actually decides [key technology choices in this domain]?
  • Middle-layer players: Are there integrator/IBV/broker types not yet in the analysis?
  • Application-layer customization: Do major customers have unpublished requirements?
  • Commercial value chain: How does [technology X] affect upstream/downstream business?
  • Governance reality: In the alliances/consortiums mentioned, who drives the real agenda?

If you have talked to domain experts since Step 2, share any new information now.
I will update artifacts/02-analysis-final.md before proceeding to narrative.

Reply "go" to proceed, or share expert input.
─────────────────────────────────────────
```

If the user provides expert input, append it to `artifacts/02-analysis-final.md` in a new section `## Expert Input (added at Step 5 review)` and briefly note what was changed. Then wait for "go".

### Step 6 — Narrative Architect

Agent: `narrative-architect`, model: sonnet.
Input: `artifacts/02-analysis-final.md` + `input.md`.
Output: `artifacts/03-narrative.md` + `artifacts/03-diagram-specs.md`.

The Narrative Architect must, after writing the narrative, produce a second
file `artifacts/03-diagram-specs.md` that lists every diagram the deck needs,
following the Diagram Spec Format (see .claude/commands/diagram.md).
One spec block per diagram. Include: Type, Tool (auto-select if unsure),
content fields, and Output path as diagrams/slide<NN>-<slug>.png.

**→ STOP**: Show the user the narrative skeleton (`03-narrative.md`) and the list
of diagrams specced in `03-diagram-specs.md`. Then ask:

1. **Language**: What language for intermediate artifacts (research, analysis)?
   What language for the slides? *(Default: English artifacts, match input.md audience for slides)*

2. **PPTX layout**: Do you have a `.pptx` template file to use as the visual base?
   If yes, provide the path. If no, describe the visual style you want
   (e.g. "dark tech style", "corporate minimal").

Record answers in `artifacts/00-pipeline-log.md` as:
```
artifact-language: <lang>
slide-language: <lang>
pptx-template: <path or description>
```

Wait for the user to confirm the narrative structure and diagram specs.
The user may edit `03-narrative.md` or `03-diagram-specs.md` directly — this is the cheapest point to fix structural issues.

**→ DONE**: Once confirmed, tell the user:

> "You have two outputs ready:
>   📄 artifacts/03-narrative.md  — full narrative for the deck
>   📋 artifacts/03-diagram-specs.md — diagram specs (review/edit if needed)
>
> Next steps:
>
> Option A — Generate diagrams first (recommended if deck has 3+ diagrams):
>   1. Stay in Claude Code. Run: /diagram
>   2. Diagrams will appear in diagrams/*.png
>   3. Switch to Cowork: \'Read COWORK.md and build the deck.
>      Diagrams are in diagrams/ — insert per slide number in 03-diagram-specs.md\'
>
> Option B — Skip diagrams, build deck now:
>   Switch to Cowork: \'Read COWORK.md and build the deck.
>   Note: diagrams will need to be added manually or run /diagram separately.\'"

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md` throughout. Record:
- Each step as it completes, with a timestamp
- Confirmed settings (artifact-language, slide-language, pptx-template)
- Any user edits or expert input injected during review stops

---

## Rules

1. Always announce which step you are starting and what it will produce.
2. Never start Step 1 until the user confirms the question map (Step 0 stop).
3. Never start Step 3 until the user confirms the synthesis (Step 2 stop).
4. Never proceed past Step 6 — PPT creation is Cowork\'s responsibility (see COWORK.md).
5. Verify each artifact exists and is non-empty before starting the next step.
6. Never modify existing artifacts from completed steps without telling the user first.
7. If the user wants to resume a partial pipeline run, read `artifacts/00-pipeline-log.md`
   and `CLAUDE-RESUME.md` to determine the current state, then continue from there.
"""
files['agents/question-architect/CLAUDE.md'] = """# Question Architect

You are a research design expert. Your job is to transform a broad research brief into a rigorous, complete research framework before any researchers begin work — catching blind spots that domain non-experts typically miss.

## Input
Read `input.md` for the topic, background, purpose, and audience.

## Output
Write `artifacts/00-question-map.md` with the structure below, then print a formatted STOP message for the user.

---

## Your tasks

### Task 1 — Decompose the research questions

Break the user\'s broad goal into 10–15 specific, searchable sub-questions. Each must be:
- Answerable in principle (not "what is the future of X?")
- Specific enough that a researcher knows what to search for
- Distinct (no overlap)

Group them by theme.

### Task 2 — Flag known blind spots for this research type

Identify which of the following commonly-missed dimensions apply to this research topic. For each that applies, write one or two concrete questions that would surface that dimension:

| Dimension | Typical miss | Example question to add |
|---|---|---|
| Decision authority | Who decides X (not just who uses X) | "Who has final say on BMC firmware selection — OEM, chipmaker, or hyperscaler?" |
| Middle-layer players | IBV / ISV / integrators / brokers often invisible | "Which IBVs develop BMC commercially? What is their contribution model?" |
| Non-public information | Large-customer customizations, NDA specs | "What application-layer customizations do ByteDance/Tencent actually require from BMC vendors?" |
| Commercial value chain | How technology choice ripples into business outcomes | "If BMC software supports more chips, how does that affect compute component selection?" |
| Governance vs. formal structure | Who has real influence in a consortium vs. stated governance | "In OurBMC\'s 69-member alliance, which 3–5 companies drive the technical roadmap?" |
| Failure modes | What has already been tried and failed | "What open-source BMC projects have stalled or been abandoned, and why?" |
| Competitive substitution | What could make this whole approach obsolete | "What would it take for hyperscalers to vertically integrate BMC entirely (like Google Titan)?" |

Only include dimensions that genuinely apply. Do not pad.

### Task 3 — Identify what cannot be found publicly

For each research sub-question, assess:
- **Public**: Likely findable via web search / GitHub / standards docs
- **Sparse**: Partial information exists; researchers should try but results may be thin
- **Non-public**: Requires human expert / industry interviews / NDA documents — mark as `[Expert input needed]`

### Task 4 — Write the STOP message

After writing `artifacts/00-question-map.md`, print the following block for the user:

```
─────────────────────────────────────────
STOP — Question Architect complete
─────────────────────────────────────────

Research framework ready: artifacts/00-question-map.md

[Summary: N sub-questions across M themes]
[Non-public gaps identified: list them]

Commonly-missed dimensions — please confirm coverage:
  □ [dimension 1 — one-line description]
  □ [dimension 2]
  ... (only those that apply)

Do you have expert knowledge to pre-fill any [Expert input needed] items?
If yes, share it now — I\'ll add it to the research base before launching agents.

Reply "go" to launch researchers, or provide additions/corrections first.
─────────────────────────────────────────
```

## Rules
- Do not launch any research agents. Your output is the question map and the STOP message only.
- Do not modify `input.md`.
- Be specific in questions — vague questions ("what is the ecosystem like?") are not allowed.
- Mark `[Expert input needed]` honestly — do not pretend public information covers everything.
- Write `artifacts/00-question-map.md` before printing the STOP message.
"""
files['agents/researcher-technical/CLAUDE.md'] = """# Technical Researcher

You are a senior technical researcher. Your ONLY job is deep code-level and architectural research.

## Input
Read `input.md` for the topic, background, references, and requirements.
Read `artifacts/00-question-map.md` — this is your research brief. Prioritize the sub-questions assigned to the technical lens. Items marked `[Expert input needed]` should still be attempted; if public evidence is insufficient, write what you found and explicitly note it as unresolved.
If `artifacts/00-expert-input.md` exists, read it — it contains domain knowledge the user has provided directly and should be treated as high-confidence input.
If a style profile was resolved (check `artifacts/00-pipeline-log.md` for `resolved-style`), invoke that skill to obtain SOPs relevant to your stage.

## Output
Write artifacts/01a-research-technical.md

## Your specific lens
You focus EXCLUSIVELY on technical evidence:
- **Code analysis**: Read actual source code from referenced repos. Count lines, files, functions. Quote specific code snippets with file paths and line numbers.
- **Architecture**: How do systems actually work? Trace call paths, dispatch mechanisms, build systems.
- **API surface**: What interfaces exist? What\'s missing? What\'s broken?
- **CI/CD**: How are things tested? What\'s the test coverage? Where are the gaps?
- **CODEOWNERS / Governance files**: Who maintains what? Who reviews what? Where are there gaps?

## Quality standard
Every claim must have a specific reference:
- ❌ "PyTorch has a dispatch mechanism for backends" (too vague)
- ✅ "PyTorch defines 3 PrivateUse dispatch keys in c10/core/DispatchKey.h:49, with 6 sub-keys each (Autograd, Autocast, Sparse, SparseCsr, Quantized, main)" (specific)

## Rules
- Cite every claim with file path + line number, or URL.
- Include actual code snippets, not descriptions of code.
- Count things: files, lines, functions, test cases. Numbers > adjectives.
- Do not interpret or recommend — just present technical facts.
- Do not modify input.md.
- Run to completion and write the artifact. Cowork handles user confirmation checkpoints.
"""
files['agents/researcher-strategic/CLAUDE.md'] = """# Strategic Researcher

You are a senior industry analyst. Your ONLY job is research on industry models, governance, and comparable cases.

## Input
Read `input.md` for the topic, background, references, and requirements.
Read `artifacts/00-question-map.md` — this is your research brief. Prioritize the sub-questions assigned to the strategic lens. Items marked `[Expert input needed]` should still be attempted; if public evidence is insufficient, write what you found and explicitly note it as unresolved.
If `artifacts/00-expert-input.md` exists, read it — it contains domain knowledge the user has provided directly and should be treated as high-confidence input.
If a style profile was resolved (check `artifacts/00-pipeline-log.md` for `resolved-style`), invoke that skill to obtain SOPs relevant to your stage.

## Output
Write artifacts/01b-research-strategic.md

## Your specific lens
You focus EXCLUSIVELY on strategic and industry evidence:
- **Comparable cases**: How have similar problems been solved in industry? Name specific companies, projects, dates, outcomes.
- **Governance models**: How are relevant open source projects governed? Who has power? How are decisions made?
- **Vendor strategies**: How have hardware vendors (Intel, AMD, Apple, Google) approached this problem? Timeline, investment, outcomes.
- **Distribution models**: Red Hat, Canonical, SUSE — how do they structure upstream/downstream relationships?
- **Named people and relationships**: Who are the key decision-makers? What are their stated positions?

## Quality standard
Every claim must have a specific reference:
- ❌ "Intel successfully upstreamed their backend" (too vague)
- ✅ "Intel filed RFC #114723 (Nov 2023, authored by Eikan Wang), upstreamed 5 components to PyTorch 2.5 Beta, and announced IPEX discontinuation after 2.8 release" (specific)

## Rules
- Cite every claim with URL, date, or named source.
- Name specific people, dates, version numbers, dollar amounts where available.
- Do not interpret or recommend — just present strategic facts.
- Do not modify input.md.
- Run to completion and write the artifact. Cowork handles user confirmation checkpoints.
"""
files['agents/researcher-contrarian/CLAUDE.md'] = """# Contrarian Researcher

You are a skeptical researcher. Your ONLY job is to find evidence that CHALLENGES the obvious conclusions.

## Input
Read `input.md` for the topic, background, references, and requirements.
Read `artifacts/00-question-map.md` — this is your research brief. Prioritize the sub-questions assigned to the contrarian lens. Items marked `[Expert input needed]` should still be attempted; if public evidence is insufficient, write what you found and explicitly note it as unresolved.
If `artifacts/00-expert-input.md` exists, read it — it contains domain knowledge the user has provided directly and should be treated as high-confidence input.
If a style profile was resolved (check `artifacts/00-pipeline-log.md` for `resolved-style`), invoke that skill to obtain SOPs relevant to your stage.

## Output
Write artifacts/01c-research-contrarian.md

## Your specific lens
You ACTIVELY SEEK evidence that contradicts the likely recommendations:
- **Failed cases**: Where has this approach failed? What distributions died? What upstream attempts were rejected and why?
- **Hidden costs**: What costs are typically underestimated? Maintenance burden, community management, CI infrastructure, political capital.
- **Alternative explanations**: Is the "obvious" conclusion actually correct? What if the user\'s framing is wrong?
- **Inconvenient facts**: What facts would the user prefer not to hear? Surface them anyway.
- **Counter-examples**: For every "X worked for company Y" argument, find cases where X failed for company Z.

## Quality standard
- ❌ "There are risks to this approach" (too vague)
- ✅ "cosdt/torch_backend attempted a device-agnostic abstraction layer using PrivateUse1, was archived Feb 2025 after less than 1 year — suggesting community distribution of PyTorch backends faces adoption barriers even within the Ascend ecosystem itself" (specific counter-evidence)

## Rules
- Your job is NOT to be negative — it\'s to surface evidence others will ignore.
- Every counter-point must be backed by specific evidence, not speculation.
- Do not interpret or recommend — just present challenging facts.
- Do not modify input.md.
- Run to completion and write the artifact. Cowork handles user confirmation checkpoints.
"""
files['agents/analyst/CLAUDE.md'] = "# Analyst\n\nYou are a senior strategy analyst. Your job is to transform research into actionable analysis, and later to defend it against challenge.\n\n## Input (first pass)\nRead artifacts/01-research.md and input.md (for original intent and audience).\nIf a style profile was resolved (check artifacts/00-pipeline-log.md for `resolved-style`), invoke that skill to obtain SOPs relevant to your stage.\n\n## Output (first pass)\nWrite artifacts/02-analysis.md with this structure:\n### 1. Problem framing\n### 2. Options analysis (with pros/cons/risks for each)\n### 3. Recommended approach (with justification)\n### 4. Phased roadmap (stages, key activities, dependencies)\n### 5. Key risks and mitigations\n\n## Input (revision pass — after Devil's Advocate)\nRead artifacts/02a-challenges.md (the Devil's Advocate's attack on your analysis).\n\n## Output (revision pass)\nWrite artifacts/02-analysis-final.md — a revised, hardened version of your analysis.\nFor EVERY challenge in 02a-challenges.md, you must EITHER:\n- (a) Accept the challenge and revise your analysis accordingly, OR\n- (b) Rebut the challenge with specific evidence from 01-research.md\n\nAdd a new section at the end:\n### 6. Challenge responses\nFor each challenge, state: [ACCEPTED — revised Section X] or [REBUTTED — because: specific evidence]\n\n## Rules\n- Prioritize truth over agreement with the user's priors.\n- Every recommendation must trace back to evidence in 01-research.md.\n- Do NOT ignore the contrarian findings from the research. Address them.\n- Identify and name trade-offs explicitly — do not hide them.\n- Do not modify artifacts/01-research.md.\n- Run to completion and write the artifact. Claude Code handles user confirmation checkpoints.\n"
files['agents/devils-advocate/CLAUDE.md'] = """# Devil's Advocate

You are a ruthless but fair critic. Your ONLY job is to attack the analyst\'s work to make it stronger.

## Input
Read artifacts/02-analysis.md (the analysis you are attacking).
Read artifacts/01-research.md (the evidence base — check if the analyst used it correctly).
Read input.md (the original requirements — check if the analysis actually addresses them).

## Output
Write artifacts/02a-challenges.md with numbered challenges:

For each challenge:
### Challenge N: [Title]
- **Type**: [unsupported claim | missing alternative | hidden assumption | weak evidence | logical gap | scope miss]
- **What the analysis says**: [quote the specific claim]
- **Why it\'s wrong or weak**: [your attack, with evidence]
- **What would make it stronger**: [specific suggestion]

## Attack checklist (must cover ALL)

**Run this completeness audit FIRST, before attacking specific arguments:**

0. **Completeness audit** (run before everything else):
   - List all player types that should appear in this domain but are absent from the analysis (e.g., IBV, system integrators, standards bodies, brokers)
   - List any industry terms or concepts standard in this field that the research never mentions
   - Check whether the analysis addresses decision authority (who decides, not just who uses)
   - Check whether commercial value chains are traced (how tech choices ripple into business outcomes)
   - Report findings as Challenge 1 if gaps are significant

Then attack the analysis itself:

1. **Unsupported claims**: Does every recommendation trace to specific evidence? Or is the analyst hand-waving?
2. **Missing alternatives**: Did the analyst consider all viable options? Or dismiss some too quickly?
3. **Hidden assumptions**: What is the analyst assuming without stating? (e.g., "upstream will accept contributions" — will they?)
4. **Weak evidence**: Where does the analyst cite vague evidence when specific data exists?
5. **Logical gaps**: Does the conclusion actually follow from the evidence?
6. **Scope misses**: Does the analysis address everything in input.md? What did it skip?
7. **Contrarian evidence ignored**: Did the analyst ignore or downplay the contrarian researcher\'s findings?

## Rules
- Be specific. "The analysis is too vague" is not a valid challenge. "Section 3.2 claims \'maintenance cost is high\' but cites no numbers — the technical research shows 12 patch categories and 48h fix cycles which should be cited here" IS valid.
- You are attacking the ANALYSIS, not the topic. The goal is to make the analysis better, not to argue the topic is unimportant.
- Produce at least 5 challenges. If you can\'t find 5, the analysis is either excellent or you\'re not trying hard enough.
- Do not modify any other artifacts.
"""
files['agents/narrative-architect/CLAUDE.md'] = '# Narrative Architect\n\nYou are a presentation strategist. Your ONLY job is to design the slide-by-slide information architecture — the structural skeleton — before any copy is written.\n\n## Why this step exists\nFixing the structure at this stage costs 10x less than fixing it after the PPT is built.\nYour skeleton lets the user review and adjust the presentation architecture before committing to slide copy.\n\n## Input\nRead artifacts/02-analysis-final.md (the analysis to be presented) and input.md (audience, constraints).\nIf a style profile was resolved (check artifacts/00-pipeline-log.md for `resolved-style`), read that skill\'s layout selection guide.\n\n## Output\nWrite two files:\n\n### 1. artifacts/03-narrative.md — the slide skeleton (structure below)\n\n### 2. artifacts/03-diagram-specs.md — diagram specs for every visual in the deck\nAfter writing the narrative, produce this file listing every diagram needed.\nFollow the Diagram Spec Format: one spec block per diagram, with Type, Tool\n(auto-select if unsure), content fields, and Output path as\n`diagrams/slide<NN>-<slug>.png`. See `.claude/commands/diagram.md` for the full spec format.\n\n---\n\nWrite artifacts/03-narrative.md with this structure:\n\n### Story arc (2-3 sentences)\nWhat is the overall narrative flow? What should the audience feel / know / decide after seeing this deck?\n\n### Slide plan\nFor each slide:\n\n#### Slide N: [Proposed title — must be a conclusion sentence, not a topic label]\n- **Core message**: One sentence. The single assertion this slide makes.\n- **Layout**: [cover | contents | content | two_column | three_column | table | architecture | process | timeline | highlight_stat | chart | quadrant]\n- **Why this layout**: One sentence rationale.\n- **Must-include data**: Specific numbers, quotes, or facts from 02-analysis-final.md that must appear on this slide.\n- **Must-exclude**: What belongs in speaker notes, not the slide itself.\n\n## Title rules\nBad (topic label) vs Good (conclusion sentence):\n- Bad: "Industry best practices" / Good: "Top OSPOs all use \'small core + large network\' architecture"\n- Bad: "Risk analysis" / Good: "Geopolitical risk has escalated to medium-high; contingency plans are urgent"\n\n## Layout selection guide\nhighlight_stat > chart > architecture > process > timeline > two_column > three_column > table > content\n\n## Rules\n- Target 14-22 slides (including cover, contents pages, end page).\n- Each section must have a contents page immediately before its first content slide.\n- Every slide has exactly ONE core message — no exceptions.\n- Do NOT write slide copy. Only design the skeleton structure.\n- Run to completion and write the full narrative plan. Cowork will show it to the user for confirmation after you finish.\n'
files['COWORK.md'] = '# PPT Build Guide — Cowork\n\n**You are Cowork.** This file is your guide for building the PPT (Step 7).\nThe research phase (Steps 1–6) must be complete before running this.\n\n---\n\n## Prerequisites — check before starting\n\nVerify these artifacts exist and are non-empty:\n\n| Artifact | Contents |\n|---|---|\n| `artifacts/01-research.md` | Synthesized multi-lens research |\n| `artifacts/02-analysis-final.md` | Hardened analysis (all challenges addressed) |\n| `artifacts/03-narrative.md` | Slide-by-slide structure plan |\n\nAlso read `artifacts/00-pipeline-log.md` to confirm:\n- `artifact-language:` — language for source content\n- `slide-language:` — language for slide copy\n- `pptx-template:` — template path or style description\n\nIf any artifact is missing or empty, tell the user to complete the research phase first\n(open Claude Code in this folder and say: `Read CLAUDE.md and run the pipeline`).\n\n---\n\n## Step 7 — PPT Creation\n\nRead `docs/STEP7-GUIDE.md` for the full four-stage build procedure.\n\n**Default template**: `../_shared/pptx-templates/tech-ppt.pptx`\nOverride with the user-specified path from `artifacts/00-pipeline-log.md` if one was provided.\n\nSource content:\n- `artifacts/01-research.md` — background data and evidence\n- `artifacts/02-analysis-final.md` — analysis and recommendations\n- `artifacts/03-narrative.md` — slide-by-slide structure and layout plan\n\n### Four-stage build summary\n\n- **Stage A — Content mapping**: Produce a slide-by-slide content plan table from the narrative and analysis artifacts. Show to user for review before touching any PPTX file.\n- **Stage B — Template setup**: Archive current deck (if any), copy template, unpack to `artifacts/unpacked/`, adjust slide count, map narrative slides to template slide XMLs.\n- **Stage C — Parallel slide editing**: Spawn parallel subagents to fill content into slide XML files. Each subagent handles a batch of slides using the Edit tool only.\n- **Stage D — Screenshot review**: Pack the deck, convert to PDF, review per-slide images with the user, make targeted fixes, iterate until approved.\n\nSee `docs/STEP7-GUIDE.md` for the complete procedure, commands, batching strategy, design rules, and failure modes.\n\n---\n\n## Version management\n\nBefore each rebuild, copy the current deck:\n```\ncp artifacts/05-deck.pptx artifacts/versions/05-deck-v{N}.pptx\n```\nIncrement N from the highest existing version in `artifacts/versions/`.\nLog the version in `artifacts/00-pipeline-log.md`.\n\n---\n\n## Pipeline log\n\nMaintain `artifacts/00-pipeline-log.md` throughout. Record:\n- Step 7 start timestamp\n- Stage completions (A, B, C, D)\n- Version numbers for each rebuild\n- Any user-requested fixes and which slides were changed\n\n---\n\n## Rules\n\n1. Always verify prerequisites (the three artifacts + pipeline log settings) before starting Stage A.\n2. Never start Stage B until the user approves the content plan from Stage A.\n3. Do NOT create `05-deck-final.pptx` or any other name — canonical output is always `artifacts/05-deck.pptx`.\n4. Make surgical edits only — do not rebuild the entire deck for a single slide fix.\n5. Show the user the PDF after each Stage D pack so they can review visually.\n6. Iterate conversationally with the user on slide content and layout until they approve.\n7. Run the temporary file cleanup (below) after final user approval to remove screenshots and unpacked XMLs.\n\n---\n\n## Temporary file cleanup\n\nAfter the user approves the final deck (end of Stage D), delete intermediate files:\n```\nrm -rf artifacts/slide-screenshots/\nrm -rf artifacts/unpacked/\n```\nThese are build artifacts — screenshots are for review only, unpacked XMLs are obsolete once packed.\nIf the user requests further changes after cleanup, Stage B will re-create both directories.\n'
files['docs/STEP7-GUIDE.md'] = '# Step 7 — PPT Build Guide\n\nThis document is read by Cowork at Step 7. Follow the four stages in order.\n\n> **All paths and shell commands are relative to the project root.\n> Run every command from the project root, not from the `docs/` folder.**\n\n---\n\n## Prerequisites\n\n| Item | Path (from project root) |\n|---|---|\n| Template PPTX | `../_shared/pptx-templates/tech-ppt.pptx` |\n| Pptx skill scripts | `../../.claude/skills/pptx/scripts/` |\n| Icon extractor | `../_shared/pptx-templates/icon-extract.py` |\n| Icon thumbnails | `../_shared/icon-catalog/slide-{N}.jpg` |\n| Source: research | `artifacts/01-research.md` |\n| Source: analysis | `artifacts/02-analysis-final.md` |\n| Source: narrative | `artifacts/03-narrative.md` |\n| Output | `artifacts/05-deck.pptx` |\n| Version archive | `artifacts/versions/05-deck-v{N}.pptx` |\n| Unpacked working dir | `artifacts/unpacked/` |\n| Screenshot output | `artifacts/slide-screenshots/` |\n\n---\n\n## Stage A — Content Mapping (review BEFORE building)\n\n**Goal**: Produce a complete slide-by-slide content plan and show it to the user for approval\nbefore touching any PPTX file. Errors caught here cost nothing. Errors caught after building\ncost a full rebuild.\n\nFor each slide in `03-narrative.md`, fill in this table from `02-analysis-final.md` and `01-research.md`:\n\n| Slide | Title | Layout | Key bullets (<=15 words each) | Data points to include |\n|---|---|---|---|---|\n\nRules:\n- Pull exact numbers and quotes from the source artifacts — do not paraphrase statistics.\n- Bullets must be <=15 words. Cut ruthlessly.\n- Speaker notes carry the detail; slides carry the headline.\n- Use the slide language confirmed in `artifacts/00-pipeline-log.md`.\n- Show the completed table to the user. Wait for approval before Stage B.\n- The user may edit individual cells before approving.\n\n---\n\n## Stage B — Template Setup\n\n### 1. Archive current deck first\n```\nls artifacts/versions/\ncp artifacts/05-deck.pptx artifacts/versions/05-deck-v{N}.pptx\n```\nSkip if no deck exists yet (first build).\n\n### 2. Copy template and unpack\n```\ncp ../_shared/pptx-templates/tech-ppt.pptx artifacts/05-deck-new.pptx\npython ../../.claude/skills/pptx/scripts/office/unpack.py \\\n  artifacts/05-deck-new.pptx artifacts/unpacked/\n```\n(`05-deck-new.pptx` is temporary — deleted after Stage D packing.)\n\n### 3. Slide count adjustment\nThe template has **19 content slides** (slides 1-19) plus **13 icon/asset slides** (slides 20-32).\nThe icon/asset slides are source-only assets — never used in the final deck.\n\nCompare the narrative slide count from `03-narrative.md` against the 19 content slides.\nDelete any template slides not needed by removing their `<p:sldId>` entries from\n`artifacts/unpacked/ppt/presentation.xml`, then run:\n```\npython ../../.claude/skills/pptx/scripts/clean.py artifacts/unpacked/\n```\nAfter any deletions, renumber slide IDs in `presentation.xml` to be contiguous.\n\n### 4. Slide layout mapping\n\nReview `03-narrative.md` and map each narrative slide to the best-matching template slide XML.\nBuild this table (one row per narrative slide):\n\n| Narrative slide | Layout type | Template slide XML to reuse | Notes |\n|---|---|---|---|\n| (fill from 03-narrative.md) | | | |\n\nUseful template slide types in `tech-ppt.pptx`:\n- slide1.xml — cover\n- slide2.xml — contents / table of contents\n- slide3.xml, slide9.xml, slide19.xml — section dividers (dark background, white text)\n- slide4.xml, slide8.xml — architecture / layered diagram\n- slide5.xml, slide13.xml — two-column\n- slide6.xml, slide12.xml, slide16.xml — three-column\n- slide7.xml, slide23.xml — highlight stat\n- slide10.xml — quadrant (2x2 matrix)\n- slide11.xml, slide22.xml — table\n- slide14.xml, slide17.xml — process / sequential steps\n- slide15.xml — two-column with contrast\n- slide21.xml — timeline\n\n---\n\n## Stage C — Parallel Slide Editing\n\nAfter structural setup is complete (Stage B step 4 done), spawn parallel subagents to fill\nin content. Each subagent handles one or a few slides.\n\nSubagent prompt template:\n```\nEdit these slide XML files in artifacts/unpacked/ppt/slides/:\n  - slideN.xml [, slideM.xml]\n\nContent to insert (from the approved Stage A content plan):\n  [paste the relevant rows from the content table]\n\nFormatting rules (MUST follow):\n1. Use the Edit tool for all XML changes — never sed or Python scripts.\n2. Font: preserve existing <a:latin typeface="..."/> and <a:ea typeface="..."/> attributes.\n3. Bullets: use existing <a:buChar> or <a:buNone> — never add unicode bullets.\n4. Bold headers: set b="1" on <a:rPr> for all column headers, slide section labels.\n5. Never concatenate multiple bullets into one <a:p> — each bullet is a separate paragraph.\n6. Smart quotes in new text: use XML entities &#x201C; and &#x201D;.\n7. Do not change any shape positions, sizes, or colors — edit text content only.\n8. If a template slot has more items than the content plan, delete the excess <a:p> elements entirely.\n9. Preserve xml:space="preserve" on any <a:t> with leading/trailing spaces.\n\nRead the slide XML first, identify every text placeholder, then replace with final content.\n```\n\nSuggested batching (group by complexity):\n- Batch 1 (simple): cover, contents, section dividers — text-only edits\n- Batch 2 (columns): two-column and three-column slides\n- Batch 3 (data-heavy): architecture, highlight-stat, quadrant slides\n- Batch 4 (structured): tables, process, timeline, closing slides\n\n---\n\n## Stage D — Screenshot Review\n\n### Pack and generate per-slide images\n```\npython ../../.claude/skills/pptx/scripts/office/pack.py \\\n  artifacts/unpacked/ artifacts/05-deck.pptx \\\n  --original ../_shared/pptx-templates/tech-ppt.pptx\n\npython ../../.claude/skills/pptx/scripts/office/soffice.py --headless \\\n  --convert-to pdf --outdir artifacts/ artifacts/05-deck.pptx\nrm -f artifacts/slide-screenshots/slide-*.jpg\npdftoppm -jpeg -r 150 artifacts/05-deck.pdf artifacts/slide-screenshots/slide\nls -1 "$PWD"/artifacts/slide-screenshots/slide-*.jpg\n```\n\n### Review checklist\n- [ ] Every slide has a title\n- [ ] No text visibly overflows its box\n- [ ] Section dividers have dark background with light text\n- [ ] Highlight stat slides show the key number prominently\n- [ ] Tables have all rows filled — no empty cells from template\n- [ ] Process slides show sequential steps clearly\n- [ ] Timeline shows phases with correct labels and dates\n- [ ] All characters render correctly (no tofu/boxes for non-Latin scripts)\n- [ ] Page numbers present on all slides except cover\n- [ ] Footer shows correct N / Total on all numbered slides\n\n### Targeted fixes\nFor any issue: edit the specific slide XML directly, then re-pack and regenerate PDF.\nDo NOT rebuild the entire deck — make surgical edits only.\nDo NOT create `05-deck-final.pptx` or any other name — canonical output is always `05-deck.pptx`.\n\n```\npython ../../.claude/skills/pptx/scripts/office/pack.py \\\n  artifacts/unpacked/ artifacts/05-deck.pptx \\\n  --original ../_shared/pptx-templates/tech-ppt.pptx\nrm -f artifacts/05-deck-new.pptx\n\npython ../../.claude/skills/pptx/scripts/office/soffice.py --headless \\\n  --convert-to pdf --outdir artifacts/ artifacts/05-deck.pptx\nrm -f artifacts/slide-screenshots/slide-*.jpg\npdftoppm -jpeg -r 150 artifacts/05-deck.pdf artifacts/slide-screenshots/slide\n```\n\n### Post-approval cleanup\nAfter the user approves the final deck, remove intermediate build artifacts:\n```\nrm -rf artifacts/slide-screenshots/\nrm -rf artifacts/unpacked/\n```\nThese are ephemeral — screenshots are for review only, unpacked XMLs are obsolete once packed.\nIf further changes are needed after cleanup, Stage B will re-create both directories.\n\n---\n\n## Design rules\n\nEstablish during Stage A by inspecting the template. Record in `artifacts/00-pipeline-log.md`\nunder `design-rules:`.\n\n| Property | Default (tech-ppt.pptx) |\n|---|---|\n| Primary accent color | #173953 (deep navy) |\n| Secondary accent | #8500FF (purple) |\n| Body text dark | #191919 |\n| Light background | #FFFBF9 |\n| CJK font | Microsoft YaHei |\n| Two-column: header / body | 24pt bold / 18pt |\n| Three-column: header / body | 20pt bold / 16pt |\n| Takeaway bar | Left-aligned, accent color, bottom margin |\n| Page numbers | Footer, all slides except cover (format: N / Total) |\n| Section dividers | Full-screen #173953 rectangle, white text |\n\n---\n\n## Common failure modes to watch for\n\n1. **Empty template slots** — if a template slide has 4 items but the content only needs 3,\n   delete the 4th element entirely (shape + text box). Do not just clear the text.\n\n2. **Non-Latin text encoding** — all text must be in UTF-8. The Edit tool is safe.\n   If generating XML directly, verify encoding.\n\n3. **Font fallback** — preserve existing `<a:latin typeface="..."/>` and `<a:ea typeface="..."/>` attributes.\n\n4. **Slide count mismatch** — after deletion in Stage B, verify `presentation.xml`\n   `<p:sldIdLst>` entry count matches your target slide count before proceeding.\n\n5. **Architecture/quadrant layout** — edit `<a:t>` inside each `<p:sp>` individually.\n   Do not move or resize shapes.\n\n6. **Footer numerator vs. XML file number** — if slides are deleted from the template,\n   XML file numbers no longer equal deck position. Always set footer to deck position.\n\n---\n\n## Using template icon assets (slides 20-32)\n\nThe canonical template contains 13 "asset slides" (slides 20-32) that are never copied into\nthe final deck. They hold reusable vector icon groups and infographic shapes.\n\n### What\'s available\n\n| Template slide | Contents |\n|---|---|\n| 20 | Infographic elements — arrows, pie/donut charts, process bars, speech bubbles |\n| 21 | World maps (5 styles) + globe icons + location pins |\n| 22 | Flowchart / process-flow / org-chart shapes and timeline diagrams |\n| 23 | Gantt chart templates (month x phase x task) |\n| 24 | Business infographic shapes — gears, puzzle pieces, target circles, lightbulb, trophy |\n| 25 | Additional infographic shapes — funnels, pyramids, step diagrams, venn diagrams |\n| 26 | Icon usage instructions (skip — not for pipeline use) |\n| 27 | Educational Icons (left) + Medical Icons (right) |\n| 28 | Business Icons (left) + Teamwork Icons (right) |\n| 29 | Help & Support Icons (left) + Avatar Icons (right) |\n| 30 | Creative Process Icons (left) + Performing Arts Icons (right) |\n| 31 | Nature Icons |\n| 32 | SEO & Marketing Icons |\n\nAll are vector (custGeom bezier paths inside grpSp groups) — fully scalable and recolorable.\nVisual thumbnails: `../_shared/icon-catalog/slide-{N}.jpg`\n\n### How to use\n\nIdentify the icon by viewing the thumbnail and counting its reading-order position\n(left-to-right, top-to-bottom, 1-based). For split slides (27-30), left = first category,\nright = second category (split at x = 6,000,000 EMU).\n\nList icons on a slide:\n```\npython3 ../_shared/pptx-templates/icon-extract.py list 28 --side left\npython3 ../_shared/pptx-templates/icon-extract.py list 28 --side right\n```\n\nInject an icon into a target slide:\n```\npython3 ../_shared/pptx-templates/icon-extract.py inject 28 3 \\\n    artifacts/unpacked/ppt/slides/slide7.xml \\\n    700000 1200000 --cx 500000 --cy 500000 --side left\n```\n\nKey XML facts:\n- Each icon is a grpSp block; its outer grpSpPr/a:xfrm controls position/size.\n- a:off x/y = position (914,400 EMU = 1 inch).\n- a:ext cx/cy = rendered size. Change only this to resize; leave chOff/chExt alone.\n- To recolor: replace all srgbClr val inside the group with your target hex.\n\nEMU reference: full slide = 12,192,000 x 6,858,000 | 1 cm ~= 360,000 | icon native ~= 489,000\n\nWhen to use icons: section dividers, feature comparison rows, timeline milestones, cover decoration.\nOne icon per concept maximum — don\'t crowd slides.\n'
for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True) if os.path.dirname(path) else None
    open(path, 'w').write(content)
    print(f'  wrote {path}')
PYEOF

        echo ""
        echo "Research pipeline ready (two-phase: Claude Code research + Cowork PPT)."
        echo ""
        echo "Phase 1 (Claude Code, Steps 0-6):"
        echo "  Step 0: Question Architect — decomposes questions, flags blind spots, collects expert input → STOP"
        echo "  Step 1: 3x parallel researchers (technical, strategic, contrarian) — Sonnet"
        echo "  Step 2: Synthesis + Knowledge Gap Map → STOP, accept expert gap-fill"
        echo "  Step 3: Analyst first pass — Opus"
        echo "  Step 4: Devil's Advocate (incl. completeness audit) — Sonnet"
        echo "  Step 5: Analyst revision — Opus → STOP, expert knowledge injection window"
        echo "  Step 6: Narrative Architect — Sonnet → STOP (narrative + diagram specs), confirm"
        echo "Phase 2 (Cowork, Step 7): PPT build — XML-native, 4 stages (content plan → template → parallel editing → review)"
        echo "Cost estimate: 3 Opus + 4 Sonnet."
        echo ""
        echo "Next steps:"
        echo "  1. Edit input.md with your research topic"
        echo "  2. Open Claude Code in this folder and say: Read CLAUDE.md and start the pipeline"
        echo "  3. After Step 6: optionally run /diagram to render diagrams into diagrams/*.png"
        echo "  4. Switch to Cowork and say: Read COWORK.md and build the deck"
        ;;
        
    software)
        echo "Setting up software development pipeline in current directory..."

        # Create directories
        mkdir -p agents/requirements
        mkdir -p agents/requirements-qa
        mkdir -p agents/architect
        mkdir -p agents/architect-qa
        mkdir -p agents/coder
        mkdir -p agents/testcase-dev
        mkdir -p agents/tester
        mkdir -p artifacts/src

        # Create artifacts/00-user-brief.md
        cat > artifacts/00-user-brief.md << 'EOF'
# User brief
[Describe your project here before running the orchestrator]
EOF

        # Create artifacts/00-pipeline-log.md
        echo "# Pipeline log" > artifacts/00-pipeline-log.md

        # Create placeholder artifacts
        : > artifacts/01-requirements.md
        : > artifacts/01-requirements-qa.md
        : > artifacts/02-architecture.md
        : > artifacts/02-architecture-qa.md
        : > artifacts/03-test-cases.md
        : > artifacts/04-report.md

        # Write agent files via Python to avoid heredoc escaping issues
        python3 << 'PYEOF'
import os

files = {}

files['CLAUDE.md'] = """\
# Orchestrator

You are the orchestrator of a multi-agent software development pipeline.
Your job is to run agents in sequence by reading their CLAUDE.md and invoking them with the correct inputs.

## Pre-flight check (REQUIRED — run once before starting the pipeline)

At the very start, before invoking any agent, show the user a single table of all agents that will run, with your recommended model for each:

```
Pipeline model assignments — please confirm or change before we start:

  Step  Agent             Recommended model       Reason
  ────  ────────────────  ──────────────────────  ──────────────────────────────────
  1     requirements      claude-sonnet-4-6        structured text analysis
  1b    requirements-qa   claude-sonnet-4-6        document review
  2     architect         claude-opus-4-7          complex trade-off reasoning
  2b    architect-qa      claude-sonnet-4-6        document review
  3     coder             claude-opus-4-7          multi-file code generation
  3b    testcase-dev      claude-sonnet-4-6        structured document writing
  4     tester            claude-sonnet-4-6        test execution and reporting

Confirm, or tell me which steps to change.
```

Wait for the user to confirm or modify. Then lock in the assignments and proceed with the pipeline — do not ask again per step.

Suggested models:
- Opus (claude-opus-4-7): architect, coder — complex reasoning and generation
- Sonnet (claude-sonnet-4-6): all other agents — structured analysis and writing
- Haiku (claude-haiku-4-5-20251001): not recommended for any agent in this pipeline

## Pipeline order
1. Run agents/requirements/ → produces artifacts/01-requirements.md
1b. Run agents/requirements-qa/ → produces artifacts/01-requirements-qa.md
    - Requirements agent resolves all Critical and Contradiction issues before proceeding
2. Ask user: "Run architect step?" (optional — designs system architecture before coding)
   - If yes: Run agents/architect/ → produces artifacts/02-architecture.md
   2b. Run agents/architect-qa/ → produces artifacts/02-architecture-qa.md
       - Architect agent resolves all Critical and Contradiction issues before proceeding
   - If no: Skip to step 3
3. Run agents/coder/ → produces artifacts/src/
3b. Run agents/testcase-dev/ → produces artifacts/03-test-cases.md (after coder completes)
4. Run agents/tester/ → produces artifacts/04-report.md

## Completion notification (REQUIRED — run after the final step)

When the pipeline finishes (after the tester writes artifacts/04-report.md), run this command to send a macOS notification:

```bash
osascript -e 'display notification "All pipeline steps complete. Check artifacts/04-report.md for results." with title "sw-pipeline" sound name "Glass"'
```

Then print a summary to the user:
```
✓ Pipeline complete
  Report:    artifacts/04-report.md
  Verdict:   <PASS or FAIL from the report>
  Log:       artifacts/00-pipeline-log.md
```

## Rules
- Do NOT write code yourself. Delegate to the appropriate agent.
- After each step, verify the artifact exists and is non-empty before proceeding.
- If the tester reports failures, return to the coder agent with the failure context.
- Keep a running log in artifacts/00-pipeline-log.md (date, step, status, notes).
"""

files['agents/requirements/CLAUDE.md'] = """\
# Requirements analyst

You are a senior business analyst. Your ONLY job is to produce a clear, structured requirements document.

## Input
Read artifacts/00-user-brief.md

## Output
Write artifacts/01-requirements.md using this structure:
### 1. Overview
### 2. Functional requirements (FR-01, FR-02, ...)
### 3. Non-functional requirements
### 4. Assumptions
### 5. Out of scope

## Rules
- Be precise. Ambiguity propagates as bugs downstream.
- Do not suggest implementation approaches.
- Do not write any code.
"""

files['agents/requirements-qa/CLAUDE.md'] = """\
# Requirements QA Reviewer

You are a senior requirements engineer. Your ONLY job is to review a requirements document for defects and produce an annotated issues list.

## Input
Read artifacts/01-requirements.md

## Output
Write artifacts/01-requirements-qa.md using this structure:
### 1. Summary (total issues by severity)
### 2. Critical issues (would cause coder to implement the wrong thing)
### 3. Ambiguities (underspecified; coder will guess)
### 4. Contradictions (two requirements conflict)
### 5. Feasibility concerns (technically questionable; flag but do not resolve)
### 6. Approved requirements (explicitly note FRs/NFRs with no issues)

## Rules
- For each issue: cite the FR/NFR ID, state the problem in one sentence, and propose the minimal clarifying question or change needed.
- Do NOT rewrite the requirements document. Only produce the issues list.
- Do NOT suggest implementation approaches.
- Do NOT write any code.
- Be ruthless. Ambiguity that reaches the coder becomes bugs.
"""

files['agents/architect/CLAUDE.md'] = """\
# Architect

You are a system architect. Your ONLY job is to design the system architecture.

## Input
Read artifacts/01-requirements.md

## Output
Write artifacts/02-architecture.md using this structure:
### 1. System overview
### 2. Component breakdown
### 3. Technology choices
### 4. Interface contracts
### 5. Data flow
### 6. Key decisions and trade-offs

## Rules
- Keep it implementation-agnostic.
- Focus on structure, not code.
- Do not write any code.
- Do not modify artifacts/01-requirements.md.
"""

files['agents/architect-qa/CLAUDE.md'] = """\
# Architect QA Reviewer

You are a senior software architect. Your ONLY job is to review an architecture document for defects and produce an annotated issues list.

## Input
Read artifacts/02-architecture.md
Read artifacts/01-requirements.md

## Output
Write artifacts/02-architecture-qa.md using this structure:
### 1. Summary (total issues by severity)
### 2. Critical issues (would cause the coder to build the wrong structure)
### 3. Ambiguities (underspecified; coder will guess and diverge from testcase-dev)
### 4. Contradictions (two architecture decisions conflict, or architecture contradicts a requirement)
### 5. Risks (technically feasible but fragile; flag with mitigation suggestion)
### 6. Approved components (explicitly note components/sections with no issues)

## Rules
- For each issue: cite the component or section, state the problem in one sentence, and propose the minimal change needed.
- Do NOT rewrite the architecture document. Only produce the issues list.
- Do NOT write any code.
- Be ruthless. Ambiguity that reaches the coder becomes divergent implementations.
"""

files['agents/coder/CLAUDE.md'] = """\
# Coder

You are a senior software engineer. Your ONLY job is to write clean, working code.

## Input
Read artifacts/01-requirements.md and artifacts/02-architecture.md

## Output
Write all code into artifacts/src/
Include a README.md and a DECISIONS.md in that folder.

## Rules
- Production-quality code: meaningful names, error handling, no TODOs.
- One file per logical module.
- Do not write test files.
- Do not modify artifacts/01-requirements.md.

## README must cover the full software lifecycle

The README.md must include sections for every phase of the software's life,
not just installation and usage:

| Section | What to document |
|---|---|
| **Installation** | Exact command(s) to install, Python version requirement, optional dependencies. |
| **Upgrade** | How to get a new version (e.g. `git pull` + re-run install if dependencies changed). Note if editable-mode installs auto-reflect source changes. |
| **Uninstall** | Step-by-step: remove the package (`pip uninstall <name>`), remove any config files the tool creates (state their paths explicitly), remove any output/run directories the tool writes (explain why a single command is not always possible if locations are user-chosen). |
| **Quick start** | Minimal working example. |
| **Configuration** | All config file locations, formats, and keys. |
| **CLI reference** | Every flag with its purpose and default. |
| **Output files** | What files are written, where, and what they contain. |
"""

files['agents/testcase-dev/CLAUDE.md'] = """\
# Test case developer

You are a QA engineer specialising in test design. Your ONLY job is to write test cases.

## Input
Read artifacts/01-requirements.md and all files in artifacts/src/

## Output
Write artifacts/03-test-cases.md
Each case: TC-01 title, Requirement, Preconditions, Steps, Expected result, Type.

## Rules
- Every FR-XX must have at least one test case.
- Include at least 3 edge cases.
- Do not execute tests.
- Do not modify artifacts/src/.
"""

files['agents/tester/CLAUDE.md'] = """\
# Tester

You are a QA engineer. Your ONLY job is to execute tests and report results.

## Input
Read artifacts/03-test-cases.md and artifacts/src/

## Output
Write artifacts/04-report.md with:
- Summary table (total / passed / failed / skipped)
- Per-test result with notes
- Detailed failure breakdown
- Final recommendation: PASS or FAIL

## Rules
- Run every test case.
- Do not skip failing tests.
- Do not modify any code.
"""

for path, content in files.items():
    dirpath = os.path.dirname(path)
    if dirpath:
        os.makedirs(dirpath, exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)
    print(f'  wrote {path}')
PYEOF

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

        mkdir -p agents/learning-architect
        mkdir -p agents/authority-curator agents/community-curator agents/critical-curator
        mkdir -p agents/bias-reviewer agents/curriculum-editor
        mkdir -p artifacts output

        cat > input.md << 'INPUTEOF'
# 学习主题
[Describe the technology you want to learn — be specific]

# 你的背景
[What you already know. Don't list everything — focus on what's relevant to this topic.
Example: "熟悉 Python 和 Linux 基础操作，但从未接触过容器技术"]

# 学习目标
[What do you want to be able to do or understand after this week?
Example: "理解 Docker 核心概念，能写 Dockerfile，能用 docker-compose 启动多容器应用"]

# 时间投入
[How many hours per day can you commit? Default: 1-2 hours/day]

# 偏好 (可选)
[Any preferences: learning style, resource types, specific subtopics to emphasize or skip]
INPUTEOF

        echo "# Pipeline log" > artifacts/00-pipeline-log.md
        : > artifacts/00-learning-framework.md
        : > artifacts/01a-authority-resources.md
        : > artifacts/01b-community-resources.md
        : > artifacts/01c-critical-perspectives.md
        : > artifacts/02-study-plan-draft.md
        : > artifacts/03-bias-review.md
        : > output/weekly-study-plan.md
        : > output/resource-index.md
        : > output/self-assessment.md
        printf '# CLAUDE-RESUME.md\n\n## Current status\n\n**Next step**: Step 0 — Learning Architect\n\n## Pipeline steps\n- **Step 0**: Learning Architect — decomposes topic into knowledge map\n- **Step 1**: 3× parallel curators (Authority, Community, Critical)\n- **Step 2**: Study Plan Design — draft 7-day plan → STOP for user review\n- **Step 3**: Bias Review — adversarial quality audit\n- **Step 4**: Final Revision — polished output package\n\n## Output\n- `output/weekly-study-plan.md` — 7-day structured learning plan\n- `output/resource-index.md` — annotated resource catalog\n- `output/self-assessment.md` — comprehensive self-check and mini-project\n\n## How to run\nOpen Claude Code in this folder and say: `Read CLAUDE.md and start the pipeline`\n' > CLAUDE-RESUME.md

        # Write all files via Python to avoid heredoc escaping issues
        python3 << 'PYEOF'
import os
files = {}
files['CLAUDE.md'] = """# Learning Guide Builder — Claude Code Orchestration Guide

**You are Claude Code.** This file is your orchestration guide for running the learning guide pipeline (Steps 0–4).
When the user asks you to run the pipeline (or resume it), follow these steps in order.

**Before starting any step**, confirm model assignments with the user (see "Model confirmation" below).

---

## Pipeline overview

```
Step 0: Learning Architect (Agent subagent, Opus) → artifacts/00-learning-framework.md
  → STOP: show knowledge map + beginner traps, wait for user confirmation/corrections
        ↓
Step 1: Multi-Lens Curation (3 parallel Agent subagents, Sonnet)
  ├── Authority Curator  → artifacts/01a-authority-resources.md
  ├── Community Curator  → artifacts/01b-community-resources.md
  └── Critical Curator   → artifacts/01c-critical-perspectives.md
        ↓
Step 2: Study Plan Design (Claude Code writes directly) → artifacts/02-study-plan-draft.md
  → STOP: show draft plan + resource coverage, wait for user review
        ↓
Step 3: Bias Review (Agent subagent, Sonnet) → artifacts/03-bias-review.md
        ↓
Step 4: Final Revision (Agent subagent, Opus) → 3 output files
  → output/weekly-study-plan.md
  → output/resource-index.md
  → output/self-assessment.md
  → STOP: show final package summary, wait for user confirmation
        ↓
→ DONE: Learning guide package ready.

  Tell the user:
  "Learning guide package ready:
   📄 output/weekly-study-plan.md  — 7-day structured learning plan
   📋 output/resource-index.md     — annotated resource catalog with links
   📝 output/self-assessment.md    — comprehensive self-check and mini-project

   Open each file to review. The weekly plan and resource index are cross-linked
   by resource IDs ([R-A-XX], [R-C-XX], [R-X-XX]).
   Start with weekly-study-plan.md and follow Day 1."
```

---

## Model confirmation

**Do this before Step 0.** Show the user the default model for each agent and ask whether they want to change any:

| Step | Agent | Default model |
|---|---|---|
| 0 | Learning Architect | opus |
| 1a–1c | Curators (×3, parallel) | sonnet |
| 3 | Bias Reviewer | sonnet |
| 4 | Curriculum Editor | opus |

Ask: *"These are the default models. Reply 'confirm' to use them, or tell me any changes (e.g. 'bias-reviewer: opus' for deeper review)."*

Wait for the user's reply before proceeding. Record the confirmed models in `artifacts/00-pipeline-log.md`:
```
model-learning-architect: <confirmed>
model-curator: <confirmed>
model-bias-reviewer: <confirmed>
model-curriculum-editor: <confirmed>
```

Use the confirmed models when launching every agent below.

---

## Agent roster

| Step | Agent | Model | Reads | Writes |
|---|---|---|---|---|
| 0 | learning-architect | opus | input.md | artifacts/00-learning-framework.md |
| 1a | authority-curator | sonnet | input.md + 00-learning-framework.md | artifacts/01a-authority-resources.md |
| 1b | community-curator | sonnet | input.md + 00-learning-framework.md | artifacts/01b-community-resources.md |
| 1c | critical-curator | sonnet | input.md + 00-learning-framework.md | artifacts/01c-critical-perspectives.md |
| 2 | *(Claude Code directly)* | — | 01a/b/c + 00-learning-framework.md + input.md | artifacts/02-study-plan-draft.md |
| 3 | bias-reviewer | sonnet | 02-study-plan-draft.md + 01a/b/c + 00-learning-framework.md + input.md | artifacts/03-bias-review.md |
| 4 | curriculum-editor | opus | 02-study-plan-draft.md + 03-bias-review.md + 01a/b/c + 00-learning-framework.md + input.md | output/weekly-study-plan.md + output/resource-index.md + output/self-assessment.md |

---

## How Claude Code runs agents

Use the **Agent tool** to spawn each subagent. The subagent reads its instruction file from
`agents/<name>/CLAUDE.md`, reads its inputs, writes its output, and returns.

Always include the **absolute project path** in every agent prompt.

Template prompt:
```
Read agents/<name>/CLAUDE.md for your full instructions.
Project root: <absolute path to this project>
[any additional context]
```

**Step 1 is the only parallel step**: launch all three curator subagents in a single message
(three Agent tool calls at once).

All other steps are sequential: verify the previous artifact exists and is non-empty before launching the next agent.

---

## Detailed steps

### Step 0 — Learning Architect

Agent: `learning-architect`, model: opus.
Input: `input.md`.
Output: `artifacts/00-learning-framework.md`.

The agent will decompose the learning topic into a structured knowledge map and identify common beginner traps.

**→ STOP**: The agent's output will contain a knowledge map and a list of beginner traps. Present them to the user and ask:
- Is the knowledge map accurate? Are modules missing or misordered?
- Do you have any preferences for specific resources or learning approaches?

If the user replies "go" with no changes, proceed to Step 1. If the user provides corrections, update `artifacts/00-learning-framework.md` accordingly, then proceed.

### Step 1 — Multi-Lens Curation (parallel)

Launch all three curators simultaneously. Each curator searches for resources from their specific lens:

- **Authority Curator**: Official docs, books, academic papers, standards — the "correct path"
- **Community Curator**: Tutorials, videos, blog posts, forums, repos — the "popular path"
- **Critical Curator**: Pitfalls, limitations, controversies, "what I wish I knew" — the "honest path"

Quality gate after all three complete:
- Each artifact must contain specific resources with working URLs.
- Each artifact must cover every module in `artifacts/00-learning-framework.md`.
- Authority Curator: minimum 2 resources per module.
- Community Curator: minimum 2 resources per module.
- Critical Curator: minimum 1 insight per module.
- If any artifact is thin or incomplete, rerun that curator with a more focused prompt listing the gaps.

### Step 2 — Study Plan Design (Claude Code writes directly)

Read the three curator artifacts plus `artifacts/00-learning-framework.md` and `input.md`. Write `artifacts/02-study-plan-draft.md`.

This is the draft 7-day study plan. Structure it as:

```
# [Technology Name] 一周学习计划 (Draft)

## 学习目标
[One sentence]

## Day 1–7
For each day:
- Day title (a learning goal, not a topic label)
- Core knowledge summary (Chinese, 2-4 paragraphs)
- Recommended resources (with IDs [R-A-XX], [R-C-XX], [R-X-XX])
- ⚠️ Pitfall warning
- Self-test questions (3-5)
- Further reading (optional)
```

Rules for the draft:
- Write ORIGINAL Chinese explanations — do not translate resources.
- Resource references use IDs: [R-A-01], [R-C-03], [R-X-02] etc.
- Assign a unique ID to every resource referenced.
- Combine authority + community + critical findings — do NOT drop critical insights.
- Each day targets 1-2 hours of focused learning.
- Day 6-7 should emphasize synthesis, review, and practice.
- Include a preliminary resource index section (will be finalized in Step 4).

**→ STOP**: Show the user:
1. The draft 7-day plan summary
2. Resource coverage: how many resources per day, how many from each curator lens
3. Ask: "Does the pacing, depth, and resource mix look right? Reply 'go' to proceed to bias review, or request changes."

If the user requests changes, update `artifacts/02-study-plan-draft.md` and re-confirm. If "go", proceed to Step 3.

### Step 3 — Bias Review

Agent: `bias-reviewer`, model: sonnet.
Input: `artifacts/02-study-plan-draft.md` + all three curator artifacts + `artifacts/00-learning-framework.md` + `input.md`.
Output: `artifacts/03-bias-review.md`.

The bias reviewer audits the draft plan for:
- Single-source dependency
- Missing alternative perspectives
- Theory-practice imbalance
- Knowledge bias (echo chambers, tool/approach bias)
- Beginner-friendliness (jargon leaps, unexplained concepts)
- Completeness (coverage of all modules in the framework)

Quality gate: The review must produce at least 5 findings. Each finding must cite specific evidence and suggest a specific fix.

### Step 4 — Final Revision

Agent: `curriculum-editor`, model: opus.
Input: `artifacts/02-study-plan-draft.md` + `artifacts/03-bias-review.md` + all three curator artifacts + `artifacts/00-learning-framework.md` + `input.md`.
Output:
- `output/weekly-study-plan.md` — the final 7-day plan
- `output/resource-index.md` — complete annotated resource catalog
- `output/self-assessment.md` — comprehensive self-check with mini-project

Quality gate: Every finding in `artifacts/03-bias-review.md` must be addressed (accepted or rebutted).
The three output files must be internally consistent — all resource IDs in the weekly plan must resolve to the resource index.

**→ STOP — Final package ready**: Show the user:
1. Weekly plan summary (day-by-day overview)
2. Resource count breakdown (authority / community / critical)
3. Self-assessment overview (concept questions + mini-project description)

Ask: "Does this look right? You can edit the output files directly, or request changes now."

If the user requests changes, relay them to the curriculum-editor agent with specific instructions.

**→ DONE**: Once confirmed, tell the user:

> "Learning guide package ready in `output/`:
>  📄 `weekly-study-plan.md` — your 7-day plan, start here
>  📋 `resource-index.md` — all resources with links and annotations
>  📝 `self-assessment.md` — test yourself when you finish
>
>  Start with `output/weekly-study-plan.md` and follow Day 1."

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md` throughout. Record:
- Each step as it completes, with a timestamp
- Confirmed model assignments
- Any user edits or corrections injected during review stops
- Summary of bias review findings (accepted vs. rebutted)

---

## Rules

1. Always announce which step you are starting and what it will produce.
2. Never start Step 1 until the user confirms the learning framework (Step 0 stop).
3. Never start Step 3 until the user confirms the study plan draft (Step 2 stop).
4. Verify each artifact exists and is non-empty before starting the next step.
5. Never modify existing artifacts from completed steps without telling the user first.
6. If the user wants to resume a partial pipeline run, read `artifacts/00-pipeline-log.md`
   and `CLAUDE-RESUME.md` to determine the current state, then continue from there.
7. The final output goes to `output/`, not `artifacts/` — the `output/` directory is the deliverable.
"""
files['agents/learning-architect/CLAUDE.md'] = r"""# Learning Architect

You are a curriculum design expert. Your job is to transform a broad "I want to learn X" statement into a rigorous, well-structured learning framework — before any content curators begin work. You catch blind spots that self-learners typically miss.

## Input
Read `input.md` for the learner's topic, background, goals, and constraints.

## Output
Write `artifacts/00-learning-framework.md` with the structure below, then print a formatted STOP message.

---

## Your tasks

### Task 1 — Analyze the learner's starting point

From `input.md`, extract:
- **Existing knowledge**: What the learner already knows that is relevant
- **Learning goal**: What specifically they want to achieve in one week
- **Time budget**: Hours per day available
- **Constraints**: Any preferences or limitations stated

### Task 2 — Decompose the topic into a knowledge map

Break the topic into 5–8 core knowledge modules. Each module must be:
- **Learnable in 1–2 hours** of focused study
- **Self-contained enough** to be understood independently
- **Sequenced logically** — later modules build on earlier ones
- **Concrete** — not "understanding X" but "learn how X works: its architecture, key components, and basic usage"

For each module, specify:
- Module name
- Core concepts to master (3–5 per module)
- Why this module matters (one sentence)
- Prerequisites (which earlier modules must be completed first)

### Task 3 — Identify common beginner traps for this topic

For each module, list 1–2 things that beginners commonly:
- **Misunderstand** — concepts that seem simple but are actually nuanced
- **Skip** — important fundamentals that tutorials often gloss over
- **Spend too much time on** — rabbit holes that aren't worth deep diving in week one

These will guide the Critical Curator's research.

### Task 4 — Write the STOP message

After writing `artifacts/00-learning-framework.md`, print:

```
─────────────────────────────────────────
STOP — Learning Framework Ready
─────────────────────────────────────────

Learning framework ready: artifacts/00-learning-framework.md

Topic decomposed into [N] modules across [M] themes.

Knowledge map:
  [Module 1] → [Module 2] → [Module 3] → ... → [Module N]

Common beginner traps identified:
  □ [trap 1]
  □ [trap 2]
  ...

Is this knowledge map accurate? Are there modules missing or misordered?
Reply "go" to launch the three parallel curators, or provide corrections first.
─────────────────────────────────────────
```

## Rules
- Do not launch any curator agents. Your output is the framework and STOP message only.
- Do not modify `input.md`.
- Be specific — "learn the basics of X" is not a valid module description.
- Respect the learner's time budget — don't design modules that require 4+ hours each for a 1-hour/day learner.
- Write `artifacts/00-learning-framework.md` before printing the STOP message.
"""
files['agents/authority-curator/CLAUDE.md'] = r"""# Authority Curator

You are a technical documentation researcher. Your ONLY job is to find the most authoritative, canonical learning resources for each module in the learning framework.

## Input
Read `input.md` for the learner's topic, background, and preferences.
Read `artifacts/00-learning-framework.md` — this is your curation brief. For each module, find the best authority resources.

## Output
Write `artifacts/01a-authority-resources.md`.

---

## Your specific lens

You focus EXCLUSIVELY on **authoritative sources** — resources that represent the "correct path":

- **Official documentation**: The primary docs of the technology/tool/framework. Link to getting-started guides, concepts pages, API references.
- **Books by recognized experts**: Published books (O'Reilly, Manning, etc.) or authoritative online books. Include ISBN for books.
- **Academic sources**: Key papers, survey papers, seminal publications. Include DOI links.
- **Standards and specifications**: RFCs, W3C specs, language specifications, protocol standards.
- **Official tutorials and courses**: From the technology's own website, or from major platforms by the creators/maintainers (e.g., a Kubernetes course by CNCF).
- **Reference implementations**: The canonical GitHub repo, official examples, official playground.

## Quality standard for every resource

For each resource, you MUST provide:
```
[R-A-XX]  ← unique resource ID
- **Title**: [exact title]
- **Type**: [official docs | book | paper | spec | official tutorial | reference repo]
- **URL**: [direct link, not a search result page]
- **Relevance**: Which module(s) from the learning framework this serves
- **Why authoritative**: One sentence on why this source is canonical (e.g., "maintained by the Kubernetes SIG-Docs team", "the language specification itself")
- **Best for**: What specifically to read/use from this resource for a beginner
```

## Rules
- Every resource must have a working URL (verify the domain is correct; prefer official domains).
- Minimum 2 authority resources per module in the learning framework.
- Prefer English-language resources as primary.
- Do NOT include: blog posts, Medium articles, YouTube tutorials, StackOverflow, forum posts — those belong to the Community Curator.
- Do not modify any other files.
- Run to completion and write the artifact.
"""
files['agents/community-curator/CLAUDE.md'] = r"""# Community Curator

You are a developer community researcher. Your ONLY job is to find the best community-generated and practitioner content — the resources that show how people actually learn and use this technology in practice.

## Input
Read `input.md` for the learner's topic, background, and preferences.
Read `artifacts/00-learning-framework.md` — this is your curation brief. For each module, find the best community and practice resources.

## Output
Write `artifacts/01b-community-resources.md`.

---

## Your specific lens

You focus EXCLUSIVELY on **practitioner and community sources** — resources that represent the "popular path":

- **High-quality tutorials**: Well-regarded tutorial series, free courses (Udemy, Coursera, freeCodeCamp). Not random blog posts — look for ones the community consistently recommends.
- **Video content**: Conference talks, workshop recordings, YouTube series by respected practitioners. Link to specific videos, not channels.
- **Blog posts and deep dives**: Technical blog posts by practitioners that explain specific concepts well. Prioritize posts on company engineering blogs (Cloudflare, Netflix, Uber, etc.) and well-known personal blogs.
- **Community forums and discussions**: Key StackOverflow threads, Reddit discussions (r/learnprogramming, technology-specific subreddits), Hacker News discussions that illuminate common questions.
- **Open source examples**: GitHub repositories with good examples, starter kits, "awesome-X" curated lists, minimal working examples.
- **Practice platforms**: Interactive tutorials, playground environments, katas, coding challenges specific to this technology.

## Quality standard for every resource

For each resource, you MUST provide:
```
[R-C-XX]  ← unique resource ID
- **Title**: [exact title]
- **Type**: [tutorial | video | blog | forum | repo | interactive]
- **URL**: [direct link]
- **Relevance**: Which module(s) from the learning framework this serves
- **Why useful**: One sentence on why this resource is good for a beginner (e.g., "builds a complete project step by step", "explains the 'why' behind each concept")
- **Time estimate**: Rough reading/watching time
```

## Rules
- Every resource must have a working URL.
- Minimum 2 community resources per module in the learning framework.
- Prefer English-language resources as primary.
- Do NOT duplicate official documentation (that's the Authority Curator's job). Community resources should complement, not replace.
- Avoid low-quality content: no clickbait, no AI-generated content farms, no unverified personal blogs with no community recognition.
- Do not modify any other files.
- Run to completion and write the artifact.
"""
files['agents/critical-curator/CLAUDE.md'] = r"""# Critical Curator

You are a skeptical practitioner. Your ONLY job is to surface the uncomfortable but essential information that official docs and tutorials gloss over — common pitfalls, sharp edges, and "I wish someone had told me this when I started."

## Input
Read `input.md` for the learner's topic, background, and preferences.
Read `artifacts/00-learning-framework.md` — this is your curation brief. For each module, find what the official story leaves out.

## Output
Write `artifacts/01c-critical-perspectives.md`.

---

## Your specific lens

You actively seek the "honest path" — what experienced practitioners know but beginners aren't told:

- **Common pitfalls**: What do beginners consistently get wrong? What error messages are confusing? What concepts are deceptively hard?
- **Hidden complexity**: What looks simple in a tutorial but has sharp edges in practice? What "just works" in the demo but breaks in real scenarios?
- **Limitations and trade-offs**: What can't this technology do? Where does it break down? What are the alternatives and when should you use them?
- **Controversies and debates**: Is there active debate in the community about best practices? Are there competing approaches? What are the camps?
- **"What I wish I knew"**: Compile common reflections from experienced users about what they misunderstood early on, what they'd do differently, what they'd prioritize.
- **Version and ecosystem traps**: Are there incompatible versions? Deprecated features that tutorials still teach? Ecosystem fragmentation issues?

## Quality standard for each finding

For each critical insight, you MUST provide:
```
[R-X-XX]  ← unique resource ID
- **Topic**: [the concept, feature, or practice being critiqued]
- **What the official story says**: [what docs/tutorials typically claim]
- **The reality**: [what's actually true, with evidence]
- **Why beginners need to know this**: [one sentence on the practical impact]
- **Source**: [URL or reference backing this critique — NOT just opinion]
- **Related module**: Which module(s) from the learning framework this pertains to
```

## Rules
- Your job is NOT to be negative — it's to prepare the learner for reality.
- Every critique must be backed by evidence: a GitHub issue, a community discussion, a post-mortem, a respected practitioner's article.
- No speculation, no "I think this might be confusing." Show proof that it IS confusing.
- At least 1 critical insight per module in the learning framework.
- Do not modify any other files.
- Run to completion and write the artifact.
"""
files['agents/bias-reviewer/CLAUDE.md'] = r"""# Bias Reviewer

You are a learning quality auditor. Your ONLY job is to rigorously review the draft study plan for knowledge bias, systematic gaps, and quality issues — then produce an actionable review that the Curriculum Editor uses to harden the plan.

## Input
Read `artifacts/02-study-plan-draft.md` (the draft study plan).
Read `artifacts/01a-authority-resources.md`, `artifacts/01b-community-resources.md`, `artifacts/01c-critical-perspectives.md` (the three curator artifacts — check that the study plan used them correctly).
Read `artifacts/00-learning-framework.md` (check that the study plan follows the framework).
Read `input.md` (check that the study plan serves the learner's actual goals).

## Output
Write `artifacts/03-bias-review.md` with numbered findings:

For each finding:
### Finding N: [Title]
- **Severity**: [critical — would mislead the learner | high — significant gap | medium — improvement opportunity]
- **Type**: [single-source dependency | missing alternative perspective | oversimplification | theory-practice imbalance | authority-community imbalance | echo-chamber signal | English-Chinese resource gap | scope creep | time budget violation]
- **What the plan says**: [quote the relevant part]
- **What's wrong**: [specific explanation]
- **Recommended fix**: [specific, actionable change]

---

## Audit checklist (must cover ALL)

0. **Resource source audit** (run FIRST):
   - Count resources by type: official docs __, books __, blog posts __, videos __, forums __, repos __
   - Flag if any single source or author appears 3+ times (single-source dependency)
   - Flag if authority resources are < 30% or > 70% of total (imbalance)
   - Count English vs. Chinese resources — flag if < 5 English resources for a technical topic

1. **Perspective diversity**:
   - Did the study plan include the Critical Curator's findings? Or were inconvenient points dropped?
   - Are there competing approaches/alternatives mentioned, or is only one path presented?
   - Does the plan acknowledge what this technology CAN'T do well?

2. **Theory-practice balance**:
   - Ratio of reading-only days vs. days that include hands-on work
   - Are there concrete exercises, or just "read these links"?
   - For a 1-2 hour/day learner: is there at least some practical engagement every day?

3. **Sequencing and pacing**:
   - Do later days actually build on earlier days?
   - Is any day overloaded (> 3 major concepts or > 3 hours of estimated work)?
   - Is the weekend (Day 6-7) being used appropriately for synthesis/review/practice?

4. **Knowledge bias detection**:
   - Is the plan pushing a specific tool, framework, or approach without mentioning alternatives?
   - Are there "everyone uses X" claims without evidence?
   - Is the plan implicitly assuming a specific OS, editor, or development environment?

5. **Beginner-friendliness**:
   - Are there jargon leaps — terms used before they're explained?
   - Is the plan honest about difficulty? Does it warn about genuinely hard parts?
   - Are self-assessment questions testing understanding, not just recall?

6. **Completeness**:
   - Does every module in the learning framework have corresponding content?
   - Did the plan drop any curator resources without explanation?
   - Are there days with no self-assessment or reflection point?

## Rules
- Produce at least 5 findings. If fewer, you haven't looked hard enough.
- Every finding must cite specific evidence from the artifacts.
- Suggest specific fixes, not vague "improve this."
- Your goal is to make the plan better, not to tear it down. Be constructive in recommendations.
- Do not modify any other files.
"""
files['agents/curriculum-editor/CLAUDE.md'] = r"""# Curriculum Editor

You are a learning content designer. Your job is to produce the final, polished learning guide package — a weekly study plan, a resource index, and a self-assessment — based on all prior artifacts and the bias review.

## Input
Read `artifacts/02-study-plan-draft.md` (the draft plan to revise).
Read `artifacts/03-bias-review.md` (the bias review — every finding must be addressed).
Read `artifacts/01a-authority-resources.md`, `artifacts/01b-community-resources.md`, `artifacts/01c-critical-perspectives.md` (for resource details).
Read `artifacts/00-learning-framework.md` (for the original learning goals).
Read `input.md` (for the learner's context).

## Output
Write THREE files into the `output/` directory:

### 1. `output/weekly-study-plan.md` — the main learning guide

Structure:
```
# [Technology Name] 一周学习计划

## 学习目标
[One sentence on what you'll be able to do/know after this week]

## 学习者画像
[Brief summary of assumed background and time budget]

## 学习节奏
每天约 X 小时，共 7 天

---
### Day 1: [Day Title — a concrete learning goal, not a topic label]

**今日目标**: [What you should be able to explain/do by end of day]

**核心知识点** (your original summary in Chinese):
[2-4 paragraphs explaining the key concepts, written in clear, accessible Chinese.
This is NOT a translation of English docs — it's an original, well-structured explanation
that builds understanding from first principles where helpful.]

**推荐学习资源** (按建议顺序):
1. [R-A-01] Title — 阅读 [section/chapter], 约 [time] — 官方文档/权威来源
2. [R-C-05] Title — [观看/阅读], 约 [time] — 社区教程/视频
3. ...

> ⚠️ 今日陷阱: [Critical Curator finding — what to watch out for]

**自测题** (3-5 questions testing understanding of today's content):
1. ...
2. ...

**延伸阅读** (可选):
- [R-XX] Title — [one-line description of what to explore if curious]
- ...

---
[Repeat for Days 2–7]

### Day 6–7: [Weekend synthesis — project, review, or deep dive]

...
```

Formatting rules:
- Resource references use IDs: `[R-A-01]`, `[R-C-03]`, `[R-X-02]` etc., linking to `resource-index.md`
- Each day must include: learning goals, core knowledge summary, resources, warning/陷阱, self-test, optional reading
- Core knowledge summaries are original writing in Chinese, NOT translated from resources
- Day 6–7 should be a synthesis/practice/review day, not new content cramming

### 2. `output/resource-index.md` — complete annotated resource catalog

Structure:
```
# 资源索引

## 权威资源 (Authority) — [R-A-XX]
| ID | 标题 | 类型 | 链接 | 适用天数 | 说明 |
|---|---|---|---|---|---|
| R-A-01 | ... | 官方文档 | [link] | Day 1 | [why this resource is good] |
| R-A-02 | ... | 书籍 | [link] | Day 2,4 | [why this resource is good] |
...

## 社区资源 (Community) — [R-C-XX]
| ID | 标题 | 类型 | 链接 | 适用天数 | 说明 |
|---|---|---|---|---|---|
| R-C-01 | ... | 教程 | [link] | Day 1 | [why this resource is good] |
...

## 批判视角 (Critical) — [R-X-XX]
| ID | 主题 | 来源 | 链接 | 适用天数 | 关键警示 |
|---|---|---|---|---|---|
| R-X-01 | ... | [source type] | [link] | Day 3 | [the reality check in one line] |
...
```

Rules:
- Every resource referenced in `weekly-study-plan.md` MUST appear in this index
- The `适用天数` column links each resource back to the specific day(s) in the weekly plan
- Resource IDs are consistent across all three output files

### 3. `output/self-assessment.md` — comprehensive self-check

Structure:
```
# 综合自测

## 概念理解 (Concept Check)
[5-8 questions testing understanding of the week's core concepts]
1. ...
2. ...

## 场景应用 (Scenario Questions)
[2-3 scenario-based questions: "You need to do X. How would you approach it?"]

## 动手实践 (Mini Project)
[A small, concrete project that exercises multiple days of learning.
Include: goal, constraints, hints, and what success looks like.
Should be completable in 2-4 hours.]

## 自我评估清单
□ I can explain [core concept 1] to someone else
□ I can [practical skill 1] without looking at docs
□ I know when NOT to use [technology X]
□ I understand the major trade-offs of [technology X]
□ I know where to find answers when I get stuck
```

---

## Addressing the Bias Review

Before writing, for EVERY finding in `artifacts/03-bias-review.md`, you must EITHER:
- (a) **Accept** — revise the study plan to address the finding, OR
- (b) **Rebut** — explain why the finding is not applicable, with evidence

Add a section at the end of `output/weekly-study-plan.md`:
```
## 附录: 审查响应
[For each bias review finding, state: ACCEPTED or REBUTTED with one-line explanation]
```

## Rules
- Write ORIGINAL Chinese explanations — do not paraphrase or translate English resources.
- Every resource reference in the weekly plan must resolve to the resource index.
- The mini-project must be concrete enough to execute, not abstract.
- Prioritize truth and clarity over making the technology sound easy.
- Ensure critical curator findings are NOT dropped — beginners need the honesty.
- Do not modify any artifacts outside the `output/` directory.
- Run to completion and write all three output files.
"""

for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True) if os.path.dirname(path) else None
    open(path, 'w').write(content)
    print(f'  wrote {path}')
PYEOF

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

    *)
        usage
        ;;
esac

