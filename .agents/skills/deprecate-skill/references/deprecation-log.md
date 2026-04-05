# Deprecation Log

Running record of all deprecated skills. Updated by deprecate-skill after every deprecation.
Read when the user asks what has been deprecated and why, or when researching whether a skill was previously tried and removed.

---

## Active Deprecations

*None yet — this log will be updated as skills are deprecated.*

---

## Log Format

Each entry follows this structure:

```markdown
### [skill-name] — deprecated YYYY-MM-DD

**Reason:** [trigger condition that justified deprecation]
**Evidence:** [specific source with date]
**Migration:** [what replaced this skill, or "model-native"]
**Callers updated:** [list of skills that were modified, or "none"]
**Archive path:** `.agents/skills/.deprecated/[skill-name]-deprecated-YYYY-MM-DD/`
**Recovery command:**
mv .agents/skills/.deprecated/[skill-name]-deprecated-YYYY-MM-DD/ .agents/skills/[skill-name]/
```
