---
name: aibti
description: 用 LLM 语义理解分析本地 Claude Code / Cursor / Codex / Copilot 提示词历史，生成 AIBTI 人格报告。当用户说"分析我的 AIBTI"、"测一下我的提示词人格"、"扫描我的对话"、"我是哪一型"、"我的 AI 对话画像"时触发。
---

# AIBTI · 提示词人格分析（LLM 判定版）

把用户真实提示词行为映射到 16 型人格之一，输出带理论依据和真实样本佐证的诊断报告。

## 🚫 绝对禁令

1. **不要用正则/关键词硬匹配做四维判定**——规则派会把创造型用户误判为"甩锅侠"。用你的**语义理解**去判断，看每条 prompt 的**真实意图**。
2. **不要捏造数据**：每个数字、每条引用必须来自真实日志。
3. **不要无脑归类**：真人通常是"场景切换型"（日常指令 + 调研探索 + 创意讨论混合），要诚实展示多人格分布，不要硬给一个标签就结束。
4. **不要冤枉用户**：看到短句先想"是不是多轮对话里的接续"，再想"是不是在讨论/创造"，最后才考虑"是不是真的抽象指令"。
5. **样本不足时不要硬出结论**——直接提示用户继续积累（见下方"数据充足性规则"）。

## 📊 数据充足性规则（非常重要）

去重并剔除接续词/噪音后的**实质 prompt 数量**决定输出策略：

| 样本量 | 策略 | 输出 |
|---|---|---|
| **< 20 条** | 🚫 数据不足 | 不出人格判定。提示："样本太少（N 条），无法产生可信的 AIBTI 画像。建议再用 Claude Code 工作 3-7 天后再测。" |
| **20-49 条** | ⚠️ 低置信度 | 出轻量报告 + 醒目标注 "⚠️ 样本量偏少（N 条），结论仅供参考。建议积累至少 50 条后复测。" |
| **50-199 条** | ✅ 标准报告 | 正常出完整报告，但在脚注说明"样本中等（N 条），单个阵营内的偶发人格可能不稳定" |
| **≥ 200 条** | ✨ 高置信度 | 全功能报告，含人格进化轨迹（本周 vs 上月） |

**提示模板（< 20 条）**：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AIBTI 人格报告
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📭  样本不足

  扫描到 {N} 条实质提示词（剔除接续词和噪音后）。
  想让你不被冤枉，至少需要 20 条才能给出靠谱人格。

  建议：
  · 再用 Claude Code 正常工作 3-7 天
  · 然后重新 /aibti-scan 看结果

  你的数据来源：
  · ~/.claude/projects/  ({M} 个 session)
  · 接续词 {X} 条已剔除
  · 噪音 {Y} 条已过滤

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**判定依据（不是拍脑袋）**：
- **20 条下限**：统计学上 16 型分布至少要 16+4 条样本才能观察到非零占比
- **50 条门槛**：参考 MBTI 心理测量文献对"小样本人格测量"的信度建议
- **200 条高置信**：和 GitHub Stack Overflow Survey 个人画像样本量对齐

## 数据源（按优先级降序）

1. `~/.aibti/prompts.jsonl` — 统一格式（如果有）
2. `~/.claude/projects/**/*.jsonl` — Claude Code 原生（最常见）
3. `~/.codex/sessions/*.jsonl` — Codex CLI
4. Cursor 的 SQLite（需要 sqlite3）

## 步骤

### -1. 语言判定（最先做！决定整份报告语言）

**检测用户语言**：
- 看**本次请求** prompt：如果是中文 → `zh`
- 看**最近 7 天** prompt 语言比例：中文 > 50% → `zh`，否则 → `en`
- 看系统 locale：`echo $LANG`（`zh_CN` → zh，`en_US` → en）

**一旦确定，整份报告所有文字（终端 + HTML）都用这个语言**。不要混用。

### 0. 先拿本地时区（重要！所有时间判定都基于本地）

JSONL 里的 `timestamp` 都是 **UTC**（`.Z` 后缀）。用户在不同时区：
- 中国开发者：UTC+8，凌晨 02:00 对应 UTC 18:00（前一天）
- 美国东岸：UTC-5，凌晨 02:00 对应 UTC 07:00

**执行步骤前**，必须先用 Bash 拿本地时区 offset：

```bash
date +%z   # 输出 +0800 / -0500 / +0000 等
```

记住这个 offset，**后续所有"小时"判定都要先做时区转换**：
- `local_hour = (utc_hour + offset_hour + 24) % 24`
- 黄金时段、凌晨骑士团彩蛋、峰值时段、"late-night ratio" 统计都用 **本地小时**

如果用户对结果不满意（觉得时间段判错了），也让他检查本机 `date +%z` 是否正确。

### 1. 抽取 user 文本

只要**真实用户输入**：`type=user` 且 `message.role=user` 且 `message.content` 是字符串或含 `type:text` 的数组。

**必须过滤掉**：
- `<system-reminder>` / `<task-notification>` / `<local-command-*>` 等自动注入
- `<command-name>` / `<command-message>` / `<command-args>` 斜杠命令残留
- Hook 产生的 `additionalContext`、`hookSpecificOutput`
- `[Image #N]` 图片占位
- `[Request interrupted by user]` 系统事件
- 纯 JSON 响应粘贴（以 `{` 开头 + `"took":` 等特征）

### 2. 意图分类（关键！先分场景再判四维）

对每条 prompt，先归入一个**意图类型**：

| 类型 | 特征 | 示例 | 是否计入主人格判定 |
|---|---|---|---|
| **接续 (Continuation)** | 10 字内的 ACK：继续/修改/确认/好/嗯/对/ok/go | "继续"、"修好了吗" | ❌ 不计 |
| **讨论 (Discussion)** | 表达观点/情绪/疑问，不是要 AI 做事 | "我懂了，互联网就是互相借鉴" | ✅ 计，通常偏 L/X |
| **创造 (Creation)** | 提出新想法/方向/创意 | "不用 MBTI，我们造 AIBTI" | ✅ 计，通常偏 A/X |
| **战略 (Strategy)** | 给 AI 定方向/原则/约束 | "人格判断要符合 AI 大神理论" | ✅ 计，通常偏 A/L |
| **指令 (Directive)** | 明确让 AI 做某事 | "User.java:42 加 getter" | ✅ 计，通常偏 D/E |
| **调研 (Research)** | 贴长上下文问方案 | 附 3 段代码 + "有优化空间吗" | ✅ 计，通常偏 V/X |
| **求助 (SOS)** | 卡住了报错求救 | "这里报 NPE 咋办" | ✅ 计，通常偏 L |

### 3. 四维语义判定（看意图，不看关键词）

每条 prompt（排除接续类）判 4 个字母：

#### A/C — Specificity（明确度）
- **A 抽象**：概念层讨论，没指向具体代码位置或产物规格。讨论/创造/战略大多是 A
- **C 具象**：含具体文件/行号/函数/具体产物描述
- 👉 *依据：Anthropic《Be Clear & Direct》(foundational) · **Karpathy 2025.02《Vibe Coding》** · **Anthropic 2026.01《Claude 4.7 Skills System》** · 完整链见 [THEORY.md](../../THEORY.md)*

#### M/V — Context Provision（上下文丰度）
- **M 精简**：< 60 字，无代码块，用户假设 AI 能从对话记忆里拿上下文
- **V 详尽**：> 200 字 或含代码块 / 需求规格 / 多步骤说明
- 👉 *依据：Brown《Few-Shot Learners》(foundational) · **Liu 2023《Lost in the Middle》** · **Anthropic 2026.01《Claude 4.7 · 1M Context》***

#### D/L — Interaction Mode（交互模式）
- **D 指令**：祈使句让 AI 执行 + 不留商量余地
- **L 协作**：疑问句 / 征求意见 / 讨论语气 / 开放式 / "你觉得..."
- 👉 **关键**：讨论类、创造类、战略类大多数时候是 L（用户在和 AI 对话，不是单向命令）
- 👉 *依据：Yao《ReAct》(foundational) · **Anthropic 2025.10《Claude Skills System》** · **Anthropic 2025《MCP 2.0》***

#### X/E — Decomposition & Verification（探索 vs 执行）
- **X 探索**：问方案、比较选项、讨论可能性、提出疑问（"可行吗？"、"有没有更好的方式？"）
- **E 执行**：直接要结果，不探索选项
- 👉 **关键**：讨论类、创造类大部分是 X；纯指令类大部分是 E
- 👉 *依据：Wei《Chain-of-Thought》(foundational) · **DeepSeek 2025.01《R1》** · **Anthropic 2026《Extended Thinking v2》***

### 3.5 · Token 成本保护（重要！避免烧钱）

用户提示词数量越多 → Skill 处理上下文越长 → **消耗 token 越多**。必须有保护：

**采样策略（硬性规则）**：

| 实质 prompt 数 | 策略 | 预估消耗 |
|---|---|---|
| < 100 | 全量分析 | ~5K tokens |
| 100-500 | 全量分析 | ~20-80K tokens |
| 500-2000 | **时间分层采样 500 条** | ~40-60K tokens |
| 2000-5000 | **时间分层采样 800 条** | ~80-100K tokens |
| > 5000 | **时间分层采样 1000 条 + 警告** | ~120K tokens |

**时间分层采样方法**：
1. 把扫描期（如 30 天）均分成 N 段（比如 10 段，每段 3 天）
2. 每段按比例抽取（如 50 条），**保证时间分布代表性**
3. 每段内先优先抽取"非接续类"的实质 prompt

**执行前输出"成本预览"行**（必做）：

```
📊 扫描: 2847 条实质 prompt · 采样 500 条分析 · 预估 ~50K tokens (~$0.15 API 成本)
```

让用户**清楚知道成本**再继续。如果用户觉得贵，可以让他用 `/aibti-today` 只看当天（样本更小，成本 ~10K tokens）。

### 4. 聚合与主人格

- 统计每个 prompt 的 4 字母代码
- 主人格 = 出现频率最高的代码
- **重要**：如果前 2 名合计 < 50%，说明用户是**场景切换型**，不要强行给一个人格，要同时展示"双核人格"或"主 + 副 + 偶发"
- 提取每个维度的占比（A% / C%）用于 bar 显示
- 标注意图类型分布（讨论 X% / 创造 X% / 指令 X%...）

### 5. 真实 prompt 样本佐证（必做）

每个主要人格挑 3-5 条用户**真实说过**的话作为证据。让用户自己看"这些是我说的，判定合理"。

## 16 型速查表

| Code | Emoji | 中文名 | 英文名 | 一句话 |
|---|---|---|---|---|
| AMDE | 🤲 | 甩锅侠 | The Ghost Boss | "搞定它，别问我怎么搞" |
| AMDX | 🌙 | 凌晨哲学家 | 3AM Philosopher | "三点钟灵魂拷问 AI" |
| AMLE | 🧘 | 佛系甲方 | Zen Stakeholder | "你看着办" |
| AMLX | 🔮 | 碎碎念诗人 | Vibe Poet | "有没有更优雅的方式" |
| AVDE | 👑 | PRD 暴君 | The Spec Tyrant | "三页文档，配一句'做'" |
| AVDX | 🎤 | 战略 PPT 家 | Pitch Deck Strategist | "铺完上下文再发问" |
| AVLE | ⛪ | 架构布道士 | DDD Evangelist | "讲完概念，一起干" |
| AVLX | 📝 | 小作文 PM | The Essay PM | "小作文 + 三选一" |
| CMDE | 🔫 | 祈使句机枪手 | Imperative Gunner | "精准定位，精准开火" |
| CMDX | 🔍 | Bug 侦探 | The Bug Detective | "拿证据问案情" |
| CMLE | 🤝 | 结对搭子 | Pair Programmer | "边写边聊" |
| CMLX | 🆘 | 卡点求助侠 | SOS Signal | "卡哪问哪" |
| CVDE | 💼 | 甲方爸爸 | The Demanding Client | "完整需求 + '做完给我'" |
| CVDX | 🛰️ | 技术侦察兵 | The Tech Scout | "讲清战场问最优解" |
| CVLE | 🎓 | 技术导师 | The Senior Mentor | "陪你一步步来" |
| CVLX | 🏛️ | 苏格拉底码农 | The Socratic Coder | "为啥不用 X？那 Y 呢？" |

## 报告输出模板

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AIBTI 人格报告  {最近 N 天}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  扫描:    {M} 个 session · 去重后 {N} 条提示词
  过滤:    接续词 {X} 条 · 噪音 {Y} 条

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  主人格
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {emoji}  【{中文名}】  {CODE}
  "{slogan}"

  > 真实样本：
    · "{真实 prompt 1}"
    · "{真实 prompt 2}"
    · "{真实 prompt 3}"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  四维占比（基于大神理论）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  A 抽象  {%} ▓▓▓▓▓▓░░░░ C 具象  {%}   — Karpathy "specificity compounds"
  M 精简  {%} ▓▓▓▓▓▓░░░░ V 详尽  {%}   — Anthropic《Multishot》
  D 指令  {%} ▓▓▓▓▓▓░░░░ L 协作  {%}   — Karpathy "LLM is collaborator"
  X 探索  {%} ▓▓▓▓▓▓░░░░ E 执行  {%}   — Wei 2022《CoT》

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  意图分布（你都在做什么）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  讨论  {%}  · 创造  {%}  · 战略  {%}
  指令  {%}  · 调研  {%}  · 求助  {%}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  16 型分布（TOP 5）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {emoji} {CODE} {name}    {count}  {%}  ← 主人格
  {emoji} {CODE} {name}    {count}  {%}
  ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  诊断（每条挂理论）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. {诊断文案}
     证据: "{真实 prompt 摘录}"
     依据: {Anthropic/OpenAI/Karpathy/论文}
  2. ...
  3. ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  针对你的改进模板
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  基于主人格 {CODE} 的盲区，下周试试：
  · 模板 1（加上目标描述）
  · 模板 2（补充上下文）
  · 模板 3（写 PLAN 再执行）
```

## 诊断规则（挂理论）

| 阈值 | 诊断 | 理论依据 |
|---|---|---|
| A > 65% | 提示词偏抽象，AI 反复追问 | Anthropic《Be Clear & Direct》· Karpathy "specificity compounds" |
| M 中位数 < 30 字 | 极简到吝啬，上下文缺失 | Anthropic《Multishot》· Brown 2020 |
| D > 75% | 协作度低，可能错失 AI 建议 | Karpathy "LLM is collaborator, not oracle" |
| 缺文件路径 > 50% | AI 定位不到目标 | OpenAI Strategy 1 "Include details" |
| 3+ 轮放弃 > 30% | 长对话崩塌率高，该先写 PLAN | Wei 2022《CoT》· OpenAI Strategy 3 |
| 凌晨占比 > 30% | 深夜决策，审慎 | 行为数据，非理论 |

## 🎁 彩蛋检测（Optional Layer · 报告末尾追加）

参考项目根目录 `EASTER_EGGS.md` 查全量徽章清单。每次生成报告前，按 Tier 1→4 顺序检查所有命中条件。

### 检测顺序
1. **Tier 1 · 维度极致**（8 个）：任一维度 ≥ 95%
2. **Tier 2 · 主人格 S 级**：主人格占比 ≥ 70%
3. **Tier 3 · 场景成就**：时间/量/轮次组合（见图鉴）
4. **Tier 4 · 传说级**：稀有组合

### 呈现约束
- **最多展示 3 个徽章**（过多稀释惊喜）
- Tier 4 > Tier 2 > Tier 1 > Tier 3（优先级）
- 首次解锁的徽章加"⭐ 首次解锁"标记
- **永远放在报告末尾**，不要开头剧透
- 如果没有任何徽章命中，不要显示"解锁徽章"区块（避免空响应）

### 追加区块模板

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎉 解锁隐藏徽章
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {emoji}  【{徽章名}】{稀有度标记}
  "{解锁文案}"
  {首次解锁 → "⭐ 首次解锁" / 否则留空}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🎨 Step 7 · 生成可视化 HTML 报告 + 自动打开（v0.3.0 叙事版）

每次生成终端报告后，**额外生成一份叙事型 HTML 报告**到 `~/.aibti/report.html`（覆盖上次），并**自动用系统默认浏览器打开**。

### 步骤

1. 检查 `~/.aibti/report-template.html` 存在（不在提示用户 `curl ... install.sh | bash`）
2. 检查 `~/.aibti/portraits/` 有 16 个 SVG
3. **检测用户语言**：根据用户的 prompt 和历史主要语言判断 `zh` 或 `en`
4. **决定叙事 tone**（重要 — 让 Claude 自主选）：读完用户真实 prompt 样本后，挑一个最匹配的基调：
   - **吐槽型**：如果用户 prompt 里有自嘲、笑点、轻松气息
   - **文艺型**：如果用户 prompt 里有感性、哲思、朦胧表达
   - **哲学型**：如果用户 prompt 有战略/元问题倾向
   - **朋友聊天型**：如果用户 prompt 直接、日常、平实
   - 不要套路化——**读他的 prompt 再决定怎么说话**
5. 读取模板内容
6. **按占位符表替换**（i18n + 叙事）
7. 用 `Write` 工具写入 `~/.aibti/report.html`
8. **必须执行 Bash 自动打开**：
   ```bash
   # macOS
   open ~/.aibti/report.html
   # Linux
   xdg-open ~/.aibti/report.html 2>/dev/null &
   # Windows
   start "" "%USERPROFILE%\.aibti\report.html"
   ```
   用 `uname` 判断系统后执行对应命令，**不要只给提示文字**。

### 占位符替换表（v0.3.0 · 严格按此填）

#### i18n 静态文本占位符（根据 LANG 填对应语言）

| 占位符 | 中文 | English |
|---|---|---|
| `{{T_LEGENDARY}}` | 传说解锁 | LEGENDARY UNLOCKED |
| `{{T_S_TIER}}` | S 级 | S-TIER |
| `{{T_OPENING}}` | 本周故事 | THIS WEEK'S STORY |
| `{{T_ONE_PROMPT}}` | 最能代表你的那句话 | THE ONE PROMPT |
| `{{T_FOUR_DIMENSIONS}}` | 四维画像 | FOUR DIMENSIONS |
| `{{T_ABSTRACT}}` | 抽象 | Abstract |
| `{{T_CONCRETE}}` | 具象 | Concrete |
| `{{T_MINIMAL}}` | 精简 | Minimal |
| `{{T_VERBOSE}}` | 详尽 | Verbose |
| `{{T_DIRECTIVE}}` | 指令 | Directive |
| `{{T_COLLAB}}` | 协作 | Collaborative |
| `{{T_EXPLORE}}` | 探索 | Explore |
| `{{T_EXECUTE}}` | 执行 | Execute |
| `{{T_PROMPTS}}` | 总 PROMPT | PROMPTS |
| `{{T_PEAK_HOUR}}` | 黄金时段 | PEAK HOUR |
| `{{T_MEDIAN}}` | 长度中位数 | MEDIAN LEN |
| `{{T_NIGHT_RATIO}}` | 凌晨占比 | NIGHT RATIO |
| `{{T_LONGEST}}` | 最长一轮 | LONGEST THREAD |
| `{{T_RANK_TITLE}}` | 16 型 TOP 6 | 16 TYPES · TOP 6 |
| `{{T_BADGES_TITLE}}` | 解锁徽章 | UNLOCKED BADGES |
| `{{T_LETTER_TITLE}}` | AI 写给你的一封信 | A LETTER TO YOU |
| `{{T_FROM_AI}}` | 来自 AI · {{REPORT_DATE}} | FROM AI · {{REPORT_DATE}} |
| `{{T_LOCAL_ONLY}}` | 100% 本地 · 零上传 | 100% local · zero telemetry |
| `{{T_WEBSITE}}` | 官网 | Website |
| `{{T_PRIVACY}}` | 隐私 | Privacy |
| `{{T_FOOTER_NOTE}}` | 这份报告是你的。没人能看到。随时删：<code>rm ~/.aibti/report.html</code> | This report is yours. No one else sees it. Delete anytime: <code>rm ~/.aibti/report.html</code> |
| `{{T_MULTICORE}}` | 你是多核选手 | MULTI-CORE PERSONA |
| `{{T_PRINT}}` | 打印 / 导出 PDF | Print / Export PDF |
| `{{T_COPY_LINK}}` | 复制链接 | Copy link |
| `{{T_STAR_GITHUB}}` | Star on GitHub | Star on GitHub |
| `{{T_FEEDBACK}}` | 反馈 | Feedback |

#### 数据占位符

| 占位符 | 内容来源 |
|---|---|
| `{{LANG}}` | `zh-CN` 或 `en` |
| `{{REPORT_DATE}}` | 生成时间 ISO（如 `2026-04-20 23:45`） |
| `{{SAMPLE_COUNT}}` | 实质 prompt 数 |
| `{{DAYS}}` | 扫描天数 |
| `{{CONFIDENCE}}` | 置信度文本（High / Standard / Low / Insufficient） |
| `{{GROUP_COLOR}}` | 主阵营色：Mystic=#a855f7 / Preacher=#fbbf24 / Sniper=#00ff88 / Craftsman=#60a5fa |
| `{{MAIN_CODE}}` | 主人格 4 字母（如 `AMLX`） |
| `{{MAIN_CODE_LOWER}}` | 小写（如 `amlx`，用于 SVG 文件名） |
| `{{MAIN_EMOJI}}` | 🔮 |
| `{{TRIBE_NAME}}` | Mystic / Preacher / Sniper / Craftsman |
| `{{MAIN_NAME_ZH}}` | 中二名（如 `碎碎念诗人`） |
| `{{MAIN_NAME_POSITIVE}}` | 正向标签（见 PERSONA_CARDS.md，如 `创造型思考者`） |
| `{{MAIN_SLOGAN}}` | slogan 一句 |
| `{{SUPERPOWERS_LIST}}` | `<li>超能力 1</li><li>超能力 2</li>` 至少 2 条 |
| `{{DARK_SIDE}}` | 一句暗面 |
| `{{TEMPLATE_BEFORE}}` | 改进前的典型 prompt |
| `{{TEMPLATE_AFTER}}` | 改进后模板 |
| `{{DIM_A_PCT}}` 等 8 个 | 四维百分比数字（不含 %） |
| `{{DIM_AC_THEORY}}` 等 4 个 | 对应理论引用（从 THEORY.md 挑 1 条简短） |
| `{{INTENT_CARDS}}` | 每个意图 `<div class="intent-card"><div class="intent-name">指令</div><div class="intent-pct">{{N}}%</div><div class="intent-mini-bar"><div class="intent-mini-fill" style="width:{{N}}%"></div></div></div>` |
| `{{TOP6_ROWS}}` | 6 行 `<div class="top-row {{'main' if top1}}"><div class="top-emoji"><img src="portraits/{{code_lower}}.svg"></div><div class="top-code">CODE</div><div class="top-name">中文名</div><div class="top-bar-wrap"><div class="top-bar" style="width:{{pct*2}}%"></div></div><div class="top-pct">N%</div></div>` |
| `{{EVIDENCE_CARDS}}` | 3-5 张 `<div class="evidence-card"><div class="evidence-text">真实 prompt</div><div class="evidence-meta">YYYY-MM-DD · project</div></div>` |
| `{{DIAG_CARDS}}` | 诊断卡 `<div class="diag-card"><div class="diag-lead">主要问题</div><div class="diag-evidence">证据引用</div><div class="diag-theory">依据: 大神理论</div></div>` |
| `{{BADGES_DISPLAY}}` | 有彩蛋 `block`，无则 `none` |
| `{{BADGE_CARDS}}` | 每个徽章 `<div class="badge-card tier-N"><div class="badge-icon">🌙</div><div class="badge-name">徽章名</div><div class="badge-desc">解锁文案</div><span class="badge-rare">TIER N</span></div>` — **class 必须带对应 tier-1/2/3/4** |
| `{{LEGENDARY_DISPLAY}}` | 命中任何 Tier 4 彩蛋 → `flex`；否则 `none` |
| `{{LEGENDARY_NAME}}` | Tier 4 徽章名（如"反甩锅者"） |
| `{{LEGENDARY_DESC}}` | Tier 4 解锁文案 |
| `{{LEGENDARY_RARITY}}` | 稀有度数字（如 `1` 代表 <1%） |
| `{{S_TIER_DISPLAY}}` | 主人格占比 ≥ 70% → `block`；否则 `none` |
| `{{S_TIER_LABEL}}` | S 级称号（查 EASTER_EGGS.md Tier 2，如 `赛博诗社社长`） |
| `{{SECONDARY_DISPLAY}}` | 有副人格 `block`，无则 `none` |
| `{{SECONDARY_*}}` | 副人格对应字段 |
| `{{PEAK_HOUR}}` / `{{MEDIAN_LEN}}` / 等 | 行为统计 |

#### 叙事内容占位符（v0.3.0 新增 · 核心灵魂）

| 占位符 | 要求 |
|---|---|
| `{{OPENING_HEADLINE}}` | 一行 20-40 字，用真实数据讲故事。例："你凌晨和 AI 对话了 8 次，每次都问同一个问题" |
| `{{OPENING_STORY_HTML}}` | 3-4 段 `<p>` 标签，每段 2-3 句。用真实数字、真实项目名、真实 prompt 编成微型叙事。**风格由你根据用户 prompt 决定**（吐槽/文艺/哲学/朋友） |
| `{{ONE_PROMPT_TEXT}}` | **挑 1 条最代表用户的真实 prompt**，原文引用（脱敏后） |
| `{{ONE_PROMPT_META}}` | 时间 + 项目 · 例："2026-04-18 03:12 · demand-center" |
| `{{ONE_PROMPT_PUNCHLINE}}` | 一句锋利的评论（基于你自主选的 tone） |
| `{{DIM_AC_PUNCHLINE}}` | 每维一句 punchline，不只是数字解读 |
| `{{DIM_MV_PUNCHLINE}}` / `{{DIM_DL_PUNCHLINE}}` / `{{DIM_XE_PUNCHLINE}}` | 同上 |
| `{{LETTER_SALUTATION}}` | "亲爱的 {{MAIN_NAME}}：" 或 "Dear {{MAIN_NAME}}," |
| `{{LETTER_BODY_HTML}}` | 4-6 段 `<p>`，200-300 字。AI 给用户写的一封信——基于真实数据 + 人格特征 + 成长建议。**要有情感**，不要流水账 |
| `{{LETTER_SIGNATURE}}` | "— Claude · 2026-04-20" 或类似 |

### 关键原则（叙事部分）

1. **每段都用真实数据或真实 prompt 支撑**，不捏造
2. **风格由你读完样本后自主决定**，不要每份报告都像同一个模板
3. **Growth Letter 是灵魂**——用户读完会有"这 AI 懂我"的触感
4. **Punchline 要锋利**，像 The Atlantic 或 The New Yorker 那种一句话概括
5. **中文用户出中文**，英文用户出英文，不要混

### 🚨 硬性规则（v0.3.1 必遵守）

1. **百分比必须整数**：`style="width:54%"` 而非 `width:54.599999999999994%`
2. **徽章必须用 SVG**，**禁止 emoji**：
   ```html
   <!-- ✗ 错 -->
   <div style="font-size:32px">🧵</div>
   <!-- ✓ 对 -->
   <svg class="badge-svg"><use href="#i-flame"/></svg>
   ```
   可用的 SVG symbol（已内联在模板）：`#i-sparkle` `#i-star` `#i-alert` `#i-target` `#i-quote` `#i-letter` `#i-book` `#i-trending` `#i-moon` `#i-flame` `#i-crown` `#i-scroll`
3. **16 型 TOP 6 的 rank-name 禁止 emoji**（左侧已有 portrait SVG）：
   ```html
   <!-- ✗ 错 --> <div class="rank-name">🔍 Bug 侦探</div>
   <!-- ✓ 对 --> <div class="rank-name">Bug 侦探</div>
   ```
4. **The One Prompt 的 meta 必须有真实日期**，找不到具体日期就挑另一条 prompt，禁止 "2026-04-XX"
5. **多核展示规则**（v0.3.1 新增）：
   - 主人格占比 < 30% → `{{MULTICORE_DISPLAY}}` 设为 `block`，必须展示
   - 主人格占比 ≥ 30% → 设为 `none`
   - 多核卡 `{{MULTICORE_CARDS}}` 展示前 3 名：
     ```html
     <div class="core-card">
       <img src="portraits/{{code_lower}}.svg" alt="{{name}}">
       <div>
         <div class="core-code">{{CODE}}</div>
         <div class="core-name">{{中文名}}</div>
         <div class="core-pct">{{整数}}%</div>
       </div>
     </div>
     ```
   - `{{MULTICORE_HEADLINE}}` 示例："你是三核选手 · 前三加起来才 47%"
   - `{{MULTICORE_CAPTION}}`：一句话解读为什么多核是人格特征
6. **不要假装 100% 确定单人格**。如果样本显示场景切换，就诚实展示

### 硬约束

- HTML 必须是**完整自包含**的（模板已内联 CSS，占位符填完即可用）
- 所有数字必须来自真实样本，禁止编造
- SVG 路径用 **相对路径** `portraits/{{code_lower}}.svg`（报告 html 和 portraits/ 同在 ~/.aibti/ 下）
- 如果 `~/.aibti/portraits/` 缺失，HTML 里 `<img>` 会 broken，但整体报告仍能看 — 提示用户重装

## 隐私保护

- 引用的真实 prompt 如果含邮箱/密钥/手机号/生产数据库密码 → 自动替换为 `<REDACTED>`
- 报告只在本地显示，不上传
- 项目路径如果敏感（含客户名、业务线名）可选脱敏为 `<PROJECT-A>`

## 语言匹配

用户用中文问就出中文报告，英文问就出英文报告。

## 🌟 正向化语气规则（UX 评审强制项）

参考项目根目录 `PERSONA_CARDS.md` —— 16 型每型除中二名外都有**正向标签 / 超能力(2) / 暗面(1) / 改进模板 / 理论**。

严格遵守：
1. **比例 2:1**：超能力 ≥ 2 条，暗面 ≤ 1 条
2. **主人格双重呈现**：中二名（好玩）+ 正向标签（尊重）同时展示
3. **先肯定再建议**：改进模板前必须先说用户已经做对的事
4. **禁用词**：失败 / 错误 / 不够 / 缺乏 / 毛病 / 你总是... / 你太...
5. **推荐词**：超能力 / 风格 / 偏好 / 空间 / 升级 / 进化

### 主人格展示必须用这个模板

```
  你这周是：{emoji} 【{中二名}】 · {正向标签}
            {CODE} · "{slogan}"

  💪 你的超能力:
     · {超能力 1}
     · {超能力 2}

  ⚠️ 可以升级的空间:
     · {暗面 1}
     🎯 改进模板: "{positive-prompt-rewrite}"
```

永远不把暗面放在超能力之前。

## 最重要的心法

> **"规则派冤枉过人，LLM 派不该再犯。"**
>
> 看每条 prompt 的时候，问自己三个问题：
> 1. 这是在**和 AI 对话**，还是**让 AI 做事**？（决定 D/L）
> 2. 这是在**想清楚**，还是**快一点**？（决定 X/E）
> 3. 用户的**真实意图**是什么？（决定意图分类）
>
> 想清楚再打标签，不要看见短句就 M、看见祈使句就 D。
