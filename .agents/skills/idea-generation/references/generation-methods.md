# Idea Generation — Method Catalogue

Load in `idea-generation` Step 2. Pick 2–3 methods aligned with founder/domain context.

## 1. Pain Mining
- **Best when:** Founder has lived experience in a domain.
- **Prompt:** "What did you complain about most in the last 6 months at work / in the role / in the community?"
- **Process:** List 10 pains. Strip duplicates. For each: who else has it, how acutely, what they do today.
- **Output strength:** High specificity, high FMF.
- **Risk:** Founder bubble — pains may be niche to founder's company/situation.

## 2. JTBD Interrogation
- **Best when:** A workflow exists but is awkward.
- **Prompt:** "When [user] is doing [activity], what are they trying to accomplish, and what's the next step they always dread?"
- **Process:** Pick a job. Map the steps. Find the friction step. The friction step is the idea.
- **Output strength:** Workflow-specific, falsifiable.
- **Risk:** Over-fits to one company's process.

## 3. Trend × Capability Matrix
- **Best when:** New tech (AI inference cost, edge compute, regulatory unlock, distribution platform shift) just changed unit economics.
- **Prompt:** "What was previously uneconomic (manual / expensive / slow) that is now economic — and who has the resulting pain?"
- **Process:** List 3–5 trends. Cross with 3–5 capabilities. Each cell is an idea seed.
- **Output strength:** Strong why-now built in.
- **Risk:** Solutions in search of problems if trend isn't grounded in a specific user pain.

## 4. Constraint Relaxation
- **Best when:** A mature market accepts a constraint that has now lifted.
- **Prompt:** "What is everyone in [industry] still doing because they assume they have to — but the assumption is no longer true?"
- **Process:** List industry conventions. For each, ask: is this actually still a hard constraint? If no, the new design is the idea.
- **Output strength:** Often produces non-obvious ideas.
- **Risk:** Some constraints persist for non-obvious regulatory / network reasons.

## 5. Adjacency Search
- **Best when:** Founder has a moat in adjacent domain (data, network, credibility).
- **Prompt:** "What can your existing audience / data / network / credibility unlock in a related domain you don't already serve?"
- **Process:** List founder's assets. List adjacent users. Cross-product.
- **Output strength:** Built-in distribution.
- **Risk:** Forces the founder into a market they don't deeply understand.

## 6. Schlep Blindness (Paul Graham)
- **Best when:** Founder dismisses ideas because they "look annoying".
- **Prompt:** "What ideas have you mentally vetoed because they involve sales / regulation / hardware / boring back-office work — even though the underlying need is real?"
- **Process:** Surface 5 vetoed ideas. Ask why each was vetoed. Reconsider.
- **Output strength:** Fewer competitors because nobody else wants the schlep either.
- **Risk:** The schlep is real and may be the wrong fit for this founder.

## 7. Live in the Future (Paul Graham)
- **Best when:** Founder uses something not yet mainstream (AI workflows, niche dev tools, novel social platforms, on-chain primitives).
- **Prompt:** "What do you do daily that 99% of people don't do yet — and what's the obvious gap in tooling for the people who'll be doing it in 24 months?"
- **Process:** List founder's "future" behaviours. For each, identify what's missing.
- **Output strength:** Genuine why-now.
- **Risk:** Mainstream may take longer than 24 months — timing risk.

## 8. RFS / Explicit Gap List
- **Best when:** Founder is open to anything; wants to scan known gaps.
- **Prompt:** "Pull from public RFS lists (YC, A16Z, Sequoia), known industry pain reports, or 'what we wish someone would build' threads."
- **Process:** Collect 20–50 gap claims. Filter by founder fit. Generate cards from top 5.
- **Output strength:** Validated demand from sophisticated parties.
- **Risk:** Crowded. Many founders are already chasing these.

## Method Selection Heuristic

| Founder context | Default methods |
|---|---|
| Deep domain expert | Pain Mining + JTBD Interrogation |
| Tech-forward, no domain | Trend × Capability + Live in the Future |
| Existing audience / community | Adjacency Search + Schlep Blindness |
| Open / no strong context | RFS + Pain Mining (founder's own life) |
| Industry insider | Constraint Relaxation + JTBD |

Combine 2–3 methods to get diversity in the generated batch.
