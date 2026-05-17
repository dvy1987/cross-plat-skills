# Changelog: Synergy Blindness — Coverage Extended to Prevention / Gate / Detection Skills

Date: 2026-05-17
Significance: PATCH — extends an existing AlphaEval-derived FAILURE_MODE (synergy blindness) into three additional skills that cover earlier and later stages of the agent lifecycle; no breaking changes; routing-neutral; gotcha-only additions via `learn-from-chat`.

## Summary
Verifying AlphaEval coverage during an in-session question revealed that synergy blindness (AlphaEval 2026 — 26% cost overruns documented in production procurement when independent agents optimize components separately) had been wired only into `agent-builder` during the original 2026-04-21 ingestion. The same failure pattern is structurally relevant at three additional intervention points in the agent lifecycle: **prevention** (`process-decomposer` — catch coupled tracks before they're declared "independent for parallelism"), **pre-execution gate** (`setup-evaluation` — flag architectures that lack cross-agent validation checkpoints), and **post-hoc detection** (`eval-pipeline` — surface synergy-blindness symptoms in multi-agent system outputs). All three are now wired in through the `learn-from-chat` append-only path. The earlier in the lifecycle the failure mode is caught, the cheaper the fix.

## Breaking Changes
None.

## Changed

- **`.agents/skills/process-decomposer/SKILL.md`** (151 → 152 lines, version 1.1 → 1.2)
  - One gotcha appended to `## Gotchas`: *"Don't declare parallel tracks 'independent' without checking for coupled decisions."* Guidance: when decomposing into parallel sub-tasks, ask whether a decision in one track can make decisions in another suboptimal — if so, the tracks are coupled, not independent. Design a coordination point or merge them. Catches synergy blindness at the decomposition stage, before architecture is designed.
  - AlphaEval already present in `metadata.sources` (added during 2026-04-21 ingestion).

- **`.agents/skills/setup-evaluation/SKILL.md`** (134 → 137 lines, version 1.0 → 1.1)
  - `metadata.sources` expanded from one-line to multiline; AlphaEval added with credibility-8/12 citation and pointer to `docs/learnings/papers/alphaeval-2026-lu-et-al.md`.
  - One gotcha appended to `## Gotchas`: *"Cross-agent coupling can pass all checks but still produce synergy blindness."* Guidance: architectures where multiple agents make decisions affecting a shared outcome (cost, schedule, dependencies) need explicit cross-agent validation checkpoints — otherwise locally-optimal decisions can produce globally suboptimal results. Evaluators should flag any multi-agent architecture lacking a cross-agent checkpoint as a structural concern even if Step 3's checks pass.

- **`.agents/skills/eval-pipeline/SKILL.md`** (194 → 195 lines, version 1.1 → 1.2)
  - One gotcha appended to `## Gotchas`: *"Multi-agent eval needs cross-agent consistency checks."* Guidance: independent agents producing locally-correct outputs can combine into globally suboptimal results — end-to-end eval alone won't catch this. Add cross-agent checks for conflicting / redundant / jointly-suboptimal decisions when designing evals for multi-agent pipelines.
  - AlphaEval already present in `metadata.sources` (added during 2026-04-21 ingestion).

## Process Notes
- All three additions routed through `learn-from-chat` v1.2 append-only path (one bullet per skill to `## Gotchas`). No workflow steps renumbered, no sections restructured, no new `references/` files, no routing triggers modified — fully in-scope for the chat-learning gate, no escalation to `improve-skills` needed.
- Post-Application Hardening Cycle ran clean on all three:
  - **200-line gate**: PASS (152 / 137 / 195 — `eval-pipeline` at 5 lines of headroom).
  - **Modified-skill security sweep** (all `secure-*` skills against the resulting files): SAFE on all three — no prompt-injection patterns, no exfiltration markers, no credential leaks, no HTML / scripts / hidden content, no zero-width or bidi unicode. `secure-skill-repo-ingestion` N/A (chat learning, not external repo content).
  - **validate-skills**: PASS — only `## Gotchas` section changed (improvement direction); all other criteria untouched.
- Provenance logged to `docs/learnings/chat-learnings.md` with `Status: IMPLEMENTED (2026-05-17, process-decomposer v1.2, setup-evaluation v1.1, eval-pipeline v1.2)`.
- Memory checkpoint fired per `memory/SKILL.md` Mandatory Auto-Trigger Checkpoints (event: skill significantly edited → `memory-capture`). Project learning recorded in `docs/memory/learnings.md` and indexed in `docs/memory/project-index.md`.

## Notes for Next Agent
- The deeper lesson recorded in `docs/memory/learnings.md` (2026-05-17 entry) is a meta-pattern for future `learn-from-paper` ingestions: when a research finding identifies a multi-stage failure mode, the Application Map should distribute the insight across the prevention / gate / detection / remediation skills covering each stage of the lifecycle, not concentrate it in the most-obviously-related skill alone. Worth surfacing as an explicit heuristic in a future `improve-skills TARGET=learn-from-paper SKIP_RESEARCH=true` pass.
- The same coverage-gap pattern likely affects other AlphaEval findings still in the library — cascade dependency is in `eval-pipeline` but arguably belongs in `process-decomposer` Step 0 (most-preventive surface); constraint misinterpretation is only in `process-decomposer` but might also belong in `eval-judge` for post-hoc detection. Not in scope for this release; flagged for the next AlphaEval-coverage audit.
- `eval-pipeline` is now at 195 / 200 lines. Any further additions should pair with a tightening pass (extract a non-core bullet to `references/`, or merge near-duplicate gotchas) before crossing the line.
