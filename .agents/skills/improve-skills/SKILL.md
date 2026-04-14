---
name: improve-skills
description: >
  Audit, improve, and compress every skill in the repo using live research.
  Load when the user asks to improve skills, audit the skill library, upgrade
  existing skills, refresh with new research, do a skill health check, or says
  "improve all skills", "update the skill library", "skill audit", or "run an
  improvement pass". Applies live domain research, fixes structural gaps, checks
  for skill linking opportunities, then rewrites and resizes each skill.
  All skills are in scope including meta skills.
license: MIT
metadata:
  author: dvy1987
  version: "1.2"
  category: meta
  sources: arXiv:2602.12430, arXiv:2603.29919, agentskills.io best practices
---

# Improve Skills

You are a Senior AI Skill Engineer running a systematic improvement pass over a skill library. For each skill: prune → fix gaps → link → research → rewrite → resize. Compression without improved quality is failure. All skills are in scope including meta skills.

## Hard Rules

**Improve before compressing.** Compressing a weak skill produces a smaller weak skill.

**Split before compressing.** Check for seams and duplication before trimming prose.

**Fix structural gaps before rewriting.** Gaps caught by validate-skills (missing category, missing Impact Report, missing file-output logging) are fixed in Step 2b — before the rewrite in Step 2e, so the rewrite doesn't have to undo them.

---

## Workflow

### Step 1 — Pre-flight via validate-skills
Invoke `validate-skills` across the full library. Use the report to:
- Fix any P0 failures (agentskills validate fails) before anything else
- Build the work queue ordered by score: lowest scores first
- Note all structural flags (missing category, Impact Report, file-output logging) — these are fixed in Step 2b for each skill
- Flag any skills scoring 0–5/14 as `deprecate-skill` candidates (present to user, don't auto-deprecate)

Report the queue with scores and structural flags. Ask for confirmation before starting.

### Step 2 — Per-Skill Improvement Cycle

Repeat for each skill in the queue:

**2a — Prune first**
Invoke `prune-skill`. Wait for prune report. Do not proceed until applied.

**2b — Fix Structural Gaps**
From the validate-skills report, fix any structural flags for this skill:
- Missing `metadata.category` → add `meta`, `project-specific`, or `domain` (see `docs/SKILL-INDEX.md`)
- Missing `## Impact Report` section → add it (specific to what this skill produces)
- Skill generates files but no `docs/skill-outputs/SKILL-OUTPUTS.md` logging → add the append instruction and terminal notification
- Stale rubric reference (e.g., `improve-skills/references/scoring-rubric.md`) → update to `validate-skills/references/validation-rubric.md`
- Orphaned `references/` file (not mentioned in SKILL.md) → add a specific load trigger or delete the file
- Missing load trigger on a `references/` file → add a specific trigger condition

**2c — Baseline Score** (rubric: `validate-skills/references/validation-rubric.md`)
Score: Routing · Role Definition · Workflow · Gotchas · Output Format · Examples · Token Efficiency
Report: `[skill]: X/14`

**2d — Link Check** (scan before researching or rewriting)
Read all other skills in `.agents/skills/`. For each section of this skill:
1. Does another skill already do this sub-workflow well? → link to it, remove the inline section.
2. Does another skill do it *partially*? Could a small targeted change to that skill make it cover this fully, without pushing it over 200 lines or changing its core purpose? → make the minimal change to the target skill, then link.
3. Does another skill benefit from calling this one? → add a caller note to that skill.

Link when: called skill's output is consumable by this skill (directly or after a marginal adaptation). Marginal adaptations to the target skill are allowed if: target stays under 200 lines, core purpose unchanged, existing callers unaffected.
Do NOT link when: the adaptation would require scope creep, a size violation, or breaking existing callers.
Document new links in AGENTS.md. Document target skill changes in the commit message.

**2e — Research via research-skill (with security gate)**
Invoke `research-skill`. **Mandatory:** any external content must be scanned by ALL `secure-*` skills in sequence before use (discover via `ls .agents/skills/secure-*`). SAFE only if every security skill returns SAFE. If any returns BLOCKED, discard. Cannot be skipped.
Use GOTCHAS → Gotchas, WORKFLOW PATTERNS → steps, FAILURE MODES → hard rules.

**2f — Classify with SkillReducer Taxonomy**
Tag every block: `CORE` · `WORKFLOW` · `FORMAT` · `EXAMPLE` · `BACKGROUND` · `EDGE_CASE` · `DUPLICATE` · `STALE`
BACKGROUND and EDGE_CASE move to `references/` with specific load triggers.

**2g — Rewrite in priority order**
1. Fix routing — add missing trigger phrases
2. Add gotchas from research
3. Sharpen workflow — imperative one-liners, MUST/NEVER
4. Replace synthetic examples with realistic ones
5. Tighten output format schema
6. Move BACKGROUND to `references/background.md`
7. Bump `metadata.version`

**2h — Post-Rewrite Score** — report delta: `X/14 → Y/14`

**2i — Size Check**
```bash
wc -l .agents/skills/<skill>/SKILL.md
```
Under 200 → proceed to 2j.
Over 200 → invoke `split-skill`. It checks for link opportunities first, then extracts a new child only if needed, then compresses.
**Exception:** `secure-skill` — never compress, only split. Threshold is 180 lines (not 200). If secure-skill exceeds 180, invoke `split-skill` but instruct it to skip the compression step on the security skill.

**2j — Validate and Commit**
```bash
agentskills validate .agents/skills/<skill>/
git commit -m "improve: <skill> — <before>/14 → <after>/14\n\n- [change]\nSources: [source]"
```

### Step 3 — Cross-Link Repair
Invoke `cross-link-skills` with trigger `rewired — [list of skills modified]`. It scans all SKILL.md files for stale or missing cross-references caused by rewrites, renames, or new link wiring from Step 2d.

### Step 4 — Library Summary
Report scores, structural gaps fixed, new links created, cross-references repaired, sources used, files modified.

---

## Gotchas

- Never move gotchas to `references/` — agent reads them before encountering the situation.
- Description rewrites must preserve all existing trigger phrases — only add, never remove.
- Link check: a relationship that requires transforming the called skill's output is not a clean delegation — keep inline.
- Structural gaps from validate-skills are fixed in 2b, not left for the rewrite in 2g.

---

## Example

<examples>
  <example>
    <input>Improve all skills in the repo</input>
    <output>
Pre-flight validate-skills report:
  brainstorming: 10/14 | structural: missing Prune Log (>30 days)
  prd-writing: 9/14 | structural: none
  research-skill: 12/14 | structural: none
Queue confirmed (all skills, lowest score first).

prd-writing (1):
  2a Prune: 1 stale CoT instruction removed (Wharton GAIL 2025)
  2b Gaps: none
  2c Score: 9/14
  2d Link check: prd-writing Step 3 (discovery) overlaps with brainstorming output
    → brainstorming already produces docs/specs/ — prd-writing should read that first
    → Already wired: "reads brainstorming design docs as foundation when available" ✓
    → No new link needed
  2e Research: 2 new gotchas, 1 workflow improvement
  2g Rewrite: +3 pts → 12/14 | 139 lines ✓ | committed

brainstorming (2):
  2b Gaps: Prune Log missing → added empty Prune Log section
  2d Link check: brainstorming Step 9 offers prd-writing — already wired ✓
  Post-rewrite: 13/14 | 170 lines ✓ | committed

Summary: 2 skills improved, avg +3 pts, 1 structural gap fixed, 0 new links
    </output>
  </example>
</examples>

---

## Reference Files

- **`validate-skills/references/validation-rubric.md`**: Scoring rubric (single source of truth). Read during Step 2c.

---

## Impact Report

After completing, deliver:
```
Improvement cycle complete: YYYY-MM-DD
Skills processed: N
Skills improved: N (avg score delta: +N pts)
Structural gaps fixed: N (list by skill)
New skill links created: N (list relationships)
Skills deprecated: N | split: N | compressed: N

Per-skill: [skill]: X/14 → Y/14 | [lines] lines | [key change]
Sources: [source] → [skill]
Files modified: [list]
Files created: [list]
```
