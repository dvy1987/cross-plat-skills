# Product Requirements Document — agent-loom

**Status:** Living Document (source of truth)
**Last updated:** 2026-04-12
**Owner:** Divya
**Point-in-time PRDs:** See dated files in this directory for historical snapshots.

---

## 1. What Is agent-loom?

agent-loom is a self-maintaining, cross-platform agent skill library with a process-reasoning layer. It installs once, works in every major AI coding tool, stays current without manual upkeep, and can reason about complex execution structure before running.

Three principles:
1. **Cross-platform by default** — one install, all tools
2. **Self-improving** — a meta layer manages the library itself
3. **Evidence-grounded** — every improvement is backed by research, every removal is cited

One architectural direction:
4. **Process reasoning before execution** — reusable process decomposition and agent-structure design for complex workflows

---

## 2. Target Users

| User | Primary Need |
|------|-------------|
| Solo AI developer (2–4 tools) | One skill install that works everywhere |
| Product-minded engineer | Structured workflows for PRDs, specs, brainstorming alongside code |
| Team lead | Shareable, version-controlled skills enforcing team standards |
| AI tooling researcher | Community reference library tracking current best practices |

---

## 3. Goals

- Cross-platform skill library: installs once globally, works in Codex CLI, Ampcode, Claude Code, Warp, Gemini CLI, GitHub Copilot, Cursor, VS Code, Factory.ai
- Self-improving meta layer: researches papers, prunes outdated content, rewrites from evidence, validates before committing
- Four skill categories: meta, thinking, project-specific, domain (on-demand)
- Reusable process-and-agent design layer: decomposition, triage, architecture, setup validation, execution feedback
- Strict quality: every skill ≤200 lines, agentskills.io validation passing, score ≥10/14
- Clean install/uninstall scripts for macOS/Linux (bash) and Windows (PowerShell)
- [agentskills.io](https://agentskills.io/specification) open standard compliance

## Non-Goals

- Proprietary skill format or platform-specific solution
- Hosting a skill registry (skills.sh publishing is optional)
- GUI tooling — CLI/agent-native only
- Full standalone agent runtime or enterprise workflow engine
- Global install support for Replit and Bolt.new (project-level only)

---

## 4. Current Skill Inventory

**49 skills** across 4 categories as of 2026-04-13.

### 4.1 Meta Skills (18)

Manage the library itself. Always global. Users interact directly with `universal-skill-creator` and `improve-skills`; the rest are called automatically.

| Skill | Purpose |
|-------|---------|
| `universal-skill-creator` | Creates new cross-platform skills via research, write, validate, resize |
| `improve-skills` | Full improvement cycle: validate → prune → research → rewrite → resize |
| `validate-skills` | Read-only health check, scores every skill |
| `research-skill` | Searches papers, blogs, GitHub repos for domain best practices |
| `prune-skill` | Removes outdated/disproven content with cited reasons |
| `compress-skill` | Moves non-core content to references/ to enforce 200-line limit |
| `split-skill` | Extracts reusable sub-capabilities into child skills |
| `deprecate-skill` | Retires redundant skills, archives, updates callers |
| `library-skill` | Syncs SKILL-INDEX, AGENTS.md, README, skill-graph, PRD, architecture after structural changes |
| `publish-skill` | Packages and publishes to skills.sh or GitHub |
| `cross-link-skills` | Repairs cross-references between SKILL.md files after creation/rename/removal |
| `skill-finder` | Maps capabilities to existing skills, prevents sprawl |
| `tool-finder` | Tool discovery, availability checking, MCP setup guidance |
| `secure-skill` | Security orchestrator: 6 core checks before any external content enters |
| `secure-skill-content-sanitization` | Strips hidden text, zero-width chars, homoglyphs |
| `secure-skill-repo-ingestion` | Repo-specific: poisoned examples, dependency scan, path attacks |
| `secure-skill-runtime` | Runtime: state corruption, skill overwrites, DoS prevention |
| `generate-changelog` | Generates release notes and changelogs |

### 4.2 Thinking Skills (11)

Structured reasoning frameworks. Always global. Platform-agnostic. Output is always in chat.

| Skill | Method |
|-------|--------|
| `brainstorming` | Structured dialogue → design doc; hard gate blocks code until approved |
| `deep-thinking` | Orchestrator for 9 frameworks; entry point for any deep reasoning |
| `inversion` | Flip goal 180°: what guarantees failure? |
| `adversarial-hat` | Three-phase critic: diagnostic → creative → challenge |
| `pre-mortem` | Klein prospective hindsight: imagine failure, rank causes |
| `assumption-mapping` | Surface assumptions as falsifiable claims, rank by importance |
| `socratic` | Recursive decomposition to find the keystone sub-question |
| `first-principles` | Strip to irreducible truths, rebuild without convention |
| `second-order` | Trace consequences: first → second → third order |
| `fermi` | Decompose unknowns into estimable factors |
| `ooda` | Boyd's OODA loop for fast-moving situations |

### 4.3 Project-Specific Skills (17)

Global install, project-scoped output. Cover the full product and engineering lifecycle.

| Skill | Purpose |
|-------|---------|
| `product-soul` | Strategic north star: User, Business, Strategy, PMF, GTM |
| `prd-writing` | Discovery interview → structured PRD |
| `implementation-plan` | Step-by-step technical implementation plan |
| `test-driven-development` | Red-Green-Refactor cycle |
| `code-review-crsp` | 6-criteria review with severity-classified findings |
| `debug-and-fix` | Reproduce → root-cause → fix → verify |
| `technical-debt-audit` | Project health audit, identifies high-interest debt |
| `agent-system-architecture` | Multi-agent system design and orchestration patterns |
| `architectural-decision-log` | Captures the "why" behind technical choices |
| `codebase-understanding` | Maps architecture, traces flows, surfaces hotspots |
| `project-setup` | Generates tailored AGENTS.md for any project |
| `project-orchestrator` | Routes requests, decomposes complex work, manages phases |
| `process-decomposer` | Conversational problem understanding + complexity triage + decomposition |
| `problem-to-plan` | Produces mini-spec, detailed plan, and TODO.md from a problem description |
| `agent-builder` | Designs single/multi-agent execution structures from processes |
| `setup-evaluation` | Pre-execution QA gate for agent-chain workflows |
| `create-agent-prompt` | Creates role prompts for agents in multi-agent topologies |
| `agent-creator` | Launches agents from validated specs via Task tool (Claude Code / Ampcode only) |
| `learn-from-paper` | Extracts actionable knowledge from research papers |
| `apply-paper-to-project` | Applies paper findings to the current codebase |

### 4.4 Domain Skills (0)

Specialized, not universally needed. **Currently empty.** Built on demand via `universal-skill-creator`.

---

## 5. Architecture Overview

Three layers:

1. **Distribution Layer** — repo cloned once; symlinks into tool-recognized global skill directories
2. **Control Layer** — `.agents/ROUTING.md` (routing precedence) + `docs/SKILL-INDEX.md` (catalog + call graph)
3. **Skill Layer** — `.agents/skills/` organized by role: meta, thinking, project-specific, security, domain

Plus a **Process-and-Agent Design Layer** for complex workflows:

```
process-decomposer → agent-builder (if needed) → setup-evaluation
  └── PASS → agent-creator → [agents run] → project-orchestrator
  └── FAIL → agent-builder (revise)
```

Complexity triage routes tasks:
| Class | Route |
|-------|-------|
| `exact-match` | Replay via project-orchestrator |
| `single-skill` | Route directly to skill |
| `needs-deliverables` | Route to problem-to-plan (spec + plan + TODO) |
| `skill-chain` | Decompose, skip architecture, execute via orchestrator |
| `agent-chain` | Full pipeline + setup-evaluator after architecture spec |

### Example Flow: "I want to do X"

When a user brings any request, here is the skill chain that fires:

```
1. project-orchestrator (always the entry point)
   ├── Silent scan: what exists? (product-soul? specs? PRD? plans? code?)
   ├── Classify the request
   │
   ├─► Simple request (maps to 1 skill)
   │   └── Route directly (e.g., "write a PRD" → prd-writing)
   │
   └─► Complex / unclear request
       └── 2. process-decomposer
           ├── Step 0: Understand the problem (conversational Q&A, 1-2 questions)
           ├── Step 1: Triage (check process registry, assess complexity)
           │
           ├─► single-skill     → Route to skill, DONE
           │
           ├─► needs-deliverables → 3. problem-to-plan
           │                        ├── Write mini-spec   → docs/specs/
           │                        ├── Write detail plan  → docs/plans/
           │                        └── Generate TODO.md   → docs/plans/
           │                            └── Agents pick up tasks
           │
           ├─► skill-chain      → Decompose into steps
           │                     └── project-orchestrator executes in order
           │
           └─► agent-chain      → Decompose into steps
                                 └── 4. agent-builder (design topology)
                                     └── 5. setup-evaluation (validate)
                                         ├─► PASS → 6. agent-creator (spawn)
                                         └─► FAIL → back to agent-builder
```

**Concrete example:** User says "The narration agent crashes when the API key is missing — fix this and add error handling."

1. **project-orchestrator** scans: code exists, this is an implementation-phase request. Complex enough to need planning. Routes to process-decomposer.
2. **process-decomposer** Step 0: "I see `agents/narration/agent.py` calls ElevenLabs with no try/except. You want graceful error handling for missing keys and API failures — correct?" User confirms.
3. **process-decomposer** Step 1: No process match. User needs planning deliverables. Routes to problem-to-plan.
4. **problem-to-plan** produces three files:
   - `docs/specs/2026-04-12-narration-error-handling-spec.md` (the "what")
   - `docs/plans/2026-04-12-narration-error-handling-plan.md` (the "how")
   - `docs/plans/2026-04-12-narration-error-handling-TODO.md` (agent-pickable tasks)
5. Agents or subagents pick up tasks from TODO.md independently.

Full architecture: [docs/architecture.md](../architecture.md)

---

## 6. Security Architecture

5-level instruction hierarchy enforced by `secure-*` skills:

```
Level 1 (highest): System / developer instructions
Level 2:           secure-* skills
Level 3:           User instructions
Level 4:           Installed skill instructions
Level 5 (lowest):  External / repo content (untrusted)
```

**Invariant:** No skill may process external content unless ALL `secure-*` skills return SAFE. Security skills cannot be skipped, deferred, or overridden. Only modified by human-authored commits.

---

## 7. Quality Standards

| Standard | Requirement |
|----------|-------------|
| Size | SKILL.md ≤ 200 lines |
| Validation | `agentskills validate` must pass |
| Score | ≥ 10/14 on scoring rubric |
| Naming | Lowercase, hyphens only, 1–64 chars, matches directory |
| Content | No API keys, no placeholders, no failing validations |

---

## 8. Installation & Distribution

**One-time global install:**
```bash
# macOS/Linux
git clone https://github.com/dvy1987/agent-loom.git ~/.agent-loom && cd ~/.agent-loom && bash install.sh

# Windows
git clone https://github.com/dvy1987/agent-loom.git $HOME\.agent-loom; cd $HOME\.agent-loom; .\install.ps1
```

**Updating:** `bash ~/.agent-loom/install.sh --update`
**Uninstall:** `bash ~/.agent-loom/uninstall.sh` (removes only repo symlinks)

Supported platforms: Codex CLI, Ampcode, Claude Code, Warp, Gemini CLI, GitHub Copilot, Cursor, VS Code, Factory.ai. Project-level only: Replit, Bolt.new.

---

## 9. Post-Creation/Update Maintenance

When a skill is created, renamed, removed, or restructured, the following maintenance runs:

| Step | Skill | What it updates |
|------|-------|----------------|
| 1 | `cross-link-skills` | Repairs cross-references in all SKILL.md files |
| 2 | `library-skill` | Syncs SKILL-INDEX.md, AGENTS.md, README.md, skill-graph.md, PRD.md, architecture.md |
| 3 | `generate-changelog` | Creates changelog entry (called by library-skill) |

Validation (handled by `universal-skill-creator` / `improve-skills`):
- `validate-skills` — score ≥10/14
- `wc -l` — ≤200 lines
- `agentskills validate` — must pass
- `secure-*` skills — mandatory security scan

---

## 10. Success Metrics

| Metric | Target |
|--------|--------|
| Skill quality score | Average ≥ 10/14; zero skills below 5/14 |
| Library freshness | All skills validated/improved within last 30 days |
| Platform coverage | All 8 globally-installable platforms working |
| Self-improvement cycle | Full library audit completes in a single agent session |
| Zero security regressions | No commit bypasses the secure-* gate |

---

## 11. Open Questions

- Domain skills prioritization — first 3–5 categories to build?
- Replit / Bolt.new — automate project-level skill injection?
- Versioning strategy — individual skill versions beyond repo version?
- Community contributions — full PR workflow beyond CONTRIBUTING.md quality standards?
- skills.sh publishing — default or opt-in?

---

## 12. Repo Structure

```
.agents/ROUTING.md                   ← skill priority rules
.agents/skills/<name>/SKILL.md       ← skill entry points (≤200 lines)
docs/SKILL-INDEX.md                  ← full skill catalog + call graph
docs/prd/PRD.md                      ← this file (living source of truth)
docs/prd/YYYY-MM-DD-*.md             ← point-in-time PRD snapshots
docs/architecture.md                 ← current-state architecture
docs/skill-graph.md                  ← Mermaid call graph
docs/processes/                      ← reusable process entries
docs/changelogs/                     ← release notes
docs/skill-outputs/SKILL-OUTPUTS.md  ← auto-log of generated files
AGENTS.md                            ← agent instructions
README.md                            ← user-facing install + usage
CONTRIBUTING.md                      ← skill quality standards
install.sh / install.ps1             ← global setup
uninstall.sh / uninstall.ps1         ← clean removal
```

---

*This is a living document maintained by `library-skill`. Point-in-time snapshots are preserved as dated files in this directory.*
