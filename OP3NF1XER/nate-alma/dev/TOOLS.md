# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

## Alma Local Setup Notes

### Group / Channel

- Telegram group label: `nate and Alma`
- Group id: `-5107377381`
- Desired group config: `requireMention: false`, `groupPolicy: open`

### Trading Data

- Market data output root: `/data/workspace/trading/market-data/`
- Setup quick summary file: `/data/workspace/trading/market-data/context.md`
- Symbol coverage target: `SPY`, `SPX`, `ES`, `XSP`, `VIX`, `VVIX`

### Scripts and Utility Paths

- SSH probe: `../tools/railway-ssh.ps1`
- Remote config ops: `../tools/openclaw-config-over-ssh.ps1`
- Remote pull snapshot: `../tools/pull-remote-state.ps1`
- Remote push bundle: `../tools/push-remote-bundle.ps1`
- Story voice tool: `tools/sag/`
- Chat-log ops kit: `skills/nate-agent-ops-kit/`

### Voice Preference

- Storytelling tone preference captured: warm/raspy female voice

### Time and Scheduling

- Human timezone: Mountain Time
- Runtime/infrastructure timezone context: Railway UTC
- Pre-market prep target: ~07:00 MT

## Security Note

Do not place passwords or bearer tokens in this file.

Use `python skills/auth-vault/scripts/vault.py ...` for credentials and OAuth token handling.

Vault path: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/.secrets/auth-vault`

Generate Alma key (encrypted):

- `python skills/auth-vault/scripts/vault.py generate-key --name alma-agent-master-key --kind api-key --provider alma --prefix "alma_" --reveal`
- `python skills/auth-vault/scripts/update_bible_login.py --username "nate" --password "..."` (updates `nate-bible-site-login`)

Skills runtime sanity kit:

- Full scan: `python skills/script-sanity-kit/scripts/chaos_audit.py`
- Guarded run: `python skills/script-sanity-kit/scripts/run_with_sanity.py --script skills/<skill>/scripts/<file> -- <args>`
