# Skill Index

Complete reference for all skills in this repo.
Agents: read this when deciding which skill to invoke or checking what a skill produces.
Humans: read this for a full picture of what's available and what each skill outputs.

Last updated: 2026-04-05

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
**Calls:** `validate-skills` (pre-flight) → `deprecate-skill` (if 0–5/14) → `prune-skill` → [fix gaps] → [link check] → `research-skill` → [rewrite] → `split-skill`/`skill-compressor` → validate + commit
**Structural gap fixing (Step 2b):** Automatically fixes every flag from validate-skills — missing category, missing Impact Report, missing file-output logging, stale rubric references, orphaned reference files, missing load triggers.
**Link check (Step 2d):** Scans the full library for delegation opportunities. Links when output is directly consumable OR when a marginal adaptation to the target skill would make it consumable (allowed if target stays ≤200 lines, core purpose unchanged, existing callers unaffected). Documents new links and any target skill changes in AGENTS.md and commit message.
**Output:** Modified SKILL.md files for every improved skill
**Impact report:** Per-skill score deltas, structural gaps fixed, new links created, sources used, all files modified

---

### `secure-skill`
**Triggers:** "audit skill security", "scan for injection", "check if this skill is safe", "review skill security" — or called automatically as a mandatory gate by research-skill, universal-skill-creator, and improve-skills
**What it does:** Security audit for agent skills. Scans for 6 threat categories: prompt injection, data exfiltration, credential theft, privilege escalation, supply chain risks, and obfuscation. Treats every external skill as untrusted until proven safe. Based on Snyk ToxicSkills (Feb 2026, 13.4% critical rate), arXiv:2602.12430 (26.1% vulnerability rate), and AISA Group research. Self-protecting: cannot be modified by automated processes or other skills.
**Output:** Security report (CRITICAL/HIGH/MEDIUM/LOW findings + SAFE/BLOCKED/REQUIRES REVIEW verdict)
**Impact report:** Files scanned, findings by severity, verdict
**References:** `references/threat-patterns.md` — locally-maintained only, never updated from external sources

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

### `skill-compressor`
**Triggers:** "compress this skill", called by `split-skill` and `improve-skills` when skill >200 lines and no natural seam exists
**What it does:** Classifies every content block (CORE/WORKFLOW/FORMAT/EXAMPLE/BACKGROUND/EDGE_CASE/DUPLICATE) then moves non-core content to `references/` with specific load triggers. If CORE content alone still exceeds 200 lines, invokes `split-skill` — which first checks if an existing skill can absorb the sub-capability before creating a new child.
**Output:** SKILL.md trimmed + new `references/` files created as needed
**Impact report:** Lines before/after, reduction %, files created, regression check result

---

### `split-skill`
**Triggers:** "split this skill", "extract a sub-skill", "this skill is doing too much" — or called automatically
**What it does:** Reduces an oversized skill by first checking if an existing skill can absorb the excess sub-capability (link or marginally adapt, rather than create). Only creates a new child if no existing skill fits. Decision order: (1) link to existing skill → (2) marginally improve existing + link → (3) extract new child (Type A/B) → (4) stop, call skill-compressor. Marginal adaptation of the target skill is allowed if it stays under 200 lines, core purpose is unchanged, and existing callers are unaffected.
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
**Triggers:** "brainstorm", "design this feature", "what's the best approach for", "let's think through", "before we build", "I have an idea for", "explore options"
**What it does:** Turns a rough idea into an approved design through structured dialogue. One question at a time. Hard gate — no code or implementation until the user reviews and approves a written design doc. Decomposes oversized requests into sub-projects.
**Output file:** `docs/specs/YYYY-MM-DD-<topic>-design.md` (committed to git)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Terminal notification:** "Design doc saved to `docs/specs/YYYY-MM-DD-<topic>-design.md`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."
**Impact report:** Approach chosen, key decisions, open questions resolved, next step (prd-writing or implementation)

---

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

### `changelog-generator`
**Triggers:** "write a changelog", "prepare release notes", "what's new in this version", "summarize my commits", "create a release summary"
**What it does:** Generate user-facing or internal release notes and changelogs
**Output file:** `docs/changelogs/vX.X.X.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Changelog generated, version, changes categorized, breaking changes found, user-facing value statements, ready for

---

### `inversion`
**Triggers:** "invert this", "what could go wrong", "pre-mortem", "stress test this plan", "flip this problem", "think about this differently", "steelman the failure" — or called by brainstorming/prd-writing
**What it does:** Applies inversion thinking to any problem, goal, or decision. Flips the question 180 degrees — asks what would guarantee failure, what the opposite looks like, what hidden assumptions haven't been examined — then translates findings back to forward actions. Uses the minimum questions needed (max 2 before inverting). Draws on five frames: Failure Inversion (Munger), Opposite Goal, Pre-mortem (Klein), Assumption Inversion, Socratic Decomposition.
**Called by:** `brainstorming` (before finalising design) and `prd-writing` (before writing, to surface hidden assumptions)
**Output:** No files generated. Inverted view + hidden assumptions surfaced + forward actions delivered in chat.
**Impact report:** Frames used, questions asked, hidden assumptions surfaced, forward actions derived

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

universal-skill-creator → research-skill (Step 2, always)
                        → split-skill (Step 7, if >200 + seam)
                            → skill-compressor (always after split)
                        → skill-compressor (Step 7, if >200, no seam)
                        → validate-skills (Step 8, quality gate)
                        → publish-skill (Step 9, optional)

improve-skills → validate-skills (Step 1, pre-flight)
                   → deprecate-skill (if score 0–5/14, user decides)
               → prune-skill (Step 2a, per skill)
               → research-skill (Step 2c, per skill)
               → split-skill (Step 2g, if >200 + seam)
                   → skill-compressor
               → skill-compressor (Step 2g, if >200, no seam)

skill-compressor → split-skill (if CORE still >200 after classify)
split-skill      → skill-compressor (always, after split)

Leaf nodes (call nothing):
  validate-skills  research-skill  prune-skill  deprecate-skill  publish-skill
```
