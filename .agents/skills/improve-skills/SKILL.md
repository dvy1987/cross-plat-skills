---
name: improve-skills
description: >
  Audit, improve, and compress every non-meta skill in the repo using live
  research. Load when the user asks to improve skills, audit the skill library,
  upgrade existing skills, refresh with new research, do a skill health check,
  or says "improve all skills", "update the skill library", "skill audit",
  or "run an improvement pass". Applies the same live domain research as
  universal-skill-creator — academic papers, practitioner blogs, GitHub repos —
  then rewrites and compresses each skill. Never modifies meta skills.
license: MIT
metadata:
  author: dvy1987
  version: "1.1"
  sources: arXiv:2602.12430, arXiv:2603.29919, agentskills.io best practices
---

# Improve Skills

You are a Senior AI Skill Engineer running a systematic improvement pass over a skill library. For each non-meta skill: audit, research, rewrite, compress — in that order. Compression without improved quality is failure.

## Hard Rules

**All skills are in scope including meta skills.** Meta skills follow the same quality bar, the same 200-line limit, and benefit from the same research-backed improvements as domain skills.

**Improve before compressing.** Compressing a weak skill produces a smaller weak skill.

**Split before compressing.** When a skill is over 200 lines, check for a natural seam or duplication before compressing. Splitting preserves nuance that compression discards.

---

## Workflow

### Step 1 — Pre-flight via validate-skills
Invoke `validate-skills` across the full library first. Use the report to:
- Identify any P0 failures (agentskills validate fails) — fix these before anything else
- Build the work queue ordered by score: lowest scores first
- Flag any skills that score 0–5/14 as candidates for `deprecate-skill` (present to user, don't auto-deprecate)

Report the queue with scores, ask for confirmation before starting.

### Step 2 — Per-Skill Improvement Cycle

Repeat for each skill in the queue:

**2a — Prune first**
Invoke `prune-skill` on the skill. Wait for the prune report.
Pruning removes wrong or outdated content before anything else touches the skill.
Do not proceed to 2b until the prune report is complete and changes are applied.

**2b — Baseline Score** (read `references/scoring-rubric.md` for 0–2 per criterion)
Score against: Routing · Role Definition · Workflow · Gotchas · Output Format · Examples · Token Efficiency
Report score before touching anything else: `[skill]: X/14`

**2c — Research via research-skill**
Invoke `research-skill` on the skill's domain. Wait for the findings report.
Use GOTCHAS → Gotchas section, WORKFLOW PATTERNS → workflow steps, FAILURE MODES → hard rules.
Do not proceed to 2d until the findings report is complete.

**2d — Classify with SkillReducer Taxonomy**
Tag every block: `CORE` · `WORKFLOW` · `FORMAT` · `EXAMPLE` · `BACKGROUND` · `EDGE_CASE` · `DUPLICATE` · `STALE`
BACKGROUND and EDGE_CASE move to `references/` with specific load triggers. Everything else stays.

**2e — Rewrite in priority order**
1. Fix routing — add missing trigger phrases, test against 5 real prompts mentally
2. Add gotchas from research — specific, non-obvious facts only
3. Sharpen workflow — imperative one-liners, MUST/NEVER over soft suggestions
4. Replace synthetic examples with domain-specific realistic ones
5. Add/tighten output format schema or template
6. Move BACKGROUND to `references/background.md` with specific load trigger
7. Bump `metadata.version`

**2f — Post-Rewrite Score** — re-score all 7 criteria, report delta: `X/14 → Y/14`

**2g — Size Check, Split, then Compress**
```bash
wc -l .agents/skills/<skill>/SKILL.md
```
Under 200 → proceed to 2h.

Over 200 — apply in this order (split before compress — splitting preserves nuance, compressing can lose it):
1. **Duplication check** — does this sub-workflow also appear in another skill? → invoke `split-skill` (Type B)
2. **Seam check** — is there a self-contained extractable phase? → invoke `split-skill` (Type A)
3. **No seam** — excess is only BACKGROUND/EDGE_CASE → invoke `skill-compressor`

`split-skill` calls `skill-compressor` on the output automatically.

**2h — Validate and Commit**
```bash
agentskills validate .agents/skills/<skill>/
git commit -m "improve: <skill> — <before>/14 → <after>/14\n\n- [change 1]\nSources: [source]"
```

### Step 3 — Library Summary
After all skills processed, report scores, line counts, sources used, and top patterns found across the library.

---

## Gotchas

- Never move gotchas to `references/` — agent reads them before encountering the situation, not after deciding to look.
- Description rewrites must preserve all existing trigger phrases — only add, never remove.

---

## Example

<examples>
  <example>
    <input>Improve all skills in the repo</input>
    <output>
Queue: brainstorming, prd-writing (skipping meta skills)
Confirm? → yes

brainstorming (1/2): 10/14 baseline
Research: obra/superpowers — agents skip scope check for "simple" requests (new gotcha)
HN 2025 — agents merge approach selection with design presentation (new gotcha)
Rewrote 3 workflow steps as one-liners, added 2 gotchas, moved 1 background section
Post-rewrite: 13/14 | 148 lines ✓ | validated ✓ | committed

prd-writing (2/2): 9/14 baseline
Research: awesome-copilot prd — discovery interview must precede writing (reinforced)
agentskills.io — vague language ("fast", "intuitive") is the top PRD failure mode
Added 2 gotchas, tightened output schema, moved tips section to references/background.md
Post-rewrite: 12/14 | 176 lines ✓ | validated ✓ | committed

Summary: 2 skills improved, avg +3 pts, sources: obra/superpowers, awesome-copilot, agentskills.io
    </output>
  </example>
</examples>

---

## Reference Files

- **`references/scoring-rubric.md`**: Full 0/1/2 scoring guide with examples for all 7 criteria. Read when a score is ambiguous.
