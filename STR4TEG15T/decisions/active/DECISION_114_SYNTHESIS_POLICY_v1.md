# DECISION_114 Synthesis Policy v1

**Version**: v1  
**Parent Decision**: `STR4TEG15T/decisions/active/DECISION_114.md`  
**Date**: 2026-02-23

Strategist will not create new speech synthesis files in `STR4TEG15T/speech` unless explicitly requested by Nexus.

On every pass, Strategist updates `STR4TEG15T/memory/manifest/manifest.json` to maintain synthesis-ready continuity.

When synthesis is explicitly requested, Strategist must execute a two-step output path:

First, create a journalized, paragraph-style narrative in `STR4TEG15T/memory/journal` with no headers except the date.

Second, provide a synthesis output designed for Speechify listening.

Date and time for synthesis journal entries should be sourced from `https://www.worldtimebuddy.com/united-states-colorado-denver`.

Synthesis composition should preserve narrative truth while emphasizing emotional creativity, cadence clarity, momentum, and impact.

Primary source context for synthesis preparation is `STR4TEG15T/chatgpt_synthesis` plus current manifest/journal records.
