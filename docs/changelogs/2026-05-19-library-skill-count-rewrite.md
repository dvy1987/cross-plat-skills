# Changelog: library-skill v1.1 — Mandatory Prose Skill-Count Rewrite

Date: 2026-05-19
Significance: PATCH — adds a missing maintenance behavior to an existing meta skill; no breaking changes; routing-neutral; one workflow-step expansion + one new Gotcha.

## Summary
`library-skill` already kept skill **tables** in sync across reference docs whenever a structural change occurred. It did not, however, enforce a rewrite of **prose** skill counts (e.g. "**90 skills**" in README intros, "(5 skills)" in suite blurbs, "N skills across M categories" in the PRD). The result was silent drift: the PRD claimed 56 skills as of 2026-04-18 while the registry held 90, and the README had no top-level count at all. This release makes the rewrite of every prose count occurrence a mandatory action of Step 4 (Update `README.md`) and adds a Gotcha so future agents do not drop the step on a deprecate-only or rename-only sync.

## Breaking Changes
None.

## Changed

- **`.agents/skills/library-skill/SKILL.md`** (189 → 191 lines, version 1.0 → 1.1)
  - Step 4 (Update `README.md`) gains one mandatory bullet: *"Rewrite the total skill count. Compute `N = len(skill registry from step 1)` — count only `.agents/skills/*/SKILL.md` files, exclude `.deprecated/`. Find every prose occurrence of the pattern `**N skills**` (or `N skills` in headline / What's-New / suite-summary lines) and replace with the recomputed N. Do NOT invent a count line if none exists; only rewrite existing mentions. Treat per-suite counts (e.g. 'Spec-Driven Development suite (4 skills)') the same way — recompute from the registry, never carry the old number forward."*
  - One Gotcha appended: *"Prose counts drift silently. Table rows are easy — the 'N skills' mention in the intro or 'What's New' prose gets forgotten because no row signals its existence. Step 4 MUST recompute and rewrite the count from the live registry on every run, even when no skill was added or removed (a deprecate-only sync still changes N)."*

- **`README.md`** (intro section)
  - New prose line in the "What is this?" section: *"Today the library contains **90 skills** across thinking, project lifecycle, evaluation, security, memory, frontend, and meta layers — kept in sync by `library-skill` on every create / split / deprecate / structural improvement."* Adds the first top-level count the README has ever carried, and names the maintenance path so the count's provenance is discoverable.

- **`docs/prd/PRD.md`** (Section 4 header + frontmatter date)
  - Header rewritten from *"**56 skills** across 4 categories as of 2026-04-18"* to *"**90 skills** across 3 active categories as of 2026-05-19 (meta · thinking · project-specific; `domain` slot reserved, currently empty)."* The previous "4 categories" framing conflated schema slots with populated categories — the new framing keeps the slot reserved (no schema change) while reflecting the live population.
  - Section 4.1 header: `Meta Skills (20)` → `Meta Skills (22)`.
  - Section 4.3 header: `Project-Specific Skills (18)` → `Project-Specific Skills (57)`.
  - `Last updated` bumped 2026-05-13 → 2026-05-19.

## Process Notes
- Route: targeted `improve-skills TARGET=library-skill SKIP_RESEARCH=true` (change source is a direct user directive, no external research required).
- Post-Application Hardening Cycle on the modified skill:
  - **200-line gate**: PASS (191 / 200, 9 lines of headroom).
  - **Modified-skill security sweep**: SAFE — plain markdown content, no URLs, no executable patterns, no zero-width / bidi unicode, no credentials.
  - **validate-skills**: PASS — workflow / gotchas / version-bump strengthened, no other section regressed.
- `library-skill` then ran end-to-end against the new Step 4 instruction. Registry built from disk (90 skills: 22 meta · 11 thinking · 57 project-specific · 0 domain). README, PRD intro, and SKILL-OUTPUTS log were rewritten by the new logic. `generate-changelog` produced this file.

## Findings Not Auto-Applied
The same library-skill run surfaced three pre-existing drift items that were *not* count-rewrites and so were not auto-applied — they need a deliberate sync pass, not a mechanical line-edit:

- **SKILL-INDEX.md missing entries**: `agent-launcher`, `deep-thinking` exist on disk but are absent from the index. Adding them needs full registry rows (description, category, triggers, called-by), not a count fix.
- **SKILL-INDEX.md broken references**: `agent-chain`, `setup-evaluator`, `specify` are referenced by SKILL-INDEX but absent from `.agents/skills/`. Likely renames (`setup-evaluator` → `setup-evaluation`; `specify` → `feature-spec`'s `/specify` route; `agent-chain` → unknown) — needs human disambiguation before the index can be safely corrected.
- **PRD Section 4 tables**: only ~49 skill rows present vs the registry's 90. Bringing the tables back to ground truth is a larger structural rewrite (correct categorization, one-line purpose for each missing skill) — flagged for a separate pass, not auto-rewritten by the count logic.

These are all in `docs/skill-outputs/SKILL-OUTPUTS.md` under the 2026-05-19 18:15 `library-skill` (audit only) entry.

## Notes for Next Agent
- The new Step 4 instruction is mechanical (regex-style rewrite of "N skills" patterns from the live registry). It is **not** a substitute for table-level sync. When the next structural change happens, run the full library-skill workflow, not just the count rewrite.
- The PRD Section 4 table sync is the highest-value backlog item: ~41 skills are missing from the tables, which means downstream consumers of the PRD (other agents reading it as ground truth) will route on a 56-skill mental model. Worth pairing with a `skill-deconflict` pass since several near-duplicate descriptions may surface.
- `library-skill` is now at 191 / 200 lines. Any further addition should pair with a tightening pass (move one of the existing Gotcha lines to `references/` or merge with an adjacent Hard Rule) before crossing the threshold.
