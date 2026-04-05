# Skill Outputs Log

Auto-generated log of files created by agent skills in this project.
Every skill that generates a project file appends an entry here.
Do not edit manually — entries are written by skills automatically.

---

## Log

| Date & Time | Skill | File | Description |
|-------------|-------|------|-------------|
| <!-- entries appended here by skills --> | | | |

---

## How to Use This Log

- **Find a file**: search by skill name or description
- **Audit outputs**: see everything the agent has generated in this project
- **Recover work**: if a file is missing, the path and description help you recreate it
- **Onboard teammates**: shows new contributors what has been generated and where

## Skills That Write Here

| Skill | What it logs |
|-------|-------------|
| `brainstorming` | Design specs → `docs/specs/YYYY-MM-DD-<topic>-design.md` |
| `prd-writing` | PRD documents → `docs/prd/YYYY-MM-DD-<feature>-prd.md` |
| *(future skills)* | Any skill that generates project files should append here |

## Initialising This File

When a skill needs to append to this file and it doesn't exist yet:
```bash
mkdir -p docs/skill-outputs
cp .agents/skills/universal-skill-creator/templates/SKILL-OUTPUTS-template.md \
   docs/skill-outputs/SKILL-OUTPUTS.md
```

Or the skill creates it automatically with just the header row on first write.
