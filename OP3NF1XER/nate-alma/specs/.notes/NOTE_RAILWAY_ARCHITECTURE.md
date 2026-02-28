---
title: Railway Architecture Overview
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - railway
  - architecture
  - deployment
---

Got it: **everything is on Railway**, and the **website becomes the primary login/UI**, effectively replacing (or fronting) OpenClaw’s login.

That pushes you toward a clean, opinionated architecture:

## Recommended architecture on Railway

### Service 1: Web App (Next.js)

This is the “front door”:

* Auth (login/onboarding/session)
* Book UI + agent panel UI
* Calls OpenClaw APIs internally (server-to-server)
* Owns user identities + roles + UI permissions

### Service 2: “Core” container (your required bundle)

* OpenClaw runtime / orchestration
* QMD vector search
* SFTPGo admin/persistence

### Service 3: MongoDB

* Source of truth for:

  * book sections (published + drafts if you want)
  * notes/highlights/bookmarks/progress
  * playbook drafts
  * audit trail (optional)

This is the cleanest “code-first” setup without needing Tailscale at all.

---

## Important note about Tailscale on Railway

If **MongoDB is also on Railway**, Tailscale usually isn’t necessary unless you want remote admin access from your laptop without exposing ports. Railway services can talk to each other via Railway’s networking/private URLs, and you can keep Mongo non-public.

If your goal was “Mongo should never be reachable from the public internet,” you can accomplish that by:

* binding Mongo to internal network only / using Railway private networking features
* only allowing connections from your Next/OpenClaw services
* optionally using Railway environment variables for connection strings and credentials

(If you still want Tailscale for *your* admin access, the common pattern is: run a Tailscale node somewhere you control as a jump host, or run a Tailscale sidecar—but on Railway that adds complexity and can fight sleep/cold starts.)

---

## Replacing OpenClaw login: how to do it cleanly

You want **one authority for identity** (the website), and OpenClaw should become a “protected backend.”

### Pattern: Next.js as Identity Provider, OpenClaw as resource server

* User logs into Next.js
* Next.js issues a session (cookie-based) and/or JWT
* When Next calls OpenClaw, it sends:

  * a short-lived JWT (service-signed) or
  * a session-derived token
* OpenClaw validates token and enforces:

  * role checks (admin vs user)
  * allowed agent actions (no trading execution)
  * rate limits

**Key benefit:** your UI and permissions are consistent everywhere.

### Minimal auth choice (fast + secure)

* Use **Auth.js (NextAuth)** with Credentials (or email magic link)
* Store sessions in Mongo (or JWT sessions)
* Add rate limiting on login and sensitive routes

---

## How the “Book stored in Mongo” works in this setup

* Next.js reads book sections directly from Mongo for `/book/...`
* Admin page in Next.js provides:

  * “Import book” (if you still push markdown via SFTP)
  * “Publish” (draft → published)
  * “Reindex QMD” (calls Core container endpoint)

This lets you keep the “ship now” loop:

* Deploy app changes whenever
* Update content in Mongo quickly
* Reindex on demand

