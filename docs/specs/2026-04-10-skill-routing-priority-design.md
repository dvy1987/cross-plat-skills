# Skill Routing Priority — Design Doc

**Date:** 2026-04-10
**Status:** Approved
**Author:** dvy1987
**Skill:** `.agents/ROUTING.md`

---

## Problem

When this skill library (cross-plat-skills) is installed alongside platform-native or user-defined skills, multiple skills may match the same user intent. For example:

- User says "fix this bug" → matches both `debug-and-fix` (this library) and Amp's builtin `fixing-bugs`
- User says "review this code" → matches both `code-review-crsp` (this library) and Amp's builtin `code-review`

Without an explicit priority rule, agents resolve conflicts inconsistently — sometimes using the library skill, sometimes the builtin, with no transparency to the user.

---

## Decision

**This library's skills always win** over platform-native, builtin, or external skills when triggers overlap — unless the user explicitly opts out.

### Rationale

1. **Cohesion.** Skills in this library are designed as a system — they call each other, share conventions, and produce compatible outputs. Mixing in platform-native skills breaks the call graph.
2. **Quality gate.** Every skill here passes `validate-skills ≥10/14` and the full `secure-*` scan pipeline. Builtin skills have no equivalent quality assurance in this context.
3. **Cross-platform consistency.** These skills work identically across 11+ platforms. Builtin skills are platform-specific by definition.

### Alternatives Considered

| Approach | Verdict | Why |
|----------|---------|-----|
| A. Platform-native wins | Rejected | Defeats the purpose of installing a curated library |
| B. This library wins (chosen) | Approved | Preserves system cohesion and quality guarantees |
| C. Ask every time | Rejected | Too noisy — would interrupt every conflicting invocation |
| D. Per-skill overrides | Rejected | Over-engineering — a blanket rule with opt-out covers all cases |

---

## Mechanism

The priority rule lives in `.agents/ROUTING.md` (read by agents on startup via AGENTS.md reference).

### Default Behavior

When a user intent matches both a library skill and an external skill:
1. Agent picks the library skill
2. Agent notifies the user (single line): "Using **[library skill]** over **[other skill]** ([source])."
3. Agent proceeds with the library skill

### Opt-Out

User can override by:
- Explicitly naming the other skill: "use the builtin code-review"
- Using opt-out phrases: "use default", "use native", "use builtin", "use the other one"

No notification needed when the user explicitly opts out.

---

## Scope

- Applies to ALL skills in this library, not just specific ones
- Applies across ALL platforms that support skill loading
- Does NOT apply when there is no conflict (only one skill matches)

---

## Risks

| Risk | Mitigation |
|------|-----------|
| User prefers a builtin and doesn't know how to opt out | Transparency notification tells them how |
| Library skill has a bug that builtin doesn't | User can opt out per-invocation; library skills have validate-skills + secure-* gates |
| New platform adds a superior builtin | User opts out explicitly; periodic `improve-skills` keeps library skills competitive |
