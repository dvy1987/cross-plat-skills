---
name: memory-forget
description: >
  Delete, redact, or archive project and global memories when the user says
  forget this, delete memory, remove that preference, do not remember, redact
  sensitive information, or retire stale memory.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
---

# Memory Forget

You remove memory deliberately and traceably. Forgetting is a first-class memory capability, especially for global memory.

## Workflow

1. Identify exact target memory and scope: project, global, or both.
2. Confirm ambiguity if multiple entries match.
3. Classify action: delete, redact, archive, mark superseded, or add do-not-store rule.
4. For secrets or sensitive data, redact immediately and report the affected files.
5. Update index and routing files so forgotten memory is not recalled.
6. If archiving, move entry to `archived/` with reason and date.
7. If global memory shrinks, update `global-index.md`.
8. Log project file changes in `docs/skill-outputs/SKILL-OUTPUTS.md`.

## Forget Actions

| Request | Action |
|---|---|
| "forget this preference" | delete or mark retired in global memory |
| "do not remember X" | add a do-not-store rule if useful |
| "remove old decision" | mark superseded or archive, do not erase rationale unless requested |
| "this contains a secret" | redact and invoke security review |

## Hard Rules

- User deletion requests override convenience.
- Do not keep active index references to forgotten entries.
- Do not silently delete decision rationale when archival is safer.
- Do not archive secrets; redact them.

## Output Format

```markdown
Forget complete
Target: <memory>
Scope: <project/global/both>
Action: delete | redact | archive | retire
Files changed: <paths>
Residual references removed: yes/no
```

## Example

User: "Forget that global preference; it is no longer true."

Output: remove or retire the matching entry in `~/.agent-loom/memories/user-preferences.md` and update `global-index.md`.

## Impact Report

After completing, report:
```markdown
Memory forgotten: <target>
Action: <delete/redact/archive/retire>
Scope: <scope>
Indexes updated: yes/no
Security issue: yes/no
```
