# AlphaEval: Evaluating Agents in Production (Lu, Xu, Zhang et al., 2026)

**learn-from-paper output document**
**Ingested:** 2026-04-20
**Canonical reference ID:** `alphaeval-2026`
**Status:** Active — cited by 7 skills (see Application Map below)

---

## Citation

> Lu, X., Xu, J., Zhang, R., Liu, P., et al. (2026). *AlphaEval: Evaluating Agents in Production*. arXiv preprint.

When citing this paper inside a SKILL.md, use the short form:

> `(AlphaEval 2026 — see docs/learnings/papers/alphaeval-2026-lu-et-al.md)`

This is the canonical source of the credibility score, methodology summary, insight extraction, and application map. Inline citations in skills MUST resolve here.

---

## Credibility: 8/12 (PASS — Moderate)

The credibility score uses the standard learn-from-paper rubric (six dimensions, 0–2 each, max 12). Each dimension is scored against observable evidence in the paper at the time of ingestion. Scores below are reproducible — a future maintainer can re-derive them from the paper alone.

| # | Dimension | Score | Evidence |
|---|-----------|-------|----------|
| 1 | Author expertise | **2/2** | Large multi-author team. Includes Pengfei Liu (established NLP researcher with prior peer-reviewed work in evaluation; Generative AI lab affiliation). Senior author signals domain credibility. |
| 2 | Publication venue | **1/2** | arXiv preprint at time of ingestion (2026-04-20). No peer-review record. Score capped at 1/2 until accepted at a venue. Re-score to 2/2 once peer-reviewed. |
| 3 | Evidence type | **2/2** | Empirical study using **production data** — 94 real-world tasks sourced from 7 partner companies across HR, finance, procurement, healthcare, legal. Not a synthetic benchmark. Direct measurement on commercial scaffolds (Claude Code, Codex, GitHub Copilot, Cursor). |
| 4 | Reproducibility | **1/2** | Methodology and rubrics are clearly described in the paper, including the requirement-to-benchmark framework. However, the underlying task dataset is **not publicly released** at the time of ingestion (proprietary partner data). Independent re-runs are not currently possible. Score capped at 1/2 until dataset is open-sourced. |
| 5 | Recency | **2/2** | Published 2026. Covers current-generation models (Opus 4.6, GPT-5.2, Gemini 3 Pro) and current commercial scaffolds. No staleness concerns at ingestion time. |
| 6 | Cross-reference | **0/2** | No independent replication or follow-up at time of ingestion. No other 2026 papers report comparable production-task scaffold-vs-model breakdowns. Score capped at 0/2 until at least one independent corroboration appears. |

**Total: 8/12 — PASS (≥ 7/12 threshold).**

**Threshold rules used:**
- 0–6/12 → REJECT (do not apply)
- 7–9/12 → PASS — Moderate (apply with caveats; re-score on new evidence)
- 10–12/12 → PASS — High (apply confidently)

**Why "Moderate" matters in skill content:**
A 8/12 paper is good enough to drive skill changes, but every cited insight must be framed as **observed in this paper** rather than as universal truth. Skills citing this paper use language like "AlphaEval 2026 documents that..." rather than "agents always...".

**Re-scoring triggers:**
- If accepted at a peer-reviewed venue → +1 (would become 9/12).
- If dataset is publicly released → +1 (would become 9/12 or 10/12).
- If an independent team replicates any headline finding → +2 (cross-reference) (would become 10–12/12).

---

## Security

- **Source:** Local PDF supplied by user.
- **Scan:** All `secure-*` skills returned SAFE (text-only content, no executables, no embedded instructions targeting agent behavior, no exfiltration patterns, no obfuscated payloads).
- **Status:** SAFE — cleared for ingestion 2026-04-20.

---

## Methodology Summary (for future maintainers)

- **Sample:** 94 real-world tasks from 7 partner companies. Tasks span HR, finance, procurement, healthcare, legal.
- **Systems evaluated:** 4 commercial scaffolds × multiple frontier models (Opus 4.6, GPT-5.2, Gemini 3 Pro, plus others).
- **Scoring:** Multi-paradigm — average 2.8 evaluation paradigms per task (rubric-based, format-checking, value-weighted, IR failure decomposition).
- **Headline numbers:**
  - Best agent config: **64.41/100** (Claude Code + Opus 4.6)
  - Same model across scaffolds: **11+ point swing** (Opus 4.6: 64.41 on Claude Code vs 53.45 on Codex)
  - IR failure breakdown: **30% hallucinations, 35% imprecise retrieval, 10% positive-info bias**
  - Synergy blindness: **26% cost overruns** in procurement when agents optimize components independently

---

## Insights Extracted

Classified using the standard learn-from-paper taxonomy:

**GOTCHA × 3**
1. Scaffold choice is a first-order performance driver (11+ pt swing on same model).
2. High aggregate scores ≠ high economic value (Gemini 3 Pro delivers more USD value despite lower aggregate).
3. Search persistence is elicitable via scaffold strategy, not a fixed model property.

**FAILURE_MODE × 5**
1. Cascade dependency — early-stage errors invalidate downstream steps. #1 pipeline killer.
2. Cross-section logical inconsistency — long-form deliverables contradict themselves across pages.
3. Constraint misinterpretation — agents satisfy explicit goals while violating implicit domain norms.
4. Format compliance failure — correct analysis fails because output format breaks downstream systems.
5. Synergy blindness — independent component optimization produces globally suboptimal results (26% overruns).

**TECHNIQUE × 2**
1. Compose multiple evaluation paradigms per task (avg 2.8). No single paradigm sufficient.
2. Requirement-to-benchmark framework: partner engagement → requirement elicitation → task formalization → iterative evaluation.

**METRIC × 2**
1. Best agent config achieves only 64.41/100 on production tasks.
2. IR failure breakdown — hallucinations 30%, imprecise retrieval 35%, positive-info bias 10%.

---

## Application Map (where this paper is cited and why)

| Skill | Insight applied | Location |
|---|---|---|
| `eval-rubric-design` | Internal consistency dimension; value-weighting gotcha | Lines 60, 131 |
| `eval-judge` | Long-form internal consistency check gotcha | Cited inline |
| `eval-pipeline` | Per-step intermediate validation for cascade dependency | Line 35 |
| `eval-output` | Aggregate-score vs business-value warning | Line 97 |
| `agent-builder` | Scaffold-as-performance-driver; cross-agent validation | Lines 84–85 |
| `process-decomposer` | Implicit domain constraints gotcha | Line 99 |
| `reality-check` | Production benchmark ceiling (<65%); IR failure rates | Lines 20, 186 |

All seven skills cite this paper as `AlphaEval (Lu et al. 2026, credibility 8/12)` — credibility score and full derivation resolve to this document.

---

## Notes for Future Maintainers

- **If the paper is updated or peer-reviewed:** re-score credibility, update this file, bump the "Status" header. Skill citations stay unchanged (they resolve here).
- **If a finding is contradicted by a follow-up paper:** annotate the affected row in the Application Map, flag the skill for review via `improve-skills`.
- **If the paper is retracted:** mark Status as RETRACTED, run `prune-skill` on every skill in the Application Map.
- **Two findings deliberately did not change skills:** (a) format compliance — already covered by an existing `eval-rubric-design` hard gate; (b) multi-paradigm composition — already covered by the existing `eval-pipeline` 3-layer approach. KEEP CURRENT noted in `docs/learnings/research-learnings.md`.
