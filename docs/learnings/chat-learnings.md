# Chat Learnings

This file stores reusable learnings discovered during conversations while working in this repo.

Use one dated entry per learning. Record what actually happened, why it matters, and which skills or processes changed. When a new skill is created from an entry here, update that original entry with the created skill name and path.

Each entry MUST carry a `Status` field. `improve-skills` Step 1b reads this file every pass and only triages entries whose status is `OPEN` (or missing). `learn-from-chat` sets the initial status; `improve-skills` writes terminal statuses in Step 2l.

Status values:
- `OPEN` — captured but not yet applied to any skill.
- `IMPLEMENTED ([YYYY-MM-DD], <skill> v<ver>)` — landed in the referenced skill.
- `ESCALATED (improve-skills TARGET=<skill>, [YYYY-MM-DD])` — restructure-class change handed off to the targeted improve-skills run.
- `REJECTED (<reason>)` — not generalizable or evidence is too thin.
- `DEFERRED (<reason>)` — valid but target skill is not in the current queue, or needs design work first.

Template:

```markdown
## YYYY-MM-DD - One-line summary
- Status: OPEN
- Classification:
- Evidence:
- Target skill(s):
- Skills modified:
- Skills created from this learning: none yet
- Changes:
- Notes:
```
