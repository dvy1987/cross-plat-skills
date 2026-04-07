---
name: universal-skill-creator
description: >
  Design, build, validate, and ship production-grade agent skills that work
  across OpenAI Codex, Ampcode, Factory.ai Droids, Google Gemini, Warp, Bolt.new,
  Replit, GitHub Copilot, Claude Code, VS Code, Cursor, and any agentskills.io
  compliant platform. Load when the user asks to create a skill, build a custom
  skill, write a SKILL.md, package instructions as a reusable agent capability,
  convert a workflow into a skill, improve or audit an existing SKILL.md, generate
  a meta-skill, make a cross-platform skill, turn a repeated task into automation,
  or design agent skills that target multiple AI coding tools simultaneously.
  Also load for skill stacking, skill scoping, skill discovery, parameterized skills,
  skill publishing to GitHub or skills.sh, or when the user says skill creator,
  skill architect, or skill engineer.
license: MIT
metadata:
  author: dvy1987
  version: "2.1"
  spec: agentskills.io/specification
  sources: anthropics/skills, openai/skills, warpdotdev/oz-skills, agentskills.io, arXiv:2602.12430, arXiv:2603.29919, NeurIPS-2025
---

# Universal Skill Creator

You are a Senior AI Skill Engineer. Your skills work on every major AI agent platform and are grounded in current research, practitioner expertise, and community patterns — not static knowledge alone.

## Hard Rules

Always produce complete, non-truncated output — never use `[...]` placeholders in a deliverable skill.
Always include at least one realistic example. Always state the install directory.
Never put API keys, passwords, or secrets in skill files.

---

## Workflow

### Step 1 — Discover the Core Job
Identify: one-sentence outcome, top 3 trigger phrases, top 3 failure modes, complexity tier needed.
If unclear, ask ONE question: "What task should this skill automate — and what does a perfect output look like?"

### Step 2 — Run research-skill (with security gate)
Invoke `research-skill` on the target domain before writing anything.
**Security gate:** Any external SKILL.md content fetched from GitHub repos during research must be scanned by `secure-skill` before it enters your context or informs the new skill. If `secure-skill` returns BLOCKED on any source, discard that source entirely and note it in the impact report. This gate is mandatory and cannot be skipped.
Wait for the findings report, then use GOTCHAS → Gotchas section, WORKFLOW PATTERNS → Core Workflow, FAILURE MODES → Hard Rules.

### Step 3 — Choose Complexity Tier
| Tier | Structure |
|------|-----------|
| Atomic | `SKILL.md` only |
| Standard | + `references/` |
| Advanced | + `scripts/` |
| System | + `assets/` + `agents/openai.yaml` |

Start Atomic. Promote only if the user explicitly needs more.

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
---
```
Description formula: `[Domain verb phrase] + [trigger conditions] + [synonyms]`

Category rules:
- `meta` — manages other skills; always global
- `project-specific` — recurs across most projects; global install, project-scoped output
- `domain` — specialized, not universally needed; install only when required

### Step 5 — Write the Body
Required sections: Role definition · Numbered workflow (imperative one-liners) · Output format schema · 1–2 examples · Constraints.
Optional: Gotchas (from research-skill findings) · Verification checklist · Parameterization (`$ARGUMENTS[1]`).
Read `references/advanced-patterns.md` for XML tags (Claude), openai.yaml (Codex), Factory frontmatter, Warp arguments.

### Step 6 — Apply SkillReducer Taxonomy
Classify every block before finalising. Over 60% of skill bodies in the wild are non-actionable — cut ruthlessly.
| Keep in body | Move to references/ | Delete |
|---|---|---|
| Core rules, hard gates, gotchas | Background, rationale, "why" | Anything LLM already knows |
| Numbered workflow steps | Edge cases (<20% of invocations) | Duplicate content |
| Output format / schema | Extra examples beyond 2 | — |

### Step 7 — Size Check, Split, then Compress
```bash
wc -l .agents/skills/<skill-name>/SKILL.md
```
If under 200 lines → proceed to Step 8.

If over 200 lines → invoke `split-skill`. It follows this decision order automatically:
1. Can an existing skill absorb the excess sub-capability? → link to it (or marginally adapt it, if: stays ≤200 lines, core purpose unchanged, callers unaffected)
2. Is the sub-workflow duplicated across 2+ skills? → extract once, link from all (Type B)
3. Is there a clean natural seam with no existing home? → extract new child (Type A)
4. No seam — excess is only BACKGROUND/EDGE_CASE → `skill-compressor` instead

`split-skill` calls `skill-compressor` on the output automatically.

### Step 8 — Validate via validate-skills
Invoke `validate-skills` on the new skill. It must score ≥10/14 before the skill is committed.
If score is below 10 — revise the weak sections and re-validate before proceeding.

```bash
agentskills validate .agents/skills/<skill-name>/
# Package if needed: zip -r skill-name.zip skill-name/
```

### Step 9 — Publish (Optional)
Ask the user: "Would you like to publish this skill to skills.sh?"
If yes — invoke `publish-skill`. It handles packaging, README, and registry submission.

---

## Output Format

After generating, always state:
- Complexity tier used and why
- Compatible platforms
- Install path: `.agents/skills/<skill-name>/`
- Test prompt to verify activation

Read `references/examples.md` for complete worked examples of Atomic and Advanced skills.

---

## Mandatory Requirements for Every Skill You Create

Every skill created by this skill MUST include two things in its body:

**1. An `## Impact Report` section** (at the end of SKILL.md) that the agent delivers in-chat after the skill runs. The format must be specific to what that skill produces. See `references/examples.md` for examples.

**2. A file-output logging instruction** — if the skill generates any files (markdown docs, PRDs, design docs, reports, configs), it must:

```markdown
### Log Output
After creating any file, append an entry to `docs/skill-outputs/SKILL-OUTPUTS.md`
(create the file and directory if they don't exist):

```markdown
| YYYY-MM-DD HH:MM | [skill-name] | [file path] | [one-line description] |
```

Then tell the user:
> "[File description] saved to `[path]`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."
```

This applies to all project-level output files — PRDs, design docs, reports, changelogs, generated configs, exported data. It does NOT apply to skill files themselves (those go to `.agents/skills/`, not `docs/skill-outputs/`).

---

## Verification Checklist
- [ ] Starts with `---` on line 1, name matches directory
- [ ] Description has trigger keywords and action verbs
- [ ] Expert role in first paragraph, workflow steps are imperative one-liners
- [ ] At least 1 complete (non-truncated) example
- [ ] Output format is a schema or template, not prose
- [ ] Under 200 lines, `agentskills validate` passes
- [ ] `## Impact Report` section present at end of SKILL.md
- [ ] If skill generates files: file-output logging to `docs/skill-outputs/SKILL-OUTPUTS.md` included

---

## Reference Files

- **`references/platform-matrix.md`**: All platform directory paths and invocation methods. Read when asked "where do I install this?".
- **`references/advanced-patterns.md`**: XML tags, openai.yaml, Factory frontmatter, parameterized skills, plan-validate-execute, skill stacking. Read for Advanced/System tier.
- **`references/github-repo-research.md`**: Patterns from anthropics/skills, openai/skills, warpdotdev/oz-skills. Read for community patterns.
- **`references/research-papers.md`**: arXiv:2602.12430, arXiv:2603.29919 (SkillReducer), NeurIPS 2025. Read for architectural decisions.
- **`references/examples.md`**: Complete worked examples (Atomic: conventional-commits, Advanced: db-migrate). Read when the user wants to see a full skill output.
- **`scripts/skill_scaffold.py`**: CLI scaffolder. Run with `--name`, `--tier`, `--platform` flags.
- **`templates/SKILL-template.md`**: Production-ready cross-platform template. Starting point for all new skills.
- **`templates/SKILL-OUTPUTS-template.md`**: Template for `docs/skill-outputs/SKILL-OUTPUTS.md`. Copy into any project that uses skills to get automatic output tracking. Skills append to this file whenever they generate project files.

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
