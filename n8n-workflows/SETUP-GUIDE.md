# CalmFalcon n8n Pipeline Setup Guide

## Overview

This guide walks you through setting up the CalmFalcon AI Signals Intelligence Pipeline in n8n.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         PIPELINE ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────┐    ┌─────────────────────────────────────────────────────┐   │
│  │ Manual   │───▶│              SOURCE INGESTION                        │   │
│  │ Trigger  │    │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐   │   │
│  └──────────┘    │  │ GitHub  │ │ arXiv   │ │Newsletter│ │ Vendor  │   │   │
│                  │  │   API   │ │   API   │ │   RSS   │ │   RSS   │   │   │
│                  │  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘   │   │
│                  └───────┼──────────┼──────────┼──────────┼──────────┘   │
│                          │          │          │          │              │
│                          ▼          ▼          ▼          ▼              │
│                  ┌─────────────────────────────────────────────────┐     │
│                  │           MERGE & DEDUPLICATE                    │     │
│                  └─────────────────────┬───────────────────────────┘     │
│                                        │                                  │
│                                        ▼                                  │
│                  ┌─────────────────────────────────────────────────┐     │
│                  │         STORE RAW SIGNALS (Supabase)            │     │
│                  └─────────────────────┬───────────────────────────┘     │
│                                        │                                  │
│                  ┌─────────────────────┴───────────────────────────┐     │
│                  │              AI AGENT PIPELINE                   │     │
│                  │  ┌───────────────┐                              │     │
│                  │  │ Theme         │  Claude Opus                 │     │
│                  │  │ Clustering    │  "Identify 5-15 themes"      │     │
│                  │  └───────┬───────┘                              │     │
│                  │          ▼                                       │     │
│                  │  ┌───────────────┐                              │     │
│                  │  │ Confidence    │  Claude Opus                 │     │
│                  │  │ Scoring       │  "Score 0-100%"              │     │
│                  │  └───────┬───────┘                              │     │
│                  │          ▼                                       │     │
│                  │  ┌───────────────┐                              │     │
│                  │  │ Signal        │  Claude Opus                 │     │
│                  │  │ Classification│  "Breaking/Rising/etc"       │     │
│                  │  └───────┬───────┘                              │     │
│                  └──────────┼──────────────────────────────────────┘     │
│                             │                                             │
│                             ▼                                             │
│                  ┌─────────────────────────────────────────────────┐     │
│                  │         STORE THEMES (Supabase)                  │     │
│                  └─────────────────────────────────────────────────┘     │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

### Required Accounts

| Service | Purpose | Signup URL |
|---------|---------|------------|
| **n8n** | Workflow automation | https://n8n.io (self-host or cloud) |
| **Supabase** | Database + Vector DB | https://supabase.com |
| **Anthropic** | Claude Opus API | https://console.anthropic.com |
| **GitHub** | API access (optional but recommended) | https://github.com/settings/tokens |

### API Keys Needed

```
ANTHROPIC_API_KEY=sk-ant-...
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=eyJ...
GITHUB_TOKEN=ghp_... (optional, increases rate limits)
```

---

## Step 1: Set Up Supabase

### 1.1 Create Project

1. Go to https://supabase.com and create a new project
2. Note your project URL and service role key (Settings → API)

### 1.2 Run Database Schema

1. Go to SQL Editor in Supabase dashboard
2. Copy contents of `supabase-schema.sql`
3. Run the SQL to create tables

### 1.3 Verify Tables Created

```sql
-- Run this to verify
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';
```

Expected tables:
- `raw_signals`
- `themes`
- `pipeline_runs`
- `weekly_briefs`

---

## Step 2: Set Up n8n

### 2.1 Install n8n

**Option A: n8n Cloud (Recommended for MVP)**
- Sign up at https://n8n.io
- No installation needed

**Option B: Self-Hosted (Docker)**
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

**Option C: npm**
```bash
npm install n8n -g
n8n start
```

### 2.2 Configure Credentials

In n8n, go to **Settings → Credentials** and add:

#### Anthropic API
1. Click "Add Credential"
2. Search for "Anthropic"
3. Enter your API key
4. Name it: `Anthropic API`

#### Supabase
1. Click "Add Credential"
2. Search for "Supabase"
3. Enter:
   - Host: `your-project.supabase.co`
   - Service Role Key: `your-service-key`
4. Name it: `Supabase Account`

#### GitHub API (Optional)
1. Click "Add Credential"
2. Search for "GitHub"
3. Enter your Personal Access Token
4. Name it: `GitHub API`

---

## Step 3: Import Workflow

### 3.1 Import JSON

1. In n8n, click **"..."** → **"Import from File"**
2. Select `calmfalcon-signals-pipeline.json`
3. Click Import

### 3.2 Update Credential References

After import, you need to connect credentials to nodes:

| Node Name | Credential Type | Select |
|-----------|-----------------|--------|
| GitHub Trending AI Repos | GitHub API | Your GitHub credential |
| Theme Clustering Agent | Anthropic API | Your Anthropic credential |
| Confidence Scoring Agent | Anthropic API | Your Anthropic credential |
| Signal Classification Agent | Anthropic API | Your Anthropic credential |
| Store Raw Signals | Supabase | Your Supabase credential |
| Store Themes | Supabase | Your Supabase credential |
| Store Pipeline Run | Supabase | Your Supabase credential |

### 3.3 Verify Node Connections

1. Click on each node with a warning icon
2. Select the appropriate credential
3. Save the workflow

---

## Step 4: Test the Pipeline

### 4.1 Run Manual Test

1. Click **"Execute Workflow"** button
2. Watch the execution progress
3. Check for errors in any node

### 4.2 Verify Data in Supabase

```sql
-- Check raw signals
SELECT COUNT(*) as signal_count, source_type
FROM raw_signals
GROUP BY source_type;

-- Check themes
SELECT theme_id, title, signal_type, confidence_score
FROM themes
ORDER BY processed_at DESC
LIMIT 10;

-- Check pipeline runs
SELECT * FROM pipeline_runs ORDER BY completed_at DESC LIMIT 5;
```

### 4.3 Expected Output

After successful run:
- **Raw Signals**: 100-200 signals across sources
- **Themes**: 5-15 clustered themes
- **Pipeline Run**: 1 logged run with summary

---

## Step 5: Troubleshooting

### Common Issues

#### Issue: "Anthropic API Error"
**Solution**:
- Verify API key is correct
- Check you have Claude Opus access (may need to request)
- Ensure sufficient API credits

#### Issue: "Supabase Connection Failed"
**Solution**:
- Verify Supabase URL format: `https://xxx.supabase.co`
- Use Service Role key (not anon key)
- Check table names match schema

#### Issue: "GitHub Rate Limit"
**Solution**:
- Add GitHub token credential
- Reduce `per_page` parameter to 30
- Wait and retry (resets hourly)

#### Issue: "RSS Feed Fetch Failed"
**Solution**:
- Some feeds may be temporarily down
- `continueOnFail: true` allows pipeline to continue
- Check feed URLs are valid

#### Issue: "Theme Clustering Returns Empty"
**Solution**:
- Check Claude response in node output
- Verify prompt format
- Increase `maxTokens` if truncated

### Debug Mode

Enable detailed logging:
1. Click on any Code node
2. Add `console.log()` statements
3. Check execution output panel

---

## Step 6: Customize Sources

### Add New Newsletters

Edit the **"Newsletter Sources"** node:

```javascript
const newsletters = [
  // Add your newsletters here
  { name: "Your Newsletter", feed_url: "https://example.com/feed.xml" },
  // ...existing newsletters
];
```

### Add New Vendors

Edit the **"Vendor Doc Sources"** node:

```javascript
const vendors = [
  // Add your vendors here
  { name: "New Vendor", url: "https://vendor.com/blog/rss", type: "rss" },
  // ...existing vendors
];
```

### Modify GitHub Query

Edit the **"GitHub Trending AI Repos"** node query parameters:

```
q: topic:ai topic:llm created:>={{ $now.minus(7, 'days').format('yyyy-MM-dd') }}
sort: stars
per_page: 50
```

---

## Step 7: Production Considerations

### Convert to Scheduled Trigger

Replace Manual Trigger with Schedule Trigger:
1. Delete "Manual Trigger" node
2. Add "Schedule Trigger" node
3. Set cron: `0 6 * * 1` (Every Monday at 6 AM)

### Add Error Notifications

Add Slack/Email notification on failure:
1. Connect "Error Check" true branch to notification node
2. Configure Slack webhook or email

### Enable Retry Logic

All HTTP nodes have:
```json
"retryOnFail": true,
"maxTries": 3,
"waitBetweenTries": 5000
```

### Monitor Costs

Claude Opus pricing considerations:
- ~3 API calls per theme (clustering, scoring, classification)
- ~$0.015 per 1K input tokens, $0.075 per 1K output tokens
- Estimate: $2-5 per full pipeline run

---

## File Structure

```
n8n-workflows/
├── calmfalcon-signals-pipeline.json  # Main n8n workflow
├── supabase-schema.sql               # Database schema
└── SETUP-GUIDE.md                    # This file
```

---

## Next Steps

After successful setup:

1. **Run weekly**: Execute before Demo Day to populate real data
2. **Build frontend**: Connect V0/React frontend to Supabase
3. **Add evaluation flow**: Create accuracy measurement workflow
4. **Iterate on prompts**: Refine clustering/scoring based on output quality

---

## Support

- **n8n Docs**: https://docs.n8n.io
- **Supabase Docs**: https://supabase.com/docs
- **Anthropic Docs**: https://docs.anthropic.com

---

*Last Updated: March 15, 2026*
