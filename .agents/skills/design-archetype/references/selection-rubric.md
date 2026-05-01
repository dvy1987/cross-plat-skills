# Archetype Selection Rubric

Score each candidate archetype 0–3 on each dimension. Sum. Highest wins.

## Dimensions

### 1. Audience fit (0–3)
Does the target audience expect or respond to this aesthetic?
- 0 — wrong audience entirely (e.g., playful-consumer for procurement officers)
- 1 — adjacent audience, would tolerate
- 2 — target audience expects this
- 3 — target audience strongly identifies with products in this archetype

### 2. Job fit (0–3)
Does this aesthetic serve the product's primary job?
- 0 — actively hostile to the job (e.g., editorial density on a power-user dashboard)
- 1 — neutral to the job
- 2 — supports the job
- 3 — the aesthetic IS part of the job (e.g., premium-consumer for a meditation app — the calm IS the product)

### 3. Distinctive fit (0–3)
Does this give the product an edge against generic competitors?
- 0 — every competitor uses this archetype (race to the bottom)
- 1 — most competitors use this
- 2 — minority of competitors use this — gives differentiation
- 3 — almost no one in the category uses this — strong distinctive position

## Tiebreakers

If two archetypes tie on score:
1. Pick the more **specific** archetype (e.g., `dev-tool` over `b2b-productivity` for a CLI dashboard)
2. Pick the archetype with the **stronger anti-pattern list** (more things it forbids = more shape, less generic)
3. Pick the archetype the user's reference product is in (if they named one)
4. Pick the archetype that gives a higher Distinctive Fit score

## Quick decision tree

- User said "feels like [product]" → archetype of that product, done
- Primary metaphor is **conversation** (chat-in / response-out, prompt is the hero) → `conversational-ai`
- Primary content surface is the **user's generated media** (image/video/audio gallery, parameter rails) → `creative-tool`
- Primary surface is an **infinite canvas** with pan/zoom/object placement → `spatial-canvas`
- Primary surface is a **feed** of posts from many people → `social-feed`
- Audience is developers → start with `dev-tool`, demote to `b2b-productivity` only if non-technical users matter equally
- Audience is regulated industry decision-makers → `enterprise-trust`
- Product charges >$50/mo to consumers OR brand is craft-led → `premium-consumer`
- Product needs daily-habit retention through emotion → `playful-consumer`
- Product is content-led, reading is the experience → `editorial`
- Product has an existing brutalist brand identity → `brutalist-distinctive`
- Asset is a marketing site for an already-built product → `marketing-landing` (layered over the product's archetype)
- Anything else → `b2b-productivity` is the most defensible default

## Distinguishing the four new ones (common confusions)

- `creative-tool` vs `b2b-productivity`: in creative-tool, **the user's output IS the content**; gallery grids are correct, tables are wrong. In b2b-productivity, the user's WORK is the content; tables are correct, galleries are wrong.
- `creative-tool` vs `spatial-canvas`: creative-tool produces media (rendered, fixed-aspect); spatial-canvas produces structured thought (objects on a plane). FigJam is canvas; Midjourney is creative-tool. Tldraw is canvas; Krea is creative-tool.
- `conversational-ai` vs `dev-tool`: even when devs use it, conversational-ai's metaphor is conversation, not terminal. ChatGPT is conversational-ai. Anthropic Console (chat surface) is conversational-ai. The CLI side of Claude Code is dev-tool.
- `social-feed` vs `editorial`: social-feed optimizes for rapid scan/react/post; editorial optimizes for immersive reading. A blogging platform is editorial; a microblogging platform is social-feed.

## Anti-patterns in selection

- Picking `brutalist-distinctive` because you can't decide — it's a strong commitment, not a fallback
- Picking `premium-consumer` for a B2B tool because "premium" sounds nice — it likely fights the job
- Picking `playful-consumer` for finance/health/security — it erodes trust
- Picking `editorial` for transactional flows — slows the user down
- Hybridizing two archetypes — picks one, makes both look weak
