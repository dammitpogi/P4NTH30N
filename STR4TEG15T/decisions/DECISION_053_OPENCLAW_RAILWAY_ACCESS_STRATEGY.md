# DECISION_053: OpenClaw Railway Access and Recovery Control Plane

**Decision ID**: DECISION_053  
**Category**: INFRA  
**Status**: Approved  
**Priority**: High  
**Date**: 2026-02-23  
**Oracle Approval**: 74/100 (risk posture favors deterministic rollback path)  
**Designer Approval**: 82/100 (workflow feasibility and operator ergonomics)

---

## Executive Summary

To keep DECISION_052 workflow-compliant and executable with current agent reality (`@openfixer` + Nexus only), this decision defines the recovery control plane choice between Railway Web UI and Railway Public API.

Decision outcome: use **Web UI first** for immediate outage recovery in this pass, with optional **API follow-up** once a Railway token is available for repeatable automation.

---

## Documentation Findings

### OpenClaw (Railway deployment)

- OpenClaw Railway deployment requires HTTP proxy on port `8080`, plus `PORT=8080` alignment.
- Required setup baseline includes `SETUP_PASSWORD`, recommended persistent volume at `/data`, and recommended state/workspace variables.
- Primary operational surfaces on Railway-hosted OpenClaw are `/setup` and `/openclaw`.

Source: `https://docs.openclaw.ai/install/railway.md`

### Railway (rollback + API)

- Railway dashboard supports deployment rollback from Deployments list.
- Rollback restores prior successful deployment image and custom variables (within retention limits).
- Railway GraphQL Public API supports deployment listing/log retrieval and mutations including `deploymentRollback`, `deploymentRestart`, and `deploymentRedeploy`.

Sources:
- `https://docs.railway.com/deployments/deployment-actions`
- `https://docs.railway.com/integrations/api/manage-deployments`

---

## Decision

1. **Primary control plane now**: Railway Web UI via OpenFixer browser flow.
2. **Secondary control plane**: Railway API only after Nexus provides token scope suitable for deployment actions.
3. **Workflow gate**: no deployment action until Nexus issues explicit initiation using the OpenFixer handoff prompt.

Rationale:
- Credentials currently provided are username/password, not API token.
- Web UI path has lower setup friction for first restore.
- API path is stronger for repeatability/auditing, but blocked by token availability.

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-053-01 | Prepare OpenFixer web recovery prompt (v2) | Strategist | Completed | High |
| ACT-053-02 | Obtain Nexus decision for control plane (Web now vs API token first) | Nexus | Pending | High |
| ACT-053-03 | If API chosen, collect Railway token and validate deployment mutation scope | Nexus/OpenFixer | Pending | Medium |
| ACT-053-04 | Feed selected control plane back into DECISION_052 and mark HandoffReady | Strategist | Pending | High |

---

## Pass Questions (Harden / Expand / Narrow)

- Harden: Do we require a minimum rollback retention window standard so restore options are always visible?
- Expand: Should we add a small OpenFixer script/template for Railway GraphQL rollback to standardize future incidents?
- Narrow: For this incident, is immediate restore-only scope acceptable, deferring prevention automation to post-recovery?

---

## Closure Checklist Draft

- [ ] DECISION_052 references OpenFixer-only execution reality
- [ ] OpenFixer handoff prompt path recorded and copy-paste ready
- [ ] Nexus chooses control plane for this run (Web/API)
- [ ] Deployment evidence recorded in journal before closure
- [ ] Manifest timestamp updated for strategist pass

---

*Decision DECISION_053*  
*OpenClaw Railway Access and Recovery Control Plane*  
*2026-02-23*
