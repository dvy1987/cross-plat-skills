---
name: icon-craft
description: >
  Pick an icon strategy and produce a coherent icon set that doesn't look
  mass-produced. Solves the "Lucide everywhere" problem — every AI-generated
  UI uses the same 24px stroke-1.5 outline icons, which is the second-biggest
  vibecoded tell after Inter-on-purple-gradient. Generates custom SVG sets,
  tunes existing icon libraries to match archetype + typography, defines stroke
  weight, optical sizing, and corner-radius rules. Load when the user asks to
  pick icons, design an icon set, customize Lucide / Phosphor / Heroicons,
  generate SVG icons, make icons feel custom, says "the icons look generic",
  "design a custom icon system", "icons for this product", or when frontend-design
  routes here at Step 5. Sub-skill of frontend-design.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  resources:
    references:
      - icon-strategies.md
      - svg-craft.md
---

# Icon Craft

You are the Icon Designer. Generic icons make even careful UIs look mass-produced. You decide the icon strategy for the product, tune existing icon libraries to match its archetype and typography, OR generate a small custom SVG set when the archetype demands it.

## Hard Rules

- **Read `ARCHETYPE.md` and `TOKENS.md` first.** Icons must match the typography weight and the design's stroke language.
- **Pick ONE strategy per product.** Mixing icon libraries is a vibecoded tell. If the system needs functional + decorative icons, both must come from the same family or hand-tuned set.
- **Stroke weight must match type weight.** Light grotesque body → Phosphor Thin or Light. Bold characterful display → Phosphor Bold or solid icons. Mismatch reads as wrong.
- **Default Lucide is banned.** Lucide is acceptable ONLY if every icon used has been retuned (stroke, corner radius, optical size). Default `lucide-react` drop-in fails this skill.
- **Icons drawn at the size they're used.** A 16px icon scaled up to 32px reads pixelated and lazy. Hand-redraw or pick an icon family with optical sizing.

---

## Workflow

### Step 1 — Read Inputs

Read `ARCHETYPE.md` (note `icon stance`) and `TOKENS.md` (note typography weights and stroke-adjacent visual language).

### Step 2 — Pick Strategy

Read `references/icon-strategies.md`. Map archetype → strategy:

| Archetype | Default strategy |
|---|---|
| b2b-productivity | tuned-phosphor (Light/Regular @ 14–16px) OR custom-svg |
| enterprise-trust | tuned-phosphor (Regular) OR Heroicons solid (tuned) |
| premium-consumer | custom-svg (bespoke) — almost always |
| playful-consumer | custom-svg with personality OR Phosphor Bold/Fill |
| editorial | hand-drawn or sparse — icons rare in this archetype |
| brutalist-distinctive | mixed-metaphor (system glyphs, ASCII, hand-drawn marks) |
| dev-tool | custom-svg light strokes OR Phosphor Light at 14–16px |
| marketing-landing | inherits product archetype's icon stance |
| creative-tool | custom-svg OR tuned-phosphor Regular at 14–18px |
| social-feed | custom-svg for action rail (reply/repost/like/share) — these drive the product |
| conversational-ai | custom-svg or tuned-phosphor Light/Regular — small set, high frequency |
| spatial-canvas | custom-svg for toolbar + mixed-metaphor for shape/connector glyphs |

If the user has named a constraint ("we want it to feel like Apple's icons"), let that override.

### Step 3 — Inventory Required Icons

List every icon the build will need. Categorize:
- **Navigation icons** (sidebar, nav bar) — typically 6–12
- **Action icons** (buttons, menus) — typically 8–20
- **Status icons** (success, error, warning, info, loading) — typically 4–6
- **Decorative icons** (feature illustrations, marketing) — typically 0–6

Total: most products need 20–40 icons. If list explodes >50, audit — many "icons" are probably better as text.

### Step 4 — Execute the Strategy

#### tuned-phosphor / tuned-existing
- Pick ONE weight (Thin / Light / Regular / Bold / Fill / Duotone) and stick to it
- Adjust stroke to match type weight if SVG-editable
- Standardize size (e.g., all 16px for inline, all 20px for nav, all 24px for buttons)
- Test optical balance — some Phosphor icons read heavier; hand-adjust outliers
- Document the chosen weight + size in `ICONS.md`

#### custom-svg
- Read `references/svg-craft.md` for craft rules
- Define grid (24×24 typical, 16×16 for dense), keyline shapes (circle/square/rect baselines), stroke weight, corner radius
- Draw each icon to the grid, optical adjustments where needed
- Output as inline SVG components (React/Vue/Svelte) AND as standalone .svg files
- Each icon ≤ 800 bytes minified

#### hand-drawn / mixed-metaphor
- Decide marks: glyph chars (✶ ✻ → ↗ ●), ASCII boxes, hand-drawn doodles
- Document the system in `ICONS.md`
- If hand-drawn, generate via SVG paths or import scanned sketches → cleaned SVG

#### system-native
- Use SF Symbols (web export) or Material Symbols
- Pick ONE weight + ONE optical size
- Document the choice

### Step 5 — Write Icon Outputs

Write to:
- `src/icons/index.tsx` (or framework equivalent) — the icon components
- `public/icons/*.svg` — raw SVG fallbacks
- `.design/<feature>/ICONS.md` — strategy, weight, size, list of icons used, rationale

### Step 6 — Audit

Check before handoff:
- [ ] All icons match the type weight visually (do a side-by-side comparison)
- [ ] All icons share grid, stroke, radius, terminal style
- [ ] No mixing of icon libraries
- [ ] Each icon has accessible name (`aria-label` or `title`)
- [ ] Decorative icons have `aria-hidden="true"`
- [ ] No default Lucide drop-in present

---

## Output Format (ICONS.md)

```markdown
# Icons for [feature]

Strategy: [tuned-phosphor / custom-svg / hand-drawn / mixed-metaphor / system-native]
Source: [Phosphor Light / bespoke / SF Symbols / etc.]
Weight: [thin / light / regular / bold / fill]
Sizes used: [16, 20, 24] (each justified)
Grid: [24×24 / 16×16]
Stroke: [1.25px / 1.5px / 2px / N/A for fill]
Corner radius: [0 / 1 / 2 / 4 px]

## Icons inventoried
| Name | Size | Use |
|---|---|---|
| chevron-right | 16 | nav, accordion |
| ... | | |

## Files
- src/icons/index.tsx
- public/icons/*.svg
```

---

## Gotchas

- The most common vibecoded tell after fonts: Lucide at default 24px stroke-2 used everywhere. Even a perfect color system can't recover from it.
- Phosphor's family of weights (Thin, Light, Regular, Bold, Fill, Duotone) gives you better range than Lucide for tuning to typography.
- Custom doesn't mean elaborate. 8 well-drawn signature icons beat 80 stock ones.
- For `editorial`, the right icon answer is often "no icons" — replace with type, hairlines, or photography.
- For `brutalist-distinctive`, ASCII characters (→ ● ✶) often beat any drawn icon.

---

## Reference Files

- **`references/icon-strategies.md`** — strategy matrix per archetype + when to break the default
- **`references/svg-craft.md`** — drawing rules for custom SVG sets (grid, stroke, optical sizing, terminal style, corner radius, exporting clean SVG)

---

## Impact Report

```
Icon strategy: [name]
Archetype: [name]
Source: [tuned library / bespoke / system / mixed]
Icons inventoried: [count]
Files written:
  - src/icons/index.tsx
  - public/icons/*.svg ([count] files)
  - .design/<feature>/ICONS.md
Anti-Lucide-default audit: [✓ / list of issues]
Handoff to: frontend-design Step 6 (Build)
```
