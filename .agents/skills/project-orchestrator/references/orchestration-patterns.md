# Orchestration Patterns

Reference for how to decompose and parallelise work across platforms.

## Pattern 1 — Sequential Chain (Default, All Platforms)

Use when tasks have dependencies. Output of skill N feeds input of skill N+1.

```
product-soul → brainstorming → prd-writing → implementation-plan → code
```

Each skill reads the previous skill's output file. No parallelism needed.
Coordination: skill-outputs/SKILL-OUTPUTS.md tracks what was produced.

## Pattern 2 — Fan-Out / Fan-In (Tier 1 Platforms Only)

Use when a plan has independent implementation tracks.

```
                    ┌→ Subagent A (auth module)      ─┐
implementation-plan ┼→ Subagent B (API layer)        ─┼→ Synthesise → Review
                    └→ Subagent C (frontend scaffold) ─┘
```

Requirements for safe fan-out:
- Each subagent writes to non-overlapping directories
- Each subagent has a specific, scoped prompt (not "implement everything")
- Each subagent gets the shared context file (PRD/plan) but its own file scope
- Parent orchestrator collects results and runs integration check

## Pattern 3 — Parallel Review (Tier 1+2 Platforms)

Use for multi-dimension review of existing code or documents.

```
             ┌→ security review (secure-skill)
document/code┼→ technical debt (technical-debt-audit)
             └→ adversarial critique (adversarial-hat)
```

Safe because reviews are read-only. Results feed into a synthesis step.

## Pattern 4 — Thinking then Doing (All Platforms)

Use when uncertainty is high before executing.

```
deep-thinking → [framework selected] → [insight produced] → skill execution
```

The thinking phase is always sequential (one framework at a time).
The doing phase may parallelise if the insight unblocks independent work.

## Pattern 5 — File-Based Task Queue (Universal Fallback)

Use on any platform, especially Tier 2-3.

Write `docs/task-plan.md`:
```markdown
| # | Task | Skill | Status | Depends On | Assigned To | Output |
|---|------|-------|--------|------------|-------------|--------|
| 1 | Write product soul | product-soul | DONE | — | — | docs/product-soul.md |
| 2 | Design auth flow | brainstorming | IN_PROGRESS | #1 | — | docs/specs/auth-design.md |
| 3 | Design data model | brainstorming | PENDING | #1 | — | docs/specs/data-design.md |
| 4 | Write PRD | prd-writing | BLOCKED | #2, #3 | — | docs/prd/feature-prd.md |
```

On Tier 1: subagents read the plan, pick up PENDING tasks, update status.
On Tier 2: user dispatches tasks; agents update the file.
On Tier 3: agent works through rows sequentially.

## Subagent Prompt Template

When spawning a subagent, always include:

```
You are a specialist subagent. Your scope is strictly limited.

TASK: [specific, single task]
SKILL TO USE: [skill name]
READ FIRST: [context file paths]
WRITE TO: [specific output directory/file]
DO NOT TOUCH: [files outside your scope]

When complete, write a status summary to [status file path].
```

## When NOT to Orchestrate

Route directly to a single skill when:
- User's request clearly maps to one skill
- The task is small (< 15 min of work)
- There are no phase transitions or dependencies
- The user says "just do it" or signals they want speed

Over-orchestration wastes time and tokens. Most requests need routing, not orchestration.
