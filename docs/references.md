# References

Canonical registry of external sources cited inside skills, plans, specs, and learnings. Every inline citation in a SKILL.md should resolve to an entry here. Each entry links to its full analysis document under `docs/learnings/papers/` (papers), `docs/learnings/repos/` (repos), or `docs/learnings/articles/` (articles).

When a skill cites a source, use the short form `(<ID> — see <path>)` so a future maintainer can trace the credibility derivation, security scan, methodology, and application map without grepping the repo.

---

## Papers

| ID | Citation | Credibility | Security | Analysis document |
|----|----------|-------------|----------|-------------------|
| `alphaeval-2026` | Lu, Xu, Zhang, Liu et al. (2026). *AlphaEval: Evaluating Agents in Production*. arXiv preprint. | 8/12 (PASS — Moderate) | SAFE | [docs/learnings/papers/alphaeval-2026-lu-et-al.md](learnings/papers/alphaeval-2026-lu-et-al.md) |
| `debate-2024` | Cited in skills as `DEBATE-arXiv-2405.09935`. Full analysis pending — flagged for backfill. | not yet scored | not yet scanned | _missing — backfill required_ |

## Repositories

_None ingested yet via `learn-from-repo`._

## Articles

_None ingested yet via `learn-from-article`._

---

## Conventions

- **ID format:** `<short-name>-<year>` (e.g., `alphaeval-2026`).
- **Inline citation in skills:** `(AlphaEval 2026 — see docs/learnings/papers/alphaeval-2026-lu-et-al.md)` or the short form already in use plus a footer link to this file.
- **Adding a new entry:** create the analysis document under the appropriate `docs/learnings/<type>/` subdirectory using the `learn-from-paper` / `learn-from-repo` / `learn-from-article` skill, then add a row here.
- **Re-scoring:** if credibility changes (peer review, dataset release, replication, retraction), update both the analysis document and the row in this table.
- **Retracted sources:** keep the row but prefix the ID with `~~` and link to the retraction note.
