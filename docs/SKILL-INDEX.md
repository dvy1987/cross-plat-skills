# Skill Index

Complete reference for all skills in this repo.
Agents: read this when deciding which skill to invoke or checking what a skill produces.
Humans: read this for a full picture of what's available and what each skill outputs.

Last updated: 2026-04-10

---

## Skill Categories — Definitions

### Meta Skills
Skills that manage the skill library itself — creating, improving, validating, compressing, splitting, deprecating, and publishing other skills. Always installed globally (`~/.agents/skills/`). Users interact with only two directly: `universal-skill-creator` and `improve-skills`. The rest are called automatically.

### Thinking Skills
Structured thinking frameworks that help reason through any problem, decision, or document. Not product-specific, not project-specific — they apply wherever clear thinking is needed: product strategy, engineering decisions, personal choices, creative work. Always installed globally. Each skill encodes a proven thinking method (inversion, adversarial critique, structured brainstorming) so the agent applies it rigorously rather than generically. New thinking frameworks can be added here as they are discovered.

### Project-Specific Skills
Workflows that recur across most or all projects. Installed globally, but the files they generate always land inside the current project (e.g. `docs/specs/`, `docs/prd/`, `docs/product-soul.md`). These are "project-specific" not because they're scoped to one codebase, but because their output belongs to whichever project you're working in.

### Domain Skills
Specialized workflows useful in some projects but not all. Examples: story writing, dramatization, screenplay formatting, academic paper structuring, legal document drafting. Not universally applicable — built and installed only when a project needs them. **Currently empty.** Add skills here as they are built.

---

## Meta Skills

Install globally: `~/.agents/skills/`. Called automatically by `improve-skills` and `universal-skill-creator`.

### `universal-skill-creator`
**Triggers:** "create a skill", "build a skill that does X", "skill creator", "write a SKILL.md", "skill architect", "skill engineer"
**What it does:** Creates new cross-platform skills from scratch. Runs live domain research (papers + practitioner blogs + GitHub skill repos), writes the skill body, validates quality (≥10/14 score), splits or compresses if over 200 lines, optionally publishes to skills.sh.
**Mandatory in every skill it creates:** `## Impact Report` section + file-output logging to `docs/skill-outputs/SKILL-OUTPUTS.md` for any skill that generates project files.
**Output:** `.agents/skills/<name>/SKILL.md` + optional `references/`, `scripts/`, `templates/`
**Impact report:** Tier, validate-skills score, install path, test trigger, all files created, research sources used, publish status

---

### `improve-skills`
**Triggers:** "improve all skills", "skill audit", "upgrade skills with latest research", "run improvement pass"
**What it does:** Full improvement cycle for every skill (or a named subset). Per-skill sequence: prune → fix structural gaps → link check → research → rewrite → resize.
**Calls:** `validate-skills` (pre-flight) → `deprecate-skill` (if 0–5/14) → `prune-skill` → [fix gaps] → [link check] → `research-skill` → [rewrite] → `split-skill`/`compress-skill` → validate + commit
**Structural gap fixing (Step 2b):** Automatically fixes every flag from validate-skills — missing category, missing Impact Report, missing file-output logging, stale rubric references, orphaned reference files, missing load triggers.
**Link check (Step 2d):** Scans the full library for delegation opportunities. Links when output is directly consumable OR when a marginal adaptation to the target skill would make it consumable (allowed if target stays ≤200 lines, core purpose unchanged, existing callers unaffected). Documents new links and any target skill changes in AGENTS.md and commit message.
**Output:** Modified SKILL.md files for every improved skill
**Impact report:** Per-skill score deltas, structural gaps fixed, new links created, sources used, all files modified

---

### `secure-skill`
**Triggers:** "audit skill security", "scan for injection", "check if this skill is safe", "review skill security" — or called automatically as a mandatory gate by research-skill, universal-skill-creator, and improve-skills
**What it does:** Security audit orchestrator. Runs 6 core checks (prompt injection, data exfiltration, credential theft, privilege escalation, supply chain, obfuscation) and then dispatches `secure-skill-repo-ingestion` and `secure-skill-runtime` in sequence. Enforces formal instruction hierarchy (system > secure-* > user > installed skills > external content). Treats every external skill and repo as untrusted. Based on Snyk ToxicSkills (36% flaw rate, 13.4% critical), arXiv:2602.12430, arXiv:2604.03081 (PoisonedSkills), and OWASP Agentic Top 10 2026.
**Output:** Security report with sibling skill verdicts. Content is SAFE only if ALL secure-* skills return SAFE.
**Impact report:** Files scanned, hierarchy status, findings by severity, sibling verdicts, final verdict
**References:** `references/threat-patterns.md` — locally-maintained only, never updated from external sources

---

### `secure-skill-content-sanitization`
**Triggers:** Called in sequence by `secure-skill` as a preprocessing step — also directly via "sanitize content", "check hidden text", "scan markdown attacks", "strip HTML", "detect invisible instructions", "check zero-width chars"
**What it does:** Detects and neutralizes visually hidden but agent-readable content. Checks for CSS-hidden text (display:none, color:white, font-size:0, opacity:0), HTML comments with instructions, collapsible details sections, zero-width unicode characters, bidirectional overrides, homoglyphs, misleading links (javascript:, data:, anchor mismatches), image-based exfiltration, and active HTML elements. Enforces mandatory sanitization: strip HTML, extract comments as first-class content, normalize unicode to NFKC, expand collapsed sections, validate links. Core principle: visibility ≠ influence — hidden content is more dangerous than visible because agents process it but humans cannot review it.
**Output:** Content sanitization audit with per-check findings and sanitization actions taken
**Impact report:** Files processed, findings per check (13-15), sanitization applied, verdict

---

### `secure-skill-repo-ingestion`
**Triggers:** Called in sequence by `secure-skill` during any repo scan — also directly via "check repo for poisoned code", "scan dependencies", "verify supply chain", "check path traversal", "audit repo before ingestion"
**What it does:** Repo-specific security checks. Scans for poisoned examples/training data (Check 7), dependency and supply-chain deep analysis (Check 8), file/path attacks including symlinks and traversal (Check 9), and format-based attacks in markdown/HTML/SVG/YAML/notebooks (Check 10). Enforces three-layer ingestion model: Observe → Judge → Commit. Read-only ingestion — never executes repo code. Quarantine workflow with human approval required before anything enters the skill store.
**Output:** Repo ingestion audit report with per-check findings and quarantine status
**Impact report:** Files scanned, skipped count, findings per check, quarantine verdict

---

### `secure-skill-runtime`
**Triggers:** Called in sequence by `secure-skill` during any scan — also directly via "check state corruption", "prevent skill overwrite", "manage no-go repos", "check provenance", "detect DoS"
**What it does:** Runtime security enforcement. Prevents state corruption and skill overwrite attacks (Check 11): no automatic writes to skill store, no memory corruption from external content, no defaults injection. Detects denial-of-service patterns (Check 12): file size limits, nesting depth limits, archive bombs, context window exhaustion. Manages the no-go repo list (blocked repos are rejected on sight). Enforces provenance tracking for all approved external content with immutable append-only records.
**Output:** Runtime security audit with per-check findings, no-go list status, provenance status
**Impact report:** Findings per check, no-go list matches, provenance recorded
**References:** `references/no-go-repos.md` — append-only blocked repo list

---

### `validate-skills`
**Triggers:** "validate skills", "skill health check", "check all skills", "are my skills ok"
**What it does:** Read-only audit. Scores every skill on 7 criteria (max 14/14). Flags P0 failures, >200-line violations, broken caller references, orphaned reference files, duplicate trigger phrases.
**Output:** No files modified. Structured quality report in chat with P0/P1/P2/P3 actions.
**Impact report:** Skills checked, P0 failures, average score, recommended actions
**Rubric:** `.agents/skills/validate-skills/references/validation-rubric.md`

---

### `prune-skill`
**Triggers:** "prune skills", "check for outdated techniques", "verify citations", "update for new model"
**What it does:** Evidence-only removal of wrong, outdated, or poorly-cited content. Audits every citation for trust tier (High=NeurIPS/ICML/ICLR, Medium=arXiv 50+ citations, Low=blogs, Zero=unverifiable). Checks the obsolete techniques list. Never prunes without a citable source. Appends a Prune Log to every skill it touches.
**Output:** Target SKILL.md pruned + Prune Log appended
**Impact report:** Items pruned, corrected, flagged; source cited for each removal
**References:** `citation-standards.md`, `obsolete-techniques.md` in `.agents/skills/prune-skill/references/`

---

### `research-skill`
**Triggers:** "research domain for a skill", "find existing skills on X", "what research exists for Y" — or called by `universal-skill-creator`/`improve-skills`
**What it does:** Searches academic papers (arXiv, NeurIPS, ICML), practitioner blogs (Vercel, Stripe, Linear eng, HN, Substack), and GitHub skill repos (anthropics/skills, openai/skills, warpdotdev/oz-skills) in parallel. Returns a structured findings report — GOTCHAS, WORKFLOW PATTERNS, FAILURE MODES, EXISTING SKILLS.
**Output:** No files modified. Returns findings report to the calling skill or user.
**Impact report:** Sources consulted, gotchas found, existing skills found, discarded background items

---

### `compress-skill`
**Triggers:** "compress this skill", called by `improve-skills` when skill >200 lines and no natural seam exists
**What it does:** Classifies every content block (CORE/WORKFLOW/FORMAT/EXAMPLE/BACKGROUND/EDGE_CASE/DUPLICATE) then moves non-core content to `references/` with specific load triggers. If CORE content alone still exceeds 200 lines, invokes `split-skill` — which first checks if an existing skill can absorb the sub-capability before creating a new child.
**Output:** SKILL.md trimmed + new `references/` files created as needed
**Impact report:** Lines before/after, reduction %, files created, regression check result

---

### `split-skill`
**Triggers:** "split this skill", "extract a sub-skill", "this skill is doing too much" — or called automatically
**What it does:** Reduces an oversized skill by first checking if an existing skill can absorb the excess sub-capability (link or marginally adapt, rather than create). Only creates a new child if no existing skill fits. Decision order: (1) link to existing skill → (2) marginally improve existing + link → (3) extract new child (Type A/B) → (4) stop, call compress-skill. Marginal adaptation of the target skill is allowed if it stays under 200 lines, core purpose is unchanged, and existing callers are unaffected.
**Output:** If linked: parent SKILL.md updated + AGENTS.md modified. If new child: `.agents/skills/<child>/SKILL.md` created + parent SKILL.md + AGENTS.md modified.
**Impact report:** Action taken (linked/adapted/extracted), parent/child line counts, callers updated, regression check
**Patterns:** `.agents/skills/split-skill/references/split-patterns.md`

---

### `deprecate-skill`
**Triggers:** "deprecate this skill", "retire this skill" — or offered by `improve-skills` when score is 0–5/14
**What it does:** Gracefully retires a skill that is redundant, superseded, or no longer earning its context window cost. Requires evidence (never age alone), requires user confirmation, archives to `.agents/skills/.deprecated/`, writes `DEPRECATION.md`, updates all callers, AGENTS.md, README, and deprecation log.
**Output:** Skill moved to `.agents/skills/.deprecated/<name>-deprecated-YYYY-MM-DD/`. AGENTS.md, README, callers modified.
**Impact report:** Archive path, recovery command, callers updated, deprecation log entry
**Log:** `.agents/skills/deprecate-skill/references/deprecation-log.md`

---

### `learn-from-paper`
**Triggers:** "learn from this paper", "skill from paper", "paper to skill", "extract from this research", "apply this paper", "read this paper and improve my skills"
**What it does:** Reads an academic paper (uploaded PDF or linked URL), rigorously assesses credibility using a 6-dimension rubric (≥7/12 required), runs the full `secure-*` security scan pipeline, then extracts actionable insights. Routes to five outcomes: improve existing skills (one or many), create new skills (with anti-sprawl gate), improve the current project codebase (via `apply-paper-to-project`), any combination, or learnings-only report with path forward.
**Calls:** `secure-*` skills (mandatory gate) → `universal-skill-creator` (if creating new) → `apply-paper-to-project` (if improving project) → `validate-skills` (post-apply)
**Output:** Credibility report + security verdicts + extracted insights + application plan in chat. Modified SKILL.md files committed with citations. Optionally saves learnings report to `docs/research-learnings/`.
**Impact report:** Paper title, credibility score/verdict, security verdict, insights extracted, skills modified/created, project changes, learnings saved, score deltas
**References:** `references/credibility-rubric.md` (6-dimension scoring rubric with trust tiers, recency windows, quick-reject criteria)

---

### `library-skill`
**Triggers:** "update the skill index", "sync skill references", "refresh the skill graph", "fix broken skill cross-references", "update docs after skill change" — or called automatically after structural changes
**What it does:** Maintains skill library consistency whenever a structural change occurs — new skill added, skill renamed, skill deprecated, call graph rewired, or category changed. Scans all SKILL.md files, updates SKILL-INDEX.md, AGENTS.md, README.md, generates/updates the skill call graph (`docs/skill-graph.md`), validates cross-references, and invokes `generate-changelog`.
**Called by:** `universal-skill-creator` (after creating), `split-skill` (after extracting child), `deprecate-skill` (after retiring), `improve-skills` (after structural changes)
**Calls:** `generate-changelog` (after completing all updates)
**Output:** Updated SKILL-INDEX.md, AGENTS.md, README.md, docs/skill-graph.md. Logged to `docs/skill-outputs/SKILL-OUTPUTS.md`.
**Impact report:** Skills scanned, entries added/removed/updated, files modified, broken cross-references, orphaned entries

---

### `publish-skill`
**Triggers:** "publish this skill", "share this skill publicly", "submit to skills.sh" — or offered by `universal-skill-creator` as optional final step
**What it does:** Validates quality (≥10/14 required), scans for proprietary content (no internal URLs, paths, or credentials), packages correctly (.md for Atomic tier, .zip for Standard+), writes README if missing, publishes to skills.sh via `npx skills publish`.
**Output:** Skill live on skills.sh registry. Optional git commit if pushing to GitHub.
**Impact report:** Registry URL, install command, score at publish, package format, proprietary scan result
**Checklist:** `.agents/skills/publish-skill/references/publish-checklist.md`

---

## Thinking Skills

Install globally: `~/.agents/skills/`. Apply to any domain — product, engineering, personal decisions, creative work.

### `brainstorming`
**Triggers:** "brainstorm", "design this feature", "what's the best approach for", "let's think through", "before we build", "I have an idea for", "explore options"
**What it does:** Turns a rough idea into an approved design through structured dialogue. One question at a time. Hard gate — no code or implementation until the user reviews and approves a written design doc. Decomposes oversized requests into sub-projects. Reads `docs/product-soul.md` for strategic context when available.
**Output file:** `docs/specs/YYYY-MM-DD-<topic>-design.md` (committed to git)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Approach chosen, key decisions, open questions resolved, next step

---

### `inversion`
**Triggers:** "invert this", "what could go wrong", "pre-mortem", "stress test this plan", "flip this problem", "steelman the failure" — or called by brainstorming/prd-writing
**What it does:** Flips any problem 180° — asks what would guarantee failure, what the opposite looks like, what hidden assumptions haven't been examined. Five frames: Failure Inversion (Munger), Opposite Goal, Pre-mortem (Klein), Assumption Inversion, Socratic Decomposition. Max 2 questions before inverting. Always returns forward actions.
**Output:** No files. Inverted view + hidden assumptions + forward actions in chat.
**Impact report:** Frames used, questions asked, assumptions surfaced, forward actions derived

---

### `adversarial-hat`
**Triggers:** "stress test this", "red team this plan", "poke holes in this", "devil's advocate", "challenge my assumptions", "what could kill this", "find the flaws" — or called by product-soul, brainstorming, prd-writing
**What it does:** Structured adversarial critique — three phases: Diagnostic (facts vs. hypotheses?), Creative (problem artificially constrained?), Challenge (solutions robust?). Every critique cites specific evidence. Always ends with resolution conditions and strongest elements to build on. Complementary to inversion: inversion asks "what is the opposite?", adversarial hat asks "what is wrong with what we have?"
**Output:** Adversarial report in chat (Critical/Significant/Minor). Optionally integrated into target document.
**Impact report:** Phases run, critical/significant/minor counts, integrated yes/no

---

### `first-principles`
**Triggers:** "think from first principles", "why does it have to work this way", "what are the actual constraints", "rebuild this from scratch", "ignore convention" — or called by deep-thinking
**What it does:** Strips a problem to its irreducible fundamental truths and rebuilds the solution from the ground up — eliminating inherited assumptions and conventional constraints. Six steps: define without assuming → list all assumptions → challenge each (necessary vs. conventional) → confirm fundamental truths → validate → rebuild. Produces solutions that bypass inherited design constraints.
**Output:** No files. Analysis (fundamental truths / conventional constraints / rebuilt solution / expected delta) in chat.
**Impact report:** Assumptions challenged, conventional constraints found, fundamental truths confirmed, new solution built

---

### `second-order`
**Triggers:** "what are the downstream effects", "and then what", "unintended consequences", "long-term vs short-term", "think ahead on this" — or called by deep-thinking
**What it does:** Traces the consequences of consequences across time — first order (immediate), second order (what that causes), third order (what that causes). Maps effects to time horizons (immediate / 6 months / 3 years). Finds hidden risks (first-order positive, second-order negative) and hidden opportunities (first-order negative, second-order positive). Based on Howard Marks second-level thinking.
**Output:** No files. Consequence chain + time horizon map + hidden risks/opportunities in chat.
**Impact report:** Orders traced, hidden risks found, hidden opportunities found, recommended time horizon

---

### `fermi`
**Triggers:** "ballpark this", "rough estimate", "how big is this market", "how long would this take", "how many users", "we don't have the numbers" — or called by deep-thinking
**What it does:** Decomposes an unknown quantity into 3–5 estimable factors, anchors each with a defensible round number, multiplies through, sense-checks against a known reference, and delivers a low/central/high range. Names the most uncertain factor. Always states what decision the estimate enables. Based on Enrico Fermi's estimation method.
**Output:** No files. Factor tree + calculation + range + sense-check + decision enabled in chat.
**Impact report:** Factors decomposed, central estimate, range, most uncertain factor, decision enabled

---

### `ooda`
**Triggers:** "what should we do right now", "the situation is changing", "competitive response", "we need to move fast", "we're stuck deciding", "OODA" — or called by deep-thinking
**What it does:** Boyd's OODA loop adapted for product and business — Observe (separate facts from assumptions), Orient (filter through mental models and context, find the key insight), Decide (2–3 options, pick one specifically), Act (owner + timeline + reversibility). Sets the next loop trigger so the team knows when to loop again. Based on OODA Canvas framework (TDHJ 2026).
**Output:** No files. OODA report (Observe/Orient/Decide/Act + next loop trigger) in chat.
**Impact report:** Key orientation insight, decision made, owner, timeline, next loop trigger

---

## Project-Specific Skills

Install globally: `~/.agents/skills/`. Output files land inside the current project.

### `prd-writing`
**Triggers:** "write a PRD", "document requirements", "create a spec", "I need a PRD for", "turn this into requirements", "define acceptance criteria"
**What it does:** Discovery interview (minimum 2 questions, even with a detailed brief) then produces a structured PRD in the chosen format. Reads brainstorming design docs from `docs/specs/` as foundation when available. Never writes before discovering.
**Formats:** Full PRD | Lean PRD | One-Pager | Technical PRD
**Output file:** `docs/prd/YYYY-MM-DD-<feature>-prd.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Terminal notification:** "PRD saved to `docs/prd/YYYY-MM-DD-<feature>-prd.md`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."
**Impact report:** Format, sections written, open questions remaining, success metrics defined
**References:** `prd-schemas.md`, `metrics-frameworks.md` in `.agents/skills/prd-writing/references/`

### `product-soul`
**Triggers:** "write the product soul", "product strategy doc", "product north star", "why we exist document", "product positioning", "what is this product really about", "capture the product vision"
**What it does:** Writes `docs/product-soul.md` — a living strategic document covering five lenses: User (who specifically, what pain), Business (model, year 1/3 conditions, biggest risk), Strategy (named competitors, moat, strategic bet), Product-Market Fit (status, signal, threshold, falsification condition), GTM (wedge channel, acquisition→activation→retention loop, first 100 users tactic). Runs inversion to stress-test assumptions. Referenced by brainstorming and prd-writing for strategic grounding.
**Output file:** `docs/product-soul.md` (living document, versioned)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Terminal notification:** "Product Soul saved to `docs/product-soul.md`. Referenced by brainstorming, prd-writing, and inversion."
**Called by:** Standalone; brainstorming and prd-writing read its output
**Impact report:** Sections written, PMF status, inversion run yes/no, open hypotheses count
**References:** `references/product-soul-schema.md` (full template), `references/discovery-questions.md` (question bank per lens)

---

### `implementation-plan`
**Triggers:** "plan a feature", "create a technical roadmap", "break down a PRD into tasks", "design an implementation strategy"
**What it does:** Create a detailed, step-by-step implementation plan for a feature or project
**Output file:** `docs/plans/YYYY-MM-DD-<feature>-plan.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Plan complete, phases defined, total tasks, critical risks identified, estimated effort, ready for

---

### `test-driven-development`
**Triggers:** "test-driven development", "write tests first", "TDD this feature", "Red-Green-Refactor"
**What it does:** Apply the Red-Green-Refactor cycle to software development
**Output file:** `tests/` and `src/` updates
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** TDD session complete, tests written, code coverage achieved, refactorings performed, status, ready for

---

### `agent-system-architecture`
**Triggers:** "build an agent system", "design agent orchestration", "choose between sequential/parallel/hierarchical workflows", "multi-agent wiring"
**What it does:** Design state-of-the-art multi-agent systems, orchestration patterns, and wiring
**Output file:** `docs/architecture/YYYY-MM-DD-<system-name>-arch.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Architecture designed, pattern chosen, number of agents, coordination complexity, observability strategy, ready for

---

### `architectural-decision-log`
**Triggers:** "record a decision", "write an ADR", "why did we do this", "document this architectural choice", "architectural decision record"
**What it does:** Capture the "why" behind technical choices to prevent architectural drift
**Output file:** `docs/adr/ADR-NNN-<title-slug>.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** ADR recorded, number, status, alternatives considered, critical consequences, ready for

---

### `technical-debt-audit`
**Triggers:** "technical debt audit", "where is the code messy", "assess project health", "find my hacks", "identify tech debt"
**What it does:** Audit the project's technical health and identify "high-interest" debt
**Output file:** `docs/reports/YYYY-MM-DD-tech-debt-audit.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Audit complete, health score, high-interest items found, total TODOs/FIXMEs, refactoring roadmap created, ready for

---

### `generate-changelog`
**Triggers:** "write a changelog", "prepare release notes", "what's new in this version", "summarize my commits", "create a release summary", auto-triggered by library-skill after major repo changes
**What it does:** Generate user-facing or internal release notes and changelogs
**Output file:** `docs/changelogs/vX.X.X.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Changelog generated, version, changes categorized, breaking changes found, user-facing value statements, ready for

---

### `project-setup`
**Triggers:** "set up this project", "create an AGENTS.md", "bootstrap agents", "configure agents for my repo", "agent onboarding", "write an AGENTS.md for this project", "project bootstrap"
**What it does:** Interviews the user about skill gaps (role, expertise, working style) and project context (stack, architecture, conventions), then generates a tailored AGENTS.md with: project overview, key commands, code style, boundaries (tuned to user comfort), user context (where agents lead vs. defer), and a phase-based Orchestration Map that routes to the right agent-loom at each project stage. Re-run after PRD changes, stack changes, or team changes to update the AGENTS.md.
**Output file:** `AGENTS.md` in the target project root
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** User role, skill gaps filled, skills in orchestration map, agent autonomy level per phase
**References:** `references/interview-questions.md` (full question bank), `templates/agents-md-template.md` (scaffold)

---

### `debug-and-fix`
**Triggers:** "this is broken", "fix this bug", "why is this failing", "debug this", "resolve this error", "what went wrong"
**What it does:** Systematically reproduces issues, isolates root causes, applies minimal fixes, and verifies the result. Supports Linear issue integration — fetches issues, cross-references against actual codebase, and updates status with user approval. Handles batch triage for multiple bugs (one at a time, full cycle each).
**Output:** No files generated. Root cause + fix + verification summary in chat. Linear issue updated if applicable.
**Impact report:** Bug fixed, root cause, files changed, tests run, Linear updated, next bug in queue

---

### `apply-paper-to-project`
**Triggers:** "apply paper findings to this project", "improve this codebase with research", "use this paper to improve my project", "apply this to my project", "how can this paper help my codebase"
**What it does:** Takes validated, security-cleared insights from `learn-from-paper` and applies them to the current project codebase — improving architecture, code patterns, testing strategies, documentation, or workflows based on empirical evidence. Reads project context (AGENTS.md, source files, tests, docs) before proposing changes. Presents a structured improvement plan, applies with user approval, and offers ADR creation for architectural changes.
**Called by:** `learn-from-paper` (outcome 4 — improve current project). Never ingests papers directly.
**Calls:** `architectural-decision-log` (optional, for significant architectural changes)
**Output:** Project improvement plan in chat. Modified project files. Optional ADR. Logged to `docs/skill-outputs/SKILL-OUTPUTS.md`.
**Impact report:** Paper applied, project path, changes applied, files modified, deferred items, ADR created, tests status

---

### `codebase-understanding`
**Triggers:** "understand this repo", "how does this project work", "explain the architecture", "what does this repo do", "show me the structure", "onboard me", "walk me through this codebase"
**What it does:** Maps project architecture, identifies major layers and components, traces 2-3 key data flows through the codebase, and surfaces complexity hotspots (high complexity, missing tests, convention deviations). Reads actual source files to verify every claim. Platform-agnostic — works without builtin walkthrough tools.
**Output:** No files generated. Architecture overview + key flows + component map + hotspots + recommendations in chat.
**Impact report:** Scope, tech stack, layers identified, flows traced, hotspots flagged, recommended next step

---

### `code-review-crsp`
**Triggers:** "review this code", "check this PR", "review my changes", "code review", "did this implement correctly", "audit this diff"
**What it does:** Reviews code changes against 6 criteria (correctness, completeness, security, conventions, tests, performance). Reads full diff + surrounding context + PRD/spec if available. Presents findings as a numbered list grouped by severity (critical → low) with file paths and line numbers. Offers to fix issues with user approval — one at a time, verified after each.
**Output:** No files generated. Structured review with severity-classified findings in chat.
**Impact report:** Review scope, files reviewed, issues by severity, PRD alignment, fixes applied, tests run

---

### `project-orchestrator`
**Triggers:** "what should I do next", "which skill should I use", "orchestrate this", "run the full workflow", "split into parallel tasks", "coordinate agents", "parallel execution", "task decomposition", "what phase am I in"
**What it does:** Reads project state (which artefacts exist), classifies the user's request (single-skill / sequential chain / parallel decomposition / phase recommendation), builds an orchestration plan, and executes platform-aware. On Tier 1 platforms (Codex, Claude Code, Cursor, Gemini+Maestro, Replit 4) it spawns parallel subagents with scoped prompts and file boundaries. On Tier 2 platforms (Warp, Copilot Mission Control, Factory.ai) it writes a task plan file for the user to dispatch. On Tier 3 platforms (Bolt.new, VS Code) it executes sequentially. Contains a full skill routing table mapping user intent to the right skill.
**Output:** Orchestration plan in chat. If parallel: optionally writes `docs/task-plan.md`. Updates `docs/skill-outputs/SKILL-OUTPUTS.md`.
**Impact report:** Mode used, skills invoked, subagents spawned, next recommended phase
**References:** `references/platform-subagent-matrix.md` (full capability matrix for 11 platforms), `references/orchestration-patterns.md` (fan-out/fan-in, file-based queue, parallel review, subagent prompt template)

---

### `inversion`
**Triggers:** "invert this", "what could go wrong", "pre-mortem", "stress test this plan", "flip this problem", "think about this differently", "steelman the failure" — or called by brainstorming/prd-writing
**What it does:** Applies inversion thinking to any problem, goal, or decision. Flips the question 180 degrees — asks what would guarantee failure, what the opposite looks like, what hidden assumptions haven't been examined — then translates findings back to forward actions. Uses the minimum questions needed (max 2 before inverting). Draws on five frames: Failure Inversion (Munger), Opposite Goal, Pre-mortem (Klein), Assumption Inversion, Socratic Decomposition.
**Called by:** `brainstorming` (before finalising design) and `prd-writing` (before writing, to surface hidden assumptions)
**Output:** No files generated. Inverted view + hidden assumptions surfaced + forward actions delivered in chat.
**Impact report:** Frames used, questions asked, hidden assumptions surfaced, forward actions derived

---

### Agent & Process Design Skills

### `process-decomposer`
**Triggers:** "decompose this", "break this down", "what steps do I need", "plan this out", "what's the process for", "how do I approach this"
**What it does:** Complexity triage (Layer 1) + task decomposition into structured process entries. Checks process.md for reusable matches first. Classifies as exact-match, single-skill, skill-chain, or agent-chain. Stores entries in docs/processes/ for future reuse. Hard gate: requires measurable outcome before decomposition.
**Calls:** `skill-finder`, `tool-finder`, `research-skill` (for knowledge gaps)
**Output file:** `docs/processes/YYYY-MM-DD-<task-slug>.md`
**Registry:** `docs/processes/process.md` (volume-split at 500 lines)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Complexity class, process entry path, steps count, knowledge gaps flagged, next layer

---

### `agent-architect`
**Triggers:** "design an agent for this", "what agent structure do I need", "architect this", "should this be multi-agent", "what's the right execution structure"
**What it does:** Designs execution structure for decomposed processes. Decides single agent or multi-agent topology. For multi-agent: defines boundaries, chooses topology (sequential/parallel/hierarchical), specifies handoff protocols. Persists architecture specs for the learning loop and triggers setup evaluation before orchestration.
**Calls:** `agent-system-architecture` (complex topology), `create-agent-prompt` (role prompts), `setup-evaluation` (via setup-evaluator agent), `project-orchestrator` (downstream)
**Output file:** `docs/architecture/YYYY-MM-DD-<task-slug>-arch.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Structure chosen, agents defined, architecture spec path, process entry linked

---

### `setup-evaluation`
**Triggers:** "evaluate this setup", "check the decomposition", "validate the architecture", "is this plan sound"
**What it does:** Validates process decomposition and architecture design before execution. Checks step coverage, tool availability, parallelism consistency, agent boundaries, handoff protocols, and cross-validates spec linkage. Returns PASS or FAIL with specific issues. Runs from setup-evaluator agent (separate from agent-architect to avoid confirmation bias).
**Output:** PASS/FAIL verdict in chat with issues list
**Impact report:** Verdict, issues count, checks passed/total, next step

---

### `skill-finder`
**Triggers:** "what skill does this need", "find a skill for", "is there a skill that", "which skill handles"
**What it does:** Searches the skill library for capability matches. Decides: use existing (full overlap), extend existing (partial overlap), or create new (no overlap). The single gatekeeper for all skill creation — prevents skill sprawl.
**Calls:** `universal-skill-creator` (if create/extend needed), `library-skill` (sync indexes)
**Output:** Skill name + action taken (existing/extended/created)
**Impact report:** Action, skill name, library size before/after

---

### `tool-finder`
**Triggers:** "what tool", "do I need an MCP", "is [tool] available", "which tool handles"
**What it does:** Identifies tools for process steps. Confirms CLI compatibility, checks MCP server config. Guides user through setup if needed. Categorises tools: File I/O, Web, Bash, API, MCP, Custom CLI.
**Output:** Tool name, status (available/needs-setup/unavailable), setup instructions
**Impact report:** Tool, status, platform

---

### `create-agent-prompt`
**Triggers:** "create an agent prompt", "write a role prompt", "define agent identity"
**What it does:** Creates focused role prompts for agents in multi-agent topologies. Defines identity, responsibilities, boundaries, handoff protocol, and failure behavior. Scope: agent role prompts only (v1). System prompts, task prompts, skill prompts are future TODOs.
**Called by:** `agent-architect`, user (direct)
**Output:** Prompt text ready to embed in AGENTS.md or architecture spec
**Impact report:** Agent name, topology role, handoff defined, failure behavior defined

---

### Agents

### `setup-evaluator` (agent)
**Spawned by:** `agent-architect` after it writes the architecture spec for `agent-chain` processes
**Skills:** `setup-evaluation`
**What it does:** Runs between architecture design and orchestration config. Validates the setup independently from the architect. On FAIL: returns issues to agent-architect. On PASS: hands off to project-orchestrator.
**Why an agent:** Independence from agent-architect prevents confirmation bias.

---

## Domain Skills

Specialized skills for specific types of projects — not universally applicable.
**Currently empty.** Add entries here as domain skills are built.

Examples of what belongs here when built:
- Story writing, dramatization, screenplay formatting
- Academic paper structuring, literature review workflows
- Legal document drafting, contract review workflows
- Marketing copy generation, campaign brief writing

---

## Skill Output Log Convention

Every skill that generates a project file appends to `docs/skill-outputs/SKILL-OUTPUTS.md`.

**Bootstrap (one time per project):**
```bash
mkdir -p docs/skill-outputs
cp .agents/skills/universal-skill-creator/templates/SKILL-OUTPUTS-template.md \
   docs/skill-outputs/SKILL-OUTPUTS.md
```

**Log format:**
```
| YYYY-MM-DD HH:MM | skill-name | file/path.md | One-line description |
```

---

## Call Graph (quick reference)

```
User entry points:
  universal-skill-creator  ← "create a skill"
  improve-skills           ← "improve skills"
  learn-from-paper         ← "learn from this paper" / "paper to skill"
  project-setup            ← "set up this project" / "create an AGENTS.md"
  project-orchestrator     ← "what should I do next" / "orchestrate" / "parallel tasks"

universal-skill-creator → research-skill (Step 2, always)
                        → split-skill (Step 7, if >200 + seam)
                        → compress-skill (Step 7, if >200, no seam)
                        → validate-skills (Step 8, quality gate)
                        → library-skill (after creation, to sync indexes)
                        → publish-skill (Step 9, optional)

improve-skills → validate-skills (Step 1, pre-flight)
                   → deprecate-skill (if score 0–5/14, user decides)
               → prune-skill (Step 2a, per skill)
               → research-skill (Step 2c, per skill)
               → split-skill (Step 2g, if >200 + seam)
               → compress-skill (Step 2g, if >200, no seam)
               → library-skill (after structural changes)

project-orchestrator → [any skill] (routes based on project state + user intent)
                     → project-setup (if no AGENTS.md exists)

learn-from-paper → secure-* skills (Step 3, mandatory)
                 → universal-skill-creator (Step 6, if creating new skill)
                 → apply-paper-to-project (Step 6, if improving project)
                 → validate-skills (Step 6, post-apply)

apply-paper-to-project → architectural-decision-log (optional, for significant changes)

project-setup → generates AGENTS.md with Orchestration Map (references project-orchestrator)

compress-skill → split-skill (if CORE still >200 after classify)
split-skill      → library-skill (after extracting child skill)
deprecate-skill  → library-skill (after retiring skill)
library-skill        → generate-changelog (final step, always)

Leaf nodes (call nothing):
  validate-skills  research-skill  prune-skill  publish-skill  generate-changelog
```
