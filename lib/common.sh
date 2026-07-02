#!/bin/bash
# Shared helpers for init-pipeline.sh.
#
# Sourced by init-pipeline.sh. Relies on these variables being set by the
# caller before sourcing:
#   SCRIPT_DIR     — absolute path to the repo root (where init-pipeline.sh lives)
#   ASSETS_DIR     — $SCRIPT_DIR/assets
#   TEMPLATES_DIR  — $SCRIPT_DIR/templates

usage() {
    echo "Usage: init-pipeline <research|software|study|coding|tech|explore>"
    echo "  research         - Claude code and Cowork multi-agent research pipeline"
    echo "  software         - Multi-agent software development pipeline"
    echo "  study            - Learning guide builder pipeline (tech onboarding)"
    echo "  coding           - Open source codebase deep analysis pipeline"
    echo "  tech             - Technology assessment research pipeline (report output)"
    echo "  explore          - Knowledge exploration & mastery pipeline (report output)"
    exit 1
}

# Copy a pipeline's static scaffold (agent instruction files, orchestration
# CLAUDE.md, input templates, etc.) from templates/<type>/ into the current
# directory. The templates ARE the source of truth for all static content —
# there is no more embedded Python/heredoc content to escape.
copy_template() {
    local type="$1"
    local src="$TEMPLATES_DIR/$type"
    if [ ! -d "$src" ]; then
        echo "Error: template directory not found: $src" >&2
        exit 1
    fi
    # copy directory contents (including dotfiles) into the current dir
    cp -R "$src/." .
}

init_pipeline_log() {
    echo "# Pipeline log" > artifacts/00-pipeline-log.md
}

init_empty_artifacts() {
    for artifact in "$@"; do
        : > "$artifact"
    done
}

write_resume_file() {
    local next_step="$1"
    local body="$2"
    printf '# CLAUDE-RESUME.md\n\n## Current status\n\n**Next step**: %s\n\n%s\n' "$next_step" "${body//\\n/$'\n'}" > CLAUDE-RESUME.md
}

# Install the default rich-text fonts (Source Han Serif SC for CJK, Source Serif 4
# for Latin) into the user font dir if missing. Used by all PDF/PPTX/Word output.
# Never aborts scaffolding: any failure prints a warning and continues.
ensure_fonts() {
    local fonts_src="$ASSETS_DIR/fonts"
    local han="$fonts_src/source-han-serif/otf/SourceHanSerifSC-VF.otf"
    local serif_dir="$fonts_src/source-serif/OTF"
    local dest

    if [ ! -d "$fonts_src" ]; then
        echo "  [fonts] assets/fonts not found — skipping font install"
        return 0
    fi

    case "$(uname -s)" in
        Darwin) dest="$HOME/Library/Fonts" ;;
        *)      dest="$HOME/.local/share/fonts" ;;
    esac

    if [ -f "$dest/SourceHanSerifSC-VF.otf" ] && [ -f "$dest/SourceSerif4-Regular.otf" ]; then
        echo "  [fonts] default fonts already installed — skipping"
        return 0
    fi

    echo "  [fonts] installing Source Han Serif SC + Source Serif 4 into $dest"
    if ! mkdir -p "$dest" 2>/dev/null; then
        echo "  [fonts] could not create $dest — skipping"
        return 0
    fi
    if [ -f "$han" ]; then
        cp -f "$han" "$dest/" 2>/dev/null || echo "  [fonts] warn: Han Serif copy failed"
    fi
    if [ -d "$serif_dir" ]; then
        cp -f "$serif_dir"/*.otf "$dest/" 2>/dev/null || echo "  [fonts] warn: Source Serif copy failed"
    fi
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f "$dest" >/dev/null 2>&1 || true
    fi
    echo "  [fonts] fonts installed"
    return 0
}

# Drop per-project brand + storytelling reference files into docs/. Call from
# pipelines that produce rich-text output (PDF/PPTX/Word). Requires docs/ to exist.
install_richtext_assets() {
    local brand_src="$ASSETS_DIR/brand/rights.template.md"
    local boss_dai_dir="$ASSETS_DIR/articles/boss_dai"

    mkdir -p docs
    if [ -f "$brand_src" ]; then
        cp -f "$brand_src" docs/rights.template.md 2>/dev/null || echo "  [assets] warn: rights template copy failed"
    fi
    # Copy the storytelling corpus + style guide INTO the project so it is fully
    # self-contained — it works no matter where the project is later run, and does
    # not depend on the team-original repo staying at any absolute path.
    if [ -d "$boss_dai_dir" ]; then
        rm -rf docs/boss_dai
        cp -R "$boss_dai_dir" docs/boss_dai 2>/dev/null || echo "  [assets] warn: storytelling corpus copy failed"
    fi
    cat > docs/STORYTELLING-REFERENCE.md << 'STORYEOF'
# Storytelling Reference — 饭桶戴老板 voice

当某个富文本输出（尤其是 PDF）需要**有故事性 / 叙事笔调**时，按下面流程借鉴戴老板的笔法。
**只借语感与结构，绝不借事实**——数据与事实以本项目研究为准。

## 内置参考库（已随项目附带，直接读取，无需询问用户来源）
- 笔法指南：`docs/boss_dai/dai-writing-style.md`
- 原文语料：`docs/boss_dai/`（约 530 篇公众号原文，随项目自带）

## 步骤（务必按顺序）
1. **先读笔法指南** `docs/boss_dai/dai-writing-style.md`，建立整体认知。
2. **从 `docs/boss_dai/` 通读 5 篇原文**（以降低随机性）：
   - 优先挑与本报告**题材相近**的篇目（商业 / 科技 / 历史 / 地缘 / 人物）。
   - 跳过文件名带「转」的转载篇，以及 `dai-writing-style.md` 本身（那是指南不是原文）。
3. **先整理、后动笔**：读完后先针对本报告主题写一段「笔法应用要点」
   （开头怎么起、贯穿全文的核心设问、用哪个历史类比、结尾升华到什么），再写正文叙事段落。
4. **只用于叙事段落**：数据表、方法论、结论清单仍用中性、精确的表达。

## 何时不用
参考型、清单型、纯分析型报告默认用中性笔调。故事笔调按需开启，仅在用户要求时使用。
STORYEOF
}
