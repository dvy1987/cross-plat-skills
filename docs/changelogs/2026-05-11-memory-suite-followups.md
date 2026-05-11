# Changelog: Memory Suite Follow-ups & Skill-Creator Repair
Date: 2026-05-11
Significance: PATCH — six follow-up fixes on existing skills after the memory-suite landing; no new skills, no breaking changes.

## Summary
Follow-up pass on the memory skill suite and `universal-skill-creator` after the previous agent's loader-repair commit. Six small fixes tighten internal consistency, make first-session memory bootstrap usable, and remove a self-violating reference-orphaning regression in the skill creator. Useful for maintainers who hit the prior loader incident or are about to run a fresh `memory-startup` for the first time.

## Breaking Changes
None.

## Fixed
- **Reference files no longer orphaned in `universal-skill-creator`** — skill authors using this creator can now actually load the platform matrix, GitHub-repo research notes, research-paper guidance, scaffolder script, and templates. The prior commit deleted the `## Reference Files` section while leaving every file declared under `metadata.resources` — making them invisible per the creator's own Step 5 rule and the `compress-skill` "invisible references" gotcha. Re-pull `main` if you've created any skills since `dc566aa` and want full reference coverage.
- **Memory orchestrator no longer reads its security gate as an afterthought** — agents working with external content (pasted transcripts, URLs, repo extracts) now see the `secure-*` scan as Step 1 of the `memory` workflow instead of buried at Step 12. The original ordering was technically correct because child skills gate on their own, but a top-down reader could miss it. Upgrade if you route ingestion through the `memory` orchestrator before child invocation.

## Changed
- **First-session memory bootstrap now produces a usable scaffold** — new projects running `memory-startup` for the first time can now act on a populated `MEMORY-ROUTING.md` (intent → file → "read when" table + three routing rules) and a `project-index.md` column header, instead of empty stubs that would push agents to "read everything." Try by deleting `docs/memory/` in a fresh project and re-running `memory-startup`.
- **`memory-capture` template scope is now explicit** — agents reading the skill no longer have to infer that the capture template applies only to state/learning/deferred/question/session, not decisions or handoffs. One line above the template now spells out the routing exception. Read the updated SKILL.md if you've been hand-merging capture entries.
- **`memory-audit` gained a cross-file overlap check** — auditors running `memory-audit` will now flag any `Confidence: low` decision in `decision-log.md` that also appears as a line in `current-state.md` Active Risks, with a consolidation recommendation. Prevents silent drift between the decision log and the live-state risk list. Run `memory-audit` on long-lived projects to surface duplicates.
- **Memory-suite changelog validation evidence is now concrete** — readers auditing the 2026-05-11 memory-suite changelog can now see the exact command used for line-count verification (`wc -l .agents/skills/memory*/SKILL.md`) plus the largest file's actual count (101 lines), matching the in-repo convention used by `validate-skills`, `compress-skill`, and `improve-skills`. Re-read the changelog if you maintain release discipline for this repo.

## Validation
- Line counts: verified via `wc -l` on every touched SKILL.md — all remain ≤200 lines (`universal-skill-creator` 200, `memory` 101, `memory-startup` 123, `memory-capture` 89, `memory-audit` 72).
- Encoding: every touched SKILL.md is UTF-8, no BOM, opens with `---` (loader-safe).
- `agentskills validate`: not run (CLI not installed in this environment).
