# cross-plat-skills

> A curated collection of agent skills that work across every major AI coding tool — write once, run everywhere.

Skills follow the [agentskills.io](https://agentskills.io/specification) open standard and are compatible with:

| Platform | Reads From |
|----------|-----------|
| OpenAI Codex | `.agents/skills/` |
| Ampcode | `.agents/skills/` |
| Claude Code | `.agents/skills/` or `.claude/skills/` |
| GitHub Copilot | `.agents/skills/` or `.github/skills/` |
| Warp | `.agents/skills/` (+ all other major dirs) |
| Factory.ai | `.agents/skills/` or `.factory/skills/` |
| Replit | `.agents/skills/` |
| Gemini CLI | `.agents/skills/` or `.gemini/skills/` |
| Cursor | `.agents/skills/` or `.cursor/skills/` |
| VS Code | `.agents/skills/` |
| Bolt.new | `.agents/skills/` |

---

## Skills in This Repo

### [`universal-skill-creator`](.agents/skills/universal-skill-creator/)

A meta-skill — a skill that creates skills. Use it to design, build, validate, and ship production-grade agent skills for any platform.

**Triggers on:** "create a skill", "write a SKILL.md", "make a cross-platform skill", "skill creator", "build a custom skill"

**What it does:**
- Guides you through the full skill creation workflow (discover → design → write → validate → publish)
- Knows every platform's directory paths, invocation methods, and platform-specific config formats
- Embeds patterns from [`anthropics/skills`](https://github.com/anthropics/skills), [`openai/skills`](https://github.com/openai/skills), [`warpdotdev/oz-skills`](https://github.com/warpdotdev/oz-skills), and [`github/awesome-copilot`](https://github.com/github/awesome-copilot)
- Includes a scaffold CLI (`scripts/skill_scaffold.py`) to auto-generate skill boilerplate

**Install:**
```bash
# Copy into your project (all platforms)
cp -r .agents/skills/universal-skill-creator/ YOUR_PROJECT/.agents/skills/

# Or install from registry
npx skills universal-skill-creator -a codex
npx skills universal-skill-creator -a replit
```

---

## How to Use Any Skill Here

```bash
# Clone this repo
git clone https://github.com/dvy1987/cross-plat-skills.git

# Copy the skill(s) you want into your project
cp -r cross-plat-skills/.agents/skills/SKILL_NAME/ YOUR_PROJECT/.agents/skills/
```

Your AI agent will automatically discover and load the skill from `.agents/skills/`.

---

## Scaffold a New Skill

The `universal-skill-creator` skill includes a Python CLI to generate new skill boilerplate:

```bash
python .agents/skills/universal-skill-creator/scripts/skill_scaffold.py \
  --name my-skill \
  --tier standard \
  --platform universal \
  --author your-name
```

**Tiers:**
| Tier | Structure |
|------|-----------|
| `atomic` | `SKILL.md` only |
| `standard` | `SKILL.md` + `references/` |
| `advanced` | `SKILL.md` + `references/` + `scripts/` |
| `system` | Full directory with `assets/` + `agents/openai.yaml` + `README.md` |

---

## Validate a Skill

```bash
pip install skills-ref
agentskills validate .agents/skills/SKILL_NAME/
```

---

## Publish a Skill

```bash
# Publish to skills.sh community registry
npx skills publish .agents/skills/SKILL_NAME/
```

---

## Contributing

1. Fork this repo
2. Create your skill in `.agents/skills/your-skill-name/`
3. Validate: `agentskills validate .agents/skills/your-skill-name/`
4. Open a PR — include a test prompt that triggers the skill

---

## Resources

- [agentskills.io specification](https://agentskills.io/specification)
- [agentskills.io best practices](https://agentskills.io/skill-creation/best-practices)
- [anthropics/skills](https://github.com/anthropics/skills) — Anthropic reference skills (69k+ stars)
- [openai/skills](https://github.com/openai/skills) — Official Codex skills catalog
- [warpdotdev/oz-skills](https://github.com/warpdotdev/oz-skills) — Warp curated skills
- [skills.sh](https://skills.sh) — Community registry

---

*Skills in this repo follow the [agentskills.io](https://agentskills.io) open standard — MIT licensed.*
