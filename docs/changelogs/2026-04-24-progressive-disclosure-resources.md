# Changelog: Progressive Disclosure — L3 Resource Indexing

**Date:** 2026-04-24
**Source:** [Developer's Guide to Building ADK Agents with Skills](https://developers.googleblog.com/developers-guide-to-building-adk-agents-with-skills/) — Google Developers Blog (April 2026)
**Authors:** Lavi Nigam (Google DevRel), Shubham Saboo (Google Sr. AI PM)
**Credibility:** 11/12 (PASS)

---

## What Changed

| # | Skill | Change | Resources Indexed |
|---|-------|--------|-------------------|
| 1 | `compress-skill` | Added `resources` to frontmatter | `references/compression-theory.md` |
| 2 | `deprecate-skill` | Added `resources` to frontmatter | `references/deprecation-log.md` |
| 3 | `generate-changelog` | Added `resources` to frontmatter | `references/changelog-template.md` |
| 4 | `learn-from-paper` | Added `resources` to frontmatter | `references/credibility-rubric.md` |
| 5 | `prd-writing` | Added `resources` to frontmatter | `references/metrics-frameworks.md`, `prd-schemas.md` |
| 6 | `product-soul` | Added `resources` to frontmatter | `references/discovery-questions.md`, `product-soul-schema.md` |
| 7 | `project-orchestrator` | Added `resources` to frontmatter | `references/agents-md-refresh-check.md`, `orchestration-patterns.md`, `platform-subagent-matrix.md` |
| 8 | `project-setup` | Added `resources` to frontmatter | `references/interview-questions.md`, `templates/agents-md-template.md` |
| 9 | `prune-skill` | Added `resources` to frontmatter | `references/citation-standards.md`, `obsolete-techniques.md` |
| 10 | `publish-skill` | Added `resources` to frontmatter | `references/publish-checklist.md` |
| 11 | `secure-skill` | Added `resources` to frontmatter | `references/threat-patterns.md` |
| 12 | `secure-skill-runtime` | Added `resources` to frontmatter | `references/no-go-repos.md` |
| 13 | `split-skill` | Added `resources` to frontmatter | `references/split-patterns.md` |
| 14 | `validate-skills` | Added `resources` to frontmatter | `references/validation-rubric.md` |
| 15 | `universal-skill-creator` | Added `resources` to frontmatter + updated Step 4 template + verification checklist | `references/` (5 files), `scripts/` (1 file), `templates/` (2 files) |

**Additional changes:**
- `templates/SKILL-template.md` — added commented `resources` field example
- `universal-skill-creator` — compressed from 212 → 189 lines to accommodate new content
- `validate-skills` — compressed from 201 → 196 lines

**Total files modified:** 17

---

## Why This Matters

Google's ADK team published a guide on building agents with skills using their `SkillToolset` API. The core architecture is **progressive disclosure** — loading agent knowledge in three layers:

- **L1 Metadata** (~100 tokens): Skill name + description. Loaded at startup for all skills. The "menu" the agent scans.
- **L2 Instructions** (<5,000 tokens): Full SKILL.md body. Loaded only when activated.
- **L3 Resources** (as needed): Reference files, scripts, templates. Loaded only when the skill's instructions require them.

agent-loom already had this architecture — frontmatter (L1), SKILL.md body (L2), and `references/` directories (L3). But we had a gap: **L3 resources weren't declared in frontmatter**. Skills mentioned their references in body text ("Read `references/examples.md` for..."), but there was no structured, machine-parseable index.

This meant platforms that support `load_skill_resource` (ADK SkillToolset, Gemini CLI) couldn't discover what L3 content a skill has without reading the entire body first — defeating the purpose of progressive disclosure.

The fix: add a `resources` field to frontmatter metadata that declares every file in `references/`, `scripts/`, and `templates/`. Now any platform can index available L3 content at L1 load time.

---

## Writeup

---

### We read the Google ADK skills guide. It confirmed 8 of 9 things we already do — and exposed the one thing we missed.

Google just published a [Developer's Guide to Building ADK Agents with Skills](https://developers.googleblog.com/developers-guide-to-building-adk-agents-with-skills/). It's one of the clearest explanations of how to structure agent knowledge using **progressive disclosure** — the idea that agents should load context in layers, not dump everything into a monolithic prompt.

Their architecture has three layers:
- **L1 — Metadata** (~100 tokens per skill). Name and description. Loaded at startup.
- **L2 — Instructions** (<5K tokens). Full skill body. Loaded on demand.
- **L3 — Resources** (as needed). Reference files, scripts, templates. Loaded only when instructions say so.

The result: an agent with 10 skills starts each call with ~1,000 tokens instead of 10,000. That's a **90% context reduction**.

We've been building [agent-loom](https://github.com/dvy1987/agent-loom) — a self-improving, cross-platform skill library that works across Codex, Claude Code, Ampcode, Gemini CLI, Cursor, Warp, and 40+ other tools. So we ran the ADK guide through our `learn-from-article` skill to see what we could learn.

**Here's what we already had:**
✅ L1/L2/L3 progressive disclosure architecture
✅ Rich descriptions with trigger phrases for routing (their "descriptions are your API docs" advice)
✅ 200-line limit per skill (stricter than their 500-line recommendation — backed by SkillReducer research)
✅ A skill factory (our `universal-skill-creator` is more sophisticated than their Pattern 4)
✅ External import via `install.sh` symlinks and `publish-skill` to skills.sh
✅ Security scanning on all generated skills (their "review generated skills like dependencies")
✅ Full agentskills.io spec compliance
✅ Cross-platform portability

**Here's what we missed:**
❌ Our L3 resources weren't declared in frontmatter. Skills mentioned references in their body text, but there was no machine-parseable index. Platforms supporting `load_skill_resource` (like ADK's SkillToolset) couldn't discover what L3 content existed without reading the full body — breaking the progressive disclosure promise at exactly the layer where it matters most.

**The fix:**
We added a structured `resources` field to the frontmatter metadata of all 15 skills that have reference files:

```yaml
metadata:
  author: dvy1987
  version: "2.1"
  resources:
    references:
      - platform-matrix.md
      - advanced-patterns.md
    scripts:
      - skill_scaffold.py
    templates:
      - SKILL-template.md
```

Now any platform — ADK, Gemini CLI, or any future agentskills.io-compatible tool — can index available L3 content at L1 load time without reading the skill body.

We also updated our `universal-skill-creator` template so every future skill includes this field automatically. 17 files changed. Zero functional regressions.

**The takeaway:**

The best skill libraries aren't the ones with the most skills. They're the ones where the agent can find what it needs *without loading what it doesn't*.

Progressive disclosure isn't just an optimization — it's the architecture that makes skill libraries scale.

If you're building agent skills, read Google's guide. And if you want a skill library that already does all of this (and maintains itself), check out [agent-loom](https://github.com/dvy1987/agent-loom).

---

*17 files modified. 15 skills upgraded. 0 regressions. One article read.*
