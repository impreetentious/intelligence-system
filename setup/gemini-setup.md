# Gemini API Key Setup

Takes about 3 minutes.

---

## Step 1 — Get an API key from Google AI Studio

1. Go to **https://aistudio.google.com/app/apikey**.
2. Sign in with your Google account if prompted.
3. Click **Create API key**.
4. Choose **Create API key in new project** (or select an existing project).
5. Google generates the key. Click **Copy** to copy it.

---

## Step 2 — Save it to your .env

Paste into your private `.env`:
```
GEMINI_API_KEY=AIza...
```

---

## Step 3 — Verify free tier limits (optional)

The workflow uses **Gemini 1.5 Flash**. As of late 2024, the free tier allows:
- 15 requests per minute
- 1 million tokens per minute
- 1,500 requests per day

For a personal daily brief + weekly synthesis, this is comfortably within the free tier.

If you exceed limits, the workflow automatically falls back to Ollama (local). No data loss — the fallback is built into both workflows.

---

## Notes

**No credit card required** for the free tier via AI Studio (as opposed to Vertex AI).

**Rotating the key:** If you ever regenerate the key, update `GEMINI_API_KEY` in your `.env` and update the environment variable in n8n (Settings → Environment Variables if you're using the UI, or restart n8n after editing `.env`).

---

## Done

`GEMINI_API_KEY` is set. Gemini is the default provider. Ollama is the fallback. The `AI_PROVIDER` variable in `.env` controls the default: `gemini` or `ollama`.
