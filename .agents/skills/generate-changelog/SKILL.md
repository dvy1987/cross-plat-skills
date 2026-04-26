---
name: generate-changelog
description: >
  Generate user-facing or internal release notes and changelogs.
  Load when the user prepares a release, tags a version, or wants to
  summarize recent progress. Also triggers on "write a changelog",
  "prepare release notes", "what's new in this version", "summarize my commits",
  or "create a release summary". Auto-triggered by library-skill after major
  repo changes (new skills added, skills renamed, structure changes).
  Applicable to any project, including this skill library itself.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  category: project-specific
  sources: keepachangelog.com, conventionalcommits.org, agentskills.io
  resources:
    references:
      - changelog-template.md
---

# Generate Changelog

You are a Changelog Author. You synthesize raw commit history into clear, value-driven release narratives. You focus on *what changed* and *why it matters* to the user, never on internal implementation details.

## Hard Rules

Never just list commit messages — synthesize them into logical groups.
Never include internal-only changes (e.g., "fixed typo in comment") in a user-facing changelog.
Never skip the "Breaking Changes" section — it's the most important part.
Never mention security findings, fixes, or implementation details in user-facing changelogs or release notes; fold them into safe user-facing functional language when needed.

---

## Workflow

### Step 1 — Gather Recent Changes
Scan the commit history, PRs, and `docs/skill-outputs/SKILL-OUTPUTS.md`.
Identify the time range or version tag to summarize.

### Step 2 — Categorize the Changes
Use the "Keep a Changelog" standard:
- **Added:** For new features.
- **Changed:** For changes in existing functionality.
- **Deprecated:** For soon-to-be removed features.
- **Removed:** For now removed features.
- **Fixed:** For any bug fixes.
- For user-facing outputs in this repo, do not emit a **Security** section; rephrase those items into allowed user-facing categories or omit them if they are purely internal.

### Step 3 — Synthesize the Value
For each major change, write a one-sentence "Value Statement":
- *Instead of:* "Updated auth logic"
- *Write:* "Added biometric login for faster and more secure authentication."

### Step 4 — Draft the Changelog
Follow the schema in `references/changelog-template.md`.
Include:
- **Version & Date** (e.g., [1.2.0] - 2026-04-05).
- **Executive Summary** (One paragraph on the theme of this release).
- **Categorized Sections** (Added, Fixed, etc.).
- **Breaking Changes** (Highlighted at the top).

### Step 5 — Present and Save
Present the changelog summary in chat.

Save to file: `docs/changelogs/vX.X.X.md`
Append to `docs/skill-outputs/SKILL-OUTPUTS.md`:
```markdown
| YYYY-MM-DD HH:MM | generate-changelog | docs/changelogs/vX.X.X.md | Changelog: vX.X.X |
```

---

## Output Format

**Release Notes / Changelog:**
1. **Version [X.X.X] - YYYY-MM-DD**
2. **Summary** (The "Big Idea" of the release)
3. **Breaking Changes** (🚨 Must-read for users)
4. **Added** (New shiny things)
5. **Fixed** (Bug squashing)
6. **Changed/Deprecated/Removed** (Maintenance)

---

## Gotchas

- Agents default to listing every commit verbatim — this produces noise, not a changelog. Group 5-15 related commits into one user-facing change with a value statement.
- Breaking changes buried under "Changed" get missed by users. They must be the FIRST section with a clear prefix, even if there is only one.
- Internal refactors, dependency bumps, and CI fixes are not user-facing changes. Omit them from user-facing changelogs entirely — they belong in internal release notes only.

---

## Example

<examples>
  <example>
    <input>Generate a changelog for the agent-loom skill library. Recent changes: renamed agent-architect to agent-builder across 8 files, created cross-link-skills skill, created living PRD at docs/prd/PRD.md, updated library-skill to maintain PRD and architecture docs, improved 6 skills to 14/14 scores.</input>
    <output>
## [0.4.0] - 2026-04-12

**Summary:** Major structural improvements — the skill library now self-maintains its own documentation, skills are cross-linked automatically, and the first living PRD establishes a single source of truth for the project.

### Breaking Changes
- **Renamed `agent-architect` -> `agent-builder`** — update any references in custom workflows or prompts.

### Added
- **cross-link-skills** — automatically repairs cross-references between SKILL.md files after creation, rename, or removal.
- **Living PRD** (`docs/prd/PRD.md`) — single source of truth for both agents and humans. Point-in-time PRDs are now historical snapshots only.
- **library-skill** now maintains `docs/prd/PRD.md` and `docs/architecture.md` automatically when structural changes occur.

### Changed
- 6 skills improved to perfect 14/14 validation scores (adversarial-hat, code-review-crsp, improve-skills, product-soul, project-orchestrator, validate-skills).

### Fixed
- Stale cross-references from skill renames are now detected and repaired automatically.

Changelog generated: v0.4.0
Changes categorized: 8
Breaking changes found: 1
User-facing value statements: 4
Ready for: release
    </output>
  </example>
</examples>

---

## Impact Report

After completing, always report:
```
Changelog generated: [version]
Changes categorized: [N]
Breaking changes found: [N]
User-facing value statements: [N]
Ready for: release / stakeholder-update
```
