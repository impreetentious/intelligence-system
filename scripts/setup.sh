#!/usr/bin/env bash
# setup.sh — Mac setup for Intelligence System
# Run from the repo root: bash scripts/setup.sh
# Prerequisites: Node.js 18+, Ollama installed

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_REPO="${HOME}/intelligence-system-config"
ENV_FILE="${CONFIG_REPO}/.env"
N8N_WORKFLOWS_DIR="${HOME}/.n8n"

echo "─────────────────────────────────────────────"
echo " Intelligence System — Mac Setup"
echo "─────────────────────────────────────────────"

# ── 1. Check Node.js ──────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo "ERROR: Node.js not found. Install Node.js 18+ first."
  exit 1
fi
NODE_VER=$(node -e "process.stdout.write(process.versions.node)")
echo "✓ Node.js ${NODE_VER}"

# ── 2. Install n8n ────────────────────────────────────────────────
if ! command -v n8n &>/dev/null; then
  echo "→ Installing n8n..."
  npm install -g n8n
else
  echo "✓ n8n already installed ($(n8n --version 2>/dev/null | head -1))"
fi

# ── 3. Load .env ──────────────────────────────────────────────────
if [ ! -f "${ENV_FILE}" ]; then
  echo ""
  echo "ERROR: .env not found at ${ENV_FILE}"
  echo "Clone your private config repo first:"
  echo "  git clone github.com/you/intelligence-system-config ~/intelligence-system-config"
  exit 1
fi

echo "→ Loading environment from ${ENV_FILE}"
set -a
# shellcheck disable=SC1090
source "${ENV_FILE}"
set +a
echo "✓ Environment loaded"

# ── 4. Check Ollama ───────────────────────────────────────────────
if command -v ollama &>/dev/null; then
  if curl -s "http://localhost:11434/api/tags" &>/dev/null; then
    echo "✓ Ollama running"
  else
    echo "→ Starting Ollama..."
    ollama serve &>/dev/null &
    sleep 2
  fi
  MODEL="${OLLAMA_MODEL:-llama3}"
  if ! ollama list 2>/dev/null | grep -q "${MODEL}"; then
    echo "→ Pulling Ollama model: ${MODEL}"
    ollama pull "${MODEL}"
  else
    echo "✓ Ollama model ${MODEL} available"
  fi
else
  echo "⚠  Ollama not found — Gemini will be used as primary AI"
fi

# ── 5. Import workflows ───────────────────────────────────────────
DAILY_JSON="${REPO_DIR}/workflows/daily-stack.json"
WEEKLY_JSON="${REPO_DIR}/workflows/weekly-stack.json"

echo ""
echo "─────────────────────────────────────────────"
echo " Starting n8n and importing workflows..."
echo "─────────────────────────────────────────────"
echo ""
echo "After n8n opens at localhost:5678, complete these steps:"
echo ""
echo "  1. Create or sign in to your n8n account"
echo "  2. Go to Workflows → Import from file"
echo "     Import: ${DAILY_JSON}"
echo "     Import: ${WEEKLY_JSON}"
echo "  3. Add credentials: Notion API, Gmail OAuth2"
echo "  4. Re-link credentials in each workflow node"
echo "  5. Run each workflow once manually to test"
echo "  6. Note webhook URLs → bookmark on browser and phone"
echo "  7. Enable both workflows"
echo ""
echo "Press Enter to start n8n..."
read -r

n8n start
