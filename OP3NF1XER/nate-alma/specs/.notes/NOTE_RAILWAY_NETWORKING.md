---
title: Railway Networking Guide
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - railway
  - networking
  - security
---

How it usually plays out on Railway:

### 1) Internal vs public networking

* **Service-to-service traffic**: can stay internal (your Next.js → OpenClaw/QMD/SFTPGo → MongoDB).
* **Public ports**: you typically only expose the **web app** (Next.js). MongoDB should not be publicly exposed.

### 2) Admin access without opening ports

* For **MongoDB**: use Railway’s tooling/CLI access patterns (or connect from another Railway service), rather than exposing a public DB port.
* For **file ops**: SFTPGo already gives you a controlled interface; Railway’s access tools cover the rest.

### 3) What your final “clean” setup becomes (simple + secure)

* **Service A:** Next.js (public)
* **Service B:** OpenClaw + QMD + SFTPGo (internal)
* **Service C:** MongoDB (internal)

And the website owns auth; OpenClaw becomes a protected backend behind internal calls.