#!/usr/bin/env bash
# AIBTI · Updater
# Usage: curl -sL https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main/update.sh | bash
#
# Pulls latest SKILL.md + report template + portraits.
# Keeps your data intact: ~/.aibti/prompts.jsonl and ~/.aibti/report.html are NEVER touched.

set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; GREY='\033[0;90m'; NC='\033[0m'
RAW="https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
API="https://api.github.com/repos/leefufufufufu-rgb/aibti"
SKILL_DIR="$HOME/.claude/skills/aibti"
DATA_DIR="$HOME/.aibti"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  AIBTI Updater${NC} · Pulling latest"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ ! -d "$SKILL_DIR" ]; then
    echo -e "${YELLOW}⚠  AIBTI not installed yet. Run the installer first:${NC}"
    echo -e "   curl -sL $RAW/install.sh | bash"
    exit 1
fi

# Show what's new (last 3 commits from GitHub, failure-tolerant)
echo -e "${GREY}Recent updates:${NC}"
curl -s "$API/commits?per_page=3" 2>/dev/null | grep '"message"' | head -3 | \
    sed -E 's/.*"message": "([^"]{0,80}).*/  · \1/' || echo -e "${GREY}  (changelog unavailable, continuing)${NC}"
echo ""

# 1. Skill
printf "${YELLOW}[1/2]${NC} Updating Skill ... "
curl -sfL "$RAW/skills/aibti/SKILL.md" -o "$SKILL_DIR/SKILL.md" && printf "${GREEN}✓${NC}\n"

# 2. Template + 16 SVGs (keeps prompts.jsonl + report.html intact)
printf "${YELLOW}[2/2]${NC} Updating report assets ...\n"
mkdir -p "$DATA_DIR/portraits"
curl -sfL "$RAW/report-template.html" -o "$DATA_DIR/report-template.html"

PORTRAITS=(amde amdx amle amlx avde avdx avle avlx cmde cmdx cmle cmlx cvde cvdx cvle cvlx)
TOTAL=${#PORTRAITS[@]}
for i in "${!PORTRAITS[@]}"; do
    code="${PORTRAITS[$i]}"
    N=$((i+1))
    printf "\r  [%2d/%d] %s.svg ... " "$N" "$TOTAL" "$code"
    curl -sfL "$RAW/portraits/${code}.svg" -o "$DATA_DIR/portraits/${code}.svg" && printf "${GREEN}✓${NC}" || printf "${YELLOW}×${NC}"
done
printf "\r${GREEN}  ✓ %d portrait SVGs refreshed                                       ${NC}\n" "$TOTAL"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ Updated. Your data (~/.aibti/prompts.jsonl, report.html) untouched.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Run ${GREEN}Analyze my AIBTI${NC} in Claude Code to see the new version in action."
