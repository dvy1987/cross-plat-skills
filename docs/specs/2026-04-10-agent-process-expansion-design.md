# Design Spec: Agent Architecture & Process Creation Expansion

**Date:** 2026-04-10  
**Author:** Divya  
**Status:** Draft — ready for implementation  
**Type:** Design Specification  
**Scope:** Expansion of project-specific skills into Agent Creation and Process Creation sub-systems

---

## 1. Context & Motivation

The current `project-specific` skill category contains a flat list of skills that cover product, engineering, architecture, and operations. As the library grows and agent-based workflows become more complex, two problems emerge:

1. **No pre-execution reasoning layer.** Skills are invoked directly. There is no system that decides *what execution structure* is appropriate before invoking skills — whether a single skill suffices, whether an agent is needed, or whether a multi-agent topology is required.

2. **No process memory.** Each task is decomposed from scratch. There is no growing registry of decomposed processes that can be reused, adapted, or learned from over time.

3. **No complexity triage.** Every task enters the same pipeline regardless of whether it's a single-skill job or a multi-agent orchestration. Simple tasks pay the cost of the full reasoning stack. Tasks that have already been decomposed and have an exact match in the process registry are re-decomposed from scratch.

This spec defines the design for new/modified skills, a setup-evaluation agent, and the supporting artifacts that address all three gaps.

---

## 2. The Full System Architecture

This expansion adds three new reasoning layers above the existing skill execution layer:

```
┌─────────────────────────────────────────────────────┐
│  LAYER 0 — INPUT                                    │
│  User natural language / docs / PRD / spec / notes  │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│  LAYER 1 — COMPLEXITY TRIAGE                        │
│  First step of: process-decomposer (NEW)            │
│  • Check process.md: exact match?                   │
│    YES → skip Layers 2-4 design work; hand matched  │
│      process to project-orchestrator for replay     │
│  • Assess complexity:                               │
│    - Single skill? → route to skill, done           │
│    - Skill chain (sequential, no specialization)?   │
│      → decompose, skip Layer 3, then execute under  │
│        project-orchestrator                         │
│    - Agent chain (parallel / specialized)?           │
│      → full pipeline: Layers 2-4                    │
│  Fast-path: exact match or single skill skips the   │
│  entire pipeline — no brainstorming, no arch design │
└────────────┬───────────────┬───────────────┬───────┘
     exact   │    simple     │    complex    │
     match   │               │               │
     │       │               ▼               │
     │       │  ┌────────────────────────┐   │
     │       │  │ LAYER 2 — PROCESS      │   │
     │       │  │ DECOMPOSITION          │   │
     │       │  │ Skill: process-        │   │
     │       │  │   decomposer (NEW)     │   │
     │       │  │ • Define outcome       │   │
     │       │  │ • Decompose steps      │   │
     │       │  │ • Assign skills/tools  │   │
     │       │  │ • Resolve knowledge    │   │
     │       │  │   gaps                 │   │
     │       │  │ Artifact → process.md  │   │
     │       │  └───────────┬────────────┘   │
     │       │              │                │
     │       │              ▼                │
     │       │  ┌────────────────────────────▼───────┐
     │       │  │ LAYER 3 — ARCHITECTURE DESIGN      │
     │       │  │ Skill: agent-builder (NEW)        │
     │       │  │ • Single agent / multi-agent?       │
     │       │  │ • Topology + orchestration rules    │
     │       │  │ • Per agent: skills[], tools[],     │
     │       │  │   prompt, knowledge[]               │
     │       │  │ Artifact → docs/architecture/       │
     │       │  └────────────────────┬───────────────┘
     │       │                       │
     │       │  ┌────────────────────▼───────────────┐
     │       │  │ LAYER 3.5 — SETUP EVALUATION       │
     │       │  │ Agent: setup-evaluator (NEW)        │
     │       │  │ • Validates decomposition quality   │
     │       │  │ • Validates architecture decisions  │
     │       │  │ • Catches errors before execution   │
     │       │  │ Fires after arch spec exists for    │
     │       │  │ agent-chain tasks                   │
     │       │  └────────────────────┬───────────────┘
     │       │                       │
     │       │  ┌────────────────────▼───────────────┐
     │       │  │ LAYER 4 — ORCHESTRATION CONFIG     │
     │       │  │ Skill: project-orchestrator (MOD)  │
     │       │  │ • Receives architecture spec       │
     │       │  │ • Writes / updates AGENTS.md       │
     │       │  │ • Writes orchestration docs        │
     │       │  │ Artifact → AGENTS.md               │
     │       │  └────────────────────┬───────────────┘
     │       │                       │
     ▼       ▼                       ▼
┌─────────────────────────────────────────────────────┐
│  LAYER 5 — EXECUTION                                │
│  Existing skill library (unchanged)                 │
│  Results logged → docs/skill-outputs/SKILL-OUTPUTS  │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│  LAYER 6 — EXECUTION FEEDBACK                       │
│  Owned by: project-orchestrator                     │
│  • After execution: update process entry            │
│  • Record actual vs planned steps                   │
│  • Record outcome achieved: yes / partial / no      │
│  • Update topology_used + link to arch spec         │
│  • Re-evaluate outcome cluster membership           │
│  Closes the learning loop for process.md            │
└─────────────────────────────────────────────────────┘
```

### Key Design Principle

`project-orchestrator` is **execution configuration and feedback ownership** — it translates a spec into AGENTS.md, wraps execution, and writes back execution results. `agent-builder` is **structural design** — it decides what to build. `process-decomposer` is **task reasoning** — it figures out what needs to happen and in what order. `setup-evaluator` is **quality assurance** — it validates decomposition and architecture before execution begins. These are four distinct responsibilities that must not bleed into each other.

### Fast-Path Principle

Not every task needs the full pipeline. The complexity triage (Layer 1) is the first thing that fires and decides:
- **Exact match in process.md** → skip design layers; hand the matched process to `project-orchestrator` to replay Layer 5 and own Layer 6 write-back
- **Single skill** → route directly, no decomposition or architecture needed
- **Skill chain** → decompose (Layer 2), skip architecture (Layer 3), then execute through `project-orchestrator`
- **Agent chain** → full pipeline through all layers, with setup evaluation after architecture design and before orchestration config

This prevents the system from being heavyweight for simple tasks while still providing the full reasoning stack for complex ones.

---

## 3. New Skills to Create

### 3.1 `process-decomposer`

**Purpose:** Take any user input (description, doc, PRD, notes) and decompose it into a structured, outcome-defined, step-by-step process. Store the result as a reusable entry in the process registry. Learn from past entries over time.

**Trigger phrases:** "decompose this", "break this down", "what steps do I need", "plan this out", "what's the process for", "how do I approach this"

**Inputs:**
- User natural language description (primary)
- Existing docs: PRD, spec, brainstorming output, notes (optional, read from `docs/`)
- `docs/processes/process.md` — checked first before any decomposition begins

**Step-by-step behavior:**

```
STEP 0 — COMPLEXITY TRIAGE (Layer 1 — fires first, before any decomposition)
  0a. Read docs/processes/process.md (all volumes: process.md, process-2.md, etc.)
      Does an exact match exist (same outcome cluster + same nuance)?
        EXACT MATCH → present to user: "Found an exact matching process."
          → Skip Layers 2-4 design work.
          → Hand matched process entry to project-orchestrator for replay.
          → No brainstorming, no agent architecture needed.
          → DONE — exit early.
        Partial match → present to user: "Found a related process. Adapt it?"
          → Proceed to Step 1 with the partial match as starting scaffold.
        No match → proceed to Step 1 fresh.

  0b. Assess task complexity (only if no exact match):
      - Single skill sufficient?
          → Route directly to skill. No decomposition needed. DONE.
      - Multi-step but sequential, no specialization?
          → Mark as SKILL-CHAIN. Proceed to Steps 1-4.
          → After Step 4: skip agent-builder (Layer 3).
          → Hand process entry to project-orchestrator for execution + write-back.
      - Parallel steps OR distinct agent specialization needed?
          → Mark as AGENT-CHAIN. Proceed to Steps 1-4.
          → After Step 4: hand off to agent-builder (Layer 3).
          → agent-builder writes architecture spec.
          → setup-evaluator validates process entry + architecture spec.
          → PASS → hand off to project-orchestrator (Layer 4).
          → FAIL → return issues to agent-builder for revision.

STEP 1 — DEFINE OUTCOME FIRST
  Ask user: "What does done look like? What is the measurable outcome?"
  Outcome must be defined before any step decomposition begins.
  This is a hard gate — do not proceed without an outcome definition.

STEP 2 — DECOMPOSE INTO STEPS
  Break the task into ordered steps (or mark parallel where appropriate)
  For each step:
    - Description: what happens in this step
    - Skill: which skill from .agents/skills/ handles this?
      → Call skill-finder to check: does this skill exist? full/partial overlap?
    - Tool: what tool does this step need?
      → Call tool-finder to identify: is the tool available? CLI compatible? MCP needed?
    - Knowledge needed: what does the agent need to know to execute this step?
      → If missing: flag it, ask user to provide OR flag for web scrape

STEP 3 — KNOWLEDGE GAP RESOLUTION
  For each flagged knowledge gap:
    Ask user: can you provide this? (file, doc, URL)
    If user cannot: flag as [KNOWLEDGE-GAP: web-scrape-needed] in the process entry
    Do not block execution — proceed with gaps flagged

STEP 4 — WRITE PROCESS ENTRY
  Write to docs/processes/YYYY-MM-DD-<task-slug>.md
  Append summary entry to docs/processes/process.md
  Tag with outcome cluster (see Section 6 — process.md schema)
  Output contract:
    - process_entry_ref
    - complexity_class

STEP 5 — PATTERN LEARNING (if reuse or adaptation)
  If this run adapted an existing process:
    Store as new variant entry linked to original
    Log what changed and why

  EXECUTION FEEDBACK (owned by project-orchestrator — see Section 4.1):
    project-orchestrator wraps execution (Layer 5) and is responsible for
    calling back AFTER execution completes to update the process entry:
      - Record actual steps vs planned steps
      - Record outcome achieved: yes / partial / no
      - Record topology_used + link to architecture spec
      - Update process entry with execution delta
      - Re-evaluate outcome cluster membership
    This closes the learning loop. process-decomposer does NOT poll for
    completion — project-orchestrator pushes the update.

HANDOFF CONTRACTS
  - process-decomposer → project-orchestrator:
      exact-match or skill-chain paths pass process_entry_ref
  - process-decomposer → agent-builder:
      agent-chain path passes process_entry_ref + complexity_class
  - agent-builder → setup-evaluator:
      passes process_entry_ref + architecture_spec_ref
  - setup-evaluator → project-orchestrator:
      PASS with process_entry_ref + architecture_spec_ref
  - setup-evaluator → agent-builder:
      FAIL with issue list for revision
```

**Primitives:**

| Primitive | What | Notes |
|-----------|------|-------|
| **Skills called** | `skill-finder` (new), `tool-finder` (new), `research-skill` (for knowledge gaps) | Must not call `universal-skill-creator` directly — only `skill-finder` decides if a new skill is needed |
| **Tools** | File read, File write, Web search (knowledge gaps), User prompt | |
| **Prompts** | Outcome elicitation, Step decomposition, Similarity matching, Gap identification | Four distinct focused prompts — do not collapse into one |
| **Knowledge** | `docs/processes/process.md`, `.agents/skills/` directory listing, current project context | Must read skill library before assigning skills to steps |
| **Memory** | Past process entries + outcome clusters | The learning loop — enables reuse without re-decomposition |

**Output artifacts:**
- `docs/processes/YYYY-MM-DD-<task-slug>.md` — individual process entry
- `docs/processes/process.md` — updated registry (or next volume if current exceeds size limit)

**Triage output (Step 0):**
- `complexity_class`: `exact-match` | `single-skill` | `skill-chain` | `agent-chain`
- This determines which downstream layers are invoked (see Section 2 architecture diagram)

---

### 3.2 `agent-builder`

**Purpose:** Given a decomposed process (from `process-decomposer`), decide the correct execution structure: single skill, single agent, or multi-agent. Design the topology. For `agent-chain` tasks, write the architecture spec, invoke setup evaluation with the required inputs, and only then hand approved work to `project-orchestrator`.

**Trigger phrases:** "design an agent for this", "what agent structure do I need", "architect this", "should this be multi-agent", "what's the right execution structure"

**Inputs:**
- Output of `process-decomposer` (process.md entry) — primary input
- Can also be triggered directly by user with a description (will call `process-decomposer` first if no process entry exists)

**Decision tree:**

```
Read decomposed process: steps, skills, tools, parallelism markers
            │
            ▼
   Is it 1 step, 1 skill?
   YES → Route directly to skill. No agent needed. Done.
            │
            ▼ NO
   Multi-step but fully sequential, no specialization?
   YES → Single agent + ordered skill stack
         Write: agent role, skills[], tools[], prompt, knowledge[]
            │
            ▼ NO
   Parallel steps OR steps requiring distinct specialization?
   YES → Multi-agent topology:
         1. Identify agent boundaries — what does each agent own?
         2. Decide topology:
            - Sequential pipeline: A → B → C
            - Parallel fan-out: orchestrator → [A, B, C] → merge
            - Hierarchical: orchestrator → sub-orchestrators → workers
         3. For each agent define:
            - Role description (used as prompt)
            - skills[]: list of skills this agent uses
            - tools[]: list of tools this agent needs
            - knowledge[]: what this agent needs to know (placeholder — see Section 8)
            - memory[]: what this agent reads/writes to memory (placeholder)
            - input: what it receives
            - output: what it produces
         4. Define orchestrator agent:
            - How it routes between agents
            - How it handles failures
            - How it merges outputs
            - Handoff protocol between agents
            │
            ▼
   Write architecture spec
            │
            ▼
   Invoke setup-evaluator with process entry + architecture spec
            │
      PASS  ▼  FAIL
   hand to     return issues to
   project-    agent-builder for
   orchestrator revision
```

**Primitives:**

| Primitive | What | Notes |
|-----------|------|-------|
| **Skills called** | `agent-system-architecture` (existing — for complex topology), `create-agent-prompt` (new — generates agent role prompts), `project-orchestrator` (downstream handoff) | Reuses existing architecture skill; does not duplicate it |
| **Tools** | File read (process entry), File write (architecture spec), User prompt (confirm topology if ambiguous) | |
| **Prompts** | Decision tree evaluation prompt, Topology design prompt, Agent boundary definition prompt, Handoff spec prompt | Each decision node has its own focused prompt |
| **Knowledge** | Process entry, available skills list, platform constraints (does this platform support parallel agents?), agent primitive template | |
| **Memory** | Past architecture decisions and outcomes — "this class of process → this topology worked" (placeholder) | |

**Output artifact:** Architecture spec — persisted to `docs/architecture/YYYY-MM-DD-<task-slug>-arch.md` by default. The corresponding process entry in `process.md` links to this file via `architecture_spec_ref`. This enables the learning loop: when the process entry records outcome success/failure, the architecture decision is preserved alongside it so the system learns "this class of process → this topology worked." Output contract for approved agent-chain setups: `architecture_spec_ref` + `process_entry_ref` handed to `project-orchestrator` after `setup-evaluator` passes.

---

## 4. Modified Skill: `project-orchestrator`

**Current responsibility:** Decides execution structure + routes + writes AGENTS.md  
**New responsibility:** Receives either a matched process entry, a decomposed skill-chain process entry, or an approved architecture spec from `agent-builder`. Translates specs into AGENTS.md and any project orchestration documents. Executes routing at runtime and owns the write-back loop for every persisted process entry that reaches execution.

**What changes:**
- REMOVE: "decide structure" logic (now fully owned by `agent-builder`)
- ADD: Read `process_entry_ref` for exact-match and skill-chain executions
- ADD: Read approved architecture spec for agent-chain executions
- ADD: Write/update `AGENTS.md` from spec
- ADD: Write any project-specific orchestration docs the project needs
- KEEP: Runtime routing logic
- KEEP: Platform-specific AGENTS.md conventions

**Primitives:**

| Primitive | What | Notes |
|-----------|------|-------|
| **Skills called** | `library-skill` (sync indexes after AGENTS.md changes) | |
| **Tools** | File read (architecture spec), File write (AGENTS.md, orchestration docs), File edit (update existing AGENTS.md) | |
| **Prompts** | AGENTS.md generation prompt, Routing rules prompt, Agent boundary documentation prompt | |
| **Knowledge** | Architecture spec from `agent-builder`, existing AGENTS.md if present, platform-specific orchestration conventions | Codex CLI, Claude Code, Warp, and Ampcode handle multi-agent differently |
| **Memory** | Past AGENTS.md patterns that worked (placeholder) | |

### 4.1 Execution Feedback Protocol

`project-orchestrator` owns the execution feedback loop. This is the mechanism that closes the learning loop in `process.md`.

**How it works:**

```
project-orchestrator receives:
  - process_entry_ref for exact-match replay or skill-chain execution
  - process_entry_ref + architecture_spec_ref for approved agent-chain execution
         │
         ▼
  Writes AGENTS.md + orchestration docs as needed
         │
         ▼
  Launches execution (Layer 5)
         │
         ▼
  Execution completes (all skills/agents finish)
         │
         ▼
  project-orchestrator updates the process entry:
    1. Read the process entry (docs/processes/YYYY-MM-DD-<task>.md)
    2. Fill in execution section:
       - actual_steps: how many steps actually ran
       - deviations: what changed from plan and why
       - outcome_achieved: true | partial | false
       - duration: approximate wall-clock time
       - topology_used: single-skill | single-agent | multi-agent-<topology>
       - architecture_spec_ref: link to docs/architecture/ file (if exists)
    3. Update process.md registry entry status
    4. Re-evaluate outcome cluster membership if outcome nuance changed
    5. Surface highest-success variant for next match
```

**Why project-orchestrator owns this (not process-decomposer):**
- `project-orchestrator` already wraps execution — it knows when execution starts and ends
- `process-decomposer` runs before execution — it would need to poll or be called back, which adds complexity
- Single owner for the write-back prevents race conditions on the process entry

**Invariant:** Every persisted process entry that reaches execution MUST do so under `project-orchestrator` control, and MUST have its execution section filled in by `project-orchestrator`. Entries with `status: executing` and no execution data after 24h are flagged as stale.

---

## 5. New Supporting Skills

These four supporting skills are referenced by the core skills above. Each is lean and single-purpose.

### 5.1 `skill-finder`

**Purpose:** Given a capability description, check the existing skill library for overlap. Decide: map to existing skill (full overlap), extend existing skill (partial overlap), or create new skill (no overlap). Prevents skill sprawl.

**Behavior:**
```
1. Read .agents/skills/ directory listing
2. Read SKILL-INDEX.md for descriptions
3. Compare capability description against existing skills
   - Full overlap  → return skill name, no action needed
   - Partial overlap → identify which section to add/extend in existing SKILL.md
                       → call universal-skill-creator with extend mode
   - No overlap    → call universal-skill-creator to create new skill
4. After any create/extend: call library-skill to sync SKILL-INDEX.md
5. Return: skill name (existing or new) to calling skill
```

**Hard rule:** Never create a new skill if an existing skill can be extended. Lean library is a first-class constraint. If in doubt, extend.

**Called by:** `process-decomposer`, `agent-builder`

---

### 5.2 `tool-finder`

**Purpose:** Given a tool requirement, identify the right tool, confirm CLI compatibility, check if an MCP server is needed and whether it is already configured. If not configured, ask the user to set it up.

**Behavior:**
```
1. Identify tool category: file I/O, web search, code execution,
   database, external API, MCP server, custom CLI
2. Check if tool is available in the current environment
3. If MCP server required:
   - Is it already running / configured?
     YES → return tool name and MCP command
     NO  → prompt user: "This step needs [tool] via MCP.
            Run: [mcp command]. Confirm when done."
4. If tool is unavailable and cannot be configured:
   - Flag step as [TOOL-UNAVAILABLE] in process entry
   - Suggest alternative tool if one exists
5. Return: tool name, availability status, setup instructions if needed
```

**Called by:** `process-decomposer`, `agent-builder`

---

### 5.3 `create-agent-prompt`

**Purpose:** Create focused, high-quality role prompts for agents in a multi-agent topology. Prompt creation is a specialized skill — orchestrators and architects are not good prompt creators by default. This skill ensures every agent has a well-formed role prompt that clearly defines its identity, boundaries, and handoff protocol.

**Scope (v1):** Agent role prompts only. This keeps the skill lean and focused on the primary consumer: `agent-builder`.

**When invoked:**
- By `agent-builder` to generate role prompts for each agent in a multi-agent topology
- Directly by the user: "create an agent prompt for...", "write a role prompt for..."

**Behavior:**
```
1. Gather context: what is this agent's role in the topology?
   - What does it own?
   - What does it receive as input?
   - What does it produce as output?
   - Who does it hand off to?
2. Apply agent role prompt structure:
   - Role / identity: who is this agent?
   - Responsibilities: what does it do and NOT do?
   - Skills & tools: what is it allowed to use?
   - Input contract: what format does it receive?
   - Output contract: what format does it produce?
   - Handoff protocol: how does it pass work to the next agent?
   - Failure behavior: what does it do when it gets stuck?
3. Validate: does the prompt have a clear success criterion?
4. Return: prompt text, ready to embed in AGENTS.md
```

**Leanness rule:** `create-agent-prompt` writes agent role prompts only. It does not execute them, validate them against a model, or manage prompt versioning.

**Called by:** `agent-builder`, user (direct)

**TODO — Future prompt skills (not implemented in this version):**
- `create-system-prompt` — system prompts that set agent identity + constraints
- `create-task-prompt` — one-time instructions for specific execution steps
- `create-skill-prompt` — prompts for invoking skills correctly
- These will be created via `skill-finder` when demand emerges

---

### 5.4 `knowledge-indexer` — TODO (deferred)

**Status:** Deferred to future version. Design is preserved here for reference but this skill is NOT implemented in the current phase.

**Rationale for deferral:** Without RAG, this skill is essentially a manifest builder (`find docs/ -name "*.md"` plus metadata). The value is limited until retrieval is implemented. In the interim, `process-decomposer` performs a simple `docs/` scan when resolving knowledge gaps. `knowledge-indexer` will be created via `skill-finder` when RAG is ready — it will be designed around actual retrieval needs rather than speculative ones.

**Preserved design (for future implementation):**
```
1. Scan current project for knowledge sources:
   - Markdown files in docs/
   - PDFs or asset documents (any attached files)
   - Any explicitly defined knowledge base paths in AGENTS.md
   - Any RAG DB connection strings (flagged as placeholder if RAG not configured)
2. Build knowledge manifest: docs/knowledge/KNOWLEDGE-INDEX.md
   Each entry:
     - Source path or connection
     - Type: markdown / PDF / asset / RAG-DB / external-URL
     - Status: available / placeholder / needs-scrape / user-must-provide
     - Topic tags for matching
3. When a process step flags a knowledge gap:
   - Check KNOWLEDGE-INDEX.md first
   - If found: return path/source to calling skill
   - If not found: flag as gap, ask user or flag for web scrape
4. Keep KNOWLEDGE-INDEX.md updated as new knowledge sources are added
```

**Memory slot (placeholder):** A `memory:` field exists in every process entry and agent definition. Memory is intentionally left open for future design. The current constraint: if a skill or agent declares `memory: [store-and-search]`, the system acknowledges it but does not implement it until the memory sub-system is designed. Nothing breaks — the field is a reserved placeholder.

**Will be called by (when implemented):** `process-decomposer`, `agent-builder`, user (direct: "index knowledge for this project")

---

### 5.5 `setup-evaluation` skill + `setup-evaluator` agent

**Problem:** Users may not be experts in agent architecture. Relying on user confirmation gates between layers assumes the user can spot bad decompositions or wrong topology choices. Instead, the system should validate its own setup before execution begins.

**Solution:** A `setup-evaluation` skill invoked by a `setup-evaluator` agent. The agent is spawned after `agent-builder` writes the architecture spec for an `agent-chain` task, because setup evaluation requires both the process entry and the architecture spec.

#### `setup-evaluation` skill

**Purpose:** Evaluate the quality of a process decomposition and its architecture design before execution begins. Catches structural errors, missing knowledge, unrealistic step ordering, and topology mismatches.

**Trigger:** Automatically invoked by `setup-evaluator` agent. Not directly user-invoked (though users can call it manually: "evaluate this setup").

**Behavior:**
```
1. Read the process entry (docs/processes/YYYY-MM-DD-<task>.md)
2. Read the architecture spec (docs/architecture/YYYY-MM-DD-<task>-arch.md)
3. Evaluate decomposition quality:
   - Does every step have a skill assigned? (no orphan steps)
   - Does every step have a tool confirmed as available?
   - Are parallel_with markers consistent? (no circular dependencies)
   - Are knowledge gaps flagged and acknowledged?
   - Is the outcome definition measurable and specific?
4. Evaluate architecture quality:
   - Does the topology match the parallelism in the process?
   - Does each agent have a clear boundary? (no overlapping ownership)
   - Are handoff protocols defined between every pair of connected agents?
   - Is the orchestrator's failure handling defined?
   - Do agent role prompts exist for every agent? (create-agent-prompt called?)
5. Cross-validate:
   - Does the architecture spec reference the correct process entry?
   - Do the skills in the architecture match the skills in the process?
   - Are there steps in the process not covered by any agent?
6. Output: PASS (proceed to orchestration config) or FAIL with specific issues list
   - On FAIL: return issues to agent-builder for revision
   - On PASS: hand off to project-orchestrator (Layer 4)
```

#### `setup-evaluator` agent

**Purpose:** An agent (not a skill) that orchestrates the setup validation. Spawned automatically — the user does not need to invoke it.

**When spawned:**
- By `agent-builder` after it writes `architecture_spec_ref` for `complexity_class = agent-chain`
- Runs between Layer 3 (Architecture Design) and Layer 4 (Orchestration Config)

**Agent definition:**
```yaml
role: "Setup Evaluator — validates process decomposition and architecture
       design before execution begins. Does NOT modify the setup — only
       evaluates and reports. If issues are found, hands back to
       agent-builder for revision."
skills: [setup-evaluation]
tools: [file-read]
input: process entry path + architecture spec path
output: PASS or FAIL with issues list
failure_behavior: "Report all issues at once. Do not fix — only evaluate."
```

**Why an agent and not just a skill?** The evaluation needs to run independently from the architect that produced the design. If `agent-builder` self-evaluated, it would have confirmation bias toward its own decisions. A separate agent provides an independent perspective.

**Called by:** `agent-builder` (automatic for agent-chain tasks), user (manual: "evaluate this setup")

---

## 6. The `process.md` Registry

### 6.1 Location
```
docs/processes/
  process.md                        ← master registry + outcome cluster index (volume 1)
  process-2.md                      ← volume 2 (created when process.md exceeds size limit)
  process-N.md                      ← additional volumes as needed
  YYYY-MM-DD-<task-slug>.md         ← individual process entries
```

### 6.1.1 Scaling Strategy

`process.md` is a search index — it is expected to grow over time. It is NOT pruned or archived.

**Volume splitting:** When a process.md volume exceeds 500 lines, `process-decomposer` creates the next volume (`process-2.md`, `process-3.md`, etc.). The triage step (Step 0) reads ALL volumes when checking for matches. New entries are appended to the latest volume.

**Why not prune:** Every completed process entry has value for future matching. Pruning would destroy the learning loop's long-term memory. The cost of reading multiple volumes is low compared to re-decomposing a task that was already solved.

**Index header in each volume:** Each volume starts with a pointer to all other volumes so any volume can be the entry point:
```markdown
<!-- Process Registry — Volume N of M -->
<!-- Other volumes: process.md, process-2.md, ... -->
```

### 6.2 Individual Process Entry Schema

```yaml
# docs/processes/YYYY-MM-DD-<task-slug>.md

id: proc-YYYY-MM-DD-NNN
date: YYYY-MM-DD
status: planned | executing | completed | failed | adapted

task:
  description: "<what the user wanted>"
  input_source: user-description | prd | spec | doc | brainstorming-output

outcome:
  definition: "<what done looks like — measurable>"
  outcome_cluster: "<category>/<sub-category>"   # e.g. feature-delivery/data-export
  nuance: "<what makes this outcome distinct from similar ones>"
  achieved: null | true | partial | false         # filled after execution

steps:
  - step: 1
    description: "<what happens>"
    skill: <skill-name>           # from .agents/skills/
    tool: <tool-name>             # from tool-finder
    knowledge_needed: "<description or null>"
    knowledge_source: user-provided | knowledge-index | web-scrape | null
    knowledge_gap: null | "<description of what is missing>"
    memory_needed: null | store | search | store-and-search  # placeholder
    parallel_with: null | [step-N, step-M]        # if this step runs in parallel
    prompt: null | "<custom prompt if needed>"
    status: planned | done | skipped | failed      # filled after execution

complexity_class: exact-match | single-skill | skill-chain | agent-chain
  # set by triage step (Step 0) — determines which layers fire

architecture:
  topology_used: null | single-skill | single-agent | multi-agent-sequential | multi-agent-parallel | multi-agent-hierarchical
  architecture_spec_ref: null | "docs/architecture/YYYY-MM-DD-<task>-arch.md"
  setup_evaluation: null | pass | fail
  setup_evaluation_issues: null | "<issues found by setup-evaluator>"

execution:
  planned_steps: N
  actual_steps: N
  deviations: null | "<what changed from plan and why>"
  outcome_achieved: null | true | partial | false
  duration: null | "<approximate>"
  reused_from: null | proc-ID     # if adapted from a previous process
  stored_as_variant: false | true
  variant_of: null | proc-ID

pattern_tags:
  - <tag-1>
  - <tag-2>
  # used for similarity matching and cluster assignment
```

### 6.3 `process.md` Master Registry Structure

```markdown
# Process Registry

## Outcome Clusters

### feature-delivery/
  - feature-delivery/data-export
      - proc-2026-04-10-001  [original]
      - proc-2026-04-15-047  [adapted — added streaming step]
      - proc-2026-04-22-089  [adapted — added multi-format support]
  - feature-delivery/auth-flow
      - proc-2026-04-11-002  [original]

### documentation/
  - documentation/prd
      - proc-2026-04-10-003  [original]

## Process Index (chronological)
| ID | Date | Task | Outcome Cluster | Topology | Status | Variant Of |
|----|------|------|-----------------|----------|--------|------------|
| proc-001 | 2026-04-10 | Build data export | feature-delivery/data-export | multi-agent-parallel | completed | — |
```

### 6.4 Learning Loop

```
New task arrives
      │
      ▼
TRIAGE (Step 0 — process-decomposer)
  Read ALL process.md volumes
      │
  ┌───┴──────────────────────────────────────────┐
  │ EXACT MATCH (same cluster + same nuance)     │
  │   → Skip Layers 2-4 design work              │
  │   → Replay via project-orchestrator          │
  │   → No brainstorming, no arch design         │
  ├──────────────────────────────────────────────┤
  │ Partial match (same cluster, different nuance)│
  │   → Adapt: show diff, confirm                │
  │   → Assess complexity (single-skill /        │
  │     skill-chain / agent-chain)               │
  │   → Execute adapted version through          │
  │     appropriate layers                       │
  │   → Store as new variant entry               │
  │   → Link to original                         │
  ├──────────────────────────────────────────────┤
  │ No match                                     │
  │   → Assess complexity class                  │
  │   → single-skill: route directly, done       │
  │   → skill-chain: decompose, skip arch,       │
  │     execute via project-orchestrator         │
  │   → agent-chain: full pipeline;              │
  │     setup-evaluator runs after arch spec     │
  │   → Assign to existing cluster               │
  │     or create new cluster                    │
  │   → Store as new original                    │
  └──────────────────────────────────────────────┘
      │
      ▼
After execution (all paths — owned by project-orchestrator):
  - Update process entry: actual vs planned steps
  - Update outcome_achieved field
  - Record topology_used + link to architecture spec
  - Re-evaluate cluster membership if outcome nuance changed
  - Highest-success variant surfaces first on next match
```

**Outcome clusters are the primary grouping key**, not task descriptions. "Write a PRD" and "document requirements for payments feature" are different descriptions but the same outcome cluster (`documentation/prd`). Over time the agent learns: *this class of outcome → this family of processes tends to work*.

---

## 7. New Skill Taxonomy

The `project-specific` category is restructured into four named sub-groups in docs (file structure unchanged):

### Agent & Process Design
| Skill | Status | Description |
|-------|--------|-------------|
| `process-decomposer` | **NEW** | Complexity triage + decomposes tasks into structured, outcome-defined process entries |
| `agent-builder` | **NEW** | Designs execution structure: single skill / single agent / multi-agent |
| `setup-evaluation` | **NEW** | Validates decomposition + architecture quality before execution begins |
| `skill-finder` | **NEW** | Maps capability to existing skill or creates new one; prevents skill sprawl |
| `tool-finder` | **NEW** | Identifies tools, checks CLI compatibility, handles MCP setup |
| `create-agent-prompt` | **NEW** | Creates focused role prompts for agents in multi-agent topologies |
| `knowledge-indexer` | **TODO** | Indexes project knowledge sources; manages knowledge gaps (deferred to RAG phase) |
| `project-orchestrator` | **MODIFIED** | Receives architecture spec; writes AGENTS.md + orchestration docs; owns execution feedback loop |
| `project-setup` | existing | Interviews user; generates tailored AGENTS.md |

### Agents
| Agent | Status | Description |
|-------|--------|-------------|
| `setup-evaluator` | **NEW** | Spawned automatically after `agent-builder` writes an arch spec for agent-chain tasks; invokes `setup-evaluation` to validate setup before orchestration |

### Product & Specs
| Skill | Status |
|-------|--------|
| `product-soul` | existing |
| `prd-writing` | existing |
| `implementation-plan` | existing |
| `brainstorming` | existing |

### Engineering
| Skill | Status |
|-------|--------|
| `test-driven-development` | existing |
| `code-review-crsp` | existing |
| `debug-and-fix` | existing |
| `technical-debt-audit` | existing |
| `agent-system-architecture` | existing |
| `architectural-decision-log` | existing |

### Research & Docs
| Skill | Status |
|-------|--------|
| `generate-changelog` | existing |
| `codebase-understanding` | existing |
| `learn-from-paper` | existing |
| `apply-paper-to-project` | existing |

---

## 8. Knowledge & Memory — Placeholders

### Knowledge
Every agent definition and process entry has a `knowledge[]` field. In this version:
- `knowledge-indexer` is **deferred** (see Section 5.4) — will be built when RAG is ready
- In the interim: `process-decomposer` does a simple `docs/` scan when resolving knowledge gaps
- Knowledge sources (for future indexer): markdown files, PDFs, attached docs, external URLs, RAG DB connection strings
- RAG implementation is **out of scope** for this version — the field exists as a placeholder
- When a step needs knowledge: scan `docs/` directly → flag gap if not found → ask user

### Memory
Every agent definition and process entry has a `memory[]` field. In this version:
- Memory is a **reserved placeholder only**
- Valid values: `null`, `store`, `search`, `store-and-search`
- Nothing is implemented — declaring memory does not break anything
- The memory sub-system is a separate design effort, intentionally deferred
- The one invariant: memory declarations in process entries and AGENTS.md must be preserved as-is during any `improve-skills` or `compress-skill` runs — they are not dead code

---

## 9. Files to Create / Modify

### New files
```
.agents/skills/process-decomposer/SKILL.md      ← new skill (≤200 lines) — includes complexity triage
.agents/skills/agent-builder/SKILL.md         ← new skill (≤200 lines)
.agents/skills/setup-evaluation/SKILL.md        ← new skill (≤200 lines)
.agents/skills/skill-finder/SKILL.md            ← new skill (≤200 lines)
.agents/skills/tool-finder/SKILL.md             ← new skill (≤200 lines)
.agents/skills/create-agent-prompt/SKILL.md     ← new skill (≤200 lines) — agent role prompts only
docs/processes/process.md                       ← empty registry template
```

### Deferred files (TODO — created when needed)
```
.agents/skills/knowledge-indexer/SKILL.md       ← deferred to RAG phase
.agents/skills/create-system-prompt/SKILL.md    ← deferred — future prompt skill
.agents/skills/create-task-prompt/SKILL.md      ← deferred — future prompt skill
.agents/skills/create-skill-prompt/SKILL.md     ← deferred — future prompt skill
docs/knowledge/KNOWLEDGE-INDEX.md              ← deferred to RAG phase
```

### Modified files
```
.agents/skills/project-orchestrator/SKILL.md   ← remove structure-decision logic; add execution feedback protocol
.agents/ROUTING.md                              ← add routing rules for new skills
AGENTS.md                                       ← update user entry points
docs/SKILL-INDEX.md                             ← add new skills
README.md                                       ← update skill tables + daily workflow + TODOs
```

---

## 10. ROUTING.md Rules to Add

```
# New routing rules — add to .agents/ROUTING.md

## Process & Agent Design Layer

- "decompose" | "break down" | "plan this out" | "what steps"
    → process-decomposer (triage fires first — may short-circuit)
    (fires BEFORE agent-builder — decomposition must precede architecture)

- "design an agent" | "what agent structure" | "architect this" | "multi-agent"
    → agent-builder
    (if no process entry exists yet, agent-builder calls process-decomposer first)

- "what skill does this need" | "find a skill for" | "is there a skill that"
    → skill-finder
    (NOT universal-skill-creator directly — always go through skill-finder first)

- "what tool" | "do I need an MCP" | "is [tool] available"
    → tool-finder

- "create an agent prompt" | "write a role prompt for this agent"
    → create-agent-prompt

- "evaluate this setup" | "check the decomposition" | "validate the architecture"
    → setup-evaluation
    (also auto-invoked by setup-evaluator agent after agent-builder writes the arch spec for agent-chain tasks)

## Hard boundaries (never auto-invoked by routing)
- deprecate-skill    → user must explicitly request
- publish-skill      → user must explicitly request
- process-decomposer → does NOT replace brainstorming
                       brainstorming = design approval (upstream)
                       process-decomposer = execution planning (downstream)
- setup-evaluator    → auto-spawned by agent-builder after arch spec exists for agent-chain only
                       (not routed by keyword — spawned programmatically)

## Triage short-circuits (process-decomposer Step 0)
  exact-match  → skip design layers, replay via project-orchestrator
  single-skill → route directly to skill, no decomposition
  skill-chain  → decompose (Layer 2), skip architecture (Layer 3), execute via project-orchestrator
  agent-chain  → full pipeline + setup-evaluator after architecture spec exists

## Firing order for full task execution (agent-chain)
  brainstorming (if needed)
    → process-decomposer (triage → decompose)
      → agent-builder
        → setup-evaluator (auto)
          → project-orchestrator
            → execution
              → execution feedback (project-orchestrator updates process.md)
```

---

## 11. Quality & Anti-Sprawl Rules

- Every new skill must pass `agentskills validate` and score ≥ 10/14
- Every new skill must be ≤ 200 lines
- `skill-finder` is the gatekeeper for new skill creation — no skill is created by any other path
- `process.md` is owned by `process-decomposer` — no other skill writes to it directly
- `process.md` volumes are split at 500 lines — never pruned, never archived (it's a search index)
- Architecture specs are persisted to `docs/architecture/` by default — never ephemeral
- `setup-evaluator` agent fires automatically for `agent-chain` tasks after the architecture spec exists — not optional
- Execution feedback (Section 4.1) is mandatory — every executed process entry must have its execution section filled
- No persisted process entry may bypass `project-orchestrator` on its way to execution
- Memory fields are reserved — any `compress-skill` or `improve-skills` run must preserve them
- `secure-*` skills gate all external knowledge ingestion — when `knowledge-indexer` is built, it must call `secure-skill-content-sanitization` before indexing any external source

---

## 12. Open Questions

- **Memory sub-system design** — What is the full data model? Key-value? Vector? Per-agent or shared? Scoped to project or global? This is a significant separate design effort.
- **tool-finder scope** — Should it also handle tool installation (npm install, pip install) or strictly discovery and MCP config?
- **create-agent-prompt versioning** — Should agent role prompts in AGENTS.md carry a version number so they can be improved without losing the original?
- **knowledge-indexer + RAG** — When RAG is added, does `knowledge-indexer` become the RAG ingestion layer, or is that a separate skill (`knowledge-ingestor`)?
- **setup-evaluator iteration limit** — How many times can setup-evaluator reject and send back to agent-builder before escalating to the user? Infinite loops are a risk.
- **Cross-volume similarity matching** — As process.md splits into multiple volumes, should the triage step use tag-based filtering first to narrow which volumes to read, or always read all volumes?

### Resolved Questions

- ~~**process.md growth management**~~ → Resolved: split into volumes at 500 lines, never prune (Section 6.1.1)
- ~~**process-decomposer as autonomous trigger**~~ → Resolved: complexity triage (Step 0) handles this — exact matches and single-skill tasks short-circuit automatically, full pipeline only fires for complex tasks (Section 3.1)
- ~~**Architecture spec persistence**~~ → Resolved: persisted by default to `docs/architecture/`, linked from process entry (Section 3.2)
- ~~**User validation of architecture**~~ → Resolved: `setup-evaluator` agent validates automatically instead of relying on user expertise (Section 5.5)

---

*Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`.*
