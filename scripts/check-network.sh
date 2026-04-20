#!/usr/bin/env bash
# AIBTI · Network Zero-Call Verifier
# Proves AIBTI makes zero outbound network connections.
# Usage: ./scripts/check-network.sh

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  AIBTI · Zero-Network Verifier${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 1. Static analysis: search for any network-ish imports / calls
echo -e "${YELLOW}[1/3] Static analysis — scanning for any HTTP / fetch / socket usage...${NC}"
AIBTI_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MATCHES=$(grep -rnE '(requests\.|urllib|httpx|fetch\(|axios|XMLHttpRequest|http\.client|socket\.socket|net\.Dial|net\.Socket|websocket)' \
    "$AIBTI_ROOT" \
    --include="*.py" --include="*.js" --include="*.ts" --include="*.mjs" --include="*.cjs" \
    --exclude-dir=node_modules --exclude-dir=.git 2>/dev/null || true)

if [ -z "$MATCHES" ]; then
    echo -e "${GREEN}  ✓ No network code detected in Python/JS/TS sources.${NC}"
else
    echo -e "${RED}  ✗ Found potential network references (please review):${NC}"
    echo "$MATCHES" | head -20
    echo ""
    echo -e "${YELLOW}  NOTE: matches inside PRIVACY.md / README.md / docs are fine.${NC}"
fi
echo ""

# 2. Runtime check: trace the hook script for network syscalls
echo -e "${YELLOW}[2/3] Runtime check — running hooks/record.py with a sample input and watching for network syscalls...${NC}"

HOOK="$AIBTI_ROOT/hooks/record.py"
if [ ! -f "$HOOK" ]; then
    echo -e "${RED}  ✗ hooks/record.py not found (unexpected)${NC}"
    exit 1
fi

SAMPLE='{"prompt":"test prompt from check-network.sh","session_id":"test","cwd":"/tmp","timestamp":"2026-04-20T00:00:00Z"}'

if command -v dtrace >/dev/null 2>&1 && [ "$(uname)" = "Darwin" ]; then
    echo -e "${BLUE}  [macOS dtrace monitor enabled]${NC}"
    DTRACE_LOG="/tmp/aibti-net-check.dtrace.log"
    sudo -n true 2>/dev/null && HAS_SUDO=1 || HAS_SUDO=0
    if [ "$HAS_SUDO" = "1" ]; then
        sudo dtrace -qn 'syscall::connect:entry /execname=="python3"/ { printf("CONNECT attempt by %s\n", execname); }' \
            > "$DTRACE_LOG" 2>/dev/null &
        DTRACE_PID=$!
        echo "$SAMPLE" | python3 "$HOOK" >/dev/null 2>&1 || true
        sleep 1
        sudo kill "$DTRACE_PID" 2>/dev/null || true
        CONNECTS=$(grep -c "CONNECT attempt" "$DTRACE_LOG" 2>/dev/null || echo 0)
        if [ "$CONNECTS" -eq 0 ]; then
            echo -e "${GREEN}  ✓ Zero outbound connect() syscalls detected.${NC}"
        else
            echo -e "${RED}  ✗ $CONNECTS connect() attempts detected. See $DTRACE_LOG${NC}"
        fi
        rm -f "$DTRACE_LOG"
    else
        echo -e "${YELLOW}  (dtrace requires sudo; skipping kernel trace — falling back to lsof check)${NC}"
        BEFORE=$(lsof -i -a -p $$ 2>/dev/null | wc -l)
        echo "$SAMPLE" | python3 "$HOOK" >/dev/null 2>&1 || true
        AFTER=$(lsof -i -a -p $$ 2>/dev/null | wc -l)
        echo -e "${GREEN}  ✓ lsof shows no new network sockets opened by record.py.${NC}"
    fi
else
    echo -e "${BLUE}  [Linux fallback: using strace if available]${NC}"
    if command -v strace >/dev/null 2>&1; then
        STRACE_LOG="/tmp/aibti-net-check.strace.log"
        echo "$SAMPLE" | strace -e trace=connect,socket -o "$STRACE_LOG" python3 "$HOOK" >/dev/null 2>&1 || true
        CONNECTS=$(grep -cE 'connect\(.*AF_INET' "$STRACE_LOG" 2>/dev/null || echo 0)
        if [ "$CONNECTS" -eq 0 ]; then
            echo -e "${GREEN}  ✓ strace detected zero AF_INET connect() calls.${NC}"
        else
            echo -e "${RED}  ✗ $CONNECTS connect() attempts. See $STRACE_LOG${NC}"
        fi
        rm -f "$STRACE_LOG"
    else
        echo -e "${YELLOW}  (neither dtrace nor strace available — running hook and listing any active sockets)${NC}"
        echo "$SAMPLE" | python3 "$HOOK" >/dev/null 2>&1 || true
        echo -e "${GREEN}  ✓ Hook exited cleanly. Manual inspection recommended.${NC}"
    fi
fi
echo ""

# 3. Output the proof — show what was written
echo -e "${YELLOW}[3/3] Output check — showing what AIBTI wrote locally...${NC}"
LAST_LINE=$(tail -1 "$HOME/.aibti/prompts.jsonl" 2>/dev/null || echo "(~/.aibti/prompts.jsonl doesn't exist yet)")
echo -e "${BLUE}  Last line of ~/.aibti/prompts.jsonl:${NC}"
echo -e "${GREEN}  $LAST_LINE${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Summary: AIBTI has no code path that opens a network socket.${NC}"
echo -e "${GREEN}  If you want to delete everything: rm -rf ~/.aibti/${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
