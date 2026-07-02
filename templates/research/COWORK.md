# PPT Build Guide — Cowork

**You are Cowork.** This file is your guide for building the PPT (Step 7).
The research phase (Steps 1–6) must be complete before running this.

---

## Prerequisites — check before starting

Verify these artifacts exist and are non-empty:

| Artifact | Contents |
|---|---|
| `artifacts/01-research.md` | Synthesized multi-lens research |
| `artifacts/02-analysis-final.md` | Hardened analysis (all challenges addressed) |
| `artifacts/04-narrative.md` | Slide-by-slide structure plan |

Also read `artifacts/00-pipeline-log.md` to confirm:
- `artifact-language:` — language for source content
- `slide-language:` — language for slide copy
- `pptx-template:` — template path or style description

If any artifact is missing or empty, tell the user to complete the research phase first
(open Claude Code in this folder and say: `Read CLAUDE.md and run the pipeline`).

---

## Step 7 — PPT Creation

Read `docs/STEP7-GUIDE.md` for the full four-stage build procedure.

**Default template**: `../_shared/pptx-templates/tech-ppt.pptx`
Override with the user-specified path from `artifacts/00-pipeline-log.md` if one was provided.

Source content:
- `artifacts/01-research.md` — background data and evidence
- `artifacts/02-analysis-final.md` — analysis and recommendations
- `artifacts/04-narrative.md` — slide-by-slide structure and layout plan

### Four-stage build summary

- **Stage A — Content mapping**: Produce a slide-by-slide content plan table from the narrative and analysis artifacts. Show to user for review before touching any PPTX file.
- **Stage B — Template setup**: Archive current deck (if any), copy template, unpack to `artifacts/unpacked/`, adjust slide count, map narrative slides to template slide XMLs.
- **Stage C — Parallel slide editing**: Spawn parallel subagents to fill content into slide XML files. Each subagent handles a batch of slides using the Edit tool only.
- **Stage D — Screenshot review**: Pack the deck, convert to PDF, review per-slide images with the user, make targeted fixes, iterate until approved.

See `docs/STEP7-GUIDE.md` for the complete procedure, commands, batching strategy, design rules, and failure modes.

---

## Version management

Before each rebuild, copy the current deck:
```
cp artifacts/05-deck.pptx artifacts/versions/05-deck-v{N}.pptx
```
Increment N from the highest existing version in `artifacts/versions/`.
Log the version in `artifacts/00-pipeline-log.md`.

---

## Pipeline log

Maintain `artifacts/00-pipeline-log.md` throughout. Record:
- Step 7 start timestamp
- Stage completions (A, B, C, D)
- Version numbers for each rebuild
- Any user-requested fixes and which slides were changed

---

## Rules

1. Always verify prerequisites (the three artifacts + pipeline log settings) before starting Stage A.
2. Never start Stage B until the user approves the content plan from Stage A.
3. Do NOT create `05-deck-final.pptx` or any other name — canonical output is always `artifacts/05-deck.pptx`.
4. Make surgical edits only — do not rebuild the entire deck for a single slide fix.
5. Show the user the PDF after each Stage D pack so they can review visually.
6. Iterate conversationally with the user on slide content and layout until they approve.
7. Run the temporary file cleanup (below) after final user approval to remove screenshots and unpacked XMLs.
8. **Rights footer (MUST)**: before final approval, verify `docs/rights.template.md` is rendered into the deck footer (or closing slide). Replace the `<#...>` placeholder with the model names from `artifacts/00-pipeline-log.md`. **Do not skip this step.**

---

## Temporary file cleanup

After the user approves the final deck (end of Stage D), delete intermediate files:
```
rm -rf artifacts/slide-screenshots/
rm -rf artifacts/unpacked/
```
These are build artifacts — screenshots are for review only, unpacked XMLs are obsolete once packed.
If the user requests further changes after cleanup, Stage B will re-create both directories.
