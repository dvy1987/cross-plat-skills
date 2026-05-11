# Idea Evaluation — Rubric

Load when scoring an unbuilt idea in `idea-evaluation` Step 4 / Step 5.

## The 11 Dimensions

| # | Dimension | Question | Scored on |
|---|---|---|---|
| 1 | Desirability | Is the pain real and acute for a specific segment? | Behavioural evidence of pain |
| 2 | Viability | Does unit economics math at SOM scale? | LTV:CAC, gross margin, runway-to-revenue |
| 3 | Feasibility | Can a small team build v1 in <6 months? | Tech complexity, dependencies, team skill |
| 4 | Distribution wedge | Is there ONE specific channel that works pre-scale? | Specificity + repeatability of channel |
| 5 | Why now | What changed in tech / regulation / behaviour / cost in last 24 months? | Specificity + timing |
| 6 | Founder-market fit | Unfair domain insight, network, credibility? | Lived experience + access |
| 7 | Market size | SOM defensible in $? | Fermi from Step 2 |
| 8 | Current alternatives | What do users use today, why painful? | Named alternatives + pain delta |
| 9 | Defensibility | What asset compounds with time/users? | Proprietary data, network, brand, switching cost |
| 10 | Capital intensity | Reach revenue with <$200k pre-seed? | Cost to first dollar |
| 11 | Regulatory/ethical risk | Path to operate clear in jurisdiction? | Legal precedent, licences, ethics review |

## 1–5 Anchors (apply per dimension)

- **5 — Strong:** Hard evidence (interviews, currency, traction, named partners, working prototype). Risk is named and bounded.
- **4 — Plausible:** Reasoned argument with 1+ proof points, no contradicting evidence.
- **3 — Hypothesis:** Claim is coherent but unvalidated. Specific assumption named.
- **2 — Weak:** Claim is vague or contradicted by available evidence.
- **1 — Absent / fatal:** No claim, or evidence directly disproves it, or unsolvable.

## Verdict Gate

The composite (sum/55) is informational. Verdict is gated on these rules in order:

### KILL triggers (any one fires → KILL)
- Desirability ≤ 2 (pain not painful)
- Distribution wedge ≤ 2 (no plausible channel)
- Why now is "AI is changing things" or equivalent vagueness
- Regulatory blocker = fatal (no licence / no jurisdiction path)
- SOM below the user's stated minimum ARR threshold
- Capital intensity > runway with no funding path

### ITERATE triggers
- 1–2 dimensions score ≤2 AND the failed assumption is testable for <$5k
- Hard prerequisites partially met (1 of 4 missing in Hard Gates #4)

### GO requires ALL of:
- Painful current workaround named (not "they currently do nothing")
- Specific segment named (a real persona, not "developers")
- Plausible first distribution channel named (not "SEO/social/content")
- No fatal regulatory blocker
- No KILL trigger fires
- Composite ≥ 33/55 (informational threshold; can be overridden)

## Founder Override

A user may override the gate. When this happens:
- Document the override reason explicitly in the eval doc
- Mark the verdict as `GO (founder override)`
- Require an extra-aggressive next kill test (≤30 days, ≤$2k)
- Re-run the eval after the kill test

## Composite Score Bands (informational)

| Composite | Reading |
|---|---|
| 45–55 | Worth real currency on the next kill test |
| 33–44 | Iterate first — fix the 1–2 weak dimensions before commitment |
| 22–32 | Most likely KILL — heavy lift to fix multiple weaknesses |
| <22 | Kill — pivot or abandon |

Composite alone never produces a verdict. The hard gates do.
