# Reality-Check Deliverable Templates

Load this file during `reality-check` Step 8 when writing the two output documents. Both templates are required — findings without a roadmap is critique without direction.

---

## Template 1: Findings Report

Saved to `docs/YYYY-MM-DD-reality-check-findings.md`.

```markdown
# Reality Check Findings — [Project Name]

## Executive Summary
[2-3 sentences: what it is, what it claims, overall verdict]

## Claim-by-Claim Assessment
[Table: claim | verdict | score | evidence]

## What's Genuinely Impressive
[List with specific evidence — adversarial-hat survivors go here]

## Architectural Gaps
[Classified by severity with evidence — Fatal / Significant / Minor]

## Fundamental Limitations
[Hard ceilings that more features won't solve]

## Competitive Positioning
[Comparison tables + honest positioning]

## Creative Solutions
[Per-gap approaches with pros/cons — Lightweight / Medium / Heavyweight]

## Risks and Guardrails
[Risk | Mitigation table]

## Final Verdict
[Brutally honest + constructive versions]
[Composite score + per-dimension scores]
```

---

## Template 2: Roadmap

Saved to `docs/YYYY-MM-DD-roadmap-and-implementation-plan.md`.

```markdown
# Roadmap — [Project Name]

## Phases (sequenced: prove → build → scale)
[Phase 0: Honest reframing]
[Phase 1: Prove one wedge end-to-end]
[Phase 2-N: Build infrastructure, then scale]

## Success Metrics by Phase
[Per-phase observable signal that the phase is done]

## Approach Comparison Matrices
[For each major decision: rows = options, columns = effort/risk/value/reversibility]

## Decision Framework
[How the project chooses among the approaches when trade-offs appear]
```

---

## Output Logging

After both files are written, append two rows to `docs/skill-outputs/SKILL-OUTPUTS.md` (create if missing):

```
| YYYY-MM-DD HH:MM | reality-check | docs/YYYY-MM-DD-reality-check-findings.md | Findings: [project] |
| YYYY-MM-DD HH:MM | reality-check | docs/YYYY-MM-DD-roadmap-and-implementation-plan.md | Roadmap: [project] |
```

Then tell the user:
> "Findings saved to `[path]`. Roadmap saved to `[path]`. Logged in `docs/skill-outputs/SKILL-OUTPUTS.md`."
