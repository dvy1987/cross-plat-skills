# Pre-Publish Checklist

Full checklist before publishing any skill to skills.sh or a public GitHub repo.
Read this for any System-tier skill, or when the user is publishing for the first time.

---

## Quality Gate (must all pass)

- [ ] `agentskills validate .agents/skills/<skill-name>/` exits 0
- [ ] Score ≥ 10/14 from validate-skills
- [ ] SKILL.md ≤ 200 lines
- [ ] At least 1 complete, non-truncated example
- [ ] Description has ≥ 3 trigger phrases

## Proprietary Content Scan (must all be clean)

- [ ] No internal URLs or API endpoints in any file
- [ ] No company or product names in examples (unless the skill is explicitly for that product)
- [ ] No hardcoded file paths (e.g., `/home/user/workspace/`, `/Users/yourname/`)
- [ ] No API keys, tokens, or credentials anywhere in the skill directory
- [ ] No internal jargon that only makes sense in one company's context

## Package Integrity

- [ ] Directory name matches `name` field in frontmatter exactly (lowercase, hyphens only)
- [ ] `license` field present in frontmatter (MIT recommended for public skills)
- [ ] `metadata.author` is set to your name or handle
- [ ] README.md present with install command and trigger example
- [ ] For zip packages: `*.pyc` and `__pycache__/` excluded from zip

## Scripts (if Advanced/System tier)

- [ ] No hardcoded paths in any script file
- [ ] Each script has a docstring: purpose, usage, inputs, outputs, exit codes
- [ ] Scripts handle errors gracefully and exit with non-zero on failure
- [ ] No `pip install` or `npm install` calls without documenting the dependency

## Platform Compatibility

- [ ] Skill installs in `.agents/skills/` (universal location — all platforms)
- [ ] If platform-specific extras exist (openai.yaml, Factory frontmatter), they are additive only
- [ ] Test trigger phrase works in at least one real agent before publishing

## Registry Submission

- [ ] `npx skills publish` command available (`npm install -g skills-ref` if not)
- [ ] Dry-run passes: `npx skills <skill-name> --dry-run`
- [ ] Registry URL confirmed after publish
