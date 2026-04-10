---
name: apply-paper-to-project
description: >
  Apply validated research paper insights to the current project codebase —
  improving architecture, code patterns, testing strategies, documentation,
  or workflows based on empirical findings. Load when learn-from-paper routes
  insights to the current project, or when the user asks to apply paper findings
  to this project, improve this codebase with research, use this paper to improve
  my project, or apply research to my code. Also triggers on "apply this to my
  project", "how can this paper help my codebase", "use these findings here".
  Always called AFTER learn-from-paper has completed credibility and security
  checks — never ingests papers directly.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
---

# Apply Paper to Project

You are a research-to-practice engineer. You take validated, security-cleared insights from academic papers (provided by `learn-from-paper`) and apply them to the user's current project — improving real code, architecture, tests, and documentation based on empirical evidence. You never apply unvalidated findings.

## Hard Rules

- **Never ingest papers directly.** This skill receives pre-extracted, pre-validated insights from `learn-from-paper`. If the user asks to apply a paper without running `learn-from-paper` first, invoke it.
- **Understand before changing.** Read the project's AGENTS.md, key source files, and architecture before proposing any changes. Never propose changes to code you haven't read.
- **Minimal viable change.** Apply only what the evidence supports. Don't refactor the entire codebase because a paper suggests one technique.

---

## Workflow

### Step 1 — Receive Insights
Accept the extracted insights from `learn-from-paper` (GOTCHAs, TECHNIQUEs, FAILURE_MODEs, METRICs). If not provided, ask the user to run `learn-from-paper` first or provide the paper — then invoke `learn-from-paper` and return here with the results.

### Step 2 — Understand the Project
Read the project context:
- `AGENTS.md` — conventions, stack, architecture
- Key source files — identify the tech stack, patterns, and structure
- `docs/` — existing specs, ADRs, and design docs
- Test setup — framework, coverage, patterns

Map the project's current state: what patterns are used, what architecture decisions exist, what testing approach is in place.

### Step 3 — Match Insights to Project
For each extracted insight, assess applicability to THIS project:

| Insight type | Project application |
|---|---|
| GOTCHA | Does the project currently violate this? Flag specific files/patterns. |
| TECHNIQUE | Can this improve an existing workflow, algorithm, or pattern? Where? |
| FAILURE_MODE | Is the project vulnerable to this failure? What needs hardening? |
| METRIC | Does this validate or invalidate a current project decision? |

Classify each as:
- **Directly applicable** — clear mapping to specific project files/patterns
- **Architecturally relevant** — informs a design decision but requires planning
- **Not applicable** — the project doesn't use the relevant technology/pattern

### Step 4 — Present Improvement Plan
Present a structured plan to the user before making any changes:

```
═══ Project Improvement Plan (from: [paper title]) ═══

Directly Applicable:
1. [File/pattern] — [what changes] — [evidence from paper]
2. [File/pattern] — [what changes] — [evidence from paper]

Architecturally Relevant (requires discussion):
1. [Area] — [what the paper suggests] — [tradeoffs for this project]

Not Applicable:
- [Insight] — [why it doesn't fit this project]

Estimated scope: [N files, small/medium/large change]
```

Wait for user approval. User may approve all, select specific items, or reject.

### Step 5 — Apply Changes (with user approval)
For each approved change:
1. Read the target file(s) fully before editing
2. Make the minimal change that applies the insight
3. Follow existing code conventions (style, libraries, patterns)
4. Add a brief comment citing the paper only if the change is non-obvious
5. Run any existing tests/linters if available

**Batch wisely:** if multiple insights affect the same file, apply them together. If they affect independent areas, apply sequentially and verify each.

### Step 6 — Document Changes
For architecturally significant changes, offer to create an ADR via `architectural-decision-log`:
```
Decision: [what changed]
Context: [paper finding that motivated it]
Source: [paper citation]
```

---

## Gotchas

- Research findings are general — the project's specific constraints may make a technique inapplicable even if the paper proves it works in theory. Always check the project context.
- Don't over-apply. If a paper finds "technique X improves performance by 15%," but the project doesn't have a performance problem, don't apply it.
- Papers often test on specific languages/frameworks. A technique proven for Python may not translate to Go or Rust idiomatically. Adapt, don't copy.
- Never add a dependency just because a paper recommends it. Check if the project already has an equivalent.

---

## Output Format

After applying changes:
```
═══ Applied Research Insights ═══
Paper: [title] ([venue], [year])
Project: [project name/path]

Changes Applied:
1. [file:line] — [what changed] — [paper evidence]
2. [file:line] — [what changed] — [paper evidence]

Deferred (architecturally relevant, needs planning):
- [area] — [recommendation]

ADR created: [path or N/A]
Tests: [passed/failed/N/A]
```

---

## Example

<examples>
  <example>
    <input>Apply the insights from that SkillReducer paper to my current project</input>
    <output>
═══ Project Improvement Plan (from: SkillReducer) ═══

Directly Applicable:
1. compress-skill/SKILL.md — add content classification step before compression
   (paper: 60%+ of skill content is non-actionable background)
2. universal-skill-creator/SKILL.md — add SkillReducer taxonomy to Step 6
   (paper: classify blocks as CORE/WORKFLOW/BACKGROUND before writing)

Not Applicable:
- Token counting optimization — project doesn't do runtime token management

Estimated scope: 2 files, small change
Approve? (all / select / reject)
    </output>
  </example>
</examples>

---

## Scope and Constraints

**In scope:** Applying validated paper insights to code, architecture, tests, docs, and workflows in the current project.

**Out of scope:**
- Ingesting or validating papers — that's `learn-from-paper`
- Improving agent skills — that's `learn-from-paper` Step 6
- General code review without paper context — that's `code-review-crsp`

---

## Log Output
After applying changes, append to `docs/skill-outputs/SKILL-OUTPUTS.md`:
```
| YYYY-MM-DD HH:MM | apply-paper-to-project | [files changed] | Applied [paper] insights: [summary] |
```

---

## Impact Report

After completing, always report:
```
Paper applied: [title]
Project: [path]
Changes applied: [N]
Files modified: [list]
Deferred items: [N]
ADR created: [path or N/A]
Tests: [passed/failed/N/A]
```
