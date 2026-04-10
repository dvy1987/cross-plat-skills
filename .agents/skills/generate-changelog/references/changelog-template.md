# Changelog Template

Use this schema when drafting `docs/changelogs/vX.X.X.md`.

```markdown
# [X.X.X] - YYYY-MM-DD

## Summary
[One short paragraph describing the user-visible theme of the release.]

## Breaking Changes
- [User action required, migration note, or "None."]

## Added
- [New capability in user-facing language]

## Changed
- [Behavior change in user-facing language]

## Deprecated
- [Optional: soon-to-be removed functionality]

## Removed
- [Optional: removed functionality]

## Fixed
- [Resolved user-visible bug or workflow issue]
```

Rules:
- Keep every bullet user-facing and value-oriented.
- Do not mention security findings, security fixes, or internal implementation details.
- Omit empty sections except `Summary` and `Breaking Changes`.
- If there are no breaking changes, write `- None.`
