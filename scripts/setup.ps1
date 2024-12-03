# setup.ps1 — Windows setup for Intelligence System
# Run from the repo root: .\scripts\setup.ps1
# Prerequisites: Node.js 18+, Ollama installed

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $PSScriptRoot
$ConfigRepo = "$env:USERPROFILE\intelligence-system-config"
$EnvFile = "$ConfigRepo\.env"

Write-Host ""
Write-Host "─────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host " Intelligence System — Windows Setup" -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""

# ── 1. Check Node.js ──────────────────────────────────────────────
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "ERROR: Node.js not found. Install Node.js 18+ from https://nodejs.org" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Node.js $nodeVersion" -ForegroundColor Green

# ── 2. Install n8n ────────────────────────────────────────────────
$n8nVersion = n8n --version 2>$null
if (-not $n8nVersion) {
    Write-Host "→ Installing n8n..." -ForegroundColor Yellow
    npm install -g n8n
} else {
    Write-Host "✓ n8n already installed ($n8nVersion)" -ForegroundColor Green
}

# ── 3. Load .env ──────────────────────────────────────────────────
if (-not (Test-Path $EnvFile)) {
    Write-Host ""
    Write-Host "ERROR: .env not found at $EnvFile" -ForegroundColor Red
    Write-Host "Clone your private config repo first:" -ForegroundColor Yellow
    Write-Host "  git clone github.com/you/intelligence-system-config $ConfigRepo"
    exit 1
}

Write-Host "→ Loading environment from $EnvFile" -ForegroundColor Yellow
Get-Content $EnvFile | ForEach-Object {
    if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
        $name  = $Matches[1].Trim()
        $value = $Matches[2].Trim()
        [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}
Write-Host "✓ Environment loaded" -ForegroundColor Green

# ── 4. Check Ollama ───────────────────────────────────────────────
$ollamaPresent = Get-Command ollama -ErrorAction SilentlyContinue
if ($ollamaPresent) {
    try {
        $null = Invoke-WebRequest "http://localhost:11434/api/tags" -UseBasicParsing -TimeoutSec 2
        Write-Host "✓ Ollama running" -ForegroundColor Green
    } catch {
        Write-Host "→ Ollama not running — start it manually or it will auto-start" -ForegroundColor Yellow
    }
    $model = if ($env:OLLAMA_MODEL) { $env:OLLAMA_MODEL } else { "llama3" }
    $modelList = ollama list 2>$null
    if ($modelList -notmatch $model) {
        Write-Host "→ Pulling Ollama model: $model" -ForegroundColor Yellow
        ollama pull $model
    } else {
        Write-Host "✓ Ollama model $model available" -ForegroundColor Green
    }
} else {
    Write-Host "⚠  Ollama not found — Gemini will be used as primary AI" -ForegroundColor Yellow
}

# ── 5. Show workflow paths and instructions ────────────────────────
$DailyJson  = Join-Path $RepoDir "workflows\daily-stack.json"
$WeeklyJson = Join-Path $RepoDir "workflows\weekly-stack.json"

Write-Host ""
Write-Host "─────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host " Starting n8n and importing workflows..." -ForegroundColor Cyan
Write-Host "─────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""
Write-Host "After n8n opens at localhost:5678, complete these steps:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Create or sign in to your n8n account"
Write-Host "  2. Workflows → Import from file:"
Write-Host "     $DailyJson" -ForegroundColor Cyan
Write-Host "     $WeeklyJson" -ForegroundColor Cyan
Write-Host "  3. Add credentials: Notion API, Gmail OAuth2"
Write-Host "  4. Re-link credentials in each workflow node"
Write-Host "  5. Run each workflow once manually to test"
Write-Host "  6. Note webhook URLs → bookmark on browser and phone"
Write-Host "  7. Enable both workflows"
Write-Host ""
Read-Host "Press Enter to start n8n"

n8n start
