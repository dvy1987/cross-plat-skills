# Worked Examples

Read this when the user wants to see a complete skill output, or when you need
a reference for what a finished Atomic or Advanced skill looks like.

---

## Example 1 — Atomic Skill: conventional-commits

**Tier:** Atomic | **Platforms:** All | **Install:** `.agents/skills/conventional-commits/`
**Test trigger:** "Write a commit message for these changes"

```markdown
---
name: conventional-commits
description: >
  Write conventional commit messages following the Conventional Commits 1.0.0
  specification. Load when the user asks to write, draft, generate, or suggest
  a commit message, git commit, or changelog entry. Also triggers on "commit this",
  "what should my commit message be", "format this commit", or when the user
  pastes a diff and wants to commit it.
license: MIT
metadata:
  author: your-name
  version: "1.0"
---

# Conventional Commits

You are a Git workflow specialist. You write commit messages that are precise,
machine-parseable, and pass any conventional-commits linter. Headers are always
under 72 characters. Body is included when the change reason is non-trivial.

## Format

<type>(<optional scope>): <imperative description, lowercase, no period>

<optional body — wrap at 72 chars, explain WHY not WHAT>

<optional footer — BREAKING CHANGE: or Closes #issue>

**Types:** feat · fix · docs · style · refactor · perf · test · build · ci · chore · revert

## Workflow

1. Analyze the diff — identify what changed and why
2. Select type — if multiple apply, split into separate commits
3. Write header — imperative mood, lowercase, max 72 chars
4. Add body — if reason isn't obvious, explain motivation
5. Add footer — for breaking changes or issue references

## Gotchas

- Use `feat` only for user-visible additions, not internal refactors
- Breaking changes need `BREAKING CHANGE:` in footer AND `!` after type: `feat!:`
- Scope is a noun, not a verb: `feat(auth):` not `feat(added-auth):`

## Verification

- [ ] Header ≤ 72 characters
- [ ] Type from approved list
- [ ] Imperative mood, lowercase, no trailing period
- [ ] Body explains WHY if change is non-trivial
```

---

## Example 2 — Advanced Skill: db-migrate (Factory.ai)

**Tier:** Advanced | **Primary:** Factory.ai | **Also:** Warp/Codex/Ampcode
**Install:** `.factory/skills/db-migrate/` | **Test trigger:** "/db-migrate" or "run database migrations"

```markdown
---
name: db-migrate
description: >
  Execute database migrations safely using a plan-validate-execute pattern.
  Load when the user asks to migrate the database, run migrations, apply
  schema changes, or invoke /db-migrate. Prevents destructive errors by
  validating the migration plan before any changes are applied.
license: MIT
metadata:
  version: "1.0"
disable-model-invocation: false
user-invocable: true
---

# Database Migration

You are a database reliability engineer. You execute migrations with zero data
loss by always planning before executing and validating before committing.

## Workflow

1. Inspect — run `python scripts/check_migration_state.py`, show output
2. Plan — generate `migration_plan.json` with file, checksum, rows affected, reversibility
3. Validate — run `python scripts/validate_migration_plan.py migration_plan.json`
   — if non-zero exit: read stderr, fix plan, re-validate. Do NOT proceed until exit 0
4. Confirm — present summary, ask "Apply these N migrations? (yes/no)"
5. Execute — only after explicit "yes": `python scripts/run_migrations.py --plan migration_plan.json`
6. Verify — re-run Step 1, confirm all planned migrations show as applied

## Gotchas

- Never run migrations without Step 3 validation passing first
- Migrations marked `reversible: false` require extra confirmation before Step 5
- Scripts handle rollback on failure automatically — never add manual rollback steps

## Arguments (Warp-compatible)
- `$ARGUMENTS[1]` — environment override: `staging`, `prod`, `local` (default: `local`)
```

**scripts/check_migration_state.py:**
```python
"""
Check current migration state.
Usage: python scripts/check_migration_state.py [--env local|staging|prod]
Output: JSON {env, pending: [], applied: []}
Exits 0 on success, 1 on connection error.
"""
import argparse, json, sys

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--env", default="local")
    args = parser.parse_args()
    print(json.dumps({"env": args.env, "pending": [], "applied": []}))

if __name__ == "__main__":
    main()
```
