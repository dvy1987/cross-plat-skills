# Discovery Synthesis Template

Load in `customer-discovery` Step 6. Use to convert raw interview notes into a verdict on the assumption being tested.

## Quote Coding Scheme

Every captured quote is coded into one of seven categories with explicit weight in the verdict.

| Code | Definition | Weight in verdict | Example |
|---|---|---|---|
| `FACT` | Observable past behaviour, falsifiable | High | "I switched from HoneyBook to Bonsai last March because of the pricing." |
| `PAIN` | Unprompted complaint about current state | High | "The hardest part is chasing clients twice a week — it kills my Mondays." |
| `CURRENCY` | Spent money / time / political capital | **Highest** | "I paid an accountant $400/mo just to do my A/R chases." |
| `WORKAROUND` | Specific named tool / hack / process | High | "I use a Notion template plus 4 calendar reminders." |
| `OPINION` | Predicted future behaviour or abstract take | Discard for verdict | "I'd love something that just handled this for me." |
| `COMPLIMENT` | Praise of idea or interviewer | Discard for verdict | "That sounds really cool, you should build it." |
| `SOLUTION-TINTED` | Said AFTER the solution was revealed | Low | "Yeah, I'd definitely use what you're describing." |

Coding rule: when in doubt between two codes, pick the lower-weight one. Do NOT inflate compliments to PAIN or PAIN to CURRENCY.

## Per-Interview Summary

For each interview, log:

```markdown
### Interview <N> — <interviewee role / segment fit> — <date>
Source: <recruiting tier 1 / 2 / 3>
ICP fit: strong / moderate / weak (mark proxies)

Quotes:
| # | Code | Quote (≤25 words) |
|---|---|---|
| 1 | CURRENCY | "I paid Bonsai $39/mo for 18 months before cancelling — never solved the chase problem." |
| 2 | PAIN | "Chasing late invoices is the worst part of being self-employed." |
| 3 | OPINION | "I'd love a tool that does this automatically." |
| 4 | COMPLIMENT | "Cool idea, you should build it." |

Workaround named: <specific tools / processes>
Currency evidence: <yes / no — what>
Painful problem: yes / no / partial
Notes: <interview-specific context>
```

## Cross-Interview Aggregation

```markdown
## Aggregated Signal (N=<interviews>)

### Pain reports
- Painful problem reported (prompted): <M/N>
- Painful problem reported (unprompted): <M/N>  ← stronger
- Threshold: ≥3/5 unprompted = strong signal

### Currency evidence
- Paid for any solution: <M/N>
- Built / hired workaround: <M/N>
- Asked for budget: <M/N>
- Threshold: ≥2/5 currency evidence = strong signal

### Workaround clustering
- Most common workaround: <name> (<M/N> interviews)
- Second most common: <name> (<M/N>)
- Workaround diversity: low / medium / high
- High diversity = segment may not be coherent

### Disconfirming patterns
- "I tried X before, it didn't work because Y": <list>
- "I don't actually have this problem": <count>
- "My version of the problem is fundamentally different": <count>

### Cross-segment notes
- ICP-fit interviews: <strong>/<all>
- Proxy / weak-fit interviews: <discount in verdict>
```

## Verdict on Assumption

For each top-3 assumption from the canvas, record the update:

```markdown
## Assumption Updates

### Assumption 1: <statement>
- Status: CONFIRMED / WEAKENED / KILLED
- Supporting evidence: <interview #> — <code> — <quote>
- Disconfirming evidence: <interview #> — <code> — <quote>
- Updated assumption: <revised version, if any>
- New test needed: <yes / no — what>

### Assumption 2: ...
```

## Decision

```markdown
## Recommendation

- [ ] Sufficient signal to proceed → re-run `idea-evaluation` with new evidence
- [ ] Insufficient signal → run another <N> interviews with refined recruiting / questions
- [ ] Strong disconfirming signal → KILL this assumption (and possibly the idea)
- [ ] Segment mismatch → adjust segment, re-run discovery

## Anti-Pattern Audit
- "Would you use this?" leakage: <count>
- Pitching during problem questions: <count>
- Friend/family-only ICP: <count>
- Compliments coded as validation: <count>
```

## Quality bar for synthesis

- Every interview has at least 5 coded quotes
- No claim in the verdict without a citing quote
- No inflation of weak codes (COMPLIMENT → never weighted as confirmation)
- ICP-fit explicitly judged for each interview
- Disconfirming evidence given equal airtime as confirming
- Verdict uses the pre-declared kill-threshold from the eval doc
