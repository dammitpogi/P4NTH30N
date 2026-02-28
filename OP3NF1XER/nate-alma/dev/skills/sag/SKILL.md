---
name: sag
description: Local voice storytelling command for short spoken updates and cinematic summaries. Uses system TTS with optional audio file output.
---

# SAG Voice Tool

Use this when you want quick spoken summaries instead of long text walls.

## Command

```bash
python skills/sag/scripts/sag.py "OpenFixer report: deployment green." 
python skills/sag/scripts/sag.py --voice onyx --save memory/voice/pantheon.wav "Pantheon hello"
```

## Wrapper shortcuts

- Windows: `tools/sag/sag.cmd "hello"`
- POSIX: `tools/sag/sag "hello"`

## Behavior

- Windows: uses PowerShell `System.Speech`.
- macOS: uses `say`.
- Linux: uses `espeak` or `spd-say` when available.
- If no speech engine is found, it prints text and returns guidance.

## Output contract

The tool prints JSON with `engine`, `spoken`, and optional `savePath` so operator logs can show what happened.
