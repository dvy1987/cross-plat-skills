# Agent & Process Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement 6 new skills, 1 new agent, 1 modified skill, 1 registry template, and 4 index/config updates as defined in `docs/specs/2026-04-10-agent-process-expansion-design.md`.

**Architecture:** Three reasoning layers (Complexity Triage, Process Decomposition, Architecture Design) sit above the existing skill execution layer. A setup-evaluator agent validates multi-step setups. project-orchestrator is modified to own the execution feedback loop. All new skills follow the existing SKILL.md convention (frontmatter + workflow + gotchas + examples + impact report, <=200 lines).

**Tech Stack:** Markdown (SKILL.md files), YAML frontmatter, agentskills.io standard.

**Design spec:** `docs/specs/2026-04-10-agent-process-expansion-design.md`
**Session context:** `docs/drafts/2026-04-10-design-review-session.md`

---

## File Structure

### New files to create

| File | Responsibility |
|------|---------------|
| `.agents/skills/skill-finder/SKILL.md` | Maps capability descriptions to existing skills; prevents skill sprawl |
| `.agents/skills/tool-finder/SKILL.md` | Identifies tools, checks availability, handles MCP setup |
| `.agents/skills/create-agent-prompt/SKILL.md` | Creates agent role prompts for multi-agent topologies |
| `.agents/skills/process-decomposer/SKILL.md` | Complexity triage + task decomposition into process entries |
| `.agents/skills/agent-architect/SKILL.md` | Designs execution structure: single skill / agent / multi-agent |
| `.agents/skills/setup-evaluation/SKILL.md` | Validates decomposition + architecture quality before execution |
| `docs/processes/process.md` | Empty process registry template (volume 1) |

### Files to modify

| File | Change |
|------|--------|
| `.agents/skills/project-orchestrator/SKILL.md` | Remove structure-decision logic; add execution feedback protocol; update routing table |
| `.agents/ROUTING.md` | Add routing rules for 6 new skills + triage short-circuits |
| `AGENTS.md` | Add new user entry points for process-decomposer, agent-architect, skill-finder |
| `docs/SKILL-INDEX.md` | Add entries for 6 new skills + setup-evaluator agent |
| `README.md` | Update skill count, add Agent & Process Design sub-group, add TODOs |

---

## Phase 1: Foundation Skills (no dependencies)

These skills have no inter-skill dependencies and can be built in any order or in parallel.

---

### Task 1: Create `skill-finder`

**Files:**
- Create: `.agents/skills/skill-finder/SKILL.md`

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p .agents/skills/skill-finder
```

- [ ] **Step 2: Write SKILL.md**

Write the following to `.agents/skills/skill-finder/SKILL.md`:

```markdown
---
name: skill-finder
description: >
  Find the right skill for a capability. Load when a user or skill needs to
  check if a skill exists for a given task, when process-decomposer assigns
  skills to steps, or when agent-architect checks skill availability. Triggers
  on "what skill does this need", "find a skill for", "is there a skill that",
  "which skill handles", "does a skill exist for", "skill lookup", "check skill
  library". Prevents skill sprawl by always checking existing skills before
  creating new ones. The gatekeeper for all skill creation.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: cross-plat-skills design spec 2026-04-10
---

# Skill Finder

You are a Skill Library Search Agent. Given a capability description, you check the existing skill library for overlap and decide: use an existing skill, extend one, or create a new one. You are the single gatekeeper for all skill creation — no skill is created without going through you first.

## Hard Rules

Never create a new skill if an existing skill can be extended. Lean library is a first-class constraint.
Never call `universal-skill-creator` directly — only invoke it after confirming no existing skill fits.
Always read `docs/SKILL-INDEX.md` before making any decision — do not rely on memory of skill names.
Always call `library-skill` to sync indexes after any create or extend operation.

---

## Workflow

### Step 1 — Read Current Library

Read `.agents/skills/` directory listing and `docs/SKILL-INDEX.md` descriptions. Build a mental map of what exists.

### Step 2 — Compare Against Request

Compare the requested capability against every existing skill. Classify:

| Match | Action |
|-------|--------|
| **Full overlap** — existing skill does exactly this | Return skill name. Done. |
| **Partial overlap** — existing skill covers 60%+ | Identify which section to extend in existing SKILL.md. Call `universal-skill-creator` with `extend` mode targeting the existing skill. |
| **No overlap** — nothing in the library fits | Call `universal-skill-creator` to create a new skill. |

### Step 3 — Extend or Create

If extending: verify the target skill stays <=200 lines after extension. If it would exceed, use `split-skill` instead.

If creating: pass the full capability description to `universal-skill-creator`. Verify the new skill passes `agentskills validate` and scores >=10/14.

### Step 4 — Sync Indexes

After any create or extend: call `library-skill` to sync `docs/SKILL-INDEX.md`, `AGENTS.md`, and `README.md`.

### Step 5 — Return Result

Return to the calling skill: `{ skill_name: "<name>", action: "existing|extended|created" }`.

---

## Gotchas

- A skill with a similar name but different purpose is NOT a match — read the full description.
- "Partial overlap" means the existing skill's core purpose encompasses this capability. If it's a tangential addition, create a new skill instead.
- When called by `process-decomposer`, you may receive multiple capability lookups in sequence. Process each independently — batch decisions cause mismatches.

---

## Example

<examples>
  <example>
    <input>Find a skill for: "evaluate whether a process decomposition is well-structured"</input>
    <output>
Scanned 46 skills in library. Closest matches:
- `validate-skills` — validates skill quality, not process quality (no overlap)
- `code-review-crsp` — reviews code, not process entries (no overlap)

No existing skill handles process/architecture evaluation. Recommending: create new skill `setup-evaluation`.
    </output>
  </example>
  <example>
    <input>Find a skill for: "create a system prompt for an agent"</input>
    <output>
Scanned 46 skills. Match found:
- `create-agent-prompt` — creates role prompts for agents in multi-agent topologies (partial overlap — covers role prompts but not system prompts)

Extending `create-agent-prompt` to include system prompt generation. Verifying line count stays <=200.
    </output>
  </example>
</examples>

---

## Impact Report

```
Skill lookup complete for: [capability description]
Action: existing | extended | created
Skill name: [name]
Library size: [N] skills (before → after if changed)
Index synced: yes/no
```
```

- [ ] **Step 3: Verify line count**

```bash
wc -l .agents/skills/skill-finder/SKILL.md
```

Expected: <=200 lines (target: ~95 lines).

- [ ] **Step 4: Commit**

```bash
git add .agents/skills/skill-finder/SKILL.md
git commit -m "feat: add skill-finder — gatekeeper for skill library lookups"
```

---

### Task 2: Create `tool-finder`

**Files:**
- Create: `.agents/skills/tool-finder/SKILL.md`

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p .agents/skills/tool-finder
```

- [ ] **Step 2: Write SKILL.md**

Write the following to `.agents/skills/tool-finder/SKILL.md`:

```markdown
---
name: tool-finder
description: >
  Identify the right tool for a process step. Load when a user or skill needs
  to check tool availability, confirm CLI compatibility, or determine if an MCP
  server is needed. Triggers on "what tool", "do I need an MCP", "is [tool]
  available", "which tool handles", "tool lookup", "check tool availability",
  "find a tool for". Called by process-decomposer and agent-architect when
  assigning tools to steps.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: cross-plat-skills design spec 2026-04-10
---

# Tool Finder

You are a Tool Discovery Agent. Given a tool requirement, you identify the right tool, confirm it is available in the current environment, and handle MCP server setup if needed. You never install tools yourself — you confirm availability or guide the user through setup.

## Hard Rules

Never install packages or tools without user confirmation.
Never assume a tool is available — always verify in the current environment.
Always check MCP configuration before suggesting MCP-based tools.
Always return a clear availability status — never leave it ambiguous.

---

## Workflow

### Step 1 — Categorise Tool Need

Identify which category the tool falls into:

| Category | Examples | Check method |
|----------|----------|-------------|
| File I/O | Read, Write, Edit, Glob, Grep | Always available (agent built-in) |
| Web search | WebSearch, WebFetch | Check agent capabilities |
| Code execution | Bash, shell commands | Always available |
| External API | REST calls, GraphQL | Check for API keys/config |
| MCP server | Database, Figma, Slack, custom | Check MCP config (Step 2) |
| Custom CLI | project-specific tools | Check with `which <tool>` |

### Step 2 — Check Availability

**Built-in tools (File I/O, Bash):** Always available. Return immediately.

**MCP server tools:**
1. Check if MCP server is configured in the current environment
2. If configured and running → return tool name and MCP command
3. If not configured → prompt user:
   > "This step needs [tool] via MCP server [name]. Set it up with: [command]. Confirm when done."

**Custom CLI tools:**
1. Run `which <tool>` or equivalent
2. If found → return tool name and path
3. If not found → flag as `[TOOL-UNAVAILABLE]` and suggest alternatives

### Step 3 — Return Result

Return to calling skill:
```
tool: <tool-name>
category: <category>
status: available | needs-setup | unavailable
setup_instructions: <if needs-setup>
alternative: <if unavailable>
```

---

## Gotchas

- Agent built-in tools (Read, Write, Grep, Bash) are ALWAYS available — don't waste time checking.
- MCP server availability varies by platform — what works in Claude Code may not work in Codex.
- A tool being installed globally doesn't mean it's available in the agent's sandbox.
- When called in batch by `process-decomposer`, deduplicate — don't check the same tool twice.

---

## Example

<examples>
  <example>
    <input>Find a tool for: "search the web for recent research papers"</input>
    <output>
Tool: WebSearch
Category: Web search
Status: available (agent built-in)
No setup needed.
    </output>
  </example>
  <example>
    <input>Find a tool for: "query a PostgreSQL database"</input>
    <output>
Tool: PostgreSQL MCP server
Category: MCP server
Status: needs-setup
Setup: Configure `mcp__postgres` in your MCP settings with connection string. See: https://github.com/modelcontextprotocol/servers/tree/main/src/postgres
    </output>
  </example>
</examples>

---

## Impact Report

```
Tool lookup complete for: [requirement]
Tool: [name]
Status: available | needs-setup | unavailable
Platform: [current platform]
```
```

- [ ] **Step 3: Verify line count**

```bash
wc -l .agents/skills/tool-finder/SKILL.md
```

Expected: <=200 lines (target: ~100 lines).

- [ ] **Step 4: Commit**

```bash
git add .agents/skills/tool-finder/SKILL.md
git commit -m "feat: add tool-finder — tool discovery and MCP setup"
```

---

### Task 3: Create `create-agent-prompt`

**Files:**
- Create: `.agents/skills/create-agent-prompt/SKILL.md`

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p .agents/skills/create-agent-prompt
```

- [ ] **Step 2: Write SKILL.md**

Write the following to `.agents/skills/create-agent-prompt/SKILL.md`:

```markdown
---
name: create-agent-prompt
description: >
  Create focused role prompts for agents in multi-agent topologies. Load when
  agent-architect needs role prompts for agents, or when a user asks to "create
  an agent prompt", "write a role prompt", "define agent identity", "write an
  agent role", "prompt for this agent". Scope: agent role prompts only (v1).
  System prompts, task prompts, and skill invocation prompts are future TODOs.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: cross-plat-skills design spec 2026-04-10, arXiv:2601.02577
---

# Create Agent Prompt

You are an Agent Prompt Engineer. You create well-structured role prompts for agents in multi-agent topologies. Every prompt you write clearly defines identity, boundaries, handoff protocol, and failure behavior. You write prompts only — you never execute them, test them against a model, or manage versioning.

## Hard Rules

Never write prompts without knowing the agent's role in the topology — ask first.
Never combine multiple agents' prompts into one — each agent gets its own prompt.
Never include implementation details (code, file paths) in role prompts — keep them behavioral.
Always include a failure behavior section — agents must know what to do when stuck.

---

## Workflow

### Step 1 — Gather Context

Ask (or read from architecture spec):
1. What does this agent own? (responsibilities)
2. What does it receive as input? (from whom, in what format)
3. What does it produce as output? (to whom, in what format)
4. Who does it hand off to? (next agent in topology)
5. What skills and tools is it allowed to use?

### Step 2 — Write Role Prompt

Apply this structure:

```
ROLE: [one sentence — who is this agent]

RESPONSIBILITIES:
- [what it does]
- [what it does NOT do — explicit boundaries]

SKILLS: [list of skills this agent may invoke]
TOOLS: [list of tools this agent may use]

INPUT: [what it receives, from whom, format]
OUTPUT: [what it produces, to whom, format]

HANDOFF PROTOCOL:
- On success: [what to pass and to whom]
- On partial success: [what to flag and to whom]

FAILURE BEHAVIOR:
- [what to do when stuck — escalate? retry? report?]
- Never: [explicit anti-patterns for this agent]
```

### Step 3 — Validate

Check:
- [ ] Does the prompt have a clear success criterion?
- [ ] Are boundaries explicit (what it does NOT do)?
- [ ] Is the handoff protocol defined for both success and failure?
- [ ] Does it avoid overlapping with other agents in the same topology?

### Step 4 — Return

Return the prompt text, ready to embed in AGENTS.md or an architecture spec.

---

## Gotchas

- Role prompts are NOT system prompts — they define behavior within a topology, not global identity.
- Avoid "be helpful" or "be thorough" — these are noise. Be specific about what the agent does.
- If the agent's boundary overlaps with another agent, the topology is wrong — flag it to agent-architect.

---

## Example

<examples>
  <example>
    <input>Create a role prompt for a "Code Review Agent" in a parallel fan-out topology that receives code diffs and produces review comments.</input>
    <output>
ROLE: Code Review Agent — reviews code diffs for correctness, conventions, and test coverage.

RESPONSIBILITIES:
- Review each diff for bugs, logic errors, and convention violations
- Check that tests exist for new functionality
- Produce structured review comments with severity (critical/warning/nit)
- Does NOT fix code, refactor, or make changes — review only

SKILLS: [code-review-crsp]
TOOLS: [Read, Grep, Bash (for running tests)]

INPUT: Code diff (unified format) from orchestrator agent
OUTPUT: Structured review (list of findings with file, line, severity, comment) to merge agent

HANDOFF PROTOCOL:
- On success: Pass review to merge agent with verdict (approve/request-changes)
- On partial: Flag files that couldn't be reviewed (e.g., binary) to orchestrator

FAILURE BEHAVIOR:
- If diff is unparseable: report to orchestrator, do not guess
- Never approve without reviewing — if unsure, request-changes with explanation
    </output>
  </example>
</examples>

---

## TODO — Future Prompt Skills

These are NOT implemented in this version. Create via `skill-finder` when demand emerges:
- `create-system-prompt` — system prompts (agent identity + constraints)
- `create-task-prompt` — one-time instructions for specific execution steps
- `create-skill-prompt` — prompts for invoking skills correctly

---

## Impact Report

```
Agent prompt created for: [agent name]
Topology role: [role in topology]
Handoff: [to whom]
Failure behavior: defined
Ready to embed in: AGENTS.md / architecture spec
```
```

- [ ] **Step 3: Verify line count**

```bash
wc -l .agents/skills/create-agent-prompt/SKILL.md
```

Expected: <=200 lines (target: ~120 lines).

- [ ] **Step 4: Commit**

```bash
git add .agents/skills/create-agent-prompt/SKILL.md
git commit -m "feat: add create-agent-prompt — agent role prompt creation"
```

---

## Phase 2: Core Pipeline Skills

These skills form the main pipeline. `process-decomposer` calls `skill-finder` and `tool-finder` (from Phase 1). `agent-architect` calls `create-agent-prompt` (from Phase 1). `setup-evaluation` validates outputs of both.

---

### Task 4: Create `process-decomposer`

**Files:**
- Create: `.agents/skills/process-decomposer/SKILL.md`

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p .agents/skills/process-decomposer
```

- [ ] **Step 2: Write SKILL.md**

Write the following to `.agents/skills/process-decomposer/SKILL.md`:

```markdown
---
name: process-decomposer
description: >
  Decompose tasks into structured, outcome-defined process entries with
  complexity triage. Load when user says "decompose this", "break this down",
  "what steps do I need", "plan this out", "what's the process for", "how do I
  approach this", or when any complex task needs structured execution planning.
  Includes Layer 1 triage: checks process.md for exact matches (skip pipeline),
  assesses complexity (single-skill / skill-chain / agent-chain), and routes
  accordingly. Does NOT replace brainstorming — brainstorming is design
  approval (upstream), this is execution planning (downstream).
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: cross-plat-skills design spec 2026-04-10
---

# Process Decomposer

You are a Process Decomposition Agent. You take user input and break it into structured, outcome-defined steps. You check for reusable processes first, assess complexity to avoid over-engineering simple tasks, and store every decomposition for future reuse. You never execute — you plan.

## Hard Rules

Never skip the triage step — always check process.md first.
Never proceed past Step 1 without a measurable outcome definition (hard gate).
Never assign a skill to a step without calling `skill-finder` first.
Never assign a tool to a step without calling `tool-finder` first.
Never write to `process.md` from any other skill — this skill owns the registry.

---

## Workflow

### Step 0 — Complexity Triage (Layer 1)

**0a. Check process registry.** Read all `docs/processes/process*.md` volumes.

| Match | Action |
|-------|--------|
| **Exact match** (same outcome cluster + nuance) | Present to user. If confirmed: skip Layers 2-4, replay into execution. DONE. |
| **Partial match** (same cluster, different nuance) | Present to user: "Found related process. Adapt it?" Proceed to Step 1 with match as scaffold. |
| **No match** | Proceed to Step 1 fresh. |

**0b. Assess complexity** (if no exact match):

| Complexity | Route |
|------------|-------|
| Single skill sufficient | Route directly to skill. No decomposition. DONE. Output: `complexity_class: single-skill` |
| Multi-step, sequential, no specialization | Mark as `skill-chain`. Proceed to Steps 1-4. Skip agent-architect after. |
| Parallel steps or distinct specialization | Mark as `agent-chain`. Proceed to Steps 1-4. Hand off to agent-architect. Spawn setup-evaluator. |

### Step 1 — Define Outcome (Hard Gate)

Ask: "What does done look like? What is the measurable outcome?"
Do NOT proceed without an answer. This is non-negotiable.

### Step 2 — Decompose Into Steps

For each step define: description, skill (via `skill-finder`), tool (via `tool-finder`), knowledge needed, parallel markers.

### Step 3 — Knowledge Gap Resolution

For each gap: ask user to provide (file, doc, URL). If unavailable: flag as `[KNOWLEDGE-GAP: web-scrape-needed]`. Do not block.

### Step 4 — Write Process Entry

Write to `docs/processes/YYYY-MM-DD-<task-slug>.md` using the schema from the design spec (Section 6.2). Append summary to latest `docs/processes/process*.md` volume (split at 500 lines).

### Step 5 — Pattern Learning

If adapted from existing process: store as variant, link to original, log changes.
Execution feedback is owned by `project-orchestrator` (Section 4.1 of design spec).

---

## Gotchas

- Triage must read ALL process.md volumes — not just the first one.
- "Exact match" means same outcome cluster AND same nuance — same cluster alone is partial.
- `skill-chain` tasks skip agent-architect entirely — don't waste time on architecture for sequential work.
- This skill does NOT replace `brainstorming` or `implementation-plan`. Brainstorming = what to build. This = how to execute.

---

## Example

<examples>
  <example>
    <input>Break down: "Add dark mode to the React app"</input>
    <output>
[Triage] Checked process.md — no match found.
[Triage] Complexity: skill-chain (sequential, no agent specialization needed).

Before I decompose, one question: **What does done look like?** For example: "Dark mode toggle in settings, persists across sessions, all components themed."
    </output>
  </example>
  <example>
    <input>Decompose: "Build a multi-agent code review pipeline"</input>
    <output>
[Triage] Checked process.md — partial match found:
- proc-2026-04-08-012: "Code review automation" (documentation/code-review cluster)
  Nuance differs: that was single-reviewer, this is multi-agent.

Complexity: agent-chain (parallel agents with specialization). Full pipeline will fire.
setup-evaluator will validate before execution.

**What does done look like?** Define the measurable outcome before we proceed.
    </output>
  </example>
</examples>

---

## Impact Report

```
Process decomposed: [task description]
Complexity class: exact-match | single-skill | skill-chain | agent-chain
Process entry: docs/processes/YYYY-MM-DD-<slug>.md
Registry updated: docs/processes/process.md (volume N)
Steps: [N] ([M] parallel)
Knowledge gaps: [N] flagged
Next: [execution | agent-architect | skill routing]
```
```

- [ ] **Step 3: Verify line count**

```bash
wc -l .agents/skills/process-decomposer/SKILL.md
```

Expected: <=200 lines (target: ~130 lines).

- [ ] **Step 4: Commit**

```bash
git add .agents/skills/process-decomposer/SKILL.md
git commit -m "feat: add process-decomposer — complexity triage + task decomposition"
```

---

### Task 5: Create `agent-architect`

**Files:**
- Create: `.agents/skills/agent-architect/SKILL.md`

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p .agents/skills/agent-architect
```

- [ ] **Step 2: Write SKILL.md**

Write the following to `.agents/skills/agent-architect/SKILL.md`:

```markdown
---
name: agent-architect
description: >
  Design execution structure for decomposed processes: single agent or
  multi-agent topology. Load when user says "design an agent for this", "what
  agent structure do I need", "architect this", "should this be multi-agent",
  "what's the right execution structure", "agent topology", "how should agents
  be organized". Takes process-decomposer output as primary input. If triggered
  directly without a process entry, calls process-decomposer first.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: cross-plat-skills design spec 2026-04-10, arXiv:2601.02577, Addy-Osmani-Code-Agent-Orchestra
---

# Agent Architect

You are an Agent Architecture Designer. Given a decomposed process, you decide whether it needs a single agent or a multi-agent topology. For multi-agent, you design the topology, define each agent's boundaries, and specify handoff protocols. You persist the architecture spec for the learning loop. You never execute — you design.

## Hard Rules

Never design an architecture without a process entry — call `process-decomposer` first if none exists.
Never make the architecture spec ephemeral — always persist to `docs/architecture/`.
Never design agents with overlapping responsibilities — clear boundaries are mandatory.
Always call `create-agent-prompt` for every agent in a multi-agent topology.
Always define failure handling for the orchestrator agent.

---

## Workflow

### Step 1 — Read Process Entry

Read the decomposed process from `docs/processes/YYYY-MM-DD-<task>.md`. Extract: steps, skills, tools, parallelism markers, complexity_class.

If no process entry exists and user triggered directly: call `process-decomposer` first. Wait for output.

### Step 2 — Decide Structure

| Signal | Structure |
|--------|-----------|
| 1 step, 1 skill | No agent needed. Route to skill. Done. |
| Multi-step, sequential, no specialization | Single agent + ordered skill stack |
| Parallel steps or distinct specialization | Multi-agent topology (Step 3) |

For single agent: write role, skills[], tools[], prompt (via `create-agent-prompt`), knowledge[].

### Step 3 — Design Multi-Agent Topology

1. **Identify agent boundaries** — what does each agent own?
2. **Choose topology:**
   - Sequential pipeline: A -> B -> C
   - Parallel fan-out: orchestrator -> [A, B, C] -> merge
   - Hierarchical: orchestrator -> sub-orchestrators -> workers
3. **For each agent** define: role, skills[], tools[], knowledge[], input, output
4. **For orchestrator** define: routing rules, failure handling, merge strategy, handoff protocol
5. **Call `create-agent-prompt`** for every agent
6. **Call `agent-system-architecture`** for complex topologies (>4 agents or hierarchical)

### Step 4 — Write Architecture Spec

Persist to `docs/architecture/YYYY-MM-DD-<task-slug>-arch.md`.
Update the process entry's `architecture_spec_ref` field to link to this file.

### Step 5 — Hand Off

Pass architecture spec to `project-orchestrator` for AGENTS.md generation.
If complexity_class is `agent-chain`: setup-evaluator runs automatically before orchestrator.

---

## Gotchas

- "Single agent" is not "no agent" — a single agent still needs a role prompt and skill stack.
- Platform constraints matter — check if the platform supports parallel agents before designing fan-out.
- The architecture spec must reference the exact process entry ID — mismatches break the learning loop.
- Don't over-architect: 2 agents is almost always better than 5. Combine where boundaries are fuzzy.

---

## Example

<examples>
  <example>
    <input>Design execution for process proc-2026-04-10-007 (3 sequential steps, no parallelism)</input>
    <output>
Process: 3 steps, all sequential, no specialization.
Structure: **Single agent** with ordered skill stack.

Agent: Feature Builder
- Skills: [brainstorming, prd-writing, implementation-plan]
- Tools: [Read, Write, Bash]
- Flow: brainstorming -> prd-writing -> implementation-plan (sequential)

Generating role prompt via create-agent-prompt...
Architecture spec saved to: docs/architecture/2026-04-10-feature-builder-arch.md
    </output>
  </example>
  <example>
    <input>Design execution for process proc-2026-04-10-012 (5 steps, 3 parallel)</input>
    <output>
Process: 5 steps, 3 can run in parallel (code-review, security-audit, debt-check).
Structure: **Multi-agent parallel fan-out**.

Topology: Orchestrator -> [Review Agent, Security Agent, Debt Agent] -> Merge Agent
[Defining boundaries, generating role prompts for each...]

Architecture spec saved to: docs/architecture/2026-04-10-review-pipeline-arch.md
    </output>
  </example>
</examples>

---

## Impact Report

```
Architecture designed for: [task]
Structure: single-agent | multi-agent-sequential | multi-agent-parallel | multi-agent-hierarchical
Agents defined: [N]
Architecture spec: docs/architecture/YYYY-MM-DD-<slug>-arch.md
Process entry linked: [proc-ID]
Next: setup-evaluator (if agent-chain) | project-orchestrator
```
```

- [ ] **Step 3: Verify line count**

```bash
wc -l .agents/skills/agent-architect/SKILL.md
```

Expected: <=200 lines (target: ~125 lines).

- [ ] **Step 4: Commit**

```bash
git add .agents/skills/agent-architect/SKILL.md
git commit -m "feat: add agent-architect — execution structure design"
```

---

### Task 6: Create `setup-evaluation`

**Files:**
- Create: `.agents/skills/setup-evaluation/SKILL.md`

- [ ] **Step 1: Create skill directory**

```bash
mkdir -p .agents/skills/setup-evaluation
```

- [ ] **Step 2: Write SKILL.md**

Write the following to `.agents/skills/setup-evaluation/SKILL.md`:

```markdown
---
name: setup-evaluation
description: >
  Validate process decomposition and architecture design quality before
  execution begins. Load when the setup-evaluator agent fires (automatic for
  agent-chain tasks), or when user says "evaluate this setup", "check the
  decomposition", "validate the architecture", "is this plan sound", "review
  the agent design". Catches structural errors, missing knowledge, unrealistic
  step ordering, and topology mismatches. Does NOT modify — only evaluates.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: cross-plat-skills design spec 2026-04-10
---

# Setup Evaluation

You are a Setup Evaluator. You validate process decompositions and architecture designs before they reach execution. You catch errors that would waste execution time. You are deliberately separate from agent-architect to avoid confirmation bias — you evaluate independently. You never modify the setup — only report PASS or FAIL with specific issues.

## Hard Rules

Never modify a process entry or architecture spec — evaluate only.
Never approve a setup with orphan steps (steps not covered by any agent).
Never approve an architecture with undefined handoff protocols.
Always report ALL issues at once — do not stop at the first failure.
Always run from the setup-evaluator agent for agent-chain tasks — this is not optional.

---

## Workflow

### Step 1 — Read Artifacts

Read:
- Process entry: `docs/processes/YYYY-MM-DD-<task>.md`
- Architecture spec: `docs/architecture/YYYY-MM-DD-<task>-arch.md`

### Step 2 — Evaluate Decomposition

| Check | FAIL if |
|-------|---------|
| Step coverage | Any step has no skill assigned |
| Tool availability | Any step has `[TOOL-UNAVAILABLE]` without alternative |
| Parallelism | `parallel_with` markers create circular dependencies |
| Knowledge | Critical knowledge gaps with no resolution path |
| Outcome | Outcome definition is vague or unmeasurable |

### Step 3 — Evaluate Architecture

| Check | FAIL if |
|-------|---------|
| Topology match | Topology doesn't reflect parallelism in process |
| Agent boundaries | Any two agents own the same step or file |
| Handoff protocols | Missing between any pair of connected agents |
| Failure handling | Orchestrator has no defined failure behavior |
| Role prompts | Any agent missing a role prompt |

### Step 4 — Cross-Validate

| Check | FAIL if |
|-------|---------|
| Spec linkage | Architecture spec doesn't reference correct process ID |
| Skill consistency | Skills in architecture don't match skills in process |
| Step coverage | Any process step not covered by any agent |

### Step 5 — Verdict

**PASS:** All checks pass. Hand off to `project-orchestrator`.

**FAIL:** Return all issues to `agent-architect` for revision. Format:

```
SETUP EVALUATION: FAIL
Issues found: [N]
1. [CHECK]: [specific issue] — [how to fix]
2. [CHECK]: [specific issue] — [how to fix]
```

---

## Gotchas

- This skill runs from a SEPARATE agent (setup-evaluator) to avoid bias. If agent-architect calls it directly, the independence is lost.
- A "partial pass" is still a FAIL — all checks must pass.
- Knowledge gaps flagged as `[KNOWLEDGE-GAP: web-scrape-needed]` are acceptable — they're acknowledged gaps, not missing assignments.
- If the same setup fails 3 times, escalate to the user instead of looping.

---

## Example

<examples>
  <example>
    <input>Evaluate setup for proc-2026-04-10-012</input>
    <output>
SETUP EVALUATION: FAIL
Issues found: 2
1. [Agent boundaries]: Review Agent and Security Agent both claim ownership of `src/auth/` — split file scope
2. [Handoff protocols]: No merge strategy defined for combining parallel review outputs

All other checks: PASS (decomposition quality, tool availability, outcome definition, skill consistency, spec linkage)
    </output>
  </example>
  <example>
    <input>Evaluate setup for proc-2026-04-10-015</input>
    <output>
SETUP EVALUATION: PASS
All checks passed (5 decomposition, 5 architecture, 3 cross-validation).
Handing off to project-orchestrator.
    </output>
  </example>
</examples>

---

## Impact Report

```
Setup evaluation for: [proc-ID]
Verdict: PASS | FAIL
Issues found: [N]
Decomposition checks: [passed/total]
Architecture checks: [passed/total]
Cross-validation checks: [passed/total]
Next: project-orchestrator (if PASS) | agent-architect revision (if FAIL)
```
```

- [ ] **Step 3: Verify line count**

```bash
wc -l .agents/skills/setup-evaluation/SKILL.md
```

Expected: <=200 lines (target: ~130 lines).

- [ ] **Step 4: Commit**

```bash
git add .agents/skills/setup-evaluation/SKILL.md
git commit -m "feat: add setup-evaluation — pre-execution quality gate"
```

---

## Phase 3: Modifications + Infrastructure

---

### Task 7: Modify `project-orchestrator`

**Files:**
- Modify: `.agents/skills/project-orchestrator/SKILL.md:53-58` (Step 2), `:114-131` (routing table), add execution feedback after Step 5

The changes are:
1. Update Step 2 to remove structure-decision logic (now owned by agent-architect)
2. Add new entries to the Skill Routing Table
3. Add Step 6: Execution Feedback Protocol

- [ ] **Step 1: Update Step 2 — remove structure decisions**

In `.agents/skills/project-orchestrator/SKILL.md`, replace the Step 2 section (lines 53-58):

Old:
```markdown
### Step 2 — Classify the Request

**Single-skill routing:** Request maps to one skill → route directly.
**Sequential chain:** Multiple skills in order → present chain, execute one at a time.
**Parallel decomposition:** Independent parts → spawn subagents (platform-aware).
**Phase recommendation:** User asks "what next?" → recommend based on Step 1.
```

New:
```markdown
### Step 2 — Classify the Request

**Single-skill routing:** Request maps to one skill → route directly.
**Process-backed execution:** Process entry exists in `docs/processes/` → read complexity_class, follow the process.
**New complex request:** No process entry → route to `process-decomposer` for triage + decomposition.
**Phase recommendation:** User asks "what next?" → recommend based on Step 1.

If `process-decomposer` returns `agent-chain`: wait for `agent-architect` and `setup-evaluator` to complete before proceeding to execution.
```

- [ ] **Step 2: Add new entries to Skill Routing Table**

In `.agents/skills/project-orchestrator/SKILL.md`, add these rows to the routing table (after line 131, before the `---`):

```markdown
| "decompose" / "break this down" / "what steps" | `process-decomposer` | — |
| "design agent" / "architect this" / "multi-agent" | `agent-architect` | Process entry |
| "find a skill for" / "which skill handles" | `skill-finder` | — |
| "what tool" / "is [tool] available" | `tool-finder` | — |
| "create agent prompt" / "write role prompt" | `create-agent-prompt` | Agent spec |
| "evaluate setup" / "validate architecture" | `setup-evaluation` | Process + arch spec |
```

- [ ] **Step 3: Add Step 6 — Execution Feedback Protocol**

In `.agents/skills/project-orchestrator/SKILL.md`, add after the AGENTS.md Refresh Check section (after line 110):

```markdown
### Step 6 — Execution Feedback (Learning Loop)

After execution completes (all skills/agents finish), update the process entry:

1. Read `docs/processes/YYYY-MM-DD-<task>.md`
2. Fill execution section: `actual_steps`, `deviations`, `outcome_achieved`, `duration`, `topology_used`, `architecture_spec_ref`
3. Update `docs/processes/process*.md` registry entry status
4. Re-evaluate outcome cluster membership if nuance changed

**This step is mandatory.** Every executed process entry must have its execution section filled. Entries stuck at `status: executing` for 24h+ are flagged as stale.
```

- [ ] **Step 4: Verify line count**

```bash
wc -l .agents/skills/project-orchestrator/SKILL.md
```

Expected: <=200 lines. If over, move the AGENTS.md Refresh Check details to `references/agents-md-refresh.md` and reference it.

- [ ] **Step 5: Commit**

```bash
git add .agents/skills/project-orchestrator/SKILL.md
git commit -m "fix: project-orchestrator — add execution feedback loop, update routing table"
```

---

### Task 8: Create `docs/processes/process.md` Registry Template

**Files:**
- Create: `docs/processes/process.md`

- [ ] **Step 1: Create directory**

```bash
mkdir -p docs/processes
```

- [ ] **Step 2: Write process.md template**

Write the following to `docs/processes/process.md`:

```markdown
<!-- Process Registry — Volume 1 of 1 -->
<!-- Split to next volume at 500 lines -->

# Process Registry

## Outcome Clusters

<!-- Clusters are added automatically by process-decomposer -->
<!-- Format: category/sub-category with proc-IDs listed under each -->

## Process Index (chronological)

| ID | Date | Task | Outcome Cluster | Topology | Status | Variant Of |
|----|------|------|-----------------|----------|--------|------------|
<!-- Entries added by process-decomposer -->
```

- [ ] **Step 3: Commit**

```bash
git add docs/processes/process.md
git commit -m "feat: add process.md — empty registry template"
```

---

## Phase 4: Index and Config Updates

---

### Task 9: Update `.agents/ROUTING.md`

**Files:**
- Modify: `.agents/ROUTING.md`

- [ ] **Step 1: Add new routing rules**

Append the following to `.agents/ROUTING.md` (after the existing Examples table, before the end of the file):

```markdown

---

## Process & Agent Design Layer

- "decompose" | "break down" | "plan this out" | "what steps"
    → `process-decomposer` (triage fires first — may short-circuit)
    Fires BEFORE `agent-architect` — decomposition must precede architecture.

- "design an agent" | "what agent structure" | "architect this" | "multi-agent"
    → `agent-architect`
    If no process entry exists, `agent-architect` calls `process-decomposer` first.

- "what skill does this need" | "find a skill for" | "is there a skill that"
    → `skill-finder`
    NOT `universal-skill-creator` directly — always go through `skill-finder` first.

- "what tool" | "do I need an MCP" | "is [tool] available"
    → `tool-finder`

- "create an agent prompt" | "write a role prompt for this agent"
    → `create-agent-prompt`

- "evaluate this setup" | "check the decomposition" | "validate the architecture"
    → `setup-evaluation`
    Also auto-invoked by setup-evaluator agent for agent-chain tasks.

## Hard Boundaries

- `process-decomposer` does NOT replace `brainstorming`.
  brainstorming = design approval (upstream). process-decomposer = execution planning (downstream).
- `setup-evaluator` agent is auto-spawned for agent-chain only (not keyword-routed).

## Triage Short-Circuits (process-decomposer Step 0)

| Complexity Class | Route |
|-----------------|-------|
| `exact-match` | Skip all layers, replay into execution |
| `single-skill` | Route directly to skill, no decomposition |
| `skill-chain` | Decompose (Layer 2), skip architecture (Layer 3) |
| `agent-chain` | Full pipeline + setup-evaluator |

## Full Firing Order (agent-chain)

brainstorming (if needed) → process-decomposer → agent-architect → setup-evaluator → project-orchestrator → execution → execution feedback
```

- [ ] **Step 2: Verify file is well-formed**

Read the full file and verify no formatting issues.

- [ ] **Step 3: Commit**

```bash
git add .agents/ROUTING.md
git commit -m "feat: ROUTING.md — add process and agent design layer routing rules"
```

---

### Task 10: Update `AGENTS.md`

**Files:**
- Modify: `AGENTS.md:123-134` (User Entry Points section)

- [ ] **Step 1: Update User Entry Points**

In `AGENTS.md`, replace the User Entry Points section (lines 123-134):

Old:
```markdown
## User Entry Points

```
"create a skill"     → universal-skill-creator
"improve skills"     → improve-skills
"learn from paper"   → learn-from-paper
"set up this project"→ project-setup
"what should I do"   → project-orchestrator
"orchestrate / split"→ project-orchestrator
```

All other meta skills are called automatically. See `docs/SKILL-INDEX.md` → Call Graph.
```

New:
```markdown
## User Entry Points

```
"create a skill"      → universal-skill-creator
"improve skills"      → improve-skills
"learn from paper"    → learn-from-paper
"set up this project" → project-setup
"what should I do"    → project-orchestrator
"orchestrate / split" → project-orchestrator
"break this down"     → process-decomposer (triage + decompose)
"design an agent"     → agent-architect
"find a skill for"    → skill-finder
```

All other meta and supporting skills are called automatically. See `docs/SKILL-INDEX.md` → Call Graph.
```

- [ ] **Step 2: Commit**

```bash
git add AGENTS.md
git commit -m "feat: AGENTS.md — add process-decomposer, agent-architect, skill-finder entry points"
```

---

### Task 11: Update `docs/SKILL-INDEX.md`

**Files:**
- Modify: `docs/SKILL-INDEX.md` (add entries in the Project-Specific Skills section)

- [ ] **Step 1: Add new skill entries**

In `docs/SKILL-INDEX.md`, add the following entries after the existing `project-orchestrator` entry in the Project-Specific Skills section (before the `---` separator that follows it). Also add a new sub-section header:

```markdown

### Agent & Process Design Skills

### `process-decomposer`
**Triggers:** "decompose this", "break this down", "what steps do I need", "plan this out", "what's the process for", "how do I approach this"
**What it does:** Complexity triage (Layer 1) + task decomposition into structured process entries. Checks process.md for reusable matches first. Classifies as exact-match, single-skill, skill-chain, or agent-chain. Stores entries in docs/processes/ for future reuse. Hard gate: requires measurable outcome before decomposition.
**Calls:** `skill-finder`, `tool-finder`, `research-skill` (for knowledge gaps)
**Output file:** `docs/processes/YYYY-MM-DD-<task-slug>.md`
**Registry:** `docs/processes/process.md` (volume-split at 500 lines)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Complexity class, process entry path, steps count, knowledge gaps flagged, next layer

---

### `agent-architect`
**Triggers:** "design an agent for this", "what agent structure do I need", "architect this", "should this be multi-agent", "what's the right execution structure"
**What it does:** Designs execution structure for decomposed processes. Decides single agent or multi-agent topology. For multi-agent: defines boundaries, chooses topology (sequential/parallel/hierarchical), specifies handoff protocols. Persists architecture specs for the learning loop.
**Calls:** `agent-system-architecture` (complex topology), `create-agent-prompt` (role prompts), `project-orchestrator` (downstream)
**Output file:** `docs/architecture/YYYY-MM-DD-<task-slug>-arch.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Structure chosen, agents defined, architecture spec path, process entry linked

---

### `setup-evaluation`
**Triggers:** "evaluate this setup", "check the decomposition", "validate the architecture", "is this plan sound"
**What it does:** Validates process decomposition and architecture design before execution. Checks step coverage, tool availability, parallelism consistency, agent boundaries, handoff protocols, and cross-validates spec linkage. Returns PASS or FAIL with specific issues. Runs from setup-evaluator agent (separate from agent-architect to avoid confirmation bias).
**Output:** PASS/FAIL verdict in chat with issues list
**Impact report:** Verdict, issues count, checks passed/total, next step

---

### `skill-finder`
**Triggers:** "what skill does this need", "find a skill for", "is there a skill that", "which skill handles"
**What it does:** Searches the skill library for capability matches. Decides: use existing (full overlap), extend existing (partial overlap), or create new (no overlap). The single gatekeeper for all skill creation — prevents skill sprawl.
**Calls:** `universal-skill-creator` (if create/extend needed), `library-skill` (sync indexes)
**Output:** Skill name + action taken (existing/extended/created)
**Impact report:** Action, skill name, library size before/after

---

### `tool-finder`
**Triggers:** "what tool", "do I need an MCP", "is [tool] available", "which tool handles"
**What it does:** Identifies tools for process steps. Confirms CLI compatibility, checks MCP server config. Guides user through setup if needed. Categorises tools: File I/O, Web, Bash, API, MCP, Custom CLI.
**Output:** Tool name, status (available/needs-setup/unavailable), setup instructions
**Impact report:** Tool, status, platform

---

### `create-agent-prompt`
**Triggers:** "create an agent prompt", "write a role prompt", "define agent identity"
**What it does:** Creates focused role prompts for agents in multi-agent topologies. Defines identity, responsibilities, boundaries, handoff protocol, and failure behavior. Scope: agent role prompts only (v1). System prompts, task prompts, skill prompts are future TODOs.
**Called by:** `agent-architect`, user (direct)
**Output:** Prompt text ready to embed in AGENTS.md or architecture spec
**Impact report:** Agent name, topology role, handoff defined, failure behavior defined

---

### Agents

### `setup-evaluator` (agent)
**Spawned by:** `process-decomposer` when `complexity_class = agent-chain`
**Skills:** `setup-evaluation`
**What it does:** Runs between architecture design and orchestration config. Validates the setup independently from the architect. On FAIL: returns issues to agent-architect. On PASS: hands off to project-orchestrator.
**Why an agent:** Independence from agent-architect prevents confirmation bias.
```

- [ ] **Step 2: Update the "Last updated" date**

Change line 7 from `Last updated: 2026-04-05` to `Last updated: 2026-04-10`.

- [ ] **Step 3: Commit**

```bash
git add docs/SKILL-INDEX.md
git commit -m "feat: SKILL-INDEX.md — add 6 new skills + setup-evaluator agent"
```

---

### Task 12: Update `README.md`

**Files:**
- Modify: `README.md` (skill count + tables + TODOs)

- [ ] **Step 1: Update skill count**

Search for the current skill count (e.g., "42 skills" or "40 skills") in README.md and update to **48 skills** (40 existing + 6 new + 2 existing skills from docs that weren't counted = 46 dirs, + 6 new = 46 + 6 = update based on actual count after creation).

Run `ls -d .agents/skills/*/` to count and use the exact number.

- [ ] **Step 2: Add Agent & Process Design sub-group**

Find the skill category table in README.md and add a new sub-group under Project-Specific Skills:

```markdown
#### Agent & Process Design
| Skill | What it does |
|-------|-------------|
| `process-decomposer` | Complexity triage + task decomposition into reusable process entries |
| `agent-architect` | Designs single-agent or multi-agent execution structures |
| `setup-evaluation` | Validates decomposition + architecture before execution |
| `skill-finder` | Maps capabilities to existing skills; prevents sprawl |
| `tool-finder` | Tool discovery, availability checking, MCP setup |
| `create-agent-prompt` | Creates role prompts for agents in multi-agent topologies |
```

- [ ] **Step 3: Add TODO section for deferred skills**

Add near the bottom of README.md (before License or Contributing section):

```markdown
## Deferred / TODO

These skills are designed but not yet implemented. They will be created via `skill-finder` when demand emerges:

- `knowledge-indexer` — indexes project knowledge sources; deferred until RAG is ready
- `create-system-prompt` — system prompts for agent identity + constraints
- `create-task-prompt` — one-time instructions for specific execution steps
- `create-skill-prompt` — prompts for invoking skills correctly
```

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "feat: README.md — add agent & process design skills, deferred TODOs"
```

---

## Verification

### Task 13: Full Verification Pass

- [ ] **Step 1: Verify all new skill directories exist**

```bash
ls -d .agents/skills/skill-finder .agents/skills/tool-finder .agents/skills/create-agent-prompt .agents/skills/process-decomposer .agents/skills/agent-architect .agents/skills/setup-evaluation
```

Expected: all 6 directories listed.

- [ ] **Step 2: Verify all SKILL.md files are <=200 lines**

```bash
wc -l .agents/skills/skill-finder/SKILL.md .agents/skills/tool-finder/SKILL.md .agents/skills/create-agent-prompt/SKILL.md .agents/skills/process-decomposer/SKILL.md .agents/skills/agent-architect/SKILL.md .agents/skills/setup-evaluation/SKILL.md
```

Expected: every file <=200 lines.

- [ ] **Step 3: Verify process.md template exists**

```bash
cat docs/processes/process.md | head -5
```

Expected: `<!-- Process Registry — Volume 1 of 1 -->`.

- [ ] **Step 4: Verify ROUTING.md has new rules**

```bash
grep "process-decomposer" .agents/ROUTING.md
grep "agent-architect" .agents/ROUTING.md
grep "setup-evaluation" .agents/ROUTING.md
```

Expected: all three found.

- [ ] **Step 5: Verify AGENTS.md has new entry points**

```bash
grep "process-decomposer" AGENTS.md
grep "agent-architect" AGENTS.md
grep "skill-finder" AGENTS.md
```

Expected: all three found.

- [ ] **Step 6: Verify SKILL-INDEX.md has new entries**

```bash
grep -c "^### \`" docs/SKILL-INDEX.md
```

Expected: count increased by 6 from previous.

- [ ] **Step 7: Verify project-orchestrator has execution feedback**

```bash
grep "Execution Feedback" .agents/skills/project-orchestrator/SKILL.md
```

Expected: found.

- [ ] **Step 8: Count total skills**

```bash
ls -d .agents/skills/*/ | wc -l
```

Expected: 46 (40 existing + 6 new).

- [ ] **Step 9: Final commit (if any verification fixes needed)**

```bash
git status
# If clean: done. If fixes needed: stage and commit.
```

---

## Dependency Graph

```
Phase 1 (parallel — no dependencies):
  Task 1: skill-finder
  Task 2: tool-finder
  Task 3: create-agent-prompt

Phase 2 (depends on Phase 1):
  Task 4: process-decomposer (calls skill-finder, tool-finder)
  Task 5: agent-architect (calls create-agent-prompt)
  Task 6: setup-evaluation (validates outputs of 4 + 5)

Phase 3 (depends on Phase 2):
  Task 7: project-orchestrator modifications
  Task 8: process.md registry template

Phase 4 (depends on all above):
  Task 9:  ROUTING.md
  Task 10: AGENTS.md
  Task 11: SKILL-INDEX.md
  Task 12: README.md

Verification:
  Task 13: full verification pass (depends on all)
```

Tasks within the same phase can run in parallel. Tasks across phases must run sequentially.
