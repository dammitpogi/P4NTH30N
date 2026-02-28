# Substack Teachings Capture Toolkit

Captures Alma's Substack posts and context comments into searchable files with an OTP handoff workflow.

## Features

- **Session persistence**: Logs in once, saves cookies, reuses them
- **Rate limiting**: 2-second delays between requests to avoid triggering limits
- **Organized output**: Saves comments to `memory/substack/` grouped by date
- **Searchable**: Markdown format lets Dash search and reference comments

## Installation

Already installed! Playwright + Chromium are ready.

## Usage

### Recommended (OTP handoff, then capture)

1) Launch to OTP stage (assistant/operator enters email and stops):

```bash
node otp-handoff-launch.js
```

2) User completes OTP and password manually in the opened browser window.

3) Run post-auth capture only (no re-login):

```bash
node post-auth-capture.js
```

This flow is hardened for `Email -> OTP -> Password` ordering and avoids login-loop regressions.

### Doctrine package in OpenClaw workspace

The companion doctrine artifacts are available at:

`memory/substack/doctrine/`

Includes AI Bible v2, Textbook v2, interaction index, capture completion
report, delivery package, and a P4NTHE0N intro note for Nate and Alma.

### Agent-indexed doctrine layer (new)

Use these companion skills for fast doctrine retrieval and citation:

- `skills/doctrine-engine/`
- `skills/openclaw-endpoint-kit/`

Core commands:

```bash
python skills/doctrine-engine/scripts/rebuild_index.py
python skills/doctrine-engine/scripts/search_bible.py --query "fomc pivot invalidation"
python skills/doctrine-engine/scripts/cite_doctrine.py --doc bible-v3 --query "event pressure"
python skills/doctrine-engine/scripts/query_decision_engine.py --query "railway auth token"
python skills/openclaw-endpoint-kit/scripts/endpoint_probe.py --base "https://clawdbot-railway-template-production-461f.up.railway.app"
```

### Legacy direct login mode (less reliable)

```bash
node scraper.js "your-email@example.com" "your-password"
```

This will:
1. Login to Substack
2. Save session cookies to `session-cookies.json`
3. Scrape all posts for Alma's comments
4. Save to `memory/substack/*.md`

### Reuse cookies mode

```bash
node scraper.js "your-email@example.com" "your-password" --reuse-cookies
```

Much faster - skips login, uses saved session.

### Update Comments

Run the same command again. It will:
- Reuse your existing session (no re-login)
- Scrape any new posts/comments
- Overwrite files with latest data

## Output

```
memory/substack/
  <date>-<post-title>.md
  all-posts.json
  all-comments.json (legacy comment extractor)
```

Each markdown file contains:
- Date/timestamp
- Full comment text
- Organized chronologically

## Security

- Cookies saved locally in `session-cookies.json`
- Password not stored anywhere after initial login
- Delete `session-cookies.json` to force re-login

## UI Decision Evidence

- `auto-enter-creds.js` enforces gate order and writes evidence:
  - `ui-decision-log.jsonl`
  - `ui-step-*.png`
- Use this when diagnosing OTP/rate-limit behavior.

## Troubleshooting

**"No comments found"**: The page selectors may need adjustment. Substack occasionally changes their HTML structure. Check the console output for clues.

**Rate limits**: The script has built-in 2-second delays. If you still hit limits, increase `DELAY_MS` in the script.

**Login fails**: Make sure you're using the correct email/password. If you have 2FA enabled, you may need to disable it temporarily or adjust the script.

## Future Enhancements

- Detect new comments only (incremental scraping)
- Better date parsing
- Telegram notifications when new comments arrive
- Filter by topic/keywords
