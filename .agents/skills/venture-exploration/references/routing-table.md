# Venture Exploration — Routing Table

Load in `venture-exploration` Step 2. Match user request + project state to one child skill.

## Stage Diagnosis Table

| Stage | User signals | Project state | Route to |
|---|---|---|---|
| **Generate** | "what should I build", "give me startup ideas", "I don't know what to build", "ideate ventures", "blank page" | No `docs/ventures/ideas/` OR explicit ask for more candidates | `idea-generation` |
| **Model** | "model this business", "fill the canvas", "Lean Canvas", "BMC", "VPC", "draw the business model" | One specific idea in mind, no canvas yet | `business-modeling` |
| **Evaluate** | "is this a good idea", "evaluate this idea", "screen this", "go/no-go", "should I build this", "is this worth pursuing" | Idea identified, optionally a canvas | `idea-evaluation` |
| **Validate** | "talk to customers", "validate the problem", "Mom Test", "interview users", "I just talked to N people", "synthesize my interviews" | Idea + at least one critical assumption to test | `customer-discovery` |
| **Commit / handoff** | "this is the one", "I'm committing to this", "let's productise this", "make this real" | Surviving idea passes 5/5 handoff gate | `product-soul` (out of suite) |

## Disambiguation rules

When the request matches more than one stage:

- **"Evaluate" + no canvas exists** → run `business-modeling` first if user is open; otherwise `idea-evaluation` with a flag that canvas is missing.
- **"I have an idea, what next"** (no specific signal) → ask: model OR evaluate OR validate? (binary).
- **"Should I build this" with eval already in `docs/ventures/evaluations/`** → likely needs `customer-discovery` (next kill test) — don't re-evaluate.
- **"Generate ideas" but evaluation/model exists for one idea** → user is iterating; ask: kill the previous idea or generate alongside?

## Out-of-scope routing

| Signal | Route to | Reason |
|---|---|---|
| "Design this feature" / "build this product" (idea chosen) | `brainstorming` | Suite is pre-decision only |
| "Audit claims-vs-reality" (product exists) | `reality-check` | Post-build territory |
| "Design / launch / read out a test" on a live product | `experimentation` | Suite is pre-build only |
| "Write the strategy doc" (one idea committed) | `product-soul` | Handoff target |
| "Write a PRD for this feature" (design approved) | `prd-writing` | Two stages downstream |

## Multi-idea handling

If the user is exploring 2+ ideas in parallel:
- Generation + Modeling can run in parallel batches.
- Evaluation runs per idea (separate file per idea).
- Customer discovery runs per assumption per idea.
- Do NOT route to `product-soul` until exactly ONE idea has passed the handoff gate.

## Looping rules

- After `idea-evaluation` returns ITERATE → route to whichever child addresses the failed dimension.
- After `customer-discovery` returns KILLED → re-run `idea-evaluation` with new evidence.
- Cap loops: if >3 ITERATE cycles on one idea without movement, surface "this looks stuck — kill, pivot, or commit despite weakness?"

## Trigger overlap protection

These exact phrases must NOT route to other skills:
- "model this business" / "Lean Canvas" → always `business-modeling`, never `brainstorming`
- "evaluate this venture" → always `idea-evaluation`, never `reality-check`
- "Mom Test" / "interview users" / "talk to customers" → always `customer-discovery`
- "what business should I start" → always `venture-exploration` (orchestrator), never `brainstorming`
- "is this a good business idea" → always `idea-evaluation`, never `prd-writing`

If trigger competition is detected (e.g., user says "brainstorm a business idea"), prefer `venture-exploration` because the user explicitly invoked the venture lifecycle.
