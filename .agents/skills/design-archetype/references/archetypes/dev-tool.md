# Archetype: dev-tool

**Feels like:** Warp, Raycast, Fly.io, Railway, Anthropic Console, Modal, Replicate, Cursor

For: CLIs with web UIs, terminals, dev infrastructure, IDE-adjacent tools. Audience is developers who notice when the type rendering is wrong.

## Typography
- Display: Mono-forward or grotesque-mono pair — JetBrains Mono Display, Berkeley Mono, IBM Plex Sans, Söhne Mono, Geist Sans + Geist Mono, Inter + JetBrains Mono.
- Body: Inter / Geist / Söhne at 13–15px. Mono used liberally for code, paths, IDs.
- Mono: ALWAYS — this is the archetype where mono is a primary, not a secondary.
- Pairing rationale: a clean grotesque + a mono companion that share metrics (so they sit beside each other gracefully). Geist Sans + Geist Mono is the canonical pairing.

## Color
- Background: terminal-dark `#0A0A0A`–`#0E0E10` (dark default — dev tools default to dark). Light mode is a secondary `#FAFAFA`–`#F8F8F8`.
- Foreground: high contrast monospace-friendly.
- Accent: ONE saturated terminal-y color — green like a phosphor, electric blue, magenta, amber. Often syntax-highlighting palette is the brand palette.
- Anti-defaults: NO purple→pink, NO Tailwind defaults, NO branded blue.

## Motion
- Duration budget: 60–140ms. Snappy. Anything slower feels like the tool is broken.
- Easing: linear or `cubic-bezier(0.4, 0, 0.6, 1)` — mechanical, not bouncy.
- Character: minimal. Loading states are the most visible motion (and should be precise — 12fps not smooth).

## Density
**Dense.** Code-window density. Lists with tight rows. Long log streams.

## Icon stance
**custom-svg** at 14–16px with 1.25–1.5px strokes, OR Phosphor Light, OR Lucide tuned to lighter strokes. Geometric, sharp. Matches the mono type.

## Layout signatures
- Code blocks with syntax highlighting that match the brand palette
- Live-updating logs / output streams as a first-class UI element
- Cmd-K command bar (mandatory)
- Keyboard shortcut hints visible everywhere (kbd-styled)
- Status indicators with single-character glyphs (●, →, ↗)
- Documentation feels native to the tool (not a separate site)
- Terminal-style cursor/selection states where possible

## Reference sites (visit these)
1. **warp.dev** — terminal as design surface, type, color palette
2. **fly.io** — dense developer marketing with character
3. **railway.app** — modern dev infra with strong type/color story

## Anti-patterns (do NOT do these)
- "Friendly" copy ("Welcome! Let's get you started 🎉") — devs hate it
- Hero illustrations of generic tech (clouds, gears, abstract shapes)
- Onboarding modals with progress dots — devs want a CLI quickstart
- Slow animations
- Light mode as default (most devs default to dark — light is fallback)
- Big rounded corners on inputs (10px+ feels consumer-y; 4–6px feels right)
- Generic iconography
