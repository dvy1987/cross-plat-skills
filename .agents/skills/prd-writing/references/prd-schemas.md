# PRD Schemas

Full templates for all four PRD formats. Read this when writing any PRD.

---

## Full PRD

```markdown
# PRD: [Feature / Product Name]
**Author:** [name] | **Date:** YYYY-MM-DD | **Status:** Draft
**Format:** Full PRD

## 1. Executive Summary
**Problem:** [1–2 sentences]
**Solution:** [1–2 sentences]
**Success Criteria:**
- [Measurable KPI with target]
- [Measurable KPI with target]
- [Measurable KPI with target]

## 2. Background & Context
[Why now? Current workaround? Business justification?]

## 3. User Personas
**Primary:** [Job title] — [what they're trying to do, what frustrates them today]
**Secondary:** [If applicable]

## 4. User Stories & Acceptance Criteria

### Story 1: [Name]
> As a [persona], I want to [action] so that [benefit].
- [ ] [Specific, testable criterion]
- [ ] [Specific, testable criterion]

## 5. Functional Requirements
| # | Requirement | Priority |
|---|-------------|----------|
| F1 | [Specific requirement] | Must Have |
| F2 | [Specific requirement] | Should Have |
| F3 | [Specific requirement] | Nice to Have |

## 6. Non-Functional Requirements
| Category | Requirement |
|----------|-------------|
| Performance | [e.g., p95 latency < 300ms at 1000 concurrent users] |
| Accessibility | [e.g., WCAG 2.1 AA] |
| Security | [e.g., PII encrypted at rest and in transit] |
| Compatibility | [e.g., Chrome 120+, Safari 17+, iOS 16+] |

## 7. Out of Scope
- [Specific item NOT in this release]
- [Specific item deferred to v2]

## 8. Technical Considerations
[High-level architecture, APIs involved, data model changes, migration needs.
Focus on WHAT, not HOW. For AI features: tools/models required, evaluation strategy, latency/cost targets.]

## 9. Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [Risk] | High/Med/Low | High/Med/Low | [Mitigation] |

## 10. Rollout Plan
- **MVP (Phase 1):** [What ships first, to whom]
- **Phase 2:** [What follows]
- **Kill switch:** [How to revert]

## 11. Success Metrics
| Metric | Baseline | Target | How Measured |
|--------|----------|--------|-------------|
| [KPI] | [current] | [goal] | [tool/query] |

## 12. Open Questions
- [ ] [Question — must be empty before Approved]

## 13. Sign-Off
| Role | Name | Status |
|------|------|--------|
| Product | | Pending |
| Engineering | | Pending |
| Design | | Pending |
```

---

## Lean PRD

```markdown
# Lean PRD: [Feature Name]
**Date:** YYYY-MM-DD | **Status:** Draft

## Problem
[2–3 sentences. What's broken, who it affects, why it matters now.]

## Solution
[2–3 sentences. What we're building — not how.]

## User Stories
- As a [persona], I want [action] so that [benefit].
  - AC: [testable criterion]
  - AC: [testable criterion]

## Success Metrics
- [Metric]: [current] → [target]

## Out of Scope
- [Item 1]

## Risks
- [Risk]: [Mitigation]

## Open Questions
- [ ] [Question]
```

---

## One-Pager

```markdown
# One-Pager: [Feature Name]
**Date:** YYYY-MM-DD

**Problem:** [1 sentence]
**Solution:** [1 sentence]
**Who benefits:** [Persona + approximate user count]
**Success looks like:** [2–3 measurable outcomes]
**Not doing:** [2–3 explicit non-goals]
**Biggest risk:** [1 sentence + mitigation]
**Ask:** [What you need from the reader]
```

---

## Technical PRD

Same as Full PRD but expand Section 8 to include:
- Architecture diagram or component list
- API contracts (request/response schemas)
- Data model changes with field definitions
- Migration strategy
- Performance benchmarks with measurement methodology
- For AI features: model selection rationale, evaluation dataset, pass/fail thresholds
