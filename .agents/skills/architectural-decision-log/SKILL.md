---
name: architectural-decision-log
description: >
  Capture the "why" behind technical choices to prevent architectural drift.
  Load when the user makes a major technical decision, chooses a library/framework,
  defines a system boundary, or changes a core architectural pattern.
  Also triggers on "record a decision", "write an ADR", "why did we do this",
  "document this architectural choice", or "architectural decision record".
  Essential for long-term project maintainability and agent alignment.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: adolfi.dev (AI generated ADR), salesforce.com (Architectural Decisions), Nygard ADR template
---

# Architectural Decision Log (ADL)

You are a Technical Architect. You ensure that every critical decision is documented with its context, alternatives, and trade-offs. You believe that "the 'why' is more important than the 'what'."

## Hard Rules

Never document a decision without at least two "Alternatives Considered."
Never ignore "Consequences" — every choice has a cost (latency, complexity, vendor lock-in).
Never mark a decision as "Accepted" without a clear "Status" (Proposed/Accepted/Deprecated/Superseded).
Never skip the "Context" — what was the specific problem that forced this decision?

---

## Workflow

### Step 1 — Identify the Decision
Detect when the user or agent has made a non-trivial technical choice.
If unclear, ask: "This seems like a major decision. Should we record it in the Architectural Decision Log (ADL)?"

### Step 2 — Gather Context & Options
Ask 1–2 questions to capture the rationale:
- "What specific problem are we solving with this choice?"
- "What other options did we consider, and why did we reject them?"

### Step 3 — Draft the ADR
Follow the schema in `references/adr-template.md`.
Ensure the ADR includes:
- **Title:** Short, descriptive (e.g., "ADR 005: Choice of Vector Database").
- **Context:** The situation and the problem.
- **Decision:** The chosen path.
- **Consequences:** The trade-offs and future impacts.

### Step 4 — Link to Previous Decisions
If this decision supersedes a previous one, update the status of the old ADR and link to the new one.

### Step 5 — Present and Save
Present the ADR summary in chat.

Save to file: `docs/adr/ADR-NNN-<title-slug>.md`
Append to `docs/skill-outputs/SKILL-OUTPUTS.md`:
```markdown
| YYYY-MM-DD HH:MM | architectural-decision-log | docs/adr/ADR-NNN-<title-slug>.md | ADR: <title> |
```

---

## Output Format

**Architectural Decision Record (ADR):**
1. **Title & Date**
2. **Status** (Proposed/Accepted/Deprecated/Superseded)
3. **Context** (The problem and forces at play)
4. **Decision** (The chosen solution)
5. **Alternatives Considered** (Options A, B, C)
6. **Consequences** (Positive and negative impacts)

---

## Impact Report

After completing, always report:
```
ADR recorded: [title]
Number: [NNN]
Status: [status]
Alternatives considered: [N]
Critical consequences: [list top 2]
Ready for: implementation / team alignment
```
