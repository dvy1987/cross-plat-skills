# Idea Card Template

Load in `idea-generation` Step 3. Every generated candidate uses this 7-field structure. Cards missing any field are rewritten or struck.

## Required fields (all 7)

```markdown
### Idea N: <one-line pitch — concrete, no marketing language>

- **Segment:** <specific persona in specific situation>
  Example good: "Solo brand designer in NYC charging $100+/hr, 1–3 active clients/month, currently using HoneyBook + Stripe."
  Example bad: "Freelance designers."

- **JTBD / pain:** <quote-form>
  Example good: "When I finish a project and hand off the deliverables, I want to get paid within 14 days, so I can pay myself salary and not chase 4 invoices for 60+ days."
  Example bad: "Designers don't get paid on time."

- **Current alternative:** <what they do today + why it sucks>
  Example good: "Manual reminder emails 2x/week + occasional Slack DMs to clients. Awkward, embarrassing, and inconsistent — most don't follow up at all."
  Example bad: "Nothing." (almost always wrong; if literally nothing, the pain isn't acute)

- **Why now:** <specific shift in last 24 months>
  Example good: "Stripe launched programmable Treasury + revenue-recognition APIs in 2025, making it possible for indie SaaS to handle full A/R workflows without a finance team."
  Example bad: "AI is changing things." / "Post-COVID."

- **Distribution wedge:** <ONE specific channel>
  Example good: "SEO on long-tail Stripe-pain queries (`stripe webhook subscription cancelled`, `late invoice freelance designer template`) — 40+ identified high-intent keywords, low DR competitors."
  Example bad: "SEO + content + social."

- **Monetisation hypothesis:** <who pays, how much, why>
  Example good: "$29/mo per user, billed monthly. Justified by: replaces a $39 Bonsai subscription + saves 4 hours/month at $100/hr = $400/mo value."
  Example bad: "Freemium with paid upgrade."

- **Feels like:** <existing product + the twist>
  Example good: "Bonsai for designer A/R, but invoice-only and 1/4 the price. Like 'just the part of HoneyBook that actually works'."
  Example bad: "Like Notion but for invoicing."
```

## Method + Non-Obviousness tags

Append:
```
- **Method:** <which generation method produced this>
- **Non-obviousness:** obvious / non-obvious
  - "obvious" = a competitor exists serving an adjacent segment, OR the idea is widely discussed in founder communities
  - "non-obvious" = no direct competitor, OR everyone dismisses it (often = schlep blindness)
```

## Quality bar

A card passes if and only if:
1. All 7 fields are concrete (not labels)
2. Segment is a real persona, not a category
3. Pain quote uses "When I…, I want…, so I can…" form OR equivalent past-behaviour reference
4. Why-now is timestamped to last 24 months
5. Distribution wedge names a specific channel/keyword/community
6. Monetisation includes price + justification
7. "Feels like" is an existing product, not a category

## Anti-patterns (auto-strike)

- "Uber for X" / "Notion for X" / "AI for X" with no concrete JTBD
- Segment = "consumers", "developers", "everyone", "businesses"
- Why now = "AI", "post-COVID", "the world is shifting"
- Distribution = "social media", "content marketing", "SEO" (without specifics)
- Monetisation = "freemium", "we'll figure it out"
- Feels like = "the X of Y" without a concrete competitor
