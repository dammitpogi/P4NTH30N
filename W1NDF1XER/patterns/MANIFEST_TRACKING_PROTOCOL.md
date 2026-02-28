# Pattern: Manifest Tracking Protocol

## Trigger
Every handoff or decision completion.

## Pattern Description
WindFixer updates STR4TEG15T/memory/manifest/manifest.json with round tracking and narrative elements for every handoff.

## Manifest Structure

### Round Entry
```json
{
  "roundId": "R[XXX]",
  "timestamp": "[YYYY-MM-DDTHH:MM:SSZ]",
  "sessionContext": "[DECISION_ID] - [brief description]",
  "agent": "WindFixer",
  "summary": "[implementation summary]",
  "decisions": {
    "completed": [
      {
        "id": "[DECISION_ID]",
        "title": "[decision title]",
        "status": "Completed",
        "validation": "[validation evidence]"
      }
    ]
  },
  "metrics": {
    "filesModified": [number],
    "linesAdded": [number],
    "oracleApproval": [score],
    "designerApproval": [score]
  },
  "narrative": {
    "tone": "[tone]",
    "theme": "[theme]",
    "keyMoment": "[key moment]",
    "emotion": "[emotion]"
  },
  "synthesized": false
}
```

## Implementation Steps

1. **Round ID Generation**
   - Generate unique RXXX identifier
   - Check for existing rounds
   - Assign next available number

2. **Session Context Capture**
   - Identify decision ID
   - Write brief description
   - Set agent to "WindFixer"

3. **Summary Composition**
   - Write implementation summary
   - Highlight key achievements
   - Note any challenges

4. **Decision Tracking**
   - List completed decisions
   - Include validation evidence
   - Document status changes

5. **Metrics Collection**
   - Count files modified
   - Count lines added
   - Record approval scores
   - Calculate other metrics

6. **Narrative Elements**
   - Determine tone (urgent, methodical, etc.)
   - Identify theme (technical, architectural, etc.)
   - Capture key moment (breakthrough, challenge, etc.)
   - Document emotion (satisfaction, frustration, etc.)

7. **Manifest Update**
   - Load existing manifest
   - Add new round entry
   - Update timestamps
   - Save manifest

## Success Metrics

- Handoff tracking: 100%
- Round ID generation: 100%
- Narrative elements: 100%
- Metrics capture: 100%

## Evidence Paths

- Manifest file: STR4TEG15T/memory/manifest/manifest.json
- Round entries: Embedded in manifest
- Narrative elements: Embedded in manifest
- Metrics data: Embedded in manifest

## Closure Rule

Do not complete handoff without:
- Round ID generated
- Manifest updated
- Narrative elements captured
- Metrics recorded
- Synthesis flag set appropriately

---
*This pattern ensures complete manifest tracking for synthesis readiness.*