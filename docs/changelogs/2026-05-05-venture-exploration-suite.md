# Changelog: Venture Exploration Skill Suite

**Date:** 2026-05-05
**Type:** New skill family — 5 new skills, 14 reference files
**Bar to beat:** Strategyzer's Lean Canvas / BMC / VPC, Rob Fitzpatrick's *The Mom Test*, Bland & Osterwalder's *Testing Business Ideas*, YC's "why now / why you / why this"

---

## What Changed

### 5 new skills added

| # | Skill | Lines | Role |
|---|-------|-------|------|
| 1 | `venture-exploration` | 194 | Thin orchestrator. Diagnoses lifecycle stage (no idea → generate; have idea → model; have model → evaluate; evaluated → validate; surviving idea → handoff) and routes to exactly one child. Holds a binding 5-criteria handoff gate to `product-soul`. Never produces artefacts itself. |
| 2 | `idea-generation` | 190 | Blank-page or domain-led idea generation. 8 generation methods (pain mining, JTBD interrogation, trend × capability matrix, constraint relaxation, adjacency search, schlep blindness, live-in-the-future, RFS scan). Default 5–10 candidates, ≥2 non-obvious, every card has 7 fields. |
| 3 | `business-modeling` | 194 | Picks ONE primary canvas — Lean Canvas (default early-stage), BMC (revenue/ops focus), or VPC (value-prop fit) — and fills it with falsifiable specifics. Top-3 critical assumptions with measurable falsification thresholds. Optional VPC appendix. |
| 4 | `idea-evaluation` | 196 | Scores an unbuilt idea on 11 dimensions, returns binding GO / ITERATE / KILL verdict with kill criteria (90-day) + next kill test (assumption, method, cost, timeline, owner, success/kill thresholds). Verdict gate trumps composite score. |
| 5 | `customer-discovery` | 199 | Mom Test–style problem-discovery interviews. Designs guides, coaches live interviews, or synthesizes batches. Codes every quote into 7 categories with explicit verdict weights. Min 5 interviews before any positive verdict; strong disconfirming evidence kills earlier. |

All five SKILL.md files are ≤200 lines (the project's hard rule). Total scope: 973 SKILL.md lines + 14 reference files.

### 14 reference files created

**`venture-exploration/references/`**
- `routing-table.md` — stage diagnosis, out-of-scope routing, trigger overlap protection
- `handoff-gate.md` — 5-criteria gate (segment / JTBD / current alternative / distribution wedge / next kill test) + override protocol

**`idea-generation/references/`**
- `generation-methods.md` — 8 methods + selection heuristic by founder context
- `idea-card-template.md` — 7-field template with passing/failing examples
- `anti-patterns.md` — auto-strike rules (label-only ideas, "everyone" segments, generic GTM, vague why-now)

**`business-modeling/references/`**
- `canvas-selector.md` — decision tree + stage heuristic for picking Lean / BMC / VPC
- `canvas-templates.md` — full filled-templates for all three canvases
- `anti-patterns.md` — per-box fluff filter (especially the moat / unfair-advantage box)

**`idea-evaluation/references/`**
- `evaluation-rubric.md` — 11 dimensions, 1–5 anchors, verdict gate rules, composite-score bands
- `kill-test-recipes.md` — 7 disconfirming-test methods (interview, smoke-test landing page, concierge MVP, pre-sell/LOI, expert review, regulatory letter, Wizard-of-Oz)
- `anti-patterns.md` — vibecoded-business tells (TAM=global, "no competitors", "we'll figure out monetisation", etc.)

**`customer-discovery/references/`**
- `mom-test-rules.md` — 3 core rules + bad→good question rewrites + signal weight ordering
- `interview-guide-template.md` — recruiting message + 30-min structure + probe banks (allowed and forbidden)
- `synthesis-template.md` — 7-code coding scheme + cross-interview aggregation + assumption-update format

---

## Lifecycle Map

The suite owns the **pre-decision** lifecycle and hands off to the existing **committed** lifecycle once one idea survives the handoff gate.

```diagram
       PRE-DECISION (this suite)             COMMITTED (existing)
╭──────────────────────────────────────╮  ╭──────────────────────────────╮
│ idea-generation → business-modeling  │  │ product-soul → brainstorming │
│        ↓             ↓               │→ │ → prd-writing → experimentation│
│   idea-evaluation ↔ customer-discovery│  │ → reality-check              │
╰──────────────────────────────────────╯  ╰──────────────────────────────╯
```

| Stage | User signals | Skill |
|---|---|---|
| Generate | "what should I build", "give me startup ideas", "blank page" | `idea-generation` |
| Model | "Lean Canvas", "BMC", "VPC", "model this business" | `business-modeling` |
| Evaluate | "is this a good idea", "go/no-go", "should I build this" | `idea-evaluation` |
| Validate | "Mom Test", "interview users", "talk to customers" | `customer-discovery` |
| Commit / handoff | surviving idea passes 5/5 gate | `product-soul` (out of suite) |

---

## Library hygiene updates

- **`AGENTS.md`** — added 5 new User Entry Points (venture-exploration orchestrator, idea-generation, idea-evaluation, business-modeling, customer-discovery)
- **`docs/SKILL-INDEX.md`** — 5 new entries in Project-Specific section between `experiment-readout` and `project-orchestrator`; Call Graph extended with full venture-exploration subgraph (orchestrator routing + child cross-calls + handoff to product-soul); date bumped to 2026-05-05

---

## Why this matters

agent-loom was previously **post-decision-only.** It had:

- `product-soul` (strategic north star — once you've decided what to build)
- `brainstorming` (turn approved idea into design)
- `prd-writing` (PRD after design is approved)
- `reality-check` (claims-vs-reality on existing products)
- `experimentation` (A/B tests on live products)

But it was **missing the entire pre-decision lifecycle**:

1. **Idea generation from a blank page** — `brainstorming` refines an existing idea; nothing in the library generated business ideas systematically.
2. **Iterative business-model exploration** — Lean Canvas / BMC / VPC are exploratory multi-variant artefacts; `product-soul` is committed-singular. Different stage, different artefact.
3. **Unbuilt-idea screening** — `reality-check` scores existing implementations; nothing scored ideas before commit (market size, why-now, founder-market-fit, distribution feasibility, defensibility, capital intensity, regulatory/ethical risk).
4. **Mom Test customer discovery** — problem-validation interviews with explicit anti-patterns (no "would you use this?", no pitching, no friend-ICP, no compliments-as-validation).

This release ships all four in a tightly-scoped suite that **leverages existing skills** rather than duplicating them. The orchestrator routes; the children call into `fermi` (sizing), `assumption-mapping` (hidden beliefs), `pre-mortem` + `adversarial-hat` (high-stakes critique), `secure-*` (mandatory before external transcript synthesis), `first-principles` and `socratic` (when stuck).

---

## The headline design decisions

After deep deliberation (oracle-reviewed):

1. **One skill per workflow, not one skill per framework.** BMC + Lean Canvas + VPC are artefact variants of the same workflow → ONE `business-modeling` skill with canvas selection logic, not three skills.
2. **`customer-discovery` deserves its own skill.** Mom Test work is a real workflow (recruiting, guide design, interview coaching, signal synthesis) — burying it inside `idea-evaluation` would make both shallow.
3. **Cut sprawl ruthlessly.** `why-now`, `founder-market-fit`, `pricing`, `positioning`, `naming`, `market-research-synthesis` are sections inside the 4 children, not separate skills.
4. **Frameworks excluded as bloat:** Wardley Mapping, Blue Ocean, Christensen's Disruption Theory, Porter's Five Forces, Crossing the Chasm, 1000 True Fans. Late-stage or out-of-scope for v1.
5. **The handoff gate is binding.** 5/5 criteria (named segment, specific JTBD, current alternative, plausible distribution wedge, declared next kill test) — `product-soul` is not a screen, the gate is.
6. **Distribution wedge + next kill test are mandatory.** Every serious evaluation must end with the cheapest disconfirming test the founder will actually run, with pre-committed kill threshold.

---

## Anti-patterns hard-banned across the suite

- "Uber/Notion/AI for X" without a specific JTBD
- "Everyone" segments ("consumers", "developers", "businesses")
- TAM = global market size; "if we get 1% of the market"
- "No direct competitors"
- "10x better/faster/cheaper" without metric or mechanism
- Generic GTM ("SEO/social/content/ads/virality") with no wedge
- "Unfair advantage = AI/data/network effects/community" without a concrete asset
- Compliments coded as validation; friends-as-ICP
- Solution-pitching disguised as customer discovery
- Two-sided marketplaces with no bootstrap path
- Enterprise ideas with no named buyer/user/budget
- Regulatory shrugging in health, fintech, legal, education
- PMF claims from waitlists or signups
- "We'll figure out monetisation later" when viability depends on it

---

## Trigger boundary protection

The orchestrator's routing table prevents trigger competition with adjacent skills:

| User intent | Routes to | NOT to |
|---|---|---|
| "what business should I start" | `venture-exploration` | `brainstorming` |
| "design this feature" (idea chosen) | `brainstorming` | `venture-exploration` |
| "write our product strategy" (one concept committed) | `product-soul` | `venture-exploration` |
| "audit claims-vs-reality" (product exists) | `reality-check` | `idea-evaluation` |
| "design/launch/read out a test" | `experimentation` | `customer-discovery` |

---

## Verification

All five SKILL.md files pass structural checks:
- ≤200 lines (the project's hard rule)
- Frontmatter present with `name` matching directory
- Description with explicit triggers
- `## Impact Report` section
- File-output logging convention to `docs/skill-outputs/SKILL-OUTPUTS.md`

---

## Try it

```
"What business should I start as a backend engineer with payments experience?"
→ venture-exploration → idea-generation
```

```
"Is the freelance-designer invoicing tool a good business idea?"
→ venture-exploration → idea-evaluation
```

```
"Lean Canvas this idea for me"
→ venture-exploration → business-modeling
```

```
"Design a Mom Test interview guide for our top assumption"
→ venture-exploration → customer-discovery
```
