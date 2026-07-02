# Step 7 — PPT Build Guide

This document is read by Cowork at Step 7. Follow the four stages in order.

> **All paths and shell commands are relative to the project root.
> Run every command from the project root, not from the `docs/` folder.**

---

## Prerequisites

| Item | Path (from project root) |
|---|---|
| Template PPTX | `../_shared/pptx-templates/tech-ppt.pptx` |
| Pptx skill scripts | `../../.claude/skills/pptx/scripts/` |
| Icon extractor | `../_shared/pptx-templates/icon-extract.py` |
| Icon thumbnails | `../_shared/icon-catalog/slide-{N}.jpg` |
| Source: research | `artifacts/01-research.md` |
| Source: analysis | `artifacts/02-analysis-final.md` |
| Source: narrative | `artifacts/04-narrative.md` |
| Output | `artifacts/05-deck.pptx` |
| Version archive | `artifacts/versions/05-deck-v{N}.pptx` |
| Unpacked working dir | `artifacts/unpacked/` |
| Screenshot output | `artifacts/slide-screenshots/` |

---

## Stage A — Content Mapping (review BEFORE building)

**Goal**: Produce a complete slide-by-slide content plan and show it to the user for approval
before touching any PPTX file. Errors caught here cost nothing. Errors caught after building
cost a full rebuild.

For each slide in `04-narrative.md`, fill in this table from `02-analysis-final.md` and `01-research.md`:

| Slide | Title | Layout | Key bullets (<=15 words each) | Data points to include |
|---|---|---|---|---|

Rules:
- Pull exact numbers and quotes from the source artifacts — do not paraphrase statistics.
- Bullets must be <=15 words. Cut ruthlessly.
- Speaker notes carry the detail; slides carry the headline.
- Use the slide language confirmed in `artifacts/00-pipeline-log.md`.
- Show the completed table to the user. Wait for approval before Stage B.
- The user may edit individual cells before approving.

---

## Stage B — Template Setup

### 1. Archive current deck first
```
ls artifacts/versions/
cp artifacts/05-deck.pptx artifacts/versions/05-deck-v{N}.pptx
```
Skip if no deck exists yet (first build).

### 2. Copy template and unpack
```
cp ../_shared/pptx-templates/tech-ppt.pptx artifacts/05-deck-new.pptx
python ../../.claude/skills/pptx/scripts/office/unpack.py \
  artifacts/05-deck-new.pptx artifacts/unpacked/
```
(`05-deck-new.pptx` is temporary — deleted after Stage D packing.)

### 3. Slide count adjustment
The template has **19 content slides** (slides 1-19) plus **13 icon/asset slides** (slides 20-32).
The icon/asset slides are source-only assets — never used in the final deck.

Compare the narrative slide count from `04-narrative.md` against the 19 content slides.
Delete any template slides not needed by removing their `<p:sldId>` entries from
`artifacts/unpacked/ppt/presentation.xml`, then run:
```
python ../../.claude/skills/pptx/scripts/clean.py artifacts/unpacked/
```
After any deletions, renumber slide IDs in `presentation.xml` to be contiguous.

### 4. Slide layout mapping

Review `04-narrative.md` and map each narrative slide to the best-matching template slide XML.
Build this table (one row per narrative slide):

| Narrative slide | Layout type | Template slide XML to reuse | Notes |
|---|---|---|---|
| (fill from 04-narrative.md) | | | |

Useful template slide types in `tech-ppt.pptx`:
- slide1.xml — cover
- slide2.xml — contents / table of contents
- slide3.xml, slide9.xml, slide19.xml — section dividers (dark background, white text)
- slide4.xml, slide8.xml — architecture / layered diagram
- slide5.xml, slide13.xml — two-column
- slide6.xml, slide12.xml, slide16.xml — three-column
- slide7.xml, slide23.xml — highlight stat
- slide10.xml — quadrant (2x2 matrix)
- slide11.xml, slide22.xml — table
- slide14.xml, slide17.xml — process / sequential steps
- slide15.xml — two-column with contrast
- slide21.xml — timeline

---

## Stage C — Parallel Slide Editing

After structural setup is complete (Stage B step 4 done), spawn parallel subagents to fill
in content. Each subagent handles one or a few slides.

Subagent prompt template:
```
Edit these slide XML files in artifacts/unpacked/ppt/slides/:
  - slideN.xml [, slideM.xml]

Content to insert (from the approved Stage A content plan):
  [paste the relevant rows from the content table]

Formatting rules (MUST follow):
1. Use the Edit tool for all XML changes — never sed or Python scripts.
2. Font: preserve existing <a:latin typeface="..."/> and <a:ea typeface="..."/> attributes.
3. Bullets: use existing <a:buChar> or <a:buNone> — never add unicode bullets.
4. Bold headers: set b="1" on <a:rPr> for all column headers, slide section labels.
5. Never concatenate multiple bullets into one <a:p> — each bullet is a separate paragraph.
6. Smart quotes in new text: use XML entities &#x201C; and &#x201D;.
7. Do not change any shape positions, sizes, or colors — edit text content only.
8. If a template slot has more items than the content plan, delete the excess <a:p> elements entirely.
9. Preserve xml:space="preserve" on any <a:t> with leading/trailing spaces.

Read the slide XML first, identify every text placeholder, then replace with final content.
```

Suggested batching (group by complexity):
- Batch 1 (simple): cover, contents, section dividers — text-only edits
- Batch 2 (columns): two-column and three-column slides
- Batch 3 (data-heavy): architecture, highlight-stat, quadrant slides
- Batch 4 (structured): tables, process, timeline, closing slides

---

## Stage D — Screenshot Review

### Pack and generate per-slide images
```
python ../../.claude/skills/pptx/scripts/office/pack.py \
  artifacts/unpacked/ artifacts/05-deck.pptx \
  --original ../_shared/pptx-templates/tech-ppt.pptx

python ../../.claude/skills/pptx/scripts/office/soffice.py --headless \
  --convert-to pdf --outdir artifacts/ artifacts/05-deck.pptx
rm -f artifacts/slide-screenshots/slide-*.jpg
pdftoppm -jpeg -r 150 artifacts/05-deck.pdf artifacts/slide-screenshots/slide
ls -1 "$PWD"/artifacts/slide-screenshots/slide-*.jpg
```

### Review checklist
- [ ] Every slide has a title
- [ ] No text visibly overflows its box
- [ ] Section dividers have dark background with light text
- [ ] Highlight stat slides show the key number prominently
- [ ] Tables have all rows filled — no empty cells from template
- [ ] Process slides show sequential steps clearly
- [ ] Timeline shows phases with correct labels and dates
- [ ] All characters render correctly (no tofu/boxes for non-Latin scripts)
- [ ] Page numbers present on all slides except cover
- [ ] Footer shows correct N / Total on all numbered slides
- [ ] Rights footer visible on every slide (from docs/rights.template.md, model names from pipeline log)

### Targeted fixes
For any issue: edit the specific slide XML directly, then re-pack and regenerate PDF.
Do NOT rebuild the entire deck — make surgical edits only.
Do NOT create `05-deck-final.pptx` or any other name — canonical output is always `05-deck.pptx`.

```
python ../../.claude/skills/pptx/scripts/office/pack.py \
  artifacts/unpacked/ artifacts/05-deck.pptx \
  --original ../_shared/pptx-templates/tech-ppt.pptx
rm -f artifacts/05-deck-new.pptx

python ../../.claude/skills/pptx/scripts/office/soffice.py --headless \
  --convert-to pdf --outdir artifacts/ artifacts/05-deck.pptx
rm -f artifacts/slide-screenshots/slide-*.jpg
pdftoppm -jpeg -r 150 artifacts/05-deck.pdf artifacts/slide-screenshots/slide
```

### Post-approval cleanup
After the user approves the final deck, remove intermediate build artifacts:
```
rm -rf artifacts/slide-screenshots/
rm -rf artifacts/unpacked/
```
These are ephemeral — screenshots are for review only, unpacked XMLs are obsolete once packed.
If further changes are needed after cleanup, Stage B will re-create both directories.

---

## Design rules

Establish during Stage A by inspecting the template. Record in `artifacts/00-pipeline-log.md`
under `design-rules:`.

| Property | Default (tech-ppt.pptx) |
|---|---|
| Primary accent color | #173953 (deep navy) |
| Secondary accent | #8500FF (purple) |
| Body text dark | #191919 |
| Light background | #FFFBF9 |
| CJK font | Source Han Serif SC |
| Latin font | Source Serif 4 |
| Two-column: header / body | 24pt bold / 18pt |
| Three-column: header / body | 20pt bold / 16pt |
| Takeaway bar | Left-aligned, accent color, bottom margin |
| Page numbers | Footer, all slides except cover (format: N / Total) |
| Section dividers | Full-screen #173953 rectangle, white text |

**Default body fonts** (installed system-wide by init-pipeline.sh): set `<a:ea typeface="Source Han Serif SC"/>` and `<a:latin typeface="Source Serif 4"/>` for both majorFont and minorFont in `ppt/theme/theme1.xml` fontScheme so all runs inherit them. Stage C rule 2 still applies to any special per-shape typefaces.

**Rights footer (MUST)**: render `docs/rights.template.md` into the deck footer (or a closing slide), replacing the `<#...>` placeholder with the model names used this run (from `artifacts/00-pipeline-log.md`). **This step is mandatory — do NOT skip.**

---

## Common failure modes to watch for

1. **Empty template slots** — if a template slide has 4 items but the content only needs 3,
   delete the 4th element entirely (shape + text box). Do not just clear the text.

2. **Non-Latin text encoding** — all text must be in UTF-8. The Edit tool is safe.
   If generating XML directly, verify encoding.

3. **Font fallback** — preserve existing `<a:latin typeface="..."/>` and `<a:ea typeface="..."/>` attributes.

4. **Slide count mismatch** — after deletion in Stage B, verify `presentation.xml`
   `<p:sldIdLst>` entry count matches your target slide count before proceeding.

5. **Architecture/quadrant layout** — edit `<a:t>` inside each `<p:sp>` individually.
   Do not move or resize shapes.

6. **Footer numerator vs. XML file number** — if slides are deleted from the template,
   XML file numbers no longer equal deck position. Always set footer to deck position.

---

## Using template icon assets (slides 20-32)

The canonical template contains 13 "asset slides" (slides 20-32) that are never copied into
the final deck. They hold reusable vector icon groups and infographic shapes.

### What's available

| Template slide | Contents |
|---|---|
| 20 | Infographic elements — arrows, pie/donut charts, process bars, speech bubbles |
| 21 | World maps (5 styles) + globe icons + location pins |
| 22 | Flowchart / process-flow / org-chart shapes and timeline diagrams |
| 23 | Gantt chart templates (month x phase x task) |
| 24 | Business infographic shapes — gears, puzzle pieces, target circles, lightbulb, trophy |
| 25 | Additional infographic shapes — funnels, pyramids, step diagrams, venn diagrams |
| 26 | Icon usage instructions (skip — not for pipeline use) |
| 27 | Educational Icons (left) + Medical Icons (right) |
| 28 | Business Icons (left) + Teamwork Icons (right) |
| 29 | Help & Support Icons (left) + Avatar Icons (right) |
| 30 | Creative Process Icons (left) + Performing Arts Icons (right) |
| 31 | Nature Icons |
| 32 | SEO & Marketing Icons |

All are vector (custGeom bezier paths inside grpSp groups) — fully scalable and recolorable.
Visual thumbnails: `../_shared/icon-catalog/slide-{N}.jpg`

### How to use

Identify the icon by viewing the thumbnail and counting its reading-order position
(left-to-right, top-to-bottom, 1-based). For split slides (27-30), left = first category,
right = second category (split at x = 6,000,000 EMU).

List icons on a slide:
```
python3 ../_shared/pptx-templates/icon-extract.py list 28 --side left
python3 ../_shared/pptx-templates/icon-extract.py list 28 --side right
```

Inject an icon into a target slide:
```
python3 ../_shared/pptx-templates/icon-extract.py inject 28 3 \
    artifacts/unpacked/ppt/slides/slide7.xml \
    700000 1200000 --cx 500000 --cy 500000 --side left
```

Key XML facts:
- Each icon is a grpSp block; its outer grpSpPr/a:xfrm controls position/size.
- a:off x/y = position (914,400 EMU = 1 inch).
- a:ext cx/cy = rendered size. Change only this to resize; leave chOff/chExt alone.
- To recolor: replace all srgbClr val inside the group with your target hex.

EMU reference: full slide = 12,192,000 x 6,858,000 | 1 cm ~= 360,000 | icon native ~= 489,000

When to use icons: section dividers, feature comparison rows, timeline milestones, cover decoration.
One icon per concept maximum — don't crowd slides.
