# agent-loom

> A skill library for AI coding tools that maintains itself — stays current with research, prunes outdated advice, and improves over time.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![agentskills.io](https://img.shields.io/badge/standard-agentskills.io-blue)](https://agentskills.io/specification)

Skills follow the [agentskills.io](https://agentskills.io/specification) open standard and work with Codex CLI, Ampcode, Claude Code, Warp, Gemini CLI, GitHub Copilot, Cursor, VS Code, Replit, Factory.ai, and Bolt.new.

---

## What is this?

AI coding tools like Codex, Claude Code, Warp, and Cursor all support "skills" — reusable instruction files that teach agents how to do specific tasks (write a PRD, run a pre-mortem, create an ADR). So, agent skills form a crucial part of agent infra. The problem: best practices are rapidly evolving.  Models have moved on. Better techniques exist. Your skill library meanwhile has remained the same.

**agent-loom fixes this.** A self-improving meta layer researches current papers and practitioner patterns, prunes outdated content with a cited reason, rewrites from evidence, and validates before every commit. The library stays current without manual upkeep. It also installs once globally — available in every tool, every project, via symlinks.

The library now also includes a process-and-agent design layer for more complex work. Instead of jumping straight from user request to execution, it can decompose a task into a reusable process, decide whether a single skill or a broader agent structure is needed, validate the setup, and then execute through the orchestrator. See [docs/architecture.md](docs/architecture.md) for the current repo architecture.

---

## Installation (One Time, Any Machine)

Clone the repo once and run the install script. Your skills become globally available in every tool, in every project — no per-project setup needed.

**macOS / Linux:**
```bash
git clone https://github.com/dvy1987/agent-loom.git ~/.agent-loom
cd ~/.agent-loom
bash install.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/dvy1987/agent-loom.git $HOME\.agent-loom
cd $HOME\.agent-loom
.\install.ps1
```

That's it. Open any project in Codex, Warp, Claude Code, Gemini — your skills are already there.

### Updating Later

When new skills are added to this repo:

```bash
bash ~/.agent-loom/install.sh --update
```

Pulls the latest from git and refreshes all symlinks instantly. No reinstall, no restart needed (except Codex CLI which needs one restart if already running).

### Uninstalling

To cleanly remove all repo-managed skills from your global directories (reverting CLIs to their pre-install state):

**macOS / Linux:**
```bash
bash ~/.agent-loom/uninstall.sh
```

**Windows (PowerShell):**
```powershell
cd $HOME\.agent-loom
.\uninstall.ps1
```

Only removes symlinks/junctions that point into this repo — any skills you added yourself (real directories or links to other sources) are left untouched. Use `--dry-run` / `-DryRun` to preview what would be removed before committing.

After uninstalling, you can optionally delete the cloned repo itself:
```bash
rm -rf ~/.agent-loom           # macOS / Linux
Remove-Item -Recurse $HOME\.agent-loom  # Windows
```

> **Note:** Project-level skill copies (e.g., skills copied into a repo's `.agents/skills/` for Replit or teammates) are not affected by uninstall — they live in each project and must be removed manually if desired.

---

## How It Works

Every platform reads `~/.agents/skills/` as the global user-level skills folder. The install script symlinks each skill there once:

```
~/.agents/skills/
├── universal-skill-creator/   → ~/.agent-loom/.agents/skills/universal-skill-creator/
├── improve-skills/            → ~/.agent-loom/.agents/skills/improve-skills/
├── brainstorming/             → ~/.agent-loom/.agents/skills/brainstorming/
├── prd-writing/               → ~/.agent-loom/.agents/skills/prd-writing/
├── research-skill/            → ~/.agent-loom/.agents/skills/research-skill/
├── compress-skill/          → ~/.agent-loom/.agents/skills/compress-skill/
└── split-skill/               → ~/.agent-loom/.agents/skills/split-skill/
```

A symlink means `git pull` is all you ever need — platforms see the updated skill immediately.

| Platform | Reads global skills from | Notes |
|----------|--------------------------|-------|
| Codex CLI | `~/.agents/skills/` | |
| Ampcode | `~/.agents/skills/` | |
| Claude Code | `~/.claude/skills/` or `~/.agents/skills/` | |
| Warp | `~/.agents/skills/` | |
| Gemini CLI | `~/.agents/skills/` | |
| GitHub Copilot CLI | `~/.agents/skills/` | |
| Cursor | `~/.agents/skills/` | |
| Factory.ai | `~/.factory/skills/` or `~/.agents/skills/` | |
| Replit | Project-level only (`/.agents/skills/`) | No global install — copy skills into each project |
| Bolt.new | Project-level only (`/.agents/skills/`) | No global install — copy skills into each project |

> **Note:** Replit and Bolt.new don't read a global `~/.agents/skills/` folder, so the "run everywhere" claim has limits on those two platforms. For team sharing on those tools, see [Adding Skills to a Specific Project](#adding-skills-to-a-specific-project).

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
| [`generate-changelog`](.agents/skills/generate-changelog/) | Generate user-facing or internal release notes and changelogs | **File created:** `docs/changelogs/` + logged | "write a changelog", "prepare release notes", "summarize my commits" |
| [`project-setup`](.agents/skills/project-setup/) | Interview the user about skill gaps and project context, then generate a tailored AGENTS.md with orchestration map, boundaries, and skill routing | **File created:** `AGENTS.md` in project root + logged | "set up this project", "create an AGENTS.md", "bootstrap agents", "configure agents for my repo" |
| [`debug-and-fix`](.agents/skills/debug-and-fix/) | Systematically reproduce, root-cause, fix, and verify bugs — supports Linear issue integration and batch triage | No files. Root cause + fix + verification summary in chat. Linear updated if applicable. | "this is broken", "fix this bug", "why is this failing", "debug this" |
| [`reality-check`](.agents/skills/reality-check/) | Evaluate claims vs actual implementation — scoring truth, identifying gaps, competitive positioning, creative solutions, and actionable roadmap | **Files created:** `docs/YYYY-MM-DD-reality-check-findings.md` + `docs/YYYY-MM-DD-roadmap-and-implementation-plan.md` + logged | "reality-check", "evaluate claims", "is this real", "score these claims" |
| [`codebase-understanding`](.agents/skills/codebase-understanding/) | Map architecture, trace key flows, surface complexity hotspots — build a mental model before making changes | No files. Architecture overview + component map + hotspots in chat. | "understand this repo", "how does this work", "explain the architecture", "onboard me" |
| [`code-review-crsp`](.agents/skills/code-review-crsp/) | Review code changes against 6 criteria (correctness, completeness, conventions, tests, performance, completeness) with severity-classified findings | No files. Structured review with findings by severity in chat. | "review this code", "check this PR", "code review", "audit this diff" |
| [`project-orchestrator`](.agents/skills/project-orchestrator/) | Route requests to the right skill, decompose complex work into parallel subagents (platform-aware), manage phase transitions | No files unless parallel plan written to `docs/task-plan.md`. Orchestration plan + routing in chat. | "what should I do next", "orchestrate this", "split into parallel tasks", "which skill should I use" |

#### Agent & Process Design

| Skill | What it does |
|-------|-------------|
| [`process-decomposer`](.agents/skills/process-decomposer/) | Complexity triage + task decomposition into reusable process entries in `docs/processes/` |
| [`agent-builder`](.agents/skills/agent-builder/) | Designs single-agent or multi-agent execution structures from decomposed processes |
| [`setup-evaluation`](.agents/skills/setup-evaluation/) | Validates decomposition + architecture before execution — on PASS, hands off to `agent-launcher` |
| [`agent-launcher`](.agents/skills/agent-launcher/) | Launches agents from a validated architecture spec using native platform parallelism (Task tool). **Claude Code and Ampcode only** — see platform note below. |
| [`skill-finder`](.agents/skills/skill-finder/) | Maps capabilities to existing skills and prevents unnecessary skill creation |
| [`tool-finder`](.agents/skills/tool-finder/) | Tool discovery, availability checking, and MCP setup guidance |
| [`create-agent-prompt`](.agents/skills/create-agent-prompt/) | Creates focused role prompts for agents in multi-agent topologies |

This design layer sits above execution. The current flow is:

```
process-decomposer → agent-builder (if needed) → setup-evaluation
  └── PASS → agent-launcher → [agents run] → project-orchestrator
  └── FAIL → agent-builder (revise)
```

That gives the repo a reusable process-memory layer instead of treating every complex request as a one-off.

> **Platform note — `agent-launcher`:** This skill uses the built-in **Task tool** for native parallel subagent spawning. It works on **Claude Code and Ampcode** (Tier 1 — Task tool available). It is installed globally on all platforms but will halt gracefully on unsupported ones with a clear message. For Warp, Factory.ai, and Gemini without Maestro (Tier 2), `project-orchestrator` handles orchestration via a file-based task plan instead.

#### Full Execution Flow — Example: Annual Compliance Audit

This shows what actually happens from user prompt to output. Everything below the first line runs invisibly — the user only ever talks to `project-orchestrator`.

```
User: "run the annual compliance audit"
        ↓
project-orchestrator
  reads project state → no prior process entry found
  classifies: complex, parallel tracks, live system access needed → agent-chain
  routes to: process-decomposer
        ↓
process-decomposer
  outcome defined: "findings report per domain, risk-ranked remediation plan"
  decomposes into 4 parallel tracks (all independent, no shared file writes):
    - privacy-agent    (GDPR / SOC2 — scans data handling, retention policies)
    - access-agent     (IAM — queries access control systems, flags stale permissions)
    - security-agent   (vulnerability scan, dependency audit, secrets check)
    - vendor-agent     (third-party risk — reviews vendor contracts, certifications)
  complexity_class: agent-chain
  writes: docs/processes/2026-04-11-compliance-audit.md
        ↓
agent-builder
  topology: parallel (all 4 tracks independent)
  merge strategy: project-orchestrator collates into executive summary
  failure handling: non-blocking — failed domain flagged, others continue
  writes: docs/architecture/2026-04-11-compliance-audit-arch.md
        ↓
setup-evaluation
  checks: no shared file writes ✓  prompts complete ✓  handoffs defined ✓
  → PASS
        ↓
agent-launcher  [Claude Code / Ampcode only]
  writes launch manifest: docs/agents/runs/2026-04-11-compliance-manifest.md
  spawns 4 agents concurrently via Task tool:
    privacy-agent  → docs/handoffs/privacy-output.md
    access-agent   → docs/handoffs/access-output.md
    security-agent → docs/handoffs/security-output.md
    vendor-agent   → docs/handoffs/vendor-output.md
  monitors docs/handoffs/ for completion
        ↓
[agents work independently — each queries real systems, discovers findings,
 writes structured output. access-agent finds 3 stale admin accounts and
 flags them; security-agent finds 2 exposed secrets in CI config.]
        ↓
project-orchestrator
  all 4 outputs present
  synthesises into: docs/reports/2026-04-11-compliance-report.md
  risk-ranks findings across all domains
  updates docs/skill-outputs/SKILL-OUTPUTS.md
  updates process entry with execution feedback (learning loop)
  recommends next phase: remediation planning
```

#### When Agents Are Actually Needed

Not every task requires this pipeline. A single well-prompted LLM call is faster, simpler, and cheaper for most work. Agents justify themselves only when:

- **The task requires live system access** — querying real databases, IAM systems, APIs, or filesystems, and reacting to what's found. You can't pre-load the answer because the answer depends on what's actually there.
- **There are feedback loops** — the agent does something, observes the result, decides the next action. The sequence can't be written in advance because step N's input depends on step N-1's output.
- **Parallelism saves meaningful time** — 4 independent tracks × 20 min each = 80 min sequential vs 20 min parallel. Worth the overhead.
- **Context is too large for one call** — scanning a large codebase or 200 support tickets requires selective navigation, not a single context window.

If none of those apply, use a skill directly. The orchestrator will tell you.

#### Current Limitations

The pipeline handles well-scoped, parallel, statically-defined work where the task shape is known before execution starts. It does not yet support:

- **Dynamic branching** — if an agent discovers something unexpected mid-run, it cannot signal back to change the plan. Topology is fixed at architecture time.
- **Conditional spawning** — no support for "if Agent A finds X, spawn Agent B, otherwise skip."
- **Replanning on failure** — `agent-launcher` retries once then halts. It does not replan around a failed agent or find an alternative path.
- **Chunking large contexts** — no built-in strategy for when the artefact being analysed exceeds one agent's context window.

These are on the roadmap. The current system covers the majority of real parallel agent use cases cleanly.

---

### Domain Skills

Specialized skills for specific types of projects — not universally applicable. **Currently empty.**
Build a domain skill when you need it: "create a skill for story writing" → `universal-skill-creator` handles it.

### Meta Skills

The library is self-managing. Say "improve all skills" and the meta layer takes over — it researches current papers and practitioner patterns, prunes anything outdated with a cited reason, rewrites from evidence, validates, and commits. The ordering is principled: prune before research, research before rewrite. You never manually maintain a skill.

You interact with two meta skills directly. The rest call each other automatically:

| Skill | What it does | Output / Outcome | When to call it |
|-------|-------------|-----------------|-----------------|
| [`universal-skill-creator`](.agents/skills/universal-skill-creator/) | Creates new cross-platform skills — live research, write, validate, split/compress | **Files created:** `.agents/skills/<name>/SKILL.md` + optional references/, scripts/. Impact report: tier, score, install path, test trigger, files created | "create a skill for X", "build a skill that does Y" |
| [`improve-skills`](.agents/skills/improve-skills/) | Full improvement cycle — validate, prune, research, rewrite, resize every skill | **Files modified:** every improved SKILL.md. Impact report: per-skill score deltas, sources used, all files touched | "improve all skills", "skill audit", "upgrade with latest research" |
| [`secure-skill`](.agents/skills/secure-skill/) | Mandatory quality gate — runs automatically during skill creation, improvement, and ingestion. Self-protecting. | Quality report (SAFE / BLOCKED / REQUIRES REVIEW) with findings by severity. | Automatic gate in research-skill, universal-skill-creator, improve-skills |
| [`validate-skills`](.agents/skills/validate-skills/) | Read-only health check — scores every skill, flags failures, size violations, duplicate triggers | **No files modified.** Structured quality report with P0/P1/P2/P3 actions | Pre-flight for `improve-skills`; quality gate after creation |
| [`prune-skill`](.agents/skills/prune-skill/) | Removes wrong, outdated, or poorly-cited content — every removal cites a source | **Files modified:** target SKILL.md pruned + Prune Log appended. Impact report: items pruned, corrected, flagged | First step of every `improve-skills` per-skill cycle |
| [`research-skill`](.agents/skills/research-skill/) | Searches papers, practitioner blogs, and GitHub skill repos — returns structured findings | **No files modified.** Returns findings report (GOTCHAS, WORKFLOW PATTERNS, FAILURE MODES) | Called by `universal-skill-creator` and `improve-skills` before writing |
| [`compress-skill`](.agents/skills/compress-skill/) | Moves non-core content to `references/` to bring SKILL.md under 200 lines | **Files modified:** SKILL.md trimmed + new references/ files created. Impact report: line reduction, files created | After `split-skill`, or directly when only background needs trimming |
| [`split-skill`](.agents/skills/split-skill/) | Extracts a reusable sub-capability into a new child skill | **Files created:** child SKILL.md. **Files modified:** parent SKILL.md, AGENTS.md. Impact report: line counts, callers updated | Before compression when a natural seam or duplication exists |
| [`deprecate-skill`](.agents/skills/deprecate-skill/) | Retires redundant or superseded skills — archives, updates callers, logs reason | **Files moved:** to `.agents/skills/.deprecated/`. **Files modified:** AGENTS.md, README, callers. Impact report: archive path, recovery command | When a skill scores 0-5/14 or is fully subsumed |
| [`library-skill`](.agents/skills/library-skill/) | Maintains library consistency — syncs SKILL-INDEX, AGENTS.md, README, skill graph after structural changes | **Files modified:** SKILL-INDEX.md, AGENTS.md, README.md, docs/skill-graph.md. Impact report: entries added/removed, cross-refs validated | Auto-called after skill creation, rename, deprecation, or restructure |
| [`publish-skill`](.agents/skills/publish-skill/) | Validates, packages, writes README if missing, publishes to skills.sh | **External action:** skill live on skills.sh. Impact report: registry URL, install command, score at publish | Optional after `universal-skill-creator` creates a skill |
| [`skill-deconflict`](.agents/skills/skill-deconflict/) | Detects naming collisions, overlapping triggers, and insufficient intent diversity across the skill library | No files. Deconflict report in chat. | Called by universal-skill-creator and improve-skills; also "deconflict skills", "check naming" |
| [`skill-routing`](.agents/skills/skill-routing/) | Matches requests to skills using trigger matching, project context, conversation history; scores ambiguity 1-10 | No files. Routing decision in chat. | Called by project-orchestrator; also "which skill should handle this", "route this request" |

### How the Meta Skills Work Together

```
User: "create a skill for X"          User: "improve all skills"
         ↓                                      ↓
universal-skill-creator            improve-skills
  → research-skill                    0. validate-skills  ← pre-flight, score all
  → split-skill (if >200, seam)          └ deprecate-skill ← if score 0-5/14
  → compress-skill (if no seam)       Per skill:
  → skill-deconflict (name/trigger gate) 1. prune-skill       ← remove wrong content
  → validate-skills  (quality gate)      2. research-skill    ← add current research
  → library-skill (sync indexes)         3. rewrite
  → publish-skill    (optional)          4. split/compress
                                         5. validate + commit
                                         6. library-skill → generate-changelog
```

**Full ordering rationale:**
- **Validate first** — know what you're dealing with before touching anything
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

Any teammate using Codex, Warp, Ampcode etc. in that repo gets the skill automatically. This is also the recommended approach for **Replit and Bolt.new**, which don't support global skill installs.

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

## Keeping Skills Current

The library updates itself. Run this in any AI tool:

```bash
# In any AI tool:
"improve all skills"             # full library audit + research-backed rewrites
"improve the brainstorming skill"   # single skill
```

The meta layer researches current papers and practitioner patterns, prunes anything outdated with a cited reason, rewrites from evidence, and validates before committing. You don't maintain skills manually — you trigger the cycle and review the result.

---

## Architecture

The repo now has three practical layers:

- Skill library: reusable skills in `.agents/skills/`
- Control plane: `.agents/ROUTING.md` and `docs/SKILL-INDEX.md`
- Process-and-agent design layer: reusable process decomposition, agent structure design, setup validation, and orchestrated execution

This keeps the project lightweight. It is still a portable skill library, not a full agent runtime or workflow engine. The current-state architecture is documented in [docs/architecture.md](docs/architecture.md).

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

## Deferred / TODO

These skills are still deferred and will be created via `skill-finder` when demand emerges:

- `knowledge-indexer` — indexes project knowledge sources; deferred until RAG is ready
- `create-system-prompt` — system prompts for agent identity + constraints
- `create-task-prompt` — one-time instructions for specific execution steps
- `create-skill-prompt` — prompts for invoking skills correctly

---

*MIT licensed — fork, adapt, use freely.*
