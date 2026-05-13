# 2026-05-13 — Chat-Learnings Feedback Loop

## Summary

`learn-from-chat` and `improve-skills` are now two ends of one closed feedback loop. In-session learnings flow into the canonical log; periodic improvement passes consume the log, triage open entries with discretion, and write terminal statuses back. Restructure-class edits captured mid-session escalate to a single canonical targeted-improvement path.

## Changes

### `improve-skills` (v1.2 → v1.3)

- **New `Modes` section.** Two modes:
  - `FULL_PASS` (default) — the existing whole-library cycle.
  - `TARGETED` — invoked as `improve-skills TARGET=<skill> [SKIP_RESEARCH=true]`. Step 1 scopes validate-skills to TARGET, Step 1b filters chat-learnings to TARGET, Step 2 runs once, Step 3 repairs cross-refs only for the modified skill. `SKIP_RESEARCH=true` skips only Step 2e — never bypasses security, validate, deconflict, size, or close steps.
- **New Step 1b — Ingest Chat Learnings.** Reads `docs/learnings/chat-learnings.md` and assigns exactly one verdict per `Status: OPEN` entry: `IMPLEMENTED (pre-existing)`, `REJECTED (<reason>)`, `DEFERRED (<reason>)`, or keep `OPEN` and attach to a queued skill as a Step 2g input. Triage is presented and requires user confirmation before mutation.
- **Step 2g priority list** now includes "Merge any chat-learnings queued for this skill" as item 2 (cite: `Chat learning [YYYY-MM-DD]`).
- **New Step 2l — Close Chat Learnings.** Every entry that started the pass `OPEN` ends with a terminal status. Silent skipping is treated as a failure.
- **Hard Rule added:** "Chat learnings are an input, not a mandate." Discretion required; every entry closed with a reason.
- **Description and Impact Report** updated to advertise TARGETED mode and the chat-learnings rollup.

### `learn-from-chat` (v1.1 → v1.2)

- **Step 5 escalation gate.** Append-only edits (single bullet to `## Gotchas` / `## Hard Rules`, one-line phrasing fix, citation) stay in-scope. Anything that adds or renumbers a workflow step, restructures a section, introduces a `references/` file, modifies routing triggers, or crosses the 200-line gate MUST escalate to `improve-skills TARGET=<skill> SKIP_RESEARCH=true` and hand off the learning as the queued input.
- **Step 5 200-line gate** now escalates to `improve-skills TARGET=<skill> SKIP_RESEARCH=true` rather than calling `compress-skill` / `split-skill` directly — keeps the targeted-improvement path canonical.
- **Step 6 log template** gains a mandatory `Status` field with five values: `OPEN`, `IMPLEMENTED (<date>, <skill> v<ver>)`, `ESCALATED (improve-skills TARGET=<skill>, <date>)`, `REJECTED (<reason>)`, `DEFERRED (<reason>)`. Initial status is written by `learn-from-chat`; `improve-skills` Step 2l writes terminal statuses on escalated entries.
- **Two new Gotchas** capturing the escalation rule and the status-field requirement.
- **Impact Report** now reports Status.

### `docs/learnings/chat-learnings.md`

- Template updated: `Status` field added with documented value vocabulary and the visibility contract — `improve-skills` Step 1b only triages entries where `Status: OPEN` (or missing).

### Library sync

- `docs/SKILL-INDEX.md` — `improve-skills` and `learn-from-chat` entries rewritten; Call Graph updated for both directions of the loop.
- `docs/skill-graph.md` — added `lfc[learn-from-chat]` node; new edges `lfc → val` (post-apply) and `lfc → imp` (escalation); Meta chain bullet and a new "Targeted improvement loop" bullet describe the closed feedback loop.
- `README.md` — `improve-skills` and `learn-from-chat` rows in the meta skills table updated to reflect modes, statuses, and the escalation path.
- `docs/skill-outputs/SKILL-OUTPUTS.md` — 7 rows appended.

## Migration

- Existing entries in `docs/learnings/chat-learnings.md` without a `Status` field are treated as `OPEN` by `improve-skills` Step 1b. No backfill required; the next improvement pass will triage them.
- No existing skills break: `FULL_PASS` is the default mode, so all current invocations of `improve-skills` continue to work unchanged. The new path is opt-in via `TARGET=<skill>`.

## Verification

```
.agents/skills/improve-skills/SKILL.md       197 lines (≤ 200 ✓)
.agents/skills/learn-from-chat/SKILL.md      180 lines (≤ 200 ✓)
```
