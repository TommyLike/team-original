# 技术文章配图规范 — "Visual Guide" 视觉语言

> 提炼自 Maarten Grootendorst 的 "A Visual Guide to ..." 系列（quantization / MoE /
> Mamba / reasoning LLMs / LLM agents / diffusion，见 `sources/`）。
> 目标：让 explore 流程在书写**技术类文章**时，插图能稳定复刻这套清晰、
> 一致、可扫描的视觉风格。
>
> **已用 Gemini `gemini-3-pro-image` 实测验证**：同一套 STYLE 提示词跨主题
> （注意力 / MoE 路由 / 量化）输出高度一致，文字渲染清晰，其中 MoE 与量化两张
> 几乎复刻原文样图。

---

## 0. 使用前提：优先真实来源，AI 生成是兜底

**这套风格规范只在"需要 AI 生成图"时才启用。配图的取图顺序永远是：**

1. **首选：可信来源的真实图**。能从权威来源拿到的图，一律优先用真实图——
   - 论文原图（arXiv / 会议论文里的架构图、实验曲线）
   - 官方文档 / 官方博客 / 项目 README 里的示意图
   - 权威技术博客（如本仓 `sources/` 这类）、维基百科 / Wikimedia
   - 真实数据图表、产品截图、历史照片
   - **务必标注来源**（作者 + 链接），尊重版权与许可。
2. **兜底：AI 生成**。只有当**找不到**贴切、可信、许可允许的真实图时，才用
   AI 生成——且**必须按本规范的 STYLE 块生成**，保证与全文其它图风格统一。

> 原因：真实图（尤其论文原图、实测曲线）自带权威性和准确性，AI 生成图再逼真
> 也可能有细节错误。**能引真实图就别造图**；造图只为填补"没有合适真实图"的空缺。

配套执行细则见 explore 流程的 `visual-enhancer`（Step 5）——它先搜真实图，
搜不到再按本规范生成。

---

## 1. 为什么是这套风格

这套图不是"配图装饰"，而是**用图解释概念**——每张图承担一个具体的理解负担
（一个映射、一次数据流、一处对比）。它之所以好复刻、好扫描，是因为它把
视觉变量压到极少、且严格一致：

- **颜色即语义**：同一个概念在所有图里永远同一个颜色。读者一旦记住"紫=激活"，
  全文都成立。
- **形状极简**：几乎只有"圆角矩形盒子 + 粗黑描边 + 箭头"三种元素。
- **留白充足**：一张图只讲一件事，不堆信息。

---

## 2. 调色板（严格执行，附 hex）

| 角色 | 颜色 | Hex | 用途 |
|---|---|---|---|
| **主高亮 / 激活** | 鲜紫 | `#A64BF0` | 当前生效的元素、被选中的路径、主角 token |
| 次级 / 未激活 | 淡紫 | `#E4CCF7` | 同一概念的"未选中"副本（靠明度区分激活与否） |
| **特殊标记** | 品红 | `#E0218A` | 特殊 token、量化后的值、边界标记 |
| **模型 / 模块** | 米色 | `#EFE4D5` + 棕字 `#7A4A2E` | Router、ORM、LLM 等"模块盒子" |
| **最终输出** | 青绿 | `#57C7C7` | 输出结果盒子；**虚线青绿边框**用于分组容器 |
| 变量 A | 橄榄金 | `#A8912E` | 给公式/图里的某个变量固定配色 |
| 变量 B / 指示箭头 | 绿 | `#3E9E4E` | 另一个变量；或指向元素的标注箭头 |
| **标注文字** | 暗红 | `#8B1A1A` | 解释性旁注（"each token is projected 3 times"） |
| 主描边 / 主箭头 / 正文 | 黑 | `#111111` | 盒子描边、数据流箭头、主要文字 |
| 辅助线 / 弱化 | 灰 | `#9A9A9A` | 虚线辅助线、被弱化的元素 |

**背景永远纯白 `#FFFFFF`。** 不用渐变、不用阴影、不用 3D。

---

## 3. 形状与排版语言

- **盒子**：圆角矩形，**粗黑描边（~4px）**，圆角半径 ~12px，**单一纯色填充**。
- **文字**：粗体圆润无衬线（Nunito / Baloo 一类）。**关键词内联着色**，颜色与它
  对应的盒子一致（正文里的 "purple **answer**" 用紫色）。
- **箭头**：数据流用细黑箭头；分组用**虚线青绿框**；标注用**细弧线箭头**（黑或绿）
  从一句暗红旁注指向被解释的元素。
- **step 徽标**：灰色圆圈里放数字（①②③），标记步骤顺序。
- **序列**：token / 状态画成一排圆角小盒子，从左到右或从上到下流动。
- **对比**：上下两栏并列（如 "Masked Diffusion" vs "Uniform-state Diffusion"），
  同结构对齐，靠颜色/明度体现差异。

**核心原则——颜色编码一致性**：先给每个概念分配一个颜色，然后在整篇文章的
所有图、以及正文的内联关键词里，都用同一个颜色。这是这套风格"高级感"的真正来源。

---

## 4. 可复用的生成提示词（STYLE 块）

把下面这段 **STYLE 块**原样拼到每张图的"内容描述"后面。内容描述只写"画什么"，
STYLE 块负责"怎么画"，保证跨图一致。

```text
STYLE (follow exactly):
- Flat 2D vector infographic on a PURE WHITE background. No 3D, no gradients, no drop shadows, no photorealism.
- Every box is a rounded rectangle with a THICK solid BLACK outline (~4px) and ~12px rounded corners, filled with ONE flat solid color.
- Consistent color-coding — each concept keeps ONE color everywhere:
  * vivid purple (#A64BF0) = primary / active element
  * light lavender tint (#E4CCF7) = inactive or secondary copies
  * magenta-pink (#E0218A) = special tokens / markers
  * cream-beige box (#EFE4D5) with brown text (#7A4A2E) = a model / module
  * teal (#57C7C7) = final output; a DASHED teal border groups related parts
- Labels are BOLD rounded sans-serif (Nunito-like); key words colored to MATCH their box color.
- Thin curved BLACK arrows for data flow; a short dark-red (#8B1A1A) caption + curved arrow annotates one element.
- Generous whitespace, clean left-to-right flow, minimalist.
Flat vector infographic, no watermark.
```

**内容描述怎么写**（示例，来自实测 test2）：

```text
A clean technical explainer diagram illustrating MIXTURE OF EXPERTS (MoE) routing.
CONTENT: A dashed teal rounded container. At top, a cream-beige "Router" box.
Below it a tiny bar chart of 4 bars (one tall purple, three short lavender). A
black arrow goes from the tall bar down to "Expert 1" (vivid purple box). Beside
it "Expert 2/3/4" in light lavender (inactive). An output arrow leaves Expert 1 to
a teal "Output" box. A dark-red caption points at the router: "only the top expert
is activated".
```

**写内容描述的要点**：
1. 一句话点明这张图讲的**一个**概念。
2. 明确每个元素**用哪个语义色**（"Expert 1 (vivid purple)"、"inactive (lavender)"）。
3. 指明**数据流方向**和**一处暗红旁注**的内容。
4. 文字标签用**英文短词**（Gemini 对短英文标签渲染最稳）。中文长句旁注可行但
   偶有断字，重要标签优先英文。

---

## 5. 生成接口与调用（已验证）

- **模型**：`gemini-3-pro-image`（`gemini-3-pro-image-preview`）——风格一致性与
  文字渲染均最佳。快速草稿可用 `gemini-2.5-flash-image`。
- **接口**：Google Gemini `generateContent`，`responseModalities:["TEXT","IMAGE"]`，
  `temperature` 0.6–0.8。
- **Key**：环境变量 `GEMINI_API_KEY`。
- 调用脚手架见本仓 `ai-image-generator` skill 或 explore 流程 visual-enhancer 的内置示例。

> **实测结论**：`gemini-3-pro-image` 对本风格的文字渲染清晰、跨主题一致，
> **无需改用 GPT Image**。（老资料里"Gemini 不能渲染可读文字"的说法针对旧模型。）
> 若某天需要在图上放**大段多行文字**或**批量 10 变体**，再考虑 GPT Image 2。

---

## 6. 一致性自查清单

生成后逐条核对：

- [ ] 背景纯白，无阴影/渐变/3D
- [ ] 所有盒子：粗黑描边 + 圆角 + 单色填充
- [ ] 同一概念全图同色；激活=鲜色、未激活=淡色
- [ ] 模块盒=米色+棕字；输出=青绿；分组=虚线青绿框
- [ ] 有且仅有一处暗红弧线旁注，指向要强调的元素
- [ ] 文字清晰可读、无断字/乱码
- [ ] 一张图只讲一个概念，留白充足

---

## 7. 参考样本

- `sources/<topic>/images/` — 从原文抽取的样图（ground truth），生成前可先读几张
  建立视觉直觉，再对照本规范的 STYLE 块产图并确认一致性。
