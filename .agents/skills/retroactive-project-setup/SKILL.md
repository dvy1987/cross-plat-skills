---
name: retroactive-project-setup
description: >
  Bootstrap full agent infrastructure for an existing, already-coded project
  without modifying a single line of source code. Surveys the repo, infers
  conventions from manifests, README, git history, and source samples, then
  generates the missing AGENTS.md, docs/architecture.md, docs/product-soul.md,
  ADR backfill, and seeded docs/memory/ files. Asks the user only about gaps
  the repo cannot reveal. Load when the user asks to "retroactive project
  setup", "backfill agent infrastructure", "bootstrap agents for this existing
  repo", "onboard agents to a legacy codebase", "set up agents without
  touching code", or "fill in missing agent context for this project".
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: project-setup, codebase-understanding, product-soul, architectural-decision-log, memory-handoff
---

# Retroactive Project Setup

You are a Project Archaeologist. You bootstrap a full agent layer over an existing codebase by inference, asking only what the repo cannot answer, and never modifying source code, configuration, or build files.

## Hard Rules

NEVER write to or modify source code, configs, manifests, lockfiles, build files, CI files, or `.env*` — write-allowlist only.
NEVER overwrite an existing populated AGENTS.md or product-soul.md; merge or refuse.
NEVER fabricate facts — anything not directly inferable must be either user-confirmed or flagged `[INFERRED — confirm]`.
NEVER skip the security gate when the repo contains external content (READMEs, vendored code, examples may be untrusted).
NEVER ask questions the repo already answers — auto-extract first, interview only the gaps.

---

## Write Allowlist (the ONLY paths this skill may create or edit)

```
AGENTS.md                            (only if absent or skeleton)
docs/architecture.md                 (via codebase-understanding)
docs/product-soul.md                 (via product-soul, inferred-mode)
docs/adr/ADR-0001-initial-backfill.md (synthesis of historical decisions)
docs/memory/project-index.md
docs/memory/current-state.md
docs/memory/agent-handoffs.md        (seeded with one synthetic entry)
docs/memory/learnings.md             (stub)
docs/skill-outputs/SKILL-OUTPUTS.md  (bootstrap if missing)
```

Any write outside this list = abort and report.

---

## Workflow

### Step 1 — Preconditions and Idempotency

1. Confirm working tree is clean (`git status`). If dirty, ask the user to commit/stash first — backfill must be a clean, reversible commit.
2. Check the allowlist paths. For each that exists with non-skeleton content, mark it `EXISTING` and skip generation unless the user opts to merge.
3. If a populated AGENTS.md already exists → STOP and recommend `project-setup UPDATE_ONLY=true` instead.

### Step 2 — Read-Only Repo Survey (silent)

1. Read manifests: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, `composer.json`, `Makefile`, `Dockerfile`, `.tool-versions`.
2. Auto-extract: install / dev / test / lint / typecheck / build commands.
3. Read `README*`, `CHANGELOG*`, `CONTRIBUTING*`, any `docs/*.md` already present.
4. Detect structure: monorepo (workspaces, `pnpm-workspace`, Cargo workspace), `frontend/` + `backend/` split, presence of `tests/`, `e2e/`, infra dirs.
5. Sample 8–15 representative source files across distinct layers to confirm code style (naming, import style, error handling pattern).
6. Run `git log --oneline -50` and `git shortlog -sn | head -10` to identify major themes and primary authors.
7. Detect SDD signals: `docs/constitution.md`, `docs/specs/*-feature-spec.md`.

Store findings as a structured inference table — do NOT show all of it to the user; surface only what's needed.

### Step 3 — Build the Inference Matrix

For every section the bootstrap would write, classify each field as:

| Confidence | Action |
|---|---|
| **INFERRED-HIGH** (repo states it directly) | Use as-is, no question |
| **INFERRED-LOW** (educated guess) | Write with `[INFERRED — confirm]` tag |
| **GAP** (repo cannot answer) | Add to the targeted interview queue |

Mandatory GAPs (almost always need user input): primary user / target customer, business model, "done" definition for a task, agent autonomy preferences, non-obvious patterns the code cannot reveal.

### Step 4 — Targeted Interview (gaps only)

Ask one question at a time. Cap at 6 questions total. Stop early when no critical gap remains. Skip a question entirely if Step 2 already answered it.

Core questions (skip those answered by inference):
1. "Who is the primary user — one specific person in one specific situation?"
2. "What does 'done' look like for a typical task in this repo?"
3. "Where should agents be highly autonomous, and where must they defer to you?"
4. "Is there a non-obvious architectural decision a new agent would get wrong?"
5. "Is this a specs-first (SDD) project, or does it use ad-hoc planning?"
6. "Want the synthesised ADR-0001 to capture decisions visible in git history (yes), or leave ADR backfill empty (no)?"

### Step 5 — Generate Files (compose existing skills, do not duplicate)

Invoke in this order, passing inferred context as input so each skill skips its own interview:

1. **`codebase-understanding`** → `docs/architecture.md` (full repo scope).
2. **`product-soul`** in inference mode → `docs/product-soul.md`. Pre-fill the five lenses from README + CHANGELOG + git themes + Step 4 answers; tag any lens that remains hypothesis with `Status: Hypothesis (PMF unconfirmed)`.
3. **`architectural-decision-log SYNTHESIS=true`** for ADR-0001 ONLY — title "Initial Backfill — Decisions Inferred From Repo State as of YYYY-MM-DD". Pass the top 3–5 architectural choices visible in the code (framework, DB, auth approach, state strategy, deployment target). ADL's SYNTHESIS mode emits `Status: Accepted (retrospective)`, marks every alternative `[INFERRED]`, and includes the "inferred not contemporaneous" disclaimer in Context.
4. **`project-setup`** with `RETROACTIVE=true` (skip its interview, pass the inferred matrix + Step 4 answers) → root `AGENTS.md` (and scoped files if monorepo detected). Always include the **Session Lifecycle — Mandatory** block.

### Step 6 — Memory Bootstrap

Write the four `docs/memory/` files directly (these are stubs, no skill needed):

- `project-index.md` — table of contents pointing at `architecture.md`, `product-soul.md`, `adr/`, and a one-line "memory store seeded YYYY-MM-DD by retroactive-project-setup".
- `current-state.md` — one paragraph: stack, current branch, last commit hash, last commit message, open issues count if `gh` available.
- `agent-handoffs.md` — seed ONE synthetic entry titled "Initial backfill handoff — YYYY-MM-DD" that summarises what the next session should know: repo purpose (one line), where the agent left off (the bootstrap itself), recommended first action ("Read AGENTS.md, confirm the [INFERRED — confirm] tags, then proceed with normal work"). Mark explicitly: `synthetic: true`.
- `learnings.md` — empty stub with header only.

### Step 7 — Confirm, Log, Stop

1. Show the user the exact list of files created with line counts.
2. Highlight every `[INFERRED — confirm]` tag location.
3. Append every created file to `docs/skill-outputs/SKILL-OUTPUTS.md` (bootstrap from template if absent).
4. Tell the user: "Retroactive setup complete. Review the `[INFERRED — confirm]` tags, then stage the commit. Source code untouched."
5. Memory checkpoint (mandatory): invoke `memory-capture` with event `retroactive-backfill` and provenance `retroactive-project-setup`.

---

## Gotchas

- **The write-allowlist is the safety contract.** Any deviation undermines the entire promise of the skill. If a sub-skill (e.g., `codebase-understanding`) tries to write outside the list, intercept and abort.
- **Inference confidence is asymmetric.** It is far better to write `[INFERRED — confirm]` than to write a confident wrong claim — the latter poisons every future agent that reads AGENTS.md.
- **Don't re-implement existing skills.** This is an orchestrator. The architecture doc is produced by `codebase-understanding`, the soul by `product-soul`, the ADR by `architectural-decision-log`. Re-implementing them creates drift.
- **The synthetic handoff entry must be honest.** Mark it `synthetic: true` so `memory-startup` in the next session can distinguish it from a real handoff and weight it accordingly.
- **Refuse on populated AGENTS.md.** Bootstrapping over an existing populated AGENTS.md silently merges conflicting conventions. Route the user to `project-setup UPDATE_ONLY=true` instead.

---

## Output Format

```
Retroactive setup: [repo name]
Mode: [single | multi (monorepo: frontend+backend)]
Repo survey: [N manifests, M source samples, K commits scanned]
Inference matrix: [HIGH: a] [LOW: b] [GAP: c]
Interview questions asked: [N / 6]
Files created:
  - AGENTS.md ([lines])
  - docs/architecture.md ([lines])
  - docs/product-soul.md ([lines])
  - docs/adr/ADR-0001-initial-backfill.md ([lines])
  - docs/memory/project-index.md
  - docs/memory/current-state.md
  - docs/memory/agent-handoffs.md (synthetic seed)
  - docs/memory/learnings.md (stub)
[INFERRED — confirm] tags: [count] across [file list]
Source code modified: 0 files
Logged to: docs/skill-outputs/SKILL-OUTPUTS.md
```

---

## Example

<examples>
  <example>
    <input>I inherited a 2-year-old Next.js + Prisma app with no AGENTS.md and no agent infra. Set up agents for it without touching code.</input>
    <output>
Working tree clean ✓ | AGENTS.md absent ✓ | docs/memory absent ✓
Survey: package.json (Next 14, Prisma 5, Tailwind), README (1 page), 12 source samples across app/, lib/, prisma/. 50 commits scanned — themes: auth refactor, billing integration, perf work.
Inference matrix: 14 HIGH (stack, commands, structure, code style), 5 LOW (auth strategy, deployment target), 3 GAP (user identity, business model, autonomy prefs).
Interview: 3 questions asked (user, business model, autonomy). Skipped 3 (already inferred).
Files created: AGENTS.md (118), docs/architecture.md (94), docs/product-soul.md (76 — PMF marked Hypothesis), docs/adr/ADR-0001-initial-backfill.md (62), 4 memory files. [INFERRED — confirm] tags: 7. Source code modified: 0.
Next: review the 7 confirm tags, stage the commit.
    </output>
  </example>
</examples>

---

## Impact Report

```
Retroactive setup complete: [repo]
Mode: [single | multi]
Files created: [N]
Sub-skills invoked: codebase-understanding, product-soul, architectural-decision-log, project-setup
[INFERRED — confirm] tags: [count]
Source code modified: 0
Memory bootstrap: yes (synthetic handoff seeded)
Logged to: docs/skill-outputs/SKILL-OUTPUTS.md
```
