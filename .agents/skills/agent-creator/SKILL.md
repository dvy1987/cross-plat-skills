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

Output structured spawn instructions for the platform to execute natively.
Do NOT generate code. The Task tool reads these instructions directly.

**Parallel topology:**
```
SPAWN SUBAGENTS:
Topology: parallel

Agent: <name>
Role prompt: docs/agents/<name>-prompt.md
Input: <input source — e.g. docs/handoffs/task-input.md>
Output to: docs/handoffs/<name>-output.md

[Repeat block for each agent]

Run all agents concurrently via Task tool.
Wait for all outputs before proceeding.
```

**Sequential topology:**
```
SPAWN SUBAGENTS:
Topology: sequential

Agent: <name-1>
Role prompt: docs/agents/<name-1>-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/<name-1>-output.md

Agent: <name-2>
Role prompt: docs/agents/<name-2>-prompt.md
Input: docs/handoffs/<name-1>-output.md
Output to: docs/handoffs/<name-2>-output.md

[Repeat, chaining each output as next input]

Run agents in order via Task tool. Each agent receives prior output as input.
```

**Hierarchical topology:**
```
SPAWN SUBAGENTS:
Topology: hierarchical

Orchestrator agent: <name>
Role prompt: docs/agents/<name>-prompt.md
Input: docs/handoffs/task-input.md
Sub-agents: [list per architecture spec]
Output to: docs/handoffs/<name>-output.md

Orchestrator manages sub-agent dispatch per architecture spec.
```

### Step 5 — Monitor and Hand Off

After spawn instructions are issued, poll for output files in docs/handoffs/:
- File present and non-empty → agent complete
- Empty file or error string in file → agent failed

**On failure** — apply failure handling rules from architecture spec:
- Retry once with same prompt via Task tool
- Retry succeeds → continue normally
- Retry fails → write `docs/handoffs/<name>-FAILED.md` with error detail
- Failed agent is blocking (sequential dependency) → halt, surface to user
- Failed agent is non-blocking (parallel, independent) → continue with
  available outputs, note failure in Impact Report

When all expected outputs are present (or failures logged):
→ Hand off to `project-orchestrator` with handoff directory path for
  synthesis, merge, and learning loop update.

---

## Gotchas

- Parallel agents must be truly independent — if Agent B needs Agent A's
  output, they are sequential not parallel. Check architecture spec carefully.
- Sequential agents must chain outputs explicitly — never assume an agent
  reads prior outputs automatically.
- Prompt files must exist on disk before spawning — in-memory prompts do
  not work with the Task tool.
- The launch manifest is the audit trail — never skip it even for two-agent runs.
- Hierarchical topologies require the orchestrator agent's prompt to include
  explicit sub-agent dispatch instructions — verify before spawning.

---

## Examples

<examples>
  <example>
    <input>
      Architecture: proc-2026-04-11-012 (3 parallel agents: review-agent,
      security-agent, debt-agent). Platform: Ampcode. setup-evaluation: PASS.
      All prompt files present.
    </input>
    <output>
Preconditions: ✓ Architecture spec found. ✓ setup-evaluation PASS.
✓ All prompt files present.
Platform: Ampcode (Task tool) — Path A.

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

Run all agents concurrently via Task tool.
Wait for all outputs before proceeding.

Monitoring docs/handoffs/...
    </output>
  </example>
  <example>
    <input>
      Architecture: proc-2026-04-11-007 (2 sequential agents: planner-agent,
      implementer-agent). Platform: Claude Code. setup-evaluation: PASS.
    </input>
    <output>
Preconditions: ✓ Architecture spec found. ✓ setup-evaluation PASS.
✓ All prompt files present.
Platform: Claude Code (Task tool) — Path A.

Manifest written: docs/agents/runs/2026-04-11-planner-implementer-manifest.md

SPAWN SUBAGENTS:
Topology: sequential

Agent: planner-agent
Role prompt: docs/agents/planner-agent-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/planner-agent-output.md

Agent: implementer-agent
Role prompt: docs/agents/implementer-agent-prompt.md
Input: docs/handoffs/planner-agent-output.md
Output to: docs/handoffs/implementer-agent-output.md

Run agents in order via Task tool. Each agent receives prior output as input.

[planner-agent complete → docs/handoffs/planner-agent-output.md]
[implementer-agent complete → docs/handoffs/implementer-agent-output.md]

Handing off to project-orchestrator for synthesis.
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
