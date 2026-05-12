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

You are an Architectural Decision Recorder. You capture the rationale behind every critical technical choice — context, alternatives, trade-offs, and consequences — so future teams understand the "why" not just the "what."

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

### Step 6 — Memory Checkpoint (Mandatory)
Per `memory/SKILL.md` → Mandatory Auto-Trigger Checkpoints (event: ADR written), invoke `memory-decision` to mirror this ADR into the decision log with rationale, alternatives, and revisit triggers.

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

## Gotchas

- The highest-value ADR content is the rejected alternatives with rejection reasons — not the chosen option. Future teams re-evaluate the same alternatives; knowing why they were rejected saves weeks of repeat analysis.
- ADRs written retrospectively produce confabulated reasoning. Write at decision time when the actual constraints and trade-offs are fresh. A rough ADR today beats a polished one written from memory next month.
- "Accepted" is not permanent. Every ADR must have a status field (Proposed/Accepted/Deprecated/Superseded) and superseded ADRs must link forward to their replacement. Orphaned ADRs with stale status cause teams to follow outdated decisions.

---

## Example

<examples>
  <example>
    <input>We just decided to use SQLite instead of PostgreSQL for our internal tool. Record this as an ADR.</input>
    <output>
**ADR-005: Use SQLite for Internal Tool Database**
**Date:** 2026-04-12 | **Status:** Accepted

**Context:**
The tool is single-user, deployed locally, with <10K records. We need a database that requires zero infrastructure setup and ships as a single file for easy backup and portability.

**Decision:**
Use SQLite as the primary database via sync SQLAlchemy.

**Alternatives Considered:**
- **PostgreSQL:** Full ACID, rich query support, excellent tooling. Rejected: requires a running server process, Docker or system install, connection management — all unnecessary overhead for a single-user local tool.
- **JSON flat files:** Zero dependencies, human-readable. Rejected: no query capability, no schema enforcement, concurrent write corruption risk, does not scale past ~1K records without performance degradation.

**Consequences:**
- ✓ Zero infrastructure — database is a single `.db` file
- ✓ No connection pooling, no server process, instant setup
- Tradeoff: No concurrent write support — acceptable for single-user but blocks future multi-user
- Tradeoff: Limited full-text search — may need FTS5 extension if search becomes critical
- If we ever need multi-user, this decision must be superseded (migration to PostgreSQL)

ADR recorded: ADR-005: Use SQLite for Internal Tool Database
Number: 005
Status: Accepted
Alternatives considered: 2
Critical consequences: No concurrent writes, limited FTS
Ready for: implementation
    </output>
  </example>
</examples>

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
