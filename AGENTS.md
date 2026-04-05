# AGENTS.md — cross-plat-skills

This file tells AI agents how to work with this repository.
Read it before making any changes.

---

## What This Repo Is

A personal library of cross-platform agent skills following the
[agentskills.io](https://agentskills.io/specification) open standard.
Every skill in `.agents/skills/` works across Codex CLI, Ampcode,
Claude Code, Warp, Gemini CLI, GitHub Copilot, Cursor, Factory.ai,
Replit, Bolt.new, and VS Code — no platform-specific changes needed.

---

## Repo Layout

```
.agents/skills/          ← all skills live here
  <skill-name>/
    SKILL.md             ← required: frontmatter + instructions
    references/          ← optional: docs loaded on demand
    scripts/             ← optional: executable logic
    templates/           ← optional: output scaffolds
    assets/              ← optional: static resources
    agents/
      openai.yaml        ← optional: Codex UI metadata only
README.md                ← user-facing install + usage guide
AGENTS.md                ← this file
CONTRIBUTING.md          ← skill quality standards + PR process
install.sh               ← one-time global setup script
```

---

## Conventions

### Adding a new skill
1. Create `.agents/skills/<skill-name>/SKILL.md`
2. Follow the template at `.agents/skills/universal-skill-creator/templates/SKILL-template.md`
3. Validate: `agentskills validate .agents/skills/<skill-name>/`
4. Update the Skills table in `README.md`
5. Commit with message: `feat: add <skill-name> skill`

### Editing an existing skill
- Bump `metadata.version` in frontmatter
- Commit with message: `fix: <skill-name> — <what changed>`

### Skill naming
- Lowercase, hyphens only, 1–64 chars
- Verb-noun preferred: `code-review`, `prd-writing`, `sprint-retro`
- Must match the directory name exactly

### Skill quality bar
- Every skill must pass `agentskills validate`
- Every skill must have at least one example (input → output)
- Every requirement must be specific and testable — no vague language
- SKILL.md must stay under 200 lines — no exceptions, including meta skills
- If a skill exceeds 200 lines, split using progressive disclosure: move examples to `references/examples.md`, background to `references/background.md`, and call `research-skill` for research instead of inlining the protocol
- See `CONTRIBUTING.md` for the full checklist

### Never
- Never put API keys, tokens, or secrets in any skill file
- Never commit a skill that fails `agentskills validate`
- Never use placeholder text (TBD, TODO) in a published skill

### Auto-compression trigger
After writing or editing any skill, check its line count:
```bash
wc -l .agents/skills/<skill-name>/SKILL.md
```
If it exceeds 200 lines — invoke `skill-compressor` before committing. No exceptions.

---

## Key Commands

```bash
# Validate a skill
agentskills validate .agents/skills/<skill-name>/

# Scaffold a new skill
python .agents/skills/universal-skill-creator/scripts/skill_scaffold.py \
  --name <skill-name> --tier atomic --author dvy1987

# Install all skills globally (run once per machine)
bash install.sh

# Update after pulling new skills
bash install.sh --update
```

---

## Skill Relationships

```
brainstorming  →  prd-writing  →  [implementation skill]

universal-skill-creator  →  research-skill  (calls for domain research)
improve-skills           →  research-skill  (calls for domain research)
improve-skills           →  skill-compressor (calls if >200 lines after rewrite)
```

- `brainstorming`: design before code — always runs first for new features
- `prd-writing`: formalises a design doc into a structured PRD
- `universal-skill-creator`: meta-skill — creates new skills
- `improve-skills`: meta-skill — audits and improves existing skills
- `skill-compressor`: meta-skill — compresses any skill to under 200 lines
- `research-skill`: shared capability — called by creator and improver for live domain research
