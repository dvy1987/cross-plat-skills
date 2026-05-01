# Archetype: social-feed

**Feels like:** X (Twitter), Threads, Bluesky, Mastodon, Reddit, BeReal

For: networked-attention products where the feed IS the home, identity is part of the visual grammar, and the job is rapid scan / react / publish lightly / re-enter.

## Typography
- Display: rare — feed products don't lean on display type. When used, conservative grotesque (Söhne, Inter, system-ui) at 18–24px max.
- Body: 14–16px / line-height 1.4–1.5. The signature is *post-shaped* type — not too dense (uncomfortable), not too airy (hurts feed throughput).
- Mono: only for code blocks in posts.
- Pairing rationale: type should be invisible. Identity comes from the content (posts, avatars, media), not the chrome.

## Color
- Background: variable per product but typically near-black `#0F1015`–`#15171B` (dark) / off-white `#FAFAFA`–`#F8F9FA` (light). Light + dark are both first-class — users live in both.
- Foreground: high contrast, slight off-pure.
- Accent: ONE branded accent for the engagement signal (like, repost, follow). Used SPARINGLY — accent is reserved for "you've taken action" moments, not always-on chrome.
- Anti-defaults: NO Tailwind grays. NO multi-color palettes (one accent rule).

## Motion
- Duration budget: 80–180ms for feed actions; 240–400ms for entering compose / detail views.
- Easing: spring-feel for like/repost confirmations, smooth for navigation. `cubic-bezier(0.16, 1, 0.3, 1)` is a safe default.
- Character: micro-celebrations on positive engagement (like animation, reply send), invisible elsewhere. Optimistic UI mandatory — actions complete instantly, network reconciles after.

## Density
**Dense.** Posts stack tightly. Avatar + name + handle + timestamp + post + media + action rail must fit a 14"-screen viewport with 4–6 posts visible.

## Icon stance
**tuned-phosphor** Regular or **custom-svg** at 18–22px. Action icons (reply, repost, like, share) are the most-seen UI elements in the product — they MUST be hand-tuned for optical balance and active/inactive states.

## Layout signatures
- **Feed as home screen** — reverse-chron or ranked stream is the product, not a navigation aid
- **Post as scan unit:** avatar + identity + metadata + content + action rail (always in this rough order — users have learned it)
- **Persistent compose surface** — FAB, top composer, or always-near-the-feed; never buried
- **Three-column layout on desktop:** nav rail / feed / contextual rail (search, trends, sidebars)
- **Modal-or-route post detail** — replies thread under, optimized for scrolling
- **Identity chrome** — username, handle, avatar, verification mark, follower counts visible
- **Notification dot pattern** — small color dot on chrome elements indicating unread state

## Reference sites (visit these)
1. **bsky.app** — clean modern social-feed, well-tuned action rail, three-column desktop
2. **threads.net** — premium-feeling feed, restrained motion, good light/dark parity
3. **mastodon.social** (instances vary) — open-protocol social feed; study chrome density

## Anti-patterns (do NOT do these)
- Editorial-style reading rhythm (kills feed throughput)
- Generous whitespace between posts (defeats scan-and-react)
- Card-based posts with shadows and rounded corners — posts are content, not cards
- Hero sections, multi-step onboarding modals — get users to the feed instantly
- Branded illustration content interrupting the feed
- Auto-playing video without user opt-in
- Heavy theming per post type (posts must feel uniform; the content is the variation)
- Sidebar navigation with primary product features hidden behind menus
