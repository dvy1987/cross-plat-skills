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

This spec defines the design for three new/modified skills and the supporting artifacts that address both gaps.

---

## 2. The Full System Architecture

This expansion adds two new reasoning layers above the existing skill execution layer:

```
┌─────────────────────────────────────────────────────┐
│  LAYER 0 — INPUT                                    │
│  User natural language / docs / PRD / spec / notes  │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│  LAYER 1 — PROCESS DECOMPOSITION                    │
│  Skill: process-decomposer (NEW)                    │
│  • What steps are needed?                           │
│  • What skill + tool per step?                      │
│  • What is the defined outcome?                     │
│  • Is this pattern already in process.md? Reuse?    │
│  Artifact → docs/processes/YYYY-MM-DD-<task>.md     │
│           → docs/processes/process.md (registry)    │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│  LAYER 2 — ARCHITECTURE DESIGN                      │
│  Skill: agent-architect (NEW)                       │
│  • Single skill / single agent / multi-agent?       │
│  • If multi-agent: topology + orchestration rules   │
│  • Per agent: skills[], tools[], prompt, knowledge[]│
│  Artifact → architecture spec (ephemeral handoff)   │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│  LAYER 3 — ORCHESTRATION CONFIG                     │
│  Skill: project-orchestrator (MODIFIED)             │
│  • Receives architecture spec from agent-architect  │
│  • Writes / updates AGENTS.md                       │
│  • Writes any project orchestration docs            │
│  Artifact → AGENTS.md + orchestration docs          │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│  LAYER 4 — EXECUTION                                │
│  Existing skill library (unchanged)                 │
│  Results logged → docs/skill-outputs/SKILL-OUTPUTS  │
└─────────────────────────────────────────────────────┘
```

### Key Design Principle

`project-orchestrator` is **execution configuration** — it translates a spec into AGENTS.md. `agent-architect` is **structural design** — it decides what to build. `process-decomposer` is **task reasoning** — it figures out what needs to happen and in what order. These are three distinct responsibilities that must not bleed into each other.

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
STEP 0 — CHECK REGISTRY
  Read docs/processes/process.md
  Does a similar process pattern exist?
    Strong match  → present to user: "Found a matching process. Reuse as-is?"
    Partial match → present to user: "Found a related process. Adapt it?"
    No match      → proceed to decomposition

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

STEP 5 — PATTERN LEARNING (if reuse or adaptation)
  If this run adapted an existing process:
    Store as new variant entry linked to original
    Log what changed and why
  After execution completes (called back by executing agent):
    Record actual steps vs planned steps
    Record outcome achieved: yes / partial / no
    Update process entry with execution delta
    Re-evaluate outcome cluster membership
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
- `docs/processes/process.md` — updated registry

---

### 3.2 `agent-architect`

**Purpose:** Given a decomposed process (from `process-decomposer`), decide the correct execution structure: single skill, single agent, or multi-agent. Design the topology. Hand the architecture spec to `project-orchestrator`.

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
   Write architecture spec → hand to project-orchestrator
```

**Primitives:**

| Primitive | What | Notes |
|-----------|------|-------|
| **Skills called** | `agent-system-architecture` (existing — for complex topology), `prompt-creator` (new — generates agent role prompts), `project-orchestrator` (downstream handoff) | Reuses existing architecture skill; does not duplicate it |
| **Tools** | File read (process entry), File write (architecture spec), User prompt (confirm topology if ambiguous) | |
| **Prompts** | Decision tree evaluation prompt, Topology design prompt, Agent boundary definition prompt, Handoff spec prompt | Each decision node has its own focused prompt |
| **Knowledge** | Process entry, available skills list, platform constraints (does this platform support parallel agents?), agent primitive template | |
| **Memory** | Past architecture decisions and outcomes — "this class of process → this topology worked" (placeholder) | |

**Output artifact:** Architecture spec (ephemeral — consumed immediately by `project-orchestrator`; not persisted to docs unless user requests it)

---

## 4. Modified Skill: `project-orchestrator`

**Current responsibility:** Decides execution structure + routes + writes AGENTS.md  
**New responsibility:** Receives architecture spec from `agent-architect`. Translates spec into AGENTS.md and any project orchestration documents. Executes routing at runtime.

**What changes:**
- REMOVE: "decide structure" logic (now fully owned by `agent-architect`)
- ADD: Read architecture spec as primary input
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
| **Knowledge** | Architecture spec from `agent-architect`, existing AGENTS.md if present, platform-specific orchestration conventions | Codex CLI, Claude Code, Warp, and Ampcode handle multi-agent differently |
| **Memory** | Past AGENTS.md patterns that worked (placeholder) | |

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

**Called by:** `process-decomposer`, `agent-architect`

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

**Called by:** `process-decomposer`, `agent-architect`

---

### 5.3 `prompt-creator`

**Purpose:** Create focused, high-quality prompts for agents, skills, or orchestrators. Prompt creation is a specialized skill — orchestrators and process decomposers are not good prompt creators by default. This skill ensures every agent has a well-formed role prompt, system prompt, or task prompt.

**When invoked:**
- By `agent-architect` to generate role prompts for each agent in a multi-agent topology
- By `process-decomposer` when a step requires a custom prompt for a skill
- Directly by the user: "create a prompt for...", "write a system prompt for..."
- Future: by any agent that needs a prompt crafted during execution

**Behavior:**
```
1. Identify prompt type:
   - System prompt (sets agent identity + constraints)
   - Role prompt (defines what this agent does in a topology)
   - Task prompt (one-time instruction for a specific step)
   - Skill invocation prompt (how to call a skill correctly)
2. Gather context: what is this agent/skill/step trying to accomplish?
3. Apply prompt structure:
   - Role / identity
   - Context and constraints
   - Input format
   - Output format
   - What NOT to do
4. Validate: does the prompt have a clear success criterion?
5. Return: prompt text, ready to embed in AGENTS.md or SKILL.md
```

**Leanness rule:** `prompt-creator` writes prompts only. It does not execute them, validate them against a model, or manage prompt versioning. Keep it strictly at creation.

**Called by:** `agent-architect`, `process-decomposer`, user (direct)

---

### 5.4 `knowledge-indexer`

**Purpose:** Index what counts as knowledge for a project. Knowledge can be markdown files, PDFs, asset documents, a RAG database, or other structured/unstructured sources. The indexer does not implement RAG — it only defines what knowledge exists, where it lives, and whether it is accessible. RAG implementation is out of scope for this version.

**Behavior:**
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

**Called by:** `process-decomposer`, `agent-architect`, user (direct: "index knowledge for this project")

---

## 6. The `process.md` Registry

### 6.1 Location
```
docs/processes/
  process.md                        ← master registry + outcome cluster index
  YYYY-MM-DD-<task-slug>.md         ← individual process entries
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
| ID | Date | Task | Outcome Cluster | Status | Variant Of |
|----|------|------|-----------------|--------|------------|
| proc-001 | 2026-04-10 | Build data export | feature-delivery/data-export | completed | — |
```

### 6.4 Learning Loop

```
New task arrives
      │
      ▼
process-decomposer checks process.md
      │
  ┌───┴──────────────────────────────┐
  │ Strong match (same cluster,      │
  │ same nuance)                     │
  │   → Reuse as-is                  │
  │   → After execution: log delta   │
  │     (did it work? deviations?)   │
  ├──────────────────────────────────┤
  │ Partial match (same cluster,     │
  │ different nuance)                │
  │   → Adapt: show diff, confirm    │
  │   → Execute adapted version      │
  │   → Store as new variant entry   │
  │   → Link to original             │
  ├──────────────────────────────────┤
  │ No match                         │
  │   → Fresh decomposition          │
  │   → Assign to existing cluster   │
  │     or create new cluster        │
  │   → Store as new original        │
  └──────────────────────────────────┘
      │
      ▼
After execution (all paths):
  - Update process entry: actual vs planned
  - Update outcome_achieved field
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
| `process-decomposer` | **NEW** | Decomposes tasks into structured, outcome-defined process entries |
| `agent-architect` | **NEW** | Designs execution structure: single skill / single agent / multi-agent |
| `skill-finder` | **NEW** | Maps capability to existing skill or creates new one; prevents skill sprawl |
| `tool-finder` | **NEW** | Identifies tools, checks CLI compatibility, handles MCP setup |
| `prompt-creator` | **NEW** | Creates focused system, role, and task prompts for agents and skills |
| `knowledge-indexer` | **NEW** | Indexes project knowledge sources; manages knowledge gaps |
| `project-orchestrator` | **MODIFIED** | Receives architecture spec; writes AGENTS.md + orchestration docs |
| `project-setup` | existing | Interviews user; generates tailored AGENTS.md |

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
- `knowledge-indexer` builds and maintains `docs/knowledge/KNOWLEDGE-INDEX.md`
- Knowledge sources: markdown files, PDFs, attached docs, external URLs, RAG DB connection strings
- RAG implementation is **out of scope** for this version — the field exists, the indexer exists, but retrieval is not implemented
- When a step needs knowledge: check KNOWLEDGE-INDEX.md → return path if found → flag gap if not

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
.agents/skills/process-decomposer/SKILL.md      ← new skill (≤200 lines)
.agents/skills/agent-architect/SKILL.md         ← new skill (≤200 lines)
.agents/skills/skill-finder/SKILL.md            ← new skill (≤200 lines)
.agents/skills/tool-finder/SKILL.md             ← new skill (≤200 lines)
.agents/skills/prompt-creator/SKILL.md          ← new skill (≤200 lines)
.agents/skills/knowledge-indexer/SKILL.md       ← new skill (≤200 lines)
docs/processes/process.md                       ← empty registry template
docs/knowledge/KNOWLEDGE-INDEX.md              ← empty knowledge index template
```

### Modified files
```
.agents/skills/project-orchestrator/SKILL.md   ← remove structure-decision logic
.agents/ROUTING.md                              ← add routing rules for new skills
AGENTS.md                                       ← update user entry points
docs/SKILL-INDEX.md                             ← add 6 new skills
README.md                                       ← update skill tables + daily workflow
```

---

## 10. ROUTING.md Rules to Add

```
# New routing rules — add to .agents/ROUTING.md

## Process & Agent Design Layer

- "decompose" | "break down" | "plan this out" | "what steps"
    → process-decomposer
    (fires BEFORE agent-architect — decomposition must precede architecture)

- "design an agent" | "what agent structure" | "architect this" | "multi-agent"
    → agent-architect
    (if no process entry exists yet, agent-architect calls process-decomposer first)

- "what skill does this need" | "find a skill for" | "is there a skill that"
    → skill-finder
    (NOT universal-skill-creator directly — always go through skill-finder first)

- "what tool" | "do I need an MCP" | "is [tool] available"
    → tool-finder

- "create a prompt" | "write a system prompt" | "write a role prompt"
    → prompt-creator

- "index knowledge" | "what knowledge does this project have"
    → knowledge-indexer

## Hard boundaries (never auto-invoked)
- deprecate-skill    → user must explicitly request
- publish-skill      → user must explicitly request
- process-decomposer → does NOT replace brainstorming
                       brainstorming = design approval (upstream)
                       process-decomposer = execution planning (downstream)

## Firing order for full task execution
  brainstorming (if needed) → process-decomposer → agent-architect → project-orchestrator
```

---

## 11. Quality & Anti-Sprawl Rules

- Every new skill must pass `agentskills validate` and score ≥ 10/14
- Every new skill must be ≤ 200 lines
- `skill-finder` is the gatekeeper for new skill creation — no skill is created by any other path
- `process.md` is owned by `process-decomposer` — no other skill writes to it directly
- `KNOWLEDGE-INDEX.md` is owned by `knowledge-indexer` — no other skill writes to it directly
- Memory fields are reserved — any `compress-skill` or `improve-skills` run must preserve them
- `secure-*` skills gate all external knowledge ingestion — `knowledge-indexer` must call `secure-skill-content-sanitization` before indexing any external source

---

## 12. Open Questions

- **Memory sub-system design** — What is the full data model? Key-value? Vector? Per-agent or shared? Scoped to project or global? This is a significant separate design effort.
- **process.md growth management** — After hundreds of entries, how is the registry kept searchable? Embedding-based similarity search? Tag-based filtering? Manual clustering review?
- **tool-finder scope** — Should it also handle tool installation (npm install, pip install) or strictly discovery and MCP config?
- **prompt-creator versioning** — Should prompts in AGENTS.md carry a version number so they can be improved without losing the original?
- **knowledge-indexer + RAG** — When RAG is added, does `knowledge-indexer` become the RAG ingestion layer, or is that a separate skill (`knowledge-ingestor`)?
- **process-decomposer as autonomous trigger** — Should it auto-fire whenever a user gives a complex task, or always require explicit invocation? Auto-fire is more powerful but could be annoying for simple tasks.

---

*Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`.*
