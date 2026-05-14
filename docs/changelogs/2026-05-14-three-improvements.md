# 2026-05-14 — Three Library-Health Improvements

Three deferred items from the 2026-05-13 handoff are now landed. All three were executed via the new `improve-skills TARGET=<skill> SKIP_RESEARCH=true` path — the first real use of the targeted-improvement entry point shipped two days ago.

## Summary

| # | Item | Outcome |
|---|------|---------|
| 1 | `reality-check` 255-line violation | 255 → 189 lines via extraction to `references/deliverable-templates.md` |
| 2 | ADL synthesis-mode idiom alignment | `architectural-decision-log` v1.1 gained `SYNTHESIS=true` mode parallel to `project-setup`'s `RETROACTIVE=true` |
| 3 | Producer-skill checkpoint enforcement | `validate-skills` v1.1 gained Step 4c audit + structural flag for "Missing memory-checkpoint registration" |

## Item 1 — `reality-check` Compression

**Problem.** `reality-check/SKILL.md` was 255 lines, breaching the 200-line invariant. Pre-existing violation surfaced during the 2026-05-13 audit.

**Approach.** Per `improve-skills` Step 2j, when over 200 the first option is extraction, not compression. The Step 8 deliverable templates (Findings Report + Roadmap markdown, ~50 lines) are pure FORMAT content with no per-invocation variance — perfect extraction candidate. Moved them to `references/deliverable-templates.md` with a specific load trigger ("Load this file during Step 8 when writing the two output documents"). Also tightened Step 0 (three Q&A bullets → one prose line) and the Step 6 example (verbose claim assessment → essentials only).

**Result.** 255 → 189 lines. `references/deliverable-templates.md` (79 lines, new) carries the templates and SKILL-OUTPUTS row format. Loader is well under budget. Version bumped to 1.2.

## Item 2 — ADL `SYNTHESIS=true` Mode

**Problem.** `retroactive-project-setup` calls `architectural-decision-log` to write ADR-0001 from inferred repo state, but ADL itself had no named mode for this — the inference work was implicit, marked only by a free-form "title note". `project-setup` already exposes a named `RETROACTIVE=true` mode for the parallel inference work; the two skills used different vocabularies for the same conceptual operation.

**Approach.** Added a "Modes" section to ADL with two named modes:
- **`INTERACTIVE`** (default) — contemporaneous capture with live interview (Step 2 asks 1–2 questions).
- **`SYNTHESIS`** — retrospective capture. Skips the Step 2 interview, reads rationale off the codebase (Context from README + manifests + commits; Alternatives from "what other tools in this category exist?" with `[INFERRED]` tags + code-supported rejection reasons; Consequences from observed code shape). Writes `Status: Accepted (retrospective)` and MUST append "Decisions inferred from repo state as of YYYY-MM-DD; not contemporaneous" to Context.

The 2-alternatives Hard Rule still applies in SYNTHESIS mode — but each alternative may be marked `[INFERRED]`. A new Gotcha makes the inference-tagging requirement explicit ("`SYNTHESIS` mode is honest, not confident — removing the tags to make the ADR look cleaner turns the file into a confabulation hazard").

`retroactive-project-setup` Step 5.3 now invokes `architectural-decision-log SYNTHESIS=true` by name rather than relying on a free-form title to imply the mode. Idiom now parallel to Step 5.4's `project-setup RETROACTIVE=true`.

**Result.** ADL: 132 → 148 lines (v1.0 → v1.1). Retroactive-project-setup unchanged at 188 lines.

## Item 3 — `validate-skills` Producer-Skill Checkpoint Flag

**Problem.** The Mandatory Auto-Trigger Checkpoint rules in `memory/SKILL.md` (changelog → `memory-capture`, ADR → `memory-decision`, spec/plan/PRD → `memory-capture`, skill creation → `memory-capture`, session end → `memory-handoff`) lived as written instructions in two places (`AGENTS.md` Session Lifecycle block + `memory/SKILL.md` registry) but nothing automated detected when a new producer skill was added without registering its checkpoint. Rule survived only by human attention.

**Approach.** Added a new **Step 4c — Producer-Skill Checkpoint Audit** to `validate-skills` workflow:

1. Read `memory/SKILL.md` once to learn the canonical event → sub-skill map.
2. Classify each skill as a "producer" if any of: (a) writes to a producer-output directory (`docs/changelogs/`, `docs/adr/`, `docs/specs/`, `docs/plans/`, `docs/prd/`, `docs/memory/`, or generates a SKILL.md), (b) description names a producer artifact, (c) appears in the registry's trigger column.
3. Grep each producer's workflow for an invocation of the matching memory sub-skill.
4. Absent → raise structural flag "Missing memory-checkpoint registration" with the specific event + missing sub-skill.

Mirrored as a new row in `references/validation-rubric.md` so the rule has a single source of truth alongside the other frontmatter checks.

**Result.** `validate-skills`: 199 → 196 lines (v1.0 → v1.1). 3 lines net saved by tightening the Step 6 report-template example to compensate for the new step. Rubric updated.

## Cross-Refs Updated

- `docs/SKILL-INDEX.md` — entries for `validate-skills`, `architectural-decision-log`, `reality-check` updated; call graph mentions `SYNTHESIS=true` invocation explicitly.
- `README.md` — meta-skills table rows for the three changed skills.
- `docs/skill-graph.md` — caption on `rps → adl` / `rps → psu` edges noting `SYNTHESIS=true` / `RETROACTIVE=true`; two new "Reading the Graph" bullets ("Retroactive backfill", "Self-enforcing checkpoints"); date bumped to 2026-05-14.
- `docs/skill-outputs/SKILL-OUTPUTS.md` — 10 rows appended.

## Migration

No breaking changes. All three are additive:
- Existing reality-check invocations continue to work — Step 8 loads the new reference file on demand.
- ADL `INTERACTIVE` mode is the default and unchanged.
- `validate-skills` Step 4c is purely additive — no existing skill loses any check; current producer skills (`generate-changelog`, `architectural-decision-log`, `feature-spec`, `implementation-plan`, `prd-writing`, `universal-skill-creator`) already have checkpoint registrations and will pass the new flag immediately.

## Verification

```
.agents/skills/reality-check/SKILL.md                189 lines  (≤ 200 ✓)
.agents/skills/reality-check/references/...          79 lines   (new)
.agents/skills/architectural-decision-log/SKILL.md   148 lines  (≤ 200 ✓)
.agents/skills/retroactive-project-setup/SKILL.md    188 lines  (≤ 200 ✓)
.agents/skills/validate-skills/SKILL.md              196 lines  (≤ 200 ✓)
.agents/skills/validate-skills/references/...        124 lines  (rubric)
```

## Notes

- This is the first real test of the `improve-skills TARGET=<skill> SKIP_RESEARCH=true` path shipped on 2026-05-13. It worked end-to-end for all three items without escalation back to `FULL_PASS`.
- `agentskills validate` CLI remains unavailable in this environment — structural checks were manual (line counts, frontmatter loader-safety, reference cross-checks).
