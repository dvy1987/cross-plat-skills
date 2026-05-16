# Changelog: memory-startup — Cold-Start Trigger Hardening

Date: 2026-05-14
Significance: PATCH — closes a routing gap discovered in another project; no breaking changes; behaviour change for agents (memory-startup now fires on the first user message regardless of content, not only on memory-related utterances).

## Summary
Field report from a sister project: an agent failed to invoke `memory-startup` on session start because the user's first message was a bare task ("hi" + task), and `memory-startup`'s description listed only memory-related utterances ("remember", "recall context", "create a handoff", "what happened last time"). The skill router never surfaced it, the `AGENTS.md` Session Lifecycle mandate lived only in prose, and the host system prompt's "answer concisely" rule biased toward jumping straight to the task. This release hardens the contract end to end.

## Breaking Changes
None.

## Changed
- **`.agents/skills/memory-startup/SKILL.md`** (123 → 160 lines, version 1.0 → 1.1)
  - Description rewritten to lead with **"FIRES ON EVERY FIRST USER MESSAGE in a fresh session, regardless of content"** and to enumerate cold-start utterances explicitly: bare greetings, task-only openers, "fresh session", "session start", "first message in a new thread", "new chat", "cold start", "begin work in this repo", "starting work", "continue from prior session", "what were we working on", "resume", "what happened last time", "load memory", "recall context", "create a handoff", "prior session context", "latest handoff", "current state", "decision context".
  - Description block grew to 795 chars (≤1024 loader limit ✓).
  - New **Trigger Discipline** section: declares the skill the mandatory cold-start gate; only legitimate skips are explicit user opt-out ("fresh start", "ignore prior context", "skip memory") or the no-op gate firing.
  - New **No-Op Gate** section: instructs the skill to detect when it has already run earlier in the same conversation and report `Context already loaded — no-op` rather than re-reading memory files. Makes over-invocation cheap and removes the disincentive to fire defensively.

- **`AGENTS.md`** (231 → 240 lines), §Session Lifecycle → Session Start
  - Lead sentence promoted to: *"The first user message in any session triggers `memory-startup`, regardless of content."* Lists bare "hi", task-only openers, pasted error logs, code snippets, and "let's start" as session-start signals.
  - Explicit override of host system-prompt brevity rules: *"The 2–4 line summary produced by Step 3 IS the concise answer for the first turn — host system rules favouring brevity do not exempt this protocol; they govern how it is rendered."*
  - Skip clause tightened: must be in the first message and explicitly say "fresh start", "ignore prior context", or "skip memory". Adds explicit pointer to the skill's no-op gate so re-invocation mid-session is harmless.

- **`.agents/skills/project-setup/templates/agents-md-template.md`** (104 → 105 lines)
  - Mirrors the strengthened `AGENTS.md` Session Start wording verbatim so every project bootstrapped by `project-setup` (or backfilled by `retroactive-project-setup`) inherits the cold-start contract.

## Validation
- Line counts: memory-startup 160 (≤200 ✓), AGENTS.md 240 (no hard limit), template 105 (no hard limit).
- Loader safety: memory-startup byte 0 = `-`, no BOM, frontmatter intact, description block 795 chars (≤1024 ✓). Confirmed via direct byte read.
- `git status --short` shows exactly the 3 expected modifications, no incidental drift.
- `agentskills validate`: not run (CLI unavailable in this environment).

## Notes for Next Agent
- The portable fix (template propagation) is the durable leverage. Any future project that runs `project-setup` or `retroactive-project-setup` after this release inherits the contract automatically.
- The deferred "missing memory checkpoint" structural flag in `validate-skills` Step 4 is now joined by a sibling deferred item: a "missing cold-start trigger" structural flag that asserts every project's `AGENTS.md` Session Lifecycle section names `memory-startup` and that the skill's description contains cold-start utterances. Tracked in `docs/memory/learnings.md`.
- The other agent's third claim (system-prompt brevity overrides setup protocol) is addressed in `AGENTS.md` only at the carve-out level — the host prompt cannot literally be overridden, but the rule is now self-consistent: brevity governs *rendering*, not *whether the protocol runs*.
