#!/usr/bin/env python3
"""AIBTI UserPromptSubmit hook
把每条用户提示词以标准 schema 写到 ~/.aibti/prompts.jsonl。
完全本地、零依赖、零上传。"""
import json, os, re, sys
from datetime import datetime, timezone
from pathlib import Path

AIBTI_DIR = Path.home() / ".aibti"
AIBTI_DIR.mkdir(exist_ok=True)
OUT = AIBTI_DIR / "prompts.jsonl"

def redact(text: str) -> str:
    """脱敏敏感信息"""
    # 邮箱
    text = re.sub(r'\b[\w.+-]+@[\w-]+\.[\w.-]+\b', '<EMAIL>', text)
    # OpenAI/Anthropic API key
    text = re.sub(r'\b(sk-[A-Za-z0-9]{20,}|ant-[A-Za-z0-9_-]{20,})\b', '<API_KEY>', text)
    # 手机号（中美）
    text = re.sub(r'\b(?:1[3-9]\d{9}|\+?1?\d{10})\b', '<PHONE>', text)
    return text

def main() -> None:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return  # 静默失败，不阻断用户

    text = (payload.get("prompt") or "").strip()
    if not text or len(text) < 2:
        return

    record = {
        "ts": datetime.now(timezone.utc).isoformat(),
        "src": "claude-code",
        "session_id": payload.get("session_id", ""),
        "cwd": payload.get("cwd", ""),
        "text": redact(text),
        "len_char": len(text),
    }

    try:
        with open(OUT, "a", encoding="utf-8") as f:
            f.write(json.dumps(record, ensure_ascii=False) + "\n")
    except Exception:
        pass  # 永远不阻断用户输入

if __name__ == "__main__":
    main()
