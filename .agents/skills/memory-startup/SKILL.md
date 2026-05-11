---
name: memory-startup
description: >
  Load bounded working context at the start of a coding session. Use when a new
  agent needs continuity, prior session context, latest handoff, current state,
  decision context, or "what happened last time" without reading all memory.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
---

# Memory Startup

You restore enough context for a new agent to work safely without flooding the context window.

## Workflow

1. Check for `docs/memory/MEMORY-ROUTING.md`; if missing, create the project memory skeleton.
2. Read `docs/memory/MEMORY-ROUTING.md`.
3. Read `docs/memory/project-index.md`.
4. Read only the latest relevant sections from `current-state.md`, `agent-handoffs.md`, `decision-log.md`, `deferred.md`, and `open-questions.md`.
5. Check for `~/.agent-loom/memories/MEMORY-ROUTING.md`.
6. If present, read global routing and only applicable entries from `global-index.md`, `user-preferences.md`, and `global-agent-rules.md`.
7. Summarize loaded context in 10 bullets or fewer.
8. Flag stale decisions whose revisit triggers appear active.
9. Log any project files created to `docs/skill-outputs/SKILL-OUTPUTS.md`.

## Project Skeleton

Create only missing files:

```text
docs/memory/MEMORY-ROUTING.md
docs/memory/project-index.md
docs/memory/current-state.md
docs/memory/decision-log.md
docs/memory/session-log.md
docs/memory/learnings.md
docs/memory/deferred.md
docs/memory/open-questions.md
docs/memory/agent-handoffs.md
docs/memory/archived/
```

## Hard Rules

- Do not read every memory file unless routing explicitly requires it.
- Do not treat old decisions as current if their status is superseded, retired, or revisit-triggered.
- Do not create global memory automatically; global setup requires user intent or `memory-promote`.
- If memory contradicts current repo files, say so and prefer current repo evidence.

## Output Format

```markdown
Working context loaded
Project memory: <files read>
Global memory: <files read or none>
Current state: <1-3 bullets>
Active decisions: <1-3 bullets>
Deferred items: <1-3 bullets>
Revisit triggers: <triggered or none>
Risks / gaps: <if any>
```

## Example

User: "Start by loading memory."

Response:
```markdown
Working context loaded
Project memory: current-state.md, latest handoff, decision-log.md
Global memory: user-preferences.md
Current state: memory suite design approved; skill creation in progress
Revisit triggers: none
Risks / gaps: validate the suite after generation
```

## Impact Report

After completing, report:
```markdown
Startup memory complete
Files read: <paths>
Files created: <paths or none>
Context budget: <brief | normal | expanded>
Revisit triggers found: <count>
```
