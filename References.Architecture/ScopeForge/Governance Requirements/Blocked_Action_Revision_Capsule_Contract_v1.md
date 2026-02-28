# Blocked-Action Revision Capsule Contract (v1)

## Purpose
Defines the mandatory interface and quality gates for blocked-action revision capsules.
This contract is binding for all blocked actions.

## Canonical Schema
- **Schema**: `blockedActionRevisionCapsule_v1.schema.json`
- **Quality gates**: `capsule_quality_checklist.md`

## Mandatory Behavior
- No bypass attempts when blocked.
- Emit the Revision Capsule in the same response as the block.
- Record the capsule to Vault as an append-only event.

## Acceptance Gates
- Capsule validates against the schema.
- Quality checklist is satisfied for completeness and clarity.
- Vault evidence references are attached.
