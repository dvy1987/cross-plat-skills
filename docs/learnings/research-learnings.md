# Research Learnings

This file stores reusable learnings captured from external sources such as papers, repositories, and articles.

Use one dated entry per learning. Keep entries concise and action-oriented so they can later be turned into skill updates or new skills. When a new skill is created from an entry here, update that same entry instead of creating a separate note.

Template:

```markdown
## YYYY-MM-DD - One-line summary
- Source:
- Type: paper | repo | article
- Credibility:
- Security:
- Classification:
- Insight:
- Recommended action:
- Skills modified:
- Skills created from this learning: none yet
- Notes:
```

## 2026-04-20 - AlphaEval: Production agent evaluation reveals scaffold dominance, value-score disconnect, and cascade fragility
- Source: Lu, Xu, Zhang et al. (2026). "AlphaEval: Evaluating Agents in Production". arXiv preprint.
- Type: paper
- Credibility: 8/12 (PASS — Moderate). Breakdown:
    - Author expertise: 2/2 — large team including Pengfei Liu (established NLP researcher)
    - Publication venue: 1/2 — arXiv preprint, no peer review yet
    - Evidence type: 2/2 — production data from 94 tasks across 7 companies
    - Reproducibility: 1/2 — benchmark described but dataset not publicly released
    - Recency: 2/2 — 2026, current models and scaffolds
    - Cross-reference: 0/2 — no independent replication at time of ingestion
- Security: SAFE (local PDF, text-only, no executable content)
- Classification: GOTCHA × 3, FAILURE_MODE × 5, TECHNIQUE × 2, METRIC × 2
- Insights:
  - GOTCHA: Scaffold choice is a first-order performance driver — same model (Opus 4.6) varies 11+ points across scaffolds (Claude Code 64.41 vs Codex 53.45)
  - GOTCHA: High aggregate scores ≠ high economic value — Gemini 3 Pro delivers more USD value than higher-scoring configs because it wins on high-value domains
  - GOTCHA: Search persistence is elicitable via scaffold strategy, not a fixed model property (GPT-5.2: 0.0 via Claude Code, 0.4 via Codex on same task)
  - FAILURE_MODE: Cascade dependency — early-stage errors invalidate all downstream steps. #1 pipeline killer.
  - FAILURE_MODE: Cross-section logical inconsistency — contradictory statements within long-form deliverables (e.g., different market sizes on different pages)
  - FAILURE_MODE: Constraint misinterpretation — agents optimize explicit goals while violating implicit domain-specific constraints
  - FAILURE_MODE: Format compliance failure — correct analysis fails because output format is incompatible with downstream systems
  - FAILURE_MODE: Synergy blindness — agents optimize components independently, producing 26% cost overruns vs jointly optimal solutions
  - TECHNIQUE: Compose multiple evaluation paradigms per task (avg 2.8 per task) — no single paradigm sufficient
  - TECHNIQUE: Requirement-to-benchmark framework (4 stages: partner engagement → requirement elicitation → task formalization → iterative evaluation)
  - METRIC: Best agent config achieves only 64.41/100 on production tasks (Claude Code + Opus 4.6)
  - METRIC: IR failure breakdown — hallucinations 30%, imprecise retrieval 35%, positive-info bias 10%
- Recommended action: Apply 8 skill improvements (see below)
- Skills modified: eval-rubric-design (×2), eval-judge, eval-pipeline, agent-builder (×2), process-decomposer, reality-check
- Skills created from this learning: none
- Notes: Format compliance finding validates existing eval-rubric-design hard gate. Multi-paradigm composition finding validates existing eval-pipeline 3-layer approach. Both KEEP CURRENT.
