---
title: MongoDB Book Storage Architecture
kind: note
status: draft
last_updated: 2026-02-28
topics:
  - mongodb
  - architecture
  - tailscale
---

Got it — **MongoDB-backed book content over a Tailscale connection** is a totally workable “code-first” approach, and it pairs nicely with App Router **if you design for caching + reindex + offline fallback**.

Here’s the cleanest way to think about it.

## What this implies (and why it’s good)

**You’re moving the “source of truth” for the book from filesystem → database.**
That buys you:

* consistent content reads across environments
* easy versioning, publishing workflows, and auditing
* no reliance on Railway ephemeral disk
* content updates can be pushed from your side over Tailscale without exposing Mongo to the public internet

## Recommended MongoDB model for the book

Use a “document per section” design:

### Collections

* `book_sections`

  * `_id`
  * `partIndex`, `chapterIndex`, `sectionIndex`
  * `partSlug`, `chapterSlug`, `sectionSlug`
  * `title`
  * `bodyMarkdown` (or MDX)
  * `frontmatter` (summary/checklist/mistakes/drill/tags/playbooks)
  * `headingIndex` (optional: `{ id, text, level }[]` for TOC + deep-links)
  * `version` (int or semver string)
  * `status` (`draft | review | published`)
  * `publishedAt`, `updatedAt`

* `book_structure` (optional, but useful)

  * single doc representing Parts/Chapters metadata, ordering, display names

* `book_assets` (optional)

  * images/attachments metadata (store binary elsewhere, keep refs here)

### Indexes (important)

* Unique index on `(partSlug, chapterSlug, sectionSlug, version?)`
* Index on `status` + ordering fields
* Text index (optional) for fallback search; QMD is still your best search

## App Router integration (fast + “OpenAI-ish” reader)

* **Server Components** fetch the section from Mongo directly for `/book/[...slug]`.
* Render markdown → HTML (remark/rehype or MDX).
* Use your **BookShell** (left TOC, center prose, right agent panel) to keep the experience “full but breathable.”

### Caching rules (so it’s fast and not stale)

Because book content changes via SFTP + publish flow:

* Default to **no-store** or short revalidate for `/book` routes during active editing.
* Add an **Admin “Publish + Reindex”** action that:

  1. marks sections as published (or bumps version)
  2. regenerates TOC snapshot (optional)
  3. triggers QMD reindex
  4. calls `revalidateTag('book')` / `revalidatePath('/book')` so Next refreshes cached pages

(If you don’t want to think about caching early: just run with `no-store` first. Optimize later.)

## Tailscale: the right shape

For “Mongo accessible only to your private network”:

* Run Mongo somewhere reachable from the app:

  * **Option A (best):** MongoDB hosted on a VPS/home box + Tailscale, app connects via Tailscale IP/DNS
  * **Option B:** Mongo inside Railway private network isn’t directly “Tailscale-friendly” unless you run a Tailscale node/subnet router bridging networks

### Key details

* Use **Tailscale MagicDNS** so your app connects to `mongo.tailnet-xyz.ts.net` instead of hardcoding IPs.
* Lock Mongo down to **bind only to Tailscale interface** (or firewall to tailnet).
* Treat Tailscale as **transport**, still use Mongo auth + TLS where possible.

## Practical caution (one thing to watch)

Railway services can **sleep**, and Tailscale connections can be fine with that, but your app needs to handle:

* initial connection latency (cold start)
* reconnect logic
* timeouts tuned sanely

If your Mongo lives outside Railway, your app sleep/wake is fine; it just reconnects when it wakes.

## How your “SFTP deploy” fits now

Since book lives in Mongo, SFTP becomes:

* deploying app changes
* and/or uploading book changes to a **content importer** (admin-only) that writes to Mongo

Typical workflow:

1. You edit markdown in git
2. You deploy app via SFTP
3. You run an “Import Book” job (admin button or CLI) that:

   * upserts sections into Mongo
   * computes headingIndex
   * optionally sets status=draft
4. You “Publish” (promotes to published + reindex QMD)

## One recommendation to keep you from pain

Even if Mongo is your source of truth, keep a **minimal “seed export”** of the book in your repo:

* lets you bootstrap a new environment instantly
* gives you a fallback if Mongo is unreachable
* makes local dev dead simple
