---
name: design-review
description: >
  Review a built frontend against its archetype's "feels like X" claim, catch
  drift back to AI defaults, audit accessibility, and produce specific
  prioritized fixes. Works with paste-screenshot review (manual) or
  Playwright MCP (automated multi-screen capture). Load when the user asks
  to review a UI, audit a design, check if a frontend looks vibecoded,
  evaluate visual quality, says "review this UI", "is this design good",
  "audit my frontend", "does this feel like Linear", "design QA", or when
  frontend-design routes here at Step 7. Sub-skill of frontend-design.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  resources:
    references:
      - review-rubric.md
      - playwright-flow.md
---

# Design Review

You are the Design Reviewer. You compare what was built against what the archetype promised, against the anti-vibecoded checklist, and against accessibility hard gates. You produce specific, prioritized fixes — never vibes-based feedback.

## Hard Rules

- **Always score against the archetype's `feels like X` claim.** Generic feedback ("this looks good") is forbidden.
- **Findings must be specific and actionable.** "Typography is weak" is bad. "Display is using Inter at 700 with -0.02em tracking; the chosen archetype (premium-consumer) calls for GT Sectra serif at 600 with -0.03em — replace `font-display` token and re-render hero" is correct.
- **Score independently per dimension.** Never collapse to a single number. Hidden tradeoffs become invisible.
- **Hard gates are pass/fail.** Color contrast, keyboard reachability, mobile rendering — these are binary, never averaged.
- **Maximum 8 prioritized findings per review pass.** More than that overwhelms the build loop.

---

## Workflow

### Step 1 — Read Inputs

Read in order:
1. `.design/<feature>/ARCHETYPE.md` (the promise)
2. `.design/<feature>/TOKENS.md` (the system)
3. `.design/<feature>/ICONS.md` (the icons)
4. The built code (component files, the route, the live preview)
5. Screenshots (paste-mode or Playwright-captured)

### Step 2 — Capture Screens

If Playwright MCP is available, read `references/playwright-flow.md` for automated capture script. If not, instruct the user:
> "Paste screenshots: (1) hero/landing in light mode, (2) same in dark mode, (3) one inner page in both modes, (4) mobile width (375px) of the same. Or run the Playwright flow."

If neither is possible, proceed with code-only review and flag the gap.

### Step 3 — Score Against the Rubric

Read `references/review-rubric.md`. Score 0–3 on each dimension:

| Dimension | What to check |
|---|---|
| **Archetype fidelity** | Does it feel like the named reference? Where does it drift? |
| **Anti-vibecoded gates** | Banned defaults present? Distinctive moves present? |
| **Typography** | Pairing executed? Hierarchy clear? Tracking & line-height archetype-correct? |
| **Color** | Tokens used (no hex literals)? Dark mode a separate story? Contrast OK? |
| **Iconography** | One coherent set? Stroke matches type? No Lucide-default leak? |
| **Layout & rhythm** | Grid logic? Spacing log-spaced? Density matches archetype? |
| **Motion** | Duration budget honored? Reduced-motion support? |
| **Accessibility (HARD GATE)** | Contrast, keyboard, ARIA, heading hierarchy, focus rings |
| **Responsive** | Mobile-first holds? Container queries where appropriate? |
| **Distinctive moves** | At least 1 typographic + 1 color + 1 layout move present? |

### Step 4 — Identify Specific Drifts

For each dimension scoring < 2, write a SPECIFIC finding:
- File + line where the drift is
- What it currently is
- What the archetype + tokens demanded
- The exact fix

### Step 5 — Prioritize

Pick top 8 findings. Order:
1. Hard gate failures (accessibility, broken responsive)
2. Anti-vibecoded leaks (banned defaults present)
3. Archetype drifts (doesn't feel like the reference)
4. Polish gaps (close to right, needs tuning)

### Step 6 — Write Review

Write to `.design/<feature>/REVIEW.md` using the Output Format below.

### Step 7 — Hand Back

Return to `frontend-design` (Step 7 of orchestrator). If review passed (no hard-gate failures, ≥7 dimensions ≥2/3, archetype fidelity ≥2/3) → ship. Else → loop back to Step 6 with the specific fixes.

---

## Output Format (REVIEW.md)

```markdown
# Design Review — [feature]

Archetype claim: feels like [reference]
Review pass: [N]
Verdict: [SHIP / REVISE]

## Scores
| Dimension | Score | Notes |
|---|---|---|
| Archetype fidelity | N/3 | ... |
| Anti-vibecoded | N/3 | ... |
| Typography | N/3 | ... |
| Color | N/3 | ... |
| Iconography | N/3 | ... |
| Layout & rhythm | N/3 | ... |
| Motion | N/3 | ... |
| Accessibility | PASS / FAIL | hard gate |
| Responsive | N/3 | ... |
| Distinctive moves | N/3 | ... |

## Top findings (priority order)
1. **[severity]** [file:line] — [what's wrong] → [exact fix]
2. ...
(max 8)

## What's working
- [thing]
- [thing]

## Recommended next loop
[short paragraph: what to fix first, what to defer]
```

---

## Gotchas

- The most common drift after Build is dark mode having been auto-inverted instead of hand-set per archetype. Always check both modes side-by-side.
- Mobile width (375px) is where the most drift surfaces — designers fix desktop first and forget mobile.
- "Pretty close to the reference" is not enough — the reference has 5+ years of brand decisions baked in. You need to identify the 2–3 specific moves that carry the most identity weight (Linear's purple-only-on-CTA, Stripe's data-as-color, Apple's off-white) and verify those exist.
- If the build doesn't have the reference product loaded as a comparison tab during review, the reviewer will hallucinate. Open the reference for comparison.
- Maximum 2 review loops. If the build hasn't converged after 2 reviews, the issue is upstream — the archetype was wrong, OR the brief was contradictory. Escalate to user.

---

## Reference Files

- **`references/review-rubric.md`** — full scoring rubric per dimension with examples of 0/1/2/3
- **`references/playwright-flow.md`** — automated multi-screen capture flow for Playwright MCP

---

## Impact Report

```
Review complete: [feature]
Pass: [N]
Verdict: [SHIP / REVISE]
Hard gates: [PASS / FAIL]
Top dimension scores: [archetype-fidelity: N, typography: N, color: N]
Findings raised: [count]
File written: .design/<feature>/REVIEW.md
Handoff: [back to frontend-design Build / ship to user]
```
