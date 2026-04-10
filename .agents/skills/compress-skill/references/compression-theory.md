# Compression Theory — Why Less Is More

Read this if the user asks why compression improves quality, or questions whether compressing a skill will hurt its effectiveness.

---

## The SkillReducer Findings (arXiv:2603.29919, April 2026)

Researchers compressed 600 real-world skills and found:
- **39% average body token reduction**
- **Functional quality improved by 2.8%** on task benchmarks after compression
- **Less-is-more effect**: removing non-essential content reduces distraction in the context window, improving agent focus on what matters
- Skills in the 1–3k token range achieved 79% core reduction; >3k token skills achieved 89%

Key insight from the paper: over 60% of content in typical skill bodies is non-actionable — background, rationale, verbose explanations the LLM already knows from training. This content doesn't help the agent; it dilutes attention away from the rules and workflow steps that do.

## The Vercel Finding (2026)

Vercel benchmarked their Next.js agent on coding tasks:
| Approach | Pass Rate |
|----------|-----------|
| No help | 53% |
| Full 40KB skill docs | 53% |
| Forced instructions | 60–65% |
| **8KB compressed index in AGENTS.md** | **100%** |

The compressed index outperformed 40KB of raw documentation because **the best information is information the agent doesn't have to decide to retrieve**. When critical facts are always present in compressed form, the agent never misses them.

## What This Means for Compression

1. **Don't be afraid to cut.** If you're uncertain whether a line is needed, remove it and check the regression criteria. More often than not, the agent performs equally well or better without it.

2. **Background explanation is almost always cuttable.** The agent already knows why PRDs need clear requirements, why design should precede code, why gotchas matter. It doesn't need to be told.

3. **Workflow steps and hard gates are never cuttable.** These are the procedural knowledge the agent genuinely doesn't have — they're the reason the skill exists.

4. **Moving to references/ is not the same as deleting.** Content in references/ is still available — it just loads only when needed, keeping the active context window clean for the task at hand.
