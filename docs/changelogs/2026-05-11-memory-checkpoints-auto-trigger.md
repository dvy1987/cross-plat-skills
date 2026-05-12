# Changelog: Memory Checkpoints — Auto-Trigger Infrastructure
Date: 2026-05-11
Significance: MINOR — closes a structural gap in how memory skills fire; touches 9 skills + 1 template + 1 AGENTS.md; no breaking changes for users; behaviour change for agents (memory sub-skills now auto-fire at producer events instead of only when the user asks).

## Summary
The memory skill suite existed but had no auto-trigger mechanism. Memory sub-skills only fired when the user explicitly said "remember this" or "handoff." Producer events — changelog written, ADR written, spec/plan/PRD written, skill created, session end — never invoked memory automatically. The gap was portable: `project-setup` propagated the same omission to every new project's `AGENTS.md`. This release builds a 4-layer fix: canonical checkpoint registry in `memory/SKILL.md`, mandatory final step in 6 producer skills, "Memory Checkpoints — Mandatory" section in agent-loom's `AGENTS.md`, and matching propagation through `project-setup` (SKILL.md + template + Update Mode + interview question) so every new project inherits the discipline.

## Breaking Changes
None.

## Added
- **`memory/SKILL.md` Mandatory Auto-Trigger Checkpoints section** — canonical registry table mapping 7 producer events to memory sub-skills (`memory-capture`, `memory-decision`, `memory-handoff`). Replaces ad-hoc "Trigger Policy" descriptions in child skills with one authoritative source of truth. Memory skill grew 101 → 117 lines.
- **Memory checkpoint final step in 6 producer skills** — each event-producing skill now ends with a "Memory Checkpoint (Mandatory)" step that points at the registry: `generate-changelog` (Step 9), `architectural-decision-log` (Step 6), `feature-spec` (Step 6), `implementation-plan` (Step 6), `prd-writing` (Step 9), `universal-skill-creator` (Step 12). Each skill remains ≤200 lines.
- **`AGENTS.md` "Memory Checkpoints — Mandatory" section** — sits at the same precedence as "Startup Skill Loading - Mandatory", at the top of the file. Agents working in agent-loom MUST consult the memory registry at every producer event and at session end.
- **`project-setup/templates/agents-md-template.md` "Memory Checkpoints — Mandatory" block** — ships in every new project's AGENTS.md, with a `<!-- Include only if memory suite installed and user did not opt out -->` gate. References `~/.agent-loom/skills/memory/SKILL.md` so the rule survives global install.
- **`project-setup/SKILL.md` Memory Checkpoints integration** — Step 4b adds it as the 9th required section (with skill-finder gate for conditional inclusion); Update Mode preserve list adds it (never overwritten on re-run); Axis 1 Q5 asks the user "Want auto-memory checkpoints?" with default-yes when the memory suite is installed.

## Fixed
- **`project-setup/SKILL.md` 200-line compliance** — file was at 213 lines (pre-existing violation, flagged in the validate-skills loader-safety changelog earlier today). While adding the Memory Checkpoints sections, the SDD chain block was compressed from 7 lines to 2, the Impact Report from 11 lines to 6, the Example from 7 lines to 1, and Step 6 footer from 2 lines to 1. Final: 200 lines exactly. Resolves a pre-existing violation as a side effect — no compress-skill invocation needed.
- **`universal-skill-creator/SKILL.md` 200-line compliance** — adding Step 12 pushed it to 202; trimmed Step 7, Step 8, Step 9, and Step 11 verbose phrasing without losing meaning. Final: 199 lines.

## Changed
- **Memory sub-skills now have an enforcement mechanism, not just documentation.** The "Trigger Policy" sections in `memory-handoff`, `memory-capture`, and `memory-decision` previously described *when they should run* — passive guidance. Now those triggers are concrete producer-event hooks invoked by name from the producer skills themselves. Agents that follow the workflow can no longer "forget" to capture a changelog or hand off at session end without explicitly violating a rule.

## Validation
- Line counts: all 9 touched SKILL.md files ≤200 lines (memory 117, project-setup 200, generate-changelog 198, architectural-decision-log 135, feature-spec 187, implementation-plan 176, prd-writing 161, universal-skill-creator 199, validate-skills 199).
- Loader safety (using the new `validate-skills` Step 2a check): all 9 SKILL.md files pass — byte 0 is `-`, ≥2 `---` fences. Verified via the same shell loop installed in `validate-skills` today.
- Encoding: no BOM, UTF-8 throughout, verified across all touched files.
- `agentskills validate`: not run (CLI not installed in this environment).

## Notes for Next Agent
- Layer 2 currently covers 6 producer skills. If a new producer skill is added later (e.g. `release-notes`, `feature-flag-decision`, `migration-plan`), it MUST register a checkpoint in `memory/SKILL.md` and add a final Memory Checkpoint step. Future work: add a "missing memory checkpoint" structural flag to `validate-skills` Step 4 so this gap can't recur silently.
- The `<!-- Include only if memory suite installed -->` gate in the template is currently a comment, not a runtime check. `project-setup` Step 4b is responsible for evaluating it via skill-finder. If `project-setup` is bypassed and the template is copied manually, the gate is documentation only.
- `project-setup` is now at exactly 200 lines — any future edit needs paired trims. If it bloats again, the right escalation is to split into `project-setup` (interview + initial scaffold) and `project-setup-update` (Update Mode), per the original split-skill heuristic.
