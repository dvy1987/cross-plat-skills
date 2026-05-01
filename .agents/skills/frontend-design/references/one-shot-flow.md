# One-Shot Flow

For single artifacts where the full pipeline is overkill: a poster, a single component in isolation, an isolated landing page, a marketing email template, a single dashboard widget.

## When to use

- Asset is single-screen and single-purpose
- No design system to integrate with
- Iteration cycle is "show me one good version" not "build a product"
- Time budget is < 30 minutes of work

## Compressed steps

### 1. Pick archetype in 30 seconds

Look at the user's request. Pick from `design-archetype`'s catalog without invoking the full skill. If the user named a reference product, use its archetype.

Record the choice as a single line at the top of the artifact:
```
<!-- archetype: editorial · feels like Vercel changelog · 2026-04-30 -->
```

### 2. Inline tokens

Skip a separate tokens file. Define a small token set inline in CSS custom properties at the top of the artifact, drawn from the archetype's recipe. Keep it minimal: 2 colors, 2 fonts, 4 spacing values, 1 radius, 1 motion curve.

### 3. Icons

If the artifact needs ≤4 icons, hand-draw them as inline SVG. If more, pick a single coherent source (Phosphor at one weight, or one Lucide variant) and tune stroke/size to the archetype.

### 4. Build with one distinctive move

A one-shot artifact must still have a distinctive move. Pick one from each:
- Typography pairing (not Inter alone)
- A non-default color choice (off-white, archetype-specific accent)
- A layout move (asymmetric, type-only hero, signature element)

### 5. Self-review

Before declaring done, scan against `anti-vibecoded-checklist.md`. One pass. Fix anything that's a banned default with no justification.

## Skip these

- Visual research step
- Separate `design-tokens-craft` invocation
- Separate `icon-craft` invocation
- `design-review` Playwright loop (do a single screenshot self-review instead)

## Don't skip these

- The archetype choice (even informal)
- The distinctive move requirement
- The anti-vibecoded scan
