# Changelog: Frontend Design Skill Suite

**Date:** 2026-04-30
**Type:** New skill family — 5 new skills, 12 archetypes, 19 reference files
**Bar to beat:** Anthropic's `frontend-design` skill (single ~42-line SKILL.md), Julian Oczkowski's `designer-skills` (7-skill suite)

---

## What Changed

### 5 new skills added

| # | Skill | Lines | Role |
|---|---|---|---|
| 1 | `frontend-design` | 171 | Orchestrator + entry point. Routes through the family with anti-vibecoded hard gates. |
| 2 | `design-archetype` | 193 | Heart of differentiation — picks one of 12 curated product archetypes; outputs a `feels like X` claim. |
| 3 | `design-tokens-craft` | 170 | Generates archetype-driven semantic tokens (oklch); bans vibecoded defaults. |
| 4 | `icon-craft` | 177 | Solves the "Lucide everywhere" problem — 5 strategies, custom-SVG craft rules. |
| 5 | `design-review` | 164 | 10-dimension rubric vs the archetype's promise; max 2 review loops. |

All five SKILL.md files are ≤200 lines (the project's hard rule). Total scope: 875 SKILL.md lines + 19 reference files.

### 19 reference files created

**`frontend-design/references/`**
- `anti-vibecoded-checklist.md` — banned defaults (Inter-only, Tailwind grays, purple→pink, Lucide drop-in, centered hero with 2 CTAs, 3-col feature grid) + required distinctive moves (typographic, color, layout, component, motion, icon)
- `build-conventions.md` — mobile-first, dark-mode-first, motion budgets, accessibility hard gates, framework conventions (React, Vue, Svelte, HTML), copy rules
- `one-shot-flow.md` — compressed flow for posters / single artifacts where the full pipeline is overkill

**`design-archetype/references/`**
- `selection-rubric.md` — 0–3 scoring on audience fit / job fit / distinctive fit, tiebreakers, decision tree, common-confusion guide
- `archetypes/<name>.md` — one file per archetype (12 total, see catalog below)

**`design-tokens-craft/references/`**
- `token-recipes.md` — per-archetype starter recipes in oklch, with adapted values for each of the 12
- `typography-pairings.md` — vetted display/body/mono pairings per archetype, paid + free options
- `banned-palettes.md` — explicit list of vibecoded color/type/spacing patterns to refuse

**`icon-craft/references/`**
- `icon-strategies.md` — 5 strategies (tuned-phosphor, custom-svg, hand-drawn, mixed-metaphor, system-native) + per-archetype default matrix
- `svg-craft.md` — drawing rules (grid, keyline shapes, stroke, corner radius, terminal style, optical sizing, export rules)

**`design-review/references/`**
- `review-rubric.md` — 10-dimension scoring with 0/1/2/3 anchors and SHIP/REVISE thresholds
- `playwright-flow.md` — automated multi-screen capture flow, contrast/font/heading/reduced-motion checks

### 12 curated archetypes

| Archetype | Feels like |
|---|---|
| `b2b-productivity` | Linear, Stripe Dashboard, Vercel |
| `enterprise-trust` | Atlassian, Datadog, Ramp, Brex |
| `premium-consumer` | Apple, Arc, Things 3, Bear |
| `playful-consumer` | Duolingo, Figma, Calm, Mailchimp |
| `editorial` | Substack, Stripe Press, NYT, Are.na |
| `brutalist-distinctive` | Gumroad, Posthog, Vercel labs |
| `dev-tool` | Warp, Raycast, Fly.io, Railway |
| `marketing-landing` | Vercel, Resend, Linear marketing (layered over product archetype) |
| `creative-tool` | Leonardo.ai, Midjourney, Runway, Krea, Suno, Luma |
| `social-feed` | X, Threads, Bluesky, Reddit, Mastodon |
| `conversational-ai` | ChatGPT, Claude, Perplexity, Gemini |
| `spatial-canvas` | FigJam, Miro, tldraw, Whimsical, Excalidraw |

### Library plumbing updates

- `docs/SKILL-INDEX.md` — added 5 entries under Project-Specific Skills with full triggers/output/references; bumped `Last updated` to 2026-04-30
- `AGENTS.md` — added 5 user entry points (`build a frontend`, `pick a design direction`, `design tokens for`, `design icons`, `review this UI`) under "User Entry Points"

---

## Why This Matters

The two existing public reference points for AI frontend skills both leave gaps:

- **Anthropic's `frontend-design`** is a single ~42-line SKILL.md that exhorts taste ("commit to a BOLD aesthetic, avoid AI slop") but provides no operational machinery. It treats "non-vibecoded" as a willpower problem, not a process problem.
- **Julian Oczkowski's 7-skill suite** (grill-me → design-brief → IA → tokens → tasks → frontend → review) provides process, but treats "aesthetic" as a freeform brief question and has no curated archetype catalog or icon-craft layer.

The actual problem of vibecoded UI lives at four levels:

| Level | Failure mode | Where this suite solves it |
|---|---|---|
| **Process** | Vibe-prompting straight to code | `frontend-design` orchestrator with hard gates between archetype, tokens, icons, build, review |
| **Archetype** | One generic aesthetic for every product | `design-archetype` 12-archetype catalog with scoring rubric |
| **Tokens & primitives** | Inter + purple gradient + shadcn cards | `design-tokens-craft` with `banned-palettes.md` as a hard refuse list |
| **Iconography** | Lucide everywhere = mass-produced | `icon-craft` with 5 strategies and SVG craft rules |

Each level cannot be carried in a single ≤200-line skill — hence the family of 5.

---

## Anti-Vibecoded Hard Gates Introduced

These are **banned defaults** unless the chosen archetype explicitly demands them AND a one-line justification is recorded:

**Color:** Tailwind `slate`/`zinc`/`gray` palettes; `blue-600` AI-default; purple→pink and indigo→violet gradients; pure `#000` and `#FFF`; auto-inverted dark mode

**Typography:** Inter as the only font; Inter Display + Inter as a "pairing"; uniform `tracking-tight` on all headings; default Tailwind `font-sans`

**Layout & components:** centered H1 + subhead + 2-CTA hero; 3-col icon-on-top feature grid; `rounded-2xl shadow-md` glass cards; pricing 3-col with "Most Popular" middle; testimonial cards with avatar + quote + name; logo wall above the fold; numbered "How it works" with connecting lines

**Iconography:** Default Lucide / Heroicons drop-in; mixing two icon libraries; uniform icon size; decorative icons next to every heading

**Motion:** `transition-all duration-300` everywhere; `ease-in-out` literal; hover scale 1.05 on cards; spring bounce on every button

**Copy:** "Build [X] in minutes, not [Y]"; "The future of [X] is here"; "Loved by N+ teams worldwide"; Lorem Ipsum in deliverables

A build cannot ship from `frontend-design` until either (a) every banned default is absent, or (b) each present default has a logged archetype-grounded justification. Plus at least one distinctive move from each of typography, color, and layout must be present.

---

## Notable Design Decisions

### Family of 5, not a single fat skill
A single skill cannot operationally carry archetype catalog + token recipes + icon craft + build conventions + review rubric at ≤200 lines. Each of the 5 has a sharp single responsibility. Composability bonus: users can invoke `design-tokens-craft` or `design-review` independently without the full pipeline.

### Archetype as the heart of differentiation
The single biggest lever against vibecoded output is the **archetype catalog itself**. AI models all retrieve roughly the same priors when asked to "design a UI" — Inter, purple gradient, card grid. The catalog forces a named, defensible philosophy that the downstream skills must obey. The 4-archetype expansion was researched with the oracle to fill genuine gaps (creative-tool for AI media studios like Leonardo.ai, social-feed for networked-attention products, conversational-ai for chat-first products like ChatGPT/Claude, spatial-canvas for infinite-canvas tools like FigJam/tldraw).

### Icon-craft as a dedicated skill
The Lucide-everywhere tell is the second-biggest vibecoded marker after Inter-on-purple. No existing skill (Anthropic's, Julian's) treats icons as a first-class concern. This suite gives icons their own skill with 5 strategies and SVG craft rules — including the explicit option to refuse to add icons (sometimes the right answer is "no icons", especially in editorial).

### oklch for color, not hex
Color tokens use `oklch()` color space because perceptual lightness scaling is correct (a "gray-500" looks gray, not vaguely blue). Tokens are semantic (`--surface-primary`, `--text-secondary`), never literal (`--color-blue-500`).

### Dark mode as a separate color story
Tokens hand-set both light and dark per archetype. Auto-inverted lightness is banned by `banned-palettes.md` — every archetype gets a hand-tuned dark recipe (warm dark for premium-consumer; deep cool dark for creative-tool; near-black with cool tint for b2b-productivity).

### Marketing-landing as a layer, not a replacement
Marketing sites for existing products always carry the product's archetype. `marketing-landing` is a *layer* applied over `b2b-productivity` (Linear marketing), `dev-tool` (Vercel marketing), `premium-consumer` (Apple), etc. — not a standalone replacement. This was an explicit design decision to prevent "marketing-landing" from becoming the lazy default.

### Max 2 review loops
`design-review` caps at 2 loops before escalating. If a build hasn't converged after 2 reviews, the upstream archetype was wrong or the brief was contradictory — not the build. This prevents endless polish cycles.

### Playwright-optional review
`design-review` works in two modes: paste-screenshot (manual) or Playwright MCP (automated). Playwright is a force-multiplier (auto-captures full matrix of viewports × modes, computes contrast, verifies font rendering and heading hierarchy) but the skill is fully usable without it.

---

## How to Use

| Trigger phrase | What runs |
|---|---|
| "build a frontend / build a landing page / build a dashboard" | Full pipeline (`frontend-design` orchestrator) |
| "make this feel like Linear / Stripe / Apple / Duolingo" | `design-archetype` direct, then continues |
| "generate design tokens for X" | `design-tokens-craft` direct (requires existing ARCHETYPE.md) |
| "design icons for X" | `icon-craft` direct |
| "review this UI / does this feel like Linear" | `design-review` direct |

Output structure:
```
.design/<feature>/
  ARCHETYPE.md      <- design-archetype
  RESEARCH.md       <- (conditional) visual research
  TOKENS.md         <- design-tokens-craft rationale
  ICONS.md          <- icon-craft strategy
  REVIEW.md         <- design-review verdict + findings
src/
  styles/tokens.css <- generated tokens
  styles/tokens.ts  <- typed exports
  icons/index.tsx   <- icon component set
  ...               <- the build
```

---

## Total Footprint

- **5 new skills** (875 lines of SKILL.md, all ≤200)
- **19 new reference files** (12 archetype philosophies + 7 supporting docs)
- **2 plumbing updates** (SKILL-INDEX.md + AGENTS.md)
- **0 banned defaults shipped** — every recipe in this suite was audited against `banned-palettes.md` before commit
