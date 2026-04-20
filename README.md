<div align="center">

# AIBTI

### AI Behavior Type Indicator

**Behavior doesn't lie. Your prompts betray who you really are.**

**Works with: Claude Code · Cursor · Codex · Copilot Chat**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Privacy](https://img.shields.io/badge/Privacy-100%25%20Local-00ff88.svg)](./PRIVACY.md)
[![Zero Telemetry](https://img.shields.io/badge/Telemetry-Zero-00ff88.svg)](./PRIVACY.md)
[![Auditable](https://img.shields.io/badge/Code-Auditable-blue.svg)](https://github.com/leefufufufufu-rgb/aibti)
[![Version](https://img.shields.io/badge/version-0.2.0-orange.svg)](https://github.com/leefufufufufu-rgb/aibti/releases)

**[English](#english)** · **[中文](#中文)** · 🎨 **[Live Demo](https://leefufufufufu-rgb.github.io/aibti/)** · 🖼 **[16 Portraits](https://leefufufufufu-rgb.github.io/aibti/portraits/)** · 🔒 **[Privacy](./PRIVACY.md)**

</div>

## 🔒 Privacy Manifesto (read this first)

```
✓  100% local — your prompts never leave your machine
✓  Zero network requests — verifiable in < 5 lines of code
✓  Zero telemetry, zero analytics, zero account
✓  MIT open-source — every file is auditable (~50 files total)
✓  Auto-redaction — emails / API keys / phone numbers masked before anything is written
✗  No cloud. No server. No "free tier". No "upgrade to pro".
```

**Verify for yourself**: `./scripts/check-network.sh` — proves AIBTI makes zero network calls. See [PRIVACY.md](./PRIVACY.md) for the full deep-dive.

---

---

## English

> **The first AI personality test that reads your actual prompts — not a survey.**
>
> Built on theories from **Anthropic**, **OpenAI**, **Karpathy**, **Chain-of-Thought**, and **ReAct**. Ships as a **Claude Code Plugin**.

### ✨ What It Does

```
> Analyze my AIBTI

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AIBTI Weekly Report · 2026-W16
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  🔮 【Vibe Poet】 · Creative Thinker
  AMLX · "Foggy thoughts, every word a breath."

  💪 Your Superpowers:
     · Dares to break frameworks, produces original ideas
     · Loves brainstorming strategy with AI

  ⚠️ Space to level up:
     · AI sometimes can't catch your real goal
     🎯 Template: Add "my ideal outcome is XX, which direction fits?"

  Real evidence (quoted from your history):
     · "Let's not use MBTI, let's create AIBTI ourselves"
     · "Personality judgments must follow AI masters' theories"

  A Abstract 64% | M Minimal 58% | L Collaborative 58% | X Explore 67%

  🎉 Badge unlocked: 🌙 Night Owl · 🤡 Anti-Blame Artist (Tier 4 · <1%)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 🧠 Theoretical Foundation

Every dimension is backed by actual AI masters and peer-reviewed papers:

| Axis | Meaning | Based On |
|---|---|---|
| **A/C** | Specificity (Abstract ↔ Concrete) | Anthropic《Be Clear & Direct》· OpenAI Strategy 1 · Karpathy "specificity compounds" |
| **M/V** | Context (Minimal ↔ Verbose) | Anthropic《Multishot》· OpenAI Strategy 2 · Brown et al. 2020《GPT-3 Few-Shot》 |
| **D/L** | Interaction (Directive ↔ Collaborative) | Karpathy "LLM is a collaborator" · Yao et al. 2022《ReAct》 |
| **X/E** | Decomposition (Explore ↔ Execute) | Wei et al. 2022《Chain-of-Thought》· Yao et al. 2023《Tree of Thoughts》· OpenAI Strategy 3 |

### 🎭 16 Personalities · 4 Tribes

| Tribe | Types |
|---|---|
| 🌫 **Mystic** | Ghost Boss · 3AM Philosopher · Zen Stakeholder · Vibe Poet |
| 📜 **Preacher** | Spec Tyrant · Pitch Deck Strategist · DDD Evangelist · Essay PM |
| 🎯 **Sniper** | Imperative Gunner · Bug Detective · Pair Programmer · SOS Signal |
| 🔨 **Craftsman** | Demanding Client · Tech Scout · Senior Mentor · Socratic Coder |

### 📦 Install (Claude Code Plugin)

```bash
# Clone to plugin directory
git clone https://github.com/leefufufufufu-rgb/aibti.git ~/.claude/plugins/aibti
```

Then in Claude Code, just say:

```
Analyze my AIBTI
```

Or use slash commands:

```
/aibti-scan          # Last 7 days
/aibti-scan 30       # Last 30 days
/aibti-today         # Today's snapshot
```

### 🔒 Privacy First

- **100% local** — no data leaves your machine
- **Auto-redaction** — emails, API keys, phone numbers auto-replaced with placeholders
- **Data sovereignty** — `~/.aibti/prompts.jsonl` stays on your disk, delete anytime
- **Zero telemetry** — no analytics, no tracking, no servers

### 🎁 30+ Hidden Easter Eggs

When your behavior hits extremes, AIBTI unlocks hidden badges — from common **"Night Owl"** to legendary **"Quantum Superposition"** (every dimension sitting at 48-52%, rarity < 0.1%). See [EASTER_EGGS.en.md](./EASTER_EGGS.en.md).

### 📖 Deep Dives

- 📚 **[THEORY.md](./THEORY.md)** — Full 2020-2026 theoretical foundation (bilingual)
- 🎭 **[PERSONA_CARDS.en.md](./PERSONA_CARDS.en.md)** — 16 positive persona cards with superpowers + growth areas
- 🎁 **[EASTER_EGGS.en.md](./EASTER_EGGS.en.md)** — Full badge codex (4 tiers, 30+ badges)

### 🚀 Roadmap

- [x] Claude Code Plugin (v0.1.0)
- [ ] Codex CLI adapter
- [ ] Cursor / Copilot Chat (VSCode extension)
- [ ] Shareable report cards (PNG export with auto-redaction)
- [ ] Monthly anonymous stats: "AIBTI distribution report"

### 🤝 Contributing

Welcome PRs! Especially:
- New personality types / naming suggestions
- More accurate judgment cases (see `tests/`)
- Visual / illustration remixes
- Translations (next: Japanese / Korean / Spanish)

### 📚 Credits

Standing on giants' shoulders:
- [Anthropic Prompt Engineering](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [OpenAI GPT Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)
- Andrej Karpathy · AI Engineer Summit talks
- Wei et al. 2022 · [Chain-of-Thought](https://arxiv.org/abs/2201.11903)
- Yao et al. 2022 · [ReAct](https://arxiv.org/abs/2210.03629)
- Yao et al. 2023 · [Tree of Thoughts](https://arxiv.org/abs/2305.10601)
- Brown et al. 2020 · [GPT-3 Few-Shot](https://arxiv.org/abs/2005.14165)

### 📄 License

MIT · *Not affiliated with MBTI®*

---

## 中文

> **第一个读你真实提示词的 AI 人格测试——不是问卷。**
>
> 基于 **Anthropic** / **OpenAI** / **Karpathy** / **CoT** / **ReAct** 理论设计。作为 **Claude Code 插件** 分发。

### ✨ 它做什么

```
> 分析我的 AIBTI

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AIBTI 本周人格报告 · 2026-W16
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  🔮 【碎碎念诗人】 · 创造型思考者
  AMLX · "想法朦胧，句句都是气口"

  💪 你的超能力:
     · 敢跳出既有框架，产生原创想法
     · 善于和 AI 在战略级问题上头脑风暴

  ⚠️ 可以升级的空间:
     · 开放讨论时 AI 偶尔抓不到你真正的目标
     🎯 改进模板: 末尾加 "我的理想结果是 XX，你判断哪个方向最匹配"

  真实佐证（你真说过的话）:
     · "可以不用 MBTI，我们自己创造一个 AIBTI 的概念"
     · "这些人格的判断要符合 AI 大神们的理论"

  A 抽象 64% | M 精简 58% | L 协作 58% | X 探索 67%

  🎉 解锁徽章: 🌙 深夜活跃者 · 🤡 反甩锅者 (Tier 4 · 稀有度 < 1%)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 🧠 理论根基（每一维都有大神背书）

| 维度 | 含义 | 理论依据 |
|---|---|---|
| **A/C** | 明确度（抽象 ↔ 具象） | Anthropic《Be Clear & Direct》· OpenAI Strategy 1 · Karpathy |
| **M/V** | 上下文（精简 ↔ 详尽） | Anthropic《Multishot》· OpenAI Strategy 2 · Brown 2020 |
| **D/L** | 交互（指令 ↔ 协作） | Karpathy "LLM 是协作者" · Yao 2022《ReAct》 |
| **X/E** | 分解（探索 ↔ 执行） | Wei 2022《Chain-of-Thought》· Yao 2023《Tree of Thoughts》· OpenAI Strategy 3 |

### 🎭 16 型 · 4 大阵营

| 阵营 | 人格 |
|---|---|
| 🌫 **玄学派** | 甩锅侠 · 凌晨哲学家 · 佛系甲方 · 碎碎念诗人 |
| 📜 **布道派** | PRD 暴君 · 战略 PPT 家 · 架构布道士 · 小作文 PM |
| 🎯 **狙击派** | 祈使句机枪手 · Bug 侦探 · 结对搭子 · 卡点求助侠 |
| 🔨 **工匠派** | 甲方爸爸 · 技术侦察兵 · 技术导师 · 苏格拉底码农 |

### 📦 安装（Claude Code 插件）

```bash
git clone https://github.com/leefufufufufu-rgb/aibti.git ~/.claude/plugins/aibti
```

然后在 Claude Code 里说：

```
分析我的 AIBTI
```

或者用斜杠命令：

```
/aibti-scan          # 最近 7 天
/aibti-scan 30       # 最近 30 天
/aibti-today         # 今日快照
```

### 🔒 隐私第一

- **100% 本地运行**——数据不离开你的电脑
- **自动脱敏**——邮箱、API Key、手机号自动替换占位符
- **数据主权**——`~/.aibti/prompts.jsonl` 随时可删
- **零遥测**——无任何数据上传

### 🎁 30+ 隐藏彩蛋

当你的行为数据触发极致条件时，AIBTI 会偷偷解锁隐藏徽章——从常见的「**深夜活跃者**」到传说级「**量子叠加态**」（四维度每项都在 48-52%，稀有度 < 0.1%）。详见 [EASTER_EGGS.md](./EASTER_EGGS.md)。

### 📖 深入阅读

- 📚 **[THEORY.md](./THEORY.md)** — 2020-2026 完整理论根基（双语）
- 🎭 **[PERSONA_CARDS.md](./PERSONA_CARDS.md)** — 16 型正向人格卡（超能力 + 进化空间）
- 🎁 **[EASTER_EGGS.md](./EASTER_EGGS.md)** — 完整彩蛋图鉴（4 阶，30+ 徽章）

### 🚀 路线图

- [x] Claude Code 插件（v0.1.0）
- [ ] Codex CLI 适配
- [ ] Cursor / Copilot Chat（VSCode 扩展）
- [ ] 可分享报告卡（PNG 导出 + 自动脱敏）
- [ ] 每月匿名统计「AIBTI 人格分布报告」

### 🤝 贡献

欢迎 PR！特别欢迎：
- 新人格类型 / 别称建议
- 更精准的判定用例（见 `tests/`）
- 视觉 / 插画 remix
- 多语言翻译（下一站：日语 / 韩语 / 西班牙语）

### 📚 致谢

站在巨人肩膀上：
- [Anthropic Prompt Engineering Overview](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [OpenAI GPT Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)
- Andrej Karpathy · AI Engineer Summit 演讲
- Wei et al. 2022 · [Chain-of-Thought](https://arxiv.org/abs/2201.11903)
- Yao et al. 2022 · [ReAct](https://arxiv.org/abs/2210.03629)
- Yao et al. 2023 · [Tree of Thoughts](https://arxiv.org/abs/2305.10601)
- Brown et al. 2020 · [GPT-3 Few-Shot](https://arxiv.org/abs/2005.14165)

### 📄 开源协议

MIT · *Not affiliated with MBTI®*

---

<div align="center">

**Made with ☕ and 3AM curiosity.**

[🌍 wengui.xyz/aibti](https://wengui.xyz/aibti) · [🖼 Portrait Gallery](https://wengui.xyz/aibti/portraits/) · [⭐ Star on GitHub](https://github.com/leefufufufufu-rgb/aibti)

</div>
