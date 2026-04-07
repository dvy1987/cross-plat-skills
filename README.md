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

Three categories of skills — **[`docs/SKILL-INDEX.md`](docs/SKILL-INDEX.md)** is the complete reference: triggers, outputs, file paths, terminal notifications, call graph, and category definitions for every skill.

### What Each Category Means

**Meta skills** manage the skill library itself — creating, improving, validating, compressing, and publishing other skills. Always global. You interact with two directly; the rest are called automatically.

**Thinking skills** are structured thinking frameworks that work in any context — product decisions, engineering choices, personal decisions, creative work. Always global. Each one encodes a proven method so the agent applies it rigorously: brainstorming (structured design before code), inversion (flip the problem 180°), adversarial hat (systematic critique). More thinking frameworks will be added here over time.

**Project-specific skills** are workflows that recur across most or all projects. Installed globally, but the files they generate always land inside the current project (`docs/specs/`, `docs/prd/`, `docs/product-soul.md`).

**Domain skills** are specialized workflows useful for some projects but not all — story writing, dramatization, academic paper structuring, etc. Currently empty. Built only when a specific project needs them.

---

### Thinking Skills

| Skill | What it does | Output / Outcome | Trigger phrases |
|-------|-------------|-----------------|----------------|
| [`brainstorming`](.agents/skills/brainstorming/) | Structured dialogue that turns rough ideas into approved design docs — hard gate prevents any code until you sign off | **File created:** `docs/specs/YYYY-MM-DD-<topic>-design.md` committed + logged | "brainstorm", "design this feature", "what's the best approach for" |
| [`inversion`](.agents/skills/inversion/) | Flip goal 180° — Failure Inversion (what guarantees failure?) + Opposite Goal (are we accidentally pursuing the reverse?). Fast and focused. | No files. Inverted view + forward actions in chat. | "invert this", "flip this problem", "what would guarantee failure" |
| [`adversarial-hat`](.agents/skills/adversarial-hat/) | Structured adversarial critic — three phases: diagnostic, creative, challenge. Every critique cites specific evidence. | No files unless integration requested. Delivers Critical/Significant/Minor findings in chat. | "stress test this", "red team this plan", "find the flaws", "devil's advocate" |
| [`pre-mortem`](.agents/skills/pre-mortem/) | Imagine it's already failed — extract root causes before they happen (Klein prospective hindsight). Ranks causes by impact × blindness. | No files. Ranked causes + prevention actions with owners in chat. | "pre-mortem", "imagine this fails", "what could go wrong before we start" |
| [`assumption-mapping`](.agents/skills/assumption-mapping/) | Surface every implicit assumption, restate as falsifiable claims, rank by importance × evidence. Finds what to test first. | No files. Assumption grid (Critical/Validated/Monitor) + minimum experiments in chat. | "map assumptions", "what must be true for this to work", "assumption audit" |
| [`socratic`](.agents/skills/socratic/) | Find the one sub-question that unlocks everything — follow the thread recursively until the path forward is clear. | No files. Decomposition path + keystone insight + next action in chat. | "help me think through this", "I keep going in circles", "break this down" |
| [`deep-thinking`](.agents/skills/deep-thinking/) | Orchestrator — diagnoses which of 9 frameworks fits your problem, guides you through them in sequence. Entry point for any deep reasoning need, including extreme ambiguity in PRD/brainstorming/product-soul. | No files. Multi-framework session with synthesis and concrete next action. | "deep thinking", "help me think through this properly", "what thinking tool should I use" |
| [`first-principles`](.agents/skills/first-principles/) | Strip a problem to irreducible truths, rebuild without convention. Produces solutions that bypass inherited constraints. | No files. Fundamental truths / conventional constraints / rebuilt solution in chat. | "think from first principles", "why does it have to work this way", "rebuild this from scratch" |
| [`second-order`](.agents/skills/second-order/) | Trace consequences across time — first, second, third order. Finds hidden risks (looks good now, bad later) and hidden opportunities (painful now, positive later). | No files. Consequence chain + time horizon map + risks/opportunities in chat. | "and then what", "unintended consequences", "long-term effects", "think ahead on this" |
| [`fermi`](.agents/skills/fermi/) | Decompose an unknown into estimable factors, produce a defensible order-of-magnitude answer. Converts "we don't know the numbers" into a decision. | No files. Factor tree + range + most uncertain factor + decision enabled in chat. | "ballpark this", "rough estimate", "how big is this market", "how many users" |
| [`ooda`](.agents/skills/ooda/) | Boyd's OODA loop for fast-moving situations — observe facts vs. assumptions, orient through context, decide and commit, act, set next loop trigger. | No files. OODA report with committed decision, owner, timeline, next loop trigger. | "what should we do right now", "competitive response", "we need to move fast" |

---

### Project-Specific Skills

| Skill | What it does | Output / Outcome | Trigger phrases |
|-------|-------------|-----------------|----------------|
| [`product-soul`](.agents/skills/product-soul/) | Writes `docs/product-soul.md` — strategic north star above any PRD. Five lenses: User, Business, Strategy, PMF, GTM. | **File created:** `docs/product-soul.md` + logged | "write the product soul", "product strategy doc", "product north star" |
| [`prd-writing`](.agents/skills/prd-writing/) | Discovery interview then structured PRD in your chosen format | **File created:** `docs/prd/YYYY-MM-DD-<feature>-prd.md` + logged to `docs/skill-outputs/SKILL-OUTPUTS.md` | "write a PRD", "document requirements", "create a spec" |
| [`implementation-plan`](.agents/skills/implementation-plan/) | Create a detailed, step-by-step implementation plan for a feature or project | **File created:** `docs/plans/YYYY-MM-DD-<feature>-plan.md` + logged | "plan a feature", "create a technical roadmap", "break down a PRD into tasks", "design an implementation strategy" |
| [`test-driven-development`](.agents/skills/test-driven-development/) | Apply the Red-Green-Refactor cycle to software development | **File created:** `tests/` and `src/` updates + logged | "test-driven development", "write tests first", "TDD this feature", "Red-Green-Refactor" |
| [`agent-system-architecture`](.agents/skills/agent-system-architecture/) | Design state-of-the-art multi-agent systems and orchestration patterns | **File created:** `docs/architecture/` + logged | "build an agent system", "design agent orchestration", "multi-agent wiring" |
| [`architectural-decision-log`](.agents/skills/architectural-decision-log/) | Capture the "why" behind technical choices to prevent architectural drift | **File created:** `docs/adr/` + logged | "record a decision", "write an ADR", "why did we do this" |
| [`technical-debt-audit`](.agents/skills/technical-debt-audit/) | Audit the project's technical health and identify "high-interest" debt | **File created:** `docs/reports/` + logged | "technical debt audit", "where is the code messy", "assess project health" |
| [`changelog-generator`](.agents/skills/changelog-generator/) | Generate user-facing or internal release notes and changelogs | **File created:** `docs/changelogs/` + logged | "write a changelog", "prepare release notes", "summarize my commits" |


---

### Domain Skills

Specialized skills for specific types of projects — not universally applicable. **Currently empty.**
Build a domain skill when you need it: "create a skill for story writing" → `universal-skill-creator` handles it.

### Meta Skills
This repo is self-managing. These skills maintain, improve, and grow the skill library itself. You can invoke them directly but they mostly call each other automatically:

| Skill | What it does | Output / Outcome | When to call it |
|-------|-------------|-----------------|-----------------|
| [`universal-skill-creator`](.agents/skills/universal-skill-creator/) | Creates new cross-platform skills — live research, write, validate, split/compress | **Files created:** `.agents/skills/<name>/SKILL.md` + optional references/, scripts/. Impact report: tier, score, install path, test trigger, files created | "create a skill for X", "build a skill that does Y" |
| [`improve-skills`](.agents/skills/improve-skills/) | Full improvement cycle — validate, prune, research, rewrite, resize every skill | **Files modified:** every improved SKILL.md. Impact report: per-skill score deltas, sources used, all files touched | "improve all skills", "skill audit", "upgrade with latest research" |
| [`secure-skill`](.agents/skills/secure-skill/) | Mandatory security gate — scans for prompt injection, data exfiltration, credential theft, supply chain risks. 26.1% of community skills contain vulnerabilities. Self-protecting: cannot be modified by automated processes. | Security report (SAFE / BLOCKED / REQUIRES REVIEW) with findings by severity. | Automatic gate in research-skill, universal-skill-creator, improve-skills |
| [`validate-skills`](.agents/skills/validate-skills/) | Read-only health check — scores every skill, flags failures, size violations, duplicate triggers | **No files modified.** Structured quality report with P0/P1/P2/P3 actions | Pre-flight for `improve-skills`; quality gate after creation |
| [`prune-skill`](.agents/skills/prune-skill/) | Removes wrong, outdated, or poorly-cited content — every removal cites a source | **Files modified:** target SKILL.md pruned + Prune Log appended. Impact report: items pruned, corrected, flagged | First step of every `improve-skills` per-skill cycle |
| [`research-skill`](.agents/skills/research-skill/) | Searches papers, practitioner blogs, and GitHub skill repos — returns structured findings | **No files modified.** Returns findings report (GOTCHAS, WORKFLOW PATTERNS, FAILURE MODES) | Called by `universal-skill-creator` and `improve-skills` before writing |
| [`skill-compressor`](.agents/skills/skill-compressor/) | Moves non-core content to `references/` to bring SKILL.md under 200 lines | **Files modified:** SKILL.md trimmed + new references/ files created. Impact report: line reduction, files created | After `split-skill`, or directly when only background needs trimming |
| [`split-skill`](.agents/skills/split-skill/) | Extracts a reusable sub-capability into a new child skill | **Files created:** child SKILL.md. **Files modified:** parent SKILL.md, AGENTS.md. Impact report: line counts, callers updated | Before compression when a natural seam or duplication exists |
| [`deprecate-skill`](.agents/skills/deprecate-skill/) | Retires redundant or superseded skills — archives, updates callers, logs reason | **Files moved:** to `.agents/skills/.deprecated/`. **Files modified:** AGENTS.md, README, callers. Impact report: archive path, recovery command | When a skill scores 0-5/14 or is fully subsumed |
| [`publish-skill`](.agents/skills/publish-skill/) | Validates, packages, writes README if missing, publishes to skills.sh | **External action:** skill live on skills.sh. Impact report: registry URL, install command, score at publish | Optional after `universal-skill-creator` creates a skill |

### How the Meta Skills Work Together

```
User: "create a skill for X"          User: "improve all skills"
         ↓                                      ↓
universal-skill-creator            improve-skills
  → research-skill                    0. validate-skills  ← pre-flight, score all
  → split-skill (if >200, seam)          └ deprecate-skill ← if score 0-5/14
      → skill-compressor              Per skill:
  → skill-compressor (if no seam)     1. prune-skill       ← remove wrong content
  → validate-skills  (quality gate)   2. research-skill    ← add current research
  → publish-skill    (optional)       3. rewrite
                                       4. split/compress
                                       5. validate + commit
```

**Full ordering rationale:**
- **Validate first** — know what you’re dealing with before touching anything
- **Prune before research** — remove wrong content before adding new content
- **Research before rewrite** — ground improvements in current evidence
- **Split before compress** — splitting preserves nuance; compression discards permanently

---

## Using Skills

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
