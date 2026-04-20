<div align="center">

# AIBTI · Theoretical Foundation 理论根基

**Every dimension backed by 2020-2026 papers, official docs, and public talks from AI leaders.**

**[English](#english)** · **[中文](#中文)**

</div>

---

## English

### Why Theory Matters

AIBTI isn't astrology. Every dimension maps to peer-reviewed research + official best practices from Anthropic / OpenAI / Google DeepMind, plus public positions from **Karpathy**, **Jason Wei**, **Simon Willison**, and others. The theory stack is **layered**: 2020-2023 **foundational work** explains "why this variable matters", and **2024-2026 frontier work** explains "how this variable manifests in today's agentic AI tools (Claude Code / Cursor / Codex / Copilot)".

### The Paradigm Shift (2022 → 2026)

```
2022: Prompt Engineering        ← Chain-of-Thought, few-shot
2023: Advanced Prompting        ← ReAct, Tree of Thoughts
2024: Agentic Systems           ← Computer Use, MCP, Claude Code
2025: Context Engineering       ← Long context, prompt caching, context editing
2025-26: Reasoning Models       ← o1, o3, DeepSeek-R1, Extended Thinking
```

AIBTI measures where **you** sit in this evolving landscape.

---

### Dimension 1 · A/C · Specificity (Abstract ↔ Concrete)

> **Core claim**: The more precisely you describe your task, the better the model performs. This is the single most consistent finding across all major labs.

**Foundational (2020-2023)**
- **Anthropic《Be Clear, Direct & Detailed》** — official Prompt Engineering Overview, rule #1
- **OpenAI《GPT Best Practices》Strategy 1**: "Write clear instructions" · "Include details in your query"
- **Andrej Karpathy** — "LLMs are like eager interns with amnesia; specificity compounds" (2022-2023 public talks)

**Modern (2024-2026)**
- **Karpathy《Software 3.0: Program Computers in English》** — AI Engineer Summit 2024. Key shift: prompts are now **specifications**, not incantations.
- **Anthropic《Claude Code Best Practices》** (2024-2025) — the [CLAUDE.md](https://docs.claude.com/en/docs/claude-code/memory) convention is specificity codified into a filesystem artifact.
- **Cursor Rules** (2024) — `.cursorrules` file: persistent project-level specification.
- **Simon Willison's "LLM as a prose-programmer"** (2024-2025 blog posts) — programming is now prose engineering.

**What AIBTI measures**: Do your prompts name specific files / functions / line numbers / types (C), or do they stay at concept-level ("the architecture", "this part") (A)?

---

### Dimension 2 · M/V · Context Provision (Minimal ↔ Verbose)

> **Core claim**: How much reference material (examples, docs, code) you provide decides the model's reliability. But with 1M-token context windows in 2025, "more" is no longer automatically better — **Context Engineering** is a discipline.

**Foundational (2020-2023)**
- **Brown et al. 2020《Language Models are Few-Shot Learners》** (arxiv 2005.14165) — the GPT-3 paper that established *in-context learning*.
- **Anthropic《Multishot Prompting》** — official guide: 3-5 examples often hit the "few-shot plateau".
- **OpenAI《Provide reference text》** — Strategy 2.
- **Lewis et al. 2020《RAG: Retrieval-Augmented Generation》** (arxiv 2005.11401) — foundational for context retrieval.

**Modern (2024-2026)**
- **Liu et al. 2023《Lost in the Middle》** (arxiv 2307.03172) — **the pivotal paper**: models systematically ignore mid-context information. "More context" can hurt performance.
- **Anthropic《Prompt Caching》** (launched 2024.08) — makes large reusable contexts economically viable.
- **Anthropic《Effective Context Engineering for Agents》** (2025) — the emerging discipline that replaces "Prompt Engineering".
- **Google Gemini 1.5 Technical Report** (2024) — 1M-context feasibility + "Needle in Haystack" benchmarks.
- **Anthropic Context Editing / Memory APIs** (2025) — active context management, not passive dumping.

**What AIBTI measures**: Do you ship terse prompts (M, risks under-context) or bulk-drop code + specs + examples (V, risks lost-in-middle)? Neither is "right" — it's a signature.

---

### Dimension 3 · D/L · Interaction Mode (Directive ↔ Collaborative)

> **Core claim**: Whether you treat the AI as **a subordinate to command** or **a peer to reason with** fundamentally changes output quality. 2024-2025 has made this mode explicit via Agent vs Edit modes across all major tools.

**Foundational (2020-2023)**
- **Andrej Karpathy** — "Treat the LLM as a junior collaborator, not an oracle." (widely cited 2022-2023 talks)
- **Yao et al. 2022《ReAct: Synergizing Reasoning and Acting》** (arxiv 2210.03629, ICLR 2023) — the theoretical formalization of collaborative loops.
- **Anthropic《System Prompts / Role Prompting》** — official guide on persona assignment.

**Modern (2024-2026)**
- **Anthropic《Building Effective Agents》** (2024.12) — the **industry-standard agent patterns** document: Augmented LLM, Workflow, Autonomous Agent.
- **Model Context Protocol (MCP)** (Anthropic 2024.11) — open standard for tool interoperability, reshaping human-AI collaboration.
- **Anthropic Computer Use** (2024.10) — AI as operator-level collaborator, not just chat.
- **Cursor Agent / Claude Code Agent / Plan Mode** (2024-2025) — productized collaborative modes.
- **Karpathy 2024-2025**: updated metaphor to "LLM is a **junior engineer with tools**" (upgrade from "intern").
- **Sholto Douglas / Jack Morris** (2025) — public discourse on "engineer-as-director" workflow.

**What AIBTI measures**: Do you issue orders (D: "rewrite this block") or invite collaboration (L: "which approach do you prefer?")?

---

### Dimension 4 · X/E · Decomposition & Verification (Explore ↔ Execute)

> **Core claim**: Complex problems collapse under single-shot execution. You need to **decompose**, **reason**, and **verify**. 2024-2025 turned this from technique into **first-class capability** via reasoning models.

**Foundational (2020-2023)**
- **Wei et al. 2022《Chain-of-Thought Prompting》** (arxiv 2201.11903, NeurIPS 2022) — the landmark paper: "Let's think step by step" alone dramatically improves accuracy. Cited 5000+ in 3 years.
- **Yao et al. 2023《Tree of Thoughts》** (arxiv 2305.10601, NeurIPS 2023) — CoT upgrade: tree-search over reasoning paths.
- **OpenAI《Split complex tasks》** — Strategy 3.
- **Anthropic《Let Claude Think》** — official CoT guide.

**Modern (2024-2026)**
- **OpenAI o1 System Card** (2024.09) — **reasoning as first-class capability**. Test-time compute becomes a scaling axis.
- **OpenAI o3 announcement** (2024.12) — frontier reasoning model.
- **DeepSeek-R1** (2025.01) — open-source reasoning model, democratized long-form thinking.
- **Anthropic Extended Thinking** (2025) — Claude's native reasoning mode, `<thinking>` blocks as product feature.
- **Google Gemini Deep Research** (2024) — agentic research: plan → search → synthesize → verify loop.
- **Jason Wei《Thoughts on Reasoning》** (2024-2025 blog posts) — internal view from the researcher who brought us CoT.
- **Karpathy "Plan before execute"** (2024-2025) — popularized Plan Mode in Claude Code.

**What AIBTI measures**: Do you explore options first (X: "what are the trade-offs?") or jump to execution (E: "just do it")?

---

### Why This Matters for You

AIBTI is not a personality label. It's **a lens calibrated by the best minds in AI** showing you your own habits. Understanding where you sit on 4 dimensions tells you:

- **Which 2024-2026 tool mode** fits you (Agent vs Edit, Plan vs Direct, Extended Thinking vs Fast)
- **What AI leader's philosophy** matches your style (Karpathy's collaborator view? Wei's reasoning view?)
- **Where your blind spots hide** based on known failure modes (Lost-in-the-middle for V types, under-specification for A types)

---

### Recommended Reading Path

**If you have 30 minutes** → Read Anthropic's [Prompt Engineering Overview](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview) and [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents).

**If you have 2 hours** → Add Karpathy's [Software 3.0 talk](https://www.youtube.com/results?search_query=karpathy+software+3.0) and OpenAI o1 system card.

**If you have a weekend** → Read Wei 2022 CoT, Yao 2022 ReAct, Liu 2023 Lost-in-Middle, DeepSeek-R1 paper — in that order.

---

## 中文

### 为什么要有理论

AIBTI 不是星座。每个维度都对标同行评议的论文 + Anthropic / OpenAI / Google DeepMind 官方实践 + **Karpathy / Jason Wei / Simon Willison** 等业界领袖的公开观点。理论栈是**分层**的：2020-2023 的**奠基论文**解释"这个变量为什么重要"，**2024-2026 的前沿工作**解释"这个变量在今天的 Agent 时代（Claude Code / Cursor / Codex / Copilot）里怎么显现"。

### 范式演进（2022 → 2026）

```
2022:  Prompt Engineering       ← CoT, Few-shot
2023:  高级 Prompting           ← ReAct, Tree of Thoughts
2024:  Agentic 系统             ← Computer Use, MCP, Claude Code
2025:  Context Engineering      ← 长上下文, Prompt Caching, Context Editing
2025-26: 推理模型                ← o1, o3, DeepSeek-R1, Extended Thinking
```

AIBTI 测量**你**在这个演进地图上的位置。

---

### 维度 1 · A/C · Specificity（抽象 ↔ 具象）

> **核心主张**：提示词描述得越精确，模型表现越好。这是所有头部实验室一致认同的最稳定发现。

**奠基（2020-2023）**
- **Anthropic《Be Clear, Direct & Detailed》**——官方 Prompt Engineering 指南第一条
- **OpenAI《GPT Best Practices》Strategy 1**："写清晰的指令" · "在你的 query 里包含细节"
- **Andrej Karpathy**——"LLMs are like eager interns with amnesia; specificity compounds."

**前沿（2024-2026）**
- **Karpathy《Software 3.0: 用英语给计算机编程》**——AI Engineer Summit 2024。关键转变：**提示词不再是"咒语"，是"规格说明（specification）"**。
- **Anthropic《Claude Code Best Practices》**（2024-2025）——[CLAUDE.md](https://docs.claude.com/en/docs/claude-code/memory) 约定把 specificity 固化到文件级。
- **Cursor Rules**（2024）——`.cursorrules` 文件持久化项目级规格。
- **Simon Willison "LLM as a prose-programmer"**（2024-2025 博客）——编程即"散文工程"。

**AIBTI 测量**：你的提示词是命名具体的文件/函数/行号/类型（C），还是停在概念层面（"架构"、"这部分"）（A）？

---

### 维度 2 · M/V · Context Provision（精简 ↔ 详尽）

> **核心主张**：提供多少参考信息（示例/文档/代码）决定了模型的可靠性。但 2025 年 100 万 token 上下文时代，"多"不再自动等于"好"——**Context Engineering** 已经成为独立学科。

**奠基（2020-2023）**
- **Brown et al. 2020《Language Models are Few-Shot Learners》**（arxiv 2005.14165）——GPT-3 论文，确立了"上下文学习"范式
- **Anthropic《Multishot Prompting》**——官方指南：3-5 个示例通常达到 few-shot plateau
- **OpenAI《Provide reference text》**——Strategy 2
- **Lewis et al. 2020《RAG》**（arxiv 2005.11401）——上下文检索的奠基论文

**前沿（2024-2026）**
- **Liu et al. 2023《Lost in the Middle》**（arxiv 2307.03172）——**关键转折论文**：模型系统性地忽略中段信息。"更多上下文"反而可能变差。
- **Anthropic《Prompt Caching》**（2024.08 发布）——让大上下文经济可行。
- **Anthropic《Effective Context Engineering for Agents》**（2025）——正在取代 "Prompt Engineering" 的新学科。
- **Google Gemini 1.5 技术报告**（2024）——1M 上下文可行性 + "Needle in Haystack" 基准。
- **Anthropic Context Editing / Memory APIs**（2025）——主动上下文管理，不再是被动塞。

**AIBTI 测量**：你是短提示词（M，风险是上下文不够）还是大段代码+规格+示例（V，风险是中段丢失）？没有"对错"，只是特征。

---

### 维度 3 · D/L · Interaction Mode（指令 ↔ 协作）

> **核心主张**：你把 AI 当**下属发号施令**还是**同事商量协作**，决定了产出质量。2024-2025 所有头部工具都已经把这个模式显式化（Agent mode vs Edit mode）。

**奠基（2020-2023）**
- **Andrej Karpathy**——"LLM 是初级协作者，不是神谕"（2022-2023 广泛引用）
- **Yao et al. 2022《ReAct: Synergizing Reasoning and Acting》**（arxiv 2210.03629，ICLR 2023）——协作循环的理论化
- **Anthropic《System Prompts / Role Prompting》**——官方指南

**前沿（2024-2026）**
- **Anthropic《Building Effective Agents》**（2024.12）——**业界标准的 agent 模式文档**：Augmented LLM、Workflow、Autonomous Agent。
- **Model Context Protocol (MCP)**（Anthropic 2024.11）——工具互操作性的开放标准，重塑人机协作。
- **Anthropic Computer Use**（2024.10）——AI 作为操作级协作者，而非纯对话。
- **Cursor Agent / Claude Code Agent / Plan Mode**（2024-2025）——协作模式产品化。
- **Karpathy 2024-2025** 把比喻升级为 **"LLM 是带工具的初级工程师"**（从"实习生"进化）
- **Sholto Douglas / Jack Morris**（2025）——"工程师即指挥官"的公共讨论

**AIBTI 测量**：你下指令（D：'重写这段'）还是邀请协作（L：'你觉得哪种方式好？'）？

---

### 维度 4 · X/E · Decomposition & Verification（探索 ↔ 执行）

> **核心主张**：复杂问题经不起一次性执行，你需要**分解、推理、验证**。2024-2025 通过推理模型把这一点从"技巧"升级为 **AI 的一级能力**。

**奠基（2020-2023）**
- **Wei et al. 2022《Chain-of-Thought Prompting》**（arxiv 2201.11903，NeurIPS 2022）——**里程碑论文**：一句 "Let's think step by step" 大幅提升准确率。3 年被引 5000+。
- **Yao et al. 2023《Tree of Thoughts》**（arxiv 2305.10601，NeurIPS 2023）——CoT 升级：在推理路径上做树搜索。
- **OpenAI《Split complex tasks》**——Strategy 3
- **Anthropic《Let Claude Think》**——官方 CoT 指南

**前沿（2024-2026）**
- **OpenAI o1 System Card**（2024.09）——**推理作为一级能力**。Test-time compute 成为新的扩展维度。
- **OpenAI o3 announcement**（2024.12）——前沿推理模型
- **DeepSeek-R1**（2025.01）——推理模型**开源时代**的开始
- **Anthropic Extended Thinking**（2025）——Claude 原生推理模式，`<thinking>` 块成为产品特性
- **Google Gemini Deep Research**（2024）——agentic 研究：计划 → 检索 → 合成 → 验证循环
- **Jason Wei《Thoughts on Reasoning》**（2024-2025 博客系列）——CoT 原作者的内部视角
- **Karpathy "Plan before execute"**（2024-2025）——Claude Code 的 Plan Mode 就是这个思想的产品化

**AIBTI 测量**：你先探索选项（X：'有什么 trade-off？'）还是直接执行（E：'做就完了'）？

---

### 为什么你应该关心

AIBTI 不是人格标签。它是**一个由业界顶尖大脑校准的镜子**，照出你自己的习惯。理解你在 4 维上的位置能告诉你：

- **哪种 2024-2026 工具模式**适合你（Agent vs Edit、Plan vs Direct、Extended Thinking vs Fast）
- **哪位 AI 大神的哲学**匹配你的风格（Karpathy 协作论？Wei 推理论？）
- **你的盲区在哪里**——基于已知的失败模式（V 型的 Lost-in-the-middle；A 型的欠规格化）

---

### 推荐阅读路径

**如果你有 30 分钟** → 读 Anthropic 的 [Prompt Engineering Overview](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview) 和 [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)。

**如果你有 2 小时** → 加上 Karpathy 的 [Software 3.0 演讲](https://www.youtube.com/results?search_query=karpathy+software+3.0) 和 OpenAI o1 system card。

**如果你有一个周末** → 按顺序读 Wei 2022 CoT、Yao 2022 ReAct、Liu 2023 Lost-in-Middle、DeepSeek-R1 论文。

---

<div align="center">

**AIBTI · Theoretical Foundation** · [⬅ README](./README.md) · [⭐ GitHub](https://github.com/leefufufufufu-rgb/aibti) · [🌐 wengui.xyz/aibti](https://wengui.xyz/aibti)

</div>
