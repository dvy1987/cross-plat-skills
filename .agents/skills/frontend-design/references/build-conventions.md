# Build Conventions

Practical conventions for the build phase. Framework-agnostic where possible; framework-specific where it matters.

## Mobile-First

- Default styles target the smallest viewport. Add complexity at breakpoints, never remove it.
- Breakpoints: prefer the 4-tier set — `sm: 640`, `md: 768`, `lg: 1024`, `xl: 1280`. Add `2xl` only if archetype specifically demands wide-screen layouts (dashboards, editorial).
- Touch target minimum: 44×44 CSS px. Test at 375px width before any other.

## Dark Mode

- Treat as a distinct color story per the tokens, not as inverted lightness.
- All semantic tokens have light + dark values; component code never branches on mode.
- Test BOTH modes on every screen before review. A UI shipped in only one mode is incomplete.

## Layout

- Use CSS Grid for page-level layout, Flexbox for component-internal alignment.
- Container queries for components that ship into varying contexts (cards, sidebar widgets).
- Max content width should derive from the archetype's reading-line target (45–75ch for editorial, 60–80ch for B2B, no max for dashboard table views).
- Whitespace scale should be log-spaced (4, 8, 12, 16, 24, 32, 48, 64, 96), not linear.

## Motion

- Duration budget per archetype:
  - dev-tool / B2B-productivity: 80–160ms
  - enterprise-trust: 120–240ms
  - editorial / premium-consumer: 200–400ms
  - playful-consumer / brutalist: 400–800ms with character
- Easing: archetype-specific cubic-bezier from tokens, never `ease-in-out` literal.
- `prefers-reduced-motion` MUST shrink durations to ≤0.01ms and disable transforms/parallax. Non-negotiable.

## Accessibility (hard gates)

- Color contrast: 4.5:1 for body, 3:1 for large text and UI controls. Test in BOTH modes.
- All interactive elements reachable by keyboard, with visible focus states matching the archetype.
- Form fields have associated `<label>` (not just placeholder).
- Icons that convey meaning have `aria-label`; decorative icons have `aria-hidden="true"`.
- Heading hierarchy is sequential — no h1→h3 skips.
- Tested with screen reader on at least one critical flow before delivery.

## Framework Conventions

### React / Next.js
- Server components by default; client components only when interactivity demands.
- Tailwind v4 with `@theme` directive sourcing tokens from `tokens.css`.
- Avoid headless UI libraries unless archetype is generic — they smuggle in defaults. Prefer Radix primitives + archetype-styled wrappers.
- No shadcn/ui drop-in. If you must use shadcn as a starter, restyle every component before ship.

### Vue / Nuxt
- `<script setup>`, composition API.
- UnoCSS or Tailwind v4 with token-driven config.
- Avoid Headless UI Vue defaults; restyle.

### Svelte / SvelteKit
- Svelte 5 runes by default.
- Tailwind v4 with archetype tokens.

### Pure HTML/CSS
- Single `tokens.css` with custom properties + a `style.css` that consumes them. No inline styles.
- Use `:has()`, container queries, `@scope`, modern CSS features. Don't write 2018 CSS.

## File Structure

```
src/
  styles/
    tokens.css       <- from design-tokens-craft
    base.css         <- resets + base styles using tokens
  components/
    [archetype-named primitives]
  pages/ or routes/
    [feature pages]
  icons/             <- from icon-craft
    [coherent set]
public/
  fonts/             <- archetype's actual fonts, self-hosted
```

## Performance gates

- LCP ≤ 2.5s on 3G simulation
- CLS ≤ 0.1
- Total JS for landing page ≤ 100KB gzipped before any framework runtime
- Fonts: preload the 1–2 weights you use; subset if non-Latin-1; never load a 9-weight family

## Copy

- No Lorem Ipsum in deliverables.
- If the user has not provided real copy, use plausible domain-specific filler that reads as if written by the product team. Mark it `// COPY-PLACEHOLDER` so it's grep-able.
- Headlines: prefer specificity over abstraction ("Ship a deploy in 47 seconds" > "Fast deploys").

## Anti-Vibecoded Final Sweep

Before declaring done, run through `anti-vibecoded-checklist.md`. Every banned default must be either absent or explicitly justified.

## Handoff to design-review

Provide:
- Live URL or local route to inspect
- Screenshots in light + dark mode at mobile + desktop widths
- The `feels like X` claim from ARCHETYPE.md
- The list of distinctive moves applied
