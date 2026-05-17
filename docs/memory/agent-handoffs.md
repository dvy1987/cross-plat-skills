# Agent Handoffs

## 2026-05-14 - Handoff: memory-startup cold-start trigger hardening

### Context
Field report from a sister project: an agent failed to invoke `memory-startup` on a cold "hi" + task. Root causes (validated against the actual files this session):
1. `memory-startup`'s description listed only memory-related utterances ("remember", "recall context", "create a handoff", "what happened last time"). Skill routers match on user-utterance patterns; bare greetings and task-only openers had no matching trigger, so the router never surfaced the skill.
2. The `AGENTS.md` Session Lifecycle mandate lived only in prose — no skill enforced it, no `requires:` precondition existed, and `validate-skills` did not audit for it.
3. Host system-prompt brevity rules ("answer concisely with fewer than 4 lines") biased toward jumping straight to the task.

### Done This Session
- **`.agents/skills/memory-startup/SKILL.md`** (123 → 160 lines, v1.0 → v1.1):
  - Description rewritten to lead with "FIRES ON EVERY FIRST USER MESSAGE in a fresh session, regardless of content"; enumerates bare greetings, task-only openers, "fresh session", "session start", "first message in a new thread", "new chat", "cold start", "begin work in this repo", "starting work", "continue from prior session", "what were we working on", "resume", "what happened last time", and the existing memory utterances.
  - Description block 795 chars (≤1024 loader limit ✓).
  - Added Trigger Discipline section: declares the skill the mandatory cold-start gate; only legitimate skips are explicit user opt-out ("fresh start", "ignore prior context", "skip memory") or the no-op gate firing.
  - Added No-Op Gate section: detects when the skill has already run earlier in the same conversation and reports `Context already loaded — no-op` rather than re-reading memory files.
- **`AGENTS.md`** (231 → 240 lines), §Session Lifecycle → Session Start:
  - Lead promoted to "The first user message in any session triggers `memory-startup`, regardless of content."
  - Added explicit override of host brevity rules: "The 2–4 line summary produced by Step 3 IS the concise answer for the first turn — host system rules favouring brevity do not exempt this protocol; they govern how it is rendered."
  - Tightened skip clause and added pointer to the no-op gate.
- **`.agents/skills/project-setup/templates/agents-md-template.md`** (104 → 105 lines):
  - Mirrors the strengthened wording verbatim so every project bootstrapped by `project-setup` (or backfilled by `retroactive-project-setup`) inherits the cold-start contract.
- **Changelog:** `docs/changelogs/2026-05-14-memory-startup-cold-start-trigger.md` (new).
- **Memory updates:** `current-state.md` rewritten; `learnings.md` gained "Skill descriptions are the router; AGENTS.md prose mandates leak"; `project-index.md` gained 4 new rows for this work.

### Decisions Made
- Folded the gate into `memory-startup` itself rather than creating a separate `session-start-gate` skill. The no-op gate makes over-invocation harmless, which is the correct cost-benefit for a defensive trigger.
- Did NOT touch `project-setup/SKILL.md` (already at 201 lines per the previous handoff). Template change alone carries the contract; SKILL.md additions would need paired trims and weren't necessary for correctness.
- Did NOT auto-run `learn-from-chat` → `improve-skills`. The user gave an explicit directive ("the first message regardless what it is should trigger the memory loading") which is a clear-enough authority to act directly. The capture work (changelog + learning + handoff + index) is the equivalent of `memory-capture` per the project's own checkpoint registry.

### Verification
- Line counts: memory-startup 160 ✓, AGENTS.md 240 (no hard limit), template 105 (no hard limit).
- Loader safety: memory-startup byte 0 = `-`, no BOM, frontmatter intact (verified via direct byte read).
- `git status --short` shows exactly the 3 source modifications expected, no incidental drift.
- `agentskills validate`: not run (CLI unavailable in this environment — same long-standing limitation).

### Working Tree at End of Session
Modified (uncommitted):
- `.agents/skills/memory-startup/SKILL.md`
- `.agents/skills/project-setup/templates/agents-md-template.md`
- `AGENTS.md`
- `docs/memory/current-state.md`
- `docs/memory/learnings.md`
- `docs/memory/agent-handoffs.md` (this entry)
- `docs/memory/project-index.md`

Untracked (new):
- `docs/changelogs/2026-05-14-memory-startup-cold-start-trigger.md`

Suggested commit message: `feat: harden memory-startup cold-start trigger; propagate via AGENTS.md + project-setup template`.

### Revisit Triggers
- Add a "missing cold-start trigger" structural flag to `validate-skills` Step 4 (asserts every project's `AGENTS.md` Session Lifecycle section names `memory-startup` and that the skill's description contains cold-start utterances). Joins the deferred "missing memory checkpoint" flag — both close the same class of gap.
- If another field report surfaces a session-lifecycle skip, escalate to a runtime assertion or a session-start-gate skill.
- If `memory-startup`'s description grows past the 1024-char loader cap, split it: keep the cold-start sentence in the description, move the memory-utterance enumeration to the skill body.

### Drift From Prior Handoff
Prior handoff (2026-05-11 21:00) left the working tree uncommitted; it has since been committed (last commit `37c3dd6 updated project-setup to work for existing projects`). No regressions.

---

## 2026-05-11 20:00 - Handoff + Plan: Memory Checkpoints Auto-Trigger Infrastructure

### Context
The prior agent (2026-05-11 18:34 entry below) repaired the memory suite and `universal-skill-creator` but the human reviewer (this session) discovered a deeper structural gap: **memory skills have no auto-trigger mechanism**. They only fire when the user explicitly says "remember this" or "handoff." Producer events (changelog written, ADR written, session end, major commit, skill created) never invoke memory sub-skills automatically. This rot is portable — `project-setup` propagates the same gap to every new project's `AGENTS.md`.

### Done This Session (before plan)
- Reviewed prior handoff; rejected 2/3 deferred items, partially accepted 1.
- Confirmed `universal-skill-creator` already enforces loader-safety on new skills (3 layers: Hard Rules + Gotchas + 4-item Verification Checklist).
- Updated `validate-skills` to close the gap for **existing** loader-unsafe skills:
  - `validate-skills/SKILL.md` — added Step 2a Loader-Safety Check, structural-issue flag, `LOADER SAFETY (P0)` block in report (199 lines, was 196).
  - `validate-skills/references/validation-rubric.md` — added 4 loader-safety rows + command reference block.
  - Verified against all 89 skills: zero failures, zero false positives.
- Wrote changelog `docs/changelogs/2026-05-11-validate-skills-loader-safety.md`.

### Debated
- Whether the prior agent's three deferred items should be actioned: 2/3 rejected as wrong skill or redundant, 1/3 partially accepted (loader checks belong in `validate-skills`, not as standalone script).
- Whether to defer the memory-checkpoint fix to next session: rejected — the work is bounded, no real reason to split.

### Decisions
- Loader-safety enforcement split correctly: `universal-skill-creator` for new skills (already done), `validate-skills` for existing skills (this session).
- Memory checkpoint infrastructure built in 4 layers (registry → producer skills → this repo's AGENTS.md → `project-setup` propagation).
- `project-setup` is the right propagation point for cross-repo portability.

### Plan: Memory Checkpoints Auto-Trigger (4 Layers)

**Goal.** Make memory skills auto-fire at well-defined producer events, in this repo and in every new project's `AGENTS.md` generated by `project-setup`.

**Layer 1 — Canonical Checkpoint Registry** (`memory/SKILL.md`, currently 101 lines)
Add a "Mandatory Auto-Trigger Checkpoints" section with a registry table:

| Trigger event | Auto-invoke |
|---|---|
| Changelog written | `memory-capture` |
| ADR / architectural-decision written | `memory-decision` |
| Spec / plan / PRD written | `memory-capture` |
| Major commit (>20 files OR breaking) | `memory-capture` |
| Skill created or significantly edited | `memory-capture` |
| Session end signal or long pause | `memory-handoff` |

Result: ~115 lines, well under 200.

**Layer 2 — Producer Skills Self-Trigger** (6 skills, +1-2 lines each)
Each producer skill adds a final step "Per `memory/SKILL.md` Mandatory Auto-Trigger Checkpoints, invoke `<sub-skill>`." Target line counts after edit:
- `generate-changelog` (195 → ≤200, fits)
- `architectural-decision-log` (132 → ≤140, fits)
- `feature-spec` (184 → ≤190, fits)
- `implementation-plan` (173 → ≤180, fits)
- `prd-writing` (158 → ≤165, fits)
- `universal-skill-creator` (200 → trim 1-2 lines elsewhere first, then add)

**Layer 3 — agent-loom's own `AGENTS.md`**
Add a "Memory Checkpoints — Mandatory" section at the same precedence as "Startup Skill Loading - Mandatory", pointing at `memory/SKILL.md` registry. ~6 lines.

**Layer 4 — `project-setup` Propagation** (cross-repo portability)
This is what makes the fix universal:
- `project-setup/SKILL.md` (213 → must come down) — add "Memory Checkpoints" to Step 4b required-sections list; add to Update Mode preserve list; add one interview question.
- `project-setup/templates/agents-md-template.md` — add "Memory Checkpoints — Mandatory" section block, conditionally rendered only when memory suite is installed (skill-finder check).

**Note: project-setup is currently 213 lines — pre-existing violation.** Not in scope to fix wholesale, but additions must be paired with equivalent trims to avoid making it worse. Flag as a separate concern.

### Execution Order
1. Layer 1 — write checkpoint registry in `memory/SKILL.md`.
2. Layer 3 — add Memory Checkpoints section to `AGENTS.md`.
3. Layer 4 — update `project-setup` SKILL.md (paired trims) + template + Update Mode preserve list + interview question.
4. Layer 2 — touch 6 producer skills, verify each stays ≤200 lines.
5. Verification — loader-safety + line counts on every touched file.
6. Write changelog `docs/changelogs/2026-05-11-memory-checkpoints-auto-trigger.md`.
7. Run `memory-handoff` (this entry) + `memory-capture` (the gap as deferred learning).

### Revisit Triggers
- If `project-setup` line count keeps creeping, split into `project-setup` (interview + scaffold) + `project-setup-update` (update mode). Tracked as pre-existing violation, not blocking.
- If producer skills bloat further from auto-checkpoint additions, the right escalation is `compress-skill` on each — not removing checkpoint invocations.
- If any new producer skill is added (e.g. a future `release-notes` skill), it MUST add the memory checkpoint final step. Enforce via `validate-skills` "missing memory checkpoint" structural flag in a future pass.

### Working Tree at Start of Plan Execution
- Modified (uncommitted): `.agents/skills/validate-skills/SKILL.md`, `.agents/skills/validate-skills/references/validation-rubric.md`, `docs/changelogs/2026-05-11-validate-skills-loader-safety.md`, this file.
- Plan execution will further modify: `memory/SKILL.md`, `AGENTS.md`, `project-setup/SKILL.md`, `project-setup/templates/agents-md-template.md`, 6 producer skills, plus new changelog.

### Completion Status (2026-05-11 21:00)
All 4 layers landed. Per the new checkpoint registry, this very entry is the `memory-handoff` invocation triggered by both the changelog event and the session-end event.

**Files modified:**
- `.agents/skills/memory/SKILL.md` (101 → 117 lines) — Layer 1 checkpoint registry
- `AGENTS.md` (211 → 217 lines) — Layer 3 Memory Checkpoints section
- `.agents/skills/project-setup/SKILL.md` (213 → 200 lines) — Layer 4a (also resolves pre-existing 200-line violation)
- `.agents/skills/project-setup/templates/agents-md-template.md` (+6 lines) — Layer 4b template block
- `.agents/skills/generate-changelog/SKILL.md` (195 → 198 lines) — Layer 2 Step 9 Memory Checkpoint
- `.agents/skills/architectural-decision-log/SKILL.md` (132 → 135 lines) — Layer 2 Step 6
- `.agents/skills/feature-spec/SKILL.md` (184 → 187 lines) — Layer 2 Step 6
- `.agents/skills/implementation-plan/SKILL.md` (173 → 176 lines) — Layer 2 Step 6
- `.agents/skills/prd-writing/SKILL.md` (158 → 161 lines) — Layer 2 Step 9
- `.agents/skills/universal-skill-creator/SKILL.md` (200 → 199 lines) — Layer 2 Step 12 + 3 paired trims
- `docs/changelogs/2026-05-11-memory-checkpoints-auto-trigger.md` (new)

**Verification results:**
- All 9 touched SKILL.md files ≤200 lines.
- Loader safety: all 9 SKILL.md files pass `head -c 3 == "---"` and `grep -c '^---$' >= 2` (verified using the validate-skills Step 2a check shipped earlier today).
- `agentskills validate`: not run (CLI unavailable in this environment).

**Decisions made in execution:**
- Resolved `project-setup` pre-existing 200-line violation as a side effect rather than separate work. Trims: SDD chain compressed (saves 4), Impact Report compressed (saves 5), Example compressed (saves 6), Step 6 footer compressed (saves 1). Net: 213 → 200.
- Memory Checkpoints section in `AGENTS.md` placed immediately after "Startup Skill Loading - Mandatory" at the highest precedence level.
- Template gate uses `<!-- comment -->` rather than a runtime check; runtime evaluation lives in `project-setup` Step 4b via skill-finder. Documented in changelog "Notes for Next Agent".

**Deferred / next pass:**
- Add a "missing memory checkpoint" structural flag to `validate-skills` Step 4 so future producer skills can't silently skip checkpoint registration.
- Layer 2 currently covers 6 producer skills. New producer skills (`release-notes`, `feature-flag-decision`, `migration-plan` if added) MUST register a checkpoint in `memory/SKILL.md` and add a final Memory Checkpoint step.
- If `project-setup` line count creeps again, escalate to `split-skill` (split into `project-setup` + `project-setup-update`).
- The working tree is uncommitted. The next agent (or this user) needs to commit:
  - `.agents/skills/validate-skills/{SKILL.md,references/validation-rubric.md}` (loader-safety work earlier today)
  - all 9 SKILL.md files touched in this layer
  - `AGENTS.md`, template, all 3 changelogs (validate-skills loader-safety, memory checkpoints auto-trigger, this handoff/state/index update)

---

## 2026-05-11 18:34 - Handoff

### Done
- Added a 10-skill memory suite under `.agents/skills/memory*`.
- Added design spec `docs/specs/2026-05-11-memory-skill-suite-design.md`.
- Added changelog `docs/changelogs/2026-05-11-memory-skill-suite.md`.
- Updated `AGENTS.md`, `README.md`, `docs/SKILL-INDEX.md`, and `docs/skill-outputs/SKILL-OUTPUTS.md` for memory suite discovery.
- Repaired six existing invalid UTF-8 skill files: `eval-judge`, `eval-output`, `eval-pipeline`, `eval-rubric-design`, `process-decomposer`, and `reality-check`.
- Repaired `universal-skill-creator` loader issues: real frontmatter description, no BOM, description under 1024 chars, and 187 lines.

### Debated
- Whether to copy Codex's `skill-creator` patterns wholesale into `universal-skill-creator`.
- Conclusion: do not copy wholesale. Preserve agent-loom's governance chain and only add platform-agnostic improvements.

### Decisions
- Keep `universal-skill-creator` as the required path for skill creation.
- Preserve calls to `research-skill`, `secure-*`, `compress-skill`, `split-skill`, `skill-deconflict`, `validate-skills`, `cross-link-skills`, `library-skill`, and optional `publish-skill`.
- Add Codex-inspired improvements only where cross-platform: example-driven design, degrees-of-freedom choice, resource selection discipline, forward-testing, and loader checks.

### Deferred
- Finish the comparison-driven improvement pass on `universal-skill-creator` carefully.
- Decide whether to update `docs/SKILL-INDEX.md` entry for `universal-skill-creator` to mention loader-safety and cross-platform metadata.
- Decide whether to add a small script/check for loader safety across all skills.

### Next Agent Should Know
- The user interrupted a proposed full rewrite because they wanted to preserve the creator's existing sub-skill call graph.
- Do not rewrite `universal-skill-creator` wholesale.
- The current `universal-skill-creator` has some targeted improvements already applied, but Step 9 still needs an explicit loader-check line and optional forward-test step if desired.
- `agentskills validate` is unavailable in this environment; use strict UTF-8/BOM/line-count checks and document the limitation.

### Revisit Triggers
- If skill loader warnings return, first scan for BOM, invalid UTF-8, missing frontmatter, and description >1024 chars.
- If `universal-skill-creator` exceeds 200 lines again, trim non-core prose rather than invoking `compress-skill` blindly.
- If Codex-specific metadata is added, keep it optional so agent-loom remains coding-agent agnostic.

### Working Tree
- Many files are modified/untracked from the memory-suite work. Review `git status --short` before editing.
- Do not revert existing changes unless the user explicitly asks.

---

## 2026-05-14 - Handoff: Retroactive Project Setup + Session Lifecycle + Chat-Learnings Loop

### Done
- New skill `retroactive-project-setup` (Atomic, 188 lines): bootstraps full agent layer over an existing codebase via a strict write-allowlist, never modifies source code. Composes `codebase-understanding`, `product-soul` (inference mode), `architectural-decision-log` (synthesis), and `project-setup` (new `RETROACTIVE=true` mode). Seeds `docs/memory/agent-handoffs.md` with a synthetic entry tagged `synthetic: true`.
- AGENTS.md template gained a symmetric `Session Lifecycle — Mandatory` block (Session Start = `memory-startup` + git check + 2-4 line context report; During & End = preserved producer-event checkpoints). Same block added to this repo's `AGENTS.md`.
- `universal-skill-creator` Step 11 — Library Sync (Mandatory) added explicitly to numbered workflow, closing the gap where `library-skill` was in AGENTS.md's invariant but missing from the creator's numbered steps. Verification checklist updated to match.
- Pre-existing line-count violations fixed as side effects: `library-skill` 207 → 189; `universal-skill-creator` adjusted to 199 after adding Step 11.
- `learn-from-chat` ↔ `improve-skills` feedback loop closed (changelog: `2026-05-13-chat-learnings-loop.md`): `improve-skills` v1.3 gained `TARGETED` mode (`TARGET=<skill> [SKIP_RESEARCH=true]`) + Step 1b chat-learnings ingest + Step 2l terminal-status close-out; `learn-from-chat` v1.2 gained Step 5 escalation gate (restructure-class edits escalate to `improve-skills TARGET=...`) + mandatory `Status` field.
- Library sync run for both deliverables: README, skill-graph, PRD (count 17→18), SKILL-INDEX all updated; cross-refs validated (8 files for retroactive-project-setup, no orphans).
- Two changelogs landed: `2026-05-13-retroactive-project-setup.md` and `2026-05-13-chat-learnings-loop.md`.
- Working tree consolidated and committed as `37c3dd6 updated project-setup to work for existing projects`.

### Debated
- Whether to add a `TARGET=` mode to `improve-skills` vs. create a new `apply-skill-patch` skill — chose the mode (canonical post-edit chain already lives in `improve-skills`; second skill would have caused drift).
- Whether `learn-from-chat` should consume `improve-skills` directly or vice versa — chose bidirectional: lfc → imp (escalation for restructure-class edits), imp → lfc log (Step 1b ingest + Step 2l close). Both ends now wired.
- Whether the retroactive bootstrap should re-implement `codebase-understanding` etc. inline vs. compose — chose composition to avoid drift.

### Decisions
- Targeted improvement path is a mode of `improve-skills`, not a separate skill (see chat-learnings-loop changelog).
- Restructure-class edits (new numbered step, section restructure, new `references/`, routing changes, 200-line crossings) are an automatic escalation in `learn-from-chat` Step 5; append-only edits stay in-scope for `learn-from-chat`.
- `retroactive-project-setup` refuses on a populated AGENTS.md and routes to `project-setup UPDATE_ONLY=true` rather than merging — keeps semantics clean.
- The Session Lifecycle block points at `memory/SKILL.md` for triggers rather than inlining the table, so it self-heals when memory checkpoints change upstream.

### Deferred
- `reality-check/SKILL.md` is 255 lines (pre-existing violation, surfaced during the final library line-count audit). Not addressed — out of scope for this session. Candidate for the next `improve-skills` pass or a focused `compress-skill` invocation.
- `architectural-decision-log/SKILL.md` was not formally exposed as an inference-mode entry point — `retroactive-project-setup` calls it for synthesis but ADL's own SKILL doesn't yet document a `SYNTHESIS=true` mode parallel to the new `RETROACTIVE=true` mode in `project-setup`. May want to align these idioms in a follow-up.
- The `agentskills validate` CLI remains unavailable in this environment; only manual structural checks were possible.

### Next Agent Should Know
- The new canonical targeted-improvement entry point is `improve-skills TARGET=<skill> SKIP_RESEARCH=true`. Use it for any in-session structural fix discovered during normal work — do NOT bypass it with direct `Edit` calls on a SKILL.md.
- Any chat-discovered learning must go through `learn-from-chat` first; if it's restructure-class, it auto-escalates. Do not hand-patch a SKILL.md from chat.
- The Session Lifecycle block is now live in this repo's AGENTS.md — at session START, invoke `memory-startup` (bounded), read latest handoff, run `git status` + `git log --oneline -5`, then state recovered context in 2–4 lines before acting.
- The `[INFERRED — confirm]` tags produced by `retroactive-project-setup` are intentional friction; agents must surface them to the user rather than silently treating them as confirmed facts.

### Revisit Triggers
- If a new event-producing skill is created (release-notes, feature-flag-decision, migration-plan, etc.), it must register a `memory/SKILL.md` Mandatory Auto-Trigger Checkpoint AND a `learn-from-chat` chat-learnings status row if it can be discovered mid-session.
- If `improve-skills` `TARGETED` mode gets used and chat-learnings entries silently stay `OPEN`, that's a Step 2l violation — treat as a bug.
- If `reality-check` or any other skill exceeds 200 lines unintentionally during routine work, route through `improve-skills TARGET=<skill> SKIP_RESEARCH=true`, not a manual Edit.

### Working Tree
- Clean. Last commit: `37c3dd6 updated project-setup to work for existing projects`.
- No untracked files; no uncommitted changes.

---

## 2026-05-17 12:30 — Handoff

### Done
- Synergy blindness (AlphaEval 2026 FAILURE_MODE) coverage extended from `agent-builder` alone to three additional lifecycle skills via `learn-from-chat` append-only path: `process-decomposer` v1.1→v1.2 (prevention gotcha — coupled-tracks check), `setup-evaluation` v1.0→v1.1 (pre-execution gate gotcha — cross-agent coupling can pass all checks; AlphaEval added to `metadata.sources`), `eval-pipeline` v1.1→v1.2 (post-hoc detection gotcha — multi-agent eval needs cross-agent consistency checks). All three cite AlphaEval 2026 (credibility 8/12, 26% cost-overrun production data).
- Coverage gap surfaced from in-session AlphaEval coverage verification (user question: "Is agent-loom incorporating these three into the eval skills library?"). Initial answer revealed synergy blindness lived only in `agent-builder`; this session closed the gap.
- Post-Application Hardening Cycle ran clean on all three: 200-line gate PASS (152 / 137 / 195), modified-skill security sweep SAFE across all four `secure-*` skills (loader safety, injection, exfiltration, credentials, HTML/scripts, zero-width / bidi unicode all checked), validate-skills criteria intact.
- Full provenance trail: `docs/learnings/chat-learnings.md` (Status IMPLEMENTED), `docs/memory/learnings.md` (+ meta-pattern entry), `docs/memory/project-index.md` (+2 rows), `docs/skill-outputs/SKILL-OUTPUTS.md` (+8 rows), `docs/changelogs/2026-05-17-synergy-blindness-coverage.md` (PATCH).
- Committed as `56b4c03 improve: extend AlphaEval synergy-blindness coverage to process-decomposer, setup-evaluation, eval-pipeline`. 8 files / +77 / −4. Not pushed.

### Debated
- Whether to include `eval-pipeline` in the extension (it already has cascade-dependency content covering the spirit of "evals need to see structure not surface"). Decided to include — synergy blindness is a distinct enough mechanism that the explicit gotcha is worth the slight redundancy. User could legitimately have KEEP-CURRENT-ed eval-pipeline alone; chose to apply all three.
- Whether to also add synergy blindness as a check row to `setup-evaluation`'s Step 3 architecture-evaluation table vs. only a gotcha. Decided gotcha-only — adding a table row counts as restructuring an existing workflow step (out of scope for `learn-from-chat`, would have escalated to `improve-skills`). Deferred as a candidate for `improve-skills TARGET=setup-evaluation SKIP_RESEARCH=true`.

### Decisions
- Synergy blindness now lives in 4 skills (`agent-builder` + the 3 added) rather than 1. Recorded as a meta-pattern in `docs/memory/learnings.md` (2026-05-17 entry): failure modes from research papers should be distributed across prevention / gate / detection skills, not concentrated in the most-obviously-related skill alone.

### Deferred
- Same coverage-gap pattern likely affects other AlphaEval findings — cascade dependency is in `eval-pipeline` but arguably belongs in `process-decomposer` Step 0 (most-preventive surface); constraint misinterpretation is only in `process-decomposer` but might also belong in `eval-judge` for post-hoc detection. Not addressed this session.
- The meta-pattern itself should become an explicit heuristic in `learn-from-paper` Step 5 (Match) or the `learn-from` orchestrator's shared application protocol. Candidate: `improve-skills TARGET=learn-from-paper SKIP_RESEARCH=true`.
- `eval-pipeline` is now at 195/200 lines. Any further additions should pair with a tightening pass (extract a non-core bullet to `references/`, or merge near-duplicate gotchas) before crossing.
- The "missing cold-start trigger" structural flag for `validate-skills` Step 4 (carried from prior handoff) is still deferred.

### Next Agent Should Know
- The user (maintainer) values "the repo should follow its own rules" — when applying chat-learnings or improvements, do not bypass `learn-from-chat` / `universal-skill-creator` / `improve-skills` with direct Edit calls on a SKILL.md. The discipline IS the product. This session demonstrated the full end-to-end discipline path for the first time on substantive content; the commit `56b4c03` is the auditable artifact.
- The AlphaEval ingestion's Application Map (`docs/learnings/papers/alphaeval-2026-lu-et-al.md`) should be re-audited for similar coverage gaps on the cascade-dependency and constraint-misinterpretation findings — same diagnostic pattern as this session.

### Revisit Triggers
- Next `learn-from-paper` ingestion lands: apply the prevention / gate / detection / remediation distribution heuristic to the Application Map BEFORE confirming changes. If most insights only map to one skill, audit for missed surfaces.
- Any AlphaEval re-score event (peer review → +1, dataset release → +1, replication → +2): update `docs/learnings/papers/alphaeval-2026-lu-et-al.md` credibility section; all 8 skills' inline citations resolve there and update automatically.
- If `eval-pipeline` is touched again: check line count first — currently 195/200.
- If the meta-pattern heuristic gets added to `learn-from-paper`: close the 2026-05-17 chat-learning's "Notes" follow-up by updating `docs/memory/learnings.md` 2026-05-17 entry's `Revisit when` line.

### Working Tree
- Dirty after this handoff: 4 modified files (memory/agent-handoffs.md, memory/current-state.md, memory/project-index.md, skill-outputs/SKILL-OUTPUTS.md) staged for the handoff commit but not committed yet (user said "end of session" — handoff written but commit decision deferred to user).
- Last committed: `56b4c03 improve: extend AlphaEval synergy-blindness coverage to process-decomposer, setup-evaluation, eval-pipeline`.
- Not pushed to remote.
