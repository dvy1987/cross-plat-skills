---
name: your-skill-name
description: >
  [Primary action verb phrase — what does this skill DO?] + [specific trigger
  conditions — when should agents load it?] + [domain keywords that users will
  mention] + [common synonyms and related phrases]. Load when the user asks to
  [trigger phrase 1], [trigger phrase 2], or [trigger phrase 3]. Also triggers
  on [synonym phrase] or when the user mentions [keyword].
license: MIT
metadata:
  author: your-name-or-org
  version: "1.0"
  # created: YYYY-MM-DD
  # spec: agentskills.io/specification
  # sources: repos or docs you drew from
# Optional fields:
# compatibility: Requires Python 3.10+ and git
# allowed-tools: Bash(git:*) Read Write    ← experimental, Codex/Copilot
# 
# Factory.ai-specific (add if targeting Factory):
# user-invocable: true
# disable-model-invocation: false
---

# [Skill Title]

You are a [specific expert role] specializing in [narrow domain]. Your outputs
are [quality standard — e.g., "precise and immediately deployable"] and
[distinctive characteristic — e.g., "always cite the exact command or file path"].

## When to Load This Skill

Load this skill when the user:
- Asks to [action trigger 1]
- Mentions [keyword 1] or [keyword 2]
- Has a file of type [extension] and wants to [action]
- Needs to [action trigger 2]

Do NOT load this skill for: [anti-trigger — narrow the scope to prevent false activations]

---

## Core Workflow

### Step 1 — [Action Verb] [Object]

[Specific instruction. State what "done" looks like: acceptance criteria, not vague.]

If [edge case condition]:
- [Handle it this specific way — not "handle appropriately"]

### Step 2 — [Action Verb] [Object]

[Specific instruction. Reference Step 1 output explicitly.]

### Step 3 — [Action Verb] [Object]

[Specific instruction.]

### Step 4 — Verify Output

Before presenting the final response, confirm:
- [ ] [Criterion 1 — specific and checkable against the output]
- [ ] [Criterion 2]
- [ ] Output is complete — no truncated sections, no TODO placeholders
- [ ] Format matches the Output Format section exactly

If any criterion fails, revise before presenting.

---

## Gotchas

<!-- 
Gotchas are the highest-value content in many skills.
These are NON-OBVIOUS facts the agent will get wrong without being told.
Keep these in SKILL.md (not references/) so the agent reads them before encountering the situation.
Each bullet is a concrete correction, not general advice.
-->

- [Specific non-obvious fact that defies reasonable assumptions]
- [Environment-specific behavior that breaks the obvious approach]
- [Naming or identifier inconsistency that causes hard-to-debug errors]

---

## Output Format

Always structure your response as:

```
[Section title]: [Description of content]
[Section title]: [Description of content]
[Section title]: [Description of content]
```

**Always include:** [List of elements that must appear in every output]
**Never include:** [List of elements to omit — conversational filler, apologies, etc.]

<!-- 
Alternative: provide a concrete template instead of a schema.
Agents pattern-match better against concrete structure than prose descriptions.

Use this exact template:

---
**Summary:** [1-2 sentence overview]
**Key Findings:**
- [Finding 1 with supporting evidence]
- [Finding 2 with supporting evidence]
**Recommendation:** [Specific actionable next step]
**Confidence:** [High/Medium/Low] — [one-line rationale]
---
-->

---

## Examples

<!-- 
Include 2-3 realistic examples. Make inputs representative of real user queries.
Make outputs complete and production-ready — never abbreviated with [...].
Cover at least 2 distinct scenarios (not just variations of the same case).
-->

<examples>
  <example>
    <input>[Realistic user request — as they would actually type it, not a simplified version]</input>
    <output>
[Complete, production-ready output. This is the gold standard — never truncate.
If the ideal output is long, include the full thing.]
    </output>
  </example>
  <example>
    <input>[A different scenario that exercises a different workflow branch or edge case]</input>
    <output>
[Complete output for this scenario. Show how the skill handles variation.]
    </output>
  </example>
</examples>

---

## Scope and Constraints

**In scope:**
- [Capability 1 — specific and bounded]
- [Capability 2]

**Out of scope — disclaim and redirect:**
- [What this skill explicitly does NOT handle]
- [What requires human judgment beyond this skill — state how to escalate]

**Hard rules:**
- Always state assumptions explicitly rather than guessing
- Prefer [approach A] over [approach B] when [condition]
- [Any non-negotiable behavior — phrased positively]

---

<!-- 
PLATFORM INSTALL PATHS
======================
Universal (all platforms read this):
  Project:  .agents/skills/your-skill-name/
  User:     ~/.agents/skills/your-skill-name/

Platform-specific additions:
  Codex:    agents/openai.yaml (add for UI metadata / tool pre-approval)
  Factory:  .factory/skills/your-skill-name/ (also user-invocable / disable-model-invocation frontmatter)
  Warp:     Reads .warp/skills/, .claude/skills/, .codex/skills/, etc. (all autodiscovered)
  Replit:   /.agents/skills/your-skill-name/
  Copilot:  .github/skills/ or .agents/skills/
  Claude:   .claude/skills/ or .agents/skills/

VALIDATION
==========
pip install -q skills-ref
agentskills validate ./your-skill-name/

PACKAGING
=========
# SKILL.md only:
cp SKILL.md ~/share/your-skill-name.md

# Full directory:
zip -r your-skill-name.zip your-skill-name/

COMMUNITY RESOURCES
===================
Learn from: anthropics/skills, openai/skills, warpdotdev/oz-skills, github/awesome-copilot
Publish at: skills.sh (npx skills publish ./your-skill-name)
Spec at:    agentskills.io/specification
-->

## Reference Files

<!-- Only include this section if your skill has reference files -->

- **`references/[file].md`**: [When to read it — specific condition, not "for details"] — [What it contains]
- **`scripts/[script].py`**: [What it does, when to run it, expected arguments and exit codes]

---

<!--
SKILL AUTHOR CHECKLIST — delete this comment block before publishing

FRONTMATTER
[ ] File starts with --- on line 1 (zero blank lines before frontmatter)
[ ] name is lowercase, hyphens-only, 1-64 chars, matches directory name exactly
[ ] description includes trigger keywords, action verbs, and synonym phrases
[ ] No unknown top-level frontmatter fields (custom fields → under metadata:)
[ ] compatibility field present if skill requires non-standard environment

BODY STRUCTURE
[ ] Expert role defined in the first paragraph with specific domain
[ ] Workflow steps are numbered with action verbs, one action per step
[ ] Gotchas section has specific non-obvious facts (not general advice)
[ ] At least 2 examples with realistic inputs and COMPLETE (non-truncated) outputs
[ ] Output Format defined as schema or template (not prose description)
[ ] Verification checklist included with specific, checkable criteria
[ ] Guardrails phrased as positive patterns ("state X") not negatives ("don't guess")
[ ] SKILL.md body is under 500 lines

RESOURCES (if Standard+ tier)
[ ] Each references/ file referenced with WHEN to load it (specific trigger)
[ ] Each scripts/ file has docstring: purpose, inputs, outputs, exit codes
[ ] assets/ templates are output-ready, no TODO placeholders

CROSS-PLATFORM
[ ] Skill installs in .agents/skills/ (universal cross-platform location)
[ ] Platform-specific extras (openai.yaml, Factory frontmatter) noted
[ ] Description tested against 3+ plausible trigger phrases
[ ] agentskills validate passes with zero errors
[ ] Packaged as .zip if directory with resources
-->
