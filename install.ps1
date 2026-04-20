# AIBTI · One-line installer (Windows PowerShell, v0.2.x)
# Usage: irm https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main/install.ps1 | iex
#
# Installs ONLY the pure personality test — zero background processes.
# AIBTI will execute ONLY when you explicitly say "Analyze my AIBTI" in Claude Code.
# Your normal development workflow is 100% unchanged.

$ErrorActionPreference = "Stop"
$Raw = "https://raw.githubusercontent.com/leefufufufufu-rgb/aibti/main"
$SkillDir = Join-Path $env:USERPROFILE ".claude\skills\aibti"
$DataDir  = Join-Path $env:USERPROFILE ".aibti"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  AIBTI Installer · Pure personality test, zero friction" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
if (-not (Test-Path $ClaudeDir)) {
    Write-Host "⚠  $ClaudeDir not found. Install Claude Code first: https://docs.claude.com/claude-code" -ForegroundColor Yellow
    exit 1
}

# 1. Skill
Write-Host "[1/2] Installing Skill to $SkillDir ..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
Invoke-WebRequest -UseBasicParsing "$Raw/skills/aibti/SKILL.md" -OutFile (Join-Path $SkillDir "SKILL.md")
Write-Host "  ✓ Skill installed (runs ONLY when you ask)" -ForegroundColor Green

# 2. Report template + 16 portrait SVGs
Write-Host "[2/2] Installing report assets to $DataDir ..." -ForegroundColor Yellow
$PortraitDir = Join-Path $DataDir "portraits"
New-Item -ItemType Directory -Force -Path $PortraitDir | Out-Null

Invoke-WebRequest -UseBasicParsing "$Raw/report-template.html" -OutFile (Join-Path $DataDir "report-template.html")
Write-Host -NoNewline "  "
$Portraits = @("amde","amdx","amle","amlx","avde","avdx","avle","avlx","cmde","cmdx","cmle","cmlx","cvde","cvdx","cvle","cvlx")
foreach ($code in $Portraits) {
    Invoke-WebRequest -UseBasicParsing "$Raw/portraits/$code.svg" -OutFile (Join-Path $PortraitDir "$code.svg")
    Write-Host "." -NoNewline
}
Write-Host ""
Write-Host "  ✓ Report template + 16 portrait SVGs installed" -ForegroundColor Green

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  ✓ AIBTI installed. Zero background processes." -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "How it works:" -ForegroundColor Cyan
Write-Host "  · AIBTI is 100% passive — runs only when you ask"
Write-Host "  · Your normal Claude Code workflow is untouched"
Write-Host ""
Write-Host "To get your report, open Claude Code and say:" -ForegroundColor Cyan
Write-Host "   Analyze my AIBTI   or   测一下我的 AIBTI" -ForegroundColor Green
Write-Host ""
Write-Host "You'll get:" -ForegroundColor Cyan
Write-Host "  · A terminal report with diagnostics"
Write-Host "  · A rich HTML report at ~\.aibti\report.html"
Write-Host ""
Write-Host "Advanced (optional · most users don't need this):" -ForegroundColor Yellow
Write-Host "  For a unified prompt log, you can install an optional hook:"
Write-Host "     irm $Raw/install-hook.ps1 | iex" -ForegroundColor Cyan
Write-Host ""
Write-Host "Privacy: 100% local · see $Raw/PRIVACY.md" -ForegroundColor Cyan
Write-Host "Uninstall: Remove-Item -Recurse $SkillDir, $DataDir" -ForegroundColor Cyan
