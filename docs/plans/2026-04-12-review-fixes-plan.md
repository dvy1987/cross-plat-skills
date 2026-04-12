# Implementation Plan: Review Fixes For Improve-Skills Batch

**Date:** 2026-04-12
**Driver:** Review findings on the 10-skill improve-skills batch
**Goal:** Fix the 4 reported regressions/policy violations without disturbing unrelated repo changes

## Executive Summary

The current batch needs a narrow corrective pass. Two issues are behavioral regressions in `agent-creator`: the launcher must obey architecture-defined failure handling again, and hierarchical launches must only emit the orchestrator spawn block instead of eagerly spawning workers. One issue is a contract mismatch in `agent-system-architecture`: examples must teach `parallel`, not `Concurrent`, because downstream consumers parse topology strings literally. One issue is a documentation-policy violation in `docs/changelogs/v1.1.1.md`: user-facing changelogs must not describe internal security-fix implementation details.

The safest execution strategy is a small, file-scoped repair with explicit verification after each fix, followed by a focused review of the staged diff and either an amend or a follow-up commit.

## Technical Scope

- Files in scope:
  - `.agents/skills/agent-creator/SKILL.md`
  - `.agents/skills/agent-system-architecture/SKILL.md`
  - `docs/changelogs/v1.1.1.md`
- Tools:
  - `apply_patch` for all edits
  - `git diff`, `git diff --check`, `git status`
  - line-count checks via PowerShell
- Out of scope:
  - unrelated dirty-worktree files
  - broader library-sync docs (`README.md`, `docs/SKILL-INDEX.md`, `AGENTS.md`) unless the fix changes a name, category, or call graph

## Architecture Overview

This is a constrained documentation-and-skill repair, not a feature build.

- `agent-system-architecture` produces architecture specs and examples.
- `agent-creator` consumes those specs and must preserve architecture-defined behavior.
- `v1.1.1.md` is a user-facing changelog and must follow repo doc policy.

The critical dependency is:

`agent-system-architecture` terminology -> `agent-creator` topology parsing -> launch behavior

Any mismatch here can break downstream execution even if the docs look reasonable.

## Phase 0 - Preconditions And Safety Setup

- [ ] Inspect the current contents of the three in-scope files and the review comments side-by-side.
  **DoD:** Each review finding is mapped to a specific line/block to edit.
- [ ] Confirm the repo is still dirty outside this scope and record the exact files to avoid staging.
  **DoD:** A scoped path list exists for the repair commit or amend.
- [ ] Decide commit strategy before editing: amend the previous batch commit if no one else depends on it; otherwise create a follow-up fix commit.
  **DoD:** One commit strategy chosen before stage/commit.

## Phase 1 - Restore `agent-creator` Launch Semantics

### Task 1.1 - Restore hierarchical spawn behavior
- [ ] Replace the generic Step 4 wording so hierarchical topology emits only the orchestrator launch block plus the sub-agent list, not one block per worker.
  **DoD:** The hierarchical instructions clearly say the launcher starts only the orchestrator and does not eagerly spawn worker agents.

### Task 1.2 - Restore architecture-defined failure handling
- [ ] Rewrite Step 5 so failure behavior is driven by the architecture spec's extracted failure-handling rules, with defaults only as fallback guidance if the spec is silent.
  **DoD:** The skill no longer hardcodes retry/continue behavior when the architecture explicitly defines something different.

### Task 1.3 - Add a hierarchical example if needed
- [ ] If the compressed examples leave hierarchy ambiguous, add one compact hierarchical example or a compact topology-specific note.
  **DoD:** A reader can infer the correct hierarchical launch pattern without guessing.

## Phase 2 - Repair Topology Contract In `agent-system-architecture`

### Task 2.1 - Align example terminology
- [ ] Replace `Concurrent` with `parallel` in the new example's orchestration summary and impact-report lines.
  **DoD:** The example uses topology strings that downstream skills already understand literally.

### Task 2.2 - Check the surrounding pattern language
- [ ] Verify the example does not create ambiguity between conceptual concurrency and the canonical topology label `parallel`.
  **DoD:** The example can still explain concurrent work, but the declared pattern value is `parallel`.

## Phase 3 - Repair Changelog Policy Violation

### Task 3.1 - Remove security-fix implementation framing
- [ ] Replace the `Security Skill Improvements` section with policy-safe user-facing wording or fold those bullets into a neutral structural-improvements section.
  **DoD:** `docs/changelogs/v1.1.1.md` no longer mentions internal security fixes or implementation details as a dedicated user-facing section.

### Task 3.2 - Re-read against repo doc policy
- [ ] Check the full changelog for wording that could still be interpreted as exposing internal security implementation details.
  **DoD:** The changelog is consistent with the repo's “no security findings/fixes in user-facing docs” rule.

## Phase 4 - Verification

### Task 4.1 - Diff hygiene
- [ ] Run `git diff --check` on the three in-scope files.
  **DoD:** No whitespace or patch-format issues reported.

### Task 4.2 - Behavioral verification by inspection
- [ ] Re-read `agent-creator` Step 2, Step 4, and Step 5 together.
  **DoD:** Extracted topology and failure rules are still reflected consistently in the later instructions.

### Task 4.3 - Contract verification by inspection
- [ ] Re-read the `agent-system-architecture` example together with the `agent-creator` accepted topology values.
  **DoD:** The example cannot teach an unsupported topology string.

### Task 4.4 - Policy verification by inspection
- [ ] Re-read `docs/changelogs/v1.1.1.md` against the repo doc-policy rule in `AGENTS.md`.
  **DoD:** No explicit internal security-fix language remains.

### Task 4.5 - Size guardrails
- [ ] Recheck line counts on the two edited skill files.
  **DoD:** `agent-creator` remains <=200 lines and `agent-system-architecture` remains <=200 lines.

## Phase 5 - Commit And Closeout

- [ ] Stage only the repaired files.
  **DoD:** `git status --short` shows only the intended files staged for this repair.
- [ ] Execute the chosen commit strategy:
  - amend the previous batch commit if preserving a single clean batch commit is still appropriate
  - otherwise create a follow-up fix commit referencing the review findings
  **DoD:** Git history clearly communicates that the review regressions were fixed.
- [ ] Summarize the fixes in plain language for non-technical review.
  **DoD:** User-facing summary explains what was broken, what was corrected, and what remains unverified.

## Risks And Mitigations

1. **Risk:** Over-compressing `agent-creator` again could reintroduce ambiguity in hierarchical behavior or failure handling.
   **Mitigation:** Prefer one compact topology-specific block over a generic abstraction when semantics differ materially.

2. **Risk:** Fixing the changelog too aggressively could erase useful release context.
   **Mitigation:** Preserve the structural-improvement narrative, but remove security-specific implementation framing only.

3. **Risk:** Amending the previous commit may be undesirable if someone has already referenced the old SHA.
   **Mitigation:** Decide commit strategy explicitly in Phase 0 based on whether preserving the existing commit hash matters.

## Timeline Estimate

**Estimated effort:** S (30-60 minutes)

- Phase 0: 5-10 min
- Phase 1: 10-20 min
- Phase 2: 5 min
- Phase 3: 5-10 min
- Phase 4-5: 10-15 min

## Ready-To-Execute Checklist

- [ ] Review comments mapped to exact edit locations
- [ ] Commit strategy chosen
- [ ] `agent-creator` semantics restored
- [ ] `agent-system-architecture` topology string aligned
- [ ] changelog wording policy-safe
- [ ] diffs checked
- [ ] line counts rechecked
- [ ] scoped commit created
