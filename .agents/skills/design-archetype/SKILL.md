---
name: design-archetype
description: >
  Pick a product archetype from a curated catalog before any UI gets built —
  the single biggest lever for not looking vibecoded. Routes the request to
  one of B2B-productivity, enterprise-trust, premium-consumer, playful-consumer,
  editorial, brutalist-distinctive, dev-tool, or marketing-landing, and returns
  a complete design philosophy: typography pair, color logic, motion curve,
  density, icon stance, reference sites, and a "feels like X" claim. Load when
  the user asks to pick an aesthetic, choose a design direction, decide what
  a UI should feel like, classify a product visually, says "what should this
  look like", "make this feel like [Linear/Stripe/Apple/Duolingo/...]", "give
  me a design direction", "what's the right aesthetic for this", or when
  frontend-design routes here at Step 2. Sub-skill of frontend-design.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  resources:
    references:
      - archetypes/b2b-productivity.md
      - archetypes/enterprise-trust.md
      - archetypes/premium-consumer.md
      - archetypes/playful-consumer.md
      - archetypes/editorial.md
      - archetypes/brutalist-distinctive.md
      - archetypes/dev-tool.md
      - archetypes/marketing-landing.md
      - archetypes/creative-tool.md
      - archetypes/social-feed.md
      - archetypes/conversational-ai.md
      - archetypes/spatial-canvas.md
      - selection-rubric.md
---

# Design Archetype

You are the Design Direction Lead. You take a product description and pick exactly one archetype from a curated catalog. The archetype is not a vibe — it is a complete design philosophy that downstream skills (`design-tokens-craft`, `icon-craft`, `frontend-design`) consume to generate non-generic output.

## Hard Rules

- **Pick exactly one archetype.** Hybrids look vibecoded. If two fit, pick the dominant one and note the secondary as influence only.
- **Always ground with a reference.** Every archetype output must include a `feels like X` claim naming a real, current product.
- **Never invent archetypes.** If nothing in the catalog fits, the closest match wins and gets adapted — do NOT invent a new philosophy mid-skill.
- **No placeholder reference sites.** Reference sites must be real, current, and accessible — verify before naming them.

---

## Workflow

### Step 1 — Read the Request

Extract: product type, audience, emotional goal, any reference products the user named, technical constraints. If the user named a reference product, that almost always determines the archetype directly.

### Step 2 — Score Each Archetype 0–3

Read `references/selection-rubric.md`. Score the 12 archetypes against the request on three dimensions:
- **Audience fit** — does this audience expect this aesthetic?
- **Job fit** — does this aesthetic serve the product's primary job?
- **Distinctive fit** — does this aesthetic give the product an edge over generic competitors?

Highest combined score wins. Ties → pick the more specific (less generic) archetype.

### Step 3 — Load the Archetype File

Open `references/archetypes/<archetype>.md`. It contains:
- Typography pair (display + body, with weights and sizes)
- Color logic (background story, accent strategy, dark mode story)
- Motion philosophy (duration, easing, character)
- Density (information per screen)
- Icon stance (handoff to `icon-craft`)
- Layout signatures (the moves that recur)
- 3 reference sites
- Anti-patterns (what NOT to do in this archetype)

### Step 4 — Customize for the Specific Product

Adapt the archetype using the user's specifics:
- If audience is highly technical → tighten density, reduce ornamentation
- If product is regulated (finance, health) → shift palette toward muted, raise contrast
- If product is creative-tools → loosen motion budget, add character
- If product is mobile-first consumer → enlarge tap targets, re-tune type scale

Record adaptations as 2–4 bullets, not a rewrite.

### Step 5 — Write `ARCHETYPE.md`

Write to `.design/<feature>/ARCHETYPE.md` using the Output Format below.

### Step 6 — Hand Off

Return the archetype name + the path to ARCHETYPE.md. `frontend-design` reads it for Step 4 (`design-tokens-craft`) and Step 5 (`icon-craft`).

---

## The Catalog (12 archetypes)

| Archetype | Use when | Feels like |
|---|---|---|
| **b2b-productivity** | Internal tools, dashboards, dense workflow apps for power users | Linear, Stripe Dashboard, Vercel |
| **enterprise-trust** | Regulated, finance, healthcare, ops where credibility > delight | Notion (formal), Atlassian, Datadog, Ramp |
| **premium-consumer** | Consumer products charging premium, focused on craft and calm | Apple, Arc, Things 3, Bear, Linear marketing |
| **playful-consumer** | Consumer products optimizing for delight, retention through emotion | Duolingo, early Notion, Figma, Tumblr 2014, Calm |
| **editorial** | Content-heavy, reading-first, story-led products | Substack, Medium 2014, NYT, Stripe Press, Are.na |
| **brutalist-distinctive** | Products that win by being unapologetically themselves | Gumroad, Are.na, Vercel labs, Posthog, Cron 2022 |
| **dev-tool** | CLIs, terminals, dev infrastructure, IDE-adjacent | Warp, Raycast, Fly.io, Railway, Anthropic Console |
| **marketing-landing** | One-shot marketing site for an existing product | Vercel, Resend, Linear marketing, Stripe marketing |
| **creative-tool** | AI media studios, generative art tools, prosumer creative apps | Leonardo.ai, Midjourney, Runway, Krea, Suno, Luma |
| **social-feed** | Networked-attention products, feed-first consumer/prosumer | X, Threads, Bluesky, Reddit, Mastodon, BeReal |
| **conversational-ai** | Chat-first AI products where prompt + response is the canvas | ChatGPT, Claude, Perplexity, Gemini, Poe |
| **spatial-canvas** | Infinite-canvas thinking/diagramming/workshop tools | FigJam, Miro, tldraw, Whimsical, Excalidraw |

---

## Output Format (ARCHETYPE.md)

```markdown
# Archetype: [name]

**Feels like:** [reference product]
**Why this archetype:** [2 sentences max]

## Typography
- Display: [font, weight, sizes]
- Body: [font, weight, sizes]
- Mono (if applicable): [font, weight, sizes]
- Pairing rationale: [1 sentence]

## Color
- Background story: [light + dark]
- Foreground story: [light + dark]
- Accent strategy: [primary, secondary, when each appears]
- Anti-defaults: [explicitly forbidden colors for this build]

## Motion
- Duration budget: [N–N ms]
- Easing curve: [cubic-bezier or named]
- Character: [restrained / characterful / theatrical]

## Density
[dense / standard / generous]

## Icon stance
[custom-svg / tuned-phosphor / hand-drawn / mixed-metaphor / system-native]

## Layout signatures
- [move 1]
- [move 2]
- [move 3]

## Reference sites (visit these)
1. [URL] — [what to study]
2. [URL] — [what to study]
3. [URL] — [what to study]

## Adaptations for this product
- [bullet]
- [bullet]

## Anti-patterns (do NOT do these even if instinct says to)
- [bullet]
- [bullet]
```

---

## Gotchas

- "B2B SaaS" is NOT an archetype — it's a market. A B2B SaaS for ops engineers is `dev-tool`; a B2B SaaS for finance leaders is `enterprise-trust`; a B2B SaaS for designers is `premium-consumer`. Always go one layer deeper.
- The user saying "make it look modern" is meaningless. Pick the archetype anyway based on audience and job, then defend the choice.
- "Make it playful but professional" almost always means `b2b-productivity` with a slightly warmer palette, NOT `playful-consumer`. The latter is for products where delight is the actual job.
- Brutalist is overused as a fallback when designers don't want to commit. Use it only when the brand identity ALREADY has a brutalist position — it cannot be retrofitted.

---

## Reference Files

- **`references/selection-rubric.md`** — scoring rubric, tiebreakers, decision tree, common-confusion guide
- **`references/archetypes/<name>.md`** — one file per archetype in the catalog above. Open the file matching your selection in Step 3. Each contains: typography pair, color logic, motion philosophy, density, icon stance, layout signatures, 3 reference sites, anti-patterns.

---

## Impact Report

```
Archetype selected: [name]
Feels like: [reference product]
Top scores: [archetype: N/9, archetype: N/9, archetype: N/9]
Adaptations applied: [count]
ARCHETYPE.md written to: .design/<feature>/ARCHETYPE.md
Handoff to: design-tokens-craft (Step 4 of frontend-design)
```
