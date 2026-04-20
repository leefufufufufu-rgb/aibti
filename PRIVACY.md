<div align="center">

# AIBTI · Privacy Policy

**The shortest privacy policy you've ever read.**

**[English](#english)** · **[中文](#中文)**

</div>

---

## English

### TL;DR

AIBTI runs **100% locally on your machine**. Your prompts, your conversations, your files — **none of them ever touch a network**. There is no server. There is no account. There is no "cloud sync". The entire codebase is MIT-licensed and fits in about 50 files you can read in under an hour.

If you don't trust this README, **trust the code instead** — all 50 files are on GitHub.

### Execution Model (most important)

AIBTI is **100% passive by default**. It has no background process, no daemon, no watcher, no hook (unless you explicitly opt in via the separate advanced installer).

```
Life cycle of an AIBTI scan:
  1. You type: "Analyze my AIBTI"   ← YOU initiate, always.
  2. Claude reads existing ~/.claude/projects/*.jsonl (files that already exist).
  3. Claude produces a report. Writes ~/.aibti/report.html.
  4. AIBTI goes back to sleep. Nothing is watching you.

When you're NOT asking:
  · Zero code runs.
  · Zero files are read.
  · Zero network calls.
  · Your normal Claude Code workflow is 100% unchanged.
```

**This is the opposite of productivity tools that "learn in the background."** AIBTI is a mirror you pick up when you want to look, and put down when you're done.

---

### What AIBTI Reads

AIBTI analyzes **one** thing: files that **already exist on your disk** — specifically, the conversation history that Claude Code / Cursor / Codex / Copilot Chat already save locally when you use them.

| Tool | Path it reads |
|---|---|
| Claude Code | `~/.claude/projects/**/*.jsonl` |
| Codex CLI | `~/.codex/sessions/*.jsonl` |
| Cursor | `~/Library/Application Support/Cursor/.../*.db` (read-only) |
| Copilot Chat | `~/Library/.../Code/User/globalStorage/github.copilot-chat/` |

AIBTI **never creates network traffic** to read these. They're already on your disk.

### What AIBTI Writes

Exactly **one file**: `~/.aibti/prompts.jsonl` — your standardized prompt history in a simple JSONL format. You can:

```bash
cat ~/.aibti/prompts.jsonl      # read it yourself
rm ~/.aibti/prompts.jsonl       # delete it anytime
```

This file contains:
- A timestamp
- Your prompt text (with emails / API keys / phone numbers **auto-redacted** before writing)
- The source tool (`claude-code` / `codex` / …)
- The working directory path

**That's it.** No model outputs, no tool calls, no file contents. Just what you typed.

### What AIBTI Never Does

- ❌ Send any data to any remote server. Ever.
- ❌ Phone home for updates, analytics, or "usage metrics".
- ❌ Ask for an email address, API key, or account.
- ❌ Read files outside `~/.claude/` / `~/.codex/` / `~/.cursor/` / `~/.aibti/`.
- ❌ Include any third-party SDK (no Sentry, no Segment, no Google Analytics).
- ❌ Execute any obfuscated code. Every file is plain text and reviewable.

### Verify It Yourself

Run this script included in the repo:

```bash
./scripts/check-network.sh
```

It uses `lsof` / `netstat` to monitor AIBTI's commands in real-time and proves **zero outbound connections** are opened.

You can also audit the entire source tree:

```bash
grep -rE '(fetch|http|curl|wget|xmlhttp|axios|requests)' . \
  --include="*.py" --include="*.js" --include="*.ts" \
  --exclude-dir=node_modules
```

The only match you'll find is in this very document.

### The LLM Call (there is exactly one)

AIBTI's `/aibti` Skill runs inside **Claude Code** — it asks Claude itself (your already-authenticated session) to semantically classify your prompts. This **is** a network call — but it's Claude Code's normal call that happens whether you use AIBTI or not. AIBTI **does not add any new endpoint**, does not use a separate API key, does not bypass your existing configuration.

If you don't want Claude to see your prompts at all, you can run the offline rule-based analyzer instead (`python3 scripts/analyze.py`), which uses zero API.

### Sensitive Data Redaction

Before any prompt text is written to `~/.aibti/prompts.jsonl`, AIBTI runs these regex redactions (see `hooks/record.py`):

| Pattern | Replaced with |
|---|---|
| Emails (`name@domain`) | `<EMAIL>` |
| OpenAI keys (`sk-…`) | `<API_KEY>` |
| Anthropic keys (`ant-…`) | `<API_KEY>` |
| Phone numbers (CN/US) | `<PHONE>` |

You can extend this list by editing `hooks/record.py` — it's 50 lines of pure Python, no dependencies.

### Contact

If you find any privacy issue, open an issue at https://github.com/leefufufufufu-rgb/aibti/issues — or just delete `~/.aibti/` and walk away. That's the whole story.

---

## 中文

### 一句话总结

AIBTI **100% 在你本地运行**。你的 prompt、你的对话、你的文件——**完全不经过网络**。没有服务器。没有账号。没有"云同步"。整个代码库 MIT 开源，大约 50 个文件，1 小时能读完。

不信 README？**去读代码**——50 个文件全都在 GitHub。

---

### AIBTI 读什么

AIBTI 只分析**一件事**：你硬盘上**已经存在**的文件——具体来说是 Claude Code / Cursor / Codex / Copilot Chat 在你用它们时**本来就在本地保存**的对话历史。

| 工具 | AIBTI 读取的路径 |
|---|---|
| Claude Code | `~/.claude/projects/**/*.jsonl` |
| Codex CLI | `~/.codex/sessions/*.jsonl` |
| Cursor | `~/Library/Application Support/Cursor/.../*.db`（只读） |
| Copilot Chat | `~/Library/.../Code/User/globalStorage/github.copilot-chat/` |

AIBTI **读取这些文件完全不产生网络流量**——它们本来就在你的硬盘上。

### AIBTI 写什么

只写**一个文件**：`~/.aibti/prompts.jsonl`——你的标准化 prompt 历史，JSONL 格式，你可以：

```bash
cat ~/.aibti/prompts.jsonl      # 自己看
rm ~/.aibti/prompts.jsonl       # 随时删
```

这个文件包含：
- 时间戳
- 你的 prompt 文本（邮箱/API Key/手机号已**自动脱敏**）
- 来源工具（`claude-code` / `codex` / …）
- 工作目录路径

**就这些。**不包含模型输出，不包含工具调用，不包含文件内容。只有你打的字。

### AIBTI 从不做的事

- ❌ 把任何数据发送到任何远程服务器。**永远不会**。
- ❌ "回家报告"任何更新、分析、"使用指标"。
- ❌ 索要邮箱地址、API Key、账号。
- ❌ 读取 `~/.claude/` / `~/.codex/` / `~/.cursor/` / `~/.aibti/` 以外的文件。
- ❌ 引入任何第三方 SDK（没有 Sentry，没有 Segment，没有 Google Analytics）。
- ❌ 执行任何混淆代码。每个文件都是纯文本、可审计。

### 自己验证

跑仓库里的这个脚本：

```bash
./scripts/check-network.sh
```

它用 `lsof` / `netstat` 实时监控 AIBTI 的所有命令，证明**零对外连接**。

也可以审计整个源码树：

```bash
grep -rE '(fetch|http|curl|wget|xmlhttp|axios|requests)' . \
  --include="*.py" --include="*.js" --include="*.ts" \
  --exclude-dir=node_modules
```

唯一匹配的位置是本文档。

### 唯一的 LLM 调用（有且仅有一个）

AIBTI 的 `/aibti` Skill 在 **Claude Code 内部**运行——它让 Claude 自己（你已经认证过的 session）语义分类你的 prompt。这**确实**是网络调用——但这是 Claude Code 原本就在做的调用，无论你用不用 AIBTI 都会发生。AIBTI **不增加任何新 endpoint**、不用独立 API Key、不绕过你的现有配置。

如果你完全不想让 Claude 看你的 prompt，可以跑离线规则版分析器（`python3 scripts/analyze.py`），零 API 调用。

### 敏感数据脱敏

在任何 prompt 文本写入 `~/.aibti/prompts.jsonl` 之前，AIBTI 跑这些正则脱敏（见 `hooks/record.py`）：

| 模式 | 替换为 |
|---|---|
| 邮箱 (`name@domain`) | `<EMAIL>` |
| OpenAI Key (`sk-…`) | `<API_KEY>` |
| Anthropic Key (`ant-…`) | `<API_KEY>` |
| 手机号（中/美） | `<PHONE>` |

这个列表你可以编辑 `hooks/record.py` 自行扩展——50 行纯 Python，零依赖。

### 联系

发现任何隐私问题，在 https://github.com/leefufufufufu-rgb/aibti/issues 提 issue——或者直接删 `~/.aibti/` 走人。就这么简单。

---

<div align="center">

**AIBTI · Privacy Policy · v1.0** · [⬅ README](./README.md)

*If your privacy is your skin, AIBTI doesn't even touch it.*

</div>
