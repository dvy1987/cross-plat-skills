# Changelog: Memory Skill Suite
Date: 2026-05-11

## Summary
Added a 10-skill memory suite for cross-agent continuity across sessions, tools, and repositories.

## Added
- `memory`: orchestrates memory startup, recall, capture, handoff, decisions, promotion, compaction, audit, and forgetting.
- `memory-startup`: loads bounded working context from routing/index files before new work.
- `memory-capture`: saves durable project memory while rejecting trivial, sensitive, duplicate, or obvious content.
- `memory-handoff`: writes compact next-agent handoffs after meaningful work or before switching agents/tools.
- `memory-decision`: records decisions with rationale, alternatives, assumptions, status, and revisit triggers.
- `memory-recall`: retrieves task-relevant memory without loading the whole store.
- `memory-promote`: gates local-to-global memory promotion into `~/.agent-loom/memories/`.
- `memory-compact`: enforces project/global memory compaction and strict global size budgets.
- `memory-audit`: audits memory health, stale entries, contradictions, routing, and bloat.
- `memory-forget`: deletes, redacts, archives, or retires memory.

## Why It Matters
New agents no longer need to infer prior work from chat fragments or git diffs alone. The suite gives them a bounded way to recover current state, debated tradeoffs, decisions, deferred options, and revisit triggers.

## Global Memory Discipline
Global memory is intentionally small: `~/.agent-loom/memories/` is a curated operating manual, not a journal. The suite requires compaction before over-budget writes.

## Validation
- Line counts: verified via `wc -l .agents/skills/memory*/SKILL.md` — all new SKILL.md files ≤200 lines (largest: `memory` at 101).
- `agentskills validate`: not run (CLI not installed in this environment).
