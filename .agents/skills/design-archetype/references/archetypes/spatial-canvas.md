# Archetype: spatial-canvas

**Feels like:** FigJam, Miro, tldraw, Whimsical, Milanote, Excalidraw, Mural

For: products where space IS the interface — infinite canvas, pan/zoom, loose object placement. The job is externalizing thought into visible structure: workshops, ideation, diagramming, mapping, planning.

## Typography
- Display: minimal in the canvas itself; type lives in objects users create. UI chrome uses a grotesque (Inter, Söhne, system-ui) at 13–14px.
- Body: 13–14px in chrome. Inside canvas objects, hand-letter feel or hand-drawn fonts (Excalifont, Virgil) often signal "rough thinking".
- Mono: optional, for code-feeling objects.
- Pairing rationale: chrome is invisible; canvas objects can have personality. The hand-drawn-feel font option is the signature for ideation tools.

## Color
- Background: light cream / off-white `#FAFAF7`–`#F5F2EC` (default canvas) or pure-ish white. Dark mode is supported but most users work in light because they're projecting / sharing screens.
- Foreground: off-black for chrome.
- Accent: a multi-color object palette is mandatory — sticky notes in 6–10 hues, connector colors, highlight colors. This is the rare archetype where multi-color is correct.
- Anti-defaults: NO single-accent austerity. NO Tailwind grays for the canvas.

## Motion
- Duration budget: 80–200ms for chrome; canvas pan/zoom is real-time and continuous (60fps), not discrete.
- Easing: smooth for chrome; physics-based for canvas (inertial pan, smooth zoom toward cursor).
- Character: presence motion is signature — live cursors with nameplates, selection halos that pulse, smooth multi-user object manipulation. Motion is functional, not decorative.

## Density
**Variable.** Chrome is dense (toolbars, inspectors); canvas is generous and user-controlled.

## Icon stance
**custom-svg** at 16–20px with a slightly playful character. Object-creation icons (sticky note, shape, connector, image, frame) live in a primary toolbar and are the most-used elements. **mixed-metaphor** acceptable for shape/connector glyphs.

## Layout signatures
- **Infinite canvas as the product** — pan, zoom, minimap optional, loose spatial grouping
- **Floating tool chrome** — toolbar, inspector, quick-add detach from page layout edges; often appears near selected objects
- **Object-first selection model** — click selects, drag moves, handles resize, snap-on-hover
- **Presence everywhere** — live cursors with nameplates, selection halos, comment threads pinned to coordinates
- **Connector / arrow primitives** — first-class objects, not decorations
- **Sticky-note language** — hue picker, font sizing inline, casual tone implied
- **Frame / section objects** — group canvas regions for export, presentation mode, scoping
- **Comment + reaction surfaces** anchored to objects
- **Export/present mode** that hides chrome and follows a predetermined path through the canvas

## Reference sites (visit these)
1. **tldraw.com** — open-source spatial canvas, canonical chrome treatment, hand-drawn feel
2. **figma.com/figjam** — workshop-grade canvas, sticky note palette, presence model
3. **excalidraw.com** — minimal hand-drawn ideation canvas, exemplary restraint

## Anti-patterns (do NOT do these)
- Page-bound layout / fixed nav (kills the infinite-canvas mental model)
- Dense data tables (this is not a workflow tool)
- Single-accent austerity in canvas object colors
- Premium-consumer whitespace inside chrome (toolbars need to be tight)
- Hidden zoom level / hidden minimap on large canvases
- Saving / autosave UI hidden — collaborative canvas users need explicit save state
- Modal interruptions during drawing/placement
- Treating the canvas like a slide deck (linear) — it's spatial
