# Interview Guide Template

Load in `customer-discovery` Step 3 / Step 4. Use this template to design 30-min problem-discovery interviews. Apply Mom Test rules from `mom-test-rules.md`.

## Recruiting Message Template

```
Subject: Quick question — your experience with <painful situation>

Hi <name>,

I'm researching how <segment> currently <activity> — specifically the
part where <painful situation>. Not selling anything; just trying to
learn from people who actually live this.

Could you spare 25–30 min on a call <day range>? I'd be grateful, and
happy to share what I learn from the broader research at the end.

<founder name>
```

Notes:
- Frame as research, not user testing or feedback.
- Name the specific painful activity, not a vague "your work".
- Don't mention the product. Ever.
- Optional: $25–$50 incentive for non-network respondents.

Reject:
- Mass social-media broadcast ("anyone willing to chat?") — selects for the wrong people.
- Friend/family ask without ICP filter — bias is high.
- Paid panel respondents — incentive bias contaminates problem discovery.

## Interview Guide Structure (30 min)

```markdown
# Interview Guide: <idea> — <segment>
Goal: <one sentence — confirm or kill assumption X>

## Block 1 — Context (3 min)
- Tell me about your role and what a typical week looks like.
- How often does <activity in question> come up?
- Who else is involved when it does?

## Block 2 — Past behaviour deep-dive (12 min)
- Walk me through the most recent time you <did the activity>. Start to finish.
- What was annoying about it?
- What did you do BEFORE you started using <current tool/process>?
- What made you switch / change?
- (Probe each pain point with: "tell me more", "what specifically", "how often")

## Block 3 — Workaround interrogation (8 min)
- What tools / processes / people are involved today?
- How long does it take? How much does it cost (money / time)?
- What have you tried that didn't work? Why didn't it work?
- If <current solution> disappeared tomorrow, what would you do?

## Block 4 — Currency (4 min)
- Have you ever spent money on a tool / consultant / contractor to help with this?
- Have you ever asked for budget? What happened?
- Have you ever built or hired someone to build a workaround?
- (Money → time → political capital, in order of strongest signal)

## Block 5 — Wrap (3 min)
- Is there anything I should have asked but didn't?
- Who else should I talk to who has this problem?
- (Optional, only if user asks: brief solution reveal, mark anything after this as SOLUTION-TINTED)
```

## Bank of Strong Probes (use during any block)

- "Tell me more about that."
- "What specifically?"
- "Walk me through that."
- "What did you do next?"
- "How often does that happen?"
- "What's the cost when it happens?"
- "Why is that the way you do it?"
- "What have you tried before?"

## Bank of Forbidden Probes (never use)

- "Would you use…?"
- "Would you pay…?"
- "Do you think this is a problem?"
- "Is this useful?"
- "If we built X, would you…?"
- "On a scale of 1–10, how painful is this?"
- "Wouldn't it be great if…?"

## Note-Taking Convention

During the call (or replay), capture verbatim quotes — not paraphrases. Tag each quote with a code in real-time:

- `[FACT]` — observable past behaviour
- `[PAIN]` — unprompted complaint
- `[CURRENCY]` — money/time/effort already spent
- `[WORKAROUND]` — specific tool/process they use
- `[OPINION]` — predicted future or abstract take (low weight)
- `[COMPLIMENT]` — "cool idea" (discard for verdict)
- `[SOLUTION-TINTED]` — said after solution reveal (discount)

Synthesis happens against these codes — see `synthesis-template.md`.

## Variations

- **Async / written interviews** — only acceptable when target segment is genuinely unreachable by call. Quality of signal is lower; weight currency questions more.
- **Group interviews / focus groups** — avoid for problem discovery. Conformity bias is high.
- **Customer advisory boards** — useful post-PMF for solution direction; useless pre-PMF for problem validation.
