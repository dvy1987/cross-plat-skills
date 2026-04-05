# Validation Rubric

Full 0/1/2 scoring guide for all 7 criteria. Read when a score is ambiguous during validate-skills Step 3, or when improve-skills needs to baseline-score a skill.

This is the single source of truth for scoring. The same rubric is referenced by improve-skills/references/scoring-rubric.md — if they diverge, this file takes precedence (it is more detailed).

---

## 1. Routing (0–2)
Does the description trigger on the phrases users actually say?

| Score | Signal | Fix |
|-------|--------|-----|
| 0 | Missing description, or fewer than 3 trigger phrases, or description is a single generic sentence | Rewrite description with: primary capability + "Load when the user asks to [X]" + synonyms |
| 1 | Has some triggers but misses common synonyms, or description is vague ("helps with PRDs") | Add 3–5 synonym phrases; test mentally against 5 real user prompts |
| 2 | Rich trigger set — primary phrases + synonyms + context hints, all within 1024 chars | No action |

---

## 2. Role Definition (0–2)
Is the expert role specific and narrow?

| Score | Signal | Fix |
|-------|--------|-----|
| 0 | No role in first paragraph, or generic ("You are an AI assistant") | Add: "You are a [specific expert title] specializing in [narrow subdomain]." |
| 1 | Role defined but too broad ("You are a software engineer") | Narrow the domain and add a quality standard sentence |
| 2 | Specific title + narrow specialty + quality standard ("Your outputs are X and Y") | No action |

Note: Per arXiv:2409.13979, role definition does not expand factual accuracy on frontier models. Score 2 requires the role to set tone and workflow context, not to claim extended factual knowledge.

---

## 3. Workflow (0–2)
Are steps numbered, imperative, and single-action?

| Score | Signal | Fix |
|-------|--------|-----|
| 0 | No numbered steps, or steps are paragraphs of prose | Add numbered steps starting with action verbs |
| 1 | Steps exist but use passive voice, vague verbs, or compound multiple actions | Rewrite: one action verb per step, imperative mood |
| 2 | Every step: imperative one-liner, one action, clear acceptance criteria | No action |

---

## 4. Gotchas (0–2)
Are there non-obvious domain facts the agent will get wrong without being told?

| Score | Signal | Fix |
|-------|--------|-----|
| 0 | No Gotchas section | Add section with at least 2 domain-specific, non-obvious facts |
| 1 | Gotchas exist but are generic ("be thorough", "check for errors") | Replace with concrete, specific corrections to known agent failure modes |
| 2 | Each gotcha is a specific fact that defies reasonable assumptions, with no generic advice | No action |

---

## 5. Output Format (0–2)
Is there a schema or template the agent can pattern-match against?

| Score | Signal | Fix |
|-------|--------|-----|
| 0 | No output format defined | Add a template or schema with concrete section headers and placeholder descriptions |
| 1 | Output described in prose ("the response should include a summary, then...") | Replace prose with a literal template |
| 2 | Concrete template or schema — agent can produce correct output without additional instructions | No action |

---

## 6. Examples (0–2)
Are examples realistic, complete, and domain-specific?

| Score | Signal | Fix |
|-------|--------|-----|
| 0 | No examples present | Add at least 1 example with realistic input and complete output |
| 1 | Examples present but: input is generic ("write a PRD"), output is truncated or abbreviated, or output uses `[...]` placeholders | Rewrite with a real-sounding input; write the complete output |
| 2 | Input sounds like a real user message; output is complete and production-ready | No action |

Per NeurIPS 2025: real, domain-specific examples from actual use outperform synthetic generic ones. Prefer examples from real invocations when available.

---

## 7. Token Efficiency (0–2)
Is 60%+ of the body actionable?

| Score | Signal | Fix |
|-------|--------|-----|
| 0 | Majority of body is background, rationale, "why" explanations, or content the LLM knows from training | Apply SkillReducer taxonomy — move BACKGROUND and EDGE_CASE to references/ |
| 1 | 40–60% actionable — some background sections that could move | Move the largest non-actionable block to references/ with a specific load trigger |
| 2 | 60%+ actionable; SKILL.md ≤200 lines; references/ files have specific load triggers | No action |

---

## Overall Score Interpretation

| Score | Meaning | Recommended action |
|-------|---------|-------------------|
| 14/14 | Excellent | No action |
| 12–13 | Good — minor polish | Fix the 1-scoring criterion only |
| 10–11 | Adequate — targeted fixes | Invoke improve-skills on specific weak sections |
| 6–9 | Needs improvement | Full improve-skills cycle |
| 0–5 | Critical | Full rewrite via universal-skill-creator, or consider deprecate-skill if domain is now model-native |
