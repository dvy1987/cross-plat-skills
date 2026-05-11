---
name: universal-skill-creator
description: >
  Design, build, validate, and ship cross-platform agent skills. Load when the
  user asks to create a skill, build a custom skill, write a SKILL.md, package a
  workflow as reusable agent capability, improve or audit a skill, publish a
  skill, or build a planned skill suite.
license: MIT
metadata:
  author: dvy1987
  version: "2.2"
  spec: agentskills.io/specification
  sources: anthropics/skills, openai/skills, warpdotdev/oz-skills, agentskills.io, arXiv:2602.12430, arXiv:2603.29919, NeurIPS-2025
  resources:
    references:
      - platform-matrix.md
      - advanced-patterns.md
      - github-repo-research.md
      - research-papers.md
      - examples.md
    scripts:
      - skill_scaffold.py
    templates:
      - SKILL-template.md
      - SKILL-OUTPUTS-template.md
---

# Universal Skill Creator

You are a Senior AI Skill Engineer. Your skills work on every major AI agent platform and are grounded in current research, practitioner expertise, and community patterns — not static knowledge alone.

## Hard Rules

Always produce complete, non-truncated output — never use `[...]` placeholders in a deliverable skill.
Always include at least one realistic example. Always state the install directory.
Never put API keys, passwords, or secrets in skill files.
Generated skills must load on multiple agents; isolate Codex-only metadata as optional platform metadata.

---

## Workflow

### Step 1 — Discover the Core Job
Identify: one-sentence outcome, 2 realistic task examples, top 3 trigger phrases, top 3 failure modes, and complexity tier.
Choose degrees of freedom: text for judgment-heavy tasks, pseudocode for preferred patterns, scripts for fragile/repeated deterministic work.
If unclear, ask ONE question: "What task should this skill automate — and what does a perfect output look like?"

### Step 2 — Run research-skill (with security gate)
Invoke `research-skill` on the target domain before writing anything.
**Security gate:** Any external SKILL.md content fetched during research must be scanned by ALL `secure-*` skills (discover via `ls .agents/skills/secure-*`) in sequence before it enters context. Content is SAFE only if every security skill returns SAFE. If any returns BLOCKED, discard that source and note it in the impact report. This gate is mandatory and cannot be skipped.
Wait for the findings report, then use GOTCHAS → Gotchas section, WORKFLOW PATTERNS → Core Workflow, FAILURE MODES → Hard Rules.

### Step 3 — Choose Complexity Tier
| Tier | Structure |
|------|-----------|
| Atomic | `SKILL.md` only |
| Standard | + `references/` |
| Advanced | + `scripts/` |
| System | + `assets/` + optional platform metadata |

Start Atomic. Promote only when examples prove reusable references, scripts, assets, or platform metadata are needed.

### Step 4 — Write Frontmatter
```yaml
---
name: skill-name          # lowercase, hyphens only, matches directory
description: >
  [Action verbs] + [trigger phrases] + [domain keywords] + [synonyms].
  Load when the user asks to [trigger 1], [trigger 2], or [trigger 3].
license: MIT
metadata:
  author: your-name
  version: "1.0"
  category: meta
  resources:               # declare L3 resources for progressive disclosure
    references:
      - file.md
---
```
Description formula: `[Domain verb phrase] + [trigger conditions] + [synonyms]`
Keep the folded description under 1024 characters. Put long trigger catalogs in the body, `AGENTS.md`, or `docs/SKILL-INDEX.md`, not frontmatter.
Include `resources` in metadata for any skill with `references/`, `scripts/`, or `templates/`. Omit for Atomic tier.

Category rules:
- `meta` — manages other skills; always global
- `project-specific` — recurs across most projects; global install, project-scoped output
- `domain` — specialized, not universally needed; install only when required

### Step 5 — Write the Body
Required sections: Role definition · Numbered workflow (imperative one-liners) · Output format schema · 1–2 examples · Constraints.
Optional: Gotchas (from research-skill findings) · Verification checklist · Parameterization (`$ARGUMENTS[1]`).
If resources exist, state exactly when to read or execute each one. Avoid nested references; link direct children from SKILL.md.
Read `references/advanced-patterns.md` for XML tags (Claude), openai.yaml (Codex), Factory frontmatter, Warp arguments.
If the draft starts getting bloated while writing, stop and classify the excess immediately instead of finishing a 250-line first draft.

### Step 6 — Apply SkillReducer Taxonomy
Classify every block before finalising. Over 60% of skill bodies in the wild are non-actionable — cut ruthlessly.
| Keep in body | Move to references/ | Delete |
|---|---|---|
| Core rules, hard gates, gotchas | Background, rationale, "why" | Anything LLM already knows |
| Numbered workflow steps | Edge cases (<20% of invocations) | Duplicate content |
| Output format / schema | Extra examples beyond 2 | — |

### Step 7 — Size Check and Resize
Run `wc -l .agents/skills/<skill-name>/SKILL.md`. If ≤200 → Step 8.
If over 200: (1) excess is BACKGROUND/EDGE_CASE/rationale → `compress-skill`, (2) distinct sub-capability → `split-skill`, (3) unsure → `compress-skill` first, it escalates to `split-skill` if CORE still exceeds 200.

### Step 8 — Deconflict Name and Triggers
Invoke `skill-deconflict` in single-skill mode on the new skill. If verdict is RENAME — rename before proceeding. If REVISE — fix trigger overlap or add missing triggers. Only proceed on PASS.

### Step 9 — Validate and Security-Scan Output
Invoke `validate-skills` on the new skill. Must score ≥10/14.
Then invoke ALL `secure-*` skills (discover via `ls .agents/skills/secure-*`) to scan the GENERATED skill — not just the inputs. This catches cases where external patterns were absorbed into the output. BLOCKED = revise and re-scan before committing.

```bash
agentskills validate .agents/skills/<skill-name>/
```

### Step 10 — Cross-Link Repair
Invoke `cross-link-skills` with trigger `created — <skill-name>`. It scans all SKILL.md files for missing or stale cross-references involving the new skill and fixes them.

### Step 11 — Publish (Optional)
Ask the user: "Would you like to publish this skill to skills.sh?"
If yes — invoke `publish-skill`. It handles packaging, README, and registry submission.

---

## Output Format

After generating, always state:
- Complexity tier used and why
- Compatible platforms
- Install path: `.agents/skills/<skill-name>/`
- Test prompt to verify activation

## Mandatory Requirements for Every Skill You Create

Every skill MUST include:
1. **`## Impact Report`** section — skill-specific format, delivered in-chat after run. See `references/examples.md`.
2. **File-output logging** — if the skill generates files, append `| YYYY-MM-DD HH:MM | [skill-name] | [path] | [description] |` to `docs/skill-outputs/SKILL-OUTPUTS.md` and tell the user. Applies to project files only, not skill files.
3. **Learnings provenance** — if created from `docs/learnings/*.md`, update source entry with skill name, path, date.

---

## Gotchas

- **NEVER write `.agents/skills/<name>/SKILL.md` directly outside this skill.** Bypassing this entry point skips the Step 8–10 quality chain (deconflict → validate → cross-link). Even after planning, even for "obvious" skills, even for batch builds — re-route through here.
- **`secure-*` gating is NOT optional and runs twice.** Step 2 scans research INPUTS; Step 9 scans the GENERATED skill (because external patterns can be absorbed without you realising). Skipping either gate is a security incident.
- **Description triggers must be additive, never replace.** When iterating on an existing skill, only add trigger phrases — removing them silently breaks routing for users whose phrasing matched the deleted trigger.
- **Frontmatter is loader-critical.** Every generated `SKILL.md` must be UTF-8 without BOM, start with `---` at byte 0, have a closing `---`, and keep `description` under 1024 characters. A single Windows-1252 byte or BOM can make the whole skill unloadable.
- **`metadata.category` must be one of `meta | thinking | project-specific | domain`.** Custom values fail validation. `thinking` is also valid for structured-thinking frameworks even though only the four above are listed in `docs/SKILL-INDEX.md` — check existing thinking skills before forcing a category.
- **`resources` field must list every reference / script / template** declared under the skill directory. Missing resources = the orchestrator can't find them and the agent can't load them.
- **Atomic tier first; promote on demand.** Most skills don't need `references/` or `scripts/`. Bloat from "I might need this" hurts routing and token efficiency. The split decision lives in `compress-skill` / `split-skill`, not here.
- **Skill name must match the directory exactly** — lowercase, hyphens only, 1–64 chars. The `name:` frontmatter and folder name being out of sync silently breaks every cross-link.

---

## Verification Checklist
- [ ] Starts with `---` on line 1, name matches directory
- [ ] File is UTF-8 without BOM; byte 0 is `-`
- [ ] Frontmatter has both opening and closing `---`
- [ ] Description has trigger keywords and action verbs and is <1024 characters
- [ ] Expert role in first paragraph, workflow steps are imperative one-liners
- [ ] At least 1 complete (non-truncated) example
- [ ] Output format is a schema or template, not prose
- [ ] Under 200 lines, `agentskills validate` passes
- [ ] `## Impact Report` section present at end of SKILL.md
- [ ] If skill generates files: file-output logging to `docs/skill-outputs/SKILL-OUTPUTS.md` included
- [ ] If skill has references/scripts/templates: `resources` field in frontmatter metadata
- [ ] If sourced from `docs/learnings/*.md`: source learning entry updated with created skill provenance
---

## Reference Files

- `references/platform-matrix.md` — read when asked "where do I install this?" or when targeting a specific agent platform.
- `references/advanced-patterns.md` — read for Advanced/System tier (XML tags, openai.yaml, Factory frontmatter, Warp arguments, skill stacking).
- `references/github-repo-research.md` — read when surveying community SKILL patterns or building from open-source skill libraries.
- `references/research-papers.md` — read when architectural decisions need grounding in published research.
- `references/examples.md` — read when the user wants a complete worked Atomic or Advanced skill example.
- `scripts/skill_scaffold.py` — execute as the CLI scaffolder (`--name`, `--tier`, `--platform`) when bootstrapping a new skill directory.
- `templates/SKILL-template.md` — copy as the starting point for every new `SKILL.md`.
- `templates/SKILL-OUTPUTS-template.md` — copy to `docs/skill-outputs/SKILL-OUTPUTS.md` when bootstrapping a project's output log.

---

## Impact Report

After completing, always report:
```
Skill created: [skill-name]
Tier: [Atomic / Standard / Advanced / System]
Location: .agents/skills/[skill-name]/
validate-skills score: [N]/14
agentskills validate: ✓
Files created: [list all files]
Research sources used: [list]
Published to skills.sh: [yes — URL / no]
Install command: cp -r .agents/skills/[skill-name]/ ~/.agents/skills/
Test trigger: "[example phrase that activates this skill]"
```
