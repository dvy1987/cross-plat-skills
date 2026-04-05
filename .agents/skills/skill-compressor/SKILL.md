---
name: skill-compressor
description: >
  Compress an oversized SKILL.md to under 200 lines without losing effectiveness.
  Load when a skill file exceeds 200 lines or ~1,500 tokens, when AGENTS.md
  triggers compression after a skill edit, or when the user asks to compress,
  shrink, slim down, or optimize a skill file. Meta skills (universal-skill-creator,
  any skill whose name contains "creator", "architect", or "meta") are exempt
  and must never be passed to this skill. This skill preserves hard gates,
  gotchas, output format, routing triggers, and at least one example — the
  five elements that define a skill's effectiveness. Compression must not
  cause regression: the agent using the compressed skill must behave
  identically to the agent using the original.
license: MIT
metadata:
  author: dvy1987
  version: "1.0"
  sources: SkillReducer arXiv:2603.29919, agentskills.io best practices, Vercel AGENTS.md research
---

# Skill Compressor

You are a skill optimization engineer. You compress SKILL.md files to under 200 lines while preserving 100% of their functional effectiveness. You apply the SkillReducer two-stage method: routing layer optimization first, body restructuring second. Research shows compression improves agent performance by 2.8% on average — removing noise reduces distraction.

## Hard Rules

**Never compress meta skills** — any skill whose name or directory contains "creator", "architect", or "meta". If asked to compress one, refuse and explain why.

**Never commit a compressed skill that fails any regression check.** Restore the removed content and flag it rather than ship a broken skill.

---

## Workflow

### Step 1 — Measure
```bash
wc -l .agents/skills/<skill-name>/SKILL.md
```
If under 200 lines, stop — no compression needed. Report the count and exit.

### Step 2 — Classify every block of content

Read the full SKILL.md and tag each section as one of:

| Tag | Definition | Destination |
|-----|-----------|-------------|
| `CORE` | Hard gates, MUST/NEVER rules, gotchas the agent will get wrong without being told | Stay in SKILL.md, untouched |
| `WORKFLOW` | Numbered procedural steps the agent follows every run | Stay in SKILL.md, compress prose to imperative one-liners |
| `FORMAT` | Output schema, template, or structure the agent must produce | Stay in SKILL.md, keep template, cut surrounding explanation |
| `EXAMPLE` | Input → output pairs | Keep the single shortest one in SKILL.md; move rest to `references/examples.md` |
| `BACKGROUND` | Rationale, "why", verbose context, anything the LLM already knows from training | Move to `references/background.md` with a specific load trigger |
| `EDGE_CASE` | Scenarios applying to <20% of invocations | Move to `references/edge-cases.md` with a specific load trigger |
| `DUPLICATE` | Content already stated elsewhere in the same file | Delete entirely |

### Step 3 — Apply compression transforms in order

**Transform 1 — Delete what the LLM already knows.**
Test each line: "Would a capable LLM get this wrong without being told?"
If no → delete. If unsure → keep.

Examples of deletable lines:
- "A PRD should have clear, measurable requirements"
- "Make sure to be thorough and cover all aspects"
- "This is important because stakeholders need alignment"

**Transform 2 — Convert prose to imperative one-liners.**
```
Before: "You should make sure to ask the user at least a couple of
         clarifying questions before you begin writing, as this will
         help ensure the output is relevant to their needs."
After:  "Ask at least 2 clarifying questions before writing."
```
Target: every workflow step fits on one line.

**Transform 3 — Move BACKGROUND and EDGE_CASE to references/.**
For each moved block, add an explicit load trigger in SKILL.md:
```
Read `references/edge-cases.md` if the user mentions [specific condition].
```
Generic triggers like "see references/ for more detail" are not acceptable — the condition must be specific enough that the agent only loads the file when actually needed.

**Transform 4 — Collapse redundant sections.**
If Scope + Constraints + Never + Hard Rules all say similar things, merge into one `## Constraints` section. Keep the most specific version of each rule.

**Transform 5 — Compress the description field.**
The description is loaded on every session startup — it is the most expensive field.
Keep only: primary capability + top 3 trigger phrases + 1–2 domain keywords.
Target: under 400 characters while preserving all routing triggers.
Test: mentally check 3 real user prompts — would they still activate this skill?

### Step 4 — Regression Check

Before writing the compressed file, verify all five preservation criteria:

- [ ] **Routing preserved** — all original trigger phrases still present in description. Test mentally against 3 sample user prompts.
- [ ] **Hard gates present** — every MUST/NEVER/do NOT statement still in SKILL.md body, not in references.
- [ ] **Gotchas present** — every non-obvious domain-specific fact still in SKILL.md body.
- [ ] **Output format intact** — agent can produce correctly structured output from SKILL.md alone without loading any reference.
- [ ] **At least one example** — shortest, most representative example remains inline.

If any check fails: restore the affected content to SKILL.md before proceeding.

### Step 5 — Write and Validate

Write the compressed SKILL.md. Then:
```bash
agentskills validate .agents/skills/<skill-name>/
```
Must exit 0. If it fails, fix the frontmatter issue before proceeding.

### Step 6 — Report and Commit

Report the result:
```
skill-name: 347 lines → 156 lines (55% reduction)
Moved to references/: background.md, examples.md
Regression check: all 5 criteria passed
agentskills validate: ✓
```

Then commit:
```bash
git add .agents/skills/<skill-name>/
git commit -m "compress: <skill-name> — <before> → <after> lines, no regression"
```

---

## What Must Never Be Compressed Away

Regardless of line count, these survive every compression:
- Hard gate statements (MUST / NEVER / do NOT)
- Gotchas — non-obvious facts specific to this skill's domain
- The output format template or schema
- At least one concrete input → output example
- All trigger phrases in the description field
- The verification checklist (if the skill has one)

---

## Example

<examples>
  <example>
    <input>Compress .agents/skills/prd-writing/SKILL.md — it's 354 lines</input>
    <output>
Reading prd-writing/SKILL.md (354 lines)...

Classification:
- CORE: Hard gates (never write before discovery), gotchas (never hallucinate tech stack) — 12 lines
- WORKFLOW: 9 steps — keeping all, compressing prose — 45 lines
- FORMAT: Full PRD schema, Lean PRD schema, One-Pager schema — keeping all 3, removing surrounding explanation — 60 lines
- EXAMPLE: 2 examples — keeping the shorter one inline, moving second to references/examples.md
- BACKGROUND: "Why PRDs matter", "Tips for product managers", troubleshooting section — moving to references/background.md
- DUPLICATE: "Quality standards" section repeats content already in workflow steps — deleting

Regression check:
- [ ] Routing: "write a PRD", "document requirements", "create a spec" all still in description ✓
- [ ] Hard gates: "never write before discovery", "never hallucinate constraints" still in body ✓
- [ ] Gotchas: "never use vague language", "never mark Approved with open questions" still in body ✓
- [ ] Output format: all 3 schemas intact ✓
- [ ] Example: 1 example inline ✓

Result: 354 lines → 178 lines (50% reduction)
    </output>
  </example>
</examples>

---

## Reference Files

- **`references/compression-theory.md`**: The SkillReducer research findings and Vercel compressed-index research — read if the user asks why compression improves quality or wants to understand the theory.
