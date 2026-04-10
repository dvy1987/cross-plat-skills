# Split Patterns

Read when the natural seam in a skill is unclear. These are the three proven split patterns.

---

## Pattern 1 — Shared Capability Extraction (Type B)

**Signal:** The same workflow steps appear verbatim or near-verbatim in 2+ skills.

**Rule:** If a sub-workflow appears in 2+ skills, it belongs in exactly one child skill.

**Structure:**
```
research-skill     ← extracted from universal-skill-creator + improve-skills
compress-skill   ← called by improve-skills when >200 lines
split-skill        ← called by compress-skill + universal-skill-creator + improve-skills
```

**How to extract:**
1. Identify the sub-workflow's natural input and output
2. Write the child skill so its output is a structured document/report the parent can consume
3. Replace the inline steps in every parent with: "Invoke `<child>`. Wait for [output type]."
4. Update all parents, not just the first one you find

**Good candidate signals:**
- Sub-workflow has a clear input (a name, a file, a domain)
- Sub-workflow produces a structured output (a report, a plan, a classification)
- Sub-workflow could be useful to future skills not yet written

**Bad candidate signals:**
- Sub-workflow only makes sense mid-pipeline (needs prior step's output as implicit context)
- Sub-workflow is 3 lines — not worth the overhead of a separate skill

---

## Pattern 2 — Phase Extraction (Type A)

**Signal:** A single skill has distinct sequential phases — e.g., Research → Write → Validate — and each phase is large enough to hit the 200-line limit on its own.

**Structure:**
```
parent-skill (orchestrator — under 200 lines)
  → phase-1-skill (e.g., research-skill)
  → phase-2-skill (e.g., skill-writer — hypothetical)
  → phase-3-skill (e.g., compress-skill)
```

**How to extract:**
1. Identify where one phase ends and the next begins — look for a natural handoff point (a document is produced, a decision is made, a plan is approved)
2. The handoff artifact becomes the contract between phases
3. Parent becomes an orchestrator: calls each phase, passes the artifact, waits for result

**Contract template:**
```
Phase 1 output: [artifact name and structure]
Phase 2 input: [artifact from Phase 1]
Phase 2 output: [artifact name and structure]
```

**Key rule:** The parent orchestrator must stay under 200 lines. If it's just calling 3 child skills, it should be well under 100 lines.

---

## Pattern 3 — Format/Schema Extraction

**Signal:** A skill has large output templates, schemas, or format examples that are CORE (agent needs them to produce correct output) but are inflating the body past 200 lines.

**This is NOT a split — it's a references/ move.**

Move the schema to `references/<schema-name>.md` and add a load trigger:
```markdown
Read `references/prd-schemas.md` when writing any PRD section.
```

Only use a full child skill split if the schema itself requires workflow steps to apply — e.g., a schema with conditional sections that need agent judgment to fill in.

---

## Check Existing Skills Before Splitting (Always Do This First)

Before any split decision, scan `.agents/skills/` for an existing skill that already covers the excess sub-capability:

1. **Already covers it fully** → link immediately. No new skill needed.
2. **Covers it ~80%** → make a targeted improvement to the existing skill, then link. Allowed if: stays ≤200 lines, core purpose unchanged, existing callers unaffected.
3. **Cannot be adapted without scope creep or size violation** → proceed with Type A or B split below.

Creating a new skill when an existing one could be adapted is an anti-pattern — see Anti-Patterns below.

---

## Anti-Patterns (Do Not Split These)

| Situation | Why not to split | What to do instead |
|-----------|-----------------|-------------------|
| Skill is 210 lines, 10 lines over limit | Overhead not worth it | Trim 10 lines with compression |
| Sub-workflow needs 3 prior steps' context | Not independently callable | Keep inline, compress prose |
| Child would only ever be called by one parent | Not truly reusable | Move to `references/` instead |
| Split would require parent to pass >5 variables to child | Tight coupling | Keep inline |
| Sub-capability is <10 lines | Too small to be a skill | Keep inline |
| Existing skill covers it with a small change | Creating a new skill is wasteful | Adapt the existing skill and link |
