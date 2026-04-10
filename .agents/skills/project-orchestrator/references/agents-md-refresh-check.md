# AGENTS.md Refresh Check

Most artefact changes do NOT require an AGENTS.md update. Skills already read PRDs, specs, and plans directly from the files — the AGENTS.md doesn't need to duplicate that content. Only refresh when the artefact changes something the AGENTS.md itself controls.

**Refresh AGENTS.md only when:**
- **Stack changed** — `package.json` / `Cargo.toml` / `pyproject.toml` / `go.mod` has new dependencies that change Key Commands or build steps
- **New non-obvious pattern emerged** — a spec, ADR, or architecture doc introduces a counterintuitive convention agents must follow (e.g., "all state in Zustand, never component state")
- **Implementation plan reveals parallel tracks** — the Orchestration Map needs new parallel decomposition hints that weren't there before
- **Boundaries need updating** — new protected directories, new "never touch" files, or new permission gates from architectural decisions

**Do NOT refresh when:**
- A PRD, spec, or plan was simply created — skills read those directly
- Product-soul was written or updated — brainstorming and prd-writing already read it from `docs/product-soul.md`
- An ADR was logged that doesn't affect coding conventions
- Content changed but no agent behaviour needs to change

**When refresh is needed:** Invoke `project-setup` with `UPDATE_ONLY=true`. This skips the interview and only updates the affected sections (Key Commands, Non-Obvious Patterns, Orchestration Map parallel hints, or Boundaries). Show a brief diff to the user.
