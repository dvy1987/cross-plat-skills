# Current State

Last updated: 2026-05-16

Four structural deliverables landed across 2026-05-13 → 2026-05-16:

1. **Retroactive Project Setup** (2026-05-13). New skill `retroactive-project-setup` (Atomic, 188 lines) bootstraps the full agent layer (AGENTS.md + architecture + soul + ADR-0001 + memory seed) over an existing codebase via a strict write-allowlist — never modifies source code. Composes `codebase-understanding`, `product-soul` (inference mode), `architectural-decision-log` (now in `SYNTHESIS=true` mode), and `project-setup` (`RETROACTIVE=true` mode). The AGENTS.md template ships with a symmetric `Session Lifecycle — Mandatory` block (Session Start + During & End).

2. **Chat-Learnings Feedback Loop** (2026-05-13). `learn-from-chat` v1.2 and `improve-skills` v1.3 are two ends of one closed loop. Canonical targeted-improvement entry point: `improve-skills TARGET=<skill> [SKIP_RESEARCH=true]`. Restructure-class edits discovered mid-session escalate from `learn-from-chat` Step 5 to that path. Chat learnings carry a mandatory `Status` field; `improve-skills` Step 1b ingests OPEN entries and Step 2l writes terminal statuses back.

3. **Three Library-Health Improvements** (2026-05-14, via the new TARGETED path). `reality-check` compressed 255 → 189 lines by extracting Step 8 deliverable templates to a reference file (v1.2). `architectural-decision-log` v1.1 gained an explicit `SYNTHESIS=true` mode parallel to `project-setup`'s `RETROACTIVE=true`; `retroactive-project-setup` Step 5.3 now invokes it by name. `validate-skills` v1.1 gained Step 4c Producer-Skill Checkpoint Audit + a new structural flag, making the `memory/SKILL.md` Mandatory Auto-Trigger Checkpoint rules self-enforcing rather than a written prayer. All 6 current producer skills pass the new check.

4. **Memory-Startup Cold-Start Trigger Hardening** (2026-05-16, local commit `0590e10`). `memory-startup`'s description was rewritten to fire on EVERY first user message regardless of content — bare greetings, task-only openers, pasted error logs all count. A No-Op Gate makes over-invocation cheap. `AGENTS.md` §Session Lifecycle and the `project-setup` template carry the same contract verbatim so every project bootstrapped by `project-setup` or `retroactive-project-setup` inherits the fix. Closes a routing gap discovered in a sister project.

Earlier wins still in place: `universal-skill-creator` Step 11 (library-skill auto-chain); loader-safety check in `validate-skills` Step 2a (2026-05-11); checkpoint registry + 4-layer producer enforcement (2026-05-11).

## Active Risks
- `agentskills validate` CLI remains unavailable in this environment; structural checks are manual.
- The 2026-05-14 work modified `validate-skills` itself — next agent should rerun the full validate-skills sweep in a clean environment to confirm Step 4c behaves correctly across the whole library, not just the 6 producer skills spot-checked here.
- `architectural-decision-log` SKILL still references `references/adr-template.md` in earlier git history; with v1.1 the schema is now spelled inline. Latent stale reference path is gone but worth a grep on next library sync.
- Some documentation files contain mojibake from prior encoding history; avoid broad rewrites.
- PowerShell `Set-Content -Encoding UTF8` may introduce a BOM in this environment. Prefer `edit_file` / `create_file` (the agent-loom tools) which write no-BOM UTF-8.
- Producer-skill checkpoint enforcement gained Step 4c on 2026-05-14, but the parallel "missing cold-start trigger" / "missing AGENTS.md Session Lifecycle reference" structural flag is still deferred — only one of the two related gaps is closed.
- `docs/memory/MEMORY-ROUTING.md` does not yet exist in this repo. The skeleton was never created; current sessions read `project-index.md` directly. Low priority — works fine — but `memory-startup` Step 1 will create it on the next run.

## Immediate Next Step
None forced. Local commit `0590e10` (cold-start hardening) was rebased on top of origin commit `b3a9cd4` (three May-14 deliverables); memory files merged manually to preserve both narratives. After the rebase lands, optional follow-up: add the deferred "missing cold-start trigger" structural flag to `validate-skills` Step 4 alongside the already-shipped Step 4c producer-checkpoint audit — both close the same class of routing gap.
