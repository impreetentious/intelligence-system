# Notion Setup

You need: a root page, three databases with exact schemas, an integration token, and the integration shared with each database.

---

## Step 1 — Create the root page

1. In Notion, create a new page at the root level (same level as any existing top-level pages).
2. Title it **Intelligence Hub**.
3. Leave it empty for now.

---

## Step 2 — Create Database 1: Sources

This is the control panel. Both workflows read it at runtime.

1. Inside Intelligence Hub, type `/database` → choose **Database — Full page**.
2. Title it **Sources**.
3. Delete any default columns Notion created. Then add these exact columns:

| Column name | Type | Notes |
|---|---|---|
| Name | Title | Already exists by default |
| Type | Select | Add options: `Newsletter`, `News`, `Podcast` |
| Cadence | Select | Add options: `Daily`, `Weekly` |
| Source | Text | RSS URL or Gmail label name |
| Active | Checkbox | Checked = active |
| Notes | Text | Optional |

---

## Step 3 — Create Database 2: Daily Briefs

1. Inside Intelligence Hub, create another **Database — Full page**.
2. Title it **Daily Briefs**.
3. Set up these columns:

| Column name | Type | Notes |
|---|---|---|
| Date | Title | Already exists; rename if needed |
| Sources Processed | Number | Format: Number |
| AI Provider Used | Select | Add options: `Gemini`, `Ollama` |
| Status | Select | Add options: `Generated`, `Nothing Today` |
| Generated At | Date | Include time |

---

## Step 4 — Create Database 3: Weekly Synthesis

1. Inside Intelligence Hub, create another **Database — Full page**.
2. Title it **Weekly Synthesis**.
3. Set up these columns:

| Column name | Type | Notes |
|---|---|---|
| Week Of | Title | Already exists; rename if needed |
| Daily Briefs Read | Number | |
| Weekly Sources | Number | |
| AI Provider Used | Select | Add options: `Gemini`, `Ollama` |
| Generated At | Date | Include time |

---

## Step 5 — Create a Notion Integration

1. Go to **https://www.notion.so/my-integrations**.
2. Click **+ New integration**.
3. Name it `intelligence-system`.
4. Associated workspace: your personal workspace.
5. Capabilities: check **Read content**, **Update content**, **Insert content**. Leave User information unchecked.
6. Click **Submit**.
7. On the next screen, copy the **Internal Integration Token** (starts with `secret_...`).
8. Paste it into your private `.env` as `NOTION_TOKEN=secret_...`.

---

## Step 6 — Share all three databases with the integration

Do this for **Sources**, **Daily Briefs**, and **Weekly Synthesis**:

1. Open the database (Full page view).
2. Click the `...` menu (top right) → **Add connections**.
3. Search for `intelligence-system` → click it to add.
4. You'll see it listed under connections. Done.

---

## Step 7 — Copy the database IDs

For each database, you need the ID to put in your `.env`.

To get a database ID:
1. Open the database as a full page.
2. Look at the URL in your browser. It looks like:
   `https://www.notion.so/yourworkspace/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX?v=...`
3. The 32-character hex string before `?v=` is the database ID.
4. Format it with hyphens if needed: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

Copy and paste into your `.env`:
```
SOURCES_DB_ID=...
DAILY_BRIEFS_DB_ID=...
WEEKLY_SYNTHESIS_DB_ID=...
```

---

## Step 8 — Add your first sources (optional, can do later)

Open Sources DB and add a few rows to test with:

| Name | Type | Cadence | Source | Active |
|---|---|---|---|---|
| Hacker News | News | Daily | `https://news.ycombinator.com/rss` | ✓ |
| TechCrunch | News | Daily | `https://techcrunch.com/feed/` | ✓ |

You can add newsletters and podcasts after Gmail is set up.

---

## Done

Your Notion workspace is ready. `.env` should now have `NOTION_TOKEN`, `SOURCES_DB_ID`, `DAILY_BRIEFS_DB_ID`, and `WEEKLY_SYNTHESIS_DB_ID` filled in.
