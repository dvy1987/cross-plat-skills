# Archetype: creative-tool

**Feels like:** Leonardo.ai, Midjourney (web), Runway, Krea, Civitai, Suno, Luma, Ideogram, ElevenLabs Studio, Pika, Higgsfield

For: AI media studios and prosumer creative tools where the user's *output* (image, video, audio, model) is the primary content. Gallery-as-canvas. Dark-first because generated media reads better on dark.

## Typography
- Display: Inter Display, Geist, Söhne, GT America at 32–64px. Often paired with a custom display moment for brand identity (Midjourney's serif, Runway's geometric grotesque).
- Body: Inter Variable / Geist / Söhne 13–15px / 1.45. Closer to b2b-productivity density than premium-consumer airiness — there are sliders and parameters to fit.
- Mono: JetBrains Mono / Geist Mono for prompt strings, seeds, model IDs.
- Pairing rationale: clean grotesque body so the *output* — not the chrome — carries personality.

## Color
- Background: dark-first `#0A0A0F`–`#101015`, often with a slight cool tint or a deep brand wash. Light mode is a real secondary, not first-class.
- Foreground: high contrast off-white.
- Accent: this archetype is the rare one where **a saturated brand gradient is correct** — Midjourney electric-blue, Leonardo purple, Runway green, Krea magenta. Used as identity wash, hero treatment, and primary CTA.
- Anti-defaults: NO Tailwind grays (still); NO purple→pink unless that IS the brand (Leonardo); NO white-default (kills the gallery).

## Motion
- Duration budget: 120–280ms. Slightly slower than dev-tool because previewing media has weight; faster than premium-consumer because creators iterate fast.
- Easing: `cubic-bezier(0.16, 1, 0.3, 1)` smooth, with a separate reveal curve for newly-generated media (slight lift + fade-in).
- Character: confident, generation-aware. Loading/progress states are first-class — they happen constantly.

## Density
**Dense** in the chrome, **generous** in the canvas. Tool sidebars cram parameters; canvas/gallery breathes around the media. The split is the signature.

## Icon stance
**custom-svg** at 14–18px OR Phosphor Light/Regular tuned to match. Iconography often supports a slight brand character (rounded versus geometric). Lucide-default still banned.

## Layout signatures
- Persistent left rail = navigation/library; right rail = parameters/inspector; center = canvas/gallery
- Image/video grid as primary content surface — masonry, fixed-aspect, or swipeable cards (this is the right answer here, NOT a vibecoded tell)
- Prompt composer as a sticky surface (bottom bar or top of canvas)
- Generation history / job queue as a first-class UI element
- Model picker / preset chips above or beside the prompt
- Public community gallery often a peer surface to the studio
- Output-first marketing — landing leads with generations, not feature copy

## Reference sites (visit these)
1. **leonardo.ai** — gallery-as-home, dense parameter rail, brand gradient as identity
2. **runwayml.com** — studio chrome, video-first canvas, model picker treatment
3. **midjourney.com** (web app) — feed-first, prompt composer dominance, grid pacing

## Anti-patterns (do NOT do these)
- Hiding the output below feature copy / chrome / nav
- Light-mode-first (kills perceived contrast on generated media)
- B2B-productivity table treatment (wrong density for media browsing)
- Premium-consumer whitespace (suffocates parameter density)
- Generic stock illustrations on marketing (the product makes images — show them)
- Refusing the brand gradient when the archetype invites one
- Friendly mascots and cartoon onboarding (creators want power, not coddling)
