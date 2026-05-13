# Changelog: Retroactive Project Setup + Session Lifecycle + Skill-Creator Library-Sync Step
Date: 2026-05-13
Significance: MINOR — one new skill, one new mandatory step in `universal-skill-creator`, expanded AGENTS.md template covering session start, two pre-existing line-count violations resolved.

## Summary
Closes the AGENTS.md asymmetry where end-of-session checkpoints were instructed but session start was not, and adds a counterpart to `project-setup` for backfilling agent infrastructure onto an existing codebase without touching source code. Also formalises the post-creation library-sync that was previously implicit in `AGENTS.md`'s "Step 8 auto-chain" invariant but missing from the creator's numbered workflow — making it an explicit, numbered, mandatory step.

## Breaking Changes
None. All additions are additive; existing skills and AGENTS.md files continue to work.

## Added
- **`retroactive-project-setup` skill (Atomic tier, 188 lines)** — bootstraps the full agent layer (AGENTS.md + `docs/architecture.md` + `docs/product-soul.md` + `docs/adr/ADR-0001-initial-backfill.md` + `docs/memory/` seed) over an existing codebase. Surveys repo manifests, README, CHANGELOG, source samples, and the last 50 commits to infer everything answerable. Runs a ≤6-question targeted interview only for genuine gaps (primary user, business model, "done" definition, autonomy preferences, SDD intent, ADR backfill consent). Tags low-confidence inferences as `[INFERRED — confirm]`. Enforces a strict write-allowlist and aborts on any out-of-allowlist write. Refuses on populated AGENTS.md, routing to `project-setup UPDATE_ONLY=true` instead. Composes `codebase-understanding`, `product-soul` (inference mode), `architectural-decision-log` (synthesis), and `project-setup` (with new `RETROACTIVE=true` mode passing the pre-inferred matrix + interview answers). Seeds `docs/memory/agent-handoffs.md` with a single synthetic entry marked `synthetic: true` so the first real `memory-startup` can distinguish it from a human handoff. Trigger phrases: "retroactive project setup", "backfill agent infrastructure", "bootstrap agents for this existing repo", "onboard agents to a legacy codebase", "set up agents without touching code".
- **Session Lifecycle block in AGENTS.md template** — the `project-setup` template now ships with a symmetric `## Session Lifecycle — Mandatory` section split into two subsections. **Session Start**: invoke `memory-startup` for bounded continuity (project-index + latest handoff + relevant decisions only), run `git status` + `git log --oneline -5`, state recovered context in 2–4 lines, wait for user confirm. **During & End of Session**: the existing producer-event auto-trigger checkpoint guidance. Opt-out: user says "fresh start" or "ignore prior context".
- **`universal-skill-creator` Step 11 — Library Sync (Mandatory)** — explicit numbered step invokes `library-skill` with trigger `new skill added — <skill-name>` after Step 10 (cross-link repair). Syncs `docs/SKILL-INDEX.md`, `AGENTS.md` (User Entry Points + Security Enforcement), `README.md` skill tables, `docs/skill-graph.md`, `docs/architecture.md`, `docs/prd/PRD.md`, then auto-invokes `generate-changelog`. Closes the gap where library-sync was documented in `AGENTS.md`'s "Step 8 auto-chain" invariant but not in the creator's numbered workflow, leading to selective skip. Verification checklist gained a corresponding item: "Step 11 (library-skill) has been invoked — skill is registered in SKILL-INDEX, README, skill-graph, PRD."

## Changed
- **Repo `AGENTS.md`** — renamed "Memory Checkpoints — Mandatory" to "Session Lifecycle — Mandatory" and split into Session Start (3 numbered steps + opt-out + no-prior-memory path) and During & End of Session (preserved verbatim). Added "backfill agent infra" / "retroactive project setup" → `retroactive-project-setup` to User Entry Points.
- **`project-setup` SKILL.md** — Axis 1 Q5 reworded to ask about the full lifecycle block. Step 4b item 9 (was "Memory Checkpoints") now describes both session start and end semantics. Update Mode preserve list renamed Memory Checkpoints → Session Lifecycle. Added sibling-skill cross-reference to `retroactive-project-setup` and a `RETROACTIVE=true` mode hint. Example output and Impact Report updated to reflect the new label.
- **`project-setup` template `agents-md-template.md`** — Session Lifecycle block replaces the old Memory Checkpoints block; references the source SKILL.md path rather than inlining the trigger table so the template stays self-healing when memory checkpoints are added or removed upstream.

## Fixed
- **Two pre-existing line-count violations resolved as side effects.** `universal-skill-creator` (200 → 199 after compressing the Verification Checklist from 12 single-property items to 8 grouped items and tightening Gotchas, while net-adding the new Step 11 narrative). `library-skill` (207 → 189 after replacing the verbose inline Mermaid example in Step 5 with a 3-bullet specification — the Mermaid block was illustrative, not normative, and other skills already produce real Mermaid output).

## Validation
- Line counts: every touched SKILL.md verified ≤200 lines via `wc -l`. `retroactive-project-setup` 188, `project-setup` 200, `universal-skill-creator` 199, `library-skill` 189.
- Skill name and triggers manually deconflicted against all 88 existing skill names; no collision. Closest neighbour `project-setup` is distinguished by "retroactive" / "backfill" / "legacy" / "existing repo" trigger keywords.
- Cross-references: `retroactive-project-setup` appears in `AGENTS.md`, `README.md`, `docs/skill-graph.md` (node + edges + entry-points list), `docs/prd/PRD.md` (§4.3 inventory + count 17→18 + last-updated bumped to 2026-05-13), `docs/SKILL-INDEX.md` (full entry + see-also on `project-setup`), `docs/memory/learnings.md` (provenance entry), and `docs/skill-outputs/SKILL-OUTPUTS.md` (six new log rows). No broken or orphaned references detected.
- `agentskills validate`: not run (CLI not installed in this environment).
- Security: the new skill itself fetches no external content; encodes its safety guarantee as a write-allowlist enforced in workflow Step 1. No `secure-*` content-scan applicable to the skill body.

## Files Touched
```
.agents/skills/retroactive-project-setup/SKILL.md            (new, 188 lines)
.agents/skills/project-setup/SKILL.md                        (200 lines, sibling xref + Q5 wording)
.agents/skills/project-setup/templates/agents-md-template.md (Session Lifecycle block)
.agents/skills/universal-skill-creator/SKILL.md              (199 lines, new Step 11)
.agents/skills/library-skill/SKILL.md                        (189 lines, pre-existing violation fixed)
AGENTS.md                                                    (Session Lifecycle + entry point)
README.md                                                    (skill table row added)
docs/SKILL-INDEX.md                                          (entry + see-also)
docs/skill-graph.md                                          (node + edges + entry points)
docs/prd/PRD.md                                              (inventory + count + date)
docs/memory/learnings.md                                     (provenance)
docs/skill-outputs/SKILL-OUTPUTS.md                          (6 rows appended)
```
