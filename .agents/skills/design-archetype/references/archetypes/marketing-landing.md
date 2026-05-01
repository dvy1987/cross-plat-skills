# Archetype: marketing-landing

**Feels like:** Vercel, Resend, Linear (marketing site), Stripe (marketing), Framer, Liveblocks

For: a marketing site for an existing product. The job is conversion, but the product's underlying archetype must still show through — marketing-landing is a *layer*, not a replacement.

## Important: this archetype is a layer

Always pair with the product's underlying archetype:
- Marketing for a B2B-productivity product → marketing-landing × b2b-productivity
- Marketing for a premium consumer product → marketing-landing × premium-consumer
- Marketing for a dev-tool → marketing-landing × dev-tool

The pairing determines type, color, motion. THIS file specifies the marketing-specific moves on top.

## Typography
- Display: bigger and more confident than the product itself — display sizes 64–128px on hero. The marketing site can shout where the product whispers.
- Body: 16–18px (larger than product UI which might use 13–14px) — marketing reading is not data scanning.

## Color
- Inherits the product archetype palette but uses it more saturated and confident — marketing can use the brand color in larger washes than the product UI does.
- Hero may use a signature color treatment (Vercel's geometric grid, Resend's gradient mark, Linear's purple wash) that doesn't appear inside the product.

## Motion
- Duration budget: matches the product archetype, but marketing can have ONE theatrical moment per page (a hero animation, a scroll-driven product reveal, a signature motion).
- Easing: archetype-appropriate.

## Density
**Generous.** Marketing pages breathe. One idea per scroll-section, large headlines, 60–90vh sections.

## Icon stance
Same as product archetype, scaled up and used sparingly. Decorative icons are rare in good marketing — replaced with product screenshots, custom illustration, or domain-specific data viz.

## Layout signatures (marketing-specific)
- A hero that is NOT centered H1 + subhead + 2 CTAs (look at Vercel, Linear, Resend — none of them do that anymore)
- Live product preview embedded in hero (not a screenshot — interactive demo)
- Logo wall with care (sized down, monochromatic, positioned to support not boast)
- Feature sections that USE the product to show the product (a section about the editor IS an editor, etc.)
- Code snippets for dev-tools, real data examples for B2B
- Pricing as a designed page, not a 3-column comparison default
- Footer with sitemap-as-design, not link soup

## Reference sites (visit these)
1. **vercel.com** — modern marketing benchmark; geometric hero, density on feature pages, type confidence
2. **resend.com** — small-team craft; hero treatment, motion, copy voice
3. **linear.app** (marketing site, NOT the product) — hero, scroll choreography, signature gradient

## Anti-patterns (do NOT do these)
- Centered hero with "Build [X] in minutes" headline + 2 CTAs side-by-side
- 3-column feature grid with icon + h3 + 2 lines of generic copy
- "Trusted by 1000+ teams" logo wall above the fold
- Testimonial carousel with avatars and quotes
- Pricing where middle column is "Most Popular" with a colored border
- "How it works" with three numbered steps and connecting lines
- CTA repeated 6+ times with the same wording

## Marketing-specific gates

The marketing landing must answer in the first 2 viewports:
1. Who is this for (audience clarity)
2. What does it do (specifically, with a real artifact — screenshot, demo, code, data)
3. What's distinctive about it (what makes it not a generic competitor)

If those three aren't answered visually + verbally in the first 2 viewports, the page is failing its job.
