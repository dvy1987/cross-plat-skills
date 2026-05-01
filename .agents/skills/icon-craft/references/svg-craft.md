# SVG Craft Rules

For when you're drawing custom icons, not picking from a library.

## Grid

- 24×24px is the default grid for nav/action icons
- 16×16px for dense (b2b-productivity tables, dev-tool inline)
- 32×32 / 48×48 for marketing/feature display icons

Within the grid:
- 2px keyline padding on all sides (icon lives in 20×20 of 24×24)
- Snap all anchor points to half-pixel grid for crisp 1× rendering
- Optical balance > geometric center — visually-heavy icons (squares, fills) sit slightly higher than text-baseline

## Keyline shapes

Pick 3–4 keyline shapes the family will share:
- **Circle** — for circular bounds (avatar, planet, dot)
- **Square** — for rectangular bounds (file, image, card)
- **Vertical rect** — for tall things (document, person)
- **Horizontal rect** — for wide things (envelope, banner)

Every icon should sit cleanly inside one of these keyline shapes for visual consistency.

## Stroke

- **Thin** 1px — only at 24px+ display sizes
- **Light** 1.25px — premium-consumer, dev-tool default
- **Regular** 1.5px — most products' default
- **Bold** 2px — playful-consumer, brutalist
- Stroke is uniform across the icon family — never mix
- Stroke linecap: `round` (soft) or `butt` (sharp) — pick one and stick
- Stroke linejoin: `round` or `miter` — pick one and stick

## Corner radius

- 0px (sharp) — brutalist, dev-tool terminal feel
- 1–2px (subtle warmth) — b2b-productivity, enterprise-trust
- 4px (gentle) — premium-consumer
- 6–8px+ (friendly) — playful-consumer

## Terminal style (line endings)

- Round caps + round joins — friendly, modern, default
- Butt caps + miter joins — geometric, technical, brutalist
- Mixed — almost never works

## Optical sizing

- Icons drawn for 24px should NOT be scaled to 16px — strokes get crowded
- For multi-size systems, hand-draw separate versions at each size
- Some glyphs need optical compensation: a square at 24px may need ~22px width to look balanced next to a circle of nominal 24px

## Counter-spaces (negative space inside icons)

- Watch for overly thin counters at small sizes — they fill in
- Consistent counter weight across the family is more important than consistent stroke

## Output format

Each icon should:
- Be a single `<svg>` with `viewBox="0 0 24 24"` (or appropriate)
- Use `currentColor` for stroke/fill so it inherits text color
- Strip metadata, comments, editor cruft (run through SVGO)
- Total file size ≤ 800 bytes per icon
- Have a meaningful filename: `chevron-right.svg`, NOT `Path-1.svg`

Example minimal output:
```svg
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 6l6 6-6 6"/>
</svg>
```

## Component wrappers

Wrap each SVG as a typed component that accepts `size` and `className`:

```tsx
export function ChevronRight({ size = 16, className }: IconProps) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.5} strokeLinecap="round" strokeLinejoin="round" className={className} aria-hidden="true">
      <path d="M9 6l6 6-6 6"/>
    </svg>
  );
}
```

## Quality checks

Before shipping a custom set, verify:
- [ ] All icons share grid, keyline, stroke, radius, terminal style
- [ ] All icons render crisply at 1× and 2×
- [ ] All icons read at the smallest size used
- [ ] All icons sit visually on the same baseline as adjacent text
- [ ] No icon needs >2 paths (most should be 1 path)
- [ ] Filenames are semantic, not numeric
- [ ] SVG output is minified, `currentColor`-driven, under 800 bytes each
