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
| v3、v4… | 留待后续迭代（见下方「怎么做下一版」）。 |

**对比看 PDF**：`v1/Ray-architecture-v1.pdf` ↔ `v2/Ray-architecture-v2.pdf`。

## 目录结构

```text
article-demo/
├── README.md              # 本文件
├── build-pdf.sh           # Markdown → PDF（pipeline recipe：pandoc→HTML→Chromium）
├── pdf.css                # PDF 排版（思源宋体 / Source Serif 4 + 配图斜体图注）
├── tools/
│   ├── gen-images.py       # Gemini 配图生成器（内置 image-style 的 STYLE 块）
│   ├── prompts-structural.json  # 结构图的 CONTENT 提示词（概念/节点/内存/集群）
│   ├── prompts-stages.json      # 5 张消息流阶段图的 CONTENT 提示词
│   └── prompts-hero.json        # 标题 hero 图的 CONTENT 提示词
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
# 从本目录运行；pdf.css 与脚本同目录
./build-pdf.sh v2/render.md v2/Ray-architecture-v2.pdf
```

依赖：`pandoc`、`npx playwright`（Chromium）、已安装的思源宋体 + Source Serif 4
（由仓库根 `init-pipeline.sh` / `ensure_fonts` 安装）。**不要用 weasyprint**
（无法解析可变/TTC 中文字体）。

### 生成配图

```bash
export GEMINI_API_KEY=<你的 key>
cd v2                      # 图会写到当前目录的 images/
python3 ../tools/gen-images.py ../tools/prompts-structural.json
python3 ../tools/gen-images.py ../tools/prompts-stages.json
python3 ../tools/gen-images.py ../tools/prompts-hero.json
```

`gen-images.py` 里内置了 `image-style.md` 的 **STYLE 块**；prompts JSON 只描述
每张图「画什么」（CONTENT），风格由 STYLE 块统一保证。模型用
`gemini-3-pro-image`。

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

## 已知小瑕疵（留给后续版本修）

- v2「阶段五」图里，小对象 Y 被画在了节点 2，按剧情应在发起方（节点 1）的
  进程内存里——语义小错，不影响「X 被回收、Y 保留」的主旨。
- 阶段图的节点边框在个别图里是实线黑框、个别是虚线青框（应统一为虚线青框）。
