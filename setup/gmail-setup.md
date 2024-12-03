# Gmail Setup

Two parts: (A) create Gmail labels and filters so newsletters land in the right place, and (B) create OAuth 2.0 credentials in Google Cloud so n8n can read your Gmail.

---

## Part A — Gmail Labels and Filters

### Step 1 — Create the labels

1. Open **Gmail** in a browser.
2. In the left sidebar, scroll down and click **+ Create new label**.
3. Create a label named `newsletters-daily`.
4. Repeat for `newsletters-weekly`.

### Step 2 — Set up a filter for each newsletter

For each newsletter you want to capture (do this per sender):

1. In Gmail, click the search bar → click **Show search options** (the small arrow on the right).
2. In the **From** field, enter the sender's email address (e.g. `noreply@morningbrew.com`).
3. Click **Create filter**.
4. Check **Apply the label** → select `newsletters-daily` (or `weekly` if it's a weekly newsletter).
5. Check **Skip the Inbox** (so your inbox stays clean).
6. Check **Also apply filter to matching conversations** if you have existing emails.
7. Click **Create filter**.

Repeat for every newsletter sender.

### Step 3 — Add sources to Notion

For each newsletter you've filtered, add a row to your **Sources DB** in Notion:
- Type: `Newsletter`
- Cadence: `Daily` or `Weekly`
- Source: the exact label name (e.g. `newsletters-daily`)
- Active: checked

The Source column value must exactly match the Gmail label name.

---

## Part B — Gmail OAuth 2.0 Credentials for n8n

n8n's Gmail node uses OAuth 2.0. You need a Google Cloud project with OAuth credentials.

### Step 1 — Create a Google Cloud project

1. Go to **https://console.cloud.google.com/**.
2. Click the project dropdown (top left) → **New Project**.
3. Name it `n8n-intelligence` → **Create**.
4. Make sure you're now working in that project.

### Step 2 — Enable the Gmail API

1. Go to **APIs & Services → Library**.
2. Search for **Gmail API**.
3. Click it → **Enable**.

### Step 3 — Configure the OAuth consent screen

1. Go to **APIs & Services → OAuth consent screen**.
2. Choose **External** → **Create**.
3. Fill in:
   - App name: `n8n Intelligence`
   - User support email: your Gmail address
   - Developer contact email: your Gmail address
4. Click **Save and Continue** through all steps.
5. On the **Test users** step, click **+ Add users** and add your own Gmail address.
6. Click **Save and Continue** → **Back to Dashboard**.

### Step 4 — Create OAuth 2.0 credentials

1. Go to **APIs & Services → Credentials**.
2. Click **+ Create Credentials** → **OAuth client ID**.
3. Application type: **Web application**.
4. Name: `n8n Gmail`.
5. Under **Authorized redirect URIs**, add:
   `http://localhost:5678/rest/oauth2-credential/callback`
6. Click **Create**.
7. A popup shows your **Client ID** and **Client Secret**. Copy both.
8. Paste into your private `.env`:
   ```
   GMAIL_CLIENT_ID=your_client_id
   GMAIL_CLIENT_SECRET=your_client_secret
   ```

---

## Notes

**Multiple Gmail accounts:** This setup works with one Gmail account. If your newsletters are spread across accounts, you'll need to either consolidate with forwarding rules or create separate credentials per account.

**Finding newsletter sender addresses:** If you're not sure what email address a newsletter uses, open an existing email from them and check the From field exactly.

**Label names with spaces:** Avoid spaces in label names — use hyphens instead. The Gmail search query format handles hyphens correctly.

---

## Done

You now have: Gmail labels active, filters routing newsletters, and OAuth credentials in `.env` (`GMAIL_CLIENT_ID` and `GMAIL_CLIENT_SECRET`). The OAuth consent flow (browser popup) completes inside n8n during credential setup.
