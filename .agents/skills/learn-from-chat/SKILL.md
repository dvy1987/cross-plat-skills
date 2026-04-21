---
name: learn-from-chat
description: >
  Capture actionable learnings that emerge during conversation — when the agent
  or user discovers that a skill, a set of skills, or a process needs to be
  updated based on what's happening in the current chat. Sub-skill of the
  learn-from orchestrator. Load when the user says "we should update the skill
  for this", "this should be a skill rule", "add this as a gotcha", "the skill
  should know about this", "update the process for this", "remember this for
  next time", "this is important for the skill". Also triggers
  when the agent notices a skill's guidance was wrong or incomplete, a process
  step failed or was unnecessary, a new pattern emerged, a guardrail was missing,
  a workaround became a pattern, or a debugging session reveals a gap.
license: MIT
metadata:
  author: dvy1987
  version: "1.1"
  category: meta
---

# Learn From Chat

You are a skill-improvement specialist that captures actionable learnings from the current conversation. Sub-skill of `learn-from` — inherits shared taxonomy, contradiction protocol, and security requirements from the orchestrator. Unlike other learn-from skills, there is no external source to fetch — the insight comes from what happened in the chat. Credibility is established jointly by the user and agent confirming the learning is real, generalizable, and backed by evidence from practice.

## Hard Rules

- **No silent updates.** Every proposed change must be presented to the user and explicitly approved before modifying any skill or process.
- **Evidence from practice.** Only capture learnings backed by what actually happened — a bug found, a pattern that failed, a technique that worked, a missing guardrail exposed. Not speculation or "it would be nice if".
- **Contradiction handling per `learn-from` shared protocol.**
- **Minimal scope.** Update only what's directly affected — don't cascade changes without evidence.
- **Not every mistake warrants a skill update.** Distinguish between one-off errors and systematic gaps. If it only happened once and the cause was situational, it's not a learning.

---

## Workflow

### Step 1 — Capture

Identify the learning from conversation context. Formulate clearly:
- **What was discovered** — the specific insight, in one sentence
- **Evidence** — what happened in this conversation that proves it (the bug, the failure, the workaround, the missing step)
- **Affected skills/processes** — which SKILL.md files or workflows this touches

If the user triggered this explicitly, use their words as the starting point. If the agent noticed it, state what was observed and ask the user to confirm before proceeding.

### Step 2 — Classify

Assign exactly one classification:

| Tag | When to use |
|-----|-------------|
| `GOTCHA` | Non-obvious fact that an agent would get wrong without being told |
| `TECHNIQUE` | A method or pattern that worked and should be reused |
| `FAILURE_MODE` | A way something went wrong that should become a guardrail |
| `METRIC` | A quantified result that validates or invalidates a practice |
| `CONTRADICTION` | Finding directly conflicts with an existing skill's hard rule, workflow, or gotcha |

No `BACKGROUND` — chat learnings are always actionable or they're not worth capturing.

### Step 3 — Match

Scan `.agents/skills/*/SKILL.md` for affected skills:
1. Which skills cover the domain of this learning?
2. Does the learning contradict any existing hard rule, workflow step, or gotcha?
3. Is the learning generalizable (applies beyond this specific project/context)?

If not generalizable → tell the user and suggest project-specific documentation instead. Stop.

**Be opinionated.** If it happened once in an unusual context, recommend NOT updating the skill and explain why: "This appears situational — [reason]. Recommend: don't modify the skill. Log as observation only."

### Step 4 — Present

Show the user:
```
═══ Chat Learning ═══
Discovered: [one-sentence insight]
Evidence: [what happened]
Classification: [GOTCHA / TECHNIQUE / FAILURE_MODE / METRIC / CONTRADICTION]
Affected: [skill-name(s)]

═══ Proposed Changes ═══
[skill-name]:
  Section: [which section]
  Change: [exact diff-style change — lines to add/modify/remove]
```

For `CONTRADICTION`, present per `learn-from` shared protocol (side-by-side + resolution options).

**State your recommendation clearly.** If the current skill approach is sound and the chat evidence is from one instance, defend the current approach: "The current skill guidance is well-founded — [reason]. One instance doesn't justify changing it. Recommend: KEEP CURRENT."

### Step 5 — Apply (user approval required)

With explicit user approval:

1. **Capacity pre-check.** Read affected skill's line count. If already near 200 lines, plan a replacement or compression instead of a blind append.
2. **Apply the change.** Add GOTCHAs to `## Gotchas`, FAILURE_MODEs to `## Hard Rules` or `## Gotchas`, TECHNIQUEs to `## Workflow` steps.
3. **Contradiction resolution** per `learn-from` shared protocol.
4. **Bump `metadata.version`** on each modified skill.
5. **Add citation:** `Discovered during [brief context description], [YYYY-MM-DD]`
6. **Modified-skill security sweep.** Run ALL `secure-*` skills (discover via `ls .agents/skills/secure-*`) on the modified skill content and any new `references/` files. This scans the resulting skill, not the source. BLOCKED → revise or revert.
7. **200-line gate.** Check final line count. Over 200 → invoke `compress-skill`. If CORE still over 200 → invoke `split-skill`.
8. **Run `validate-skills`** on every modified skill. Must score ≥10/14. Runs AFTER any compress/split.

### Step 6 — Log

Ensure `docs/learnings/` exists, then append to `docs/learnings/chat-learnings.md`:
```markdown
## [YYYY-MM-DD] — [one-line summary]
- **Classification:** [tag]
- **Evidence:** [what happened]
- **Skills modified:** [list]
- **Skills created from this learning:** [none yet / skill-name(s)]
- **Changes:** [brief description of what was added/changed]
```

Create the file if it doesn't exist. If this learning later creates a new skill, update the original entry with the skill name, date, and path. Tell user: "Logged in `docs/learnings/chat-learnings.md`."

---

## Gotchas

- Chat context can be misleading — confirm the learning is generalizable, not project-specific, before modifying a skill.
- Avoid skill bloat — if a skill is already at 200 lines, the new learning must replace something or trigger compress/split.
- Don't confuse user preference with a systematic gap — "I prefer X" is not evidence that a skill should change.
- Multiple learnings from one chat should each be evaluated independently — don't batch-approve.
- A workaround is only a pattern after it recurs — one instance is an observation, not a learning.

---

## Example

<examples>
  <example>
    <input>During debugging, the agent discovers that compress-skill's workflow doesn't check whether moved references are actually loaded by the skill at runtime.</input>
    <output>
═══ Chat Learning ═══
Discovered: compress-skill can move content to references/ without verifying load triggers exist
Evidence: During compression, background was moved to references/background.md but no load trigger was added — agent never read it when needed
Classification: FAILURE_MODE
Affected: compress-skill

═══ Proposed Changes ═══
compress-skill:
  Section: ## Gotchas
  Change:
  + - Every file moved to `references/` must have a specific load trigger in the workflow — "see references/" is not sufficient.

Awaiting your approval to apply.
    </output>
  </example>
</examples>

---

## Impact Report

After completing, always report:
```
Chat learning captured: [YYYY-MM-DD]
Discovered: [one-sentence insight]
Classification: [tag] | Generalizable: [yes/no]
Skills modified: [list] | Contradictions resolved: [N]
validate-skills: [skill]: [before] → [after]
Logged: docs/learnings/chat-learnings.md
```
