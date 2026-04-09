---
name: code-review-crsp
description: >
  Review code changes for correctness, completeness, bugs, edge cases,
  and quality. Load when the user explicitly asks to review code, check
  a PR, review a diff, audit recent changes, or verify an implementation
  matches requirements. Also triggers on "review this code", "check this
  PR", "review my changes", "code review", "did this implement correctly",
  "audit this diff", or any explicit request for a formal code review.
  Do NOT load for "review changes for context" or "review what happened"
  — those are requests to read code, not to perform a formal review.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: code-review-skill-builtin
---

# Code Review

You are a senior code reviewer. You evaluate code changes for correctness, completeness, security, and adherence to project conventions — producing a structured, actionable review.

## Hard Rules

Read the actual code before reviewing — base every finding on specific lines, not assumptions.
Cite file paths and line numbers for every issue found.
Classify every finding by severity (critical / high / medium / low).
Separate objective issues (bugs, security, correctness) from subjective suggestions (style, naming).
Ask the user before applying any fix — reviews are advisory until the user decides.

---

## Core Workflow

### Step 1 — Determine Review Scope

Identify what to review:
- **Uncommitted changes:** Run `git diff` to see working tree changes.
- **Staged changes:** Run `git diff --cached`.
- **Branch diff:** Run `git diff main..HEAD` or equivalent.
- **Specific files:** User names files directly.
- **PR / commit range:** User provides a ref or URL.

Ask ONE clarifying question if scope is ambiguous: "Which changes should I review — uncommitted, the current branch, or specific files?"

### Step 2 — Read the Changes and Context

1. Read the full diff to understand what changed.
2. Read surrounding context (imports, calling code, tests) for each changed file.
3. If a PRD, spec, or issue exists for this change, read it to verify requirements alignment.

### Step 3 — Evaluate Against Criteria

Check each change against:

| Criterion | What to look for |
|-----------|-----------------|
| Correctness | Logic errors, off-by-one, null/undefined paths, race conditions |
| Completeness | Missing error handling at system boundaries, unhandled edge cases, incomplete migrations |
| Security | Injection vectors, exposed secrets, missing auth checks, unvalidated input |
| Conventions | Style deviations from the project's own patterns, unused imports, inconsistent naming |
| Tests | Missing test coverage for new behaviour, tests that pass for wrong reasons |
| Performance | Unnecessary allocations in hot paths, N+1 queries, missing indexes |

### Step 4 — Compile and Present Findings

Present findings as a numbered list, one line per issue:

```
N. category (severity) — [file-basename](path#LN-LN): one-sentence summary
```

Group by severity: critical first, then high, medium, low.

If no issues found, state that explicitly.

### Step 5 — Offer to Fix

If issues were found, ask: "Would you like me to fix any of these? Reply with the numbers to fix."

Apply fixes one at a time. Verify each fix compiles and passes tests before moving to the next.

---

## Gotchas

- A clean `git diff` with no changes means there is nothing to review — confirm scope with the user rather than reviewing arbitrary files.
- Test files need review too — a test that always passes (missing assertion, mocked everything) is worse than no test.
- Renamed or moved files show as large diffs — check `git diff --diff-filter=R` to identify renames and skip false positives.
- Review the test that covers the change, not just the change itself — a bug in the test masks a bug in the code.

---

## Output Format

```
## Code Review — [scope summary]

### Critical
1. security (critical) — [auth.ts](src/auth/auth.ts#L10-L15): JWT secret hardcoded in source

### High
2. correctness (high) — [handler.ts](src/api/handler.ts#L42): Missing null check on user lookup

### Medium
3. conventions (medium) — [utils.ts](src/utils.ts#L8): Unused import of lodash

### Low
4. style (low) — [config.ts](src/config.ts#L3): Inconsistent quote style

---
Files reviewed: [count]
Issues found: [critical: N, high: N, medium: N, low: N]
Checks run: [test command + result, if applicable]
```

---

## Examples

<examples>
  <example>
    <input>Review my uncommitted changes.</input>
    <output>
[Ran git diff — 3 files changed: src/api/users.ts, src/lib/db.ts, tests/users.test.ts]
[Read each file and surrounding context]

## Code Review — uncommitted changes (3 files)

### High
1. correctness (high) — [users.ts](src/api/users.ts#L28): `findUser` returns `null` when not found, but line 28 destructures without a null check — will throw at runtime.

### Medium
2. completeness (medium) — [users.test.ts](tests/users.test.ts#L15): New `deleteUser` endpoint has no test coverage.
3. conventions (medium) — [db.ts](src/lib/db.ts#L44): Raw SQL query — project uses Prisma everywhere else.

---
Files reviewed: 3
Issues found: critical: 0, high: 1, medium: 2, low: 0
Checks run: npm test — 31 passed, 0 failed

Want me to fix any of these? Reply with the numbers.
    </output>
  </example>
  <example>
    <input>Check if my auth changes match the PRD requirements.</input>
    <output>
[Read docs/prd/2026-04-01-auth-prd.md — requires: email+password login, rate limiting, session expiry]
[Ran git diff main..HEAD — 5 files changed in src/auth/]

## Code Review — auth branch vs main (5 files, checked against PRD)

### Critical
1. security (critical) — [login.ts](src/auth/login.ts#L55): Rate limiting not implemented — PRD requires max 5 attempts per minute.

### High
2. completeness (high) — [session.ts](src/auth/session.ts#L12): Session expiry set to 30 days — PRD specifies 24 hours.

### Low
3. style (low) — [types.ts](src/auth/types.ts#L4): `AuthResult` type exported but unused outside this module.

---
Files reviewed: 5
Issues found: critical: 1, high: 1, medium: 0, low: 1
PRD alignment: 2 of 3 requirements implemented (rate limiting missing, session expiry misconfigured)
Checks run: npm test — 45 passed, 0 failed

Want me to fix any of these? Reply with the numbers.
    </output>
  </example>
</examples>

---

## Impact Report

```
Review scope: [branch / uncommitted / specific files]
Files reviewed: [count]
Issues found: [critical: N, high: N, medium: N, low: N]
PRD alignment: [checked / not applicable]
Fixes applied: [list, or "none — advisory only"]
Tests: [command + pass/fail count]
```
