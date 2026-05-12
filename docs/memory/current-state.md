# Current State

Last updated: 2026-05-11 21:00

The memory skill suite now has an auto-trigger mechanism. Memory sub-skills fire at producer events (changelog written, ADR written, spec/plan/PRD written, skill created, session end) via the canonical "Mandatory Auto-Trigger Checkpoints" registry in `.agents/skills/memory/SKILL.md`. The discipline is enforced in this repo's `AGENTS.md` and propagated to every new project via `project-setup` (SKILL.md + template + Update Mode + interview).

The earlier loader-safety gap (six pre-existing skills with BOM/encoding regressions) is also closed: `validate-skills` Step 2a now runs the loader check across the full library on every audit.

## Active Risks
- `agentskills validate` is not available in this shell.
- Some documentation files contain mojibake from prior encoding history; avoid broad rewrites.
- PowerShell `Set-Content -Encoding UTF8` may introduce a BOM in this environment. Prefer `apply_patch` or byte-level writes that preserve no-BOM UTF-8.
- Layer 2 currently covers 6 producer skills. If a new producer skill is added (e.g. `release-notes`, `feature-flag-decision`, `migration-plan`), it MUST register a checkpoint in `memory/SKILL.md` and add a final Memory Checkpoint step — currently nothing enforces this. Tracked as deferred work: add a "missing memory checkpoint" structural flag to `validate-skills` Step 4.
- Working tree is uncommitted across multiple skill files; needs a commit pass before pushing.

## Immediate Next Step
Commit the working tree in two logical groups: (1) validate-skills loader-safety work + its changelog, (2) memory checkpoints auto-trigger work (9 SKILL.md files + AGENTS.md + template + memory state files + its changelog). Then run `validate-skills` once it lands (it now includes the loader-safety check that should have caught the prior incident).
