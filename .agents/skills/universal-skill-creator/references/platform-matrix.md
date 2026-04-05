# Platform Matrix — Universal Skill Deployment Guide

This file covers every major AI agent platform's skill directory paths, invocation methods, platform-specific file formats, and compatibility requirements. Read this when:
- The user asks where to install a skill on their platform
- You need to add platform-specific frontmatter or config files
- You need to support multiple platforms simultaneously

---

## Universal Rule: `.agents/skills/` Is the Canonical Location

Every major platform (Codex, Ampcode, Warp, Factory.ai, Replit, Copilot, Claude Code, Cursor, Gemini, VS Code) reads from `.agents/skills/` in addition to their own native directory. **Always put skills in `.agents/skills/` first for maximum portability.**

```
your-project/
└── .agents/
    └── skills/
        └── your-skill-name/
            └── SKILL.md
```

---

## Platform Comparison Matrix

| Platform | Canonical Skill Dir | Also Reads From | Invocation | User-Level Skills |
|----------|--------------------|-----------------|-----------|--------------------|
| **Codex (OpenAI)** | `.agents/skills/` | `$HOME/.agents/skills/`, `/etc/codex/skills` | `/skills`, `$skill-name`, implicit | `$HOME/.agents/skills/` |
| **Ampcode** | `.agents/skills/` | `.claude/skills/`, `~/.claude/skills/`, `~/.config/agents/skills/` | Implicit, `/skill-name` | `~/.config/agents/skills/` |
| **Claude Code** | `.claude/skills/` | `.agents/skills/` | Implicit, description matching | `~/.claude/skills/` |
| **GitHub Copilot** | `.github/skills/` | `.claude/skills/`, `.agents/skills/` | Implicit | `~/.copilot/skills/`, `~/.claude/skills/`, `~/.agents/skills/` |
| **Warp** | `.agents/skills/` | `.warp/skills/`, `.claude/skills/`, `.codex/skills/`, `.cursor/skills/`, `.gemini/skills/`, `.copilot/skills/`, `.factory/skills/`, `.github/skills/`, `.opencode/skills/` | Implicit, `/{skill-name}`, natural language | `~/.agents/skills/`, `~/.warp/skills/` |
| **Factory.ai** | `.factory/skills/` | `.agent/skills/` (compatibility) | Implicit, `/{skill-name}` | `~/.factory/skills/` |
| **Replit** | `/.agents/skills/` | — | Implicit, Skills pane | User-level via profile |
| **Gemini (Google)** | `.gemini/skills/` | `.agents/skills/` | Implicit | `~/.gemini/skills/` |
| **Cursor** | `.cursor/skills/` | `.agents/skills/` | Implicit | `~/.cursor/skills/` |
| **VS Code Copilot** | `.github/skills/` | `.agents/skills/` | Implicit via Copilot agent mode | User settings sync |
| **Bolt.new** | `.agents/skills/` | — | Implicit | Not applicable (cloud) |

---

## Platform-Specific Details

### 1. OpenAI Codex

**Directory structure:**
```
project/
├── .agents/skills/
│   └── your-skill/
│       ├── SKILL.md              # Required
│       ├── scripts/              # Optional
│       ├── references/           # Optional
│       ├── assets/               # Optional
│       └── agents/
│           └── openai.yaml       # Optional: Codex-specific UI metadata
```

**`agents/openai.yaml` format** (adds Codex app UI metadata and tool pre-approval):
```yaml
interface:
  display_name: "Human-Readable Skill Name"
  short_description: "One-line description shown in skill picker"
  icon_small: "./assets/icon-16.svg"     # Optional
  icon_large: "./assets/icon-128.png"    # Optional
  brand_color: "#3B82F6"                 # Optional hex color
  default_prompt: "Optional pre-filled prompt for the skill"

policy:
  allow_implicit_invocation: true        # false = explicit /skill-name only

dependencies:
  tools:
    - type: "mcp"
      value: "openaiDeveloperDocs"
      description: "OpenAI Docs MCP server"
      transport: "streamable_http"
      url: "https://developers.openai.com/mcp"
```

**Install CLI:**
```bash
$skill-installer linear                   # Install curated skill by name
$skill-installer install the create-plan skill from the .experimental folder
$skill-installer install https://github.com/openai/skills/tree/main/skills/.experimental/create-plan
```

**Enable/disable without deleting** (`~/.codex/config.toml`):
```toml
[[skills.config]]
path = "/path/to/skill/SKILL.md"
enabled = false
```

**Key facts:**
- Codex scans `.agents/skills/` from CWD up to repo root
- Skills in `.system` are auto-installed by Codex itself
- If two skills share the same `name`, Codex shows both — no merge
- Detects skill changes automatically; restart if a new skill doesn't appear
- Use `/skills` in CLI or type `$` to explicitly mention a skill

---

### 2. Ampcode

**Directories read (in order):**
1. `.agents/skills/` — Workspace-level (recommended)
2. `.claude/skills/` — Claude Code compatibility
3. `~/.config/agents/skills/` — User-level skills
4. `~/.claude/skills/` — User-level Claude compatibility

**No platform-specific file required.** Standard SKILL.md works as-is.

**Key facts:**
- Ampcode fully implements the agentskills.io open standard
- Uses the same lazy-loading progressive disclosure model
- Skills improve tool-use performance in a context-efficient way
- Ampcode's own team uses skills extensively: Agent Sandbox, Agent Skill Creator, BigQuery, Tmux, Web Browser

---

### 3. Claude Code (Anthropic)

**Directories:**
- Project: `.claude/skills/` (primary) and `.agents/skills/`
- User: `~/.claude/skills/`

**XML optimization for Claude.** Claude Code parses XML tags exceptionally well. Use these in complex skills:
```xml
<instructions>
  Core workflow steps
</instructions>

<thinking>
  Before responding, work through:
  1. [Reasoning step 1]
  2. [Reasoning step 2]
</thinking>

<examples>
  <example>
    <input>...</input>
    <output>...</output>
  </example>
</examples>

<constraints>
  Hard rules the agent must never break
</constraints>
```

**Extended thinking trigger** (Claude 3.5+ Sonnet/Opus):
```markdown
Before generating the final response:
1. Enumerate all relevant considerations and their tradeoffs
2. Identify ambiguities and resolve with stated assumptions
3. Draft the core argument or analysis
4. Verify the draft against the user's goal
Then produce the final output.
```

**CLAUDE.md / AGENTS.md integration.** Skills should be referenced in your repo's `CLAUDE.md` or `AGENTS.md` with their full file path and description:
```markdown
## Available Skills

- `.claude/skills/conventional-commits/SKILL.md` — Write conventional commit messages
- `.claude/skills/db-migrate/SKILL.md` — Execute database migrations safely
```

---

### 4. GitHub Copilot

**Directories:**
- Project: `.github/skills/`, `.claude/skills/`, `.agents/skills/`
- Personal (CLI + coding agent): `~/.copilot/skills/`, `~/.claude/skills/`, `~/.agents/skills/`
- Organization/Enterprise: Coming soon

**Works with:**
- Copilot cloud agent (available in all GitHub repos)
- GitHub Copilot CLI (requires org policy enabled)
- VS Code Copilot agent mode

**Community resources:**
- `anthropics/skills` — Anthropic-maintained reference skills
- `github/awesome-copilot` — Community-contributed skill collection

---

### 5. Warp

**Warp reads from ALL of these directories** (scanning all for maximum compatibility):
```
Project-level:
.agents/skills/     ← recommended, universal
.warp/skills/
.claude/skills/
.codex/skills/
.cursor/skills/
.gemini/skills/
.copilot/skills/
.factory/skills/
.github/skills/
.opencode/skills/

User-level (global, available in all projects):
~/.agents/skills/
~/.warp/skills/
~/.claude/skills/
```

**Parameterized skills** (Warp-specific feature):
```markdown
## Arguments
When invoked as `/deploy staging`, `$ARGUMENTS` = "staging", `$ARGUMENTS[1]` = "staging"

Use `$ARGUMENTS[1]` for the first positional argument.
Use `$ARGUMENTS` for the full argument string.
Use `$1` as shorthand for first argument.
```

**Invocation:**
- Natural language: "Use the deploy skill to push to staging"
- Slash command: `/deploy` or `/deploy staging`
- Prompting with context: `/code-review focus on error handling`

**Skill name conflicts:** Warp prioritizes home directory (global) skills first, then higher directories (closer to repo root) for background resolution. For natural language, it shows all matching skills.

**Pre-built community skills:** `warpdotdev/oz-skills` on GitHub

**RULES vs SKILLS distinction** (Warp-specific):
- **Rules**: Persistent guidelines agents ALWAYS follow (constraints, preferences)
- **Skills**: Specific task workflows agents load ON DEMAND
- Don't conflate them — keep project constraints in Rules, workflows in Skills

---

### 6. Factory.ai (Droids)

**Directories:**
- Workspace: `.factory/skills/<skill-name>/SKILL.md`
- Personal: `~/.factory/skills/<skill-name>/SKILL.md`
- Compatibility: `.agent/skills/` (also scanned)

**Factory-specific frontmatter fields:**
```yaml
---
name: skill-name
description: What the skill does and when the Droid should invoke it
user-invocable: true            # false = Droid-only, hides from /slash menu
disable-model-invocation: true  # true = user-only, Droid can't auto-invoke
---
```

**When to use `disable-model-invocation: true`:**
- Deploy, send-notification, destructive ops — don't let Droid decide when to run these

**When to use `user-invocable: false`:**
- Background knowledge/context skills not meaningful as user commands (e.g., `legacy-system-context`)

**Invocation:**
- Natural language or `/skill-name` slash command
- Droids can chain skills together as part of larger workflows

**Companion: AGENTS.md** — Every Factory project should have an AGENTS.md at root documenting build commands, project layout, development patterns, git workflow, and security rules. Skills complement AGENTS.md but don't replace it.

---

### 7. Replit

**Directory:** `/.agents/skills/` (note the leading `/` — Replit project root)

**Scoping levels:**
- **Project-level**: `/.agents/skills/` — specific to one codebase, versioned with code
- **User-level**: Personal toolkit that follows you across projects
- **Enterprise**: Company-wide standards, pinned to agent input box

**Install methods:**
```bash
# From skills.sh registry
npx skills <skill-name> -a replit

# Manual: place in /.agents/skills/<skill-name>/SKILL.md
# Or upload via Skills pane in Workspace
```

**Community skills:** Browse at [skills.sh](https://skills.sh)

**Key facts:**
- Skills pane in Workspace for browsing, installing, managing
- Skills persist across Agent sessions and can be committed to version control
- Only `description` loads initially — full SKILL.md loads on activation

---

### 8. Gemini (Google AI)

**Directory:** `.gemini/skills/` (primary), also reads `.agents/skills/`

**User-level:** `~/.gemini/skills/`

**Note:** Gemini CLI and Google AI Studio are adopting the agentskills.io standard. Skills targeting Gemini follow the same SKILL.md format with no platform-specific additions required. For advanced Gemini integration through Vertex AI Agent Builder, see the translation pattern in the Vertex AI guide in `references/advanced-patterns.md`.

---

### 9. Bolt.new

**Directory:** `.agents/skills/` (cloud environment)

Bolt.new runs in a cloud-based development environment (StackBlitz). Skills are loaded per-project. No user-level skills (cloud context). Standard SKILL.md format, no platform-specific additions needed.

---

## Multi-Platform Deployment Strategy

For skills that need to work across ALL platforms simultaneously, use this directory structure:

```
your-project/
├── .agents/skills/              ← Universal (all platforms read this)
│   └── your-skill/
│       ├── SKILL.md
│       └── agents/
│           └── openai.yaml     ← Codex UI metadata (optional)
├── AGENTS.md                   ← Project context for Factory.ai + Claude Code
└── .claude/
    └── AGENTS.md               ← Claude Code specific context
```

**The `.agents/skills/` directory is your single source of truth.** Every platform listed in this guide reads from it. You do not need to duplicate skills across multiple platform directories — just keep them in `.agents/skills/` and add platform-specific config files alongside.

---

## Install via npx skills CLI

The cross-platform skill installer works for Replit, Codex, Copilot, and any agentskills.io-compliant tool:

```bash
# Generic install
npx skills <skill-name>

# Platform-targeted
npx skills <skill-name> -a replit
npx skills <skill-name> -a codex
npx skills <skill-name> -a copilot

# Publish your skill to the registry
npx skills publish ./your-skill-name
```

---

## Validation

```bash
# Install the reference library
pip install -q skills-ref

# Validate a single skill directory
agentskills validate ./your-skill-name/

# Validate all skills in a project
agentskills validate ./.agents/skills/
```
