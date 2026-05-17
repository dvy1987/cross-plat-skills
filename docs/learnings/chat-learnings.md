# Chat Learnings

This file stores reusable learnings discovered during conversations while working in this repo.

Use one dated entry per learning. Record what actually happened, why it matters, and which skills or processes changed. When a new skill is created from an entry here, update that original entry with the created skill name and path.

Each entry MUST carry a `Status` field. `improve-skills` Step 1b reads this file every pass and only triages entries whose status is `OPEN` (or missing). `learn-from-chat` sets the initial status; `improve-skills` writes terminal statuses in Step 2l.

Status values:
- `OPEN` — captured but not yet applied to any skill.
- `IMPLEMENTED ([YYYY-MM-DD], <skill> v<ver>)` — landed in the referenced skill.
- `ESCALATED (improve-skills TARGET=<skill>, [YYYY-MM-DD])` — restructure-class change handed off to the targeted improve-skills run.
- `REJECTED (<reason>)` — not generalizable or evidence is too thin.
- `DEFERRED (<reason>)` — valid but target skill is not in the current queue, or needs design work first.

Template:

```markdown
## YYYY-MM-DD - One-line summary
- Status: OPEN
- Classification:
- Evidence:
- Target skill(s):
- Skills modified:
- Skills created from this learning: none yet
- Changes:
- Notes:
```

---

## 2026-05-17 — Synergy blindness wired into prevention / gate / detection skills, not just architecture

- **Status:** IMPLEMENTED (2026-05-17, process-decomposer v1.2, setup-evaluation v1.1, eval-pipeline v1.2)
- **Classification:** FAILURE_MODE
- **Evidence:** Verifying AlphaEval coverage in response to a user question revealed that synergy blindness (AlphaEval 2026 — 26% cost overruns in production procurement) had been applied only to `agent-builder` during the original 2026-04-21 ingestion. `grep -i synergy .agents/skills/*/SKILL.md` returned hits only in `agent-builder`. The AlphaEval ingestion doc's Application Map (`docs/learnings/papers/alphaeval-2026-lu-et-al.md`) maps synergy blindness only to `agent-builder` under "scaffold-as-performance-driver; cross-agent validation," missing the upstream prevention (`process-decomposer`), pre-execution gate (`setup-evaluation`), and post-hoc detection (`eval-pipeline`) surfaces.
- **Target skill(s):** process-decomposer, setup-evaluation, eval-pipeline
- **Skills modified:** process-decomposer (v1.1→v1.2), setup-evaluation (v1.0→v1.1, also added AlphaEval to `metadata.sources`), eval-pipeline (v1.1→v1.2)
- **Skills created from this learning:** none
- **Changes:** One gotcha appended to each skill's `## Gotchas`, citing AlphaEval 2026 (credibility 8/12) and the 26% cost-overrun production data. process-decomposer: "Don't declare parallel tracks 'independent' without checking for coupled decisions." setup-evaluation: "Cross-agent coupling can pass all checks but still produce synergy blindness." eval-pipeline: "Multi-agent eval needs cross-agent consistency checks." Post-application hardening cycle: 200-line gate PASS (152 / 137 / 195), security sweep SAFE on all three (no injection / exfiltration / credential / hidden-content / unicode findings), validate-skills criteria intact (only Gotchas section changed — improvement direction).
- **Notes:** Structural meta-pattern worth carrying forward — when a `learn-from-paper` ingestion identifies a multi-stage failure mode, the corresponding insight should be distributed across prevention / gate / detection skills, not concentrated only in the most-obviously-related skill. Consider adding this as a heuristic to `learn-from-paper` or the `learn-from` orchestrator's shared protocol in a future improve-skills pass.
