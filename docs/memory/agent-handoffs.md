# Agent Handoffs

## 2026-05-11 18:34 - Handoff

### Done
- Added a 10-skill memory suite under `.agents/skills/memory*`.
- Added design spec `docs/specs/2026-05-11-memory-skill-suite-design.md`.
- Added changelog `docs/changelogs/2026-05-11-memory-skill-suite.md`.
- Updated `AGENTS.md`, `README.md`, `docs/SKILL-INDEX.md`, and `docs/skill-outputs/SKILL-OUTPUTS.md` for memory suite discovery.
- Repaired six existing invalid UTF-8 skill files: `eval-judge`, `eval-output`, `eval-pipeline`, `eval-rubric-design`, `process-decomposer`, and `reality-check`.
- Repaired `universal-skill-creator` loader issues: real frontmatter description, no BOM, description under 1024 chars, and 187 lines.

### Debated
- Whether to copy Codex's `skill-creator` patterns wholesale into `universal-skill-creator`.
- Conclusion: do not copy wholesale. Preserve agent-loom's governance chain and only add platform-agnostic improvements.

### Decisions
- Keep `universal-skill-creator` as the required path for skill creation.
- Preserve calls to `research-skill`, `secure-*`, `compress-skill`, `split-skill`, `skill-deconflict`, `validate-skills`, `cross-link-skills`, `library-skill`, and optional `publish-skill`.
- Add Codex-inspired improvements only where cross-platform: example-driven design, degrees-of-freedom choice, resource selection discipline, forward-testing, and loader checks.

### Deferred
- Finish the comparison-driven improvement pass on `universal-skill-creator` carefully.
- Decide whether to update `docs/SKILL-INDEX.md` entry for `universal-skill-creator` to mention loader-safety and cross-platform metadata.
- Decide whether to add a small script/check for loader safety across all skills.

### Next Agent Should Know
- The user interrupted a proposed full rewrite because they wanted to preserve the creator's existing sub-skill call graph.
- Do not rewrite `universal-skill-creator` wholesale.
- The current `universal-skill-creator` has some targeted improvements already applied, but Step 9 still needs an explicit loader-check line and optional forward-test step if desired.
- `agentskills validate` is unavailable in this environment; use strict UTF-8/BOM/line-count checks and document the limitation.

### Revisit Triggers
- If skill loader warnings return, first scan for BOM, invalid UTF-8, missing frontmatter, and description >1024 chars.
- If `universal-skill-creator` exceeds 200 lines again, trim non-core prose rather than invoking `compress-skill` blindly.
- If Codex-specific metadata is added, keep it optional so agent-loom remains coding-agent agnostic.

### Working Tree
- Many files are modified/untracked from the memory-suite work. Review `git status --short` before editing.
- Do not revert existing changes unless the user explicitly asks.
