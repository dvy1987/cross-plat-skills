# agent-loom — Roadmap & Implementation Plan

## Overview

This roadmap addresses the gaps identified in the VC due diligence assessment (see `docs/2026-04-13-vc-due-diligence-findings.md`). It prioritizes building proof before building infrastructure, and infrastructure before scale.

**Guiding principle:** Narrow the claim, prove it, then expand.

**Current state:** Impressive skill library and control plane. No proven end-to-end execution. No persistent memory. No evals. The gap between "designed" and "completed" is the primary risk.

---

## Phase 0: Honest Reframing (Week 1)
**Objective:** Align public claims with actual capability. Build trust.

### 0.1 — Update README Claims
- **Action:** Replace "can complete any process" with honest positioning
- **New framing:** "A portable, self-improving skill library that helps AI agents reason about, structure, and execute common software and product workflows across tools."
- **Files affected:** README.md, docs/prd/PRD.md
- **Effort:** 1 day

### 0.2 — Publish Verified Platform Capability Matrix
- **Action:** Create `docs/platform-capability-matrix.md` showing what actually works per platform
- **Columns:** Platform | Skills load | Routing works | Subagent spawn | Full pipeline tested
- **Test each platform combination with at least one skill invocation**
- **Add "tested on" badges to README**
- **Effort:** 2-3 days

### 0.3 — Relabel Security as Governance
- **Action:** In all docs referring to secure-* skills, add a note: "Advisory governance layer — depends on model compliance. Not a hard security boundary."
- **Files affected:** AGENTS.md, SKILL-INDEX.md, relevant SKILL.md files
- **Effort:** 1 day

### Milestone: Honest, credible project positioning. No claims that can't be demonstrated.

---

## Phase 1: Prove One Wedge (Weeks 2-4)
**Objective:** Demonstrate one complete workflow end-to-end with measurable outcomes. Convert narrative into evidence.

### 1.1 — Choose the Wedge Workflow
- **Recommended:** "Feature idea → Product Soul → Brainstorm → PRD → Implementation Plan" (the full product planning pipeline)
- **Why this one:**
  - Uses 4-5 existing skills in sequence
  - Produces tangible, reviewable artifacts
  - Doesn't require platform-specific features (no Task tool needed)
  - Can be tested on any platform
  - Most likely to succeed given current skill maturity

### 1.2 — Define Success Criteria
- **Quantitative:**
  - All 5 artifacts produced (product-soul.md, design spec, PRD, implementation plan, skill-outputs log)
  - Each artifact passes a structural validation check (required sections present)
  - End-to-end time < 45 minutes with human-in-the-loop
  - Works identically on at least 3 platforms
- **Qualitative:**
  - A developer unfamiliar with the project can follow the plan to start implementation
  - Artifacts reference each other correctly (PRD cites design spec, plan cites PRD)

### 1.3 — Build the Golden Task
- **Create:** `tests/golden-tasks/feature-planning-pipeline/`
- **Contents:**
  - `input.md` — a realistic feature request (e.g., "Add dark mode to a React app with Tailwind")
  - `expected-artifacts.md` — list of files that should be produced with required sections
  - `validation-script.sh` — checks artifact presence, required headings, cross-references
  - `run-log-template.md` — template for recording run results
- **Effort:** 3 days

### 1.4 — Execute and Document
- **Run the pipeline 3 times** on at least 2 platforms
- **Record:** inputs, outputs, timing, failures, human interventions
- **Document:** `docs/proof/2026-04-feature-planning-pipeline-proof.md`
- **Include:** actual artifacts produced, screenshots/logs, success rate
- **Effort:** 5 days

### 1.5 — Fix Issues Found During Proof Runs
- **Budget:** 3-5 days for skill fixes, routing adjustments, handoff improvements
- **Document all fixes** in changelog

### Milestone: One demonstrated end-to-end workflow with evidence. Can show to investors/users.

---

## Phase 2: Durable State & Memory (Weeks 5-8)
**Objective:** Make "learning from past executions" real. Transform the empty process registry into a functional memory system.

### 2.1 — Design the Run Ledger Schema
- **Approach:** Local SQLite database (lightest durable option)
- **Schema:**
  ```
  runs:
    - run_id (UUID)
    - workflow_name
    - started_at / completed_at
    - status (running | completed | failed | paused)
    - input_summary (text)
    - output_paths (JSON array)
    - skills_invoked (JSON array)
    - platform
    - user_approvals (JSON array of {step, decision, timestamp})
    - failure_reason (nullable text)
    - process_entry_ref (nullable, links to docs/processes/)

  memory:
    - memory_id (UUID)
    - run_id (FK)
    - type (insight | decision | failure | learning)
    - content (text)
    - created_at
    - tags (JSON array)
  ```
- **Effort:** 2 days design, 3 days implementation

### 2.2 — Build Memory Skill
- **Create:** `.agents/skills/memory/SKILL.md`
- **Capabilities:**
  - `store` — save a run record, insight, or learning
  - `recall` — search past runs by keyword, workflow, date, outcome
  - `replay` — retrieve a past run's plan + artifacts for adaptation
- **Storage:** SQLite via MCP server or direct file-based CLI wrapper
- **Effort:** 5 days

### 2.3 — Wire Process Registry to Run Ledger
- **Action:** When process-decomposer writes a process entry, also create a run record
- **Action:** When project-orchestrator completes execution, update run status + write learnings
- **Action:** When process-decomposer triages, ALSO check run ledger (not just process.md)
- **Effort:** 3 days

### 2.4 — Chat History Ingestion (Lightweight)
- **Action:** Create a "session summarizer" that extracts key decisions, failures, and learnings from a conversation and writes them to the memory table
- **Trigger:** End of each skill-chain or agent-chain execution
- **Not full chat storage** — structured summaries only
- **Effort:** 3 days

### Milestone: process-decomposer can find and reuse past executions. "Learning" becomes real.

---

## Phase 3: Eval Harness & Quality Gates (Weeks 9-11)
**Objective:** Prove that self-improvement actually improves things. Build regression gates.

### 3.1 — Golden Task Suite
- **Expand Phase 1's golden task to 10 canonical tasks:**
  1. Feature planning pipeline (from Phase 1)
  2. Bug report → debug → fix → verify
  3. Brainstorm → design doc approval
  4. PRD from scratch (with discovery interview)
  5. Technical debt audit on a sample repo
  6. Code review with severity findings
  7. Deep thinking → multi-framework analysis
  8. Process decomposition → process entry
  9. Skill creation end-to-end
  10. Improve-skills cycle on a single skill
- **Each task:** input, expected output structure, validation script
- **Effort:** 10 days

### 3.2 — Eval Runner
- **Create:** `tests/eval-runner.sh` (or Python equivalent)
- **Flow:**
  1. For each golden task: invoke the skill/pipeline
  2. Check outputs against expected structure
  3. Score on rubric (artifact completeness, required sections, cross-references)
  4. Report pass/fail with score
- **Store results in run ledger** for tracking over time
- **Effort:** 5 days

### 3.3 — Gate improve-skills on Eval Pass
- **Action:** Before improve-skills commits any change, run the relevant golden task
- **Action:** If eval score drops, block the commit and flag for human review
- **This makes self-improvement safe**
- **Effort:** 3 days

### Milestone: Measurable skill quality. Self-improvement has guardrails. Regression is detectable.

---

## Phase 4: Execution Reliability (Weeks 12-16)
**Objective:** Make multi-step workflows robust enough for real use.

### 4.1 — Checkpoint/Resume System
- **Design:** YAML state files per step in a run
  ```yaml
  run_id: abc-123
  step: 3
  status: completed
  output_path: docs/specs/design.md
  next_step: 4
  resume_from_here: true
  ```
- **Behavior:** If a run fails at step N, user can say "resume" and it picks up from step N
- **Effort:** 5 days

### 4.2 — Platform Adapter Layer
- **Create:** `references/platform-adapters/` with per-platform capability profiles
- **Each adapter defines:**
  - Available tools
  - Subagent support (yes/no + method)
  - Context window limits
  - Known failure modes
- **project-orchestrator reads adapter before execution planning**
- **Effort:** 5 days

### 4.3 — Conditional Step Execution
- **Enhancement to process-decomposer:**
  - Allow steps to have `condition: "if step_N.output contains 'critical'"`
  - project-orchestrator evaluates conditions before executing each step
  - Enables basic dynamic branching without full replanning
- **Effort:** 5 days

### 4.4 — Failure Recovery Patterns
- **Create:** `.agents/skills/failure-recovery/SKILL.md`
- **Patterns:**
  - Retry with backoff (for transient failures)
  - Skip and continue (for non-blocking steps)
  - Substitute (try alternative skill/approach)
  - Escalate to human (pause and notify)
- **Wire into project-orchestrator**
- **Effort:** 5 days

### Milestone: Workflows can survive failures, resume from checkpoints, and adapt to platform capabilities.

---

## Phase 5: Extended Capabilities (Weeks 17-24)
**Objective:** Expand what agent-loom can actually do — from planning-only to planning + execution.

### 5.1 — First Domain Skills (Pick 3)
- **Candidates:**
  1. `api-design` — Design REST/GraphQL APIs with schema generation
  2. `migration-planning` — Database/system migration plans with rollback strategies
  3. `sprint-retro` — Structured sprint retrospective with action items
- **Each follows universal-skill-creator pipeline**
- **Effort:** 5 days each (15 days total)

### 5.2 — External Tool Integration Framework
- **Create:** `references/tool-integration-spec.md`
- **Define standard patterns for:**
  - MCP server connections (Linear, GitHub, Jira)
  - API authentication handling (OAuth, API keys via env vars)
  - Data connector patterns (read-only first, write with approval)
- **Implement 2 reference integrations:**
  - GitHub (issues, PRs, code search)
  - Linear (issues, projects, status updates)
- **Effort:** 10 days

### 5.3 — Context Management for Large Codebases
- **Create:** `.agents/skills/context-manager/SKILL.md`
- **Capabilities:**
  - Intelligent file selection (read only what's needed)
  - Summary caching (store file/module summaries for reuse)
  - Chunked analysis (break large analyses into sequential chunks)
- **Effort:** 5 days

### Milestone: agent-loom can handle real-world coding and product workflows, not just planning artifacts.

---

## Phase 6: Team & Scale (Weeks 25-32)
**Objective:** Make agent-loom useful for teams, not just solo developers.

### 6.1 — Shared Memory Layer
- **Migrate from local SQLite to shared storage (optional)**
- **Options:**
  - Git-committed markdown ledger (simplest team option)
  - Supabase/Turso for hosted SQLite
  - Self-hosted Postgres for enterprise
- **Key: make it opt-in, local-first remains default**
- **Effort:** 10 days

### 6.2 — Team Skill Governance
- **Skill review workflow:** PR-based skill changes with validate-skills as CI check
- **Skill versioning:** Individual skill versions (not just repo version)
- **Skill permissions:** Define which skills can be invoked in which projects
- **Effort:** 10 days

### 6.3 — Analytics & Observability
- **Dashboard:** Run success rates, skill usage frequency, failure hotspots
- **Alerts:** Skills that degrade over time (based on eval scores)
- **Reports:** Team productivity metrics tied to skill usage
- **Effort:** 10 days

### Milestone: agent-loom works for teams with shared process knowledge and governance.

---

## Prioritization Summary

| Phase | Weeks | Focus | Key Deliverable |
|-------|-------|-------|----------------|
| **0** | 1 | Honest reframing | Credible positioning |
| **1** | 2-4 | Prove one wedge | Demonstrated end-to-end workflow with evidence |
| **2** | 5-8 | Durable memory | Process registry with real run data |
| **3** | 9-11 | Eval harness | Measurable quality + regression gates |
| **4** | 12-16 | Execution reliability | Checkpoint/resume, failure recovery, conditional steps |
| **5** | 17-24 | Extended capabilities | Domain skills, external tools, context management |
| **6** | 25-32 | Team & scale | Shared memory, governance, observability |

## Decision Framework: What to Build vs. What to Claim

```
Proven in production → Claim it boldly
Designed but unproven → "Supports" or "Enables"
Aspirational          → "Roadmap" or "Coming soon"
Not started           → Don't mention
```

Apply this to every feature and capability in README, PRD, and public-facing docs.

## Success Metrics by Phase

| Phase | Metric | Target |
|-------|--------|--------|
| 0 | Claims match capability | 100% |
| 1 | Golden task success rate | ≥80% across 3 runs |
| 1 | Platform parity | Works on ≥3 platforms |
| 2 | Run records in ledger | ≥20 real runs |
| 2 | Process reuse rate | ≥1 reused process |
| 3 | Golden tasks passing | ≥8/10 |
| 3 | improve-skills doesn't regress | 0 regressions per cycle |
| 4 | Failure recovery success | ≥70% auto-recovery |
| 5 | Domain skills scoring | ≥10/14 each |
| 6 | Team shared runs | ≥5 team members using shared memory |

## Appendix: Approach Comparison Matrix

For the most critical decisions in this roadmap, here are the pros and cons of different approaches:

### Memory Storage: Markdown vs SQLite vs Hosted DB

| Factor | Markdown Files | Local SQLite | Hosted DB |
|--------|---------------|-------------|-----------|
| Setup complexity | None | Low | High |
| Search speed | Slow (grep) | Fast (FTS5) | Fast |
| Concurrency | Poor | Good | Excellent |
| Version control | ✅ Git-native | ⚠️ Binary file | ❌ External |
| Team sharing | Via git | Via file sync | Native |
| Schema evolution | Manual | Migrations | Migrations |
| Privacy | ✅ Local | ✅ Local | ⚠️ Depends |
| **Recommendation** | **Phase 0-1** | **Phase 2-5** | **Phase 6+** |

### Execution: Instruction Generation vs Platform Adapter vs Own Runtime

| Factor | Instructions Only | Platform Adapter | Own Runtime |
|--------|-------------------|-----------------|-------------|
| Implementation | Done ✅ | Medium | Very High |
| Reliability | Low | Medium | High |
| Portability | ✅ Universal | ✅ Adapt per platform | ❌ Own platform |
| Observability | None | Some | Full |
| Recovery | Manual | Basic retry | Checkpoint/resume |
| **Recommendation** | **Phase 0-1** | **Phase 2-4** | **Phase 6+ (maybe)** |

### Verification: Artifact Checks vs LLM-as-Judge vs Sandboxed Tests

| Factor | Artifact Checks | LLM-as-Judge | Sandboxed Tests |
|--------|----------------|-------------|-----------------|
| Speed | Fast | Medium | Slow |
| Depth | Shallow | Medium | Deep |
| Cost | Free | Model inference | Infra |
| Reliability | High (deterministic) | Medium (bias) | High |
| Feedback quality | Binary | Rich | Rich |
| **Recommendation** | **Phase 1-2** | **Phase 3-4** | **Phase 5+** |

---

*This roadmap was created alongside the VC due diligence assessment. It prioritizes building evidence before infrastructure, and infrastructure before scale. Each phase builds on the previous one — do not skip phases.*
