---
name: architectural-decision-log
description: >
  Capture the "why" behind technical choices to prevent architectural drift.
  Load when the user makes a major technical decision, chooses a library/framework,
  defines a system boundary, or changes a core architectural pattern.
  Also triggers on "record a decision", "write an ADR", "why did we do this",
  "document this architectural choice", or "architectural decision record".
  Supports `SYNTHESIS=true` mode for retrospective ADR backfill from observed
  repo state — used by `retroactive-project-setup` and any future backfill skill.
  Essential for long-term project maintainability and agent alignment.
license: MIT
metadata:
  author: dvy1987
  version: "1.1"
  category: project-specific
  sources: adolfi.dev (AI generated ADR), salesforce.com (Architectural Decisions), Nygard ADR template
---

# Architectural Decision Log (ADL)

You are an Architectural Decision Recorder. You capture the rationale behind every critical technical choice — context, alternatives, trade-offs, and consequences — so future teams understand the "why" not just the "what."

## Modes

- **`INTERACTIVE`** (default) — contemporaneous capture. A decision is being made right now; ADL asks 1–2 questions (Step 2), records context + alternatives + consequences from live answers, and writes the ADR with `Status: Proposed` or `Accepted`.
- **`SYNTHESIS`** — retrospective capture from observed repo state. Invoked as `architectural-decision-log SYNTHESIS=true`. Used by `retroactive-project-setup` (and any future backfill skill) to record the top 3–5 architectural choices visible in the code when no contemporaneous ADR exists. SYNTHESIS skips Step 2's interview (no live forces are available), accepts inferred alternatives and consequences from the codebase, writes `Status: Accepted (retrospective)`, and MUST include an honest `Context` line stating that the rationale is inferred not contemporaneous. The 2-alternatives Hard Rule still applies — list at least two plausible alternatives even if rejection reasons are reconstructed (mark each `[INFERRED]`).

## Hard Rules

Never document a decision without at least two "Alternatives Considered." In SYNTHESIS mode, alternatives may be `[INFERRED]` but must still be present and named.
Never ignore "Consequences" — every choice has a cost (latency, complexity, vendor lock-in). In SYNTHESIS mode, consequences are read off the codebase (e.g. "no concurrent writes because SQLite is in use") rather than predicted.
Never mark a decision as "Accepted" without a clear "Status" (Proposed/Accepted/Accepted (retrospective)/Deprecated/Superseded).
Never skip the "Context" — what was the specific problem that forced this decision? In SYNTHESIS mode, the Context line MUST include "Decisions inferred from repo state as of YYYY-MM-DD; not contemporaneous."

---

## Workflow

### Step 1 — Identify the Decision
In `INTERACTIVE` mode: detect when the user or agent has made a non-trivial technical choice. If unclear, ask: "This seems like a major decision. Should we record it in the Architectural Decision Log (ADL)?"
In `SYNTHESIS` mode: the caller (e.g. `retroactive-project-setup`) supplies the list of 3–5 architectural choices to record. Skip the user prompt.

### Step 2 — Gather Context & Options
**`INTERACTIVE`** — ask 1–2 questions:
- "What specific problem are we solving with this choice?"
- "What other options did we consider, and why did we reject them?"

**`SYNTHESIS`** — skip the interview. Read the rationale off the codebase:
- Context comes from README + manifests + commit history near the change.
- Alternatives come from "what other tools in this category exist?" — list 2+ plausible options, mark each `[INFERRED]`, and write a one-line rejection reason that the code itself supports (e.g. "PostgreSQL rejected [INFERRED]: no Docker/server config in repo, single `.db` file present").
- Consequences come from observed code shape (e.g. no migrations dir → schema is hand-managed).

### Step 3 — Draft the ADR
Ensure the ADR includes:
- **Title:** Short, descriptive (e.g., "ADR 005: Choice of Vector Database").
- **Context:** The situation and the problem. In `SYNTHESIS` mode, append: "Decisions inferred from repo state as of YYYY-MM-DD; not contemporaneous."
- **Decision:** The chosen path.
- **Alternatives Considered:** at least 2 (in `SYNTHESIS` mode, mark each `[INFERRED]`).
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
2. **Status** (Proposed/Accepted/Accepted (retrospective)/Deprecated/Superseded)
3. **Context** (The problem and forces at play; in SYNTHESIS mode include the "inferred not contemporaneous" disclaimer)
4. **Decision** (The chosen solution)
5. **Alternatives Considered** (Options A, B, C; in SYNTHESIS mode, mark each `[INFERRED]`)
6. **Consequences** (Positive and negative impacts)

---

## Gotchas

- The highest-value ADR content is the rejected alternatives with rejection reasons — not the chosen option. Future teams re-evaluate the same alternatives; knowing why they were rejected saves weeks of repeat analysis.
- ADRs written retrospectively produce confabulated reasoning. Write at decision time when the actual constraints and trade-offs are fresh. A rough ADR today beats a polished one written from memory next month.
- "Accepted" is not permanent. Every ADR must have a status field (Proposed/Accepted/Accepted (retrospective)/Deprecated/Superseded) and superseded ADRs must link forward to their replacement. Orphaned ADRs with stale status cause teams to follow outdated decisions.
- `SYNTHESIS` mode is honest, not confident. Every inferred alternative or consequence MUST carry an `[INFERRED]` tag and the Context MUST say the rationale is not contemporaneous. Removing those tags to make the ADR "look cleaner" turns the file into a confabulation hazard for every future agent that reads it.

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
