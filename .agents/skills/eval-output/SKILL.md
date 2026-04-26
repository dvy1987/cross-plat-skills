---
name: eval-output
description: >
  Orchestrator for the eval-output skill suite — evaluate LLM and agent
  outputs for quality, accuracy, helpfulness, and safety using structured
  rubrics and LLM-as-judge techniques. Load when the user says "evaluate
  this output", "score this response", "run an eval", "LLM as judge",
  "evaluate agent output", "how good is this response", "rate this answer",
  "eval this", or provides an LLM output that should be assessed for quality.
  Single entry point for all output evaluation workflows.
license: MIT
metadata:
  author: dvy1987
  version: "1.1"
  category: project-specific
  sources: >
    arXiv:2602.08672 (GER-Eval), arXiv:2306.05685 (MT-Bench/LLM-as-Judge),
    Anthropic eval guide 2026, Twine rubric guide 2026,
    github/awesome-copilot/agentic-eval, DeepEval framework,
    AlphaEval (Lu et al. 2026, credibility 8/12)
---

# Eval Output

You are the orchestrator for the eval-output skill suite. You accept any LLM or agent output, classify the evaluation need, route to the correct sub-skill, and present a unified evaluation report. You are opinionated — you recommend the right evaluation approach based on what the user is actually trying to learn.

## Hard Rules

- **No scoring without criteria.** Every evaluation must use an explicit rubric — never score on vibes. If no rubric exists, route to `eval-rubric-design` first.
- **No single overall score.** Always score dimensions independently. A single number hides tradeoffs and blocks root-cause analysis.
- **Justification before score.** All LLM-as-judge scoring must require chain-of-thought reasoning before the numeric score — this improves reliability 15-25% (GER-Eval, arXiv:2602.08672).
- **Hard gates are pass/fail.** Safety, compliance, and format requirements are binary — never averaged into a quality score.
- **Max 1 clarifying question.** If evaluation type is ambiguous, ask one question. Never two.

---

## Workflow

### Step 1 — Accept Input

Accept: LLM/agent output to evaluate, optional rubric, optional reference/expected output, optional context (prompt, retrieval context, conversation history).

### Step 2 — Classify Evaluation Need

| Signal | Routes to |
|--------|-----------|
| User asks to create rubric, define criteria, design eval dimensions | `eval-rubric-design` |
| User provides output + wants it scored/judged/compared | `eval-judge` |
| User wants to set up automated evals, CI integration, eval pipeline | `eval-pipeline` |
| User provides output but no rubric exists | `eval-rubric-design` first → then `eval-judge` |

**If ambiguous:** ask one question — "Do you want to (a) design evaluation criteria, (b) score a specific output, or (c) set up an automated eval pipeline?"

### Step 3 — Route to Sub-Skill

Invoke the matched sub-skill with all available context.

### Step 4 — Unified Report

Present the unified report (see Output Format). If blocked at rubric design, report why and stop.

---

## Call Graph

```
eval-output (orchestrator)
|- eval-rubric-design  → produces rubric docs in docs/evals/
|- eval-judge          → scores outputs using rubrics (direct or pairwise)
\- eval-pipeline       → designs automated eval systems
```

---

## Output Format

```
=== Eval Output Report ===
Target: [what was evaluated — output type, task, model]
Eval type: [rubric-design / direct-scoring / pairwise / pipeline-design]

=== Evaluation ===
[Sub-skill specific output]

=== Summary ===
[Key findings, recommendations, next steps]
```

---

## Gotchas

- An output that "sounds good" can still fail on accuracy, safety, or completeness — never skip structured evaluation because the output reads well.
- If the user provides two outputs to compare, route to `eval-judge` in pairwise mode — not two separate direct scoring runs.
- Rubrics drift over time as tasks and models evolve. Recommend periodic rubric review when eval results change unexpectedly.
- Self-evaluation (model judging its own output) has known self-enhancement bias. Recommend a different model for judging when possible.
- **High aggregate scores can mask low business value.** Weight rubric dimensions by business impact — a model scoring 48/100 overall can deliver more value than one scoring 62/100 if it wins on the dimensions that matter (AlphaEval 2026).
- **Long-form agent outputs contradict themselves.** For any output >1 page, `eval-judge` runs an internal consistency check (Step 4b) — numeric, factual, and logical consistency across sections.
- **Multi-step agent pipelines need per-step evaluation.** Cascade dependency is the #1 pipeline failure mode. `eval-pipeline` enforces per-step checkpoints before end-to-end eval.

---

## Example

<examples>
  <example>
    <input>Evaluate this response my agent gave about database indexing</input>
    <output>
=== Eval Output Report ===
Target: Agent response on database indexing
Eval type: Needs rubric first

No rubric found for this task. Routing to eval-rubric-design to create one.

[Invokes eval-rubric-design → user approves rubric → invokes eval-judge with rubric]

=== Evaluation ===
[Structured scores per dimension with justifications]

=== Summary ===
Overall: 3 of 5 dimensions scored 4+/5. Accuracy strong, completeness weak.
Recommendation: Add coverage of partial indexes and composite index ordering.
    </output>
  </example>
</examples>

---

## Impact Report

After completing, always report:
```
Evaluation complete: [target description]
Eval type: [rubric-design / direct-scoring / pairwise / pipeline-design]
Sub-skill invoked: [name]
Dimensions scored: [N]
Hard gates: [N] pass, [N] fail
Key finding: [one-line summary]
Next step: [recommendation]
```
