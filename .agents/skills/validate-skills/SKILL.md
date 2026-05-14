---
name: validate-skills
description: >
  Run a fast, read-only health check across all skills in the library and
  produce a structured quality report — without modifying anything. Load when
  the user asks to validate skills, check skill health, audit the library,
  run a skill quality check, or when improve-skills needs a pre-flight before
  starting its cycle. Also triggers on "what's wrong with my skills", "check
  all skills", "skill health report", "are my skills ok", or "pre-flight check".
  Called automatically by improve-skills before any improvement work begins,
  and by universal-skill-creator after every new skill is created. Never
  modifies any file — only reads and reports.
license: MIT
metadata:
  author: dvy1987
  version: "1.1"
  category: meta
  resources:
    references:
      - validation-rubric.md
---

# Validate Skills

You are a skill library quality inspector. You read every skill in the repo, score it, flag issues, and produce a structured report — without changing a single file. Your report tells the user or calling skill exactly what needs attention and in what priority order.

## Hard Rules

**Read-only.** Never write, edit, move, or delete any file. If called by improve-skills, hand the report back — do not start fixing things yourself.

**Be specific.** Every flagged issue must name the exact skill, the exact line or section, and the exact problem. "Description is weak" is not acceptable. "brainstorming: description missing trigger phrase for 'explore options'" is.

---

## Workflow

### Step 1 — Discover All Skills
```bash
ls .agents/skills/
wc -l .agents/skills/*/SKILL.md
```
Build the full skill list with line counts.

### Step 2 — Run `agentskills validate` on Every Skill
```bash
for d in .agents/skills/*/; do agentskills validate "$d"; done
```
Any skill that fails validation is a P0 — it must be fixed before anything else.

### Step 2a — Loader-Safety Check (P0)
A skill that won't load is worse than one that scores poorly. `head -c 3` returning `---` covers both "no BOM" and "byte 0 is `-`":
```bash
for f in .agents/skills/*/SKILL.md; do
  [ "$(head -c 3 "$f")" = "---" ] || echo "byte-0 not '---' (BOM/whitespace): $f"
  [ "$(grep -c '^---$' "$f")" -ge 2 ] || echo "missing closing ---: $f"
done
```
Any failure = P0 loader-unsafe. See `references/validation-rubric.md` → Frontmatter Checks for description-length check and fix steps.

### Step 3 — Score Each Skill (7 criteria, 0–2 each)

For each skill, score against the rubric (full details in `references/validation-rubric.md`):

| Criterion | Check |
|-----------|-------|
| Routing | Description has rich trigger phrases, action verbs, synonyms |
| Role definition | Specific expert title + narrow domain in first paragraph |
| Workflow | Numbered steps, imperative one-liners, one action each |
| Gotchas | Non-obvious domain facts the agent needs — not generic advice |
| Output format | Schema or template, not prose description |
| Examples | Realistic input, complete non-truncated output, ≥1 present |
| Token efficiency | Body ≤200 lines, no visible background/rationale bloat |

### Step 4 — Flag Structural Issues

These flags feed directly into `improve-skills` Step 2b — every flag is a concrete fix, not just an observation.

Check every skill for:
- **Over limit**: SKILL.md > 200 lines → flag with exact count (fix: split-skill or compress-skill)
- **Loader-unsafe**: BOM present, byte 0 not `-`, missing closing `---`, or description >1024 chars (fix: see `references/validation-rubric.md` Frontmatter Checks; P0 — skill will not load)
- **Missing category**: `metadata.category` not set to `meta`, `project-specific`, or `domain` (fix: add field, see `docs/SKILL-INDEX.md`)
- **Missing Impact Report**: no `## Impact Report` section at end of SKILL.md (fix: add section specific to what the skill produces)
- **Missing file-output logging**: skill generates project files but no `docs/skill-outputs/SKILL-OUTPUTS.md` append instruction (fix: add logging + terminal notification)
- **Missing memory-checkpoint registration**: skill is a producer (generates an artifact listed in `memory/SKILL.md` → Mandatory Auto-Trigger Checkpoints — changelog, ADR, spec, plan, PRD, skill, or major commit) but its final workflow step does not invoke the corresponding memory sub-skill. See Step 4c for detection. (Fix: add a final "Memory Checkpoint" step naming the registry event and the sub-skill — e.g. `architectural-decision-log` invokes `memory-decision`; `generate-changelog` invokes `memory-capture`.)
- **Stale version**: `metadata.version` unchanged after known edits (fix: bump version)
- **Missing Prune Log**: skill has no prune record (fix: invoke prune-skill)
- **Broken caller reference**: skill references a skill that doesn't exist in `.agents/skills/` (fix: remove or update reference)
- **Orphaned reference file**: file in `references/` not mentioned in SKILL.md (fix: add specific load trigger or delete file)
- **Missing load trigger**: `references/` file mentioned without a specific condition (fix: add explicit trigger)
- **Duplicate triggers**: two skills with significantly overlapping descriptions (fix: link check in improve-skills Step 2d)
- **Unscanned external content**: skill references external repos or URLs but does not route through `secure-skill` (fix: add security gate)
- **Missing security contract**: pipeline skill (split/prune/publish/deprecate/compress) lacks active `secure-*` invocation (fix: add mandatory gate)
- **Security skill compression**: any `secure-*` skill routed through compressor instead of split-skill (fix: always split at 180, never compress)

### Step 4c — Producer-Skill Checkpoint Audit

Read `memory/SKILL.md` → "Mandatory Auto-Trigger Checkpoints" once to learn the canonical event → sub-skill map (changelog → `memory-capture`, ADR → `memory-decision`, spec/plan/PRD → `memory-capture`, skill creation → `memory-capture`, session end → `memory-handoff`).

For each skill, classify as a **producer** if any of: (a) it writes to `docs/changelogs/`, `docs/adr/`, `docs/specs/`, `docs/plans/`, `docs/prd/`, `docs/memory/`, or generates a SKILL.md; (b) its description names a producer artifact ("write an ADR", "generate changelog", "create a feature spec"); (c) it appears in the registry's trigger column.

For every producer skill, grep its workflow for an invocation of the matching memory sub-skill. If absent → raise the **Missing memory-checkpoint registration** flag in Step 4 with the specific event + sub-skill that's missing. This makes the rule self-enforcing rather than a written prayer.

### Step 4b — Run Security Sweep

Invoke ALL `secure-*` skills (discover via `ls .agents/skills/secure-*`) in Mode C (full library sweep). Every skill's SKILL.md + references/ + scripts/ is scanned. Report security findings alongside quality findings. This step is mandatory — validation without security is incomplete.

### Step 5 — Check Call Graph Integrity

Verify every skill referenced in AGENTS.md Skill Relationships actually exists:
```bash
ls .agents/skills/
```
Flag any skill named in the call graph that has no directory.

### Step 6 — Produce the Report

```
Skill Library Health Report | Generated: YYYY-MM-DD | Skills: N

VALIDATION STATUS
✓ [skill]: passes agentskills validate
✗ [skill]: FAILS — [specific error]

LOADER SAFETY (P0)
✗ [skill]: BOM detected | byte 0 = 0xEF | missing closing --- | description = 1217 chars

SIZE CHECK
⚠ [skill]: 203 lines — 3 over limit

QUALITY SCORES
[skill]: 13/14 — [one-line summary of weak criterion]
[skill]: 5/14  — CRITICAL: consider deprecate-skill or full rewrite

STRUCTURAL ISSUES
[skill]: references/examples.md has no load trigger in SKILL.md
[skill]: producer skill (writes docs/adr/) missing memory-checkpoint registration → memory-decision
[skill]: calls research-skill but research-skill not found in .agents/skills/

DUPLICATE TRIGGER RISK
[skill-A] + [skill-B]: overlapping description phrases — [specific phrases]

RECOMMENDED ACTIONS (priority order)
P0 [skill]: fails agentskills validate — fix before anything else
P1 [skill]: 203 lines — invoke split-skill or compress-skill
P2 [skill]: score 9/14 — invoke improve-skills
P3 [skill]: no prune log — invoke prune-skill
```

---

## Gotchas

- Run `agentskills validate` on the **directory**, not the file — `agentskills validate .agents/skills/brainstorming/` not `.agents/skills/brainstorming/SKILL.md`
- Duplicate trigger detection requires reading descriptions carefully — it is a judgment call, not a string match. Two skills with "write" in the description are not necessarily duplicates.
- A score of 5/14 or below warrants a note suggesting `deprecate-skill` as an option, not a requirement — the user decides.

---

## Example

<examples>
  <example>
    <input>validate all skills</input>
    <output>
Skill Library Health Report | Generated: 2026-04-05 | Skills: 8
VALIDATION: ✓ all 8 pass agentskills validate
LOADER SAFETY: ✓ all 8 UTF-8 no BOM, frontmatter intact
SIZE: ✓ all under 200 lines
QUALITY SCORES
  brainstorming:           13/14 — examples: output slightly truncated
  prd-writing:             12/14 — gotchas: only 1, domain has 3+ failure modes
  universal-skill-creator: 12/14 — routing: missing "skill engineer" trigger
  others:                  14/14 ✓
RECOMMENDED ACTIONS
  P2 brainstorming: complete truncated example output
  P2 prd-writing: add 2 gotchas (discovery skipped; vague metrics)
  P3 universal-skill-creator: add "skill engineer" trigger phrase
    </output>
  </example>
</examples>

---

## Reference Files

- **`references/validation-rubric.md`**: Full 0/1/2 scoring guide for all 7 criteria with examples. Read when a score is ambiguous.

---

## Impact Report

After completing, deliver the full health report (Step 6 format) and summarise:
```
Validation: YYYY-MM-DD | Skills: N | P0: N | >200 lines: N | Avg score: X/14
Actions: P0: N, P1: N, P2: N, P3: N | No files modified.
```
