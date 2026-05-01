# Archetype: conversational-ai

**Feels like:** ChatGPT, Claude, Perplexity, Gemini, Poe, T3 Chat, Anthropic Console (chat surfaces)

For: products where the primary metaphor is *conversation* — open-ended turn-based interaction, a prompt surface as the dominant UI, responses that become working documents.

## Typography
- Display: rare — conversational-AI products don't lead with display type. Body type at slightly larger sizes (16–18px) does most of the work.
- Body: highly readable grotesque OR humanist serif. Inter, Söhne, Sohne, Charter, or Source Serif at 15–17px / line-height 1.6. Reading long generated responses is the experience.
- Mono: REQUIRED — code blocks are first-class content, not edge cases. JetBrains Mono / Geist Mono / SF Mono.
- Pairing rationale: optimized for *reading generated text* — line-height generous, line-length controlled, hierarchy clear so headers and lists in responses scan well.

## Color
- Background: typically near-white in light mode (`#FFFFFF`–`#FAFAFA`) and warm dark in dark (`#1A1A1A`–`#212121`). The chrome is quiet; the conversation is the canvas.
- Foreground: high contrast for sustained reading.
- Accent: ONE quiet accent for primary CTA (Send, the model selector active state). Often absent from the response body entirely.
- Anti-defaults: NO Tailwind grays. NO purple-pink gradient as identity. The discipline is restraint — let the content speak.

## Motion
- Duration budget: 80–200ms for chrome; streaming response motion is its own category (token-by-token reveal at the model's natural rate).
- Easing: smooth, restrained. `cubic-bezier(0.32, 0.72, 0, 1)`.
- Character: nearly absent. Streaming text and "thinking" indicators are the only signature motion.

## Density
**Generous reading, dense chrome.** Conversation column is reading-optimized (60–80ch). Sidebar history, model picker, and tool affordances live in tight rails.

## Icon stance
**custom-svg** or **tuned-phosphor** Regular/Light at 16–18px. Icon set is small (10–20 icons) but high-frequency: send, attach, microphone, model picker, copy, regenerate, edit, branch, share. Quality matters — these are seen constantly.

## Layout signatures
- **Prompt box is the hero** — oversized composer, often anchored bottom or centered, with tool/model affordances attached (attach, model picker, web search toggle, deep-think toggle)
- **Response as working document** — chunked, source-linked, expandable, with regenerate/edit/copy on hover
- **Side-by-side artifact canvas** — when responses produce code/docs/files, a second pane opens (Claude artifacts, ChatGPT canvas, Perplexity Pages)
- **Left rail thread history** — collapsible, search, organize, pin
- **Starter prompt cards on empty state** — replace the blank-page problem
- **Model selector visible** — never buried; users care which model is responding
- **Streaming response indicators** — token cursor, thinking pulse, or word-by-word reveal
- **Copy / cite / branch / regenerate affordances** on every response

## Reference sites (visit these)
1. **claude.ai** — restrained chrome, artifact split-view, generous reading column
2. **chat.openai.com** — prompt composer dominance, model picker treatment, history rail
3. **perplexity.ai** — citation-rich responses, source rendering, follow-up surface

## Anti-patterns (do NOT do these)
- Treating it as `dev-tool` (terminal aesthetic kills the broad-audience reading experience)
- Treating it as `b2b-productivity` (dashboard chrome buries the prompt)
- Heavy branding inside the conversation column
- Decorative illustrations on empty state (use real starter prompts)
- Tiny prompt box that hides the primary action
- Hidden model selector / hidden tool affordances
- Auto-scroll that fights the user during streaming (let users override)
- Cards or boxes around every response (interrupts reading)
- Bot avatars and chat-app skeumorphism (this isn't a messaging app)
