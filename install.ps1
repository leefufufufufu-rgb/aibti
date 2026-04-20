# AIBTI · One-line installer (Windows PowerShell, v0.2.x)
# Usage:
#   irm https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main/install.ps1 | iex
#
# Zero new runtime dependencies — Claude Code already ships Node.js.

$ErrorActionPreference = "Stop"
$Raw = "https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
$SkillDir = Join-Path $env:USERPROFILE ".claude\skills\aibti"
$DataDir  = Join-Path $env:USERPROFILE ".aibti"

function Write-Banner($text, $color = "Cyan") { Write-Host $text -ForegroundColor $color }

Write-Banner "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Banner "  AIBTI Installer · Your AI Conversation Personality"
Write-Banner "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
if (-not (Test-Path $ClaudeDir)) {
    Write-Host "⚠  $ClaudeDir not found. Install Claude Code first: https://docs.claude.com/claude-code" -ForegroundColor Yellow
    exit 1
}

# 1. Skill
Write-Host "[1/3] Installing Skill to $SkillDir ..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
Invoke-WebRequest -UseBasicParsing "$Raw/skills/aibti/SKILL.md" -OutFile (Join-Path $SkillDir "SKILL.md")
Write-Host "  ✓ Skill installed" -ForegroundColor Green

# 2. Report assets
Write-Host "[2/3] Installing report assets to $DataDir ..." -ForegroundColor Yellow
$PortraitDir = Join-Path $DataDir "portraits"
New-Item -ItemType Directory -Force -Path $PortraitDir | Out-Null

Invoke-WebRequest -UseBasicParsing "$Raw/report-template.html" -OutFile (Join-Path $DataDir "report-template.html")
Write-Host "  ✓ Report template" -ForegroundColor Green

$Portraits = @("amde","amdx","amle","amlx","avde","avdx","avle","avlx","cmde","cmdx","cmle","cmlx","cvde","cvdx","cvle","cvlx")
foreach ($code in $Portraits) {
    Invoke-WebRequest -UseBasicParsing "$Raw/portraits/$code.svg" -OutFile (Join-Path $PortraitDir "$code.svg")
    Write-Host "." -NoNewline
}
Write-Host ""
Write-Host "  ✓ 16 portrait SVGs installed" -ForegroundColor Green

# 3. Optional hook
Write-Host ""
Write-Host "[3/3] Optional — install Node.js hook to record future prompts?" -ForegroundColor Yellow
Write-Host "   Without it: AIBTI still works (reads existing ~/.claude/projects/)."
Write-Host "   With it:    Future prompts unified to ~/.aibti/prompts.jsonl (with redaction)."
Write-Host ""
$installHook = Read-Host "   Install hook? [y/N]"

if ($installHook -match '^[Yy]') {
    Invoke-WebRequest -UseBasicParsing "$Raw/hooks/record.js" -OutFile (Join-Path $DataDir "record.js")
    Write-Host "  ✓ Hook script installed" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Add to $($env:USERPROFILE)\.claude\settings.json (under 'hooks'):" -ForegroundColor Yellow
    $hookCmd = "node `"$(Join-Path $DataDir 'record.js')`""
    @"
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [{"type":"command","command":"$hookCmd","timeout":2}]
      }
    ]
"@ | Write-Host
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  ✓ AIBTI installed." -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "Next: open Claude Code and say:" -ForegroundColor Cyan
Write-Host "   Analyze my AIBTI   or   测一下我的 AIBTI" -ForegroundColor Green
Write-Host ""
Write-Host "You'll get:" -ForegroundColor Cyan
Write-Host "   · A rich terminal report"
Write-Host "   · A beautiful HTML report at ~/.aibti/report.html (open in any browser)"
Write-Host ""
Write-Host "Privacy: 100% local — see $Raw/PRIVACY.md" -ForegroundColor Cyan
Write-Host "Uninstall: Remove-Item -Recurse $SkillDir, $DataDir" -ForegroundColor Cyan
