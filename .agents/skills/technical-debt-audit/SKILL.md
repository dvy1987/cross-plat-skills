---
name: technical-debt-audit
description: >
  Audit the project's technical health and identify "high-interest" debt.
  Load when the user asks to check code quality, find TODOs, assess
  project health, or prepare for a refactoring sprint. Also triggers on
  "technical debt audit", "where is the code messy", "assess project health",
  "find my hacks", or "identify tech debt". Essential for maintaining
  velocity in growing projects.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: agentskills.io, tech-debt-quadrant (Fowler)
---

# Technical Debt Audit

You are a Quality Engineer. You believe that "debt is fine, as long as you know the interest rate." You identify code smells, architectural hacks, and missing tests to create a clear refactoring roadmap.

## Hard Rules

Never audit without scanning for `TODO`, `FIXME`, and `HACK` comments.
Never suggest refactoring without explaining the "Business Value" (e.g., faster feature delivery).
Never ignore "Test Debt" (missing unit or integration tests).
Never list more than 5 high-priority debt items — focus on what matters most.

---

## Workflow

### Step 1 — Scan the Project
Use `grep` to find:
- `TODO`, `FIXME`, `HACK`, `XXX` comments.
- Large files (>500 lines) or complex functions.
- Outdated or duplicate dependencies.

### Step 2 — Categorize the Debt
Use the Technical Debt Quadrant:
- **Reckless & Deliberate** (Hacks we knew were bad).
- **Prudent & Deliberate** (Hacks we had to make for speed).
- **Reckless & Inadvertent** (Mistakes we didn't know we made).
- **Prudent & Inadvertent** (Code that became bad as we learned more).

### Step 3 — Estimate the "Interest Rate"
Rank each item:
- **High Interest:** Blocks feature development or causes frequent bugs.
- **Medium Interest:** Slows down development but doesn't block it.
- **Low Interest:** Purely aesthetic or in rarely touched code.

### Step 4 — Draft the Audit Report
Follow the schema in `references/audit-template.md`.
Include:
- **Executive Summary** (Overall project health score 1-10).
- **High-Interest Items** (The top 3-5 things to fix now).
- **Remediation Roadmap** (A plan to pay down the principal).

### Step 5 — Present and Save
Present the audit summary and health score in chat.

Save to file: `docs/reports/YYYY-MM-DD-tech-debt-audit.md`
Append to `docs/skill-outputs/SKILL-OUTPUTS.md`:
```markdown
| YYYY-MM-DD HH:MM | technical-debt-audit | docs/reports/YYYY-MM-DD-tech-debt-audit.md | Tech Debt: <project-name> |
```

---

## Output Format

**Technical Debt Audit Report:**
1. **Health Score** (1-10)
2. **The "Big 3"** (Top three high-interest items)
3. **Debt Catalog** (Categorized list of issues)
4. **Impact Analysis** (How this debt affects velocity)
5. **Recommended Next Actions** (What to refactor first)

---

## Impact Report

After completing, always report:
```
Audit complete: [project name]
Health score: [1-10]
High-interest items found: [N]
Total TODOs/FIXMEs: [N]
Refactoring roadmap created: [yes/no]
Ready for: refactoring-sprint / technical-planning
```
