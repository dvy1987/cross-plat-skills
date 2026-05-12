# Changelog: validate-skills Loader-Safety Checks
Date: 2026-05-11
Significance: PATCH — one skill updated, one reference file extended, no new skills, no breaking changes.

## Summary
Closes the gap between `universal-skill-creator` (which has enforced loader-safety on new skills since the 2026-05-11 repair) and `validate-skills` (which previously had no way to detect loader-unsafe skills authored before those rules existed). The earlier loader incident hit six pre-existing skills with invalid UTF-8 / BOM / encoding regressions that `validate-skills` could not surface. After this change, the same audit run that scores quality also catches BOM, missing-fence, byte-0, and oversized-description issues — all rated P0 because they prevent the skill from loading at all.

## Breaking Changes
None.

## Added
- **`validate-skills` Step 2a — Loader-Safety Check** — runs a one-liner shell loop after `agentskills validate` and before scoring. Catches the two highest-impact loader failures: byte-0 not `-` (BOM or stray whitespace) and missing closing `---` fence. Any failure is rated P0 in the report. Verified clean across all 89 skills currently in the library.
- **`validate-skills` report now includes a `LOADER SAFETY (P0)` block** — sits between `VALIDATION STATUS` and `SIZE CHECK` in the Step 6 output format. Format: `✓ [skill]` for passes, `✗ [skill]: <specific failure>` for misses (e.g. `BOM detected | byte 0 = 0xEF | missing closing --- | description = 1217 chars`).
- **`Loader-unsafe` structural-issue flag** — new bullet in the Step 4 structural-issues list pointing at the rubric for fix instructions. Feeds directly into `improve-skills` Step 2b like every other structural flag.
- **4 loader-safety rows in `references/validation-rubric.md` Frontmatter Checks** — UTF-8/no-BOM, byte-0 `-`, closing `---`, and ≤1024 char description. Each row has a one-line fix recipe. New "Loader-safety command reference" block below the table gives copy-paste shell commands including the awk-based description-length check (the one check too noisy to put in the SKILL.md shell loop).

## Validation
- Line counts: `validate-skills/SKILL.md` is 199 lines (under the 200 cap), `references/validation-rubric.md` grew from 100 to 123 lines (no cap on references).
- Encoding: both touched files are UTF-8, no BOM, open with `---` and have ≥2 `---` fences (loader-safe by their own rule).
- Loader check on the full library: ran the new Step 2a loop against all 89 skills in `.agents/skills/` — zero failures, zero false positives.
- `agentskills validate`: not run (CLI not installed in this environment); manual line-count and frontmatter checks performed instead.

## Notes for Next Agent
- The description-length check (≤1024 chars) is intentionally only in `references/validation-rubric.md`, not in the SKILL.md shell loop. Reason: a reliable folded-block parser is too long for the SKILL.md size budget. If a future loader incident traces back to oversized descriptions, promote the awk command from the reference file into Step 2a.
- The prior agent's handoff proposed adding loader-safety to `universal-skill-creator` Step 9 and creating a standalone loader-check script. Both were rejected: Step 9 already gates on Verification Checklist + Gotchas (4 loader-safety items between them), and `validate-skills` is the canonical home for repo-wide audits. See `docs/memory/agent-handoffs.md` 2026-05-11 18:34 entry for the rejected items.
