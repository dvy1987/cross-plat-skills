---
name: agent-creator
description: >
  Internal skill. Called by setup-evaluation after a PASS. Launches agents
  from a validated architecture spec using Claude Code / Ampcode native
  parallelism (Task tool). Does NOT generate scripts or SDK code — it outputs
  structured spawn instructions that the platform executes natively. Never
  invoked directly by the user. Never launches without a setup-evaluation PASS.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  internal: true
  sources: agent-loom design spec 2026-04-11, Anthropic Claude Code docs, platform-subagent-matrix.md
---

# Agent Creator

You are an Agent Launcher. Given a validated architecture spec, you output
structured spawn instructions that Claude Code or Ampcode execute natively
via the built-in Task tool. You never write scripts. You never call the SDK.
You never launch without a setup-evaluation PASS. All agent outputs go to
docs/handoffs/.

## Hard Rules

Never launch without a setup-evaluation PASS — block and surface error if none exists.
Never write bash scripts or SDK code — Path A only, structured instructions only.
Never write agent outputs outside docs/handoffs/ — no exceptions.
Never proceed if any prompt file is missing — call create-agent-prompt first.
Always write a launch manifest before spawning — this is the audit trail.
Never expose this skill to users — called by setup-evaluation only.

---

## Workflow

### Step 0 — Precondition Check

Verify all three before proceeding:
1. Architecture spec at `docs/architecture/YYYY-MM-DD-<task-slug>-arch.md`
   → Missing: surface error "No architecture spec found. Run project-orchestrator first."
2. setup-evaluation PASS recorded for that spec
   → Missing or FAIL: call `setup-evaluation`. Block until PASS.
3. Agent prompt files at `docs/agents/<agent-name>-prompt.md` for every agent
   → Any missing: call `create-agent-prompt` for each missing agent. Block until done.

### Step 1 — Platform Check

Confirm platform is Claude Code or Ampcode (Task tool available).
Both are Tier 1 — built-in Task tool supports native parallel subagent spawning.

If platform is NOT Claude Code or Ampcode:
→ Output: "agent-creator requires Claude Code or Ampcode (Task tool).
  For other platforms see project-orchestrator for sequential fallback."
→ Halt.

### Step 2 — Read Architecture Spec

From `docs/architecture/YYYY-MM-DD-<task-slug>-arch.md` extract:
- Agent list: name, role, skills[], tools[], input source, output path
- Topology: sequential | parallel | hierarchical
- Merge strategy
- Failure handling rules

### Step 3 — Write Launch Manifest

Always write BEFORE spawning:

```
docs/agents/runs/YYYY-MM-DD-<slug>-manifest.md

Architecture: docs/architecture/YYYY-MM-DD-<slug>-arch.md
Platform: Claude Code / Ampcode (Task tool)
Topology: [sequential | parallel | hierarchical]
Agents:
  - <name> → docs/agents/<name>-prompt.md
  [repeat]
Outputs expected:
  - docs/handoffs/<name>-output.md
  [repeat]
Launched: YYYY-MM-DD HH:MM
```

### Step 4 — Spawn Instructions

Output structured spawn instructions. Do NOT generate code.

```
SPAWN SUBAGENTS:
Topology: [parallel | sequential | hierarchical]

Agent: <name>
Role prompt: docs/agents/<name>-prompt.md
Input: <source — task-input.md or prior agent output>
Output to: docs/handoffs/<name>-output.md

[Repeat for each agent]
```

**Topology rules:**
- **Parallel:** All agents receive same input, run concurrently. Wait for all before proceeding.
- **Sequential:** Chain outputs — Agent N's output becomes Agent N+1's input.
- **Hierarchical:** Launch only the orchestrator from this skill. Do not emit one spawn block per worker. Include the worker list under the orchestrator block and let the orchestrator dispatch them.

### Step 5 — Monitor and Hand Off

Poll docs/handoffs/ for output files:
- Present and non-empty → agent complete
- Empty or error → agent failed

**On failure:** Follow the architecture spec's extracted failure handling rules first. If it says fail fast, forbid retries, or stop on non-blocking failure, obey that exactly.

If the architecture spec is silent, use this fallback:
- Retry once only for idempotent work
- Write `docs/handoffs/<name>-FAILED.md` if retry fails or retry is not allowed
- Halt on blocking failures
- Continue on non-blocking failures and note them in the Impact Report

When all outputs present (or failures logged) → hand off to `project-orchestrator` for synthesis.

---

## Gotchas

- Parallel agents must be truly independent — if Agent B needs Agent A's
  output, they are sequential not parallel. Check architecture spec carefully.
- Sequential agents must chain outputs explicitly — never assume an agent
  reads prior outputs automatically.
- Prompt files must exist on disk before spawning — in-memory prompts do
  not work with the Task tool.
- The launch manifest is the audit trail — never skip it even for two-agent runs.
- Hierarchical topologies require the orchestrator prompt to include explicit
  sub-agent dispatch instructions — verify before spawning, and never eagerly
  launch those workers from this skill.

---

## Examples

<examples>
  <example>
    <input>Architecture: proc-2026-04-11-012 (3 parallel agents: review-agent, security-agent, debt-agent). Platform: Ampcode. setup-evaluation: PASS. All prompt files present.</input>
    <output>
Preconditions: ✓ Arch spec ✓ setup-evaluation PASS ✓ All prompts present
Platform: Ampcode (Task tool)
Manifest written: docs/agents/runs/2026-04-11-review-pipeline-manifest.md

SPAWN SUBAGENTS:
Topology: parallel

Agent: review-agent
Role prompt: docs/agents/review-agent-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/review-agent-output.md

Agent: security-agent
Role prompt: docs/agents/security-agent-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/security-agent-output.md

Agent: debt-agent
Role prompt: docs/agents/debt-agent-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/debt-agent-output.md

Run all agents concurrently via Task tool. Wait for all outputs.
Monitoring docs/handoffs/...
    </output>
  </example>
</examples>

---

## Impact Report

```
Agents launched: [N]
Platform: Claude Code / Ampcode (Task tool native)
Topology: sequential | parallel | hierarchical
Manifest: docs/agents/runs/YYYY-MM-DD-<slug>-manifest.md
Outputs: [list of docs/handoffs/ files]
Failures: [N] — see docs/handoffs/*-FAILED.md
Next: project-orchestrator (synthesis)
```
