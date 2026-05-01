# Banned Palettes (vibecoded tells)

If any of these appear in generated tokens without an explicit, archetype-grounded justification, REJECT and regenerate.

## Color tells

- `slate-50` through `slate-950` as the primary grayscale (Tailwind default — instantly recognized)
- `zinc-*` or `gray-*` as primary grayscale (same problem)
- `blue-600` (#2563EB) as the only accent (over-used "AI default")
- `from-purple-500 to-pink-500` gradient or `from-indigo-500 to-violet-500` gradient
- 9-step grayscale dump (50, 100, 200, 300, 400, 500, 600, 700, 800, 900) — most products need 5–7 grays
- Pure black `#000000` background — only acceptable in `brutalist-distinctive`
- Pure white `#FFFFFF` background — only acceptable in `enterprise-trust` and `brutalist-distinctive`
- Identical hex values for "primary" and "brand" tokens (means the system is one-color, not a system)
- Auto-generated dark mode by inverting lightness (must be hand-set per archetype)

## Typography tells

- Inter as the only font on the page (across display + body + mono)
- "Inter Display" + "Inter" as a "pairing" (it's one family — not a real pair)
- Tailwind's `font-sans` left as default in tokens (means no decision was made)
- `tracking-tight` applied uniformly to all headings
- Body line-height 1 (cramped) or > 1.8 (drifty) without editorial justification
- Default font sizes from Tailwind's scale untouched (1rem, 1.125rem, 1.25rem...) when archetype demands a custom scale

## Spacing tells

- Linear spacing scale (4, 8, 12, 16, 20, 24, 28...) — use log-spaced
- 100+ spacing tokens (over-engineered)
- 0 distinct spacing tokens (under-engineered)
- Border-radius scale starting at 4 and ending at `9999px` with no archetype rationale

## Motion tells

- Single `transition-all duration-300` token used everywhere
- `ease-in-out` literal — pick a real cubic-bezier
- 5+ duration tokens (most archetypes need 3–4)
- No `prefers-reduced-motion` token override

## Elevation tells

- 6+ shadow elevations (most archetypes need 0–3)
- Default Tailwind shadows (`shadow-sm`, `shadow-md`, `shadow-lg`) untouched — they're calibrated for one specific aesthetic
- Drop shadows on every card

---

## Audit script (mental checklist)

After generating tokens, scan the output:
1. Any literal `slate-*` / `zinc-*` / `gray-*` hex values? → reject
2. Any `from-purple-* to-pink-*` gradient definition? → reject
3. Is the typography token output using one family for everything? → reject (unless archetype is brutalist-mono)
4. Is the dark mode mathematically inverted? → reject, hand-set
5. Are there 9 grays defined? → trim to 5–7
6. Is there a single duration of 300ms used everywhere? → split per archetype motion budget

If any reject hits, return to Step 4 of the workflow and regenerate the offending section grounded in the archetype recipe.
