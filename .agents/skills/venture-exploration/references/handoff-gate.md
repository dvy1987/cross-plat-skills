# Handoff Gate — venture-exploration → product-soul

Load in `venture-exploration` Step 6. Run before any handoff to `product-soul`.

The gate is the contract between exploratory work (multiple variants, hypothesis-heavy) and committed strategic work (singular product, north-star artefact). `product-soul` does NOT screen ideas — this gate does.

## The 5-Criteria Check

A surviving idea must pass ALL FIVE before handoff is allowed.

### Criterion 1 — Named segment
- ✅ Pass: A specific persona in a specific situation. "Solo brand designers in NYC charging $100+/hr, 1–3 active clients/month."
- ❌ Fail: "Designers", "freelancers", "consumers", "developers", "businesses".
- Source: `docs/ventures/models/<idea>-canvas.md` `Customer Segments` box, OR `docs/ventures/discovery/<idea>-interviews.md` ICP fit.

### Criterion 2 — Specific JTBD / pain
- ✅ Pass: Quote-form. "When I finish a project and hand off the deliverables, I want to get paid within 14 days, so I can pay myself salary."
- ❌ Fail: "They have a problem with payments." / "It's a pain point."
- Source: Interview quotes from `customer-discovery`, or canvas Problem/Pains box, with at least one verbatim user quote.

### Criterion 3 — Current alternative
- ✅ Pass: Named alternative + why it fails. "Manual reminders 2x/week + occasional Slack DMs. Awkward, embarrassing, and inconsistent."
- ❌ Fail: "Nothing." / "They don't have a solution today." (almost always wrong; if literally true, the pain is not acute and the idea is not viable).
- Source: Canvas + discovery synthesis.

### Criterion 4 — Plausible distribution wedge
- ✅ Pass: ONE specific channel + entry point. "SEO on long-tail Stripe-pain queries (40+ identified low-DR keywords)."
- ❌ Fail: "SEO + content + social" / "We'll figure out distribution" / "Viral".
- Source: Canvas Channels box, with a feasibility argument.

### Criterion 5 — Next kill test declared
- ✅ Pass: Named test + cost + timeline + success/kill thresholds + owner. "Concierge MVP for 5 customers; $0; 3 weeks; success = 3/5 paying $29/mo by week 3; kill = <2/5 paying."
- ❌ Fail: "We'll do customer discovery." / "We'll launch and see."
- Source: `docs/ventures/evaluations/<idea>-eval.md` `Next Kill Test` section.

## Gate Output

```markdown
## Handoff Gate Check — <idea>
Date: YYYY-MM-DD

| # | Criterion | Status | Source |
|---|---|---|---|
| 1 | Named segment | ✅ / ❌ | <file ref> |
| 2 | Specific JTBD / pain | ✅ / ❌ | <file ref> |
| 3 | Current alternative | ✅ / ❌ | <file ref> |
| 4 | Plausible distribution wedge | ✅ / ❌ | <file ref> |
| 5 | Next kill test declared | ✅ / ❌ | <file ref> |

Result: <PASS — handoff to product-soul / FAIL — N missing>

If FAIL:
- Missing criteria: <list>
- Recommended next child: <idea-generation / business-modeling / idea-evaluation / customer-discovery>
- Reason: <which child produces the missing artefact>
```

## What happens on PASS

Announce:
> "Handoff gate passed. Routing to `product-soul` to write the strategic north star for <idea>. After product-soul, expected sequence: `brainstorming` → `prd-writing` → (build) → `experimentation` → `reality-check`."

Do NOT auto-invoke `product-soul` — let the user confirm. They may want to do a final sanity check or run discovery one more round.

## What happens on FAIL

Do NOT lower the bar. Do NOT explain away missing criteria. Route to the child that produces the missing artefact:

| Missing | Route to |
|---|---|
| Named segment | `customer-discovery` (find real users) OR `business-modeling` (specify segment in canvas) |
| Specific JTBD | `customer-discovery` (interviews to capture verbatim) |
| Current alternative | `customer-discovery` (interviews; canvas alone is hypothesis) |
| Distribution wedge | `business-modeling` (channels box) OR `idea-evaluation` (check wedge specificity) |
| Next kill test | `idea-evaluation` (Step 6 designs the test) |

## Override

A user may force handoff despite gate failure. Allowed but documented:

```markdown
## Founder Override
Gate result: <N>/5
Override reason: <user-supplied — must be concrete>
Risk acknowledged: <which criterion was skipped and the resulting risk>
Mitigation: <what will be done in product-soul / brainstorming to compensate>
```

Mark in `docs/skill-outputs/SKILL-OUTPUTS.md`:
```
| YYYY-MM-DD HH:MM | venture-exploration | (no file) | Handoff override <N>/5 → product-soul: <reason> |
```

This logs the decision for accountability if the venture fails downstream for the skipped reason.
