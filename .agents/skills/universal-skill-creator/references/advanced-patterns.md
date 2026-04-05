# Advanced Skill Patterns

This file covers advanced techniques for System and Advanced tier skills: parameterized skills, plan-validate-execute, validation loops, XML Claude tags, Codex `openai.yaml`, Factory frontmatter, skill stacking, Vertex AI translation, and grounding new skills in GitHub repo research. Read this when building a skill that goes beyond a standard SKILL.md.

---

## 1. Parameterized Skills (Warp + Universal)

Parameterized skills use argument placeholders that get substituted at invocation time. This turns one skill into a reusable template.

**Placeholder variables:**
| Variable | Meaning |
|----------|---------|
| `$ARGUMENTS` | Full string after the skill name |
| `$ARGUMENTS[1]` | First whitespace-delimited argument |
| `$ARGUMENTS[2]` | Second argument |
| `$1` | Shorthand for `$ARGUMENTS[1]` |
| `$2` | Shorthand for `$ARGUMENTS[2]` |

**Example: Environment-aware deploy skill**
```markdown
---
name: deploy
description: Deploy to a target environment. Invoke as /deploy [env] where env is
  staging, prod, or local. Defaults to staging if no environment given.
---

Deploy `$ARGUMENTS[1]` (or staging if not specified).

1. Run pre-deploy validation: `./scripts/pre-deploy.sh ${1:-staging}`
2. Build artifact: `npm run build:${1:-staging}`
3. Push to environment: `./scripts/deploy.sh ${1:-staging}`
4. Run smoke tests: `./scripts/smoke-test.sh ${1:-staging}`
5. Report status with: environment name, deploy time, and smoke test results
```

**Best practices:**
- Always provide a default value when `$ARGUMENTS[1]` may be absent
- Document the expected argument format in `description`
- Keep argument semantics simple — no parsing of comma-separated lists

---

## 2. Plan-Validate-Execute Pattern

For batch operations, form filling, database migrations, or any destructive workflow, use this three-phase pattern to give the agent a self-correction loop.

**Template:**
```markdown
## [Operation] Workflow

Progress:
- [ ] Step 1: Generate plan
- [ ] Step 2: Validate plan  
- [ ] Step 3: Execute (only after validation passes)
- [ ] Step 4: Verify result

### Step 1 — Generate Plan

Run: `python scripts/analyze_inputs.py` → outputs `plan.json`

`plan.json` structure:
```json
{
  "operations": [
    {"type": "...", "target": "...", "reversible": true}
  ]
}
```

### Step 2 — Validate Plan

Run: `python scripts/validate_plan.py plan.json`

- Exit 0: proceed to Step 3
- Exit non-zero: read stderr for specific errors, revise `plan.json`, re-run validation
- Do NOT proceed to Step 3 if validation fails

### Step 3 — Execute

Present plan summary to user. Require explicit "yes" before running:
`python scripts/execute_plan.py plan.json`

### Step 4 — Verify

Run the same inspection from Step 1. Confirm that every planned operation now
shows in the "applied" state. Report any discrepancies.
```

**The self-correction requirement:** The validation script in Step 2 must emit actionable error messages. "Field 'delivery_date' not found — available fields: order_date, ship_date, delivery_timestamp" lets the agent fix the plan without human intervention.

---

## 3. Validation Loops

For any multi-step workflow where each step must succeed before the next begins:

```markdown
## Editing Workflow

1. Make edits
2. Run: `python scripts/validate.py output/`
3. If validation fails:
   - Read the error output carefully
   - Fix the specific issue identified
   - Run validation again from step 2
4. Only proceed when validation exits 0
```

**When to use validation loops:**
- Document generation (validate structure, required sections)
- Code generation (run linter/type checker)
- Data transformation (validate schema compliance)
- Form filling (validate all required fields present and correctly typed)

---

## 4. XML Structure Tags for Claude/Ampcode

Claude Code and Ampcode parse XML tags with high fidelity. Use them for complex skills where section separation matters:

**Full XML skill structure:**
```xml
<instructions>
  ## Core Workflow
  
  1. **Analyze**: Read the user's request and identify the core requirement
  2. **Research**: Load relevant reference files only if needed
  3. **Draft**: Generate the output following the Output Format section
  4. **Verify**: Run the self-check before presenting
</instructions>

<thinking>
  Before responding, work through:
  1. What is the user's actual underlying need (not just their stated request)?
  2. Which step of the workflow applies to this request?
  3. Are there any ambiguities that need a single clarifying question?
</thinking>

<examples>
  <example>
    <input>Create a migration to add an email column to the users table</input>
    <output>
      [Complete migration file content here — never truncated]
    </output>
  </example>
</examples>

<constraints>
  - State assumptions explicitly rather than guessing
  - Present complete output, never truncated
  - When multiple approaches are valid, pick one default and note the alternative briefly
</constraints>
```

**Claude-specific frontmatter for CLAUDE.md integration:**
Reference skills explicitly in your project's CLAUDE.md or AGENTS.md:
```markdown
## Skills Available

Specialized skills are in `.claude/skills/`. Key skills:
- `conventional-commits/` — Write conventional commit messages
- `db-migrate/` — Safe database migration workflow
- `code-review/` — Structured PR review
```

---

## 5. Codex `agents/openai.yaml`

The optional `agents/openai.yaml` file in a Codex skill adds UI metadata and policy controls:

```yaml
interface:
  display_name: "Readable Name in Skill Picker"
  short_description: "One-line user-facing summary"
  icon_small: "./assets/icon-16.svg"    # 16x16 SVG for list views
  icon_large: "./assets/icon-128.png"   # 128x128 PNG for detail views
  brand_color: "#3B82F6"               # Hex color for skill card
  default_prompt: "Create a plan for the task I'm about to describe"

policy:
  # Set false for skills with side effects (deploy, delete, send email)
  # User must explicitly invoke with $skill-name — Codex won't auto-pick it
  allow_implicit_invocation: false

dependencies:
  tools:
    - type: "mcp"
      value: "openaiDeveloperDocs"
      description: "OpenAI Docs MCP server"
      transport: "streamable_http"
      url: "https://developers.openai.com/mcp"
    - type: "mcp"
      value: "github"
      description: "GitHub MCP server"
      transport: "streamable_http"
      url: "https://api.githubcopilot.com/mcp/"
```

**When to set `allow_implicit_invocation: false`:**
- Deploy, publish, send, delete, or any operation with external side effects
- Billing or payment operations
- Operations that modify production systems
- Skills that should only run when explicitly requested

---

## 6. Factory.ai Frontmatter Fields

Factory.ai Droids support additional frontmatter fields for invocation control:

```yaml
---
name: deploy
description: Deploy to target environment. Use for explicit deployment requests.
user-invocable: true          # Shows in /slash command menu (default: true)
disable-model-invocation: true  # Droid cannot auto-invoke; user must type /deploy
---
```

**Decision matrix:**
| Situation | `user-invocable` | `disable-model-invocation` |
|-----------|-----------------|--------------------------|
| Normal workflow skill | `true` | `false` |
| Dangerous/side-effect skill | `true` | `true` |
| Background knowledge only | `false` | `false` |

**Companion: AGENTS.md** for Factory.ai projects:
```markdown
# Project Name

## Build & Commands
- Install: `pnpm install`
- Dev server: `pnpm dev`
- Tests: `pnpm test --run`
- Type check: `pnpm check`

## Project Layout
├─ client/    → React frontend
├─ server/    → Express backend
└─ shared/    → Shared utilities

## Development Patterns
- TypeScript strict mode
- Single quotes, trailing commas, no semicolons
- 100-character line limit

## Never
- Never force-push main
- Never commit API keys
- Never skip pnpm check before committing
```

---

## 7. Vertex AI Agent Builder Translation

When deploying to Google Vertex AI Agent Builder, translate SKILL.md workflow to Goal/Steps:

```yaml
displayName: Skill Name
goal: |
  [Combine description + first paragraph of SKILL.md body]
steps:
  - stepId: step1
    description: "[Step 1 from SKILL.md workflow]"
    action:
      searchAction:
        dataStores: ["projects/PROJECT/locations/LOC/collections/default/dataStores/STORE"]
  - stepId: step2
    description: "[Step 2 from SKILL.md workflow]"
    action:
      llmAction:
        model: gemini-1.5-pro
        systemInstruction: "[Relevant section of SKILL.md body]"

safetySettings:
  - category: HARM_CATEGORY_DANGEROUS_CONTENT
    threshold: BLOCK_MEDIUM_AND_ABOVE
confidenceThreshold: 0.7
```

Upload `references/` files to a Vertex AI Data Store for grounding.

---

## 8. Skill Stacking Strategy

Multiple skills can activate simultaneously when one query matches several descriptions. Design for composability:

**Composition rules:**
- Skills must be stateless — no assumption about what other skills are active
- Each skill handles exactly one coherent job (like a well-scoped function)
- Output format of Skill A should be a valid input for Skill B
- Avoid skills that partially overlap in scope (causes conflicting instructions)

**Example composable stack:**
```
User: "Research our top 5 competitors and create a comparison slide deck"

→ research-assistant (web search, data synthesis)
→ presentation-creator (slide generation from structured data)
→ Output: research findings → input: slide content
```

**Anti-pattern: monolithic skills**
```
# BAD: One skill doing too many unrelated things
description: Helps with research, presentations, emails, code review, and deployment
```

**Correct: scoped skills that stack**
```
# GOOD: Three separate skills that activate together
description: Research and synthesize information from web sources...
description: Create slide presentations from structured content or research...
description: Write and send professional emails...
```

---

## 9. Grounding New Skills in GitHub Repo Research

When creating a skill in a domain that already has community solutions, follow this research workflow:

**Step 1: Search GitHub for existing skills**
```
Search queries:
- site:github.com SKILL.md [domain-keyword]
- [domain] skill SKILL.md "agentskills.io"
- [domain] skill anthropics openai warpdotdev
```

**Step 2: Check the canonical repos**
- `anthropics/skills` — Reference implementation quality
- `openai/skills` — Official curated patterns
- `warpdotdev/oz-skills` — CLI/terminal skill patterns
- `skills.sh` — Community registry, searchable

**Step 3: Extract reusable patterns**
From existing skills, extract:
- Description trigger phrases that work well
- Workflow steps that are battle-tested
- Gotchas that caught real agent failures
- Scripts that solved determinism problems

**Step 4: Synthesize, don't copy**
Combine patterns from multiple sources into a skill that is:
- More specific to the user's project context
- Cleaner and more focused than any individual source
- Extended with domain knowledge the GitHub repos lack

---

## 10. The 12 Prompt Engineering Techniques (Quick Reference)

Apply these techniques in SKILL.md bodies:

| Technique | When to Apply | Pattern |
|-----------|---------------|---------|
| Role Definition | Always | "You are a [specific expert] specializing in [narrow domain]" |
| Sequential Decomposition | Multi-step workflows | Numbered steps with action verbs, one action each |
| Chain-of-Thought | Quantitative/logical tasks | "Before responding, work through: 1... 2... 3..." |
| Few-Shot Examples | Format-critical outputs | `<examples><example><input>...<output>...` |
| Output Format Anchoring | Structured outputs | Provide schema or template, not prose description |
| Positive Pattern Framing | All constraints | "State X explicitly" not "Don't guess" |
| Self-Verification | High-stakes outputs | Checklist before finalizing |
| Constraint Framing | Scope boundaries | In scope / Out of scope / Hard rules |
| Contextual Grounding | Research/analysis | "Cite source inline as [Name](url)" |
| Adaptive Depth | Mixed audience | Detect expertise level from query |
| Decomposed Clarification | Under-specified requests | Ask ONE focused question |
| Meta-Reflection | Iterative skills | Reflection step when explicitly requested |

---

## 11. Self-Verification Checklist Template

Embed this in any high-stakes skill:

```markdown
## Verification

Before presenting the final output, verify:
- [ ] [Criterion 1 — specific, checkable, tied to output quality]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
- [ ] Output is complete — no truncated sections or TODO placeholders
- [ ] Format matches the specified Output Format exactly
- [ ] All claims in the output are verifiable from the provided source material

If any criterion fails, revise the relevant section before presenting.
```

---

## 12. Publishing to skills.sh Registry

```bash
# Initial setup
npm install -g skills-ref

# Validate before publishing
agentskills validate ./your-skill-name/

# Publish (creates entry in skills.sh registry)
npx skills publish ./your-skill-name

# After publishing, users install with:
npx skills your-skill-name -a replit     # Replit
npx skills your-skill-name -a codex      # Codex
$skill-installer your-skill-name         # Codex native CLI
```

**Requirements for registry submission:**
- Pass `agentskills validate` with zero errors
- Include `license` field in frontmatter
- Description must be 100+ characters with real trigger keywords
- At least one example in the skill body
- README.md with usage instructions (for GitHub hosting)
