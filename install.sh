#!/usr/bin/env bash
# AIBTI · One-line installer (v0.2.x)
# Usage: curl -sL https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main/install.sh | bash
#
# Installs ONLY the pure personality test — zero background processes.
# AIBTI will execute ONLY when you explicitly say "Analyze my AIBTI" in Claude Code.
# Your normal development workflow is 100% unchanged.

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
RAW="https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
SKILL_DIR="$HOME/.claude/skills/aibti"
DATA_DIR="$HOME/.aibti"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  AIBTI Installer${NC} · Pure personality test, zero friction"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ ! -d "$HOME/.claude" ]; then
    echo -e "${YELLOW}⚠  ~/.claude not found. Install Claude Code first: https://docs.claude.com/claude-code${NC}"
    exit 1
fi

# 1. Skill
echo -e "${YELLOW}[1/2] Installing Skill to ${SKILL_DIR}...${NC}"
mkdir -p "$SKILL_DIR"
curl -sfL "$RAW/skills/aibti/SKILL.md" -o "$SKILL_DIR/SKILL.md"
echo -e "${GREEN}  ✓ Skill installed (runs ONLY when you ask)${NC}"

# 2. Report template + 16 portrait SVGs (for beautiful HTML report)
echo -e "${YELLOW}[2/2] Installing report assets to ${DATA_DIR}...${NC}"
mkdir -p "$DATA_DIR/portraits"
chmod 700 "$DATA_DIR" 2>/dev/null || true

curl -sfL "$RAW/report-template.html" -o "$DATA_DIR/report-template.html"
printf "  "
PORTRAITS=(amde amdx amle amlx avde avdx avle avlx cmde cmdx cmle cmlx cvde cvdx cvle cvlx)
for code in "${PORTRAITS[@]}"; do
    curl -sfL "$RAW/portraits/${code}.svg" -o "$DATA_DIR/portraits/${code}.svg"
    printf "."
done
echo -e "\n${GREEN}  ✓ Report template + 16 portrait SVGs installed${NC}"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ AIBTI installed. Zero background processes.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BLUE}How it works:${NC}"
echo "  · AIBTI is 100% passive — runs only when you ask"
echo "  · Your normal Claude Code workflow is untouched"
echo "  · Each scan reads existing ~/.claude/projects/ (no new files watched)"
echo ""
echo -e "${BLUE}To get your report, open Claude Code and say:${NC}"
echo -e "   ${GREEN}Analyze my AIBTI${NC}     or     ${GREEN}测一下我的 AIBTI${NC}"
echo ""
echo -e "${BLUE}You'll get:${NC}"
echo "  · A terminal report (diagnostics with AI-research citations)"
echo "  · A rich HTML report at ${GREEN}~/.aibti/report.html${NC}"
echo ""
echo -e "${YELLOW}Advanced (optional · most users don't need this):${NC}"
echo "  For a unified prompt log across Claude Code / Cursor / Codex / Copilot,"
echo "  you can install a lightweight hook that runs ~100ms per prompt:"
echo -e "     ${BLUE}curl -sL $RAW/install-hook.sh | bash${NC}"
echo ""
echo -e "${BLUE}Privacy:${NC} 100% local · see $RAW/PRIVACY.md"
echo -e "${BLUE}Uninstall:${NC} rm -rf $SKILL_DIR $DATA_DIR"
