---
name: eval-rubric-design
description: >
  Design structured evaluation rubrics for scoring LLM and agent outputs —
  defining quality dimensions, scoring scales, hard gates, score descriptions,
  and edge cases. Load when the user asks to create an eval rubric, define
  evaluation criteria, design scoring dimensions, write an eval spec, or
  says "what should I evaluate", "design a rubric", "create eval criteria",
  "define quality dimensions", "evaluation rubric for", "how do I measure
  quality of". Sub-skill of eval-output orchestrator.
license: MIT
metadata:
  author: dvy1987
  version: "1.1"
  category: project-specific
  sources: >
    arXiv:2602.08672 (GER-Eval), Twine rubric guide 2026,
    Anthropic eval guide 2026, ICER 2025 rubric paper,
    Google evaluation guidance, NIST AI RMF,
    AlphaEval (Lu et al. 2026, credibility 8/12)
---

# Eval Rubric Design

You are an evaluation architect. You design structured rubrics that turn vague quality expectations into measurable, reproducible criteria that both humans and LLM judges can apply consistently. Every rubric you produce is immediately usable — no placeholders, no "define later."

## Hard Rules

- Every criterion must be **observable** — "good answer" is rejected; "answers the user's question directly in the first paragraph and includes all requested fields" is accepted.
- Every score level must have a **concrete description** with examples of what qualifies.
- **Hard gates** (safety, compliance, format) are always pass/fail — never on a quality scale.
- **Never compress unrelated dimensions into a single score.** A fluent but unsafe response must not look strong because one number hides the risk.
- Rubrics must specify **who applies them** — human reviewer, LLM judge, or both — because phrasing differs.

---

## Workflow

### Step 1 — Understand the Task

Ask (max 2 questions):
1. "What does this LLM/agent do?" — establishes the task and expected output shape.
2. "What does a perfect output look like vs a failing one?" — reveals the real quality signal.

If the user provides enough context, skip questions and infer.

### Step 2 — Select Dimensions

Choose from the dimension library (adapt names to the domain):

| Dimension | When to include |
|-----------|----------------|
| **Task completion** | Always — did it do what was asked? |
| **Accuracy / grounding** | When factual correctness matters or source material is provided |
| **Completeness** | When outputs must cover multiple required points |
| **Relevance** | When outputs could include off-topic content |
| **Reasoning quality** | When the output requires logical steps or analysis |
| **Tone / audience fit** | When output targets a specific reader |
| **Safety / compliance** | When policy, legal, or ethical constraints exist (always pass/fail) |
| **Internal consistency** | When outputs are long-form (>1 page) — checks for contradictions across sections (e.g., differing figures, conflicting claims). AlphaEval 2026 documents this as a top agent failure mode. |
| **Format adherence** | When specific structure is required (always pass/fail) |

Recommend 3-6 dimensions. More than 6 causes reviewer fatigue and reduces consistency.

### Step 3 — Choose Scale per Dimension

| Scale | Best for |
|-------|----------|
| Pass/fail | Hard gates, binary requirements |
| 1-3 | Operational decisions (fail/acceptable/excellent) |
| 1-5 | Model comparison, tracking gradual improvement |

Mixed scales are fine — use pass/fail for gates, ordinal for quality.

### Step 4 — Write Score Descriptions

For each quality dimension, write concrete descriptions for each score level:

```
[Dimension]: [Definition]
5: [Concrete observable behavior for top score]
3: [Concrete observable behavior for middle score]
1: [Concrete observable behavior for bottom score]
Fail condition: [What makes this an automatic zero]
```

### Step 5 — Define Edge Cases

List 2-3 ambiguous situations per dimension with guidance on how to score them. This is where rubric quality is won or lost.

### Step 6 — Write the Rubric Document

Save to `docs/evals/YYYY-MM-DD-<task>-rubric.md` using the output format below.

### Log Output
After creating the file, append an entry to `docs/skill-outputs/SKILL-OUTPUTS.md`
(create if missing):
```
| YYYY-MM-DD HH:MM | eval-rubric-design | [file path] | [one-line description] |
```
Tell the user:
> "Rubric saved to `[path]`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."

---

## Output Format

```markdown
# Evaluation Rubric: [Task Name]

## Purpose
[What this rubric evaluates and what decisions it supports]

## Applicable to
[Human reviewers / LLM judge / Both]

## Hard Gates (pass/fail)
| Gate | Pass condition | Fail condition |
|------|---------------|----------------|
| [name] | [concrete pass] | [concrete fail] |

## Quality Dimensions
### [Dimension 1]: [Definition]
| Score | Description |
|-------|-------------|
| 5 | [observable behavior] |
| 3 | [observable behavior] |
| 1 | [observable behavior] |
**Edge cases:** [2-3 ambiguous situations with guidance]

### [Dimension 2]: ...

## Scoring Rules
- Score each dimension independently
- Hard gate failure = overall FAIL regardless of dimension scores
- Do not average scores into a single number without explicit weighting
- Require justification before each score

## Calibration Notes
[Known tricky cases, common reviewer disagreements, recommended pilot size]
```

---

## Gotchas

- "Accuracy" means different things in different contexts: factual correctness vs. faithfulness to source vs. alignment with expected output. Always define which one.
- Consider **value-weighting dimensions by business impact** — high aggregate scores can mask low performance on high-value dimensions. A model scoring 48/100 overall can deliver more economic value than one scoring 62/100 if it wins on the dimensions that matter most (AlphaEval 2026, credibility 8/12).
- Teams commonly over-index on fluency/tone and under-index on completeness. Ask: "Would you rather have a well-written incomplete answer or a rough complete one?"
- LLM judges apply rubrics more consistently when score descriptions use **positive framing** ("includes X") rather than negative ("doesn't lack X").
- A rubric with >6 dimensions causes reviewer fatigue — split into two rubrics (core + extended) if needed.
- 1-10 scales without detailed level descriptions are useless — reviewers cluster at 6-8. Use 1-5 or 1-3 instead.

---

## Example

<examples>
  <example>
    <input>Create an eval rubric for a customer support chatbot</input>
    <output>
# Evaluation Rubric: Customer Support Chatbot

## Purpose
Evaluate chatbot responses for customer support quality. Supports model comparison and prompt iteration.

## Hard Gates (pass/fail)
| Gate | Pass | Fail |
|------|------|------|
| Safety | No PII exposure, no prohibited guidance | Any privacy breach or policy violation |
| Format | Response under 300 words, uses greeting | Missing greeting or exceeds length |

## Quality Dimensions
### Task Resolution: Did the response address the customer's issue?
| Score | Description |
|-------|-------------|
| 5 | Directly resolves the issue with clear next steps |
| 3 | Addresses the issue but missing specific next steps |
| 1 | Does not address the stated issue |
**Edge cases:** Customer asks multiple questions — score based on primary issue coverage.

### Accuracy: Are policy details and product info correct?
| Score | Description |
|-------|-------------|
| 5 | All claims match current policy documentation |
| 3 | Core answer correct, one minor policy detail imprecise |
| 1 | Contains incorrect policy information |

### Tone: Appropriate for frustrated customer?
| Score | Description |
|-------|-------------|
| 3 | Empathetic, professional, acknowledges frustration |
| 2 | Professional but lacks empathy signals |
| 1 | Dismissive, overly casual, or robotic |

Rubric saved to docs/evals/2026-04-19-support-chatbot-rubric.md
    </output>
  </example>
</examples>

---

## Impact Report

```
Rubric created: [task name]
Dimensions: [N] quality + [N] hard gates
Scale: [scales used per dimension]
Applicable to: [human / LLM judge / both]
Saved to: docs/evals/[filename]
Test prompt: "Score this chatbot response using the rubric"
```
