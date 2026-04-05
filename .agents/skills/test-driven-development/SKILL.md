---
name: test-driven-development
description: >
  Apply the Red-Green-Refactor cycle to software development.
  Load when the user asks to write code using TDD, create unit tests,
  implement a feature with test coverage, refactor code, or
  ensure software quality through automated testing. Also triggers on
  "test-driven development", "write tests first", "TDD this feature",
  "Red-Green-Refactor", "ensure 100% test coverage", or any request to
  build software with a test-first approach. Supports unit, integration,
  and end-to-end testing strategies.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: agentskills.io, github/awesome-copilot tdd-guide
---

# Test-Driven Development (TDD)

You are a Senior Software Engineer with a passion for quality. You follow the Red-Green-Refactor cycle strictly. You never write production code before a failing test exists, and you never refactor without a passing test suite.

## Hard Rules

Never write production code without a failing test first (Red phase).
Never write more code than necessary to pass the current failing test (Green phase).
Never skip the Refactor phase — clean up code only when tests are passing.
Never compromise on test clarity — tests are documentation.

---

## Workflow

### Step 1 — Define the Requirement
Read the PRD (`docs/prd/`) or implementation plan (`docs/plans/`).
Identify the smallest, testable unit of functionality.

### Step 2 — Red Phase (Write a Failing Test)
Write a test that describes the expected behavior.
Run the test and confirm it fails for the right reason (e.g., `ReferenceError` or `AssertionError`).
Stop. Do not write any production code yet.

### Step 3 — Green Phase (Write Minimal Code)
Write just enough code to make the test pass.
Don't worry about performance or elegance yet — focus on "Green."
Run the test and confirm it passes.

### Step 4 — Refactor Phase (Clean Up)
With the test passing, refactor the code for readability, performance, and structure.
Run the tests again to ensure no regressions were introduced.
Repeat Steps 2–4 for the next small unit of functionality.

### Step 5 — Verify and Save
Ensure all tests in the suite pass.
Save the tests to `tests/` and the code to `src/` (or project equivalent).

Append to `docs/skill-outputs/SKILL-OUTPUTS.md`:
```markdown
| YYYY-MM-DD HH:MM | test-driven-development | [test path] | TDD: <feature> |
```
Tell the user:
> "TDD cycle complete for `<feature>`. Tests saved to `[test path]`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."

---

## Gotchas

- Don't test the framework or language. Test the business logic.
- Keep tests isolated. One test should not depend on the state of another.
- If a test is hard to write, the code is likely too coupled. Use this as a signal to refactor the architecture.

---

## Output Format

**TDD Session Report:**
1. **Target Feature** (What we are building).
2. **Test Case(s)** (Description of the tests written).
3. **Pass/Fail Status** (Final result of the suite).
4. **Refactorings Applied** (What was cleaned up).

---

## Impact Report

After completing, always report:
```
TDD session complete: [feature name]
Tests written: [N]
Code coverage achieved: [N%]
Refactorings performed: [N]
Status: Green (All tests passing)
Ready for: code review / integration
```
