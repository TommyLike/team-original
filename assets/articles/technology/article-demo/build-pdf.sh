#!/bin/bash
# Build a PDF from a markdown file following the pipeline recipe:
# pandoc MD -> standalone HTML (with embedded CSS) -> headless Chromium PDF.
# Usage: ./build-pdf.sh <input.md> <output.pdf>
set -e
IN="$1"; OUT="$2"; CSS="${3:-pdf.css}"
DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="${OUT%.pdf}.html"

INDIR="$(cd "$(dirname "$IN")" && pwd)"
pandoc "$IN" -o "$HTML" --standalone --embed-resources \
  -f markdown-implicit_figures \
  --resource-path "$INDIR" \
  --metadata title="" \
  -c "$DIR/$CSS"

npx playwright pdf "$HTML" "$OUT" >/dev/null 2>&1
echo "built: $OUT ($(du -h "$OUT" | cut -f1))"
