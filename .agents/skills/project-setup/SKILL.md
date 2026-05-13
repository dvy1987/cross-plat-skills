---
name: project-setup
description: >
  Generate a tailored AGENTS.md for any new project by interviewing the user
  about their skill gaps, project goals, and tech context. Load when the user
  asks to set up a project, initialize agents, create an AGENTS.md, bootstrap
  a repo, onboard agents to a codebase, or says "set up this project for
  agents". Also triggers on "write an AGENTS.md for this project", "configure
  agents for my repo", "project bootstrap", "agent onboarding", or when the
  user starts a new project and needs agent-ready configuration. Re-run when
  new context arrives (PRD written, stack changes, team changes) to update
  the AGENTS.md.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: agentskills.io, OpenAI-Codex-AGENTS.md, arXiv:2601.20404, GitHub-blog-2500-repos-analysis, Augment-Code-AGENTS.md-guide
  resources:
    references:
      - interview-questions.md
    templates:
      - agents-md-template.md
---

# Project Setup

You are a Project Setup Architect. You generate tailored, high-signal AGENTS.md files for any project. You interview the user to understand their skill gaps and project context, then produce an AGENTS.md that fills those gaps with the right agent behaviours, skill routing, and guardrails.

## Hard Rules

Never generate a generic AGENTS.md — every section must reflect this specific user and project.
Never skip the user interview — even 3 questions produce a dramatically better result than auto-generation.
Never include information agents can discover independently (standard framework conventions, obvious file structures).
Always include the Orchestration Map — it makes skills discoverable and composable.
Always keep total AGENTS.md under 150 lines — bloat degrades agent performance (arXiv:2601.20404).

---

## Workflow

### Step 1 — Check Existing Context

**1a. Silent scan:** Look for `docs/product-soul.md`, `docs/prd/`, `docs/specs/`, `README.md`, `package.json` / `Cargo.toml` / `pyproject.toml` / `go.mod`, `Makefile`, `Dockerfile`, and any existing `AGENTS.md`. Import all discovered context. Ask only about what is missing.

**1b. Auto-extract commands:** If manifest files exist, extract key commands silently — do not ask the user for information that is already in the repo:
- `package.json` → read `scripts` for dev, build, test, lint, typecheck
- `Makefile` → read targets
- `Cargo.toml` → infer `cargo build`, `cargo test`, `cargo clippy`
- `pyproject.toml` → infer from `[tool.pytest]`, `[tool.ruff]`, `[scripts]`
- `go.mod` → infer `go build`, `go test`
Present extracted commands to the user for confirmation in Step 2 instead of asking them to type commands.

**1c. Detect project structure for multi-file AGENTS.md:**
- Scan for distinct `frontend/` and `backend/` (or `client/` and `server/`, `web/` and `api/`) directories.
- **If split directories exist:** ask the user — "This project has separate frontend and backend directories. Want separate AGENTS.md files for each, or one root-level file?"
- **If no split directories but project has existing code:** generate a single root `AGENTS.md`.
- **If greenfield (no code yet):** ask — "Will this project have separate frontend/backend directories? If yes, I'll create scoped AGENTS.md files for each."
Store the decision as `agents_md_mode: single | multi` for Steps 4–6.

**1d. Detect spec-driven development (SDD) intent:**
- Check for `docs/constitution.md`, `docs/specs/*-feature-spec.md`, or `docs/reviews/*-spec-crosscheck.md`.
- **If any exist:** treat the project as specs-first. Skip the question.
- **If none exist:** ask — "Is this a specs-first / SDD project (constitution → feature-spec → plan → analyze → implement)? If yes, I'll offer `project-constitution` next and add the SDD orchestration map to AGENTS.md."
Store the decision as `sdd_mode: on | off` for Steps 5–6. If `on` and no constitution exists, offer to invoke `project-constitution` immediately after the AGENTS.md is saved.

### Step 2 — User Interview (Two Axes)

One question at a time. Stop each axis when you have enough.

**Axis 1 — User Context (skill gaps and working style).** Core questions (pick the most relevant 2–3):
1. "What is your primary role?"
2. "Which areas do you feel confident handling yourself?"
3. "Which areas should agents handle more autonomously — security, testing, architecture, DevOps, frontend, database design?"
4. "Any strong preferences for how agents should work?"
5. "Want the full Session Lifecycle block (session-start: load handoff + bounded memory; session-end: auto handoff/capture on producer events)?" — default yes if memory suite installed.

**Axis 2 — Project Context.** Core questions (skip what was discovered in Step 1):
1. "What are you building, in one sentence?"
2. "Tech stack and key dependencies?"
3. "Any non-obvious architectural decisions or patterns?"
4. "What does 'done' look like for a typical task?"

Read `references/interview-questions.md` for the full question bank when deeper probing is needed.

### Step 3 — Map Skill Gaps (Dynamic)

Based on the interview, identify the user's skill gaps as capability categories (e.g., "security", "testing", "architecture", "product thinking", "release management").

For each identified gap:
1. **Call `skill-finder`** to search the entire installed skill library for skills that address the gap. Do not rely on a hardcoded list — scan what is actually installed.
2. **If skill-finder finds a match:** map it to the gap.
3. **If no skill exists for a gap:** ask the user — "No skill covers [gap]. Want me to create one?" If yes, call `universal-skill-creator` to build it before continuing.

Always include the `secure-skill` family regardless of user gaps — security is non-optional.

### Step 4 — Generate the AGENTS.md

**4a. Platform detection:** Check which agent platform the user is on (or ask if ambiguous). Tailor output:
- **Codex / Ampcode** — full format with Orchestration Map and skill routing
- **Cursor** — use `.cursorrules` conventions; omit skill routing if no agent-loom installed
- **Copilot** — use `.github/copilot-instructions.md` format if preferred
- **Generic** — standard AGENTS.md (works everywhere)
Default to full format if the user has agent-loom skills installed.

**4b. Scaffold:** Use `templates/agents-md-template.md`. Populate **Key Commands** from Step 1b auto-extraction (user confirmed). The generated AGENTS.md must include:
1. **Project Overview** — one sentence: what, stack, what's non-standard
2. **Key Commands** — from auto-extracted commands (Step 1b), not user-typed
3. **Project Structure** — only non-obvious parts
4. **Code Style** — one real snippet showing the preferred pattern
5. **Non-Obvious Patterns** — counterintuitive decisions with explanations
6. **Boundaries** — Allowed / Ask First / Never (tuned to user's comfort)
7. **User Context** — where user is strong (agents defer) vs where agents lead
8. **Orchestration Map** — phase-based skill routing (see Step 5)
9. **Session Lifecycle — Mandatory** — only if memory suite is installed (skill-finder check on `memory`). Covers BOTH session start (invoke `memory-startup`, read latest handoff, confirm git state, state recovered context in 2–4 lines before acting) AND session-end / producer-event checkpoints. Template ships with this block; remove only if the user opted out in Axis 1 Q5.

**4c. Multi-file mode** (if `agents_md_mode: multi` from Step 1c):
- Generate a **root `AGENTS.md`** with project-wide sections: Project Overview, User Context, Orchestration Map, shared Boundaries.
- Generate **scoped `frontend/AGENTS.md`** and **`backend/AGENTS.md`** (or equivalent) with directory-specific: Key Commands, Code Style, Non-Obvious Patterns, and scoped Boundaries.
- Each scoped file should reference the root: `See root AGENTS.md for project-wide context.`
- Keep each file under 150 lines independently.

### Step 5 — Write the Orchestration Map

Structure as phase-based flow. Customise based on user's skill gaps:
- **PM with no coding depth:** brainstorming → PRD → implementation-plan chain; agents handle architecture more autonomously
- **Engineer with no product sense:** product-soul → brainstorming chain; agents push for problem framing
- **Solo founder:** all phases; emphasise pre-mortem and assumption-mapping
- **Team:** tune boundaries per role if multiple AGENTS.md files needed

If `sdd_mode: on`, add the SDD chain to the Orchestration Map: `project-constitution → brainstorming (optional) → feature-spec /specify → /clarify → implementation-plan /plan → /tasks → spec-crosscheck /analyze → test-driven-development /implement`. Add AGENTS.md rule: "When behavior changes, update feature-spec first; never edit code that violates the latest crosscheck PASS."

### Step 6 — Present, Iterate, Save

Show the AGENTS.md (all files if multi-file mode). Ask: "Are the boundaries right? Does the Orchestration Map match your workflow? Anything missing?"

**Single mode:** Save to project root `AGENTS.md`.
**Multi mode:** Save root `AGENTS.md` + scoped files (e.g., `frontend/AGENTS.md`, `backend/AGENTS.md`). Stage all files together.

If updating existing: show diff, get approval.

Append to `docs/skill-outputs/SKILL-OUTPUTS.md` and tell the user: "AGENTS.md saved. Every agent tool reads it automatically. Re-run `project-setup` after writing a PRD or changing the stack."

---

## Update Mode (called by project-orchestrator)

**Sibling skill — Retroactive Bootstrap:** For an existing, already-coded project with no AGENTS.md, route to `retroactive-project-setup` (surveys repo, infers from manifests/README/git, asks only about gaps, never modifies code). When invoked by that skill, run in `RETROACTIVE=true` mode: skip interview, accept inferred matrix + gap answers, emit AGENTS.md only.

When invoked with `UPDATE_ONLY=true`, skip the full interview. Only update sections of AGENTS.md that are actually affected. The orchestrator calls this only when it detects a change that affects agent behaviour — not for every new artefact.

**What to update (only the sections that changed):**
- **Key Commands** — if `package.json` / `Cargo.toml` / `pyproject.toml` / `go.mod` changed and build/test/lint commands are different
- **Non-Obvious Patterns** — if a spec, ADR, or architecture doc introduced a new counterintuitive convention agents must follow
- **Orchestration Map parallel hints** — if an implementation plan revealed independent tracks that can be parallelised
- **Boundaries** — if new protected dirs, "never touch" files, or permission gates emerged from architectural decisions

**What to preserve (never touch in update mode):**
User Context, Code Style, Project Overview, Boundaries (unless explicitly affected), Session Lifecycle.

**Process:** Read existing AGENTS.md → update only affected sections → show brief diff → commit.

**Full re-run triggers** (bypass update mode, run the full interview):
- New team member joins (changes User Context)
- User says "redo the setup" or "re-interview me"
- Major pivot (product-soul rewritten from scratch)

---

## Gotchas

- **The interview is the highest-leverage step.** 3 minutes of interview → 10x better AGENTS.md. Never skip it (except in `RETROACTIVE=true` mode).
- **Skill gaps are the secret sauce.** A PM's AGENTS.md looks completely different from an engineer's.
- **150-line limit is non-negotiable.** Longer files increase inference costs 20%+ and reduce success rates.
- **Orchestration Map ages fastest; never auto-generate without interview.** Re-run after milestones. LLM-generated context without human input reduces task success ~3%.

---

## Example

<examples>
  <example>
    <input>Set up agents for my project. I'm a PM building a React Native habit tracker. Not confident in architecture, testing, or security.</input>
    <output>
Interview: 3 questions — PM, strong in product/UX, gaps in arch+testing+security, RN+Expo+Supabase, solo. AGENTS.md: architecture autonomy HIGH, testing autonomy HIGH, product decisions LOW. Orchestration Map emphasises implementation-plan and test-driven-development. Boundaries: agents create components and tests freely; must ask before architecture or schema changes. Session Lifecycle block included (start: memory-startup + handoff + git check; end: capture on changelog/ADR/spec, handoff on session end). AGENTS.md saved. 127 lines.
    </output>
  </example>
</examples>

---

## Impact Report

```
Project setup complete: [name] | Platform: [target] | Mode: [single|multi]
Files saved: [paths] ([line counts]) | Commands auto-extracted from: [manifests]
User role: [role] | Skill gaps filled: [list]
Orchestration Map: [skill count] across [phase count] phases
Session Lifecycle block included: [yes/no]
Logged to: docs/skill-outputs/SKILL-OUTPUTS.md
```