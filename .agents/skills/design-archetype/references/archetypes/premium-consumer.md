# Archetype: premium-consumer

**Feels like:** Apple, Arc, Things 3, Bear, Linear marketing, Tesla, Teenage Engineering

For: consumer products charging premium prices and selling craft. Calm, confident, generous whitespace, almost no decoration. Every detail intentional.

## Typography
- Display: SF Pro Display, GT America, Tiempos Headline (serif option), Söhne Breit, Suisse Int'l. 600–700 weight. Sizes: 40–96px. Tight tracking on display (-0.02 to -0.04em).
- Body: SF Pro Text, GT America, Söhne, Inter at 16–18px / line-height 1.5–1.6.
- Optional small text: 13–14px for captions and metadata.
- Pairing rationale: TWO families used confidently — a display family with character (often a serif or a high-contrast grotesque) and a quiet body grotesque. The display IS the brand voice.

## Color
- Background: off-white `#FAFAF7`, `#F8F5EE`, paper-tones — NEVER pure white. Dark mode: warm dark `#111111`–`#1A1A1A`, often with a hint of warmth, not cool grey.
- Foreground: high contrast, off-black `#1A1A1A`–`#232323`, never pure `#000`.
- Accent: usually ONE color, used sparingly. Often a saturated jewel tone (Things blue, Bear green, Arc's color of the day) OR no accent at all (pure type + photography).
- Anti-defaults: NO Tailwind palette colors out-of-the-box (`slate`, `zinc`, `gray` are dead giveaways). NO purple→pink gradient. NO three-color brand palette.

## Motion
- Duration budget: 200–400ms. The weight matters — motion is felt.
- Easing: `cubic-bezier(0.32, 0.72, 0, 1)` (Apple), or custom curves with overshoot for interactive elements.
- Character: deliberate, weighty, confident. Motion expresses physical material.

## Density
**Generous.** Whitespace is a feature. Rooms for type to breathe. Hero sections often take 80vh+ with one headline and minimal furniture.

## Icon stance
**custom-svg** preferred — bespoke icon set drawn at the exact size used, matched to typography weight. If using existing: Phosphor Light/Thin, hand-drawn linework. Never default Lucide.

## Layout signatures
- Type-only heroes (no illustrations, no demo videos — just confident headline)
- Or photography-as-hero with editorial cropping
- Asymmetric layouts with intentional misalignment that draws the eye
- A signature recurring element (Apple's hairline rules, Things' colored dot, Arc's pinned tab)
- Single-column reading flow on long-form pages (no sidebars unless content demands)
- Edge-to-edge media inside generous container padding (the "full-bleed" punch)

## Reference sites (visit these)
1. **apple.com/macbook-pro** (any product page) — type scale, pacing, photography
2. **arc.net** — color story, hero treatment, motion character
3. **culturedcode.com/things** — craft details, product photography, color use

## Anti-patterns (do NOT do these)
- Stock illustrations (immediately reads as cheap)
- Card grids of features with icons (b2b-productivity move)
- Heavy gradients
- Multiple accent colors fighting for attention
- Saturated full-bleed backgrounds (cheap consumer)
- Fonts with personality fighting each other
- Over-animated entries — premium reads as confident, not theatrical
