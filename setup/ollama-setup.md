# Ollama Setup

Ollama is the local fallback AI provider. The workflows call it automatically if Gemini fails, or exclusively if you set `AI_PROVIDER=ollama`.

---

## Step 1 — Install Ollama (if not already installed)

**Mac:**
```bash
brew install ollama
```
Or download the macOS app from **https://ollama.com/download**.

**Windows:**
Download the installer from **https://ollama.com/download** and run it.

---

## Step 2 — Pull the model

The `.env.example` defaults to `llama3`. Pull it:

```bash
ollama pull llama3
```

This downloads about 4.7 GB. A good alternative for lower RAM machines is `llama3.2:3b` (~2 GB):
```bash
ollama pull llama3.2:3b
# Then update OLLAMA_MODEL=llama3.2:3b in your .env
```

---

## Step 3 — Confirm Ollama is running

```bash
ollama list
# Should show the model you pulled
```

```bash
curl http://localhost:11434/api/tags
# Should return JSON with your models
```

Ollama starts automatically on Mac after installation. On Windows, it runs as a background service.

---

## Step 4 — Verify the .env values

Defaults work on any machine:
```
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=llama3
```

If you changed the model in Step 2, update `OLLAMA_MODEL` accordingly.

---

## Notes

**Performance:** Llama 3 (8B) runs comfortably on 8 GB RAM machines. The weekly synthesis prompt is longer (~2000 tokens output) and may take 2–4 minutes on CPU-only machines.

**Switching to Ollama permanently:** Set `AI_PROVIDER=ollama` in your `.env`. Both workflows will use it exclusively and skip the Gemini call entirely.

**Ollama not running:** If Ollama is off when the workflow runs, Gemini handles everything. Ollama is only needed as a fallback or primary provider.

---

## Done

Ollama is installed and the model is pulled. No credentials needed — Ollama is a local HTTP server with no authentication.
