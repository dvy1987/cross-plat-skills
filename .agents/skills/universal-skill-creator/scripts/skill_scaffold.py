#!/usr/bin/env python3
"""
skill_scaffold.py — Universal Skill Directory Generator

Scaffolds a new agent skill directory following the agentskills.io open standard,
compatible with Codex, Ampcode, Factory.ai, Warp, Replit, GitHub Copilot,
Claude Code, VS Code, Cursor, Gemini, and Bolt.new.

Usage:
    python skill_scaffold.py --name <skill-name> [options]

Options:
    --name       Skill name (lowercase, hyphens only, 1-64 chars) [required]
    --tier       Complexity tier: atomic | standard | advanced | system [default: atomic]
    --platform   Target platform hint: universal | codex | factory | warp | replit
                 [default: universal]
    --output     Output directory [default: .agents/skills/]
    --author     Author name for frontmatter [default: your-name]
    --desc       One-line description seed (will be expanded in the template)
    --dry-run    Print what would be created without writing files

Examples:
    python skill_scaffold.py --name conventional-commits
    python skill_scaffold.py --name db-migrate --tier advanced --platform factory
    python skill_scaffold.py --name deploy --tier standard --platform warp
    python skill_scaffold.py --name data-pipeline --tier system --output .claude/skills/

Exit codes:
    0 — Success
    1 — Invalid arguments
    2 — Output path already exists
    3 — File write error
"""

import argparse
import os
import sys
import textwrap
from pathlib import Path
from datetime import date

# ---------------------------------------------------------------------------
# Templates
# ---------------------------------------------------------------------------

SKILL_MD_ATOMIC = """\
---
name: {name}
description: >
  {desc_line1}
  {desc_line2}
  Load when the user asks to [trigger phrase 1], [trigger phrase 2],
  or [trigger phrase 3]. Also triggers on [synonym phrase].
license: MIT
metadata:
  author: {author}
  version: "1.0"
  created: {today}
---

# {title}

You are a [specific expert role] specializing in [narrow domain]. Your outputs
are [quality standard] and [distinctive characteristic].

## When to Load

Load this skill when the user:
- Asks to [action 1]
- Mentions [keyword 1] or [keyword 2]
- Needs to [action 2]

Do NOT load for: [anti-trigger if any]

---

## Core Workflow

### Step 1 — [Action Verb] [Object]

[Specific instruction. Include acceptance criteria: what does "done" look like?]

### Step 2 — [Action Verb] [Object]

[Specific instruction referencing Step 1 outputs.]

### Step 3 — [Action Verb] [Object]

[Specific instruction.]

### Step 4 — Verify Output

Before presenting, confirm:
- [ ] [Criterion 1 — specific and checkable]
- [ ] [Criterion 2]
- [ ] Output is complete, no truncated sections

---

## Gotchas

- [Non-obvious fact the agent will get wrong without being told]
- [Environment-specific behavior that defies reasonable assumptions]

---

## Output Format

Always structure your response as:

```
[Section 1]: [Content description]
[Section 2]: [Content description]
```

**Always include:** [required elements]

---

## Examples

<examples>
  <example>
    <input>[Realistic user request — not simplified]</input>
    <output>
[Complete, production-ready output — never abbreviated]
    </output>
  </example>
  <example>
    <input>[A different scenario that tests a different workflow branch]</input>
    <output>
[Complete output for this scenario]
    </output>
  </example>
</examples>

---

## Scope and Constraints

**In scope:**
- [Capability 1]
- [Capability 2]

**Out of scope — disclaim and redirect:**
- [What this skill does NOT handle]

**Hard rules:**
- Always [non-negotiable positive behavior]
- State assumptions explicitly rather than guessing
"""

REFERENCES_PLACEHOLDER = """\
# {title} — Reference Guide

This file contains detailed reference material for the `{name}` skill.
Read this when [specific trigger condition].

---

## [Topic 1]

[Content]

---

## [Topic 2]

[Content]
"""

SCRIPT_PLACEHOLDER = """\
#!/usr/bin/env python3
\"\"\"
{script_name}.py — [One-line purpose]

Part of the `{name}` skill (agentskills.io standard).

Usage:
    python scripts/{script_name}.py [--arg1 value] [--arg2 value]

Arguments:
    --arg1   Description of argument 1
    --arg2   Description of argument 2

Output:
    [Describe what this script outputs: JSON, stdout text, exit code meaning]

Exit codes:
    0 — Success
    1 — Input validation error
    2 — Runtime error (see stderr for details)
\"\"\"

import argparse
import json
import sys


def main():
    parser = argparse.ArgumentParser(description="[One-line description]")
    parser.add_argument("--arg1", required=True, help="Description")
    parser.add_argument("--arg2", default="default", help="Description")
    args = parser.parse_args()

    try:
        result = run(args)
        print(json.dumps(result, indent=2))
        sys.exit(0)
    except ValueError as e:
        print(f"Validation error: {{e}}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error: {{e}}", file=sys.stderr)
        sys.exit(2)


def run(args):
    \"\"\"Core logic — replace with your implementation.\"\"\"
    # TODO: Implement
    return {{"status": "ok", "arg1": args.arg1, "arg2": args.arg2}}


if __name__ == "__main__":
    main()
"""

OPENAI_YAML = """\
# agents/openai.yaml — Codex-specific metadata
# Optional file. Only needed for Codex app UI customization or tool dependencies.
# Remove this file if targeting non-Codex platforms only.

interface:
  display_name: "{title}"
  short_description: "One-line user-facing description"
  # icon_small: "./assets/icon-16.svg"
  # icon_large: "./assets/icon-128.png"
  # brand_color: "#3B82F6"
  # default_prompt: "Optional pre-filled prompt"

policy:
  # Set to false for skills with side effects (deploy, delete, send, etc.)
  allow_implicit_invocation: true

# dependencies:
#   tools:
#     - type: "mcp"
#       value: "openaiDeveloperDocs"
#       description: "OpenAI Docs MCP server"
#       transport: "streamable_http"
#       url: "https://developers.openai.com/mcp"
"""

README_MD = """\
# {title}

> Agent skill following the [agentskills.io](https://agentskills.io) open standard.

## What This Skill Does

[One-paragraph description of what this skill automates and why it's useful]

## Supported Platforms

- OpenAI Codex
- Ampcode
- Claude Code
- GitHub Copilot
- Warp
- Factory.ai
- Replit
- Cursor
- VS Code
- Gemini

## Installation

### Universal (all platforms)
```bash
# Place in your project
cp -r {name}/ .agents/skills/
```

### Via npx skills CLI
```bash
npx skills {name} -a replit     # Replit
npx skills {name} -a codex      # Codex
$skill-installer {name}          # Codex native CLI
```

### Platform-specific paths
| Platform | Directory |
|----------|-----------|
| Codex | `.agents/skills/` or `$HOME/.agents/skills/` |
| Ampcode | `.agents/skills/` or `~/.config/agents/skills/` |
| Claude Code | `.claude/skills/` |
| Copilot | `.github/skills/` |
| Warp | `.agents/skills/` (reads all major dirs) |
| Factory.ai | `.factory/skills/` |
| Replit | `/.agents/skills/` |

## Validation

```bash
pip install -q skills-ref
agentskills validate ./{name}/
```

## Usage

Trigger this skill by asking your agent to [trigger phrase]. Example:

```
[Example trigger prompt]
```

## License

MIT — Created {today}
"""

# ---------------------------------------------------------------------------
# Tier definitions
# ---------------------------------------------------------------------------

TIER_FILES = {
    "atomic": ["SKILL.md"],
    "standard": ["SKILL.md", "references/reference.md"],
    "advanced": ["SKILL.md", "references/reference.md", "scripts/main.py"],
    "system": [
        "SKILL.md",
        "references/reference.md",
        "scripts/main.py",
        "assets/output-template.md",
        "agents/openai.yaml",
        "README.md",
    ],
}

PLATFORM_DIRS = {
    "universal": ".agents/skills",
    "codex": ".agents/skills",
    "ampcode": ".agents/skills",
    "claude": ".claude/skills",
    "copilot": ".github/skills",
    "warp": ".agents/skills",
    "factory": ".factory/skills",
    "replit": ".agents/skills",
    "gemini": ".gemini/skills",
    "cursor": ".cursor/skills",
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def to_title(name: str) -> str:
    return " ".join(w.capitalize() for w in name.split("-"))


def validate_name(name: str) -> None:
    import re
    if not re.match(r"^[a-z][a-z0-9]*(-[a-z0-9]+)*$", name):
        print(
            f"Error: Skill name '{name}' is invalid.\n"
            "Rules: lowercase letters and hyphens only, no consecutive hyphens, "
            "must not start or end with a hyphen.",
            file=sys.stderr,
        )
        sys.exit(1)
    if len(name) > 64:
        print(f"Error: Skill name must be 1-64 characters (got {len(name)}).", file=sys.stderr)
        sys.exit(1)


def build_skill_md(name: str, author: str, desc: str, today: str) -> str:
    title = to_title(name)
    desc_seed = desc or f"[Describe what the {name} skill does and when to use it]"
    words = desc_seed.split()
    mid = len(words) // 2
    desc_line1 = " ".join(words[:mid]) if words else desc_seed
    desc_line2 = " ".join(words[mid:]) if len(words) > 1 else ""
    return SKILL_MD_ATOMIC.format(
        name=name,
        title=title,
        author=author,
        today=today,
        desc_line1=desc_line1,
        desc_line2=desc_line2,
    )


def create_file(path: Path, content: str, dry_run: bool) -> None:
    if dry_run:
        print(f"  [would create] {path}")
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    print(f"  [created] {path}")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser(
        description="Scaffold a new agent skill following the agentskills.io standard",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent(
            """
            Examples:
              python skill_scaffold.py --name conventional-commits
              python skill_scaffold.py --name db-migrate --tier advanced --platform factory
              python skill_scaffold.py --name deploy --tier standard --platform warp
            """
        ),
    )
    parser.add_argument("--name", required=True, help="Skill name (lowercase, hyphens only)")
    parser.add_argument(
        "--tier",
        choices=["atomic", "standard", "advanced", "system"],
        default="atomic",
        help="Complexity tier (default: atomic)",
    )
    parser.add_argument(
        "--platform",
        choices=list(PLATFORM_DIRS.keys()),
        default="universal",
        help="Target platform hint (default: universal → .agents/skills/)",
    )
    parser.add_argument("--output", default=None, help="Override output base directory")
    parser.add_argument("--author", default="your-name", help="Author name for frontmatter")
    parser.add_argument("--desc", default="", help="One-line description seed")
    parser.add_argument("--dry-run", action="store_true", help="Preview without writing files")
    args = parser.parse_args()

    validate_name(args.name)

    today = date.today().isoformat()
    title = to_title(args.name)
    base_dir = args.output or PLATFORM_DIRS[args.platform]
    skill_root = Path(base_dir) / args.name

    if skill_root.exists() and not args.dry_run:
        print(f"Error: '{skill_root}' already exists. Delete it first or choose a different name.", file=sys.stderr)
        sys.exit(2)

    print(f"\nScaffolding skill: {args.name}")
    print(f"  Tier     : {args.tier}")
    print(f"  Platform : {args.platform}")
    print(f"  Output   : {skill_root}/")
    if args.dry_run:
        print("  (dry run — no files will be written)\n")
    else:
        print()

    files = TIER_FILES[args.tier]

    for rel_path in files:
        full_path = skill_root / rel_path

        if rel_path == "SKILL.md":
            content = build_skill_md(args.name, args.author, args.desc, today)

        elif rel_path.startswith("references/"):
            content = REFERENCES_PLACEHOLDER.format(title=title, name=args.name)

        elif rel_path.startswith("scripts/"):
            script_name = Path(rel_path).stem
            content = SCRIPT_PLACEHOLDER.format(name=args.name, script_name=script_name)

        elif rel_path == "agents/openai.yaml":
            content = OPENAI_YAML.format(title=title)

        elif rel_path == "README.md":
            content = README_MD.format(name=args.name, title=title, today=today)

        elif rel_path.startswith("assets/"):
            content = f"# {title} — Output Template\n\n[Replace with your output template]\n"

        else:
            content = f"# {rel_path}\n"

        create_file(full_path, content, args.dry_run)

    if not args.dry_run:
        print(f"\nSkill scaffolded at: {skill_root}/")
        print("\nNext steps:")
        print(f"  1. Edit {skill_root}/SKILL.md — fill in role, workflow, examples, gotchas")
        if args.tier in ("advanced", "system"):
            print(f"  2. Implement {skill_root}/scripts/main.py")
        print(f"  3. Validate: agentskills validate {skill_root}/")
        if args.tier == "system":
            print(f"  4. Package:  zip -r {args.name}.zip {skill_root}/")
        print(f"\nTrigger test prompt: \"[Ask your agent to use the {args.name} skill]\"")
    else:
        print("\n(Dry run complete — no files written)")


if __name__ == "__main__":
    main()
