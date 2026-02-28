# DECISION_116 Manifest v2 Architecture v1

**Version**: v1  
**Parent Decision**: `STR4TEG15T/decisions/active/DECISION_116.md`  
**Date**: 2026-02-23

## Storage Layout

`STR4TEG15T/memory/manifest/`

- `events/YYYY/MM/DD.jsonl` (append-only event partitions)
- `views/current-state.json`
- `views/by-status/{status}.json`
- `views/by-decision/{DECISION_ID}.json`
- `snapshots/snapshot-YYYYMMDD.json`
- `archive/YYYY/*.jsonl.gz`
- `catalog/archive-catalog.json`

Decision status visibility is provided by generated index artifact:

- `../memory/decision-engine/decision-status-index.json`

## Event Shape (recommended)

```json
{
  "eventId": "evt_20260223_000001",
  "timestamp": "2026-02-23T01:00:00Z",
  "decisionId": "DECISION_114",
  "eventType": "status_changed",
  "actor": "Strategist",
  "payload": {
    "from": "HandoffReady",
    "to": "Validating",
    "reason": "OpenFixer deployment completed"
  },
  "trace": {
    "sourceFile": "STR4TEG15T/decisions/active/DECISION_114.md",
    "correlationId": "dec114-audit-pass"
  }
}
```

## CRUD Routing

- `Create`: append `decision_created` event, refresh by-decision and by-status views.
- `Read`: resolve from views first; replay events only when deep history requested.
- `Update`: append `decision_updated`/`status_changed` events; never in-place mutate event history.
- `Delete`: append `decision_tombstoned` event with retention marker.
- `Archive`: move old daily partitions after snapshot + checksum.

## Compaction Policy (recommended baseline)

- Snapshot every 250 events or every 24h, whichever comes first.
- Archive partitions older than 30 days to compressed store.
- Keep rolling 14-day hot window for fast operational queries.

## Integrity Rules

- Every archive file includes sha256 checksum in catalog.
- Rebuild command must reconstruct `views/current-state.json` from events + latest snapshot.
- Any divergence between rebuild output and current view triggers integrity incident.
