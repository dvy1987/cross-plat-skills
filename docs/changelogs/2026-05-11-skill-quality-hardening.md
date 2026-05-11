# Changelog: Skill-Quality Hardening Pass

**Date:** 2026-05-11
**Type:** Library hardening — 1 new invariant, 7 skills upgraded with battle-tested Gotchas, 1 naming-clarity rename
**Bar to beat:** The previous release shipped a 5-skill suite (`venture-exploration`). This release makes sure that *next* time the library grows by 5 skills, none of them silently drift.

---

## Why this matters (the value prop in one sentence)

**The last release added new capability; this release makes the existing capability harder to break.** Every change here closes a specific failure mode we've actually seen — agents writing SKILL.md outside `universal-skill-creator` and skipping validation, "significant" creeping into underpowered experiment readouts, exposure events firing at flag-fetch instead of variant-render, compressed skills silently losing their hard gates, and `setup-evaluator` (an agent) being confused with `setup-evaluation` (a skill) in routing.

If you upgraded the library yesterday for *more skills*, you should pull today for *more trustworthy skills*.

---

## What Changed

### 1. New mandatory invariant — Skill Creation Invariant (AGENTS.md)

**The single biggest change in this release.** A new top-level section in `AGENTS.md` makes it a hard rule that **no agent may write `.agents/skills/<name>/SKILL.md` directly** — every skill creation must route through `universal-skill-creator` so the Step 8 quality chain (`validate-skills` → `skill-deconflict` → `library-skill`, optional `publish-skill`) fires automatically.

Why this exists: agents were bypassing the creator after a planning phase ("I already designed it, I'll just write the file"), or when the user said *"go ahead build"* / *"build the suite"* / *"ship the skills"* instead of the canonical *"create a skill"*. Bypassing skips deconfliction, validation, cross-link repair, and library-doc updates — every bypass rots the library a little.

The invariant explicitly covers the four most common rationalisations:
- The agent has already done the research / planning manually
- The user said "go ahead build" instead of "create a skill"
- Multiple skills are being built in one batch
- The skill body feels obvious or "already designed"

**Enforcement:** if a SKILL.md write is detected outside `universal-skill-creator`, the agent must stop and re-route.

### 2. `universal-skill-creator` v2.1 → v2.2

Two changes that lock in the new invariant:

- **Description triggers expanded** to cover every plural / suite / batch / go-ahead phrasing: `"build all skills"`, `"build N skills"`, `"build the planned skills"`, `"build the suite"`, `"implement the suite"`, `"ship the skills"`, `"create these skills"`, `"go ahead build"`, `"go ahead create"`, `"make all of them"`, `"build them all"`, `"now build it"`. There is no longer ambiguity for routing to ignore.
- **New Gotchas section (7 entries)** — the hard-won failure modes:
  - Never write SKILL.md outside this skill (mirrors the AGENTS.md invariant)
  - `secure-*` gating runs **twice** — Step 2 on inputs, Step 9 on the generated skill
  - Description triggers must be **additive, never replace** when iterating on existing skills
  - `metadata.category` must be one of `meta | thinking | project-specific | domain` — `thinking` is valid even though it's not in the high-level category table
  - `resources` field must list every reference / script / template — missing entries are invisible to the orchestrator
  - **Atomic tier first**, promote on demand — no premature `references/` or `scripts/` bloat
  - Skill name MUST exactly match directory — silent break of every cross-link otherwise

### 3. `compress-skill` Gotchas section added (6 entries)

Compression was the second-most common source of regressions — agents shaving lines without understanding which lines were load-bearing. The new Gotchas codify the rules:

- **`secure-*` skills are uncompressable** — threshold is 180 lines and the only allowed action is `split-skill`. Compression silently removes threat coverage.
- **Description compression loses triggers silently** — must test compressed description against ≥3 sample prompts that activated the original.
- **"Move to references/" without a load trigger is invisible** — every referenced file MUST be referenced from SKILL.md with a specific load condition.
- **Imperative one-liners ≠ removing context** — preserve numbers, thresholds, and MUST/NEVER verbs. *"Ask at least 2 clarifying questions before writing the spec"* must not become *"Ask questions"*.
- **A 200-line skill that lost a hard gate is worse than a 220-line skill that kept it** — when in doubt, restore content and invoke `split-skill` instead.
- **LLM-already-knows is a judgment call** — default to keeping; only delete when unambiguously generic.

### 4. Experimentation suite — Gotchas baked in across all 5 skills

Every skill in the experimentation suite now carries a Gotchas section that encodes the experimental-rigour failure modes most teams hit at least once. This is the single most rigour-shifting change of the release: it bakes "what makes an experiment trustworthy" directly into the skill prompts so the agent will challenge the user (and itself) before launch and during readout.

**`experimentation` (orchestrator) — 6 gotchas:**
- A/B is not the universal answer — persistent treatments / lifecycle email / recommendations default to **holdouts**; marketplaces / feeds default to **switchbacks**; SEO / content default to **quasi-experiments**
- Decision class declared up front, never retrofitted — Directional cannot become "Causal" because the lift looked nice
- The orchestrator never analyses results itself — always route to `experiment-readout`
- Skipping a stage requires a recorded justification (silent skips break the learnings log)
- Funnel-ROI map is a default, not a rule — validate against the user's stage
- `reality-check` integration is one-way — return artefact paths, never modify the claim ledger

**`experiment-backlog` — 6 gotchas:**
- Feasibility is a binary gate, not an ICE multiplier
- ICE inflation — anchor scoring against past wins where lift size is known
- Retention A/Bs without a holdout are fake
- Don't replace `backlog.md` — append (lifecycle history is load-bearing for `experiment-readout` learnings)
- Population stability is invisible until it bites — schedule around marketing / seasonal windows
- "Quick wins" are usually retention or referral A/Bs that fail feasibility — be willing to push back

**`experiment-spec` — 7 gotchas:**
- **MDE is relative, not absolute** — "5% lift" almost always means 5% relative to baseline; missing the unit is the #1 source of post-launch sample-size surprise
- **The if-clause IS the spec** — without "if it does, we will [decision]", it's an aspiration, not a falsifiable spec
- Exposure event ≠ flag fetch
- Duration must cover whole-week multiples to absorb day-of-week effects
- B2B / account-level treatments need group randomisation
- Counter-metric is mandatory for optimisation tests (conversion ↑ with refund-rate ↑ is a loss)
- MAB only when there's no ship/kill decision — bandits optimise allocation, not learning

**`experiment-runbook` — 7 gotchas:**
- Exposure event must fire when the variant **renders**, not when the flag is **fetched**
- `$feature_flag_called` is PostHog's exposure event — custom events without `$feature_flag` / `$feature_flag_response` properties are invisible to the experiment UI
- Person-property assignment for B2B accounts is wrong — use group-property
- Salt the hash and lock it — drifting salts re-randomise mid-test and destroy causal inference
- Bot / internal traffic must be filtered at the cohort level, not in analysis
- A 1% ramp without an SRM dry-run is just a slow launch
- Holdout cohort flags must be permanent, not per-test

**`experiment-readout` — 7 gotchas:**
- **SRM is the silent killer of trust** — a failed SRM invalidates everything downstream; phantom wins almost always trace to broken randomisation
- **"Significant" is forbidden vocabulary for Directional and Instrumentation tests** — strip it from every readout that wasn't pre-declared Causal with adequate power
- CI excluding zero ≠ a "win" if a guardrail breached — decision rule is conjunctive
- Exposure-parity gaps point at instrumentation, not user behaviour
- Novelty effects vanish from short tests — flag for Phase-2 holdout monitoring
- **Append to learnings even on SRM-fails and inconclusives** — skipping failed tests builds survivorship bias
- Pre-registered metrics only as headlines — post-hoc findings are tagged `EXPLORATORY`, never the ship justification

### 5. Naming-clarity rename — `setup-evaluator` → `setup-evaluation`

`agent-builder` and `project-orchestrator` were referencing `setup-evaluator` (the agent) where they meant `setup-evaluation` (the skill). The skill name is now used consistently in cross-references, with a one-line note that the skill *runs from* the `setup-evaluator` agent for independence. Removes a recurring source of "skill not found" routing errors when `agent-builder` finishes an `agent-chain` decomposition.

### 6. Library docs refreshed

- **`README.md`** — added the full Venture Exploration Suite table (all 5 skills with output paths and trigger phrases)
- **`docs/SKILL-INDEX.md`** — venture-exploration suite indexed with call graph + categorisation
- **`docs/skill-graph.md`** — venture-exploration nodes wired into the graph (and pre-decision → committed handoff edge)
- **`docs/skill-outputs/SKILL-OUTPUTS.md`** — venture-exploration output paths registered (`docs/ventures/ideas/`, `docs/ventures/models/`, `docs/ventures/evaluations/`, `docs/ventures/discovery/`)
- **`AGENTS.md`** — venture-exploration entry-point triggers added to the user routing table

---

## Why each change in plain language

| Change | What it stops happening |
|---|---|
| Skill Creation Invariant | Agents writing SKILL.md directly and skipping validation / deconflict / cross-link / library updates |
| `universal-skill-creator` v2.2 triggers | "build the suite" / "go ahead build" routing past the creator after a planning phase |
| `universal-skill-creator` Gotchas | New skills shipping with category mismatches, missing `resources` entries, deleted triggers, premature `references/` bloat |
| `compress-skill` Gotchas | Compressed skills losing hard gates, dropped triggers, and uncited references — and `secure-*` skills being compressed at all |
| Experimentation suite Gotchas | Wrong method (A/B where holdout was needed), MDE confusion (relative vs absolute), exposure-event-at-fetch bugs, retrofitted "Causal" claims, ignored SRM failures, post-hoc significance theatre |
| `setup-evaluator` → `setup-evaluation` | "Skill not found" routing errors after `agent-builder` finishes an agent-chain decomposition |

---

## Stats

```
Files modified                                   14
Skills hardened with Gotchas sections             7  (universal-skill-creator, compress-skill,
                                                       experimentation, experiment-backlog,
                                                       experiment-spec, experiment-runbook,
                                                       experiment-readout)
New AGENTS.md invariant                           1  (Skill Creation Invariant)
Skill version bumps                               1  (universal-skill-creator: 2.1 → 2.2)
Cross-reference renames                           2  (setup-evaluator → setup-evaluation in
                                                       agent-builder, project-orchestrator)
Total Gotchas added                              46  (across the 7 hardened skills)
Net diff                                       +242 / −9
Skills still ≤200 lines after Gotchas added     7/7  (hard rule preserved)
```

---

## Compatibility / Migration

**No breaking changes.** Existing skills continue to work; existing changelogs and outputs remain valid. Two consequences for agents:

1. **Agents will now refuse to write SKILL.md directly** — if you have a workflow that bypasses `universal-skill-creator`, it will be re-routed. This is intentional. The fix is to invoke the creator with the same brief.
2. **`setup-evaluator` references in any user-authored docs should be updated to `setup-evaluation`** when referring to the skill. The agent name (`setup-evaluator`) is unchanged.

---

## What this release does *not* do

To set expectations honestly:
- No new skill *capability* added — this is a quality / rigour pass, not a feature pass.
- No changes to `secure-*` skills (those changes require human-authored commits per `AGENTS.md` policy).
- No installer or uninstaller changes — the install surface is unchanged.
- The Skill Creation Invariant is enforced by agent behaviour and prompt-level rules, not by a pre-commit hook. A human writing a SKILL.md by hand is still allowed; the rule binds *agents*.

---

## Why this is the right size of release

The previous changelog (`2026-05-05-venture-exploration-suite.md`) was a *capability* release: 5 new skills, 14 reference files, ~1000 SKILL.md lines, a new `docs/ventures/` tree. That's the kind of release where breakage rides in unnoticed — broken cross-links, premature `references/` bloat, missing trigger phrases, skipped validation gates.

This release is the deliberate *follow-up* — the discipline pass that makes sure the next capability release lands on a foundation that doesn't quietly degrade. It costs nothing to install and pays for itself the first time an agent tries to write SKILL.md directly, the first time an experiment readout gets challenged on its SRM check, or the first time `compress-skill` is asked to shave a `secure-*` skill.
