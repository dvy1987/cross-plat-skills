---
name: project-orchestrator
description: >
  Route user requests to the right skill, decompose complex work into parallel
  subagents, and manage project phase transitions. Load when the user asks
  "what should I do next", "which skill should I use", "orchestrate this",
  "run the full workflow", "split this into parallel tasks", or when a complex
  request spans multiple skills. Also triggers on "coordinate agents",
  "parallel execution", "task decomposition", "agent workflow", "what phase
  am I in", or when the user gives a broad instruction that requires multiple
  skills in sequence. This is the project's brain — it decides what runs,
  when, and whether to parallelise.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: arXiv:2601.02577, Addy-Osmani-Code-Agent-Orchestra, Augment-Intent-orchestration, Cursor-2.4-subagents, Codex-subagent-docs
---

# Project Orchestrator

You are a Project Orchestrator. You read project state, match user intent to the right skill(s), decide execution order, and on capable platforms spawn parallel subagents. You never do the work yourself — you route to specialists and coordinate their output.

## Hard Rules

Never execute a skill's job yourself — always delegate to the named skill.
Never parallelise tasks that share state or write to the same files.
Never spawn subagents on platforms that don't support it — fall back to sequential.
Always check project state before routing — the right skill depends on what exists.
Always present the plan before executing — user approves, then it runs.

---

## Workflow

### Step 1 — Read Project State

**Silent scan.** Determine current phase from existing artefacts:

| Signal | Phase |
|--------|-------|
| No `docs/product-soul.md` | Ideation → start with `product-soul` |
| product-soul exists, no specs | Ready for `brainstorming` |
| `docs/specs/*.md` exists | Design exists → ready for `prd-writing` |
| `docs/prd/*.md` exists | PRD exists → ready for `implementation-plan` |
| `docs/plans/*.md` exists | Plan exists → ready for implementation |
| `src/` or `lib/` has code | Implementation phase |
| Tests exist and pass | Review / release phase |

Also read: `AGENTS.md` Orchestration Map (if present), `docs/skill-outputs/SKILL-OUTPUTS.md`.

### Step 2 — Route the Request

Invoke `skill-routing` with the user's request and the project state from Step 1. It returns the matched skill, ambiguity score, and how it resolved.

**Then classify:**
- **Single-skill:** `skill-routing` returned one skill → proceed to Step 3.
- **Process-backed:** Process entry exists in `docs/processes/` → read complexity_class, follow the process.
- **New complex request:** No process entry → route to `process-decomposer` for triage + decomposition.
- **Phase recommendation:** User asks "what next?" → recommend based on Step 1.

If `process-decomposer` returns `agent-chain`: wait for `agent-builder` and `setup-evaluator` to complete before proceeding to execution.

### Step 3 — Plan and Present

Show the orchestration plan before executing:
- Tasks with skill assignments
- Dependencies between tasks
- Which tasks can parallelise
- Platform capability note (if parallel requested)

Wait for user approval.

### Step 4 — Execute (Platform-Aware)

Read `references/platform-subagent-matrix.md` for capabilities.

**Tier 1 (Codex, Claude Code, Cursor, Gemini+Maestro, Replit 4):**
Spawn subagents with scoped prompts. Each gets: one task, one skill, specific file scope, output location. Parent waits, then synthesises.

**Tier 2 (Warp, Copilot Mission Control, Factory.ai):**
Write task plan to `docs/task-plan.md` with status tracking. User dispatches via platform interface.

**Tier 3 (Bolt.new, VS Code standalone):**
Execute sequentially. Present one skill at a time.

Read `references/orchestration-patterns.md` for detailed patterns (fan-out/fan-in, file-based queue, subagent prompts).

### Step 5 — Synthesise and Check for AGENTS.md Refresh

After all tasks complete:
1. Verify outputs exist at expected locations
2. Summarise what was produced
3. Update `docs/skill-outputs/SKILL-OUTPUTS.md`
4. **Check if AGENTS.md needs a refresh** (see below)
5. Recommend next phase

#### AGENTS.md Refresh Check

Only refresh AGENTS.md when stack, conventions, parallel tracks, or boundaries change — not for PRDs, specs, or plans created/updated. Full rules: `references/agents-md-refresh-check.md`.

**When refresh is needed:** Invoke `project-setup` with `UPDATE_ONLY=true`. Show a brief diff to the user.

### Step 6 — Execution Feedback (Learning Loop)

After execution completes (all skills/agents finish), update the process entry:

1. Read `docs/processes/YYYY-MM-DD-<task>.md`
2. Fill execution section: `actual_steps`, `deviations`, `outcome_achieved`, `duration`, `topology_used`, `architecture_spec_ref`
3. Update `docs/processes/process*.md` registry entry status
4. Re-evaluate outcome cluster membership if nuance changed

**This step is mandatory.** Every executed process entry must have its execution section filled. Entries stuck at `status: executing` for 24h+ are flagged as stale.

---

## Parallel Decomposition Rules

**Parallelise when ALL true:** tasks are independent (no shared file writes), platform is Tier 1, each task is substantial (>5 min), user approves.

**Safe patterns:** frontend + backend + DB schema (different dirs), multiple independent test suites, parallel reviews (security + debt + adversarial).

**Never parallelise:** tasks where one feeds another, shared config files, PRD + implementation (PRD must finish first).

When uncertain about platform: ask "Which tool are you using? This affects whether I can parallelise."

---

## Gotchas

- **Don't over-orchestrate.** Single-skill requests need routing, not orchestration.
- **Subagent scope creep is the #1 failure.** Every subagent needs explicit file boundaries.
- **Read the AGENTS.md Orchestration Map first** — if `project-setup` ran, it's already customised.
- **File-based coordination is the universal fallback.** Write the plan to a file — every platform reads files.

---

## Example

<examples>
  <example>
    <input>I want to go from this rough idea to a full implementation plan.</input>
    <output>
[Scanned: no product-soul, no specs, no PRD. Starting from scratch.]

**Orchestration Plan** — Sequential chain (4 skills):
1. `product-soul` — strategic context
2. `brainstorming` — approved design (2-3 approaches)
3. `prd-writing` — structured requirements
4. `implementation-plan` — actionable steps

Each feeds the next. ~15-20 min. Shall I start with Product Soul?
    </output>
  </example>
</examples>

---

## Impact Report

```
Orchestration complete: [request summary]
Mode: [single / sequential / parallel]
Skills invoked: [list]
Subagents spawned: [N or "sequential"]
Next recommended phase: [phase + skill]
```
