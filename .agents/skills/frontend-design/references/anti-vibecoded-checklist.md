# Anti-Vibecoded Checklist

The reason AI-generated UIs all look the same: every model has the same priors. This file lists those priors as **banned defaults** and gives the **distinctive moves** that break out.

## Banned Defaults (require justification + archetype fit before use)

### Typography
- Inter as the only font on the page
- A second weight of the same font masquerading as a typographic pair
- Tailwind's `font-sans` left as default
- All headings same family as body, distinguished only by weight
- `tracking-tight` on every heading reflexively

### Color
- `slate-900` / `gray-950` background with `slate-100` text and one accent
- Purple → pink gradient (`from-purple-500 to-pink-500`)
- Indigo → violet gradient (`from-indigo-500 to-violet-500`)
- "AI Blue" (#0066FF / Tailwind `blue-600`) as primary
- Pure black `#000` and pure white `#FFF` (lazy — almost no real product uses these)
- One accent color used for everything interactive

### Layout & Components
- Hero: centered H1 + subhead + two CTAs side-by-side + small text under
- 3-column feature grid with icon-on-top + h3 + 2-line description
- `rounded-2xl shadow-md bg-white/5 backdrop-blur` glass cards
- Bento grid that's actually just an asymmetric grid with no editorial purpose
- Pricing: 3 columns, middle one "Most Popular", same shape, different price
- Testimonial section with 3 cards each containing avatar + quote + name + company
- Footer with 4 columns of links + newsletter signup + social icons
- "How it works" with 3 steps + numbered circles + connecting lines

### Iconography
- Lucide / Heroicons in default style with no stroke / size / radius tuning
- Same icon size everywhere
- Mixing two icon libraries (one for nav, one for feature cards)
- Decorative icon next to every heading

### Motion
- `transition-all duration-300` on everything
- Stagger fade-in on scroll for every section
- Hover scale of 1.05 on cards
- Spring bounce on button click

### Copy
- "Build [X] in minutes, not [Y]"
- "The future of [X] is here"
- "Loved by [N]+ teams worldwide"
- Lorem Ipsum in a deliverable

If any banned default appears in the build, EITHER:
1. Remove it and use the archetype's prescribed alternative, OR
2. Log a one-line justification in `BUILD-NOTES.md` explaining why this archetype demands this exact move (rare and must be specific — "Linear uses Inter at 13px because their density requires a screen-optimized neutral grotesque" is acceptable, "Inter is fine" is not).

---

## Distinctive Moves (at least ONE must appear in every build)

A UI without at least one distinctive move IS vibecoded by definition.

### Typographic moves
- Editorial pairing (e.g., serif display + grotesque body — Tiempos + Inter, GT Sectra + Söhne)
- Display weight contrast (e.g., 800 display next to 350 body — not 700/400)
- Optical sizing for display vs text (different fonts at different sizes, not same font scaled)
- Mixed-script fallback that respects original glyph proportions
- Hand-set tracking on display headings (negative for serifs at large sizes, positive for caps)

### Color moves
- Off-white background (#FAFAF7, #F8F5EE) instead of pure white
- Off-black text (#1A1A1A, #232323) instead of pure black
- Tertiary accent that appears once per page in a deliberate spot
- Dark mode that's actually a different color story, not just inverted lightness
- Color used as content (status, category, sentiment) rather than decoration

### Layout moves
- Asymmetric grid where the asymmetry has editorial logic
- A signature element that recurs (e.g., a hairline rule treatment, a marginalia column, a sidebar that breathes)
- Breaking the grid intentionally on one element to draw the eye
- Density that matches the archetype (dense for B2B-productivity, generous for premium-consumer)
- Whitespace as a feature, not as padding

### Component moves
- A hero that is NOT centered H1 + subhead + 2 CTAs (e.g., type-only hero, demo-as-hero, table-as-hero, headline-on-the-side)
- Custom-drawn illustrations or domain-specific data viz instead of stock photos / icons
- A signature interaction (Linear's command bar, Stripe's syntax-highlighted code, Arc's pinned tabs)

### Motion moves
- Motion budget under 200ms total per interaction (B2B/dev-tool) OR over 600ms with character (playful-consumer)
- Easing curve specific to the archetype (cubic-bezier values, not `ease-in-out`)
- Motion used to express state, not to decorate

### Icon moves
- Custom SVG icon set (or hand-tuned existing set with documented rules)
- Icons drawn at the size they'll be used (not scaled)
- Icon style that matches the typography (geometric icons with grotesque type, humanist icons with humanist type)

---

## How To Use This File

After Step 6 (Build) in `frontend-design`:
1. Read this file
2. Scan the build for every banned default
3. Either remove or justify each
4. Confirm at least one distinctive move from each of typography, color, and layout is present
5. Block delivery until both conditions are met
