# Textbook Site Exposure Plan

Target base URL:

- `https://clawdbot-railway-template-production-461f.up.railway.app`

Planned textbook route:

- `/textbook/`

## Railway exposure steps

1. Ensure service is linked and authenticated in Railway CLI.
2. Add static route mapping (or web server middleware) for `memory/alma-teachings/site/`.
3. Verify `GET /textbook/` returns `index.html`.
4. Validate link references and doctrine file paths.
5. Confirm `textbookCheck.routeKind == textbook-static` from probe output.

## Endpoint verification

```bash
python skills/openclaw-endpoint-kit/scripts/endpoint_probe.py --base "https://clawdbot-railway-template-production-461f.up.railway.app"
```
