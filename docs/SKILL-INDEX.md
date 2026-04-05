# Skill Index

Complete reference for all skills in this repo.
Agents: read this when deciding which skill to invoke or checking what a skill produces.
Humans: read this for a full picture of what's available and what each skill outputs.

Last updated: 2026-04-05

---

## Skill Categories — Definitions

### Meta Skills
Skills that manage the skill library itself. They create, improve, validate, compress, split, deprecate, and publish other skills. Meta skills are always installed globally (`~/.agents/skills/`) and are available across every project automatically. They call each other — see the Call Graph below. Users interact with only two: `universal-skill-creator` and `improve-skills`. The rest are called automatically.

### Project-Specific Skills
Skills built for workflows that recur across most or all projects — things like designing features before coding, writing product requirements, planning implementation, writing changelogs, or documenting decisions. These skills are installed globally and work in any project, but the files they generate land inside the current project's directory structure (e.g., `docs/specs/`, `docs/prd/`). They are "project-specific" not because they are scoped to one codebase, but because their output is always tied to the project you are currently working in.

### Domain Skills
Skills built for specialized workflows that are useful in some projects but not all. Examples: story writing, dramatization, screenplay formatting, academic paper structuring, legal document drafting, marketing copy generation. Domain skills are not universally applicable — they are built and installed only when a project or user explicitly needs them. **This category is currently empty.** Add skills here when you build something specialized.

---

## Meta Skills

Install globally: `~/.agents/skills/`. Called automatically by `improve-skills` and `universal-skill-creator`.

### `universal-skill-creator`
**Triggers:** "create a skill", "build a skill that does X", "skill creator", "write a SKILL.md", "skill architect", "skill engineer"
**What it does:** Creates new cross-platform skills from scratch. Runs live domain research (papers + practitioner blogs + GitHub skill repos), writes the skill body, validates quality (≥10/14 score), splits or compresses if over 200 lines, optionally publishes to skills.sh.
**Mandatory in every skill it creates:** `## Impact Report` section + file-output logging to `docs/skill-outputs/SKILL-OUTPUTS.md` for any skill that generates project files.
**Output:** `.agents/skills/<name>/SKILL.md` + optional `references/`, `scripts/`, `templates/`
**Impact report:** Tier, validate-skills score, install path, test trigger, all files created, research sources used, publish status

---

### `improve-skills`
**Triggers:** "improve all skills", "skill audit", "upgrade skills with latest research", "run improvement pass"
**What it does:** Full improvement cycle for every skill (or a named subset). Per-skill sequence: prune → fix structural gaps → link check → research → rewrite → resize.
**Calls:** `validate-skills` (pre-flight) → `deprecate-skill` (if 0–5/14) → `prune-skill` → [fix gaps] → [link check] → `research-skill` → [rewrite] → `split-skill`/`skill-compressor` → validate + commit
**Structural gap fixing (Step 2b):** Automatically fixes every flag from validate-skills — missing category, missing Impact Report, missing file-output logging, stale rubric references, orphaned reference files, missing load triggers.
**Link check (Step 2d):** Scans the full library for delegation opportunities. Links when output is directly consumable OR when a marginal adaptation to the target skill would make it consumable (allowed if target stays ≤200 lines, core purpose unchanged, existing callers unaffected). Documents new links and any target skill changes in AGENTS.md and commit message.
**Output:** Modified SKILL.md files for every improved skill
**Impact report:** Per-skill score deltas, structural gaps fixed, new links created, sources used, all files modified

---

### `validate-skills`
**Triggers:** "validate skills", "skill health check", "check all skills", "are my skills ok"
**What it does:** Read-only audit. Scores every skill on 7 criteria (max 14/14). Flags P0 failures, >200-line violations, broken caller references, orphaned reference files, duplicate trigger phrases.
**Output:** No files modified. Structured quality report in chat with P0/P1/P2/P3 actions.
**Impact report:** Skills checked, P0 failures, average score, recommended actions
**Rubric:** `.agents/skills/validate-skills/references/validation-rubric.md`

---

### `prune-skill`
**Triggers:** "prune skills", "check for outdated techniques", "verify citations", "update for new model"
**What it does:** Evidence-only removal of wrong, outdated, or poorly-cited content. Audits every citation for trust tier (High=NeurIPS/ICML/ICLR, Medium=arXiv 50+ citations, Low=blogs, Zero=unverifiable). Checks the obsolete techniques list. Never prunes without a citable source. Appends a Prune Log to every skill it touches.
**Output:** Target SKILL.md pruned + Prune Log appended
**Impact report:** Items pruned, corrected, flagged; source cited for each removal
**References:** `citation-standards.md`, `obsolete-techniques.md` in `.agents/skills/prune-skill/references/`

---

### `research-skill`
**Triggers:** "research domain for a skill", "find existing skills on X", "what research exists for Y" — or called by `universal-skill-creator`/`improve-skills`
**What it does:** Searches academic papers (arXiv, NeurIPS, ICML), practitioner blogs (Vercel, Stripe, Linear eng, HN, Substack), and GitHub skill repos (anthropics/skills, openai/skills, warpdotdev/oz-skills) in parallel. Returns a structured findings report — GOTCHAS, WORKFLOW PATTERNS, FAILURE MODES, EXISTING SKILLS.
**Output:** No files modified. Returns findings report to the calling skill or user.
**Impact report:** Sources consulted, gotchas found, existing skills found, discarded background items

---

### `skill-compressor`
**Triggers:** "compress this skill", called by `split-skill` and `improve-skills` when skill >200 lines and no natural seam exists
**What it does:** Classifies every content block (CORE/WORKFLOW/FORMAT/EXAMPLE/BACKGROUND/EDGE_CASE/DUPLICATE) then moves non-core content to `references/` with specific load triggers. If CORE content alone still exceeds 200 lines, invokes `split-skill` — which first checks if an existing skill can absorb the sub-capability before creating a new child.
**Output:** SKILL.md trimmed + new `references/` files created as needed
**Impact report:** Lines before/after, reduction %, files created, regression check result

---

### `split-skill`
**Triggers:** "split this skill", "extract a sub-skill", "this skill is doing too much" — or called automatically
**What it does:** Reduces an oversized skill by first checking if an existing skill can absorb the excess sub-capability (link or marginally adapt, rather than create). Only creates a new child if no existing skill fits. Decision order: (1) link to existing skill → (2) marginally improve existing + link → (3) extract new child (Type A/B) → (4) stop, call skill-compressor. Marginal adaptation of the target skill is allowed if it stays under 200 lines, core purpose is unchanged, and existing callers are unaffected.
**Output:** If linked: parent SKILL.md updated + AGENTS.md modified. If new child: `.agents/skills/<child>/SKILL.md` created + parent SKILL.md + AGENTS.md modified.
**Impact report:** Action taken (linked/adapted/extracted), parent/child line counts, callers updated, regression check
**Patterns:** `.agents/skills/split-skill/references/split-patterns.md`

---

### `deprecate-skill`
**Triggers:** "deprecate this skill", "retire this skill" — or offered by `improve-skills` when score is 0–5/14
**What it does:** Gracefully retires a skill that is redundant, superseded, or no longer earning its context window cost. Requires evidence (never age alone), requires user confirmation, archives to `.agents/skills/.deprecated/`, writes `DEPRECATION.md`, updates all callers, AGENTS.md, README, and deprecation log.
**Output:** Skill moved to `.agents/skills/.deprecated/<name>-deprecated-YYYY-MM-DD/`. AGENTS.md, README, callers modified.
**Impact report:** Archive path, recovery command, callers updated, deprecation log entry
**Log:** `.agents/skills/deprecate-skill/references/deprecation-log.md`

---

### `publish-skill`
**Triggers:** "publish this skill", "share this skill publicly", "submit to skills.sh" — or offered by `universal-skill-creator` as optional final step
**What it does:** Validates quality (≥10/14 required), scans for proprietary content (no internal URLs, paths, or credentials), packages correctly (.md for Atomic tier, .zip for Standard+), writes README if missing, publishes to skills.sh via `npx skills publish`.
**Output:** Skill live on skills.sh registry. Optional git commit if pushing to GitHub.
**Impact report:** Registry URL, install command, score at publish, package format, proprietary scan result
**Checklist:** `.agents/skills/publish-skill/references/publish-checklist.md`

---

## Project-Specific Skills

Install globally: `~/.agents/skills/`. Output files land inside the current project.

### `brainstorming`
**Triggers:** "brainstorm", "design this feature", "what's the best approach for", "let's think through", "before we build", "I have an idea for", "explore options"
**What it does:** Turns a rough idea into an approved design through structured dialogue. One question at a time. Hard gate — no code or implementation until the user reviews and approves a written design doc. Decomposes oversized requests into sub-projects.
**Output file:** `docs/specs/YYYY-MM-DD-<topic>-design.md` (committed to git)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Terminal notification:** "Design doc saved to `docs/specs/YYYY-MM-DD-<topic>-design.md`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."
**Impact report:** Approach chosen, key decisions, open questions resolved, next step (prd-writing or implementation)

---

### `prd-writing`
**Triggers:** "write a PRD", "document requirements", "create a spec", "I need a PRD for", "turn this into requirements", "define acceptance criteria"
**What it does:** Discovery interview (minimum 2 questions, even with a detailed brief) then produces a structured PRD in the chosen format. Reads brainstorming design docs from `docs/specs/` as foundation when available. Never writes before discovering.
**Formats:** Full PRD | Lean PRD | One-Pager | Technical PRD
**Output file:** `docs/prd/YYYY-MM-DD-<feature>-prd.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Terminal notification:** "PRD saved to `docs/prd/YYYY-MM-DD-<feature>-prd.md`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."
**Impact report:** Format, sections written, open questions remaining, success metrics defined
**References:** `prd-schemas.md`, `metrics-frameworks.md` in `.agents/skills/prd-writing/references/`

---

## Domain Skills

Specialized skills for specific types of projects — not universally applicable.
**Currently empty.** Add entries here as domain skills are built.

Examples of what belongs here when built:
- Story writing, dramatization, screenplay formatting
- Academic paper structuring, literature review workflows
- Legal document drafting, contract review workflows
- Marketing copy generation, campaign brief writing

---

## Skill Output Log Convention

Every skill that generates a project file appends to `docs/skill-outputs/SKILL-OUTPUTS.md`.

**Bootstrap (one time per project):**
```bash
mkdir -p docs/skill-outputs
cp .agents/skills/universal-skill-creator/templates/SKILL-OUTPUTS-template.md \
   docs/skill-outputs/SKILL-OUTPUTS.md
```

**Log format:**
```
| YYYY-MM-DD HH:MM | skill-name | file/path.md | One-line description |
```

---

## Call Graph (quick reference)

```
User entry points:
  universal-skill-creator  ← "create a skill"
  improve-skills           ← "improve skills"

universal-skill-creator → research-skill (Step 2, always)
                        → split-skill (Step 7, if >200 + seam)
                            → skill-compressor (always after split)
                        → skill-compressor (Step 7, if >200, no seam)
                        → validate-skills (Step 8, quality gate)
                        → publish-skill (Step 9, optional)

improve-skills → validate-skills (Step 1, pre-flight)
                   → deprecate-skill (if score 0–5/14, user decides)
               → prune-skill (Step 2a, per skill)
               → research-skill (Step 2c, per skill)
               → split-skill (Step 2g, if >200 + seam)
                   → skill-compressor
               → skill-compressor (Step 2g, if >200, no seam)

skill-compressor → split-skill (if CORE still >200 after classify)
split-skill      → skill-compressor (always, after split)

Leaf nodes (call nothing):
  validate-skills  research-skill  prune-skill  deprecate-skill  publish-skill
```
