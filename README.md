# cross-plat-skills

> A personal library of agent skills that work across every major AI coding tool — write once, run everywhere.

Skills follow the [agentskills.io](https://agentskills.io/specification) open standard and work with Codex CLI, Ampcode, Claude Code, Warp, Gemini CLI, GitHub Copilot, Cursor, VS Code, Replit, Factory.ai, and Bolt.new.

---

## Installation (One Time, Any Machine)

Clone the repo once and run the install script. Your skills become globally available in every tool, in every project — no per-project setup needed.

```bash
git clone https://github.com/dvy1987/cross-plat-skills.git ~/.cross-plat-skills
cd ~/.cross-plat-skills
bash install.sh
```

That's it. Open any project in Codex, Warp, Claude Code, Gemini — your skills are already there.

### Updating Later

When new skills are added to this repo:

```bash
bash ~/.cross-plat-skills/install.sh --update
```

Pulls the latest from git and refreshes all symlinks instantly. No reinstall, no restart needed (except Codex CLI which needs one restart if already running).

---

## How It Works

Every platform reads `~/.agents/skills/` as the global user-level skills folder. The install script symlinks each skill there once:

```
~/.agents/skills/
├── universal-skill-creator/   → ~/.cross-plat-skills/.agents/skills/universal-skill-creator/
├── improve-skills/            → ~/.cross-plat-skills/.agents/skills/improve-skills/
├── brainstorming/             → ~/.cross-plat-skills/.agents/skills/brainstorming/
├── prd-writing/               → ~/.cross-plat-skills/.agents/skills/prd-writing/
├── research-skill/            → ~/.cross-plat-skills/.agents/skills/research-skill/
├── skill-compressor/          → ~/.cross-plat-skills/.agents/skills/skill-compressor/
└── split-skill/               → ~/.cross-plat-skills/.agents/skills/split-skill/
```

A symlink means `git pull` is all you ever need — platforms see the updated skill immediately.

| Platform | Reads global skills from |
|----------|--------------------------|
| Codex CLI | `~/.agents/skills/` |
| Ampcode | `~/.agents/skills/` |
| Claude Code | `~/.claude/skills/` or `~/.agents/skills/` |
| Warp | `~/.agents/skills/` |
| Gemini CLI | `~/.agents/skills/` |
| GitHub Copilot CLI | `~/.agents/skills/` |
| Cursor | `~/.agents/skills/` |
| Factory.ai | `~/.factory/skills/` or `~/.agents/skills/` |
| Replit | Project-level only (`/.agents/skills/`) |
| Bolt.new | Project-level only (`/.agents/skills/`) |

---

## Skills in This Repo

### Domain Skills
These are the skills you use directly in your daily work:

| Skill | What it does | Trigger phrases |
|-------|-------------|-----------------|
| [`brainstorming`](.agents/skills/brainstorming/) | Design before code — turns ideas into approved design docs, hard gate prevents any implementation until you sign off | "brainstorm", "design this feature", "what's the best approach for" |
| [`prd-writing`](.agents/skills/prd-writing/) | Discovery interview → structured PRD (Full, Lean, One-Pager, or Technical format) | "write a PRD", "document requirements", "create a spec" |

### Meta Skills
This repo is self-managing. These skills maintain, improve, and grow the skill library itself. You can invoke them directly but they mostly call each other automatically:

| Skill | What it does | When to call it |
|-------|-------------|-----------------|
| [`universal-skill-creator`](.agents/skills/universal-skill-creator/) | Creates new cross-platform skills from scratch — runs live research, writes, validates, splits/compresses if needed | "create a skill for X", "build a skill that does Y" |
| [`improve-skills`](.agents/skills/improve-skills/) | Audits every skill in the repo, researches the domain, rewrites for quality, then splits/compresses to stay under 200 lines | "improve all skills", "skill audit", "upgrade skills with latest research" |
| [`research-skill`](.agents/skills/research-skill/) | Searches academic papers, practitioner blogs, and GitHub skill repos for a domain — returns structured findings | Called automatically by `universal-skill-creator` and `improve-skills` |
| [`skill-compressor`](.agents/skills/skill-compressor/) | Compresses any skill to under 200 lines by moving non-core content to `references/` — never degrades quality | Called automatically when a skill has only background content to trim |
| [`split-skill`](.agents/skills/split-skill/) | Extracts a coherent sub-capability into a child skill when a skill is too large to compress without losing nuance | Called automatically before compression when duplication or a natural seam exists |

### How the Meta Skills Work Together

```
User: "create a skill for X"          User: "improve all skills"
         ↓                                      ↓
universal-skill-creator            improve-skills
  → research-skill (research)         → research-skill (per skill)
  → split-skill (if >200, seam)       → split-skill (if >200, seam)
      → skill-compressor (cleanup)        → skill-compressor (cleanup)
  → skill-compressor (if no seam)     → skill-compressor (if no seam)
```

**Ordering rule:** Split before compress. Splitting preserves nuance by extracting to a child skill. Compression discards content. Wrong order = permanent loss of detail.

---

## Using Domain Skills

### Codex CLI

```bash
codex                         # start Codex in any project
/skills                       # list all available skills
$brainstorming                # invoke explicitly
$prd-writing                  # invoke explicitly

# Or just describe your task — Codex matches automatically:
"brainstorm ideas for our onboarding flow"
"write a PRD for the payments feature"
```

### Ampcode / Claude Code

```bash
claude   # or amp
"help me brainstorm approaches for this refactor"
"create a PRD for dark mode"
```

### Warp

```bash
/brainstorming
/prd-writing
/prd-writing for the new search feature    # pass context inline
```

### Gemini CLI / GitHub Copilot CLI

```bash
"let's brainstorm the analytics dashboard design"
"write requirements for the export feature"
```

---

## The Daily Workflow

Skills enforce a repeatable product discipline across every tool:

```
Codex:    "build a feature for data export"
               ↓ brainstorming skill loads
          One question at a time → 2-3 approaches → design approval
          Saves design doc to docs/specs/

Warp:     /prd-writing
               ↓ prd-writing reads the design doc from docs/specs/
          Skips already-answered questions → structured PRD

Ampcode:  "implement the PRD we just wrote"
               ↓ agent reads PRD, builds from spec
          No vibe coding — builds from an approved spec
```

Same skills, chained across tools. Your entire product workflow — idea → design → spec → code — is version-controlled and portable across every machine and AI tool.

---

## Adding Skills to a Specific Project

To give teammates a skill without requiring them to install the repo:

```bash
cd your-project/
cp -r ~/.agents/skills/prd-writing .agents/skills/
git add .agents/skills/prd-writing
git commit -m "chore: add prd-writing skill for team"
```

Any teammate using Codex, Warp, Ampcode etc. in that repo gets the skill automatically.

---

## Adding New Skills to This Library

Use the `universal-skill-creator` skill — it handles research, writing, splitting, and compression automatically:

```bash
# In any AI tool with the skill installed:
"create a skill for writing sprint retrospectives"
"build a skill for code review"
"make a skill for writing changelog entries"
```

Or scaffold manually then fill in:

```bash
python .agents/skills/universal-skill-creator/scripts/skill_scaffold.py \
  --name my-skill \
  --tier atomic \
  --author dvy1987
```

Then commit and run `install.sh --update` on any machine.

---

## Improving Existing Skills

```bash
# In any AI tool:
"improve all skills"             # full library audit + research-backed rewrites
"improve the brainstorming skill"   # single skill
```

`improve-skills` will score each skill against a 7-criterion rubric, run live research on the domain, rewrite for quality, then split and compress to stay under 200 lines.

---

## Resources

- [agentskills.io specification](https://agentskills.io/specification)
- [agentskills.io best practices](https://agentskills.io/skill-creation/best-practices)
- [anthropics/skills](https://github.com/anthropics/skills) — Anthropic reference skills
- [openai/skills](https://github.com/openai/skills) — Official Codex skills catalog
- [warpdotdev/oz-skills](https://github.com/warpdotdev/oz-skills) — Warp curated skills
- [github/awesome-copilot](https://github.com/github/awesome-copilot) — Community skills collection
- [obra/superpowers](https://github.com/obra/superpowers) — Battle-tested brainstorming + dev workflow skills
- [SkillReducer paper (arXiv:2603.29919)](https://arxiv.org/abs/2603.29919) — Research backing the 200-line limit and compression approach
- [Agent Skills survey (arXiv:2602.12430)](https://arxiv.org/abs/2602.12430) — 2026 comprehensive survey on agent skill architecture

---

*MIT licensed — fork, adapt, use freely.*
