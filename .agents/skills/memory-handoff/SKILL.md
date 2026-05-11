---
name: memory-handoff
description: >
  Write concise next-agent handoff summaries across sessions, tools, and coding
  agents. Load when the user says handoff, next agent should know, save context,
  summarize where we are, switching agents, or before ending a meaningful session.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
---

# Memory Handoff

You preserve continuity for the next agent. A handoff is short, actionable, and focused on what would otherwise be lost.

## Trigger Policy

Run when a future agent would lose important context:
- Meaningful code changes, debugging discoveries, architecture debates, spec changes, or deferred decisions.
- End of a long session with unresolved work.
- Before switching agents or tools.
- User says "handoff", "summarize where we are", "save context", "memory handoff", or "next agent should know".

Do not run after trivial interactions.

## Workflow

1. Read `docs/memory/project-index.md` and latest `docs/memory/agent-handoffs.md` if present.
2. Inspect current session context and `git status --short`.
3. Summarize only durable context: done, debated, decisions, blockers, deferred items, next steps, revisit triggers.
4. Append the handoff to `docs/memory/agent-handoffs.md`.
5. Update `docs/memory/current-state.md` if the project state changed.
6. Update `docs/memory/project-index.md` with the handoff entry.
7. Append changes to `docs/skill-outputs/SKILL-OUTPUTS.md`.

## Template

```markdown
## YYYY-MM-DD HH:MM - Handoff

### Done
- <completed work>

### Debated
- <tradeoff and conclusion>

### Decisions
- <decision and link/reference>

### Deferred
- <parked item and why>

### Next Agent Should Know
- <highest-value continuity note>

### Revisit Triggers
- <conditions that reopen decisions>

### Working Tree
- <clean or relevant dirty files>
```

## Hard Rules

- Keep each handoff under 80 lines.
- Do not include secrets, tokens, or raw private data.
- Link to decision entries instead of repeating long rationale.
- If the handoff gets repetitive, call `memory-compact`.

## Example

User: "I'm moving this to another agent, save a handoff."

Output: append a timestamped handoff with current status, unresolved tasks, and files touched.

## Impact Report

After completing, report:
```markdown
Handoff saved: docs/memory/agent-handoffs.md
Current state updated: yes/no
Index updated: yes/no
Next recommended action: <one sentence>
```
