# Playwright MCP Flow

Automated multi-screen capture flow for design-review. Optional — if Playwright MCP is unavailable, fall back to paste-screenshot mode.

## Prerequisites

- Playwright MCP server installed and connected
- Local dev server running (`http://localhost:3000` typical) OR a deployed preview URL

## Capture matrix

For each route to review, capture:

| Viewport | Mode | Note |
|---|---|---|
| 375×812 (iPhone) | light | mobile portrait |
| 375×812 (iPhone) | dark | mobile portrait dark |
| 768×1024 (iPad) | light | tablet portrait |
| 1280×800 (laptop) | light | desktop |
| 1280×800 (laptop) | dark | desktop dark |
| 1920×1080 (HD) | light | wide desktop, only if archetype is dashboard or marketing |

Save to `.design/<feature>/screenshots/<route>--<viewport>--<mode>.png`.

## Capture flow

1. Navigate to the route
2. Set viewport
3. Set color scheme (`page.emulateMedia({ colorScheme: 'dark' })`)
4. Wait for fonts to load (`document.fonts.ready`)
5. Wait for animations to settle (300ms after navigation)
6. Capture full-page screenshot

## Per-route checks (automated)

For each captured screenshot, also pull:
- Computed contrast on key text/background pairs (use page.evaluate to read DOM and compute)
- Font families actually rendered (verify they match TOKENS.md)
- Existence of `<meta name="viewport">` and `<meta name="theme-color">`
- Heading hierarchy (read all `h1-h6` and verify sequence)
- Image alt-text presence
- Focus state visibility (tab through, capture each focus)

## Reduced-motion check

- Set `page.emulateMedia({ reducedMotion: 'reduce' })`
- Re-navigate and verify durations shrink (read `getComputedStyle().transitionDuration`)
- Verify no transforms / parallax remain

## Output

Write to `.design/<feature>/AUTOMATED-AUDIT.md`:

```markdown
# Automated audit — [feature]

## Routes captured
- /  → 5 screenshots
- /pricing → 5 screenshots
- /docs → 5 screenshots

## Computed contrast (sample)
| Pair | Ratio | Meets 4.5:1? |
|---|---|---|
| body on surface-primary (light) | 12.3:1 | ✓ |
| body on surface-primary (dark) | 14.1:1 | ✓ |
| text-secondary on surface-secondary (light) | 4.8:1 | ✓ |
| ... | | |

## Font rendering verification
- Display: GT Sectra (matches TOKENS.md ✓)
- Body: Inter Variable (matches TOKENS.md ✓)

## Heading hierarchy
- /: h1 → h2 → h2 → h3 ✓
- /pricing: h1 → h2 → h3 → h4 → h2 ✓
- /docs: h1 → h3 ⚠ (skipped h2)

## Reduced-motion
- Durations shrunk to ≤0.01ms: ✓
- Transforms disabled: ✓
```

## Returning to the review

The `design-review` SKILL reads `AUTOMATED-AUDIT.md` and the screenshots together with `ARCHETYPE.md` to score. Automated findings feed Accessibility and Responsive dimensions; visual review still required for archetype fidelity.

## Fallback when Playwright is unavailable

Instruct the user:
1. Run dev server
2. Open each route in light + dark mode
3. Use browser devtools to set viewport (375, 768, 1280)
4. Take a full-page screenshot of each
5. Paste into chat OR save under `.design/<feature>/screenshots/`

Then proceed with manual review using the same rubric.
