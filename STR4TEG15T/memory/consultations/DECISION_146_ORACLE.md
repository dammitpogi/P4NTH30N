---
type: consultation
id: DECISION_146_ORACLE
parent: DECISION_146
consultant: Oracle
status: complete
created_at: '2026-02-27T00:40:00Z'
---

# DECISION_146 Oracle Consultation (Security)

## Core Findings

- Railway SSH is a **custom WebSocket protocol**; do not expect standard SSH features (no SCP/SFTP/port-forwarding).
- Public TCP exposure is via **TCP Proxy**; external endpoint is assigned **host:port**. Do not assume public `:2022`.
- Avoid exposing OpenSSH by default; it expands surface area and is redundant if `railway ssh` is available.

## SFTPGo Hardening (Mandatory)

- Disable password + keyboard-interactive auth; require SSH public keys.
- Disable/bind HTTP admin/client/REST surfaces to localhost (or disable entirely). Also prevents 8080 collision with OpenClaw wrapper.
- Restrict SFTP root to `/data/workspace` (or narrower). Treat anything reachable by SFTP as eventually readable by an attacker.
- Prevent SFTP compromise from exposing OpenClaw state: `/data/.openclaw` must not be readable by the SFTP runtime identity.

## Top Risks (Merged Container)

- Internet-exposed SFTP brute-force → key-only + defender + finite auth tries.
- Shared volume → SFTP compromise becomes OpenClaw token/state exfil → split perms and restrict directories.
- Setup password leak (`SETUP_PASSWORD`) → treat as break-glass secret, rotate and limit distribution.
- Supply chain drift (`latest` installs) → pin versions, record build provenance.
- RAG injection and untrusted retrieval content → treat retrieved docs as untrusted evidence.

## Required Gates Before “Ready”

- TCP Proxy endpoint recorded in `OP3NF1XER/nate-alma/dev/TOOLS.md` (host:port).
- SFTPGo hardened (key-only) and verified by a real login attempt.
- Volume isolation verified (SFTP user cannot read OpenClaw state).
- `/setup` auth gate verified; `/healthz` verified; logs show both services started.
