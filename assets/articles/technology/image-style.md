# 技术文章配图规范 — "技术蓝墨" 视觉语言

> **手法**提炼自 Maarten Grootendorst 的 "A Visual Guide to ..." 系列（quantization /
> MoE / Mamba / reasoning LLMs / LLM agents / diffusion，见 `sources/`）——
> 那套"一图一概念、颜色即语义、渐进式揭示"的**方法**照单全收。
> **但配色不照搬**：原系列用鲜紫 / 品红 / 青绿，饱和度高、偏活泼、抢注意力；
> 本规范把它换成一套**冷静、克制、工程感**的调色板（"技术蓝墨"），
> 让插图服务于理解，而不是跟正文抢眼球。
>
> 目标：让 explore 流程在书写**技术类文章**时，插图能稳定复刻这套清晰、
> 一致、可扫描、且**安静**的视觉风格。
>
> **已用 Gemini `gemini-3-pro-image` 实测验证**：同一套 STYLE 提示词跨主题
> 输出高度一致，文字渲染清晰。

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

- **颜色即语义**：同一个概念在所有图里永远同一个颜色。读者一旦记住"钢蓝=激活"，
  全文都成立。
- **形状极简**：几乎只有"圆角矩形盒子 + 粗黑描边 + 箭头"三种元素。
- **留白充足**：一张图只讲一件事，不堆信息。

**为什么把配色改成"技术蓝墨"**：原系列的鲜紫/品红/青绿很跳，一张图里好几处
高饱和色互相抢注意力，读者的视线不知道该落在哪。技术文章要的是"安静地把机制讲清"，
所以本规范把整套色收进**一个冷色家族（蓝—青—灰）+ 唯一一个暖强调（赭红）**：
全图只有那一处赭红在"喊话"（指向本图唯一要你注意的点），其余都退成冷静的背景。
墨黑描边本身已经提供了结构感，填充色不需要再靠高饱和度去撑。

---

## 2. 调色板（"技术蓝墨"，严格执行，附 hex）

| 角色 | 颜色 | Hex | 用途 |
|---|---|---|---|
| **主高亮 / 激活** | 钢蓝 | `#2F6FB0` | 当前生效的元素、被选中的路径、主角（唯一"强"的冷色） |
| 次级 / 未激活 / 缓存副本 | 淡蓝灰 | `#D3E0EC` | 同一概念的"未选中"副本（靠明度区分激活与否） |
| **唯一暖强调** | 赭红 | `#B0553F` | **全图仅此一处跳色**：特殊标记（PIN / GCS / 边界标记）**和**那句解释性旁注，共用这一个暖色 |
| **模型 / 模块** | 冷灰 | `#EBEEF2` + 深墨字 `#33414F` | Router、Scheduler、ORM、LLM 等"模块盒子"（冷中性，不抢戏） |
| **最终输出 / 分组容器** | 沉青 | `#3F8F8A` | 输出结果盒子；**虚线沉青边框**用于分组容器（如一个 Node） |
| 第二变量 / 次要区分 | 灰绿 | `#5A8F6B` | 需要第二个变量色时用（如 Driver、另一条数据线） |
| 主描边 / 主箭头 / 正文 | 墨黑（微带蓝） | `#1B2430` | 盒子描边、数据流箭头、主要文字 |
| 辅助线 / 弱化 / step 徽标 | 冷灰 | `#9AA6B2` | 虚线辅助线、被弱化的元素、①②③步骤圆圈 |

**背景永远纯白 `#FFFFFF`。** 不用渐变、不用阴影、不用 3D。

**唯一暖色纪律（本规范的核心）**：赭红 `#B0553F` 是全图**唯一**的暖色，且**每张图最多出现在两处**——
一个特殊标记 + 一句旁注。它的作用就是"读者的视线锚点"。一旦一张图里出现两三块赭红，
它就不再是强调，而是噪声——请退回冷色家族。

---

## 3. 形状与排版语言

- **盒子**：圆角矩形，**中细墨黑描边（`#1B2430`，~2px，清晰但不显笨重）**，圆角半径 ~12px，**单一纯色填充**。
- **分组容器（如一个 Node）**：**只用虚线沉青（`#3F8F8A`）边框**，**不要**再套一层黑色实线外框——
  容器靠虚线区分层级，实线只留给具体盒子。
- **文字**：粗体圆润无衬线（Nunito / Baloo 一类）。**关键词内联着色**，颜色与它
  对应的盒子一致（正文里的 "steel-blue **Worker**" 用钢蓝）。
- **箭头**：数据流用细墨黑箭头；分组用**虚线沉青框**；标注用**细弧线箭头**（墨黑或赭红）
  从一句赭红旁注指向被解释的元素。
- **step 徽标**：**冷灰**圆圈里放数字（①②③），标记步骤顺序（不要用暖色，避免和赭红旁注争夺注意力）。
- **序列**：token / 状态画成一排圆角小盒子，从左到右或从上到下流动。
- **对比**：上下两栏并列，同结构对齐，靠颜色/明度体现差异（激活=钢蓝、未激活=淡蓝灰）。

**核心原则——颜色编码一致性**：先给每个概念分配一个颜色，然后在整篇文章的
所有图、以及正文的内联关键词里，都用同一个颜色。这是这套风格"高级感"的真正来源。

---

## 4. 可复用的生成提示词（STYLE 块）

把下面这段 **STYLE 块**原样拼到每张图的"内容描述"后面。内容描述只写"画什么"，
STYLE 块负责"怎么画"，保证跨图一致。

```text
STYLE (follow exactly):
- Flat 2D vector infographic on a PURE WHITE background. No 3D, no gradients, no drop shadows, no photorealism.
- Every box is a rounded rectangle with a CLEAN MEDIUM-THIN solid outline in ink-black (#1B2430, ~2px — crisp but NOT heavy/chunky) and ~12px rounded corners, filled with ONE flat solid color.
- RESTRAINED, calm engineering palette. Low saturation. Consistent color-coding — each concept keeps ONE color everywhere:
  * steel blue (#2F6FB0) = primary / active element (the ONLY strong color)
  * pale blue-grey (#D3E0EC) = inactive / secondary / cached copies
  * cool-grey box (#EBEEF2) with dark ink text (#33414F) = a model / module
  * muted teal (#3F8F8A) = final output; a DASHED muted-teal border groups related parts
  * sage green (#5A8F6B) = a second variable when needed
  * ochre-red (#B0553F) = THE ONLY WARM ACCENT, used sparingly — special markers AND the single annotation caption share this one color
- Grouping containers use ONLY a dashed muted-teal border — do NOT wrap them in a solid black outer box.
- Labels are BOLD rounded sans-serif (Nunito-like); key words colored to MATCH their box color.
- Thin curved ink-black (#1B2430) arrows for data flow; small numbered cool-grey (#9AA6B2) circle badges (1,2,3...) mark step order; exactly ONE short ochre-red (#B0553F) caption + curved arrow annotates one element.
- Generous whitespace, clean left-to-right flow, minimalist and QUIET — nothing should visually shout except the single ochre-red annotation.
Flat vector infographic, no watermark.
```

**内容描述怎么写**（示例）：

```text
A clean technical explainer diagram illustrating MIXTURE OF EXPERTS (MoE) routing.
CONTENT: A dashed muted-teal rounded container. At top, a cool-grey "Router" box.
Below it a tiny bar chart of 4 bars (one tall steel-blue, three short pale blue-grey).
A black arrow goes from the tall bar down to "Expert 1" (steel-blue box). Beside it
"Expert 2/3/4" in pale blue-grey (inactive). An output arrow leaves Expert 1 to a
muted-teal "Output" box. One ochre-red caption points at the router: "only the top
expert is activated".
```

**写内容描述的要点**：
1. 一句话点明这张图讲的**一个**概念。
2. 明确每个元素**用哪个语义色**（"Expert 1 (steel-blue)"、"inactive (pale blue-grey)"）。
3. 指明**数据流方向**和**那一处赭红旁注**的内容（每图只留一处）。
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
- [ ] 所有具体盒子：中细墨黑描边（~2px，不笨重）+ 圆角 + 单色填充
- [ ] 分组容器只有虚线沉青框，**没有**黑色实线外框
- [ ] 同一概念全图同色；激活=钢蓝、未激活/缓存=淡蓝灰
- [ ] 模块盒=冷灰+深墨字；输出=沉青；分组=虚线沉青框
- [ ] **赭红全图最多两处**（一个标记 + 一句旁注），是全图唯一暖色/唯一"喊话"处
- [ ] step 徽标是冷灰圆圈，不用暖色
- [ ] 文字清晰可读、无断字/乱码
- [ ] 一张图只讲一个概念，留白充足，整体"安静"

---

## 7. 参考样本

- `sources/<topic>/images/` — 从原文抽取的样图（ground truth）。**注意**：这些样图用的是
  原系列的鲜紫/品红配色，只作**手法**参考（一图一概念、渐进揭示、正文↔图咬合），
  **配色以本规范第 2 节的"技术蓝墨"为准**，不要复刻原图的高饱和色。
- `article-demo/v3/images/` — 按本规范"技术蓝墨"实际生成的一整套图（Ray 架构讲解），
  可作为落地样例：同一套 STYLE 块跨 6-7 张图保持一致、且整体安静不抢眼。
