#!/usr/bin/env python3
import argparse
import json
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path


def run(cmd):
    cp = subprocess.run(cmd, capture_output=True, text=True, check=False)
    return cp.returncode, (cp.stdout or "") + (cp.stderr or "")


def speak_windows(text: str, voice: str | None, save: str | None):
    save_line = ""
    if save:
        save_path = str(Path(save).expanduser())
        save_line = "$s.SetOutputToWaveFile('" + save_path.replace("'", "''") + "');"

    voice_line = ""
    if voice:
        v = voice.replace("'", "''")
        voice_line = (
            "$m=$s.GetInstalledVoices()|%{$_.VoiceInfo.Name}|?{$_ -match '"
            + v
            + "'}|Select-Object -First 1; if($m){$s.SelectVoice($m)};"
        )

    script = (
        "Add-Type -AssemblyName System.Speech;"
        "$s=New-Object System.Speech.Synthesis.SpeechSynthesizer;"
        + voice_line
        + save_line
        + "$s.Speak('"
        + text.replace("'", "''")
        + "');"
        + ("$s.SetOutputToDefaultAudioDevice();" if save else "")
    )

    return run(["powershell", "-NoProfile", "-Command", script])


def speak_macos(text: str, voice: str | None, save: str | None):
    cmd = ["say"]
    if voice:
        cmd.extend(["-v", voice])
    if save:
        cmd.extend(["-o", str(Path(save).expanduser())])
    cmd.append(text)
    return run(cmd)


def speak_linux(text: str, voice: str | None, save: str | None):
    if shutil.which("espeak"):
        cmd = ["espeak"]
        if voice:
            cmd.extend(["-v", voice])
        if save:
            cmd.extend(["-w", str(Path(save).expanduser())])
        cmd.append(text)
        return run(cmd)

    if shutil.which("spd-say"):
        cmd = ["spd-say", text]
        return run(cmd)

    return 127, "No Linux speech engine found (espeak/spd-say)."


def main():
    ap = argparse.ArgumentParser(description="SAG local voice storytelling tool")
    ap.add_argument("text", nargs="+", help="Text to speak")
    ap.add_argument("--voice", help="Voice selector (engine-specific)")
    ap.add_argument("--save", help="Optional output wav path")
    args = ap.parse_args()

    text = " ".join(args.text).strip()
    if not text:
        print(json.dumps({"spoken": False, "error": "empty text"}))
        return 1

    if args.save:
        out = Path(args.save).expanduser()
        out.parent.mkdir(parents=True, exist_ok=True)

    system = platform.system().lower()
    if system.startswith("win"):
        code, out = speak_windows(text, args.voice, args.save)
        engine = "powershell-system-speech"
    elif system == "darwin":
        code, out = speak_macos(text, args.voice, args.save)
        engine = "say"
    else:
        code, out = speak_linux(text, args.voice, args.save)
        engine = "espeak/spd-say"

    result = {
        "engine": engine,
        "spoken": code == 0,
        "voice": args.voice or "default",
    }
    if args.save:
        result["savePath"] = str(Path(args.save).expanduser())
    if code != 0:
        result["error"] = out.strip() or f"exit {code}"
        result["hint"] = (
            "Install a local speech engine or use text-only fallback in chat."
        )

    print(json.dumps(result, indent=2))
    return 0 if code == 0 else 2


if __name__ == "__main__":
    sys.exit(main())
