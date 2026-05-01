# Typography Pairings per Archetype

Vetted pairings. Each pairing has a paid recommendation (the real signature) and a free fallback. Self-host both.

## b2b-productivity

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature | Söhne (Klim) | Söhne | Söhne Mono |
| Strong free | Inter Display | Inter Variable | JetBrains Mono |
| Modern free | Geist | Geist | Geist Mono |

Pair rule: same family OR matched grotesque + matched mono. Display weight 600–700 with -0.02em tracking. Body 400/500 at 13–14px / 1.45.

## enterprise-trust

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature | Söhne / Aktiv Grotesk | Söhne / Aktiv | SF Mono |
| Strong free | Inter | Inter | IBM Plex Mono |

Pair rule: confident grotesque, no theatrical display. Display 600 at conservative tracking. Body 400/500 at 14–15px / 1.5.

## premium-consumer

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature, serif-led | Tiempos Headline (Klim) | Söhne | — |
| Paid signature, sans-led | GT America Display | GT America Standard | — |
| Strong free, serif-led | Source Serif Pro | Inter | — |
| Strong free, sans-led | General Sans | Inter | — |

Pair rule: TWO families confidently used. Display has character, body is quiet. Display 600–700, -0.02 to -0.04em tracking.

## playful-consumer

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature | GT Maru | Söhne | — |
| Paid signature alt | Sharp Grotesk | Inter | — |
| Strong free | Migra (TWG) | Inter Rounded | — |
| Strong free alt | Pangea | DM Sans | — |

Pair rule: characterful display + warm friendly body. Display 700–900 at large sizes. Body 15–17px / 1.55.

## editorial

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature, serif/serif | Tiempos Headline | Tiempos Text | — |
| Paid signature, serif/sans | GT Sectra | Söhne | — |
| Strong free, serif/serif | Source Serif Pro | Source Serif Pro | — |
| Strong free, serif/sans | Lora | Inter | — |

Pair rule: explicit display/text pairing — NEVER one font for both. Body line-height 1.6–1.8. Reading column 60–75ch.

## brutalist-distinctive

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature, mono-led | Berkeley Mono | Berkeley Mono | Berkeley Mono |
| Paid signature, slab/grotesque | GT Pressura | Söhne | — |
| Strong free, mono | JetBrains Mono | JetBrains Mono | JetBrains Mono |
| Strong free, slab | Roboto Slab | Inter | — |

Pair rule: type IS the position. Mono-only is a strong move. Slab + plain grotesque is the secondary move.

## dev-tool

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature | Berkeley Mono + Söhne | Söhne | Berkeley Mono |
| Strong free, modern | Geist Sans | Geist Sans | Geist Mono |
| Strong free, classic | Inter | Inter | JetBrains Mono |

Pair rule: matched sans + mono with shared metrics. Mono used liberally for code, paths, IDs. Body 13–15px.

## creative-tool

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature | GT America Display | GT America Standard | GT America Mono |
| Strong free | Geist Sans | Geist Sans | Geist Mono |
| Strong free alt | Inter Display | Inter Variable | JetBrains Mono |

Pair rule: clean grotesque body so the *output* — not the chrome — carries personality. Display restrained; brand wash in color does the identity work. Body 13–15px / 1.45 to fit parameter density.

## social-feed

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature | Söhne | Söhne | Söhne Mono (rare) |
| Strong free | Inter Variable | Inter Variable | JetBrains Mono |

Pair rule: type is invisible. Identity comes from posts, avatars, media — not from chrome typography. Body 14–16px / 1.4–1.5. NEVER lead with display.

## conversational-ai

| Tier | Display | Body | Mono |
|---|---|---|---|
| Paid signature, sans-led | Söhne | Söhne | Söhne Mono |
| Paid signature, serif-led | — | Charter / Source Serif | JetBrains Mono |
| Strong free, sans-led | Inter | Inter | JetBrains Mono |
| Strong free, serif-led | — | Source Serif Pro | Geist Mono |

Pair rule: optimize for reading generated text. Body 15–17px / line-height 1.6. Mono is REQUIRED — code blocks are first-class content. Reading column 60–80ch.

## spatial-canvas

| Tier | Chrome | Canvas-object option | Mono |
|---|---|---|---|
| Paid signature | Söhne | Caveat / hand-drawn paid | — |
| Strong free | Inter | Excalifont / Virgil / Caveat | JetBrains Mono |

Pair rule: chrome type is invisible (Inter / Söhne at 13–14px). The optional hand-drawn font for canvas objects is the signature — it signals "rough thinking" and lowers the bar for ideation. Provide both options to users.

## marketing-landing

Inherits product archetype pairing. Marketing-specific moves:
- Display sizes scale up to 6xl/7xl (96–128px) on hero
- Body 16–18px (larger than product UI)
- Variable axes can be exploited for marketing-only display moments

---

## How to use

1. Pick the row matching the archetype + budget
2. Self-host both fonts in `public/fonts/`
3. Set `font-display: swap`, preload the 1–2 weights actually used
4. Subset to the script range needed
5. Variable fonts where available — one file for the whole weight range
