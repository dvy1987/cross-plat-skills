# Changelog: SKILL-INDEX + PRD Reconciliation — library-skill v1.2

Date: 2026-05-20
Significance: MINOR — sharpens an existing meta skill (library-skill v1.1 → v1.2), registers 7 long-orphaned skills in SKILL-INDEX, removes a pre-existing duplicate, and brings PRD §4 to full registry truth. No skills added/removed/renamed; no routing changes; reference-doc accuracy only.

## Summary
Following the 2026-05-19 prose-count rewrite, a deeper audit revealed (a) my initial cross-reference scan had three false positives, (b) the SKILL-INDEX orphan count was 7, not 2, (c) a pre-existing duplicate `inversion` entry, and (d) the mechanical count-rewrite from v1.1 had introduced an internal inconsistency in the PRD (section headers bumped to the registry while the tables they label were short of rows). All real issues were fixed in one pass and verified programmatically against the live registry.

## Breaking Changes
None.

## What the Audit Corrected (from the 2026-05-19 findings)
- **False positives** — three "broken references" flagged on 2026-05-19 were not skills at all:
  - `agent-chain` — a **process classification** (one of exact-match / single-skill / skill-chain / agent-chain) used by `process-decomposer`.
  - `setup-evaluator` — an **agent** (runtime container), correctly listed in SKILL-INDEX's `### Agents` section; it *runs* the `setup-evaluation` skill for independence. Documented in the 2026-05-11 quality-hardening release.
  - `specify` — a **slash command** (`/specify`), routed by `spec-driven-development` to `feature-spec`.
  - Root cause of the false positives: a regex that matched every backticked identifier could not distinguish skill names from process types, agent names, and slash commands.
- **Orphan count was 7, not 2.** The full set of skills present on disk but missing a SKILL-INDEX definition heading: `deep-thinking`, `assumption-mapping`, `pre-mortem`, `socratic` (all from commit `72ab6c5` "deep thinking architecture"), `cross-link-skills` (`0fb874e`), `problem-to-plan` (`ebaa60e`), `agent-launcher` (`e9fa19b`). Root cause: `library-skill` was never invoked when these skills were created across four separate commits.

## Changed

- **`.agents/skills/library-skill/SKILL.md`** (191 lines, version 1.1 → 1.2)
  - Step 4 now distinguishes two count types: **standalone prose counts** (intro / What's-New / suite blurb not heading a table) — rewrite freely to the registry; and **table-labeling counts** (a heading like "Meta Skills (22)" directly above a table) — MUST equal the rows beneath, NEVER bump without syncing the rows in the same edit; if the table can't be synced this run, leave the number and flag it in the Impact Report.
  - Gotcha rewritten: *"Never make a heading lie about its own table."* Rationale captured inline — bumping a heading to the registry while its table is short turns a consistent-but-stale doc into an inconsistent one (exactly the regression the v1.1 mechanical rewrite caused in the PRD before this fix).

- **`docs/SKILL-INDEX.md`**
  - Added 7 missing skill entries with full format (Triggers / What it does / Calls / Output / Impact report): `cross-link-skills` (Meta), `deep-thinking` + `assumption-mapping` + `pre-mortem` + `socratic` (Thinking), `problem-to-plan` + `agent-launcher` (Project-Specific). `agent-launcher` carries an explicit `internal: true` note and the Tier-1 (Claude Code / Ampcode only) platform constraint.
  - Removed a misplaced **duplicate `inversion` entry** that sat in the Project-Specific section (pre-existing — present in `git HEAD` with 2 occurrences). The correctly-placed entry in the Thinking section is retained.
  - Verified: SKILL-INDEX now lists exactly 90 skills, 1:1 with the registry, zero duplicates, zero entries-not-on-disk (the one `setup-evaluator` "extra" is correctly an agent, not a skill).

- **`docs/prd/PRD.md`** (Section 4)
  - Full table sync to registry truth: §4.1 = 22 meta, §4.2 = 11 thinking (unchanged), §4.3 = 57 project-specific, §4.4 = 0 domain. 38 missing rows added.
  - Fixed 4 miscategorizations against SKILL.md frontmatter: `skill-finder`, `tool-finder`, `generate-changelog` moved §4.1 (meta) → §4.3 (project-specific); `learn-from-paper` moved §4.3 → §4.1 (meta).
  - Section header counts now equal their table rows (resolves the v1.1 inconsistency). Total 90; `Last updated` 2026-05-20.

## Verification
- `SKILL-INDEX` skill headings (excluding the `### Agents` section): 90, diff against registry empty in both directions, no duplicates.
- `PRD §4` per-category diff against registry: §4.1 22/22, §4.2 11/11, §4.3 57/57 — all MATCH; total 90 rows; no duplicates across sections; every section header integer equals its row count.
- `library-skill` 191 / 200 lines (size gate PASS); frontmatter structurally unchanged apart from version bump.

## Notes for Next Agent
- **Descriptions are condensed, not authoritative.** The 38 new PRD §4 one-liners and 7 new SKILL-INDEX entries were derived from each skill's README row / frontmatter `description`. They are accurate but terse; if a skill's behavior changes, update the SKILL.md first and let `library-skill` propagate.
- **`docs/skill-graph.md` regenerated (2026-05-20).** Full Step-5 rebuild from the synced SKILL-INDEX: 90 skill nodes + the `setup-evaluator` agent across 12 subgraphs (previously ~58 nodes, missing the memory / eval / experiment / frontend / SDD suites entirely). Every edge endpoint was validated against a declared node; 3 nodes are intentionally isolated (`code-review-crsp`, `debug-and-fix`, `technical-debt-audit` — standalone engineering skills with no skill-to-skill calls).
- **Root-cause fix landed in v1.2**, but the *creation-time* gap remains the real lever: these 7 orphans existed because `universal-skill-creator` Step 11 (invoke `library-skill`) was skipped on four historical commits. The `Skill Creation Invariant` in AGENTS.md is meant to prevent this going forward; consider a CI check that fails when a `.agents/skills/*/SKILL.md` exists with no matching SKILL-INDEX heading.
