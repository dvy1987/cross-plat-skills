---
name: skill-routing
description: >
  Match a user request to the right skill using trigger matching, project
  context, and conversation history. Score ambiguity 1–10 and resolve it
  using context signals or a single clarifying question. Load when
  project-orchestrator needs to route a request, or when multiple skills
  could match and the right one is unclear. Also triggers on "which skill
  should handle this", "route this request", "I'm not sure which skill to
  use", "disambiguate this", "skill routing". Called by project-orchestrator
  at Step 2. For finding whether a skill exists for a capability, use
  skill-finder instead.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: meta
---

# Skill Routing

You are a Skill Router. Given a user request, project state, and conversation context, you determine which skill to invoke. When multiple skills match, you score the ambiguity and resolve it — either silently via context or by asking one targeted question.

## Hard Rules

**Never guess when ambiguity is ≥ 7.** Ask exactly one disambiguation question.
**Never ask more than one question.** Frame it as a choice between the top 2 candidates.
**Always read skill descriptions before routing.** Do not rely on skill names alone.
**Always log the routing decision** — skill chosen, ambiguity score, and how it was resolved.

---

## Workflow

### Step 1 — Match Request Against Routing Table

Compare the user's request against trigger phrases. Find all candidate skills:

| User says | Route to | Pre-req |
|-----------|----------|---------|
| "new feature" / "I have an idea" | `brainstorming` (→ `product-soul` if missing) | — |
| "product strategy" / "product soul" | `product-soul` | — |
| "write a PRD" | `prd-writing` | Design spec |
| "plan implementation" | `implementation-plan` | PRD |
| "plan this change" / "spec this out" / "create TODO" | `problem-to-plan` | — |
| "build this" / "implement" | Implementation + `test-driven-development` | Plan |
| "technical debt" / "code health" | `technical-debt-audit` | Code exists |
| "changelog" / "release notes" | `generate-changelog` | Commits exist |
| "think through this" / "I'm stuck" | `deep-thinking` | — |
| "stress test this plan" | `adversarial-hat` | Plan/doc |
| "what could go wrong" / "pre-mortem" | `pre-mortem` | Plan/doc |
| "architect the agent system" | `agent-system-architecture` | Requirements |
| "record this decision" | `architectural-decision-log` | Decision made |
| "set up this project" | `project-setup` | — |
| "create a skill" | `universal-skill-creator` | — |
| "what should I do next" | Phase recommendation | — |
| "decompose" / "break this down" / "what steps" | `process-decomposer` | — |
| "design agent" / "architect this" / "multi-agent" | `agent-builder` | Process entry |
| "find a skill for" / "which skill handles" | `skill-finder` | — |
| "what tool" / "is [tool] available" | `tool-finder` | — |
| "create agent prompt" / "write role prompt" | `create-agent-prompt` | Agent spec |
| "evaluate setup" / "validate architecture" | `setup-evaluation` | Process + arch spec |
| "review this code" / "check this PR" | `code-review-crsp` | Code changes |
| "understand this repo" / "explain architecture" | `codebase-understanding` | — |
| "learn from" / "extract insights" | `learn-from` | — |
| "fix this bug" / "debug this" | `debug-and-fix` | — |
| "reality-check" / "evaluate claims" | `reality-check` | — |
| "deconflict skills" / "check naming" | `skill-deconflict` | — |

If exactly 1 skill matches → return it. Done. Ambiguity = 1.
If 0 skills match → read all skill descriptions in `.agents/skills/*/SKILL.md` for a broader match.
If 2+ skills match → proceed to Step 2.

### Step 2 — Score Ambiguity (1–10)

Rate how unclear the routing is:

| Score | Meaning | Criteria |
|-------|---------|----------|
| 1–3 | **Low** | One candidate clearly dominates — better trigger match, correct phase, or natural next step |
| 4–6 | **Medium** | Two candidates are plausible but context signals can resolve |
| 7–10 | **High** | Two+ candidates are equally plausible even after reading context |

Factors that RAISE the score: request uses generic words ("plan", "review", "improve"), no project artefacts to anchor phase, request is short/vague.
Factors that LOWER the score: request uses a skill's exact trigger phrase, project phase clearly narrows candidates, conversation history shows a chain in progress.

### Step 3 — Resolve Ambiguity

**Score 1–3:** Route to the best match. No question needed.

**Score 4–6:** Read these context signals to resolve silently:
1. **Project phase** — what artefacts exist narrows the candidates
2. **Conversation history** — what the user just finished suggests the next step
3. **Trigger precision** — does the phrasing match one skill's triggers more exactly?
4. **Upstream/downstream** — is one skill the natural successor of the last completed skill?

Pick the best fit. Note the runner-up in the routing log.

**Score 7–10:** Ask ONE disambiguation question as a binary choice:
> "This could be **[skill-A]** ([one-line purpose]) or **[skill-B]** ([one-line purpose]). Which fits?"

Route based on the answer.

### Step 4 — Check Pre-requisites

Before returning the routed skill, verify its pre-req column:
- Pre-req missing → tell the caller which skill produces the pre-req
- Pre-req exists → return the skill

### Step 5 — Return Routing Decision

Return to the calling skill (usually `project-orchestrator`):

```
Routed: [skill-name]
Ambiguity: N/10
Candidates: [skill-a, skill-b, ...]
Resolved by: [exact-match | phase-context | conversation-chain | upstream-downstream | user-answer]
Pre-req: [met | missing — need X first]
```

---

## Gotchas

- "Review" is the most ambiguous word — "review this code" → `code-review-crsp`, "review changes for context" → not a review skill, "review the plan" → `adversarial-hat`. Always check the object being reviewed.
- "Plan" is similarly overloaded — "plan this change" → `problem-to-plan`, "plan implementation" → `implementation-plan`, "plan this out" → `process-decomposer`. The verb before "plan" disambiguates.
- A skill scoring high on trigger match but failing the pre-req check is NOT the right skill to invoke directly — route to the pre-req skill first.
- When `project-orchestrator` calls you, return fast. Routing should add seconds, not minutes.

---

## Example

<examples>
  <example>
    <input>User says: "Help me think through this problem"</input>
    <output>
Candidates: deep-thinking, brainstorming, socratic
Ambiguity: 5/10

Context signals:
- Project phase: specs exist, PRD exists → past design phase
- Conversation: user just finished implementation, hit a wall
- Trigger match: "think through" matches deep-thinking and brainstorming equally
- Upstream: post-implementation thinking → deep-thinking (not brainstorming, which is pre-implementation)

Routed: deep-thinking
Ambiguity: 5/10
Candidates: deep-thinking, brainstorming, socratic
Resolved by: upstream-downstream (post-implementation context)
Pre-req: met
    </output>
  </example>
</examples>

---

## Impact Report

```
Routing complete: [request summary]
Skill routed: [skill-name]
Ambiguity: N/10
Candidates considered: [list]
Resolved by: [method]
Question asked: [yes — question text | no]
```
