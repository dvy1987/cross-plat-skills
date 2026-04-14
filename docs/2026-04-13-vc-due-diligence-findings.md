# VC & Technologist Due Diligence — agent-loom Claim Assessment

*Prepared: 2026-04-13 · Independent assessment against repo implementation, commit history, and documentation*

---

## Executive Summary

agent-loom is a cross-platform agent skill library with 48 skills, a self-improving meta layer, process decomposition, agent architecture design, and security scanning. It follows the agentskills.io open standard and works across ~10 AI coding platforms. The claim under review is that it "can complete any process — coding or business problem" by understanding tasks, asking relevant questions, building agent infrastructure, learning from past chats, and learning from best practices.

**Verdict:** The headline claim is materially overstated today. agent-loom is a thoughtful, unusually well-structured cross-platform skill/control-plane library, but it is NOT yet a proven system that can complete any coding or business process, nor does it truly "learn from past chats" in a durable way. It looks more like high-quality promptware/control-plane infrastructure than a reliable agent runtime.

**Fair reframing:** "A portable, self-improving skill library that helps agents reason about, structure, and execute common software/product workflows across tools."

---

## Section 1: Claim-by-Claim Truth Assessment

### The Headline Claim

> "agent-loom can complete any process — coding or business problem — using this project. The project will understand, ask relevant questions, build the required agent infrastructure, learn from past chats, and learn from best practices."

### Sub-Claim Scoring

| Sub-Claim | Verdict | Score (1–10) | Evidence |
|-----------|---------|:---:|----------|
| "Can complete any process" | **False** | 1/10 | No production proof exists. No end-to-end agent-chain has been run. The process registry (`docs/processes/process.md`) is empty. Explicit limitations in README: no dynamic branching, no conditional spawning, no replanning on failure, no context chunking. |
| "Coding or business problem" | **False** | 1/10 | Coding-adjacent planning workflows exist (PRD, brainstorm, implementation plan). Business process execution does not: no database/API connectors, no persistent memory, no enterprise system integration, domain skills category is explicitly empty. |
| "Using its skill library" | **Partially true** | 6/10 | The library is real, broad (48 skills), and thoughtfully organized into meta/thinking/project-specific/domain categories. But many skills are instruction/methodology frameworks, not executable capabilities. They produce plans and documents, not completed outcomes. |
| "Understanding the task" | **Partially true** | 6/10 | Skills like process-decomposer (Step 0 conversational understanding), brainstorming (structured questioning), and project-orchestrator (project state reading) encode strong clarification behavior. But this is prompt behavior relying on LLM compliance, not a robust task understanding system. |
| "Asking relevant questions" | **Mostly true** | 7/10 | One of the stronger parts. Several skills enforce gated questioning: brainstorming (one question at a time), prd-writing (minimum 2 questions even with a detailed brief), process-decomposer (1–2 focused questions, wait for confirmation). This is well-designed prompt discipline. |
| "Building required agent infrastructure" | **Partially true** | 3/10 | Can design process docs, architecture specs, agent role prompts, and launch manifests. But actual execution infrastructure is thin: agent-creator only works on 2 platforms (Claude Code, Ampcode), generates spawn INSTRUCTIONS not actual orchestration, and has never been proven in production. |
| "Learning from past chats" | **False** | 1/10 | The process registry is empty. There is no persistent chat memory, no ingestion pipeline from prior conversations, no retrieval layer, no embedding store, no database. The "learning loop" (execution feedback written to process entries) has never been exercised. |
| "Learning from best practices" | **Partially true** | 4/10 | research-skill searches papers/blogs/GitHub repos. improve-skills runs prune→research→rewrite cycles. learn-from-paper extracts insights from academic papers. But "learning" here means prompt-guided rewriting at agent invocation time, not measured, durable capability improvement. No evals prove the improvements actually make skills better. |

### Adjacent Claims That Matter

| Claim | Verdict | Score | Evidence |
|-------|---------|:---:|----------|
| Cross-platform skill library | **Mostly true** | 7/10 | Distribution/install story is genuinely strong. Symlinks to `~/.agents/skills/` work. But execution parity does not exist — agent-creator only works on 2 of 10 platforms. "Installed everywhere" ≠ "works equally everywhere." Replit and Bolt.new are project-level only. |
| Self-improving meta layer | **Partially true** | 4/10 | Well designed on paper. validate→prune→research→rewrite→split/compress flow is coherent. But no eval harness proves improvements don't degrade quality. v1.1.1 changelog even notes "agentskills validate could not be run because CLI is not installed." |
| Evidence-grounded improvements | **Partially true** | 5/10 | Cited/pruned/research-backed workflow is a solid pattern. Prune-skill has citation standards and obsolete-techniques list. But no hard assurance that evidence quality is vetted or resulting changes are actually better. |
| Reusable process memory layer | **Mostly false** | 2/10 | Architecturally intended with `process.md` registry, outcome clusters, replay logic. But the registry has zero entries. Never been tested in real use. The entire feedback loop is theoretical. |
| Security layer | **Conceptually strong, practically soft** | 5/10 | The 5-level instruction hierarchy, 4 secure-* skills, content sanitization, repo ingestion checks — all conceptually mature. But enforcement depends entirely on the LLM following instructions. No sandboxing, no policy engine, no secret broker, no capability isolation. It's governance, not enforcement. |

---

## Section 2: What's Genuinely Impressive

Before diving into gaps, it's important to acknowledge what this project does exceptionally well — things most competitors don't even attempt.

### 1. Excellent Distribution Model

The "install once, available everywhere" story via symlinks to `~/.agents/skills/` is practical, elegant, and genuinely cross-platform. `git pull` + `install.sh --update` refreshes the entire library. This is better than how most agent frameworks distribute capabilities.

### 2. Superior Information Architecture

The taxonomy — meta, thinking, project-specific, domain, agent/process design — is coherent and well-reasoned. The call graph (`docs/skill-graph.md`), routing rules (`ROUTING.md`), and skill index create a control plane that most prompt libraries lack entirely.

### 3. Human-Readable, Version-Controlled Agent Workflows

Markdown artifacts are a feature, not just a limitation. Teams can `git diff` their agent reasoning. Process entries, architecture specs, and design docs are inspectable, reviewable, and auditable in standard tooling.

### 4. Meta-Maintenance as First-Class Concern

The prune→research→rewrite→split→compress flow is more mature than most OSS prompt libraries. The fact that the library has a principled ordering (prune before research, research before rewrite, split before compress) shows genuine systems thinking.

### 5. Honest Scoping of When Agents Are Needed

The README's "When Agents Are Actually Needed" section and explicit "Current Limitations" section show product maturity. The author understands that not everything should be agentified — a rare quality in the AI tooling space.

### 6. Security Architecture Ambition

The 5-level instruction hierarchy, mandatory security scanning before any external content enters, and the separation of concerns across 4 security skills is more thoughtful than virtually any other OSS skill library.

### 7. Thinking Skill Portfolio

11 structured thinking frameworks (inversion, pre-mortem, first-principles, OODA, Fermi, etc.) with deep-thinking as orchestrator — this is genuinely useful for product and engineering decisions and represents curated methodology, not just boilerplate prompts.

### Where's the Moat?

Today the moat is NOT deep technical execution. The moat is:

- Portable cross-platform distribution
- Curated workflow/methodology corpus
- Open-standard alignment (agentskills.io)
- Community trust in a well-maintained skill library
- Self-maintenance discipline

That's a real OSS wedge. It's just not yet a hard systems moat.

---

## Section 3: Architectural Gaps — The Hard Truth

### Gap 1: Persistent State and Memory

**What's missing:**
- Durable run state (runs are fire-and-forget)
- Cross-session memory (each conversation starts from zero)
- Prior chat ingestion pipeline
- Search/retrieval over historical runs
- Structured outcome history

**Why it's fatal to the claim:** "Learning from past chats" is impossible without durable storage + retrieval + write-back. The process registry was designed for this but has zero entries. There's no database, no embedding store, no retrieval layer.

**Evidence:** `docs/processes/process.md` is empty template boilerplate. No `docs/handoffs/` directory exists. No `docs/agents/runs/` directory exists.

### Gap 2: Real Execution vs. Instruction Generation

**What's missing:**
- Most of the system generates plans, manifests, prompts, and markdown artifacts
- agent-creator emits spawn INSTRUCTIONS; it is not a real orchestration engine
- Execution is delegated to host platforms and model obedience
- No actual Task tool invocations in the skills — just templates for how they would look

**Why it's fatal to the claim:** There is a massive gap between "designed an agent topology" and "reliably completed work." The compliance audit example in the README is aspirational — it describes what WOULD happen, not what HAS happened.

### Gap 3: Error Recovery and Replanning

**What the README explicitly admits is missing:**
- Dynamic branching (agent can't signal back to change the plan mid-run)
- Conditional spawning (no "if Agent A finds X, spawn Agent B")
- Replanning on failure (agent-creator retries once then halts)
- Chunking large contexts

**Why it matters:** Real-world workflows fail constantly. Without adaptive recovery, multi-step automation is brittle. The retry-once-then-halt strategy is not production-grade.

### Gap 4: Human-in-the-Loop Controls

**What exists:** Some approval gating (brainstorming hard gate, orchestrator "show plan before executing")

**What's missing:**
- Pause/resume capabilities
- Structured approvals at risky steps
- Override policies
- Partial completion handling
- Audit trail beyond markdown files
- Rollback mechanisms

### Gap 5: Verification and Testing

**What's missing:**
- Benchmark tasks / golden task suite
- Skill-level regression tests
- End-to-end eval harness
- Outcome validation beyond "file exists at expected path"
- Measurable task success rates
- Self-improvement quality gates backed by evals

**Why it matters:** Self-improvement without evals is a recipe for silent degradation. The v1.1.1 changelog notes that `agentskills validate` couldn't even be run because the CLI wasn't installed.

### Gap 6: Domain and System Integration

**What's missing:**
- Real connectors to external systems (CRM, ticketing, databases, APIs)
- Authentication/authorization handling
- Standardized tool invocation patterns
- Enterprise system access patterns
- Data pipeline integration

**Why it matters:** The claim includes "business problems." Business process completion requires touching CRMs, ticketing systems, document management, APIs, data stores, etc. None of this exists.

### Gap 7: Scalability and Concurrency

**File-based markdown is elegant but weak for:**
- Concurrent runs (no locking)
- Conflict handling
- Search at scale
- Analytics and reporting
- Team/shared memory
- Resumability across sessions

### Gap 8: Platform Capability Inconsistency

**The trust problem:**
- agent-creator works on 2 of 10 platforms
- project-orchestrator has 3 tiers with very different capabilities
- README says "works with" 10+ platforms but execution depth varies dramatically
- "Installed everywhere" is marketing; "works equally everywhere" is false

### Gap 9: Security Is Governance, Not Enforcement

**Conceptually strong, practically soft:**
- Security depends entirely on the LLM following prompt instructions
- No actual sandbox, container, or process isolation
- No policy engine with deny-by-default
- No secret broker / capability isolation
- No runtime enforcement — a sufficiently persuasive prompt injection could bypass all checks
- The threat model references real papers (Snyk ToxicSkills, PoisonedSkills) but the defense is purely advisory

---

## Section 4: Fundamental Limitations That More Skills Cannot Solve

These are hard ceilings inherent to the architecture:

1. **No runtime = no reliability.** You cannot get durable orchestration, retries, exactly-once semantics, resumability, or observability by adding more markdown skills. This requires an actual execution engine.

2. **No durable memory = no learning.** Process files are not a memory system. Without storage, retrieval, and write-back, "learning" is just re-reading file contents that happen to be in the conversation context.

3. **Host platform dependence is structural.** The project inherits the limits of Claude Code/Amp/Cursor/etc. Skill count does not fix uneven task APIs, tool support, or subagent behavior across platforms.

4. **LLM context windows remain a hard bottleneck.** Without chunking, retrieval, and state externalization, large-codebase or long-running workflows break down. A 48-skill library + process registry + architecture spec can easily exceed any model's context window.

5. **Prompt following is not enforcement.** Security, routing, and execution contracts are advisory unless backed by code/runtime controls. A model that doesn't follow the `ROUTING.md` exactly will break the entire system.

6. **General verification is unsolved.** "Did it complete the business process correctly?" is often not machine-checkable without domain-specific tests, humans, or external signals.

7. **"Any process" is not a credible product boundary.** It is too broad to validate, benchmark, or operationalize. No system — including humans — can "complete any process."

---

## Section 5: Competitive Positioning

### vs. LangChain / LangGraph

| Dimension | agent-loom | LangGraph |
|-----------|-----------|-----------|
| Stateful orchestration | ❌ File-based | ✅ Graph state |
| Retry/recovery | ❌ Retry once, halt | ✅ Configurable |
| Memory | ❌ None persistent | ✅ Built-in patterns |
| Portability | ✅ 10 platforms | ❌ Python runtime |
| Human-readable artifacts | ✅ Markdown | ❌ Code |
| Methodology packaging | ✅ Rich | ❌ Minimal |

**Verdict:** Not substitutes. agent-loom is a portable control-plane/prompt layer; LangGraph is a runtime framework.

### vs. CrewAI / AutoGen

| Dimension | agent-loom | CrewAI/AutoGen |
|-----------|-----------|----------------|
| Multi-agent runtime | ❌ Instruction generation | ✅ Real execution |
| Message passing | ❌ File-based | ✅ Native |
| Skill modularity | ✅ Strong | ⚠️ Varies |
| Cross-platform | ✅ Universal | ❌ Python runtime |

**Verdict:** They automate more; agent-loom governs better.

### vs. OpenAI Assistants

| Dimension | agent-loom | OpenAI Assistants |
|-----------|-----------|-------------------|
| Hosted state/threads | ❌ | ✅ |
| Tool integrations | ❌ | ✅ |
| Vendor neutrality | ✅ | ❌ |
| Inspectability | ✅ | ❌ |

**Verdict:** agent-loom is more open; OpenAI is more operationally real.

### vs. Temporal / Prefect (Workflow Engines)

| Dimension | agent-loom | Temporal/Prefect |
|-----------|-----------|-----------------|
| Durability | ❌ | ✅ Enterprise-grade |
| Retry semantics | ❌ | ✅ Exactly-once |
| Observability | ❌ | ✅ Native |
| Portable skills | ✅ | ❌ |

**Verdict:** Not comparable. At best, agent-loom could become an authoring/control layer that OUTPUTS workflows for these systems.

### Best Positioning

> "A portable, open-standard skill and workflow-intelligence layer for AI coding tools"

NOT:

> "A general-purpose autonomous workflow engine"

---

## Section 6: Creative Solutions for Each Gap

### Memory & "Learn from Past Chats"

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **Lightweight** | Structured markdown run ledger with YAML frontmatter per run + grep-based retrieval | Minimal infra, stays repo-native, version-controlled | Weak retrieval, concurrency pain, doesn't scale past ~100 runs |
| **Medium** | Local SQLite + FTS5 full-text search + optional vector embeddings via sqlite-vss | Real persistence, local-first, searchable, resumable, no cloud dependency | Implementation complexity, migration from markdown, needs schema design |
| **Heavyweight** | Hosted memory API / team knowledge service (e.g., Supabase + pgvector, or purpose-built) | Cross-device/team learning, analytics, stronger retrieval, shared memory | Infra burden, privacy concerns, ops cost, moves away from portable simplicity |

### Real Execution Layer

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **Lightweight** | Narrow claims to "plan/generate/coordinate" — be honest about what it does | Instantly truthful, no engineering needed | Smaller ambition story |
| **Medium** | Platform adapter layer with unified execution manifest + capability probing | Consistent execution contract, testable, graceful degradation | Adapter maintenance per platform, still limited by host capabilities |
| **Heavyweight** | First-party local daemon/runtime with checkpoint state, retry engine, tool executor | True control, observability, resumability, platform independence | Basically a new product, massive scope, competes with Temporal/CrewAI |

### Error Recovery & Branching

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **Lightweight** | Manual checkpoints + resume files (YAML state snapshots at each step) | Easy, safe, human-controlled | Manual burden, slow |
| **Medium** | Run state machine with conditional transitions defined in process spec | Real robustness, auto-recovery for known failure modes | Significant complexity, state machine design per workflow |
| **Heavyweight** | Temporal/Prefect backend for durable execution with saga patterns | Mature durability, retries, observability | Very heavyweight, off-mission for a skill library |

### Verification & Quality Gates

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **Lightweight** | Golden task suite — 10 canonical tasks with expected artifact outputs, diffed on every improve cycle | Immediate signal, fast, catches regressions | Shallow — only checks artifact shape, not quality |
| **Medium** | Eval harness with rubric-graded LLM scoring + regression tracking over time | Much stronger proof, quantifiable quality trajectory | LLM-as-judge has known biases, needs calibration |
| **Heavyweight** | Domain-specific sandboxed integration tests (actually run the workflow, check real outcomes) | Strongest evidence, real-world validation | Expensive, slow, complex infra |

### Platform Consistency

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **Lightweight** | Publish verified capability matrix (not aspirational) — honest tier system in README | Restores trust, sets correct expectations | Worse marketing optics |
| **Medium** | Runtime capability probing + graceful degradation with user notification | Better UX, automatic adaptation, honest | Some engineering effort |
| **Heavyweight** | Native extensions/plugins per platform for full-fidelity execution | Best UX, full capability | Very costly to maintain across 10 platforms |

### Security Enforcement

| Approach | Description | Pros | Cons |
|----------|-------------|------|------|
| **Lightweight** | Signed skill manifests + CI validation pipeline | Better integrity, detects tampering | Still soft at runtime |
| **Medium** | Tool allowlists + sandboxed execution wrapper for external content | Meaningful safety boundary | Platform limitations on sandboxing |
| **Heavyweight** | Policy engine (OPA/Cedar) + secret broker + capability isolation | Enterprise-grade governance | High complexity, over-engineered for current scale |

---

## Section 7: Risks and Guardrails

| Risk | Mitigation |
|------|-----------|
| **Promptware overclaiming** — marketing exceeds capability | Separate "designed in markdown" from "executed reliably" in all docs |
| **Self-improvement degrades quality** — prune/rewrite cycle introduces bugs | No meta rewrite without eval pass; golden task suite gates every change |
| **Platform inconsistency damages trust** — users expect uniform behavior | Publish verified capability matrix; test each platform; graceful degradation |
| **Security claims exceed enforcement** — "mandatory" security is advisory | Label secure-* as advisory governance until backed by technical controls |
| **File-based state collapses under concurrency** — race conditions, lost updates | Move to local DB-backed run ledger before team use |
| **Scope creep into runtime territory** — trying to be Temporal when you're a skill library | Maintain clear architectural boundary: skill layer ↔ execution layer |
| **No proof of value** — lots of architecture, zero production runs | Prove one wedge workflow end-to-end with measurable success before broadening |

---

## Section 8: Final Verdict

### The Brutally Honest Version

Today, agent-loom is an impressive OSS cross-platform skill library with sophisticated prompt architecture and strong product thinking, but the central claim is false as stated. It does NOT currently demonstrate general process completion, real learning from past chats, or durable agent infrastructure. The gap between "well-designed markdown instructions" and "reliably completed any process" is enormous.

### The Constructive Version

There is a credible and differentiated product wedge here — portable agent methodology + skill distribution + process-aware control plane — and if the team narrows the claim and ships durable state/evals around one proven wedge workflow, it could become genuinely important in the agent tooling ecosystem.

### Composite Score: 2/10 for the headline claim as stated

- As a portable skill library: **7/10** (real, differentiated)
- As a process design/control plane: **4/10** (promising, unproven)
- As a general autonomous process-completion engine: **1/10** (not substantiated)

### What an Investor Would Say

> "I like the product taste, the distribution story, and the self-maintenance discipline. But the claim is aspirational, not operational. Come back with: (1) one proven end-to-end workflow with measurable outcomes, (2) durable state/memory that demonstrates real learning, and (3) an eval harness that proves self-improvement works. Then we'll talk."

---

*This document was prepared as an independent due diligence assessment. All claims are evaluated against the repo's actual implementation, commit history, and documentation as of 2026-04-13.*
