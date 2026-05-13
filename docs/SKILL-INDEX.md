# Skill Index

Complete reference for all skills in this repo.
Agents: read this when deciding which skill to invoke or checking what a skill produces.
Humans: read this for a full picture of what's available and what each skill outputs.

Last updated: 2026-05-05

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
**Triggers:** "improve all skills", "skill audit", "upgrade skills with latest research", "run improvement pass" — and `improve-skills TARGET=<skill> [SKIP_RESEARCH=true]` for single-skill fixes (entry point for `learn-from-chat` Step 5 escalation)
**What it does:** Full improvement cycle for every skill (or a named subset). Per-skill sequence: prune → fix structural gaps → link check → research → rewrite → resize. Ingests `docs/learnings/chat-learnings.md` in Step 1b, triages OPEN entries (IMPLEMENTED/REJECTED/DEFERRED/keep OPEN), and writes terminal statuses back in Step 2l.
**Modes:** `FULL_PASS` (default — all skills) and `TARGETED` (single skill; optional `SKIP_RESEARCH=true` skips only Step 2e when the change source is already trusted).
**Calls:** `validate-skills` (pre-flight) → `deprecate-skill` (if 0–5/14) → `prune-skill` → [fix gaps] → [link check] → `research-skill` → [rewrite] → `split-skill`/`compress-skill` → validate + commit → `cross-link-skills`
**Structural gap fixing (Step 2b):** Automatically fixes every flag from validate-skills — missing category, missing Impact Report, missing file-output logging, stale rubric references, orphaned reference files, missing load triggers.
**Link check (Step 2d):** Scans the full library for delegation opportunities. Links when output is directly consumable OR when a marginal adaptation to the target skill would make it consumable (allowed if target stays ≤200 lines, core purpose unchanged, existing callers unaffected). Documents new links and any target skill changes in AGENTS.md and commit message.
**Output:** Modified SKILL.md files for every improved skill; updated statuses in `docs/learnings/chat-learnings.md`.
**Impact report:** Per-skill score deltas, structural gaps fixed, new links created, sources used, all files modified, chat-learnings closed (count by terminal status).

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

### `skill-deconflict`
**Triggers:** "deconflict skills", "check for naming collisions", "audit trigger overlap", "review intent coverage", "find duplicate triggers", "check skill names", "are any skills too similar", "which skills overlap", "deconflict the library", "check for confusing skill names", "intent audit"
**What it does:** Detects and resolves three classes of skill library problems: names that sound alike but do different things, descriptions with overlapping trigger phrases causing misrouting, and descriptions with too few or too similar intent examples. Rates ambiguity, produces PASS/RENAME/REVISE verdicts in single-skill mode, or a full library audit report.
**Called by:** `universal-skill-creator` (Step 8, after creation), `improve-skills` (Step 2h, per-skill)
**Output:** No files. Deconflict report in chat with name collisions, trigger overlaps, and intent diversity scores.
**Impact report:** Skills scanned, name collisions, trigger overlaps, diversity failures/warnings/passes, verdict

---

### `skill-routing`
**Triggers:** "which skill should handle this", "route this request", "I'm not sure which skill to use", "disambiguate this", "skill routing"
**What it does:** Matches a user request to the right skill using trigger matching, project context, and conversation history. Scores ambiguity 1–10. At 1–3: routes silently. At 4–6: reads context signals (project phase, conversation history, trigger precision, upstream/downstream position) to resolve. At 7–10: asks exactly one disambiguation question as a binary choice. Owns the full skill routing table.
**Called by:** `project-orchestrator` (Step 2)
**Output:** No files. Routing decision with skill name, ambiguity score, candidates, and resolution method.
**Impact report:** Skill routed, ambiguity score, candidates considered, resolution method, question asked yes/no

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

### `learn-from`
**Triggers:** "learn from", "learn from this", "extract insights from", "apply learnings from", "what can we learn from"
**What it does:** Orchestrator for the learn-from suite. Auto-detects source type (academic paper, GitHub repo, blog/web article, or in-conversation learning) and routes to the correct sub-skill. Shares common gates: credibility, security, insight extraction taxonomy (GOTCHA, TECHNIQUE, FAILURE_MODE, METRIC, CONTRADICTION, BACKGROUND). Presents unified report.
**Calls:** `learn-from-paper`, `learn-from-repo`, `learn-from-article`, `learn-from-chat`
**Output:** Unified learn-from report in chat. Delegates actual work to sub-skills.
**Impact report:** Source type, sub-skill invoked, credibility/security verdicts, insights extracted, action taken

---

### `learn-from-paper`
**Triggers:** "learn from this paper", "skill from paper", "paper to skill", "extract from this research", "apply this paper", "read this paper and improve my skills"
**What it does:** Sub-skill of `learn-from`. Reads an academic paper (uploaded PDF or linked URL), rigorously assesses credibility using a 6-dimension rubric (≥7/12 required), runs the full `secure-*` security scan pipeline, then extracts actionable insights. Routes to six outcomes: improve existing skills, create new skills, both, resolve contradictions, improve current project (via `apply-paper-to-project`), or learnings-only.
**Calls:** `secure-*` skills (mandatory gate) → `universal-skill-creator` (if creating new) → `apply-paper-to-project` (if improving project) → `validate-skills` (post-apply)
**Output:** Credibility report + security verdicts + extracted insights + application plan in chat. Modified SKILL.md files committed with citations. Optionally saves learnings report to `docs/learnings/research-learnings.md`.
**Impact report:** Paper title, credibility score/verdict, security verdict, insights extracted, skills modified/created, contradictions resolved, project changes, learnings saved, score deltas
**References:** `references/credibility-rubric.md` (6-dimension scoring rubric with trust tiers, recency windows, quick-reject criteria)

---

### `learn-from-repo`
**Triggers:** "learn from this repo", "learn from this repository", "what can we learn from this codebase", "extract patterns from this repo", "study this repo"
**What it does:** Sub-skill of `learn-from`. Analyzes GitHub/GitLab repositories — extracts actionable patterns from actual source code (not README marketing). Credibility rubric adapted for repos (stars, maturity, code quality, maintenance). `secure-skill-repo-ingestion` is critical. Same six outcomes as learn-from-paper including contradiction resolution.
**Calls:** `secure-*` skills (mandatory gate, esp. `secure-skill-repo-ingestion`) → `universal-skill-creator` (if creating new) → `validate-skills` (post-apply)
**Output:** Repo credibility report + security verdicts + extracted insights + application plan in chat. Modified SKILL.md files with citations.
**Impact report:** Repo name, credibility score/verdict, security verdict, insights extracted, skills modified/created, contradictions resolved

---

### `learn-from-article`
**Triggers:** "learn from this article", "learn from this blog post", "extract insights from this post", "what can we learn from this article", "apply this article"
**What it does:** Sub-skill of `learn-from`. Extracts insights from blog posts, web articles, and practitioner content. Lower credibility gate (≥6/12) because practitioner insight is valuable without formal rigor. Separates production-backed claims from untested opinions. Tags insights with confidence (HIGH/MEDIUM/LOW).
**Calls:** `secure-*` skills (mandatory gate) → `universal-skill-creator` (if creating new) → `validate-skills` (post-apply)
**Output:** Article credibility report + security verdicts + extracted insights with confidence tags + application plan in chat.
**Impact report:** Article title, credibility score/verdict, security verdict, insights extracted, opinions discarded, skills modified/created, contradictions resolved

---

### `learn-from-chat`
**Triggers:** "we should update the skill for this", "this should be a skill rule", "add this as a gotcha", "the skill should know about this", "update the process for this", "learn from this", "remember this for next time"
**What it does:** Sub-skill of `learn-from`. Captures learnings from the current conversation — when the agent or user discovers a skill or process needs updating. No external fetch needed. Evidence comes from what happened in the chat. Checks generalizability before modifying skills. Step 5 escalation gate: append-only edits land here; restructuring or anything that crosses the 200-line gate escalates to `improve-skills TARGET=<skill> SKIP_RESEARCH=true`. Logs every learning to `docs/learnings/chat-learnings.md` with a `Status` field (`OPEN` / `IMPLEMENTED` / `ESCALATED` / `REJECTED` / `DEFERRED`).
**Calls:** `validate-skills` (post-apply for in-scope edits), `improve-skills TARGET=<skill> SKIP_RESEARCH=true` (Step 5 escalation for restructure-class edits)
**Output:** Chat learning report + proposed changes (diff-style) in chat. Modified SKILL.md files with citations. Status-tagged entry in `docs/learnings/chat-learnings.md`.
**Impact report:** Learning captured, classification, status, skills modified, contradictions resolved, logged path

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

### `memory`
**Triggers:** "remember this", "save context", "what happened last time", "manage memory", "continue from prior sessions", "update memory", "compact memory", "forget memory"
**What it does:** Orchestrator for the memory suite. Routes startup context loading, task-specific recall, project memory capture, next-agent handoff, decision logging, global promotion, compaction, audit, and forgetting. Enforces project/global separation: project memory in `docs/memory/`, global memory in `~/.agent-loom/memories/`.
**Calls:** `memory-startup`, `memory-recall`, `memory-capture`, `memory-handoff`, `memory-decision`, `memory-promote`, `memory-compact`, `memory-audit`, `memory-forget`, `secure-*` when external content is involved.
**Output:** No files directly; child skills write memory artifacts.
**Impact report:** Route selected, scope, files read/changed, compaction/security status

### `memory-startup`
**Triggers:** "start from memory", "load prior context", "what happened last time", "continue from previous session", "restore working context"
**What it does:** Loads bounded working context for a new agent by reading memory routing and indexes first, then only relevant current state, latest handoff, decisions, deferred items, open questions, and applicable global preferences/rules. Creates missing `docs/memory/` skeleton when needed.
**Output files:** Optional bootstrap of `docs/memory/` files.
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`

### `memory-capture`
**Triggers:** "remember this", "save this learning", "record what happened", "update project memory", "preserve this context"
**What it does:** Captures durable project memories from session work, debates, debugging discoveries, learned conventions, deferred options, and open questions. Rejects trivial, sensitive, duplicate, or obvious content. Routes cross-project candidates to `memory-promote`.
**Output files:** Updates `docs/memory/*` and `docs/memory/project-index.md`.
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`

### `memory-handoff`
**Triggers:** "handoff", "next agent should know", "save context", "summarize where we are", "switching agents", "memory handoff"
**What it does:** Writes compact next-agent summaries after meaningful work or before switching tools/sessions. Captures done/debated/decisions/deferred/next steps/revisit triggers without journaling trivial interactions.
**Output files:** `docs/memory/agent-handoffs.md`, optionally `docs/memory/current-state.md` and `project-index.md`.
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`

### `memory-decision`
**Triggers:** "record this decision", "we decided", "decision log", "why did we choose", "revisit this later", "capture rationale"
**What it does:** Records decisions with rationale, alternatives, assumptions, status, consequences, and concrete revisit triggers. Distinguishes deferred from rejected and offers `architectural-decision-log` when an ADR is warranted.
**Output files:** `docs/memory/decision-log.md` and `docs/memory/project-index.md`.
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`

### `memory-recall`
**Triggers:** "recall decisions about", "find memory about", "resume this task", "what did we decide", "what was deferred"
**What it does:** Retrieves task-relevant project/global memory without loading the whole store. Reads routing and indexes first, cites source paths, and flags stale or superseded entries.
**Output:** No files. Cited recall summary in chat.

### `memory-promote`
**Triggers:** "make this global", "remember across projects", "save this globally", "promote this learning", "global memory"
**What it does:** Gatekeeper for global memory. Promotes only stable, cross-project, safe, repeatedly useful memories into `~/.agent-loom/memories/`. Enforces strict line budgets and invokes `memory-compact` before over-budget writes.
**Output files:** Updates `~/.agent-loom/memories/*` and source project provenance.

### `memory-compact`
**Triggers:** "compact memory", "memory is too big", "global memory over budget", "compress memory", "clean up old memories"
**What it does:** Reduces memory bloat while preserving decisions, rationale, revisit triggers, and provenance. Global active budgets: user preferences 100 lines, global rules 150, reusable learnings 200, global index 250, active total target 500-700.
**Output files:** Updates memory files, archives stale entries, logs project file changes.

### `memory-audit`
**Triggers:** "audit memory", "check memory health", "clean memory", "verify memory quality", "find stale memories"
**What it does:** Read-only by default. Finds bloat, stale decisions, duplicates, contradictions, unsafe content, missing provenance, broken routing, and over-budget global files. Recommends compact/forget/decision/capture actions.
**Output:** Audit report in chat unless user asks to apply fixes.

### `memory-forget`
**Triggers:** "forget this", "delete memory", "remove that preference", "do not remember", "redact sensitive information", "retire stale memory"
**What it does:** Deletes, redacts, archives, or retires project/global memory. Updates indexes/routing so forgotten memory is not recalled. Redacts secrets instead of archiving them.
**Output files:** Updates target memory files and indexes; logs project file changes.

---

### `implementation-plan`
**Triggers:** "plan a feature", "create a technical roadmap", "break down a PRD into tasks", "design an implementation strategy", "/plan", "/tasks"
**What it does:** Create a detailed, step-by-step implementation plan for a feature or project. Reads `docs/specs/<slug>-feature-spec.md` first when present (refuses to proceed if status≠Approved). Builds a Requirement Traceability table mapping every FR/NFR/C-N to tasks. Tags each task with the IDs it satisfies — read by `spec-crosscheck`. Supports tasks-only mode (called by `spec-driven-development /tasks`).
**Output files:** `docs/plans/YYYY-MM-DD-<slug>-plan.md` (always); `docs/plans/YYYY-MM-DD-<slug>-tasks.md` (when invoked in tasks mode)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Called by:** `spec-driven-development` (`/plan`, `/tasks`)
**Impact report:** Plan complete, phases defined, total tasks, critical risks identified, estimated effort, ready for

---

### `spec-driven-development`
**Triggers:** "spec-driven development", "SDD", "specs-first workflow", "run the spec loop", "/specify a feature", "/plan from this spec", "do spec-driven for this", "GitHub Spec Kit workflow", "Kiro workflow", any SDD-style slash command
**What it does:** Orchestrator for spec-driven development. Routes the seven SDD slash commands to leaf skills, enforces phase order (constitution → specify → clarify → plan → tasks → analyze → implement), and refuses later phases when earlier ones are missing. Detects current SDD state by reading existing artifacts. Thin router — never writes content directly.
**Phase Map:** `/constitution → project-constitution`, `/specify → feature-spec`, `/clarify → feature-spec` (clarify mode), `/plan → implementation-plan`, `/tasks → implementation-plan` (tasks mode), `/analyze → spec-crosscheck`, `/implement → test-driven-development`
**Output:** No files directly — delegates to leaf skills.
**Calls:** `project-constitution`, `feature-spec`, `implementation-plan`, `spec-crosscheck`, `test-driven-development`
**Impact report:** Phases run this turn, artifact state (constitution version, spec status, plan/tasks/crosscheck presence), next phase

---

### `project-constitution`
**Triggers:** "write a constitution", "define project rules", "set engineering invariants", "non-negotiable rules", "project policy", "set our standards", "/constitution"
**What it does:** Writes the project's irreducible engineering invariants — testing, security, performance, accessibility, dependencies, observability, migration, documentation. Each rule has a stable ID (`C-N.M`), is normative (MUST/MUST NOT/SHOULD), and is enforceable in review or CI. Versioned with an Amendments log. The third strategic artifact alongside AGENTS.md (agent behavior) and product-soul (strategy).
**Output file:** `docs/constitution.md` (versioned, ≤120 lines)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Called by:** `spec-driven-development` (`/constitution`), `project-setup` (when sdd_mode: on)
**Cited by:** `feature-spec`, `implementation-plan`, `spec-crosscheck`
**Impact report:** Version, categories populated, rules total, lines used (out of 120)

---

### `feature-spec`
**Triggers:** "write a feature spec", "executable spec", "/specify", "/clarify", "write the spec for this feature", "specification for", "spec-driven", "machine-readable spec"
**What it does:** Writes the executable feature specification — the WHAT and WHY artifact agents and reviewers treat as source of truth. Owns both `/specify` and `/clarify` modes. Sections: Summary, Problem, User Scenarios (US-N), Functional Requirements (FR-N), Non-Functional Requirements (NFR-N), Acceptance Criteria as Given/When/Then (AC-FR-N.M), Edge Cases, Out of Scope, Constitution Waivers, Needs Clarification (CL-N), Review Checklist. Hard gate: cannot mark `Approved` while any `[NEEDS CLARIFICATION]` markers remain.
**Modes:** `specify` (default — write new spec), `clarify` (resolve CL markers in existing spec)
**Output file:** `docs/specs/YYYY-MM-DD-<slug>-feature-spec.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Called by:** `spec-driven-development` (`/specify`, `/clarify`)
**References:** `references/feature-spec-schema.md` — full template, status lifecycle, cross-reference contract
**Impact report:** Status (Draft/Clarifying/Approved), constitution version, counts (US/FR/NFR/AC/Edge/CL), next phase

---

### `spec-crosscheck`
**Triggers:** "cross-check spec vs plan", "audit traceability", "verify spec readiness", "gate-check before implementation", "is this spec implementation-ready", "trace requirements to tasks", "/analyze", "spec sanity check", "spec readiness gate", "spec consistency check"
**What it does:** Hard readiness gate before implementation. Cross-checks constitution + feature-spec + plan + tasks for consistency, traceability, and unresolved ambiguity. Returns PASS or FAIL with `file:line` evidence. Six checks: (A) Spec readiness, (B) Constitution coverage, (C) Spec→Plan traceability, (D) Plan→Spec traceability (no scope creep), (E) Task quality (DoD + target), (F) Out-of-Scope adherence. Read-only — never modifies artifacts.
**Output file:** `docs/reviews/YYYY-MM-DD-<slug>-spec-crosscheck.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Called by:** `spec-driven-development` (`/analyze`)
**Reads:** `docs/constitution.md`, `docs/specs/<slug>-feature-spec.md`, `docs/plans/<slug>-plan.md`, `docs/plans/<slug>-tasks.md` (or `-TODO.md`)
**Impact report:** Verdict (PASS/FAIL), per-check verdicts, finding count by severity, implementation gated/unblocked

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
**See also:** `retroactive-project-setup` for backfilling agent infrastructure onto an existing codebase without modifying source code.

---

### `retroactive-project-setup`
**Triggers:** "retroactive project setup", "backfill agent infrastructure", "bootstrap agents for this existing repo", "onboard agents to a legacy codebase", "set up agents without touching code", "fill in missing agent context for this project"
**What it does:** Bootstraps the full agent layer (AGENTS.md, docs/architecture.md, docs/product-soul.md, ADR-0001 backfill, docs/memory/ seed) over an existing, already-coded project — without modifying source code, configs, manifests, lockfiles, or build files. Surveys the repo (manifests, README, CHANGELOG, git history, source samples) to auto-infer everything answerable, then runs a targeted ≤6-question interview only for genuine gaps. Tags low-confidence inferences with `[INFERRED — confirm]`. Enforces a strict write-allowlist; aborts on any out-of-allowlist write. Refuses if a populated AGENTS.md already exists and routes the user to `project-setup UPDATE_ONLY=true` instead.
**Calls:** `codebase-understanding` (architecture), `product-soul` (in inference mode for soul), `architectural-decision-log` (ADR-0001 synthesis), `project-setup` (with `RETROACTIVE=true` for AGENTS.md), `memory-capture` (checkpoint at end)
**Output files:** `AGENTS.md`, `docs/architecture.md`, `docs/product-soul.md`, `docs/adr/ADR-0001-initial-backfill.md`, `docs/memory/{project-index,current-state,agent-handoffs,learnings}.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Repo, mode (single/multi), files created, sub-skills invoked, `[INFERRED — confirm]` tag count, source files modified (always 0), synthetic handoff seeded
**Pairs with:** `project-setup` (interview-first, new/forward-looking projects) — this is the archaeology-first counterpart for legacy repos.

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

### `reality-check`
**Triggers:** "reality-check", "evaluate claims", "assess a project", "score these claims", "what's real vs marketing", "validate product claims", "is this real", "does this work as claimed", "evaluate this project", "assess the gap between claims and reality", "how credible is this", "investor assessment"
**What it does:** Evaluates any project, product, or system's claims against its actual implementation. Reads code, docs, commit history, and artifacts to verify every claim. Scores each claim numerically (1-10) with cited evidence. Identifies architectural gaps classified by severity. Compares against 3-5 competitors. Proposes creative solutions (lightweight/medium/heavyweight) for each gap. Produces two deliverables: a findings report and an actionable roadmap.
**Calls:** `adversarial-hat` (Step 7 — pressure-test strongest claims), `assumption-mapping` (Step 4 — surface hidden beliefs), `codebase-understanding` (Step 1 — map architecture), `implementation-plan` (Step 8 — structure roadmap)
**Output files:** `docs/YYYY-MM-DD-reality-check-findings.md` + `docs/YYYY-MM-DD-roadmap-and-implementation-plan.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Project name, claims evaluated, composite score, gaps by severity, competitors compared, solutions proposed, file paths

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

### `eval-output`
**Triggers:** "evaluate this output", "score this response", "run an eval", "LLM as judge", "evaluate agent output", "how good is this response", "rate this answer", "eval this"
**What it does:** Orchestrator for the eval-output skill suite. Accepts any LLM or agent output, classifies the evaluation need (rubric design, direct scoring, pairwise comparison, or pipeline design), and routes to the correct sub-skill. Presents unified evaluation reports.
**Calls:** `eval-rubric-design`, `eval-judge`, `eval-pipeline`
**Output:** Unified eval report in chat. Delegates actual work to sub-skills.
**Impact report:** Eval type, sub-skill invoked, dimensions scored, hard gates status, key finding

---

### `eval-rubric-design`
**Triggers:** "create an eval rubric", "define evaluation criteria", "design scoring dimensions", "what should I evaluate", "design a rubric", "evaluation rubric for", "how do I measure quality of"
**What it does:** Sub-skill of `eval-output`. Designs structured evaluation rubrics with quality dimensions, scoring scales, hard gates, score descriptions, and edge cases. Every criterion is observable and every score level has concrete descriptions. Supports 3-6 dimensions with mixed scales (pass/fail for gates, ordinal for quality).
**Called by:** `eval-output` (when rubric is needed before scoring)
**Output file:** `docs/evals/YYYY-MM-DD-<task>-rubric.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Dimensions, hard gates, scales used, applicable to (human/LLM/both), file path

---

### `eval-judge`
**Triggers:** "score this output", "judge this response", "evaluate against rubric", "rate this", "which response is better", "score this against the rubric", "LLM as judge this", "direct scoring", "pairwise comparison"
**What it does:** Sub-skill of `eval-output`. Scores outputs using LLM-as-judge — direct scoring against rubrics or pairwise comparison between two outputs. Built-in bias mitigation: position swap for pairwise, justification-before-score (15-25% reliability improvement), length bias awareness. Reports confidence per dimension.
**Called by:** `eval-output` (when scoring is needed)
**Output:** Structured eval report in chat. Optionally saves to `docs/evals/`.
**Impact report:** Mode (direct/pairwise), rubric used, dimensions scored, hard gates, confidence, verdict

---

### `eval-pipeline`
**Triggers:** "set up automated evals", "design an eval pipeline", "CI eval integration", "evaluation pipeline", "automate my evals", "continuous evaluation", "monitoring eval quality", "eval-driven development", "set up regression testing for my agent"
**What it does:** Sub-skill of `eval-output`. Designs automated multi-layer evaluation pipelines combining deterministic checks, statistical metrics, and LLM-as-judge scoring. Covers CI/CD integration, dataset design (happy path + edge cases + adversarial + known-bad), baseline establishment, alerting, and cost budgeting.
**Called by:** `eval-output` (when pipeline design is needed)
**Output file:** `docs/evals/YYYY-MM-DD-<system>-eval-pipeline.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Maturity stage, evaluator layers, dataset splits, CI integration, cost estimate, file path

---

### `frontend-design`
**Triggers:** "build a UI", "design a frontend", "build a landing page", "build a dashboard", "design a SaaS interface", "beautify a UI", "redesign this", "make this not look AI-generated", "give this real design polish", "frontend design"
**What it does:** Orchestrator for the frontend-design suite. Diagnoses the ask (one-shot / full app / refactor / direct sub-skill), routes through `design-archetype` → optional research → `design-tokens-craft` → `icon-craft` → build → `design-review`. Hard-bans defaults (Inter-only, Tailwind grays, purple→pink gradient, Lucide drop-in, centered hero with 2 CTAs, 3-col feature grid) without archetype-grounded justification. Mobile-first, dark-mode-first. Real working code only — no placeholders.
**Calls:** `design-archetype` (Step 2) → `design-tokens-craft` (Step 4) → `icon-craft` (Step 5) → `design-review` (Step 7). Max 2 review loops before escalating.
**Output files:** `.design/<feature>/ARCHETYPE.md`, `RESEARCH.md`, `TOKENS.md`, `ICONS.md`, `REVIEW.md`, plus `src/...` build
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/anti-vibecoded-checklist.md` (banned defaults + distinctive moves), `references/build-conventions.md` (mobile-first, motion, a11y, framework conventions), `references/one-shot-flow.md` (compressed flow for posters/single artifacts)
**Impact report:** Feature, archetype, path taken, sub-skills invoked, anti-vibecoded gates passed, review loops, distinctive moves applied

---

### `design-archetype`
**Triggers:** "pick an aesthetic", "choose a design direction", "what should this look like", "make this feel like Linear / Stripe / Apple / Duolingo", "give me a design direction", "classify this product visually" — or called by `frontend-design` Step 2
**What it does:** Sub-skill of `frontend-design`. Picks exactly one archetype from a curated catalog of 12: `b2b-productivity`, `enterprise-trust`, `premium-consumer`, `playful-consumer`, `editorial`, `brutalist-distinctive`, `dev-tool`, `marketing-landing`, `creative-tool` (Leonardo/Midjourney/Runway), `social-feed` (X/Threads/Bluesky), `conversational-ai` (ChatGPT/Claude/Perplexity), `spatial-canvas` (FigJam/Miro/tldraw). Each archetype = typography pair, color logic, motion philosophy, density, icon stance, 3 reference sites, anti-patterns. Scores candidates 0–3 on audience fit / job fit / distinctive fit. Outputs a `feels like X` claim grounded in a real product.
**Called by:** `frontend-design` (Step 2)
**Output file:** `.design/<feature>/ARCHETYPE.md`
**References:** `references/selection-rubric.md` + 12 archetype files in `references/archetypes/`
**Impact report:** Archetype selected, feels-like reference, top 3 scores, adaptations applied

---

### `design-tokens-craft`
**Triggers:** "generate design tokens", "create a design system", "set up CSS custom properties", "build a token scale", "design tokens for", "set up a theme" — or called by `frontend-design` Step 4
**What it does:** Sub-skill of `frontend-design`. Generates archetype-driven semantic tokens (color, typography, spacing, radius, motion, elevation). Hard-bans Tailwind-default palettes (`slate`, `zinc`, `gray`), Inter-only typography, purple→pink gradients, 9-step grayscale dumps, and inverted-lightness dark mode unless archetype demands it. Uses `oklch()` for color definitions. Outputs `tokens.css`, `tokens.ts`, and `TOKENS.md` rationale.
**Called by:** `frontend-design` (Step 4)
**Output files:** `src/styles/tokens.css`, `src/styles/tokens.ts`, `.design/<feature>/TOKENS.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/token-recipes.md` (per-archetype starter recipes), `references/typography-pairings.md` (paid + free pairings), `references/banned-palettes.md` (vibecoded tells)
**Impact report:** Archetype, recipe used, color/type slot counts, banned defaults rejected, files written

---

### `icon-craft`
**Triggers:** "pick icons", "design an icon set", "customize Lucide / Phosphor / Heroicons", "generate SVG icons", "make icons feel custom", "the icons look generic", "icons for this product" — or called by `frontend-design` Step 5
**What it does:** Sub-skill of `frontend-design`. Picks ONE icon strategy: `tuned-phosphor`, `custom-svg`, `hand-drawn`, `mixed-metaphor`, or `system-native`. Solves the "Lucide everywhere" vibecoded tell. Matches stroke weight to typography, defines grid/keyline/radius/terminal style, generates SVG component set when archetype demands custom. Bans default Lucide drop-in.
**Called by:** `frontend-design` (Step 5)
**Output files:** `src/icons/index.tsx`, `public/icons/*.svg`, `.design/<feature>/ICONS.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/icon-strategies.md` (5 strategies + per-archetype defaults), `references/svg-craft.md` (grid, stroke, optical sizing, terminal style, export rules)
**Impact report:** Strategy, source, icons inventoried, anti-Lucide-default audit, files written

---

### `design-review`
**Triggers:** "review this UI", "audit this design", "is this design good", "does this feel like Linear", "design QA", "evaluate visual quality", "check if this looks vibecoded" — or called by `frontend-design` Step 7
**What it does:** Sub-skill of `frontend-design`. Scores a built UI against its archetype's `feels like X` claim across 10 dimensions (archetype fidelity, anti-vibecoded gates, typography, color, iconography, layout & rhythm, motion, accessibility hard-gate, responsive, distinctive moves). Produces specific, prioritized fixes — never vibes-based feedback. Max 8 findings per pass, max 2 review loops before escalating. Supports paste-screenshot (manual) or Playwright MCP (automated multi-screen capture).
**Called by:** `frontend-design` (Step 7)
**Output file:** `.design/<feature>/REVIEW.md` (+ `AUTOMATED-AUDIT.md` if Playwright)
**References:** `references/review-rubric.md` (0–3 scoring per dimension with anchors + verdict thresholds), `references/playwright-flow.md` (capture matrix + automated checks)
**Impact report:** Review pass, verdict (SHIP/REVISE), hard gates, top dimension scores, findings raised

---

### `experimentation`
**Triggers:** "design an experiment", "A/B test this", "should we A/B test", "what should we test next", "analyse experiment results", "read out this experiment", "run a holdout test", "experiment on the landing page", "test this hypothesis", "is this lift real", "ship or kill this test"
**What it does:** Orchestrator for the experimentation skill suite. Diagnoses lifecycle stage (no idea yet → backlog; have idea → spec; have spec → runbook; have results → readout) and routes to the right child. Enforces decision-class labelling (`Causal | Directional | Instrumentation`), SRM hard gate before any readout, and pre-committed decision rules. Platform-agnostic with PostHog as the primary binding. Lifecycle-decomposed (not method-decomposed) — A/B / holdout / switchback / MAB are method choices inside `experiment-spec`.
**Calls:** `experiment-backlog`, `experiment-spec`, `experiment-runbook`, `experiment-readout`. Pre-route hooks: `assumption-mapping`, `brainstorming`, `inversion`, `fermi`, `eval-output`. Downstream: `prd-writing`, `architectural-decision-log`, `reality-check`.
**Output:** No files directly — children produce all artefacts under `docs/experiments/`. Returns lifecycle stage, decision class, child invoked, next step.
**References:** `references/method-selector.md` (A/B vs holdout vs switchback vs MAB vs quasi-experiment), `references/funnel-surface-map.md` (highest-ROI surfaces by funnel stage), `references/decision-class-rules.md` (gates per decision class)
**Impact report:** Lifecycle stage, child skill invoked, decision class, upstream/downstream skills called, output paths, next recommended step

---

### `experiment-backlog`
**Triggers:** "what should we test next", "build an experiment backlog", "prioritise our tests", "where should we experiment", "what's worth testing" — or called by `experimentation`
**What it does:** Sub-skill of `experimentation`. Turns assumptions, funnel observations, and product questions into a prioritised, feasibility-checked experiment backlog. Filters by traffic reality, metric latency, method fit, and population stability — not just ICE/RICE scoring. Maintains a living portfolio with status (idea → designed → running → readout → archived). Pulls upstream from `assumption-mapping` and `brainstorming` outputs when available.
**Called by:** `experimentation` (backlog path)
**Calls:** `assumption-mapping` (upstream), `fermi` (traffic estimates)
**Output file:** `docs/experiments/backlog.md` (living, updated)
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/prioritization-rubric.md` (ICE anchors + binary feasibility gate)
**Impact report:** Candidates added, candidates rejected with reason, top 3 ready, funnel coverage by stage, next recommended item

---

### `experiment-spec`
**Triggers:** "spec this experiment", "write the test plan", "design this A/B test", "what's the hypothesis", "how big a sample do we need", "how long should we run this", "define the metrics for this test" — or called by `experimentation`
**What it does:** Sub-skill of `experimentation`. Writes a rigorous, decision-grade experiment spec — falsifiable hypothesis, primary metric, guardrails, randomisation unit, exposure event, method (A/B / holdout / switchback / quasi / MAB), MDE/sample/duration plan, peek policy, validity threats, pre-committed decision rule. Platform-agnostic. Hard gates: decision class declared, falsifiable hypothesis, primary + ≥1 guardrail, MDE plan or Directional label, decision rule pre-committed, peek policy declared. Optionally calls `inversion` for failure-mode pre-mortem and `fermi` for sample sizing when traffic is unknown.
**Called by:** `experimentation` (spec path)
**Calls:** `inversion` (pre-mortem on validity threats), `fermi` (MDE/sample estimates)
**Output file:** `docs/experiments/specs/YYYY-MM-DD-<slug>-spec.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/mde-heuristics.md` (sample-size table by baseline + relative MDE), `references/validity-threats.md` (catalogue: SRM, novelty, primacy, interference, contamination, channel-mix, instrumentation drift, multiple comparisons, selection bias, long-term lag), `references/spec-template.md` (the spec doc structure)
**Impact report:** Spec path, decision class, method, primary + MDE, guardrails count, sample plan, validity threats listed, status (READY / DOWNGRADED / BLOCKED), next step

---

### `experiment-runbook`
**Triggers:** "set up the experiment", "wire this up in PostHog", "implement the test", "create the runbook", "launch checklist for this test" — or called by `experimentation`
**What it does:** Sub-skill of `experimentation`. Translates an approved spec into a launch runbook — feature flag setup, variant allocation, assignment unit, exposure event, instrumentation QA checklist, dashboard wiring, ramp plan (1% → 5% → 50% with SRM and guardrail gates), monitoring, and rollback procedure. Platform-agnostic body with one strong PostHog mapping shipped; GrowthBook / Statsig / LaunchDarkly / Optimizely / Eppo documented as a single mapping table the user adapts. Hard gates: no runbook without approved spec, exposure event verified firing in QA before any ramp, SRM dry-run at 1% and 5%, rollback documented.
**Called by:** `experimentation` (runbook path)
**Calls:** `problem-to-plan` (optional, if implementation tasks need breaking down)
**Output file:** `docs/experiments/runbooks/YYYY-MM-DD-<slug>-runbook.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/posthog-binding.md` (flags, exposures, cohorts, group analytics, dashboards, holdout pattern, common pitfalls), `references/vendor-mapping.md` (single mapping table covering 5 other platforms), `references/launch-qa-checklist.md` (pre-launch verification list, blocking)
**Impact report:** Runbook path, platform, flag key, allocation, ramp plan, QA pass count, rollback documented, status (READY / BLOCKED), next step

---

### `experiment-readout`
**Triggers:** "read out this experiment", "analyse the test", "did the test win", "interpret the results", "what did we learn", "ship or kill" — or called by `experimentation`
**What it does:** Sub-skill of `experimentation`. Analyses experiment results — runs validity checks (SRM, exposure parity, event-rate stability, novelty/primacy, segment sanity, multiple-comparisons hygiene, channel-mix stability), interprets causally, applies the pre-declared decision rule literally, and appends to cumulative learnings. Forces honest readouts: SRM-fail returns `INCONCLUSIVE` not a result; Directional tests cannot use the words "significant", "winner", "lift", or "ship". Hard gates: SRM check first and blocking; data integrity confirmed; decision matches pre-declared rule; learnings appended for every readout including failures.
**Called by:** `experimentation` (readout path)
**Calls:** `prd-writing` (when winner graduates to a permanent feature), `architectural-decision-log` (architecturally significant changes)
**Output files:** `docs/experiments/analyses/YYYY-MM-DD-<slug>-analysis.md` + appends to `docs/experiments/learnings.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/validity-checks.md` (SRM blocking gate, exposure parity, event stability, novelty windows, segment sanity, channel-mix), `references/readout-template.md` (full analysis doc structure), `references/learnings-format.md` (cumulative log entry format with confidence tagging)
**Impact report:** Analysis path, validity status (SRM/exposure/event), decision (SHIP/ITERATE/KILL/INCONCLUSIVE/SRM-FAIL), primary effect with CI, guardrails breached, learnings appended, downstream routes, next step

---

### `venture-exploration`
**Triggers:** "explore business ideas", "what business should I start", "should I build this", "is this a good business idea", "I have a startup idea", "evaluate this venture", "model this business", "validate this idea", "Mom Test", "Lean Canvas", "Business Model Canvas", "Value Proposition Canvas", "go/no-go on this idea"
**What it does:** Orchestrator for the pre-decision business-idea lifecycle. Diagnoses stage (no idea → generate; have idea → model; have model → evaluate; evaluated → validate; surviving idea → handoff) and routes to exactly one child. Holds a binding 5-criteria handoff gate to `product-soul` (named segment, specific JTBD, current alternative, plausible distribution wedge, declared next kill test). Pre-decision suite — once one idea is committed, hands off to `product-soul`, then `brainstorming` → `prd-writing` → `experimentation`.
**Calls:** `idea-generation`, `business-modeling`, `idea-evaluation`, `customer-discovery`. Downstream: `product-soul`, `brainstorming`, `prd-writing`, `experimentation`, `reality-check`.
**Output:** No file directly — children produce all artefacts under `docs/ventures/`. Returns lifecycle stage, child invoked, handoff-gate status, next step.
**References:** `references/routing-table.md` (stage diagnosis + out-of-scope routing + trigger overlap protection), `references/handoff-gate.md` (5-criteria check + override protocol)
**Impact report:** Stage, child invoked, prerequisites status, handoff gate (N/5), next recommended step, logged route

---

### `idea-generation`
**Triggers:** "generate business ideas", "give me startup ideas", "what should I build", "I don't know what to build", "ideate ventures", "blank-page idea generation", "find me a startup idea", "explore business opportunities" — or called by `venture-exploration`
**What it does:** Sub-skill of `venture-exploration`. Generates 5–10 idea candidates from founder/domain context using 2–3 of: pain mining, JTBD interrogation, trend × capability matrix, constraint relaxation, adjacency search, schlep blindness, live-in-the-future, RFS scan. Every card has 7 fields (segment, JTBD, current alternative, why-now, distribution wedge, monetisation, "feels like") and is tagged obvious/non-obvious. Hard-bans "everyone" segments and label-only ideas ("Uber for X" with no JTBD).
**Called by:** `venture-exploration` (generate path)
**Calls:** Optional `first-principles`, `socratic` only when stuck.
**Output file:** `docs/ventures/ideas/YYYY-MM-DD-batch.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/generation-methods.md` (8 methods + selection heuristic), `references/idea-card-template.md` (7-field template), `references/anti-patterns.md` (auto-strike rules)
**Impact report:** Methods used, candidates produced (struck), non-obvious count, top 3 by rough score, next action

---

### `business-modeling`
**Triggers:** "model this business", "fill the canvas", "Lean Canvas", "Business Model Canvas", "Value Proposition Canvas", "BMC", "VPC", "design the business model", "what's the business model" — or called by `venture-exploration`
**What it does:** Sub-skill of `venture-exploration`. Picks ONE primary canvas (Lean default, BMC for revenue/ops, VPC for value-prop fit) and fills it with falsifiable specifics. One segment, top-3 critical assumptions with measurable falsification thresholds, optional VPC appendix. Hard-bans "everyone" segments, generic channels ("SEO/social/content/ads"), and "unfair advantage = AI/data/network effects" without a concrete asset.
**Called by:** `venture-exploration` (model path)
**Calls:** `fermi` (when revenue/cost numbers unknown).
**Output file:** `docs/ventures/models/YYYY-MM-DD-<idea>-canvas.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/canvas-selector.md` (decision tree + stage heuristic), `references/canvas-templates.md` (Lean + BMC + VPC templates), `references/anti-patterns.md` (per-box fluff filter)
**Impact report:** Canvas chosen, VPC appendix yes/no, boxes filled with specifics, hypothesis-marked boxes, anti-pattern flags, top 3 critical assumptions

---

### `idea-evaluation`
**Triggers:** "evaluate this idea", "is this a good business idea", "score a startup idea", "screen this idea", "should I build this", "go/no-go on this idea", "kill or pursue", "is this worth pursuing" — or called by `venture-exploration`
**What it does:** Sub-skill of `venture-exploration`. Scores an unbuilt idea on 11 dimensions (desirability, viability, feasibility, distribution wedge, why-now, founder-market-fit, market size, current alternatives, defensibility, capital intensity, regulatory/ethical risk) and returns a binding GO / ITERATE / KILL verdict. Mandatory composite output: kill criteria (90-day) + next kill test (assumption, method, cost, timeline, owner, success/kill thresholds). Verdict gate trumps composite — KILL on any of: pain-not-painful, no plausible wedge, no why-now, fatal regulatory blocker, SOM below threshold, capital intensity exceeds runway.
**Called by:** `venture-exploration` (evaluate path)
**Calls:** `fermi` (SOM sizing), `assumption-mapping` (top 5 critical-unvalidated), optional `pre-mortem` + `adversarial-hat` for high-stakes (>3 mo or >$50k commit).
**Output file:** `docs/ventures/evaluations/YYYY-MM-DD-<idea>-eval.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/evaluation-rubric.md` (11 dimensions + 1–5 anchors + verdict gate), `references/kill-test-recipes.md` (7 cheap-test methods + thresholds), `references/anti-patterns.md` (vibecoded-business tells)
**Impact report:** Verdict, composite/55, SOM, top assumptions, anti-pattern flags, next kill test, file path

---

### `customer-discovery`
**Triggers:** "talk to customers", "validate the problem", "interview users", "Mom Test this", "did real users want it", "synthesize my interviews", "I just talked to N people", "design my interview guide", "run problem interviews" — or called by `venture-exploration`
**What it does:** Sub-skill of `venture-exploration`. Runs Mom Test–style problem-discovery interviews — designs the guide (30-min structure: context → past behaviour → workaround interrogation → currency → wrap, no pitching, no "would you use this"), coaches live interviews, or synthesizes completed batches. Codes every quote into one of seven categories (FACT, PAIN, CURRENCY, WORKAROUND, OPINION, COMPLIMENT, SOLUTION-TINTED) with explicit verdict weights. Hard-bans pitching, friend/family-only ICP, and treating compliments as validation. Min 5 interviews before any positive verdict; strong disconfirming evidence can kill earlier. Calls `secure-*` before synthesizing any pasted external transcripts.
**Called by:** `venture-exploration` (validate path), `idea-evaluation` (when next kill test = customer interview)
**Calls:** `secure-*` skills (mandatory before external transcript synthesis).
**Output file:** `docs/ventures/discovery/YYYY-MM-DD-<idea>-interviews.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**References:** `references/mom-test-rules.md` (3 core rules + bad→good question rewrites + signal weights), `references/interview-guide-template.md` (recruiting message + 30-min structure + probe banks), `references/synthesis-template.md` (7-code coding scheme + cross-interview aggregation + assumption-update format)
**Impact report:** Mode (design/coach/synthesize), interviews count, painful-problem reports, currency evidence, verdict (CONFIRMED / WEAKENED / KILLED / NEED-MORE), assumption updates pushed

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

### `agent-builder`
**Triggers:** "design an agent for this", "what agent structure do I need", "architect this", "should this be multi-agent", "what's the right execution structure"
**What it does:** Designs execution structure for decomposed processes. Decides single agent or multi-agent topology. For multi-agent: defines boundaries, chooses topology (sequential/parallel/hierarchical), specifies handoff protocols. Persists architecture specs for the learning loop and triggers setup evaluation before orchestration.
**Calls:** `agent-system-architecture` (complex topology), `create-agent-prompt` (role prompts), `setup-evaluation` (via setup-evaluator agent), `project-orchestrator` (downstream)
**Output file:** `docs/architecture/YYYY-MM-DD-<task-slug>-arch.md`
**Logged to:** `docs/skill-outputs/SKILL-OUTPUTS.md`
**Impact report:** Structure chosen, agents defined, architecture spec path, process entry linked

---

### `setup-evaluation`
**Triggers:** "evaluate this setup", "check the decomposition", "validate the architecture", "is this plan sound"
**What it does:** Validates process decomposition and architecture design before execution. Checks step coverage, tool availability, parallelism consistency, agent boundaries, handoff protocols, and cross-validates spec linkage. Returns PASS or FAIL with specific issues. Runs from setup-evaluator agent (separate from agent-builder to avoid confirmation bias).
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
**Called by:** `agent-builder`, user (direct)
**Output:** Prompt text ready to embed in AGENTS.md or architecture spec
**Impact report:** Agent name, topology role, handoff defined, failure behavior defined

---

### Agents

### `setup-evaluator` (agent)
**Spawned by:** `agent-builder` after it writes the architecture spec for `agent-chain` processes
**Skills:** `setup-evaluation`
**What it does:** Runs between architecture design and orchestration config. Validates the setup independently from the architect. On FAIL: returns issues to agent-builder. On PASS: hands off to project-orchestrator.
**Why an agent:** Independence from agent-builder prevents confirmation bias.

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
  learn-from               ← "learn from" / "learn from this" / "extract insights from"
  eval-output              ← "evaluate output" / "score this response" / "run an eval" / "LLM as judge"
  reality-check            ← "reality-check" / "evaluate claims" / "is this real"
  project-setup            ← "set up this project" / "create an AGENTS.md"
  project-orchestrator     ← "what should I do next" / "orchestrate" / "parallel tasks"
  spec-driven-development  ← "spec-driven development" / "SDD" / "specs-first" / "/specify" / "/plan" / "/analyze"
  venture-exploration      ← "explore business ideas" / "what should I build" / "evaluate this venture" / "is this a good business idea"

venture-exploration → idea-generation (generate stage)
                    → business-modeling (model stage)
                    → idea-evaluation (evaluate stage)
                    → customer-discovery (validate stage)
                    → product-soul (handoff after 5/5 gate passes)

idea-evaluation → fermi (SOM sizing, always)
                → assumption-mapping (top 5 critical-unvalidated, always)
                → pre-mortem + adversarial-hat (high-stakes, optional)

business-modeling → fermi (when revenue/cost numbers unknown)

customer-discovery → secure-* skills (mandatory before external transcript synthesis)

idea-generation → first-principles, socratic (optional, when stuck)

universal-skill-creator → research-skill (Step 2, always)
                        → split-skill (Step 7, if >200 + seam)
                        → compress-skill (Step 7, if >200, no seam)
                        → validate-skills (Step 8, quality gate)
                        → skill-deconflict (Step 8, name/trigger gate)
                        → library-skill (after creation, to sync indexes)
                        → publish-skill (Step 9, optional)

improve-skills → validate-skills (Step 1, pre-flight)
                   → deprecate-skill (if score 0–5/14, user decides)
               → [ingest docs/learnings/chat-learnings.md] (Step 1b, triage OPEN entries)
               → prune-skill (Step 2a, per skill)
               → research-skill (Step 2e, per skill — skipped when SKIP_RESEARCH=true)
               → split-skill (Step 2j, if >200 + seam)
               → compress-skill (Step 2j, if >200, no seam)
               → skill-deconflict (Step 2h, per skill)
               → cross-link-skills (Step 3)
               → library-skill (after structural changes)
               → [close chat-learnings] (Step 2l, write terminal statuses back)

project-orchestrator → skill-routing (Step 2, always)
                     → [any skill] (routes based on project state + user intent)
                     → project-setup (if no AGENTS.md exists)

learn-from → learn-from-paper (if academic paper/PDF/arXiv)
           → learn-from-repo (if GitHub/GitLab repo)
           → learn-from-article (if blog/web article)
           → learn-from-chat (if in-conversation learning)

learn-from-paper → secure-* skills (Step 3, mandatory)
                 → universal-skill-creator (Step 6, if creating new skill)
                 → apply-paper-to-project (Step 6, if improving project)
                 → validate-skills (Step 6, post-apply)

learn-from-repo → secure-* skills (Step 3, mandatory, esp. repo-ingestion)
                → universal-skill-creator (Step 6, if creating new skill)
                → validate-skills (Step 6, post-apply)

learn-from-article → secure-* skills (Step 3, mandatory)
                   → universal-skill-creator (Step 6, if creating new skill)
                   → validate-skills (Step 6, post-apply)

learn-from-chat → validate-skills (Step 5, post-apply, in-scope path only)
                → improve-skills TARGET=<skill> SKIP_RESEARCH=true (Step 5 escalation for restructure-class edits or >200-line skills)
                → [append entry with Status field] (Step 6, docs/learnings/chat-learnings.md)

apply-paper-to-project → architectural-decision-log (optional, for significant changes)

project-setup → generates AGENTS.md with Orchestration Map (references project-orchestrator)
              → project-constitution (when sdd_mode: on and no constitution exists)

spec-driven-development → project-constitution (/constitution)
                        → feature-spec (/specify, /clarify)
                        → implementation-plan (/plan, /tasks)
                        → spec-crosscheck (/analyze)
                        → test-driven-development (/implement, default)

feature-spec → project-constitution (offers if no docs/constitution.md)

implementation-plan → feature-spec (gates on Approved status if present)
                    → project-constitution (reads C-N rules for traceability)

spec-crosscheck → reads only (constitution + feature-spec + plan + tasks); modifies nothing

brainstorming → feature-spec (Step 10 handoff for SDD projects)
              → prd-writing (Step 10 handoff for product framing)
              → implementation-plan (Step 10 handoff for direct execution)

compress-skill → split-skill (if CORE still >200 after classify)
split-skill      → library-skill (after extracting child skill)
deprecate-skill  → library-skill (after retiring skill)
library-skill        → generate-changelog (final step, always)

eval-output → eval-rubric-design (if rubric needed)
           → eval-judge (if scoring/comparison needed)
           → eval-pipeline (if automated eval system needed)

reality-check → adversarial-hat (Step 7, pressure-test claims)
              → assumption-mapping (Step 4, surface hidden beliefs)
              → codebase-understanding (Step 1, map architecture)
              → implementation-plan (Step 8, structure roadmap)

experimentation → experiment-backlog (if user has no candidate)
                → experiment-spec (if user has hypothesis or candidate)
                → experiment-runbook (if spec approved)
                → experiment-readout (if results exist)
   pre-route hooks: assumption-mapping, brainstorming, inversion, fermi, eval-output
   downstream: prd-writing, architectural-decision-log, reality-check

experiment-spec → inversion (pre-mortem on validity threats)
                → fermi (sample-size estimation when traffic unknown)

experiment-runbook → problem-to-plan (optional, for implementation tasks)

experiment-readout → prd-writing (winner graduates to feature)
                   → architectural-decision-log (significant changes)

Leaf nodes (call nothing):
  validate-skills  research-skill  prune-skill  publish-skill  generate-changelog  skill-routing  skill-deconflict
  eval-rubric-design  eval-judge  eval-pipeline
  project-constitution  spec-crosscheck
```
