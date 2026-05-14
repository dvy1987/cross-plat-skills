# Project Learnings

Durable lessons captured from sessions. Each entry follows the `memory-capture` template.

---

## 2026-05-11 - Skill trigger policies are documentation, not enforcement
Type: learning
Status: active
Scope: project
Confidence: high
Source: 2026-05-11 session — gap discovered by human reviewer after agent wrote a changelog without invoking memory-capture
Tags: memory, architecture, skill-design, auto-trigger

### Content
Writing a "Trigger Policy" section in a SKILL.md describes *when the skill should run* — it does not actually cause the skill to run. There are no runtime hooks in this skill system; every invocation is the agent's judgment call based on description matching. So if the agent doesn't think "this is a session-ending moment" or "this is a checkpoint event," it never fires the skill regardless of how clearly the trigger policy is written.

The fix is to push trigger enforcement up one level: a canonical registry in the orchestrator skill (`memory/SKILL.md` Mandatory Auto-Trigger Checkpoints), referenced by name in the producer skill's final step ("Per `memory/SKILL.md` registry, invoke `memory-capture`"). Producer skills then carry the trigger as a workflow step the agent cannot complete without invoking.

### Why It Matters
Any future skill suite that relies on "auto-fire on event X" will have the same gap unless it follows the same 4-layer pattern: (1) canonical registry in orchestrator, (2) producer skills self-trigger via explicit final step, (3) host repo's AGENTS.md mandates the registry, (4) `project-setup` propagates the AGENTS.md section to new projects via SKILL.md + template + Update Mode preserve list + interview question. Skipping any of the 4 layers leaves a gap: registry-only fails because producers don't fire; producer-only fails for new projects; AGENTS.md-only is local; project-setup-only is unenforced in the current repo.

### Revisit When
- A new event-producing skill is added (release-notes, feature-flag-decision, migration-plan, etc.) — it must register a checkpoint.
- `validate-skills` gains a "missing memory checkpoint" structural flag (currently deferred).
- A future skill suite designed around event-driven auto-triggering needs the same 4-layer pattern.

---

## 2026-05-11 - Pre-existing line-count violations can be resolved as side effects of feature work
Type: learning
Status: active
Scope: project
Confidence: medium
Source: 2026-05-11 session — project-setup was 213 lines (pre-existing violation), brought to exactly 200 while adding Memory Checkpoints
Tags: skill-quality, compression, line-limit

### Content
When making targeted additions to a skill that's already over the 200-line cap, find compressible blocks elsewhere in the same skill rather than scoping a separate compress-skill pass. In `project-setup`, the SDD chain block (7 lines), Impact Report (11 lines), Example (7 lines), and Step 6 footer (2 lines) all had compressible verbose phrasing that could be tightened without losing meaning. Pairing 4 additions with 13 lines of trims brought a 213-line file to exactly 200 — resolving a pre-existing violation as a bonus.

### Why It Matters
Avoids the spiral where every edit needs a separate compress-skill invocation, and avoids accumulating "pre-existing violations" as technical debt. The trade-off: only applicable when the file has compressible content nearby. If the file is genuinely lean, escalate to `split-skill` instead.

### Revisit When
- A skill stays over 200 lines after a feature edit despite trim attempts — escalate to `split-skill`.
- Multiple pre-existing violations accumulate — run a focused `improve-skills` pass.

---

## 2026-05-13 - Retroactive bootstrap is a distinct skill, not a project-setup mode
Type: provenance
Status: active
Scope: project
Confidence: high
Source: 2026-05-13 session — universal-skill-creator workflow, atomic tier
Tags: skill-design, project-setup, retroactive, composition

### Content
Created `retroactive-project-setup` (Atomic, 188 lines) to bootstrap full agent infrastructure (AGENTS.md, docs/architecture.md, docs/product-soul.md, ADR-0001, docs/memory/ seed) over an existing already-coded project without modifying source code. It composes `codebase-understanding`, `product-soul` (inference mode), `architectural-decision-log` (synthesis), and `project-setup` (`RETROACTIVE=true` mode passing pre-inferred matrix + ≤6 gap-interview answers). Enforces a strict write-allowlist. Tags low-confidence inferences with `[INFERRED — confirm]`. Refuses on populated AGENTS.md (routes to `project-setup UPDATE_ONLY=true`). Memory bootstrap seeds one synthetic handoff entry marked `synthetic: true`.

### Why It Matters
`project-setup` is interview-first and forward-looking — it assumes the user can describe the project. A 2-year-old codebase already encodes most of those answers in manifests, README, source files, and git history. Forcing a full interview re-derives what the repo already states and creates a friction wall that stops users from adopting agent-loom on existing projects. Separating archaeology-first (`retroactive-project-setup`) from interview-first (`project-setup`) lets each be lean and correct for its scope; the new skill is the on-ramp for legacy repos.

### Revisit When
- `project-setup` gains a fully native `RETROACTIVE=true` mode that subsumes the orchestration (would deprecate the sibling).
- A monorepo with 4+ packages becomes the test case — current multi-file mode only handles frontend/backend split.
- `[INFERRED — confirm]` tag noise becomes a friction point — consider auto-resolving tags via a follow-up confirmation pass.

## 2026-05-13 — Chat-learnings ↔ improve-skills feedback loop wired

- **What:** Closed the loop between `learn-from-chat` (in-session capture) and `improve-skills` (periodic pass) so chat-discovered learnings can't go missing.
- **Mechanism:**
  - `improve-skills` v1.3: new Modes section (FULL_PASS / TARGETED with `TARGET=<skill> [SKIP_RESEARCH=true]`); new Step 1b ingests `docs/learnings/chat-learnings.md` and triages OPEN entries with discretion (IMPLEMENTED pre-existing / REJECTED / DEFERRED / keep OPEN); new Step 2l writes terminal statuses back; Hard Rule "Chat learnings are an input, not a mandate."
  - `learn-from-chat` v1.2: Step 5 escalation gate — append-only edits land here; restructure-class edits (new step, renumbering, new references/, routing triggers, >200-line gate) escalate to `improve-skills TARGET=<skill> SKIP_RESEARCH=true`; Step 6 log gains mandatory Status field.
  - `docs/learnings/chat-learnings.md` template now requires `Status` (OPEN / IMPLEMENTED / ESCALATED / REJECTED / DEFERRED).
- **Why:** Previously these two skills were disconnected — chat learnings were orphaned from the next improvement pass, and `learn-from-chat` could silently restructure skills outside the canonical creator/improver gate.
- **Library sync:** SKILL-INDEX (entries + Call Graph), skill-graph (added lfc node + 2 edges + loop bullet), README rows, SKILL-OUTPUTS (7 rows), changelog `2026-05-13-chat-learnings-loop.md`.
- **Verified:** improve-skills 197, learn-from-chat 180; both ≤200.

## 2026-05-14 — Three deferred items closed via TARGETED improve-skills path

- **What:** Cleared the 3 deferred items from the 2026-05-13 handoff (`reality-check` 255-line violation; ADL synthesis-mode idiom alignment; `validate-skills` producer-checkpoint enforcement).
- **Mechanism:**
  - `reality-check` v1.2: extracted Step 8 deliverable templates (Findings Report + Roadmap markdown) to `references/deliverable-templates.md`; tightened Step 0 and example. 255 → 189 lines.
  - `architectural-decision-log` v1.1: added `Modes` section with `INTERACTIVE` (default) and `SYNTHESIS=true` (retrospective backfill — skips interview, reads rationale off codebase, `Status: Accepted (retrospective)`, mandatory `[INFERRED]` tags on alternatives, "inferred not contemporaneous" Context disclaimer). Updated `retroactive-project-setup` Step 5.3 to invoke `architectural-decision-log SYNTHESIS=true` by name. ADL: 132 → 148 lines.
  - `validate-skills` v1.1: added Step 4c Producer-Skill Checkpoint Audit (reads `memory/SKILL.md` registry; classifies producers by output dir / description / registry trigger; greps for matching memory sub-skill invocation); new structural flag "Missing memory-checkpoint registration"; mirrored row in `references/validation-rubric.md`. Step 6 example trimmed to compensate. 199 → 196 lines.
- **Validation:** Dry-run of new Step 4c against all 6 current producer skills (`generate-changelog`, `architectural-decision-log`, `feature-spec`, `implementation-plan`, `prd-writing`, `universal-skill-creator`) — all 6 pass with explicit `Per memory/SKILL.md → Mandatory Auto-Trigger Checkpoints` invocations. Zero false positives, zero false negatives.
- **Significance:** First real end-to-end test of the `improve-skills TARGET=<skill> SKIP_RESEARCH=true` path shipped 2026-05-13. Used for all three items; worked without escalation back to FULL_PASS in any case.
- **Library sync:** SKILL-INDEX entries + call graph; README rows; skill-graph (caption on `rps` edges + 2 new "Reading the Graph" bullets); SKILL-OUTPUTS (10 rows); changelog `2026-05-14-three-improvements.md`.
- **Files at end:** reality-check 189, ADL 148, retroactive-project-setup 188, validate-skills 196 — all ≤200.
