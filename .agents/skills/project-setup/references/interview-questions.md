# Interview Question Bank

Full question set for project-setup. Use the core questions in SKILL.md first. Pull from here when deeper context is needed.

## Axis 1 — User Context

### Role & Skill Depth
- What is your primary role? (PM, engineer, designer, founder, etc.)
- How many years have you been in this role?
- Which areas do you feel most confident handling yourself?
- Which areas would you want agents to handle more autonomously?

### Working Style
- Do you prefer to review every change, or are you comfortable with agents committing directly?
- Small PRs or large feature branches?
- Test-first or test-after?
- Do you want agents to ask before installing packages or changing architecture?

### Team Context (if applicable)
- Who else works on this project? What are their roles?
- Do different team members have different skill gaps?
- Should the AGENTS.md account for multiple roles or just yours?

### Skill Gap Probing (ask if user says "I'm not sure")
- When you last built something similar, what part took longest or went wrong?
- If an agent made an architectural decision, would you be able to evaluate whether it was good?
- Do you write tests for your code? What kind? (unit, integration, e2e)
- Have you done a security review on a project before?

## Axis 2 — Project Context

### What We're Building
- What are you building, in one sentence?
- Is this greenfield or adding to an existing codebase?
- What's the target platform? (web, mobile, CLI, API, extension, etc.)

### Tech Stack
- Tech stack and key dependencies? (or should I detect from the repo?)
- Any frameworks with non-obvious conventions?
- What package manager? Build tool? Test framework?

### Architecture & Patterns
- Any non-obvious architectural decisions agents should follow?
- Are there patterns in the codebase that look wrong but are intentional?
- Any directories or files that should never be touched?

### Definition of Done
- What does "done" look like for a typical task? (PR? commit? deployed?)
- Who reviews PRs? What's the review process?
- Any CI/CD pipeline that must pass?

### Existing Documentation
- Is there a PRD, product-soul, or design doc?
- Any external docs agents should reference? (API docs, design system, etc.)
- Are there existing ADRs (Architectural Decision Records)?
