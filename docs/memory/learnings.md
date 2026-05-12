# Project Learnings

Durable lessons captured from sessions. Each entry follows the `memory-capture` template.

---

## 2026-05-11 - Skill trigger policies are documentation, not enforcement
Type: learning
Status: active
Scope: project
Confidence: high
Source: 2026-05-11 session — gap discovered by human reviewer after agent wrote a changelog without invoking memory-capture
Tags: memory, architecture, skill-design, auto-trigger

### Content
Writing a "Trigger Policy" section in a SKILL.md describes *when the skill should run* — it does not actually cause the skill to run. There are no runtime hooks in this skill system; every invocation is the agent's judgment call based on description matching. So if the agent doesn't think "this is a session-ending moment" or "this is a checkpoint event," it never fires the skill regardless of how clearly the trigger policy is written.

The fix is to push trigger enforcement up one level: a canonical registry in the orchestrator skill (`memory/SKILL.md` Mandatory Auto-Trigger Checkpoints), referenced by name in the producer skill's final step ("Per `memory/SKILL.md` registry, invoke `memory-capture`"). Producer skills then carry the trigger as a workflow step the agent cannot complete without invoking.

### Why It Matters
Any future skill suite that relies on "auto-fire on event X" will have the same gap unless it follows the same 4-layer pattern: (1) canonical registry in orchestrator, (2) producer skills self-trigger via explicit final step, (3) host repo's AGENTS.md mandates the registry, (4) `project-setup` propagates the AGENTS.md section to new projects via SKILL.md + template + Update Mode preserve list + interview question. Skipping any of the 4 layers leaves a gap: registry-only fails because producers don't fire; producer-only fails for new projects; AGENTS.md-only is local; project-setup-only is unenforced in the current repo.

### Revisit When
- A new event-producing skill is added (release-notes, feature-flag-decision, migration-plan, etc.) — it must register a checkpoint.
- `validate-skills` gains a "missing memory checkpoint" structural flag (currently deferred).
- A future skill suite designed around event-driven auto-triggering needs the same 4-layer pattern.

---

## 2026-05-11 - Pre-existing line-count violations can be resolved as side effects of feature work
Type: learning
Status: active
Scope: project
Confidence: medium
Source: 2026-05-11 session — project-setup was 213 lines (pre-existing violation), brought to exactly 200 while adding Memory Checkpoints
Tags: skill-quality, compression, line-limit

### Content
When making targeted additions to a skill that's already over the 200-line cap, find compressible blocks elsewhere in the same skill rather than scoping a separate compress-skill pass. In `project-setup`, the SDD chain block (7 lines), Impact Report (11 lines), Example (7 lines), and Step 6 footer (2 lines) all had compressible verbose phrasing that could be tightened without losing meaning. Pairing 4 additions with 13 lines of trims brought a 213-line file to exactly 200 — resolving a pre-existing violation as a bonus.

### Why It Matters
Avoids the spiral where every edit needs a separate compress-skill invocation, and avoids accumulating "pre-existing violations" as technical debt. The trade-off: only applicable when the file has compressible content nearby. If the file is genuinely lean, escalate to `split-skill` instead.

### Revisit When
- A skill stays over 200 lines after a feature edit despite trim attempts — escalate to `split-skill`.
- Multiple pre-existing violations accumulate — run a focused `improve-skills` pass.
