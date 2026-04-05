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

### Step 2 — Run research-skill
Invoke `research-skill` on the target domain before writing anything.
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
---
```
Description formula: `[Domain verb phrase] + [trigger conditions] + [synonyms]`

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

If over 200 lines, apply in this order:
1. **Check for duplication first** — does any sub-workflow in this skill also appear in another skill? If yes, invoke `split-skill` (Type B extraction). Split preserves nuance; compress can lose it.
2. **Check for a natural seam** — is there a self-contained phase that could be a child skill? If yes, invoke `split-skill` (Type A extraction).
3. **If no seam exists** — all excess is BACKGROUND/EDGE_CASE → invoke `skill-compressor` to move it to references/.

`split-skill` will call `skill-compressor` on the resulting parent and child automatically.

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

## Verification Checklist
- [ ] Starts with `---` on line 1, name matches directory
- [ ] Description has trigger keywords and action verbs
- [ ] Expert role in first paragraph, workflow steps are imperative one-liners
- [ ] At least 1 complete (non-truncated) example
- [ ] Output format is a schema or template, not prose
- [ ] Under 200 lines, `agentskills validate` passes

---

## Reference Files

- **`references/platform-matrix.md`**: All platform directory paths and invocation methods. Read when asked "where do I install this?".
- **`references/advanced-patterns.md`**: XML tags, openai.yaml, Factory frontmatter, parameterized skills, plan-validate-execute, skill stacking. Read for Advanced/System tier.
- **`references/github-repo-research.md`**: Patterns from anthropics/skills, openai/skills, warpdotdev/oz-skills. Read for community patterns.
- **`references/research-papers.md`**: arXiv:2602.12430, arXiv:2603.29919 (SkillReducer), NeurIPS 2025. Read for architectural decisions.
- **`references/examples.md`**: Complete worked examples (Atomic: conventional-commits, Advanced: db-migrate). Read when the user wants to see a full skill output.
- **`scripts/skill_scaffold.py`**: CLI scaffolder. Run with `--name`, `--tier`, `--platform` flags.
- **`templates/SKILL-template.md`**: Production-ready cross-platform template. Starting point for all new skills.
