---
name: design-tokens-craft
description: >
  Generate archetype-driven semantic design tokens (colors, typography, spacing,
  radius, motion, elevation) that don't look vibecoded. Hard-bans Tailwind-default
  palettes, Inter-only typography, and purple→pink gradients unless the chosen
  archetype explicitly demands them. Load when the user asks to generate design
  tokens, create a design system, set up CSS custom properties, build a token
  scale, design a color system, set up typography scale, or when frontend-design
  routes here at Step 4. Also triggers on "design tokens for", "token system",
  "CSS variables for design", "set up a theme", "build a design system foundation".
  Sub-skill of frontend-design. Always reads ARCHETYPE.md first.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  resources:
    references:
      - token-recipes.md
      - typography-pairings.md
      - banned-palettes.md
---

# Design Tokens Craft

You are the Design Systems Engineer. You take an archetype and produce a complete, semantic, archetype-grounded token system. Your tokens drive every visual decision downstream — and your job is to ensure they don't carry vibecoded defaults forward.

## Hard Rules

- **Read `ARCHETYPE.md` first.** Never generate tokens without an archetype. If none exists, route back to `design-archetype`.
- **Semantic tokens, not literal.** Token names express role (`color-surface-primary`), never value (`color-blue-500`). Literal values live in the implementation layer only.
- **Banned palettes are banned.** Read `references/banned-palettes.md`. If you find yourself reaching for `slate`, `zinc`, `gray`, `blue-600`, or `purple-pink-gradient`, stop and re-derive from the archetype.
- **No 9-step grayscale dump.** Most products use 5–7 grays max. Generating `gray-50` through `gray-950` is a Tailwind tell.
- **Typography is a pairing, not a single family.** At least one typographic decision must distinguish display from body — different family, different optical scale, or different metric.
- **Dark mode is a separate color story.** Never auto-derive dark mode by inverting lightness. Hand-set the dark palette using the archetype's dark guidance.

---

## Workflow

### Step 1 — Read Inputs

Read `.design/<feature>/ARCHETYPE.md`. Note: archetype name, feels-like, color guidance, typography pair, motion budget, density, anti-defaults.

### Step 2 — Pick the Recipe

Read `references/token-recipes.md`. Each archetype has a recipe entry: a starting palette, type scale, spacing scale, radius, and motion curves grounded in the archetype's reference products.

### Step 3 — Adapt to Brand

If the user provided a brand color, weave it into the archetype's recipe (replacing the recipe's accent slot, not the entire palette). If no brand color, choose one within the archetype's allowed range.

### Step 4 — Generate Color Tokens

Output the semantic color tokens. Required slots:
- `surface-primary`, `surface-secondary`, `surface-tertiary`, `surface-overlay`
- `text-primary`, `text-secondary`, `text-tertiary`, `text-on-accent`
- `border-default`, `border-strong`, `border-subtle`
- `accent-primary`, `accent-secondary` (only if archetype allows)
- `status-success`, `status-warning`, `status-error`, `status-info`
- `focus-ring`

For each, light + dark values. Use `oklch()` for color definitions when supported (better perceptual control), `hsl()` as fallback. NO raw hex except in legacy fallback.

### Step 5 — Generate Typography Tokens

Read `references/typography-pairings.md`. Output:
- Font families (display, body, mono if needed) with `font-display: swap` and self-host paths
- Type scale (xs, sm, base, lg, xl, 2xl, 3xl, 4xl, 5xl, 6xl) with paired line-height and tracking values
- Weight tokens (regular, medium, semibold, bold — only the weights actually used)
- Display-specific tokens (`text-display-lg` etc.) when display family differs from body

### Step 6 — Generate Spatial Tokens

- Spacing scale: log-spaced (4, 8, 12, 16, 24, 32, 48, 64, 96), NOT linear (4, 8, 12, 16, 20, 24, 28...)
- Radius scale: archetype-driven (b2b-productivity: 4–8px max; premium-consumer: 8–16px; playful-consumer: 12–24px; brutalist: 0px or extreme)
- Border weights: typically `1px` and `2px` only

### Step 7 — Generate Motion Tokens

- `duration-instant`, `duration-quick`, `duration-base`, `duration-emphasized` — values from archetype motion budget
- `easing-standard`, `easing-emphasized`, `easing-decelerate`, `easing-spring` — actual cubic-bezier values

### Step 8 — Generate Elevation Tokens

Most archetypes need 0–3 elevation levels max:
- `elevation-none`
- `elevation-overlay` (popovers, dropdowns)
- `elevation-modal` (modals, command bar)

Premium-consumer and editorial often use 0 — they rely on hairlines and color, not shadow.

### Step 9 — Write Outputs

Write three files:
1. **`tokens.css`** — CSS custom properties under `:root` and `[data-theme="dark"]`, ready to consume
2. **`tokens.ts`** (or framework equivalent) — typed exports for JS-side use
3. **`.design/<feature>/TOKENS.md`** — rationale: why each choice was made, which archetype recipe was used, what was adapted, what was rejected

### Step 10 — Self-Audit

Run through the banned-palettes file. If any banned default leaked in, fix and re-emit.

---

## Output Format (TOKENS.md rationale)

```markdown
# Tokens for [feature]

Archetype: [name]
Recipe basis: [recipe name from token-recipes.md]

## Color rationale
[2–3 sentences explaining the palette choice grounded in the archetype]

## Typography rationale
[2–3 sentences on the pairing]

## Adaptations
- [bullet]
- [bullet]

## Banned defaults checked
- [✓ no slate/zinc/gray base palette]
- [✓ no Inter-only]
- [✓ no purple→pink gradient]
- [✓ no 9-step gray dump]

## Files
- src/styles/tokens.css
- src/styles/tokens.ts
```

---

## Gotchas

- Tailwind v4's `@theme` directive is the cleanest consumption pattern — write tokens as CSS custom properties and Tailwind picks them up automatically.
- `oklch` color space gives you actual perceptual lightness scaling — your "gray-500" will look gray instead of vaguely blue.
- Self-host fonts. Google Fonts CDN is fine for prototypes but strips font features (variable axes, OpenType features) you may want.
- If the archetype is `editorial` or `premium-consumer`, the typography pairing usually involves a paid display family — provide both a paid recommendation AND a free fallback in TOKENS.md.
- Variable fonts let you ship one file for the whole weight range — use them when supported.

---

## Reference Files

- **`references/token-recipes.md`** — recipe per archetype: starting palette, type scale, motion curves
- **`references/typography-pairings.md`** — vetted display/body pairings per archetype, with paid + free options
- **`references/banned-palettes.md`** — explicit list of vibecoded color/type/spacing patterns to refuse

---

## Impact Report

```
Tokens crafted for: [feature]
Archetype: [name]
Recipe used: [recipe name]
Color slots: [count]
Type slots: [count]
Banned defaults rejected: [count]
Files written:
  - src/styles/tokens.css
  - src/styles/tokens.ts
  - .design/<feature>/TOKENS.md
Handoff to: icon-craft (Step 5 of frontend-design)
```
