# Contributing to cross-plat-skills

---

## The One Rule

Every skill must work on the first try in at least three platforms.
If it only works in Claude Code, it doesn't belong here.

---

## Adding a Skill

### 1. Scaffold it

```bash
python .agents/skills/universal-skill-creator/scripts/skill_scaffold.py \
  --name your-skill-name \
  --tier atomic \
  --author your-name
```

Or copy the template manually:
```bash
mkdir -p .agents/skills/your-skill-name
cp .agents/skills/universal-skill-creator/templates/SKILL-template.md \
   .agents/skills/your-skill-name/SKILL.md
```

### 2. Write it

Open `.agents/skills/your-skill-name/SKILL.md` and fill in:

- **`description`** — the most important field. Write it to answer: "When should an agent load this?" Include trigger phrases, domain keywords, and synonyms. Use the full 1024 characters for public skills.
- **`metadata.category`** — must be one of `meta`, `thinking`, `project-specific`, or `domain`. See `docs/SKILL-INDEX.md` for definitions.
- **Role definition** — "You are a [specific expert] specializing in [narrow domain]"
- **Numbered workflow** — one action per step, action verbs only
- **Gotchas** — non-obvious facts the agent will get wrong without being told
- **2+ examples** — realistic input → complete (non-truncated) output
- **`## Impact Report` section** — at the end of SKILL.md. States exactly what files are created, modified, or moved, and what the agent delivers in chat after the skill runs. Required for every skill.
- **File-output logging** — if the skill generates any project files, it must append to `docs/skill-outputs/SKILL-OUTPUTS.md` and tell the user the file path. See `universal-skill-creator/templates/SKILL-OUTPUTS-template.md`.

**Quality standards (enforced):**
- No vague language: "fast", "easy", "intuitive", "modern", "robust" → replace with specific, testable criteria
- No negative constraints: "don't do X" → rewrite as "do Y instead"
- No placeholder text in published skills: TBD, TODO, `[fill in]`
- SKILL.md body under 200 lines — no exceptions. If it grows over 200 lines: invoke `split-skill`, which will first check if an existing skill can absorb the excess (link or marginally adapt), then extract a new child only if no existing skill fits, then call `skill-compressor`

### 3. Validate it

```bash
pip install -q skills-ref
agentskills validate .agents/skills/your-skill-name/
```

Must pass with zero errors before committing.

### 4. Test it

Before submitting, test with at least one trigger prompt in a real agent. Include that test prompt in your PR description:

```
Test prompt: "help me write a sprint retrospective for last week's sprint"
Expected: sprint-retro skill loads, asks for team size and sprint duration
```

### 5. Update the README

Add a row to the Skills table in `README.md`:

```markdown
| [`your-skill-name`](.agents/skills/your-skill-name/) | What it does | "trigger phrase 1", "trigger phrase 2" |
```

### 6. Commit

```bash
git add .agents/skills/your-skill-name/ README.md
git commit -m "feat: add your-skill-name skill"
```

---

## Skill Tiers

Choose the right complexity for the job:

| Tier | Structure | When to Use |
|------|-----------|-------------|
| **Atomic** | `SKILL.md` only | Self-contained task, no external reference needed |
| **Standard** | + `references/` | Task needs lookup tables, API docs, or long examples |
| **Advanced** | + `scripts/` | Needs deterministic automation or validation |
| **System** | + `assets/` + `agents/openai.yaml` | Full workflow with output templates + Codex UI |

Start Atomic. Promote to Standard when the agent consistently needs reference material mid-task. Never promote to avoid the 200-line limit — use `split-skill` or `skill-compressor` instead.

---

## Skill Author Checklist

Before every commit:

**Frontmatter**
- [ ] File starts with `---` on line 1 (no blank lines before it)
- [ ] `name` is lowercase, hyphens-only, matches directory name exactly
- [ ] `description` has trigger keywords, action verbs, synonyms
- [ ] `metadata.category` is set to `meta`, `thinking`, `project-specific`, or `domain`
- [ ] No unknown top-level fields (custom fields go under `metadata:`)

**Body**
- [ ] Expert role defined in first paragraph
- [ ] Workflow steps numbered, one action each, action verbs
- [ ] Gotchas section with specific non-obvious facts
- [ ] At least 2 examples with realistic inputs and complete outputs
- [ ] Output format defined as schema or template (not prose)
- [ ] Verification checklist included
- [ ] All constraints phrased positively
- [ ] Under 200 lines — invoke `split-skill` if over (it handles link-first, then extract, then compress)
- [ ] `## Impact Report` section present at end of SKILL.md
- [ ] If skill generates files: `docs/skill-outputs/SKILL-OUTPUTS.md` logging instruction included

**Cross-platform**
- [ ] Installs in `.agents/skills/` (universal location)
- [ ] `agentskills validate` passes with zero errors
- [ ] Test prompt confirmed working in at least one real agent

---

## Skill Relationships

Full skill reference: `docs/SKILL-INDEX.md` — definitions, triggers, outputs, call graph.

When adding a skill, consider how it chains with existing ones:

```
# Domain skill chain
brainstorming → prd-writing → [your skill here]

# Meta skill chain (called automatically — you don't invoke these directly)
universal-skill-creator → research-skill, validate-skills, publish-skill (optional)
improve-skills          → validate-skills, prune-skill, research-skill,
                           split-skill, skill-compressor, deprecate-skill
```

If your skill naturally follows or precedes an existing skill, add a handoff note at the end of your SKILL.md. Example: "Once the design is approved, invoke the `prd-writing` skill."

If your new skill duplicates a sub-workflow from an existing skill, flag it — `split-skill` will first check if one of the existing skills can be linked to or marginally adapted, and only extracts a new shared child if no existing skill fits.

## Meta Skills Available to You

You don't need to manage these manually — they're called by `improve-skills` and `universal-skill-creator`. But you can invoke any of them directly:

| Meta skill | What it does | When to call directly |
|---|---|---|
| `validate-skills` | Read-only health check, scores all skills | Before committing any skill change |
| `improve-skills` | Full improvement cycle for one or all skills | When skills feel stale or weak |
| `prune-skill` | Removes outdated/disproven content | When a model update makes techniques obsolete |
| `research-skill` | Live domain research | When you want evidence before writing a skill |
| `skill-compressor` | Trims skill to under 200 lines | When a skill grows past the limit |
| `split-skill` | Links to existing skill or extracts a new child — always checks existing skills first | When a skill is >200 lines and CORE content can't be compressed away |
| `deprecate-skill` | Retires a redundant skill cleanly | When two skills overlap or a domain is model-native |
| `publish-skill` | Publishes to skills.sh | When you want to share a skill publicly |

---

## Resources

- [agentskills.io specification](https://agentskills.io/specification)
- [agentskills.io best practices](https://agentskills.io/skill-creation/best-practices)
- [anthropics/skills](https://github.com/anthropics/skills) — reference quality bar
- [openai/skills](https://github.com/openai/skills) — Codex patterns
- [warpdotdev/oz-skills](https://github.com/warpdotdev/oz-skills) — parameterized skill patterns
- [obra/superpowers](https://github.com/obra/superpowers) — workflow enforcement patterns
