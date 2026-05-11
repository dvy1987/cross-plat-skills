# Kill Test Recipes

Load when designing the "next kill test" in `idea-evaluation` Step 6.

The goal is **disconfirming evidence as cheaply as possible**. Pick the cheapest method that could plausibly kill the riskiest assumption within 14–30 days.

## Method Catalogue

### 1. Five-Lever Customer-Discovery Interview (Mom Test)
- **Best for:** Desirability, Pain acuity, Workaround specificity, Currency willingness
- **Cost:** $0–$500 (incentives optional)
- **Timeline:** 1–2 weeks for 5–8 interviews
- **Kill threshold:** <3/5 interviewees describe the pain unprompted, or <2/5 have spent money/time on a workaround
- **Routes to:** `customer-discovery` skill
- **Best when:** Pain itself is the assumption being tested

### 2. Smoke-Test Landing Page
- **Best for:** Demand signal, willingness to engage, headline-message resonance
- **Cost:** $200–$2,000 (page + ads)
- **Timeline:** 7–14 days (need 500+ qualified visits)
- **Kill threshold:** <2% click-to-CTA OR <0.5% email-capture from qualified traffic
- **Caveat:** Smoke tests prove curiosity, NOT willingness to pay. Use only when curiosity is the assumption.
- **Best when:** Demand at the top of funnel is uncertain

### 3. Concierge MVP
- **Best for:** Whether the painful workflow can be solved at all (manually), and whether users will pay for it solved
- **Cost:** $0 + the founder's time
- **Timeline:** 2–4 weeks
- **Method:** Solve the problem manually for 3–5 customers. No product. Email, Notion, spreadsheets.
- **Kill threshold:** <2/5 customers continue past week 2, OR none willing to pay even token amount
- **Best when:** Willingness to pay + repeatability of solution are the assumptions

### 4. Pre-Sell / Letter of Intent
- **Best for:** B2B viability, real budget existence, decision-maker access
- **Cost:** $0
- **Timeline:** 2–6 weeks
- **Method:** Sell the not-yet-built product. Get signed LOI, deposit, or paid pilot.
- **Kill threshold:** <1 signed LOI from 10 qualified target accounts within 6 weeks
- **Best when:** Enterprise / mid-market viability is the assumption

### 5. Expert Review
- **Best for:** Regulatory risk, technical feasibility, capital intensity
- **Cost:** $0–$2,000 (paid expert call)
- **Timeline:** 1 week
- **Method:** 1–2 calls with domain experts (regulator, CTO, venture investor in space, ex-operator). Specific questions, not "what do you think".
- **Kill threshold:** Expert names a specific blocker that founder cannot solve
- **Best when:** Hidden regulatory / technical complexity is the risk

### 6. Regulatory Letter / Compliance Pre-Read
- **Best for:** Health, fintech, legal, education ideas
- **Cost:** $500–$5,000 (lawyer hour)
- **Timeline:** 2–4 weeks
- **Method:** Written summary of business model + jurisdiction → opinion letter on operability
- **Kill threshold:** Lawyer names licensure / consent / liability blocker without clear path
- **Best when:** Regulatory risk is the gating dimension

### 7. Wizard-of-Oz Prototype
- **Best for:** UX viability when the back-end is impossible/expensive
- **Cost:** $1,000–$5,000
- **Timeline:** 3–6 weeks
- **Method:** Front-end looks real; back-end is human-operated
- **Kill threshold:** Engagement <30% of expected, OR humans can't operate at <2x target unit cost
- **Best when:** Whether the user even wants the experience is uncertain

## Required Output Fields

For every kill test, the evaluation must document:

```
- Assumption: <one sentence; from assumption-mapping>
- Method: <one of the above>
- Cost: $<amount>
- Timeline: <N days>
- Owner: <name>
- Success threshold: <quantitative — what would confirm>
- Kill threshold: <quantitative — what would falsify>
- What we will do on KILL: <commit to alternative / pivot / abandon>
```

## Anti-Patterns

- **Test that cannot fail:** "We'll talk to 5 friends about it" → no kill threshold, no real signal
- **Test that doesn't isolate the assumption:** Building the whole product to test pricing → wrong scope
- **Smoke-test for paid willingness:** Email signups ≠ purchase intent
- **Survey-based kill tests:** Almost always overestimate purchase intent — discount by 5–10x or skip
- **No pre-committed kill threshold:** Without a number written down before the test runs, founder bias rationalises ambiguous results
