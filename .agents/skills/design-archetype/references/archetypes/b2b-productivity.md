# Archetype: b2b-productivity

**Feels like:** Linear, Stripe Dashboard, Vercel, Notion (modern), Height

For: dense workflow apps where power users live for hours. Speed > delight. Information density > whitespace luxury.

## Typography
- Display: Inter Display 700 / 600 at 28–48px tight tracking (-0.02em). Acceptable swaps: Söhne, GT America, Söhne Mono for code displays.
- Body: Inter Variable 400/500 at 13–14px / line-height 1.45. The 13px body is the signature — most consumer products go 16px; B2B-productivity goes 13–14 because users live in tables and lists.
- Mono: JetBrains Mono, IBM Plex Mono, or Söhne Mono for inline code, IDs, timestamps.
- Pairing rationale: a single grotesque family at multiple weights, plus a paired mono. No serif. The neutrality of grotesque is the point — type should be invisible, the data should sing.

## Color
- Background: near-black `#0A0A0A`–`#111114` (dark) / off-white `#FAFAFA`–`#F8F8F8` (light). NEVER pure black or pure white.
- Foreground: ~92% contrast on background. Hairlines and dividers in 6–10% on dark / 4–6% on light.
- Accent: ONE saturated accent (Linear purple, Stripe purple, Vercel cyan-ish white) used sparingly — primary CTA, current selection, focus ring. Maybe a second muted accent for status (success/error/warning) but those should feel system-native, not branded.
- Anti-defaults: NO purple→pink gradient, NO blue-600 as accent (over-used), NO `slate-*` palette by default — pick a color story with character.

## Motion
- Duration budget: 80–160ms. Anything over 200ms feels sluggish for power users.
- Easing: `cubic-bezier(0.4, 0, 0.2, 1)` (material standard) or `cubic-bezier(0.16, 1, 0.3, 1)` (Linear-style smooth).
- Character: restrained. Motion confirms causality, never decorates.

## Density
**Dense.** Tables show 30+ rows without scrolling on a 13" laptop. Sidebar items 28–32px tall. Nav items, buttons, inputs all 28–36px. Generous whitespace is a sin.

## Icon stance
**tuned-phosphor** at light or regular weight, 14–16px, OR custom SVG set in matching stroke (1.5px). Lucide is acceptable IF stroke is tuned to 1.5px and corners hand-adjusted. NEVER mix icon libraries.

## Layout signatures
- Persistent left sidebar with collapsible sections; top header is thin or absent
- Tables with hairline dividers, NOT card-shaped rows
- Cmd-K command bar as primary navigation pattern
- Status pills with subtle color, never saturated
- "Empty states" treated as designed first-class screens
- Content is left-aligned, never centered (centering is a hero-page move)

## Reference sites (visit these)
1. **linear.app** — study sidebar density, table treatment, Cmd-K
2. **dashboard.stripe.com** (or stripe.com/payments product pages) — color as data, status pills, tabular layouts
3. **vercel.com/dashboard** (or product pages) — typography, motion budget, dark mode story

## Anti-patterns (do NOT do these)
- Hero-page styling on internal screens (centered headline, illustration, big CTA)
- Card grid for showing list data — use a table
- Drop shadows on data containers
- Saturated brand color on every interactive element
- "Friendly" empty-state illustrations with cartoonish characters
- Animations longer than 200ms
- Emoji as icons
