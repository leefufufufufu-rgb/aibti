#!/usr/bin/env bash
# AIBTI · Optional Hook Installer (ADVANCED)
#
# WARNING: This adds a Node.js script that runs ~100ms on EVERY prompt you send.
#          Most users DO NOT need this. The main Skill already reads your existing
#          ~/.claude/projects/ JSONL files and produces accurate reports.
#
# Only install this hook if you want:
#   · A unified prompt log across Claude Code / Cursor / Codex / Copilot
#   · Auto-redaction of API keys / emails / phones at write time
#
# To uninstall: remove the UserPromptSubmit block from ~/.claude/settings.json

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
RAW="https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
DATA_DIR="$HOME/.aibti"

echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  AIBTI Optional Hook · advanced users only${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${RED}⚠  This hook runs on EVERY prompt you send in Claude Code.${NC}"
echo -e "${RED}   Runtime: ~100ms per prompt (fast, but non-zero).${NC}"
echo ""
read -p "   Continue? [y/N]: " -r go < /dev/tty || go="n"
if [[ ! "$go" =~ ^[Yy]$ ]]; then
    echo "Cancelled. Main AIBTI Skill still works without this hook."
    exit 0
fi

mkdir -p "$DATA_DIR"
curl -sfL "$RAW/hooks/record.js" -o "$DATA_DIR/record.js"
echo -e "${GREEN}✓ Hook script installed at $DATA_DIR/record.js${NC}"
echo ""
echo -e "${YELLOW}Add this block to ~/.claude/settings.json (under 'hooks'):${NC}"
cat <<EOF
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [{"type":"command","command":"node $DATA_DIR/record.js","timeout":2}]
      }
    ]
EOF
echo ""
echo -e "${GREEN}Done. To uninstall: remove the block above and ${NC}rm $DATA_DIR/record.js"
