# Intelligence System (Automated)

Two n8n workflows that pull newsletters, news RSS and podcast show notes into structured Notion briefs — fully automated, AI-summarised, and manageable entirely from a Notion database.

## What it does

**Daily Brief** — fires at 7am (or on-demand). Reads last 24h of content from all active sources. Produces a _Today in Brief_ page in Notion.

**Weekly Synthesis** — fires Sunday at 4pm (or on-demand). Reads the week's Daily Brief pages plus any weekly-cadence sources. Produces a _Week of X_ synthesis page in Notion.

## Stack

| Layer | Tool | Cost |
|---|---|---|
| Automation | n8n (local, Mac + Windows) | Free |
| AI — Primary | Google Gemini 2.5 Flash | Free tier |
| AI — Fallback | Ollama (local) | Free |
| Output | Notion | Free |
| Email | Gmail | Free |
| News + Podcasts | RSS | Free |

## How sources are managed

Every source lives in a Notion database called **Sources**. Add a row → source is active on next run. Uncheck Active → paused instantly. No n8n edits ever needed.

## Switching AI provider

Change `AI_PROVIDER=ollama` in your `.env` (or in n8n's environment variables). Both workflows pick it up on the next run. Gemini failures automatically fall back to Ollama regardless.

## Repo structure

```
intelligence-system/
├── README.md
├── .env.example                 ← all required variables with placeholders
├── workflows/
│   ├── daily-stack.json         ← importable, all values via $env refs
│   └── weekly-stack.json
├── prompts/
│   ├── daily-prompt.md          ← prompt template for reference and editing
│   └── weekly-prompt.md
├── setup/
│   ├── notion-setup.md          ← DB schemas + integration token
│   ├── gmail-setup.md           ← labels, filters, OAuth credentials
│   ├── gemini-setup.md          ← API key walkthrough
│   ├── ollama-setup.md          ← model setup + fallback config
│   └── n8n-setup.md             ← import, credentials, env vars, test
└── scripts/
    ├── setup.sh                 ← Mac: copies .env, starts n8n, imports workflows
    └── setup.ps1                ← Windows: same
```

## New device setup

Prerequisites: your private `.env` file has all tokens and DB IDs already filled in.

1. `npm install -g n8n`
2. `git clone github.com/you/intelligence-system`
3. `git clone github.com/you/intelligence-system-config` (your private repo with `.env`)
4. Mac: `bash scripts/setup.sh` / Windows: `.\scripts\setup.ps1`
5. Open `localhost:5678`, add three credentials (Notion, Gemini, Gmail OAuth)
6. Confirm Ollama is running and model is pulled
7. Run each workflow once manually to test
8. Note the two webhook URLs → bookmark on browser and phone
9. Enable both workflows

**Under 20 minutes every time.**

## Credential notes

After importing the workflow JSONs, open each node that uses a credential (Notion query nodes, Gmail node, Gemini/Ollama HTTP nodes) and re-select the credential you created. The JSONs use placeholder credential IDs (`REPLACE_NOTION_CRED_ID`, `REPLACE_GMAIL_CRED_ID`) that need to be mapped to your actual n8n credentials.

## No personal data in this repo

Every personal value is stored as an environment variable referenced as `$env.VARIABLE_NAME` in node parameters. The workflow JSONs are safe to publish publicly.

## License

MIT © Sidakpreet Singh — see [LICENSE](LICENSE).

---

**Version:** v1.0.1
