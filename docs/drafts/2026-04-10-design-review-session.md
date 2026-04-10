# Session Draft: Design Spec Review & Revision — 2026-04-10

**Purpose:** Full context dump of the design review session for the Agent Architecture & Process Expansion spec. Reference this file to resume work in a new session.

**Design spec location:** `docs/specs/2026-04-10-agent-process-expansion-design.md`

---

## 1. Repo Context

This is a **self-maintaining, cross-platform skill library** for AI coding tools (Codex CLI, Claude Code, Warp, Gemini CLI, etc.) implementing the agentskills.io standard. 42 skills across 4 categories (meta, thinking, project-specific, domain), all constrained to <=200 lines. The meta skills form a self-improvement loop: validate -> prune -> research -> rewrite -> compress/split. Installs globally via symlinks so skills are available in every tool and project.

---

## 2. What the Design Spec Proposes

The spec adds reasoning layers above the existing skill execution layer:

- **Layer 1 (Complexity Triage):** Checks process.md for matches, assesses complexity, routes accordingly
- **Layer 2 (Process Decomposition):** `process-decomposer` — decomposes tasks into steps with skills/tools/knowledge
- **Layer 3 (Architecture Design):** `agent-architect` — decides single-skill / single-agent / multi-agent topology
- **Layer 3.5 (Setup Evaluation):** `setup-evaluator` agent — validates decomposition + architecture before execution
- **Layer 4 (Orchestration Config):** `project-orchestrator` (modified) — writes AGENTS.md from arch spec
- **Layer 5 (Execution):** Existing skill library
- **Layer 6 (Execution Feedback):** `project-orchestrator` updates process entry after execution completes

Supporting skills: `skill-finder`, `tool-finder`, `create-agent-prompt`, `knowledge-indexer` (deferred)

---

## 3. Initial Review Feedback (from Claude)

8 points were raised. Here is what was decided for each:

### 3.1 Pipeline too heavyweight for simple tasks
- **Decision:** Add **complexity triage** as the first thing that fires (Layer 1 in process-decomposer Step 0)
- **Implementation:** 4 complexity classes: `exact-match` (skip everything), `single-skill` (route directly), `skill-chain` (decompose only, skip arch), `agent-chain` (full pipeline)
- **Status:** DONE — spec updated

### 3.2 Execution feedback loop underspecified
- **Problem:** Step 5 of process-decomposer said "called back by executing agent" but no mechanism existed for this callback
- **Decision:** `project-orchestrator` owns the feedback loop. It wraps execution and pushes updates back to process entries. No polling needed.
- **Implementation:** New Section 4.1 in the spec defines the protocol
- **Status:** DONE — spec updated

### 3.3 Architecture specs should be persisted
- **Decision:** Persist to `docs/architecture/YYYY-MM-DD-<task>-arch.md` by default (not ephemeral)
- **Implementation:** Process entry schema now has `architecture_spec_ref` and `topology_used` fields
- **Status:** DONE — spec updated

### 3.4 knowledge-indexer deferred
- **Decision:** Mark as TODO. Without RAG it's just a manifest builder. `process-decomposer` does simple docs/ scan in interim.
- **Status:** DONE — spec updated, Section 5.4 preserved but marked deferred

### 3.5 skill-finder kept as separate skill
- **Divya's decision:** Keep it separate. Users will create many skills, need help managing sprawl. Users may not know when to split.
- **Status:** No change needed — already in spec as separate skill

### 3.6 process.md scaling via volume splitting
- **Decision:** Split into process-2.md, process-3.md at 500 lines. Never prune — it's a search index.
- **Implementation:** New Section 6.1.1 defines the scaling strategy
- **Status:** DONE — spec updated

### 3.7 setup-evaluator instead of user confirmation gates
- **Divya's insight:** Users may not be experts in agent architecture. System should validate itself.
- **Decision:** `setup-evaluation` skill + `setup-evaluator` agent. Auto-spawned for agent-chain tasks. Separate agent avoids confirmation bias.
- **Implementation:** New Section 5.5 in the spec
- **Status:** DONE — spec updated

### 3.8 prompt-creator scoped down to create-agent-prompt
- **Decision:** Rename to `create-agent-prompt`, scope to agent role prompts only for v1
- **Other prompt types:** Listed as TODOs (create-system-prompt, create-task-prompt, create-skill-prompt)
- **Status:** DONE — spec updated

---

## 4. All Changes Applied to the Spec

| # | Section | Change |
|---|---------|--------|
| 1 | Section 1 (Motivation) | Added problem #3: no complexity triage |
| 2 | Section 2 (Architecture) | Rewrote diagram with Layers 1-6, triage short-circuits, setup-evaluator |
| 3 | Section 2 (Key Principles) | Added fast-path principle, setup-evaluator as 4th distinct responsibility |
| 4 | Section 3.1 (process-decomposer) | Rewrote Step 0 with full triage logic (exact-match/single-skill/skill-chain/agent-chain) |
| 5 | Section 3.1 (process-decomposer) | Rewrote Step 5 with execution feedback protocol owned by project-orchestrator |
| 6 | Section 3.1 (process-decomposer) | Added triage output (complexity_class) to output artifacts |
| 7 | Section 3.2 (agent-architect) | Changed output from ephemeral to persisted at docs/architecture/ |
| 8 | Section 3.2 (agent-architect) | Updated primitives: prompt-creator -> create-agent-prompt |
| 9 | Section 4 (project-orchestrator) | Added Section 4.1: Execution Feedback Protocol with full diagram |
| 10 | Section 5.3 | Renamed prompt-creator -> create-agent-prompt, narrowed scope, added TODOs |
| 11 | Section 5.4 | Marked knowledge-indexer as TODO/deferred with rationale |
| 12 | NEW Section 5.5 | Added setup-evaluation skill + setup-evaluator agent |
| 13 | Section 6.1 | Added volume splitting strategy (Section 6.1.1) |
| 14 | Section 6.2 | Added complexity_class + architecture block (topology_used, architecture_spec_ref, setup_evaluation) to process entry schema |
| 15 | Section 6.3 | Added Topology column to master registry table |
| 16 | Section 6.4 | Rewrote learning loop diagram with triage and topology tracking |
| 17 | Section 7 | Updated taxonomy table: added setup-evaluation, create-agent-prompt, setup-evaluator agent row, knowledge-indexer marked TODO |
| 18 | Section 8 | Updated knowledge section to reference deferral |
| 19 | Section 9 | Updated files list: added setup-evaluation, create-agent-prompt; added deferred files section; removed knowledge-indexer from new files |
| 20 | Section 10 | Rewrote routing rules: added setup-evaluation, triage short-circuits, full firing order with feedback |
| 21 | Section 11 | Updated anti-sprawl rules: volume splitting, arch persistence, setup-evaluator mandatory, execution feedback mandatory |
| 22 | Section 12 | Updated open questions: 4 resolved with section refs, 2 new added (iteration limit, cross-volume matching) |

---

## 5. New Open Questions (from this session)

- **setup-evaluator iteration limit** — How many times can it reject and loop back to agent-architect before escalating to user?
- **Cross-volume similarity matching** — As process.md splits, should triage use tag-based pre-filtering or always read all volumes?

---

## 6. What's Next (not started)

Implementation of the spec. Likely order:
1. `process-decomposer` (core skill with triage)
2. `agent-architect`
3. `setup-evaluation` + `setup-evaluator` agent
4. `project-orchestrator` modifications (structure removal + execution feedback)
5. `skill-finder`
6. `tool-finder`
7. `create-agent-prompt`
8. `process.md` registry template
9. Routing, AGENTS.md, SKILL-INDEX.md, README updates

---

## 7. Implementation Plan

Full implementation plan saved to: `docs/superpowers/plans/2026-04-10-agent-process-expansion.md`

**13 tasks across 4 phases + verification:**
- Phase 1 (parallel): skill-finder, tool-finder, create-agent-prompt
- Phase 2 (depends on P1): process-decomposer, agent-architect, setup-evaluation
- Phase 3 (depends on P2): project-orchestrator modifications, process.md template
- Phase 4 (depends on all): ROUTING.md, AGENTS.md, SKILL-INDEX.md, README.md
- Verification: full pass across all files

Each task includes the complete SKILL.md content — no placeholders.

---

## 8. How to Resume

Point the next session agent to:
```
Read docs/drafts/2026-04-10-design-review-session.md for full context of the design review.
The updated spec is at docs/specs/2026-04-10-agent-process-expansion-design.md.
The implementation plan is at docs/superpowers/plans/2026-04-10-agent-process-expansion.md.
```
