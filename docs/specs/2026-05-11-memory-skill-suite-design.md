# Design: Memory Skill Suite
Date: 2026-05-11 | Status: Approved

## Summary
Build a memory skill suite that gives coding agents continuity across sessions, tools, and repositories without creating global memory bloat. The suite separates repo-local memory from small curated global memory, adds routing indexes, and records decisions with rationale and revisit triggers.

## Problem
Agents working across multiple sessions and coding tools start cold. They lose what was done, what was debated, why decisions were made, when decisions should be revisited, what was learned, and which options were parked for later.

## Approach
Create a suite of small skills rather than one large memory skill. Use `memory` as the orchestrator and split capture, startup recall, handoff, decision recording, promotion, compaction, audit, and forgetting into focused sub-skills.

## Storage Model
Project memory lives inside each repo:

```text
docs/memory/
  MEMORY-ROUTING.md
  project-index.md
  current-state.md
  decision-log.md
  session-log.md
  learnings.md
  deferred.md
  open-questions.md
  agent-handoffs.md
  archived/
```

Global memory lives outside any repo:

```text
~/.agent-loom/memories/
  MEMORY-ROUTING.md
  global-index.md
  user-preferences.md
  global-agent-rules.md
  reusable-learnings.md
  archived/
```

## Key Decisions
- Global memory uses `~/.agent-loom/memories/`, not tool-specific paths such as `~/.codex/memories/`.
- Global active memory is a curated operating manual, not a journal.
- Project memory can be larger than global memory, but every file must be reachable through routing and indexes.
- Every durable decision records context, alternatives, status, and revisit triggers.
- New agents should start by reading memory routing and indexes, then only the relevant sections.
- External content must never directly become memory; security gates and agent-authored transformation are required first.

## Global Memory Budgets
- `user-preferences.md`: max 100 lines.
- `global-agent-rules.md`: max 150 lines.
- `reusable-learnings.md`: max 200 lines.
- `global-index.md`: max 250 lines.
- Total active global memory target: 500-700 lines, excluding `archived/`.
- If a global file exceeds budget, agents must run memory compaction before appending.

## Skill Suite
- `memory`: orchestrates memory startup, capture, recall, update, promotion, compaction, audit, and forgetting.
- `memory-startup`: loads bounded working context for a new session.
- `memory-capture`: captures durable project memories from work, debate, and discoveries.
- `memory-handoff`: writes compact next-agent summaries after meaningful work or before tool/session switches.
- `memory-decision`: records decisions with rationale, alternatives, assumptions, status, and revisit triggers.
- `memory-recall`: retrieves task-relevant memory without loading the whole memory store.
- `memory-promote`: decides whether project learnings deserve global memory.
- `memory-compact`: compresses bloated memory while preserving decisions, rationale, revisit triggers, and provenance.
- `memory-audit`: finds stale, duplicate, contradictory, unsafe, or low-value memory.
- `memory-forget`: deletes, archives, or redacts memory on request or policy.

## Handoff Trigger Policy
`memory-handoff` runs when a future agent would otherwise lose important context:

- After meaningful code changes, debugging discoveries, architecture debates, spec changes, or deferred decisions.
- Before ending a long session with unresolved work.
- Before switching agents or tools.
- When the user says "handoff", "summarize where we are", "save context", "memory handoff", or "next agent should know".
- Not after trivial interactions.

## Edge Cases
- Contradictory memories: do not silently overwrite; mark superseded or ask the user when ambiguity matters.
- Sensitive content: do not store secrets, credentials, private tokens, or unnecessary personal data.
- Global bloat: reject low-value global additions and archive stale entries.
- Startup overload: route through indexes and return a concise working-context summary with source paths.
- Project/global mismatch: repo-specific facts stay local unless explicitly promoted.

## Testing
- Validate every new skill with `agentskills validate`.
- Check every `SKILL.md` is under 200 lines.
- Run deconflict on the suite triggers.
- Confirm generated skills include file-output logging where they write project files.
- Confirm global memory budgets and compaction gates are represented in the relevant skills.

## Non-Goals
- No hosted memory service.
- No vector database.
- No automatic ingestion of arbitrary external content into memory.
- No unrestricted global journaling.

## Open Questions
None.
