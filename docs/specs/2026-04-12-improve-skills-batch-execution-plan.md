# Improve-Skills Batch Execution Plan

**Date:** 2026-04-12
**Status:** Ready for execution
**Pre-flight:** Complete (all 10 skills analyzed, rubric reviewed)
**Rubric:** `.agents/skills/validate-skills/references/validation-rubric.md`
**Gold standard reference:** adversarial-hat (14/14, 162 lines)

---

## How to Use This Plan

Tell the agent:
> "Execute the improve-skills batch plan at `docs/specs/2026-04-12-improve-skills-batch-execution-plan.md`. Start with Skill 1 and work through all 10 in order."

Or for a specific skill:
> "Execute Skill 3 from the improve-skills batch plan at `docs/specs/2026-04-12-improve-skills-batch-execution-plan.md`."

After all 10 skills are done, execute the Post-Batch Steps at the bottom.

---

## Execution Order

| # | Skill | File | Current | Target | Action |
|---|-------|------|---------|--------|--------|
| 1 | agent-creator | `.agents/skills/agent-creator/SKILL.md` | 262 lines, 12/14 | ≤200 lines, 13+/14 | Compress (P0) |
| 2 | agent-system-architecture | `.agents/skills/agent-system-architecture/SKILL.md` | 92 lines, 8/14 | ≤150 lines, 12+/14 | Add Gotchas + Examples |
| 3 | architectural-decision-log | `.agents/skills/architectural-decision-log/SKILL.md` | 86 lines, 8/14 | ≤150 lines, 12+/14 | Narrow role + add Gotchas + Examples |
| 4 | generate-changelog | `.agents/skills/generate-changelog/SKILL.md` | 92 lines, 8/14 | ≤150 lines, 12+/14 | Narrow role + add Gotchas + Examples |
| 5 | technical-debt-audit | `.agents/skills/technical-debt-audit/SKILL.md` | 91 lines, 8/14 | ≤150 lines, 12+/14 | Narrow role + add Gotchas + Examples |
| 6 | implementation-plan | `.agents/skills/implementation-plan/SKILL.md` | 101 lines, 9/14 | ≤150 lines, 11+/14 | Sharpen Gotchas + add Examples |
| 7 | test-driven-development | `.agents/skills/test-driven-development/SKILL.md` | 95 lines, 9/14 | ≤150 lines, 11+/14 | Sharpen Gotchas + add Examples |
| 8 | secure-skill-content-sanitization | `.agents/skills/secure-skill-content-sanitization/SKILL.md` | 155 lines, 11/14 | ≤180 lines, 13+/14 | Add Impact Report |
| 9 | secure-skill-repo-ingestion | `.agents/skills/secure-skill-repo-ingestion/SKILL.md` | 166 lines, 11/14 | ≤180 lines, 13+/14 | Add Impact Report + wrap Examples |
| 10 | secure-skill-runtime | `.agents/skills/secure-skill-runtime/SKILL.md` | 173 lines, 11/14 | ≤180 lines, 13+/14 | Add Impact Report |

---

## Skill 1 — agent-creator (P0: COMPRESS)

**File:** `.agents/skills/agent-creator/SKILL.md`
**Problem:** 262 lines — 62 lines over the 200-line limit.
**Root cause:** Step 4 has three separate topology templates (parallel/sequential/hierarchical) that repeat the same structure, plus two full examples that repeat template content.

### Exact Changes

#### Change 1: Replace Step 4 (lines 86–139) with consolidated template

Replace the three separate topology blocks with ONE universal template:

```markdown
### Step 4 — Spawn Instructions

Output structured spawn instructions. Do NOT generate code.

```
SPAWN SUBAGENTS:
Topology: [parallel | sequential | hierarchical]

Agent: <name>
Role prompt: docs/agents/<name>-prompt.md
Input: <source — task-input.md or prior agent output>
Output to: docs/handoffs/<name>-output.md

[Repeat for each agent]
```

**Topology rules:**
- **Parallel:** All agents receive same input, run concurrently. Wait for all before proceeding.
- **Sequential:** Chain outputs — Agent N's output becomes Agent N+1's input.
- **Hierarchical:** First agent is orchestrator with explicit sub-agent dispatch in its prompt.
```

This replaces ~54 lines with ~16 lines.

#### Change 2: Replace two examples (lines 177–248) with one compact example

Keep only the parallel example, make it compact:

```markdown
## Examples

<examples>
  <example>
    <input>Architecture: proc-2026-04-11-012 (3 parallel agents: review-agent, security-agent, debt-agent). Platform: Ampcode. setup-evaluation: PASS. All prompt files present.</input>
    <output>
Preconditions: ✓ Arch spec ✓ setup-evaluation PASS ✓ All prompts present
Platform: Ampcode (Task tool)
Manifest written: docs/agents/runs/2026-04-11-review-pipeline-manifest.md

SPAWN SUBAGENTS:
Topology: parallel

Agent: review-agent
Role prompt: docs/agents/review-agent-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/review-agent-output.md

Agent: security-agent
Role prompt: docs/agents/security-agent-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/security-agent-output.md

Agent: debt-agent
Role prompt: docs/agents/debt-agent-prompt.md
Input: docs/handoffs/task-input.md
Output to: docs/handoffs/debt-agent-output.md

Run all agents concurrently via Task tool. Wait for all outputs.
Monitoring docs/handoffs/...
    </output>
  </example>
</examples>
```

This replaces ~72 lines with ~28 lines.

#### Change 3: Compact Step 5 failure handling (lines 141–158)

Replace the detailed sub-bullets with:

```markdown
### Step 5 — Monitor and Hand Off

Poll docs/handoffs/ for output files:
- Present and non-empty → agent complete
- Empty or error → agent failed

**On failure:** Retry once via Task tool. If retry fails → write `docs/handoffs/<name>-FAILED.md`. Blocking agent failure (sequential dependency) → halt, surface to user. Non-blocking → continue, note in Impact Report.

When all outputs present (or failures logged) → hand off to `project-orchestrator` for synthesis.
```

This replaces ~18 lines with ~8 lines.

**Do NOT change:** Frontmatter, Hard Rules, Steps 0-3, Gotchas, Impact Report.

**Expected result:** ~175-185 lines.

### Verification
After edit: count lines (`wc -l` or equivalent). Must be ≤200.

---

## Skill 2 — agent-system-architecture

**File:** `.agents/skills/agent-system-architecture/SKILL.md`
**Problem:** Missing Gotchas section (score 0/2), Missing Examples section (score 0/2).

### Exact Changes

#### Change 1: Insert Gotchas section before Impact Report

Insert BEFORE `## Impact Report` (currently line 82):

```markdown
## Gotchas

- Shared-blackboard state creates hidden coupling — agents reading stale state produce cascading errors that look like logic bugs. Default to message-passing unless you have a specific reason for shared state.
- "Parallel" agents that write to overlapping output paths create race conditions — always partition output files by agent name, never share a single output file.
- Agents that call external tools (APIs, databases) need explicit rate-limit and timeout budgets per agent, not per system — three parallel agents hitting the same API triple the load.
- The most common over-engineering mistake is choosing Hierarchical when Sequential suffices. Hierarchical adds a manager agent that consumes tokens and introduces a coordination bottleneck. Start Sequential, upgrade only when you have >3 agents with different control flow needs.

---
```

#### Change 2: Insert Examples section before Impact Report

Insert after the Gotchas section, before `## Impact Report`:

```markdown
## Example

<examples>
  <example>
    <input>Design a multi-agent system for automated PR review that checks code quality, security vulnerabilities, and test coverage in parallel.</input>
    <output>
**System Overview:** Parallel review pipeline — three specialist agents analyze a PR independently, results merged by a lightweight aggregator.

**Orchestration Pattern:** Concurrent (3 agents share same input, produce independent outputs).

**Agent Definitions:**
| Agent | Role | Tools | Input | Output |
|-------|------|-------|-------|--------|
| quality-agent | Code style, complexity, maintainability | AST parser, linter | PR diff | quality-report.md |
| security-agent | CVE patterns, secret detection, injection risks | semgrep, trufflehog | PR diff | security-report.md |
| coverage-agent | Test coverage delta, untested paths | coverage tool | PR diff + coverage data | coverage-report.md |

**Wiring:** Message-passing. Each agent receives the PR diff as input. No inter-agent communication. Aggregator collects all three reports.

**State & Memory:** Stateless per run. No cross-PR memory. Each agent reads only its input file.

**Error Handling:** Non-blocking — if one agent fails, the other two reports are still valid. Aggregator notes the gap. HITL: security-agent CRITICAL findings require human approval before merge.

Architecture designed: pr-review-pipeline
Pattern chosen: Concurrent
Number of agents: 3 + aggregator
Coordination complexity: Low
Observability strategy: Token usage + latency per agent logged to manifest
Ready for: implementation-plan
    </output>
  </example>
</examples>

---
```

**Do NOT change:** Frontmatter, role definition, Hard Rules, Workflow, Output Format.

**Expected result:** ~135-145 lines.

---

## Skill 3 — architectural-decision-log

**File:** `.agents/skills/architectural-decision-log/SKILL.md`
**Problem:** Role slightly broad (1/2), Missing Gotchas (0/2), Missing Examples (0/2).

### Exact Changes

#### Change 1: Narrow the role (line 20)

Replace:
```
You are a Technical Architect. You ensure that every critical decision is documented with its context, alternatives, and trade-offs. You believe that "the 'why' is more important than the 'what'."
```

With:
```
You are an Architectural Decision Recorder. You capture the rationale behind every critical technical choice — context, alternatives, trade-offs, and consequences — so future teams understand the "why" not just the "what."
```

#### Change 2: Insert Gotchas section before Impact Report

Insert BEFORE `## Impact Report` (currently line 76):

```markdown
## Gotchas

- The highest-value ADR content is the rejected alternatives with rejection reasons — not the chosen option. Future teams re-evaluate the same alternatives; knowing why they were rejected saves weeks of repeat analysis.
- ADRs written retrospectively produce confabulated reasoning. Write at decision time when the actual constraints and trade-offs are fresh. A rough ADR today beats a polished one written from memory next month.
- "Accepted" is not permanent. Every ADR must have a status field (Proposed/Accepted/Deprecated/Superseded) and superseded ADRs must link forward to their replacement. Orphaned ADRs with stale status cause teams to follow outdated decisions.

---
```

#### Change 3: Insert Examples section before Impact Report

Insert after Gotchas, before `## Impact Report`:

```markdown
## Example

<examples>
  <example>
    <input>We just decided to use SQLite instead of PostgreSQL for our internal tool. Record this as an ADR.</input>
    <output>
**ADR-005: Use SQLite for Internal Tool Database**
**Date:** 2026-04-12 | **Status:** Accepted

**Context:**
The tool is single-user, deployed locally, with <10K records. We need a database that requires zero infrastructure setup and ships as a single file for easy backup and portability.

**Decision:**
Use SQLite as the primary database via sync SQLAlchemy.

**Alternatives Considered:**
- **PostgreSQL:** Full ACID, rich query support, excellent tooling. Rejected: requires a running server process, Docker or system install, connection management — all unnecessary overhead for a single-user local tool.
- **JSON flat files:** Zero dependencies, human-readable. Rejected: no query capability, no schema enforcement, concurrent write corruption risk, does not scale past ~1K records without performance degradation.

**Consequences:**
- ✅ Zero infrastructure — database is a single `.db` file
- ✅ No connection pooling, no server process, instant setup
- ⚠️ No concurrent write support — acceptable for single-user but blocks future multi-user
- ⚠️ Limited full-text search — may need FTS5 extension if search becomes critical
- 🔄 If we ever need multi-user, this decision must be superseded (migration to PostgreSQL)

ADR recorded: ADR-005: Use SQLite for Internal Tool Database
Number: 005
Status: Accepted
Alternatives considered: 2
Critical consequences: No concurrent writes, limited FTS
Ready for: implementation
    </output>
  </example>
</examples>

---
```

**Expected result:** ~135-145 lines.

---

## Skill 4 — generate-changelog

**File:** `.agents/skills/generate-changelog/SKILL.md`
**Problem:** Role slightly broad (1/2), Missing Gotchas (0/2), Missing Examples (0/2).

### Exact Changes

#### Change 1: Narrow the role (line 21)

Replace:
```
You are a Release Engineer. You synthesize raw commit history into clear, value-driven release notes. You focus on *what changed* and *why it matters* to the user, not just the technical details.
```

With:
```
You are a Changelog Author. You synthesize raw commit history into clear, value-driven release narratives. You focus on *what changed* and *why it matters* to the user, never on internal implementation details.
```

#### Change 2: Insert Gotchas section before Impact Report

Insert BEFORE `## Impact Report` (currently line 82):

```markdown
## Gotchas

- Agents default to listing every commit verbatim — this produces noise, not a changelog. Group 5-15 related commits into one user-facing change with a value statement.
- Breaking changes buried under "Changed" get missed by users. They must be the FIRST section with a 🚨 prefix, even if there is only one.
- Internal refactors, dependency bumps, and CI fixes are not user-facing changes. Omit them from user-facing changelogs entirely — they belong in internal release notes only.

---
```

#### Change 3: Insert Examples section before Impact Report

Insert after Gotchas, before `## Impact Report`:

```markdown
## Example

<examples>
  <example>
    <input>Generate a changelog for the agent-loom skill library. Recent changes: renamed agent-architect to agent-builder across 8 files, created cross-link-skills skill, created living PRD at docs/prd/PRD.md, updated library-skill to maintain PRD and architecture docs, improved 6 skills to 14/14 scores.</input>
    <output>
## [0.4.0] - 2026-04-12

**Summary:** Major structural improvements — the skill library now self-maintains its own documentation, skills are cross-linked automatically, and the first living PRD establishes a single source of truth for the project.

### 🚨 Breaking Changes
- **Renamed `agent-architect` → `agent-builder`** — update any references in custom workflows or prompts.

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
```

**Expected result:** ~140-150 lines.

---

## Skill 5 — technical-debt-audit

**File:** `.agents/skills/technical-debt-audit/SKILL.md`
**Problem:** Role slightly broad (1/2), Missing Gotchas (0/2), Missing Examples (0/2).

### Exact Changes

#### Change 1: Narrow the role (line 20)

Replace:
```
You are a Quality Engineer. You believe that "debt is fine, as long as you know the interest rate." You identify code smells, architectural hacks, and missing tests to create a clear refactoring roadmap.
```

With:
```
You are a Technical Debt Analyst. You believe "debt is fine, as long as you know the interest rate." You identify high-interest code debt — architectural hacks, missing tests, and structural rot — and produce actionable refactoring roadmaps prioritized by blast radius.
```

#### Change 2: Insert Gotchas section before Impact Report

Insert BEFORE `## Impact Report` (currently line 79):

```markdown
## Gotchas

- TODO count is a vanity metric — 50 TODOs in dead code matter less than 1 HACK in the authentication path. Weight findings by blast radius (how many features break if this debt compounds), not by count.
- Agents over-report cosmetic debt (naming, formatting, comment style) and under-report structural debt (circular dependencies, missing abstractions, god objects). Prioritize structural debt that blocks feature velocity over cosmetic issues that only affect readability.
- "Refactor everything" is not a roadmap. Each high-interest item needs a specific, time-boxed remediation task (e.g., "Extract auth logic from UserController into AuthService — 2h estimate") not a vague directive.

---
```

#### Change 3: Insert Examples section before Impact Report

Insert after Gotchas, before `## Impact Report`:

```markdown
## Example

<examples>
  <example>
    <input>Run a tech debt audit on the agent-loom skill library.</input>
    <output>
**Technical Debt Audit: agent-loom**
**Date:** 2026-04-12 | **Health Score:** 7/10

**The "Big 3" (High-Interest Items):**
1. **agent-creator at 262 lines** — 62 lines over the 200-line limit. Blocks validation pipeline. Blast radius: every improve-skills run flags this as a failure. Fix: compress topology templates and consolidate examples. Effort: 30min.
2. **10 skills below 10/14 score** — missing Gotchas and Examples sections. These skills produce lower-quality agent behavior because the agent has no failure-mode awareness or output examples to pattern-match against. Fix: batch improvement pass. Effort: 2h.
3. **No automated validation in CI** — skill quality is manually checked. Regressions can slip in silently. Fix: add validate-skills as a pre-commit hook. Effort: 1h.

**Debt Catalog:**
| Item | Quadrant | Interest | Location |
|------|----------|----------|----------|
| Oversized agent-creator | Prudent/Deliberate | High | `.agents/skills/agent-creator/SKILL.md` |
| Missing structural sections | Prudent/Inadvertent | High | 10 skills (see queue) |
| No CI validation | Prudent/Inadvertent | Medium | repo root |
| Stale cross-references | Reckless/Inadvertent | Low | various SKILL.md files |

**Recommended Next Actions:**
1. Compress agent-creator (30min)
2. Run improve-skills batch on 10-skill queue (2h)
3. Add validate-skills to pre-commit (1h)

Audit complete: agent-loom
Health score: 7/10
High-interest items found: 3
Total TODOs/FIXMEs: 0
Refactoring roadmap created: yes
Ready for: improve-skills batch execution
    </output>
  </example>
</examples>

---
```

**Expected result:** ~145-155 lines.

---

## Skill 6 — implementation-plan

**File:** `.agents/skills/implementation-plan/SKILL.md`
**Problem:** Missing Examples (0/2), Gotchas scored 1/2 (generic).

### Exact Changes

#### Change 1: Sharpen existing Gotchas (lines 73-76)

Replace:
```markdown
## Gotchas

- A plan is not a PRD. Focus on *how*, not *what*.
- Don't over-engineer Phase 1. Keep it focused on the "Happy Path."
- Always include a "Rollback Plan" or "Feature Flag" task for high-risk changes.
```

With:
```markdown
## Gotchas

- A plan is not a PRD — if you catch yourself writing user stories or success metrics, stop. Plans define tasks, dependencies, and verification steps, not product requirements.
- Phase 1 must be demoable. If the MVP phase cannot produce a working demo (even ugly), the scope is wrong. Cut until it is demoable, then move cuts to Phase 2.
- Agents underestimate integration tasks. "Connect to API X" is not one task — it is auth setup + client creation + error handling + retry logic + testing. Decompose integration work into at least 3 subtasks.
- Every task needs a concrete Definition of Done, not "it works." Bad: "Implement auth." Good: "User can log in with email/password, receives JWT, invalid credentials return 401."
```

#### Change 2: Insert Examples section after Gotchas, before Output Format

Insert BEFORE `## Output Format` (currently line 79):

```markdown
## Example

<examples>
  <example>
    <input>Create an implementation plan for adding voice narration to our video generation pipeline. We have scripts as markdown, need to convert to audio using ElevenLabs API.</input>
    <output>
**Implementation Plan: Voice Narration Pipeline**

**Technical Stack:** Python, ElevenLabs API, FFmpeg (format conversion), local file storage

**Architecture:** New NarrationAgent extending BaseAgent. Input: script markdown. Output: MP3 audio file + metadata JSON.

**Phase 0 — Prerequisites (2 tasks)**
- [ ] Obtain ElevenLabs API key, add to `.env`, verify quota limits. **DoD:** API key works in a standalone curl test.
- [ ] Add `elevenlabs` Python package to `requirements.txt`, install. **DoD:** `import elevenlabs` succeeds.

**Phase 1 — Core MVP (3 tasks)**
- [ ] Create `agents/narration/agent.py` extending BaseAgent with `chat()` and `generate()`. **DoD:** Agent loads via AgentRegistry, responds to basic chat.
- [ ] Implement `generate()`: parse script markdown → extract narration text → call ElevenLabs API → save MP3 to `storage/narration/<video-id>/`. **DoD:** Given a test script, produces a playable MP3 file.
- [ ] Create narration API endpoint `POST /api/narration/generate`. **DoD:** Curl request with script ID returns 200, audio file exists on disk.

**Phase 2 — Refinement (3 tasks)**
- [ ] Add voice selection (voice ID parameter). **DoD:** Different voice IDs produce audibly different output.
- [ ] Add error handling: API rate limits (retry with backoff), invalid scripts (return 422), network failures (timeout after 30s). **DoD:** Each error case returns appropriate error message.
- [ ] Add progress tracking: emit status updates during long generation. **DoD:** Frontend can poll for generation status.

**Phase 3 — Testing (2 tasks)**
- [ ] Unit tests for script parsing and API response handling (mock ElevenLabs). **DoD:** `pytest tests/narration/` passes, ≥80% coverage.
- [ ] Integration test: end-to-end script → audio with real API call. **DoD:** Test produces valid MP3, runs in <30s.

**Risks:**
1. ElevenLabs API latency (10-30s per generation) — Mitigation: async generation with status polling, not synchronous request.
2. API quota exhaustion during batch generation — Mitigation: implement queue with rate limiting, show quota usage in UI.

**Estimated effort:** M (3-5 days)

Plan complete: Voice Narration Pipeline
Phases defined: 4
Total tasks: 10
Critical risks identified: 2
Estimated effort: M
Ready for: engineering execution
    </output>
  </example>
</examples>

---
```

**Do NOT change:** Frontmatter, role definition, Hard Rules, Workflow, Output Format, Impact Report.

**Expected result:** ~155-165 lines.

---

## Skill 7 — test-driven-development

**File:** `.agents/skills/test-driven-development/SKILL.md`
**Problem:** Missing Examples (0/2), Gotchas scored 1/2 (generic).

### Exact Changes

#### Change 1: Sharpen existing Gotchas (lines 69-72)

Replace:
```markdown
## Gotchas

- Don't test the framework or language. Test the business logic.
- Keep tests isolated. One test should not depend on the state of another.
- If a test is hard to write, the code is likely too coupled. Use this as a signal to refactor the architecture.
```

With:
```markdown
## Gotchas

- Agents skip Red — they jump straight to writing code and tests together. Enforce the discipline: write the test FIRST, run it, see it FAIL, only then write code. The failure message confirms you are testing the right thing.
- "Test the framework" is the #1 agent mistake. Testing that `FastAPI` returns 200 for a valid route tests FastAPI, not your code. Test the business logic the route calls, not the HTTP plumbing.
- Agents write one giant test per feature instead of many small tests. Each test should verify exactly one behavior. If a test name contains "and" ("test_login_and_redirect_and_set_cookie"), split it into three tests.
- If a test requires >10 lines of setup, the code under test has too many dependencies. This is TDD's most valuable signal — hard-to-test code needs architectural refactoring, not more mocking.
```

#### Change 2: Insert Examples section after Gotchas, before Output Format

Insert BEFORE `## Output Format` (currently line 76):

```markdown
## Example

<examples>
  <example>
    <input>TDD a function that calculates the "interest rate" of a technical debt item based on its blast radius and frequency of encounters.</input>
    <output>
**Target Feature:** `calculate_debt_interest(blast_radius: int, encounter_frequency: int) -> str`

**Red Phase — Test 1: Basic classification**
```python
def test_high_interest_when_high_blast_and_frequent():
    assert calculate_debt_interest(blast_radius=8, encounter_frequency=5) == "high"
```
Run: ❌ `NameError: name 'calculate_debt_interest' is not defined` — correct failure.

**Green Phase — Minimal implementation**
```python
def calculate_debt_interest(blast_radius: int, encounter_frequency: int) -> str:
    score = blast_radius * encounter_frequency
    if score >= 20:
        return "high"
    return "low"
```
Run: ✅ Test passes.

**Red Phase — Test 2: Medium classification**
```python
def test_medium_interest_when_moderate_score():
    assert calculate_debt_interest(blast_radius=3, encounter_frequency=3) == "medium"
```
Run: ❌ `AssertionError: 'low' != 'medium'` — correct failure.

**Green Phase — Add medium tier**
```python
def calculate_debt_interest(blast_radius: int, encounter_frequency: int) -> str:
    score = blast_radius * encounter_frequency
    if score >= 20:
        return "high"
    if score >= 8:
        return "medium"
    return "low"
```
Run: ✅ Both tests pass.

**Refactor Phase:** Extracted threshold constants, added docstring. All tests still green.

TDD session complete: calculate_debt_interest
Tests written: 2 (+ 1 edge case for score=0)
Code coverage achieved: 100%
Refactorings performed: 1 (extract constants)
Status: Green (All tests passing)
Ready for: code review
    </output>
  </example>
</examples>

---
```

**Expected result:** ~150-160 lines.

---

## Skill 8 — secure-skill-content-sanitization

**File:** `.agents/skills/secure-skill-content-sanitization/SKILL.md`
**Problem:** Missing `## Impact Report` section. Has `## Report Format` and `## Examples` — both are fine. Just needs the standard Impact Report section at the end.
**Constraint:** secure-* skill — never compress, split at 180 lines. Currently 155 lines.

### Exact Changes

#### Change 1: Add Impact Report section at end of file

Append after the closing `</examples>` tag (line 155):

```markdown

---

## Impact Report

After completing, always report:
```
Content sanitization: [source file or directory]
Files processed: [N]
Checks run: 13 (Hidden Content), 14 (Markdown), 15 (Unicode)
Findings: [N critical, N high, N medium]
Sanitization applied: [HTML stripped / unicode normalized / comments extracted / none]
Verdict: [SAFE / BLOCKED / REQUIRES REVIEW]
```
```

**Expected result:** ~167 lines (within 180-line limit).

---

## Skill 9 — secure-skill-repo-ingestion

**File:** `.agents/skills/secure-skill-repo-ingestion/SKILL.md`
**Problem:** Missing `## Impact Report` section. Has `## Report Format` but no standard Impact Report. Also, examples exist in the checks but there is no formal `## Examples` section with `<examples>` XML tags.
**Constraint:** secure-* skill — never compress, split at 180 lines. Currently 166 lines.

### Exact Changes

This skill is at 166 lines and needs both an Impact Report (~10 lines) and formal Examples (~15 lines minimum). Adding both would push it to ~191 lines, over the 180-line limit.

**Decision:** Add only the Impact Report section (the higher-scoring gap). The inline examples within each check (lines 53-58, 78-83, etc.) provide sufficient example coverage — they are realistic and complete. Wrapping them in `<examples>` tags would exceed 180 lines.

#### Change 1: Add Impact Report section at end of file

Append after `VERDICT: [SAFE / BLOCKED / REQUIRES REVIEW]` closing block (line 166):

```markdown

---

## Impact Report

After completing, always report:
```
Repo ingestion audit: [repo URL or name]
Files scanned: [N] | Skipped: [N]
Checks run: 7 (Poisoned Examples), 8 (Dependencies), 9 (File/Path), 10 (Format)
Findings: [N critical, N high, N medium]
Quarantine status: [CLEAR / HELD]
Verdict: [SAFE / BLOCKED / REQUIRES REVIEW]
```
```

**Expected result:** ~178 lines (within 180-line limit).

---

## Skill 10 — secure-skill-runtime

**File:** `.agents/skills/secure-skill-runtime/SKILL.md`
**Problem:** Missing `## Impact Report` section. Has `## Report Format` (line 133) which is correct for the security report output, but needs the standard `## Impact Report` section that other skills have.
**Constraint:** secure-* skill — never compress, split at 180 lines. Currently 173 lines.

### Exact Changes

At 173 lines, adding a full Impact Report would push past 180. Need to be very compact.

#### Change 1: Add compact Impact Report at end of file

Append after closing `</examples>` tag (line 173):

```markdown

---

## Impact Report

```
Runtime audit: [source / context]
Checks: 11 (State Corruption) [N findings], 12 (DoS) [N findings]
No-go list: [CLEAR / MATCHED]
Verdict: [SAFE / BLOCKED / REQUIRES REVIEW]
```
```

**Expected result:** ~180 lines (at the limit).

---

## Post-Batch Steps

Execute these IN ORDER after all 10 skills are improved:

### Step 1 — Validate all 10 skills
For each skill, count lines and verify against limits:
- Standard skills: ≤200 lines
- secure-* skills: ≤180 lines

### Step 2 — Score check
Mentally score each skill against the rubric at `.agents/skills/validate-skills/references/validation-rubric.md`. All should score ≥10/14 (target ≥12/14 for priority queue skills).

### Step 3 — Invoke cross-link-skills
Run the cross-link-skills skill to repair any stale cross-references across all SKILL.md files:
> "Run cross-link-skills on the entire `.agents/skills/` directory."

### Step 4 — Library summary
Run library-skill to sync all library documents:
- `SKILL-INDEX.md`
- `AGENTS.md`
- `README.md`
- `skill-graph.md`
- `docs/prd/PRD.md`
- `docs/architecture.md`

### Step 5 — Generate changelog
Run generate-changelog to document this improvement batch.

### Step 6 — Update shared context
Update `docs/agent-shared-context.md` with the batch results.
Append to `docs/agent-change-log.md` with files touched and status.

### Step 7 — Commit
Stage only the changed SKILL.md files and shared docs. Commit with message:
```
improve-skills: batch improvement of 10 skills (structural gaps)

- Compressed agent-creator from 262 to ≤200 lines
- Added Gotchas + Examples to 6 skills (8-9/14 → 12+/14)
- Added Impact Reports to 3 secure-* skills (11/14 → 13+/14)
- Ran cross-link-skills and library-skill sync
```
