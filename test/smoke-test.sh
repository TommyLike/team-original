#!/bin/bash
# Smoke test: run init-pipeline.sh for every pipeline type and assert that
# the critical orchestration files are generated without error.
#
# Usage: ./test/smoke-test.sh [--keep]
#   --keep   keep temp directories after the run (useful for inspection)
#
# Exit codes: 0 = all pass, 1 = one or more pipelines failed

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INIT="$REPO_ROOT/init-pipeline.sh"

KEEP=0
for arg in "$@"; do
    [ "$arg" = "--keep" ] && KEEP=1
done

PASS=0
FAIL=0
FAILED_TYPES=""

# ── per-pipeline file checklists ──────────────────────────────────────────────

collect_missing() {
    local dir="$1"; shift
    local missing=""
    local f
    for f in "$@"; do
        [ -f "$dir/$f" ] || missing="$missing $f"
    done
    printf '%s' "${missing# }"
}

check_research() {
    collect_missing "$1" \
        CLAUDE.md COWORK.md CLAUDE-RESUME.md input.md \
        agents/question-architect/CLAUDE.md \
        agents/narrative-architect/CLAUDE.md \
        agents/report-writer/CLAUDE.md \
        docs/STEP7-GUIDE.md
}

check_software() {
    collect_missing "$1" \
        CLAUDE.md CLAUDE-RESUME.md \
        artifacts/00-user-brief.md \
        agents/requirements/CLAUDE.md \
        agents/architect/CLAUDE.md \
        agents/coder/CLAUDE.md \
        agents/tester/CLAUDE.md
}

check_study() {
    collect_missing "$1" \
        CLAUDE.md CLAUDE-RESUME.md input.md \
        agents/learning-architect/CLAUDE.md \
        agents/curriculum-editor/CLAUDE.md \
        agents/bias-reviewer/CLAUDE.md
}

check_coding() {
    collect_missing "$1" \
        CLAUDE.md CLAUDE-RESUME.md input.md \
        agents/project-surveyor/CLAUDE.md \
        agents/architecture-mapper/CLAUDE.md \
        agents/design-interpreter/CLAUDE.md
}

check_tech() {
    collect_missing "$1" \
        CLAUDE.md COWORK.md CLAUDE-RESUME.md input.md \
        agents/tech-question-architect/CLAUDE.md \
        agents/report-writer/CLAUDE.md \
        docs/STEP7-GUIDE.md
}

check_explore() {
    collect_missing "$1" \
        CLAUDE.md CLAUDE-RESUME.md input.md \
        agents/topic-architect/CLAUDE.md \
        agents/visual-enhancer/CLAUDE.md \
        agents/knowledge-report-writer/CLAUDE.md \
        agents/devils-advocate/CLAUDE.md
}

# ── test runner ───────────────────────────────────────────────────────────────

run_one() {
    local pipeline="$1"
    local tmp
    tmp="$(mktemp -d)"

    printf '[%s] running ... ' "$pipeline"

    local log="$tmp/_smoke.log"
    if ! (cd "$tmp" && bash "$INIT" "$pipeline" >"$log" 2>&1); then
        echo "FAIL (script exited non-zero)"
        echo "    log: $log"
        tail -5 "$log" | sed 's/^/    /'
        FAIL=$((FAIL + 1))
        FAILED_TYPES="$FAILED_TYPES $pipeline"
        [ "$KEEP" -eq 0 ] && rm -rf "$tmp"
        return
    fi

    local missing
    missing="$(check_"$pipeline" "$tmp")"

    if [ -n "$missing" ]; then
        echo "FAIL (missing files: $missing)"
        echo "    dir: $tmp"
        FAIL=$((FAIL + 1))
        FAILED_TYPES="$FAILED_TYPES $pipeline"
        [ "$KEEP" -eq 0 ] && rm -rf "$tmp"
    else
        echo "PASS"
        PASS=$((PASS + 1))
        [ "$KEEP" -eq 0 ] && rm -rf "$tmp"
    fi
}

# ── main ──────────────────────────────────────────────────────────────────────

echo "Smoke-testing init-pipeline.sh ($INIT)"
echo "────────────────────────────────────────"

for pipeline in research software study coding tech explore; do
    run_one "$pipeline"
done

echo "────────────────────────────────────────"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    echo "FAILED pipelines:$FAILED_TYPES"
    exit 1
fi
