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
Available skills: [list installed cross-plat-skills relevant to this project]
Orchestrator: invoke `project-orchestrator` when unsure which skill to use or to decompose complex work.
