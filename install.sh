#!/usr/bin/env bash
# AIBTI · One-line installer (v0.2.x)
# Usage: curl -sL https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main/install.sh | bash
#
# What it does:
#   1. Downloads the AIBTI Skill to ~/.claude/skills/aibti/
#   2. Downloads report template + 16 portrait SVGs to ~/.aibti/
#   3. (Optional) Installs the Node.js hook for future prompts
#
# Zero new runtime dependencies — Claude Code already ships Node.js.

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
RAW="https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
SKILL_DIR="$HOME/.claude/skills/aibti"
DATA_DIR="$HOME/.aibti"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  AIBTI Installer${NC} · Your AI Conversation Personality"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ ! -d "$HOME/.claude" ]; then
    echo -e "${YELLOW}⚠  ~/.claude not found. Install Claude Code first: https://docs.claude.com/claude-code${NC}"
    exit 1
fi

# 1. Skill
echo -e "${YELLOW}[1/3] Installing Skill to ${SKILL_DIR}...${NC}"
mkdir -p "$SKILL_DIR"
curl -sfL "$RAW/skills/aibti/SKILL.md" -o "$SKILL_DIR/SKILL.md"
echo -e "${GREEN}  ✓ Skill installed${NC}"

# 2. Report template + 16 portrait SVGs
echo -e "${YELLOW}[2/3] Installing report assets to ${DATA_DIR}...${NC}"
mkdir -p "$DATA_DIR/portraits"
chmod 700 "$DATA_DIR" 2>/dev/null || true

curl -sfL "$RAW/report-template.html" -o "$DATA_DIR/report-template.html"
echo -e "${GREEN}  ✓ Report template${NC}"

PORTRAITS=(amde amdx amle amlx avde avdx avle avlx cmde cmdx cmle cmlx cvde cvdx cvle cvlx)
for code in "${PORTRAITS[@]}"; do
    curl -sfL "$RAW/portraits/${code}.svg" -o "$DATA_DIR/portraits/${code}.svg"
    printf "."
done
echo -e "\n${GREEN}  ✓ 16 portrait SVGs installed${NC}"

# 3. Optional hook (Node.js — already shipped with Claude Code)
echo ""
echo -e "${YELLOW}[3/3] Optional — install Node.js hook to record future prompts?${NC}"
echo "   Without it: AIBTI still works (reads existing ~/.claude/projects/)."
echo "   With it:    Future prompts unified to ~/.aibti/prompts.jsonl (with redaction)."
echo ""
read -p "   Install hook? [y/N]: " -r install_hook < /dev/tty || install_hook="n"

if [[ "$install_hook" =~ ^[Yy]$ ]]; then
    curl -sfL "$RAW/hooks/record.js" -o "$DATA_DIR/record.js"
    echo -e "${GREEN}  ✓ Hook script installed at $DATA_DIR/record.js${NC}"
    echo ""
    echo -e "${YELLOW}  Add this to ~/.claude/settings.json (under 'hooks'):${NC}"
    cat <<EOF
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [{"type":"command","command":"node $DATA_DIR/record.js","timeout":2}]
      }
    ]
EOF
else
    echo -e "${BLUE}  (skipped — re-run this installer anytime)${NC}"
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ AIBTI installed.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}Next:${NC} Open Claude Code, say:"
echo -e "   ${GREEN}Analyze my AIBTI${NC}   or   ${GREEN}测一下我的 AIBTI${NC}"
echo ""
echo -e "${BLUE}You'll get:${NC}"
echo "   · A rich terminal report"
echo "   · A beautiful HTML report at ${GREEN}~/.aibti/report.html${NC} (open it in any browser)"
echo ""
echo -e "${BLUE}Privacy:${NC} 100% local — see $RAW/PRIVACY.md"
echo -e "${BLUE}Uninstall:${NC} rm -rf $SKILL_DIR $DATA_DIR"
