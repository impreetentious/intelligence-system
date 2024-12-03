# n8n Setup

This is the final step. By now you should have `.env` fully filled in with all tokens and IDs.

---

## Step 1 — Install n8n

```bash
npm install -g n8n
```

Requires Node.js 18+. Verify with `node --version`.

---

## Step 2 — Set environment variables

n8n reads environment variables when it starts. The easiest approach is to export them before starting n8n.

**Mac:**
```bash
export $(grep -v '^#' /path/to/your/.env | xargs)
n8n start
```

Or use the setup script from this repo (see `scripts/setup.sh`) which does this for you.

**Windows:**
Use the setup script (`scripts\setup.ps1`) or set them via n8n's UI after starting (Settings → Environment Variables).

n8n runs at **http://localhost:5678**.

---

## Step 3 — Import the workflow JSONs

1. Open n8n at `localhost:5678`.
2. Create a free account (first time only) or sign in.
3. In the left sidebar, go to **Workflows**.
4. Click **+ Add workflow** → **Import from file**.
5. Import `workflows/daily-stack.json`.
6. Import `workflows/weekly-stack.json` (repeat).

Both workflows will appear in your workflows list.

---

## Step 4 — Add the Notion credential

1. In n8n, go to **Settings → Credentials** (or the Credentials section in the sidebar).
2. Click **+ Add credential**.
3. Search for **Notion** → choose **Notion API**.
4. Paste your `NOTION_TOKEN` from `.env` into the API key field.
5. Name it `Notion account`.
6. Click **Save**.
7. Note the credential ID (visible in the URL when editing it).

---

## Step 5 — Add the Gemini credential

For the Gemini HTTP Request nodes, the API key is passed via URL query parameter (`?key=...`) using `$env.GEMINI_API_KEY`. No separate credential needed — as long as the env variable is set, it works.

---

## Step 6 — Add the Gmail OAuth credential

1. In n8n, go to **Settings → Credentials → + Add credential**.
2. Search for **Gmail** → choose **Gmail OAuth2**.
3. Enter your `GMAIL_CLIENT_ID` and `GMAIL_CLIENT_SECRET` from `.env`.
4. Click **Connect** — a browser popup opens asking you to authorize the app.
5. Sign in with your Gmail account and grant the requested permissions.
6. The popup closes and the credential shows as connected.
7. Name it `Gmail account`.
8. Click **Save**.

---

## Step 7 — Re-link credentials in the workflows

The imported JSON has placeholder credential IDs. You need to re-link them:

**For each workflow (Daily Brief and Weekly Synthesis):**

1. Open the workflow.
2. Click on each of these nodes and re-select your credential in the dropdown:
   - **Read Sources DB** → select `Notion account`
   - **Read Daily Briefs** (weekly workflow only) → select `Notion account`
   - **Read Weekly Sources** (weekly workflow only) → select `Notion account`
   - **Fetch Newsletters / Fetch W-Newsletters** → select `Gmail account`
   - **Get Block Children** (weekly workflow only) → select `Notion account`
   - **Append Brief Content / Append Synthesis Content** → select `Notion account`
   - **Create Brief Page / Create Synthesis Page / Create Nothing Today / Create Nothing This Week** → select `Notion account`
3. Save the workflow (Ctrl+S or Cmd+S).

---

## Step 8 — Test each workflow manually

### Test Daily Brief:

1. Open the **Daily Brief — Intelligence System** workflow.
2. Click **Test workflow** (or the play button on the Schedule Trigger).
3. Watch the execution in real time. Each node turns green (success) or red (error).
4. If all nodes succeed, open Notion → Intelligence Hub → Daily Briefs. A new page should be there.

**Common first-run issues:**

- **Notion node error "database not found"**: Check that `SOURCES_DB_ID` etc. are the correct IDs with no extra spaces. Also verify the integration is shared with each database (see notion-setup.md Step 6).
- **Gmail node "unauthorized"**: The OAuth credential needs to be re-authorized. Open the Gmail credential and click Connect again.
- **Gemini 403 error**: Check that `GEMINI_API_KEY` is set correctly as an n8n environment variable, not just in your `.env` file.
- **"No items"**: Either no sources are Active+Daily in Sources DB, or no new emails/RSS items in last 24h. Add a test RSS source and re-run.

### Test Weekly Synthesis:

1. Open the **Weekly Synthesis — Intelligence System** workflow.
2. Run manually. This workflow also reads last week's Daily Brief pages, so run the Daily Brief first at least once.
3. After success, check Notion → Intelligence Hub → Weekly Synthesis.

---

## Step 9 — Set n8n environment variables via UI (alternative method)

If you didn't export env vars before starting n8n, you can set them in the UI:

1. Go to **Settings → Environment Variables**.
2. Add each variable from your `.env` file.
3. Restart n8n after saving.

---

## Step 10 — Note the webhook URLs

1. Open the Daily Brief workflow.
2. Click on **Webhook Trigger** node.
3. Copy the **Production URL** (not the test URL). It looks like `https://localhost:5678/webhook/daily-brief` or similar.
4. Bookmark it in your browser and phone browser as **"Run Daily Brief"**.
5. Repeat for the Weekly Synthesis workflow → bookmark as **"Run Weekly Synthesis"**.

For phone bookmarks: open the URL on your phone, then use the browser's "Add to Home Screen" option for one-tap access.

---

## Step 11 — Enable both workflows

1. Open each workflow.
2. Toggle the **Active** switch (top right) to ON.
3. The cron triggers are now live: Daily Brief fires at 7am, Weekly Synthesis fires Sunday at 4pm.

---

## Editing prompts

Both prompts live inside Code nodes in the workflows:
- Daily Brief: the **Normalise + Build Prompt** node → `jsCode` parameter → the `prompt` constant
- Weekly: the **Build Synthesis Prompt** node → same structure

To edit: open the node → edit the string → save.

---

## Done

Both workflows are active. Sources are managed in Notion. AI provider is switchable via one env var. New device setup runs this entire guide in under 20 minutes with the setup script.
