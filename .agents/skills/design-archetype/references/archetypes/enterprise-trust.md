# Archetype: enterprise-trust

**Feels like:** Atlassian, Datadog, Ramp, Notion (formal contexts), Brex, Workday (modern)

For: regulated industries, finance, healthcare, ops, compliance — where credibility, clarity, and "no surprises" matter more than delight or distinctive personality.

## Typography
- Display: Söhne 600 / Inter Display 600 / Aktiv Grotesk 600 at 24–40px. Conservative tracking (0 to -0.01em). Avoid theatrical display weights.
- Body: Inter / Söhne / Aktiv Grotesk 400/500 at 14–15px / line-height 1.5. Slightly larger than b2b-productivity — readability over density.
- Mono: SF Mono, Söhne Mono — used sparingly for IDs, timestamps, currency where alignment matters.
- Pairing rationale: one trustworthy grotesque family at multiple weights. No serif (serifs read as editorial/luxury, not enterprise). No display fonts with character — they erode credibility.

## Color
- Background: white `#FFFFFF` or near-white `#FCFCFD`–`#F8F9FA` (light); dark mode is `#101114`–`#16181D` with cooler undertone than b2b-productivity.
- Foreground: high contrast (90%+). Dividers and hairlines visible but quiet.
- Accent: ONE branded primary, often a confident blue, deep green, or navy. Avoid magenta/pink/yellow as primary. Status colors are system-native (red for error, green for success, amber for warning) and used clearly.
- Anti-defaults: NO pure black, NO purple→pink gradients (frivolous), NO neon greens (low trust), NO playful pastels.

## Motion
- Duration budget: 120–240ms.
- Easing: `cubic-bezier(0.32, 0.72, 0, 1)` (Apple-style confident) or material standard.
- Character: confident and quiet. Motion smooths transitions; never draws attention to itself.

## Density
**Standard.** More breathing room than b2b-productivity but still data-forward. Tables 36–44px row height. Forms with proper field spacing (16–20px between fields, never crammed).

## Icon stance
**tuned-phosphor** at regular weight 16–20px, OR a paid premium icon set (Sargent, Iconoir Pro). Heroicons solid variant is acceptable if tuned. Icons should feel quiet and authoritative, never cute.

## Layout signatures
- Top navigation with clear hierarchy (primary nav, secondary contextual nav, breadcrumbs)
- Data tables with sortable columns, sticky headers, pagination — like real data tools
- Forms broken into clear sections with section headers
- Status indicators are pill-shaped or dot-prefixed text, never just color
- Cards used for grouping related controls, not for visual decoration
- Generous use of disabled/loading/error states — every state explicitly designed

## Reference sites (visit these)
1. **ramp.com** (product screens) — modern enterprise that doesn't feel sterile
2. **datadoghq.com/product** — dense data, still readable, uses color as data
3. **atlassian.design** — design system that documents enterprise patterns

## Anti-patterns (do NOT do these)
- Hero gradients (frivolous in this context)
- Animated illustrations on dashboards (looks consumer)
- Casual copy ("Yay! Your invoice synced!") — keep tone professional but warm
- Hidden/secondary nav for primary actions
- Skeumorphic or glassmorphic UI (low trust signals)
- Brand logo too prominently in the product chrome
