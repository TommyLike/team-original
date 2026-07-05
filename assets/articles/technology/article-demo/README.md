# article-demo — 技术文章重写 + 配图的样例工坊

这是把本目录的两份规范**应用到一篇真实文章**上的完整样例，用于持续打磨、
对比不同版本的效果：

- 写作手法 → [`../rule.md`](../rule.md)
- 配图风格 → [`../image-style.md`](../image-style.md)

样例文章：《Ray 架构总览——从 Driver 到 Worker 的消息流动》
（原文微信公众号「开源时刻」，2025-05-21，
<https://mp.weixin.qq.com/s/-vUcr6SdV2WX7KsQoNBqZw>）。

## 版本

| 版本 | 说明 |
|---|---|
| **v1** | 原文，原图。作为对比基线。 |
| **v2** | 按 `rule.md` 重写（问题导入 / 自底向上 / 预先给地图 / 问题式小标题 / 直觉收尾），按 `image-style.md` 用 Gemini **重新生成全部配图**。 |
| **v3** | 按 `rule.md` **v0.4** 的「病→药→效→托」骨架重构：戴老板式**具体场景开篇**、每节钩子句；**补上 v2 缺的"效"**（§六 三处设计各省下什么）和**"托"**（§七 真实采用方 + 可跑最小示例 + 坦诚边界）；配图改用 **"技术蓝墨"** 配色（钢蓝 + 赭红，降饱和、不抢注意力），并修掉 v2 两处图 bug。 |
| v4… | 留待后续迭代（见下方「怎么做下一版」）。 |

**对比看 PDF**：`v1/…v1.pdf` ↔ `v2/…v2.pdf` ↔ `v3/Ray-architecture-v3.pdf`。
v1→v3 的差异：原文搬运 → 结构化讲解（v2）→ 完整的病药效托 + 冷静配色（v3）。

## 目录结构

```text
article-demo/
├── README.md              # 本文件
├── build-pdf.sh           # Markdown → PDF（pipeline recipe：pandoc→HTML→Chromium）；第 3 参数可指定 css
├── pdf.css                # v1/v2 PDF 排版（紫色系）
├── pdf-v3.css             # v3 PDF 排版（"技术蓝墨"：钢蓝标题 / 赭红强调 / 沉青引用）
├── tools/
│   ├── gen-images.py       # v2 配图生成器（内置旧 STYLE 块）
│   ├── gen-images-v3.py    # v3 配图生成器（内置"技术蓝墨" STYLE 块）
│   ├── prompts-structural.json / -v3.json   # 结构图 CONTENT（概念/节点/内存/集群）
│   ├── prompts-stages.json / -v3.json       # 5 张消息流阶段图 CONTENT
│   └── prompts-hero.json / -v3.json         # 标题 hero 图 CONTENT
├── v1/
│   ├── article.md          # 原文（feedgrab 抓取）
│   ├── render.md           # 渲染用（图片改为本地路径、去掉 front-matter）
│   ├── images/             # 原文配图
│   └── Ray-architecture-v1.pdf
└── v2/
    ├── article.md          # 重写稿（含 <!-- IMG: name --> 图槽）
    ├── render.md           # 渲染用（图槽已替换为图片 + 斜体图注）
    ├── images/             # 按我们的风格重新生成的配图（含 hero）
    └── Ray-architecture-v2.pdf
```

## 复现 / 重建

### 建 PDF

```bash
# 从本目录运行；css 与脚本同目录，第 3 参数可选（默认 pdf.css）
./build-pdf.sh v2/render.md v2/Ray-architecture-v2.pdf              # v2（紫色系）
./build-pdf.sh v3/render.md v3/Ray-architecture-v3.pdf pdf-v3.css   # v3（技术蓝墨）
```

依赖：`pandoc`、`npx playwright`（Chromium）、已安装的思源宋体 + Source Serif 4
（由仓库根 `init-pipeline.sh` / `ensure_fonts` 安装）。**不要用 weasyprint**
（无法解析可变/TTC 中文字体）。

### 生成配图

```bash
export GEMINI_API_KEY=<你的 key>
cd v3                      # 图会写到当前目录的 images/
python3 ../tools/gen-images-v3.py ../tools/prompts-structural-v3.json
python3 ../tools/gen-images-v3.py ../tools/prompts-stages-v3.json
python3 ../tools/gen-images-v3.py ../tools/prompts-hero-v3.json
```

`gen-images-v3.py` 里内置了 `image-style.md`「技术蓝墨」的 **STYLE 块**；prompts JSON
只描述每张图「画什么」（CONTENT），风格由 STYLE 块统一保证。模型用
`gemini-3-pro-image`。（v2 用 `gen-images.py` + `prompts-*.json`，紫色系旧配色。）

## 怎么做下一版（v3、v4…）

1. `cp -R v2 v3`。
2. 编辑 `v3/article.md`：调整结构 / 补充内容 / 改图槽。
3. 要改图就编辑 `tools/prompts-*.json` 里对应条目的 CONTENT（**别动 STYLE 块**，
   风格要保持一致），然后 `cd v3 && python3 ../tools/gen-images.py ...` 重新生成。
4. 把 `v3/article.md` 里的 `<!-- IMG: name -->` 图槽替换成
   `![](images/name.png)` + 一行 `*图：说明*`（斜体图注，PDF 会自动排成更浅更小）。
   —— v2 的 `render.md` 可作模板。
5. `./build-pdf.sh v3/render.md v3/Ray-architecture-v3.pdf`。
6. 对比 v2/v3 的 PDF，把好的改动**反哺**回 `../rule.md` / `../image-style.md`。

> 迭代的目标不只是这篇文章更好看，而是通过一次次对比，把「什么样的重写和配图
> 真正有效」沉淀回上层的两份规范里。

## 已知小瑕疵

**v2 的两处图 bug，已在 v3 修掉：**

- ~~v2「阶段五」图里小对象 Y 被画在节点 2~~ → v3 已改到发起方（节点 1）的进程内存里。
- ~~阶段图节点边框实线黑框/虚线青框不统一~~ → v3 STYLE 块强制「分组容器只用虚线沉青框、无黑实线外框」，全套一致。

（后续版本若发现新瑕疵，续记于此。）
