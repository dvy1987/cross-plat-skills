# Review Rubric

Scoring 0–3 per dimension. Anchors below.

## Archetype fidelity

- **0** — does not feel like the claimed reference at all; reads as a different archetype
- **1** — partial fit; some right moves, but key signature elements missing
- **2** — recognizable as the archetype; most signature moves present
- **3** — feels indistinguishable in spirit from the reference; signature moves all present and intentional

## Anti-vibecoded gates

- **0** — multiple banned defaults present (Inter-only + Tailwind grays + purple gradient + Lucide drop-in)
- **1** — 1–2 banned defaults present without justification
- **2** — no banned defaults; at least one distinctive move present
- **3** — no banned defaults; multiple distinctive moves present (typography + color + layout)

## Typography

- **0** — single font for everything OR mismatched pairing OR Tailwind defaults left untouched
- **1** — pairing exists but hierarchy is unclear, or tracking / line-height not archetype-correct
- **2** — pairing executed correctly, hierarchy clear, tracking and line-height archetype-correct
- **3** — typography is the strongest element of the build; pairing and rhythm carry the brand voice

## Color

- **0** — hex literals in components, banned palettes present, dark mode is inverted lightness
- **1** — tokens used inconsistently, OR dark mode partially executed
- **2** — all colors via tokens, dark mode is a separate hand-set story
- **3** — color story is distinctive, used as content where appropriate, contrast quietly excellent

## Iconography

- **0** — Lucide drop-in default OR mixed icon libraries OR icons don't match type weight
- **1** — single library used but not tuned to type weight, sizes inconsistent
- **2** — coherent set, matched to type, consistent sizes; bespoke or properly-tuned
- **3** — icons are a signature element; clearly bespoke or perfectly tuned; carries brand identity

## Layout & rhythm

- **0** — generic 3-col feature grid + centered hero + cards-everywhere
- **1** — some structure present but rhythm is uneven, density doesn't match archetype
- **2** — grid logic clear, spacing log-spaced, density matches archetype
- **3** — layout has a signature move (asymmetry, recurring marginalia, archetype-specific)

## Motion

- **0** — `transition-all duration-300` everywhere, no easing variation, no reduced-motion support
- **1** — motion exists but doesn't follow archetype budget; reduced-motion present but partial
- **2** — duration budget matches archetype; easing curve is archetype-specific; reduced-motion fully honored
- **3** — motion expresses state and confirms causality; one signature motion moment present

## Accessibility (HARD GATE — pass/fail)

PASS requires ALL of:
- Color contrast 4.5:1 body / 3:1 UI in BOTH modes
- Keyboard reachable for every interactive element
- Visible focus state on every interactive element
- Heading hierarchy sequential
- Form fields have associated `<label>`
- Icons that convey meaning have `aria-label`
- `prefers-reduced-motion` shrinks durations to ≤0.01ms

FAIL on any of the above. No partial credit.

## Responsive

- **0** — broken at 375px width; horizontal scroll; content cut
- **1** — works at 375px but layout is awkward; some sections need work
- **2** — clean at 375px, 768px, 1024px, 1280px; container queries where appropriate
- **3** — responsive design carries information density appropriate to viewport (not just shrunk)

## Distinctive moves

- **0** — zero distinctive moves; UI is generic
- **1** — one distinctive move present
- **2** — distinctive moves in two of {typography, color, layout}
- **3** — distinctive moves in three+ areas; the UI has identifiable character

---

## Verdict thresholds

- **SHIP** requires:
  - Accessibility = PASS
  - Archetype fidelity ≥ 2
  - Anti-vibecoded ≥ 2
  - All other dimensions ≥ 2
  - Distinctive moves ≥ 2

- **REVISE** = anything below the SHIP bar.

If REVISE: top 8 findings drive the next build loop.
