# Token Recipes per Archetype

Starter recipes. Each is a defensible default — adapt within the archetype's allowed range, do not jump archetypes.

## b2b-productivity

```css
:root {
  /* surfaces */
  --surface-primary: oklch(99% 0 0);          /* off-white, not pure */
  --surface-secondary: oklch(97% 0 0);
  --surface-tertiary: oklch(95% 0 0);
  /* text */
  --text-primary: oklch(20% 0 0);             /* off-black */
  --text-secondary: oklch(45% 0 0);
  --text-tertiary: oklch(60% 0 0);
  /* accent — pick ONE, not Tailwind blue */
  --accent-primary: oklch(55% 0.22 280);      /* Linear-ish purple OR substitute */
  --focus-ring: oklch(55% 0.22 280 / 0.35);
}
[data-theme="dark"] {
  --surface-primary: oklch(13% 0.005 270);    /* near-black, slight cool */
  --surface-secondary: oklch(16% 0.005 270);
  --surface-tertiary: oklch(20% 0.005 270);
  --text-primary: oklch(95% 0 0);
  --text-secondary: oklch(70% 0 0);
  --text-tertiary: oklch(55% 0 0);
}
```
Spacing: 4, 8, 12, 16, 24, 32, 48, 64. Radius: 4, 6, 8 (max). Motion: 80–160ms, `cubic-bezier(0.16, 1, 0.3, 1)`.

## enterprise-trust

```css
:root {
  --surface-primary: #FFFFFF;
  --surface-secondary: oklch(98% 0.005 240);
  --text-primary: oklch(15% 0.01 240);
  --accent-primary: oklch(45% 0.18 240);      /* deep confident blue */
  --status-success: oklch(55% 0.16 145);
  --status-error: oklch(55% 0.22 25);
  --status-warning: oklch(70% 0.18 75);
}
```
Spacing: 4, 8, 12, 16, 24, 32, 48. Radius: 4, 6, 8. Motion: 120–240ms, `cubic-bezier(0.32, 0.72, 0, 1)`. Elevation 0–2.

## premium-consumer

```css
:root {
  --surface-primary: oklch(98% 0.008 80);     /* warm off-white */
  --surface-secondary: oklch(95% 0.012 80);
  --text-primary: oklch(18% 0.01 60);         /* warm off-black */
  --accent-primary: oklch(50% 0.15 240);      /* one jewel tone */
}
[data-theme="dark"] {
  --surface-primary: oklch(15% 0.012 60);     /* warm dark, not cool */
  --text-primary: oklch(95% 0.005 80);
}
```
Spacing: 4, 8, 12, 16, 24, 32, 48, 64, 96, 128. Radius: 8, 12, 16. Motion: 200–400ms, `cubic-bezier(0.32, 0.72, 0, 1)`.

## playful-consumer

```css
:root {
  --surface-primary: oklch(99% 0.015 70);     /* warm tinted off-white */
  --text-primary: oklch(20% 0.02 30);
  --accent-primary: oklch(70% 0.20 145);      /* characterful */
  --accent-secondary: oklch(75% 0.22 30);     /* warm */
  --accent-tertiary: oklch(70% 0.18 280);     /* cool counterpoint */
}
```
Spacing: 4, 8, 12, 16, 24, 32, 48, 64. Radius: 12, 16, 24. Motion: 400–800ms with springs (`cubic-bezier(0.5, 1.5, 0.5, 1)`).

## editorial

```css
:root {
  --surface-primary: oklch(97% 0.012 85);     /* paper */
  --surface-secondary: oklch(94% 0.015 85);
  --text-primary: oklch(18% 0.01 60);         /* ink */
  --accent-primary: oklch(45% 0.18 25);       /* editorial red OR */
  /* --accent-primary: oklch(40% 0.10 145); */ /* editorial green */
}
```
Spacing: 8, 16, 24, 32, 48, 64, 96, 128. Radius: 0, 2 max (editorial dislikes rounding). Motion: 200–400ms, classical curves.

## brutalist-distinctive

```css
:root {
  --surface-primary: #FFFFFF;                 /* OK here, archetype demands stark */
  --text-primary: #000000;                    /* OK here only */
  --accent-primary: oklch(70% 0.32 350);      /* loud — Gumroad-pink range */
  --border-strong: 2px solid var(--text-primary);
}
```
Spacing: 0, 4, 16, 64 (irregular intentional). Radius: 0 (typically) or extreme (24+). Motion: stepped/linear, deliberate.

## dev-tool

```css
:root {
  --surface-primary: oklch(8% 0.005 240);     /* terminal dark default */
  --surface-secondary: oklch(12% 0.005 240);
  --text-primary: oklch(92% 0.005 80);
  --accent-primary: oklch(75% 0.22 145);      /* phosphor green OR */
  /* --accent-primary: oklch(70% 0.20 30); */  /* amber */
}
[data-theme="light"] {
  --surface-primary: oklch(99% 0 0);
  --text-primary: oklch(15% 0 0);
}
```
Spacing: 4, 8, 12, 16, 24, 32. Radius: 4, 6 max. Motion: 60–140ms, linear or `cubic-bezier(0.4, 0, 0.6, 1)`.

## creative-tool

```css
:root {
  /* dark-first */
  --surface-primary: oklch(11% 0.01 280);     /* deep cool dark */
  --surface-secondary: oklch(15% 0.01 280);
  --surface-tertiary: oklch(19% 0.01 280);
  --text-primary: oklch(96% 0.005 80);
  --text-secondary: oklch(70% 0.005 80);
  --accent-primary: oklch(60% 0.25 285);      /* brand wash — Leonardo-ish purple */
  --accent-gradient-from: oklch(60% 0.25 285);
  --accent-gradient-to: oklch(70% 0.22 320);  /* gradient is CORRECT here */
}
[data-theme="light"] {
  --surface-primary: oklch(99% 0.003 280);
  --text-primary: oklch(15% 0.005 280);
}
```
Spacing: 4, 8, 12, 16, 24, 32, 48 (chrome dense; canvas breathes via layout). Radius: 6, 8, 12 for media tiles. Motion: 120–280ms, smooth + a separate reveal curve for newly-generated media.

## social-feed

```css
:root {
  --surface-primary: oklch(13% 0.005 250);    /* near-black, slight cool */
  --surface-secondary: oklch(16% 0.005 250);
  --text-primary: oklch(96% 0.005 250);
  --accent-primary: oklch(70% 0.22 220);      /* engagement signal — used SPARINGLY */
}
[data-theme="light"] {
  --surface-primary: oklch(99% 0.002 250);
  --surface-secondary: oklch(97% 0.003 250);
  --text-primary: oklch(15% 0.005 250);
}
```
Spacing: 4, 8, 12, 16, 20, 24 (tight — feed throughput matters). Radius: 0, 4, 999 (avatars only). Motion: 80–180ms with spring micro-celebrations on engagement.

## conversational-ai

```css
:root {
  --surface-primary: oklch(99% 0 0);          /* clean light default */
  --surface-secondary: oklch(97% 0 0);
  --text-primary: oklch(18% 0 0);
  --accent-primary: oklch(50% 0.15 240);      /* quiet — used only on send/active */
  --reading-column: 75ch;                     /* reading is the experience */
}
[data-theme="dark"] {
  --surface-primary: oklch(20% 0.005 60);     /* warm dark, easier sustained reading */
  --surface-secondary: oklch(24% 0.005 60);
  --text-primary: oklch(95% 0.005 80);
}
```
Spacing: 4, 8, 12, 16, 24, 32, 48. Radius: 8, 12 (composer + buttons), 4 (inline elements). Motion: 80–200ms chrome; streaming response is its own category.

## spatial-canvas

```css
:root {
  /* canvas is light-first — users live there, often projecting */
  --surface-canvas: oklch(98% 0.012 80);      /* paper canvas */
  --surface-chrome: oklch(99% 0 0);           /* white chrome */
  --text-primary: oklch(15% 0.005 60);
  /* multi-color object palette — REQUIRED for this archetype */
  --object-yellow: oklch(85% 0.15 90);
  --object-pink: oklch(75% 0.20 0);
  --object-blue: oklch(75% 0.15 230);
  --object-green: oklch(75% 0.15 145);
  --object-purple: oklch(70% 0.18 295);
  --object-orange: oklch(75% 0.18 50);
  --accent-primary: oklch(45% 0.20 250);      /* selection halo / connector active */
}
```
Spacing: 4, 8, 12, 16 (chrome) — canvas is user-controlled. Radius: 4, 8 chrome; object radii vary. Motion: 80–200ms chrome; canvas pan/zoom is real-time 60fps with inertial physics.

## marketing-landing

Inherits base recipe from product archetype. ADD:
- one signature accent treatment per page (a wash, a gradient if the archetype allows, a saturated section)
- larger type scale (display goes up to 6xl/7xl for hero)
- one theatrical motion moment allowed per page

---

## How to use

1. Pick the recipe matching the archetype
2. Replace `--accent-primary` with the user's brand color if provided, kept within the archetype's allowed hue range
3. Generate the full token file using the recipe as the seed, expanding to all required slots
4. Validate against `banned-palettes.md`
