# GitHub Repo Research — Community Skill Patterns

This file synthesizes best practices and structural patterns from the top public agent skill repositories. Read this when grounding a new skill in community standards, learning from proven patterns, or when the user asks to create a skill inspired by top public repos.

**Canonical repos to draw from:**
- [`anthropics/skills`](https://github.com/anthropics/skills) — 69k+ stars, Claude-optimized reference skills
- [`openai/skills`](https://github.com/openai/skills) — Official Codex skills catalog with curated + experimental collections
- [`warpdotdev/oz-skills`](https://github.com/warpdotdev/oz-skills) — Warp's curated, parameterized, CLI-first skills
- [`github/awesome-copilot`](https://github.com/github/awesome-copilot) — Community-contributed Copilot skills
- [`skills.sh`](https://skills.sh) — Cross-platform community registry

---

## Pattern 1: The Minimal Viable Skill (anthropics/skills)

The most effective skills from the Anthropic repo are short, focused, and jump straight to what the agent wouldn't know on its own.

**Anti-pattern** (too verbose):
```markdown
## Extract PDF text

PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. pdfplumber is recommended because it handles most cases well.
```

**Best practice** (jumps to domain-specific knowledge):
```markdown
## Extract PDF text

Use pdfplumber for text extraction. For scanned documents, fall back to
pdf2image with pytesseract.

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Key takeaway:** If the agent already knows it, cut it. Only include what the agent would get wrong without the skill.

---

## Pattern 2: The Curated Codex Skill (openai/skills)

The `openai/skills` repo uses two tiers: `.curated` (stable, install by name) and `.experimental` (cutting-edge, install by folder URL). Apply this pattern for skill libraries:

**Curated tier** — installable by name, high quality bar:
```bash
$skill-installer gh-address-comments
```

**Experimental tier** — installable by folder URL, lower stability expectation:
```bash
$skill-installer install https://github.com/openai/skills/tree/main/skills/.experimental/create-plan
```

**The `gh-address-comments` skill pattern** (most popular Codex curated skill):
- Reads open PR comments automatically
- Groups comments by file and line range
- Proposes code changes addressing each comment
- Outputs a summary of what was changed and why

**The `create-plan` skill pattern** (experimental):
- Takes ambiguous task description as input
- Decomposes into atomic, testable subtasks
- Outputs a structured plan with acceptance criteria per step
- Asks for confirmation before executing

**Key takeaway for Codex skills:** Include `agents/openai.yaml` with `allow_implicit_invocation: false` for any skill that has side effects. Users should explicitly invoke dangerous or irreversible operations.

---

## Pattern 3: Parameterized CLI Skills (warpdotdev/oz-skills)

Warp's oz-skills collection uses argument placeholders extensively for reusability:

**Example: Deploy skill with environment argument**
```markdown
---
name: deploy
description: Deploy the application to a target environment. Use when the user
  asks to deploy, push to staging, push to production, or release the app.
---

## Deploy

Deploy to `$ARGUMENTS[1]` environment (default: staging if not specified).

1. Run pre-deploy checks: `./scripts/pre-deploy.sh $ARGUMENTS[1]`
2. Build: `npm run build:$ARGUMENTS[1]`
3. Deploy: `./scripts/deploy.sh $ARGUMENTS[1]`
4. Smoke test: `./scripts/smoke-test.sh $ARGUMENTS[1]`
```

**Invoked as:**
- `/deploy` → deploys to staging (default)
- `/deploy prod` → deploys to production
- `/deploy staging focus on the auth service` → additional context via `$ARGUMENTS`

**Key argument variables:**
- `$ARGUMENTS` — Full string after skill name
- `$ARGUMENTS[1]`, `$ARGUMENTS[2]` — Positional arguments
- `$1` — Shorthand for `$ARGUMENTS[1]`

**Key takeaway:** Parameterize anything that changes per-invocation. This turns a single skill into a template for many situations.

---

## Pattern 4: The Gotchas Section (agentskills.io community)

The highest-value content in production skills is a **Gotchas** section listing environment-specific facts that defy reasonable assumptions. These are the concrete corrections to mistakes the agent will make without being told.

```markdown
## Gotchas

- The `users` table uses soft deletes. All queries must include
  `WHERE deleted_at IS NULL` or they will include deactivated accounts.

- The user ID is `user_id` in the database, `uid` in the auth service,
  and `accountId` in the billing API. All three refer to the same entity.

- The `/health` endpoint returns 200 as long as the web server is running,
  even if the database connection is down. Use `/ready` for full-service health.

- This API rate-limits to 100 requests/minute per IP. Always implement
  exponential backoff. Do not use a fixed sleep — it causes thundering herd.
```

**Rules for gotchas:**
- Keep in SKILL.md (not references/) — agent must see them before encountering the situation
- Make each gotcha specific and actionable, not general advice
- Format as a bulleted list for scanability
- One gotcha per bullet — no compound bullets

---

## Pattern 5: First-Person Instructions (community best practice)

From analysis of top-performing skills in the community, first-person instruction framing produces more reliable agent behavior:

**Fragile (third-person):**
```markdown
The agent should ask the user for clarification.
```

**Robust (first-person with the user):**
```markdown
Ask me to clarify which environment before proceeding.
```

**Rationale:** First-person framing matches how the agent reads and interprets the skill — as instructions it is following, not instructions about some other agent.

---

## Pattern 6: Description-First Activation (all repos)

Analysis of top skills across all repos shows a clear pattern for high-quality `description` fields:

**Poor description (won't activate correctly):**
```yaml
description: Helps with database stuff.
```

**Good description (rich activation surface):**
```yaml
description: >
  Query and analyze data in BigQuery datasets using the bq CLI. Load when the
  user asks to query BigQuery, run a BigQuery job, analyze data in a GCP dataset,
  write SQL for BigQuery, or investigate BigQuery query performance. Also triggers
  on "bq query", "BigQuery error", "run this SQL in BigQuery", or any mention of
  BigQuery tables, datasets, or projects. Handles query optimization, cost
  estimation, schema inspection, and result formatting as markdown tables.
```

**Formula from community analysis:**
1. Core capability (verb + object)
2. Primary trigger phrases ("Load when...")
3. Secondary trigger phrases ("Also triggers on...")
4. Output types the skill produces

---

## Pattern 7: The Skill Stacking Pattern

Multiple skills can co-activate when a query matches several descriptions. Design skills to compose well:

**Example stack from community:**
```
User: "Research our competitors and create a presentation"
→ research-assistant skill activates (web research)
→ presentation-creator skill activates (slide generation)
→ Output of research feeds into presentation creation
```

**Design rules for stackable skills:**
- Each skill handles exactly one coherent job
- Skills are stateless — no assumption about which other skills are active
- Output format of skill A should be compatible as input to skill B
- Never build a skill that tries to do what another skill already does

---

## Pattern 8: The Plan-Validate-Execute Pattern (openai/skills + anthropics/skills)

For batch or destructive operations, the best public skills follow a three-phase safety pattern:

```markdown
## [Dangerous Operation] Workflow

1. **Plan** — Generate `operation_plan.json` with every intended change listed
2. **Validate** — Run `python scripts/validate_plan.py operation_plan.json`
   - If validation fails: read stderr, fix the plan, re-validate
   - Do NOT proceed to Execute until validation exits 0
3. **Confirm** — Present plan summary, ask for explicit "yes" before executing
4. **Execute** — Run `python scripts/execute_plan.py operation_plan.json`
5. **Verify** — Run the same check from Step 1, confirm desired state achieved
```

**The key ingredient:** Step 2 validation script outputs actionable error messages that let the agent self-correct without human intervention.

---

## Pattern 9: Using `$skill-installer` as a Meta-Pattern

Codex's built-in `$skill-creator` is itself a skill. This meta-pattern — skills that create or manage other skills — is emerging across the community:

**Meta-skill patterns observed:**
- **Skill Creator** (`openai/skills`, `ampcode`) — Creates new skills from conversation
- **Skill Updater** — Refines existing skills after real-world execution
- **Skill Discoverer** — Finds and installs relevant skills from the registry
- **Skill Auditor** — Reviews existing skills for anti-patterns and improvements

When building a meta-skill (skill creator), the skill itself must follow all the same quality standards as the skills it creates.

---

## Pattern 10: Script Bundling Threshold (agentskills.io best practice)

When to move logic from inline instructions to a bundled `scripts/` file:

**Keep in SKILL.md instructions:**
- One-line commands the agent can construct from context
- Decisions that require understanding the task context
- Choices between 2-3 clear alternatives

**Move to `scripts/`:**
- Logic the agent re-invents identically across multiple runs
- Validation logic that needs to be deterministic
- Complex parsing or transformation of structured data
- Any operation where reliability matters more than flexibility

**Signal from community:** If you see the agent making the same mistake on step N across 3+ runs, that's a signal to write a script that enforces the correct behavior mechanically.

---

## Top Community Skills Worth Studying

| Skill | Source Repo | Key Pattern |
|-------|------------|-------------|
| `gh-address-comments` | openai/skills | PR comment grouping + code change workflow |
| `create-plan` | openai/skills | Task decomposition with acceptance criteria |
| `weekly-update` | sohamkamani/weekly-update-skill-demo | Git commit analysis → structured report |
| `bigquery` | ampcode skills | CLI tool expertise + schema inspection |
| `web-browser` | ampcode skills | Chrome DevTools Protocol integration |
| `agent-sandbox` | ampcode skills | Isolated execution environment pattern |
| `check-broken-links` | agentskills.io docs | Script bundling + validation loop |
| `db-migrate` | community | Plan-validate-execute safety pattern |
| `conventional-commits` | community | Format enforcement + gotchas |
| `code-review-crsp` | community | Structured analysis with scope constraints |

To study any of these, search GitHub for `SKILL.md` + skill name.
