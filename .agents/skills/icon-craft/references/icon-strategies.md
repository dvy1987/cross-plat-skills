# Icon Strategies

The five viable strategies and when to use each.

## 1. tuned-phosphor (or tuned-existing)

**What:** Pick Phosphor (or another high-quality icon family) at ONE weight, normalize stroke + size to match the typography, hand-adjust outliers.

**Use when:**
- b2b-productivity, enterprise-trust, dev-tool
- Time/budget for bespoke is limited
- The product needs 20+ icons (custom-svg cost grows linearly)

**Phosphor weights map:**
| Weight | Pair with |
|---|---|
| Thin (1px stroke) | Light or thin display type |
| Light (1.25px) | Regular grotesque body |
| Regular (1.5px) | Default for most archetypes |
| Bold (2px) | Bold display, playful archetypes |
| Fill (solid) | Playful-consumer, marketing accent moments |
| Duotone | Specific archetypes only — easy to overuse |

**Banned:** Default Lucide drop-in (stroke 2px, default 24px size, default corner radius). Acceptable only if every icon is hand-tuned.

## 2. custom-svg

**What:** Draw a bespoke icon set on a defined grid with documented stroke, radius, terminal style.

**Use when:**
- premium-consumer (almost always)
- The product has 8–20 signature icons that recur frequently
- Brand identity demands a unique visual mark

**Cost:** Roughly 1 hour per simple icon, more for complex. Set of 12 = a half-day commitment.

**Worth it because:** Custom icons are the single fastest way to make a UI not look AI-generated.

## 3. hand-drawn

**What:** Hand-drawn (or hand-drawn-feeling) marks — sketchy strokes, slight imperfection, often imported from real ink.

**Use when:**
- editorial — when icons are needed at all
- Specific brand identities (illustration-led products)
- Marketing moments where icons need warmth

**Caution:** Reads as twee or unprofessional in B2B contexts. Don't use for nav/action icons in productivity tools.

## 4. mixed-metaphor

**What:** System glyphs (✶ ✻ → ↗ ● ◆), ASCII marks, emoji where defensible, simple shapes used as decoration. NOT a drawn icon set.

**Use when:**
- brutalist-distinctive
- Markdown-native interfaces
- When the product wants to refuse the "icon language" entirely

**Examples:** Posthog uses ASCII art. Are.na uses geometric glyphs. Old-school terminals use unicode block elements.

## 5. system-native

**What:** SF Symbols (Apple), Material Symbols (Google), Fluent (Microsoft).

**Use when:**
- The product targets ONE platform exclusively (iOS-only, Material-Web-only)
- Brand IS the platform (Apple ecosystem feel)

**Caution:** Cross-platform products using SF Symbols on the web look "Apple-derivative" in a bad way unless the rest of the design is committed to that lineage.

---

## Decision matrix by archetype

| Archetype | Default | When to escalate to custom-svg |
|---|---|---|
| b2b-productivity | tuned-phosphor light | Brand wants strong signature mark |
| enterprise-trust | tuned-phosphor regular | Rare — usually unnecessary |
| premium-consumer | **custom-svg** | Always |
| playful-consumer | custom-svg with personality OR Phosphor Bold/Fill | If brand is character-led |
| editorial | hand-drawn or none | If the editorial voice demands signature marks |
| brutalist-distinctive | mixed-metaphor / system glyphs | Rare — drawn icons soften the position |
| dev-tool | tuned-phosphor light | If brand has a strong terminal-glyph identity |
| marketing-landing | inherits product | When marketing has bespoke moments product doesn't |
| creative-tool | custom-svg or tuned-phosphor regular | When brand has a strong studio identity (Runway, Leonardo) |
| social-feed | custom-svg (action rail icons MUST be hand-tuned) | Always — these are the most-seen icons in the product |
| conversational-ai | custom-svg or tuned-phosphor light/regular | When the small icon set (10–20) deserves bespoke quality |
| spatial-canvas | custom-svg with mild character + mixed-metaphor for shapes/connectors | Always — toolbar icons drive the entire interaction |

---

## When to refuse to add icons

Some "we need icons here" instincts are wrong:
- Headings rarely need icons (kills hierarchy)
- Body text never needs icons (clutters reading)
- Features in marketing pages often work better with type + screenshot than with icon + h3 + paragraph
- Empty states often work better with type + a single character glyph than with an illustration

Push back on icon proliferation.
