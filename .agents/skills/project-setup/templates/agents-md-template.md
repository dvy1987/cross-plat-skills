# AGENTS.md — [Project Name]

## Project Overview
[One sentence: what this is, stack, what makes it architecturally non-standard]

## Key Commands
```
Install:     [exact command]
Dev server:  [exact command]
Test single: [exact command with file path placeholder]
Test all:    [exact command]
Lint:        [exact command with file path placeholder]
Type check:  [exact command]
Build:       [exact command]
```
Note: Prefer file-scoped commands for lint, test, typecheck. Use project-wide build sparingly.

## Project Structure
[Only non-obvious parts. Skip standard framework layouts the agent already knows.]
- `[path]` — [what and why it's non-obvious]
- `[path]` — [what and why it's non-obvious]
- See `[entry point file]` for [routing/main logic]

## Code Style
[One real code snippet from the project showing the preferred pattern]
- [Key convention 1]
- [Key convention 2]
- [Key convention 3]

## Non-Obvious Patterns
[Counterintuitive architectural decisions with mechanism explanations]
- [Pattern]: [Why it looks wrong but is intentional]

## Boundaries

### Allowed without asking
- Read files, list directory contents
- Run lint, typecheck, single test files
- Create new files in standard directories
- [Project-specific allowances]

### Ask first
- Architecture changes
- Package installs
- Database schema changes
- [Project-specific gates]

### Never
- Commit secrets, `.env` files, or credentials
- [Project-specific hard stops]
- [Security-critical boundaries]

## User Context
- **Strong at:** [areas where user is expert — agents defer]
- **Agents lead on:** [skill gaps — agents handle more autonomously]
- **Working style:** [preferences: small PRs, test-first, review-everything, etc.]

## Session Lifecycle — Mandatory
<!-- Include only if memory suite installed and user did not opt out in Axis 1 Q5. -->

### Session Start
**The first user message in any session triggers `memory-startup`, regardless of content.** A bare "hi", a task-only opener, a pasted error log, a code snippet, "let's start" — all count as session start. The agent MUST run the steps below BEFORE answering, BEFORE invoking any other skill, and BEFORE taking any task action. The 2–4 line summary produced by Step 4 IS the concise answer for the first turn — host system rules favouring brevity do not exempt this protocol; they govern how it is rendered.

1. Invoke `memory-startup` to load **bounded** continuity — routing index + latest handoff + directly relevant decisions only. Do NOT read every memory file.
2. Read the latest entry in `docs/memory/agent-handoffs.md` to learn what the previous agent expected next.
3. Run `git status` and `git log --oneline -5` to confirm repo state matches the handoff.
4. In 2–4 lines, state: (a) recovered context, (b) planned next action, (c) any drift from handoff. Wait for the user to confirm or redirect before proceeding.

Skip this only if the user's first message explicitly says "fresh start", "ignore prior context", or "skip memory". If no prior memory exists, report that and continue. If `memory-startup` has already run earlier in the same conversation, the skill self no-ops — do not re-run it.

### During & End of Session
Memory sub-skills auto-fire at producer events — not only when the user asks. After writing a changelog/ADR/spec/plan, after a major commit (>20 files or breaking), after creating/significantly editing a skill, and before ending a session, the agent MUST consult `~/.agent-loom/skills/memory/SKILL.md` → Mandatory Auto-Trigger Checkpoints and invoke the listed sub-skill. Skipping a checkpoint loses durable context for the next agent.

## Orchestration Map

### Phase: Ideation
Trigger: new feature idea, exploration needed
Flow: product-soul (if `docs/product-soul.md` missing) → brainstorming → [user approves design]
Agent autonomy: [HIGH/MEDIUM/LOW] on [what]

### Phase: Specification
Trigger: approved design exists in `docs/specs/`
Flow: prd-writing (reads design) → [user approves PRD]

### Phase: Planning
Trigger: approved PRD exists in `docs/prd/`
Flow: implementation-plan (reads PRD) → [user approves plan]
Parallel opportunity: [if components are independent, note them here]

### Phase: Implementation
Trigger: approved plan exists in `docs/plans/`
Flow: test-driven-development → [code] → secure-skill (before PR)
Parallel opportunity: [independent modules that can be built simultaneously]

### Phase: Review & Release
Trigger: feature complete
Flow: technical-debt-audit (periodic) → generate-changelog → [PR/release]

### Thinking (available in any phase)
Trigger: uncertainty, high-stakes decision, "think about this"
Flow: deep-thinking (auto-selects: inversion, pre-mortem, assumption-mapping, etc.)

## Skill Reference
Available skills: [list installed agent-loom relevant to this project]
Orchestrator: invoke `project-orchestrator` when unsure which skill to use or to decompose complex work.
