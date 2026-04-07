# Platform Sub-Agent Capability Matrix

Last updated: 2026-04-07

## Full Sub-Agent Support (spawn + parallel + orchestrate from skill/AGENTS.md)

### Codex CLI
- **Mechanism:** `codex --yolo exec "prompt"` spawns headless subagents; background jobs with `& ... & wait`
- **Parallel:** Yes — background shell jobs or multi-thread spawning via `spawn_agent`
- **Limits:** Global thread cap (default 32, shared across sessions); `max_spawn_depth` controls nesting (default 2, depth=3 requires config)
- **Skill-triggered:** Yes — AGENTS.md can instruct orchestration; skills can spawn via bash tool
- **Config:** `~/.codex/config.toml` → `max_threads`, `agents.max_spawn_depth`
- **Maturity:** Production-ready, most configurable

### Claude Code / Ampcode
- **Mechanism:** Built-in `Task` tool spawns subagents; Agent Teams (experimental) for true parallel with shared task list
- **Parallel:** Yes — multiple Task calls in single message execute concurrently; Agent Teams use tmux panes
- **Limits:** Rate limits per API tier; context window per subagent is independent
- **Skill-triggered:** Yes — CLAUDE.md / AGENTS.md can hint at parallel patterns; subagent definitions in code
- **Config:** `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` for teams; git worktree isolation per subagent
- **Maturity:** Task tool is stable; Agent Teams are experimental but powerful

### Cursor
- **Mechanism:** Built-in subagents (Explore, Bash, Browser) + custom subagents; `run_in_background: true` for async
- **Parallel:** Yes — up to 4 concurrent subagents per batch (default); rolling window pattern available via scripts
- **Limits:** 4 parallel slots default; batch-and-wait unless rolling window configured
- **Skill-triggered:** Yes — skills can define orchestration; .cursor/agents/ for custom subagents
- **Config:** Foreground vs background mode; custom subagent definitions
- **Maturity:** Production (since Cursor 2.4)

### Gemini CLI
- **Mechanism:** Subagents as named tools; `@agent-name` syntax for explicit delegation; Jules extension for async background work
- **Parallel:** Yes — via Maestro extension (12 specialized subagents, parallel dispatch default); native subagents are sequential by default
- **Limits:** Experimental subagents flag required in settings.json; Maestro manages concurrency via `max_concurrent` + `stagger_delay_seconds`
- **Skill-triggered:** Yes — AGENTS.md read; subagent definitions in config
- **Config:** `settings.json` experimental flags; Maestro YAML config
- **Maturity:** Subagents experimental; Maestro community extension is mature

### Replit
- **Mechanism:** Agent 4 parallel task execution; auto-splits large tasks into sub-agents; merge conflict resolution via specialized sub-agents
- **Parallel:** Yes — multiple agents on different parts simultaneously; task-based workflow with intelligent sequencing
- **Limits:** Parallel execution is Pro/Enterprise (temporarily Core); effort-based pricing means parallel = faster credit burn
- **Skill-triggered:** Partially — task-based interface, not direct skill invocation from AGENTS.md
- **Config:** Built into platform; no user-configurable parallelism settings
- **Maturity:** Production (Agent 4, March 2026)

## Partial Sub-Agent Support (limited or platform-managed)

### Warp / Oz
- **Mechanism:** Agent Management Panel for running multiple agents; Oz agents via terminal panes and cloud execution
- **Parallel:** Yes at platform level — multiple agents across panes/tabs; not skill-triggered subagent spawning
- **Limits:** Parallelism is terminal-session-level, not programmatic from within a skill
- **Skill-triggered:** Skills (Oz skills) execute individually; no skill-to-subagent spawning API
- **Config:** Agent Management Panel; local vs cloud execution modes
- **Maturity:** Platform-level parallel is production; no skill-level orchestration

### GitHub Copilot
- **Mechanism:** Mission Control for multi-repo task dispatch; Fleet mode (`/fleet`) for parallel CLI agents; SQUAD extension for team orchestration
- **Parallel:** Yes via Mission Control / Fleet — but subagents in VS Code Agent Mode are sequential
- **Limits:** CLI Fleet mode is parallel; IDE Agent Mode subagents are sequential (as of Dec 2025)
- **Skill-triggered:** agents.md with frontmatter defines agent personas; SQUAD enables team collaboration
- **Config:** Mission Control UI; Fleet mode in CLI; SQUAD for team orchestration
- **Maturity:** Fleet/Mission Control production; IDE subagents sequential only

### Factory.ai
- **Mechanism:** Droids execute assigned tasks; coordinator pattern available
- **Parallel:** Platform-managed — Droids can work in parallel on different tasks
- **Limits:** Not user-configurable from skill level
- **Skill-triggered:** Skills inform Droid behaviour but don't spawn sub-Droids
- **Config:** Factory platform manages orchestration
- **Maturity:** Production but platform-controlled

## No Sub-Agent Support

### Bolt.new
- **Mechanism:** Single-agent execution per task
- **Parallel:** No
- **Skill-triggered:** AGENTS.md read for context but no orchestration capability
- **Maturity:** N/A

### VS Code (standalone, no Copilot/Cursor)
- **Mechanism:** Extension-dependent; no native sub-agent support
- **Parallel:** No (unless using Copilot extension with Fleet)
- **Maturity:** N/A

## Orchestration Strategy by Platform Tier

### Tier 1 — Full orchestration (skill can spawn and manage subagents)
Codex CLI, Claude Code, Cursor, Gemini CLI (with Maestro), Replit Agent 4

**Strategy:** Orchestrator skill directly instructs subagent spawning with specific prompts, tool restrictions, and parallelism hints. AGENTS.md Orchestration Map can include explicit spawn instructions.

### Tier 2 — Platform-managed parallelism (user coordinates, platform executes)
Warp/Oz, GitHub Copilot (Mission Control/Fleet), Factory.ai

**Strategy:** Orchestrator skill recommends task decomposition and sequencing. User or platform dispatches agents. AGENTS.md Orchestration Map focuses on task ordering and dependency hints rather than spawn commands.

### Tier 3 — Sequential only (no parallelism)
Bolt.new, VS Code standalone, GitHub Copilot IDE Agent Mode

**Strategy:** Orchestrator skill provides phase-based guidance. All work is sequential. AGENTS.md Orchestration Map is a linear workflow with checkpoints.

## Cross-Platform Orchestration Pattern

The safest cross-platform pattern is **file-based coordination**:
1. Orchestrator writes a task plan to a file (e.g., `docs/task-plan.md`)
2. Each task has status (PENDING / IN_PROGRESS / DONE / BLOCKED)
3. Dependencies are explicit (Task B depends on Task A)
4. On Tier 1 platforms: subagents pick up tasks and update status
5. On Tier 2 platforms: user dispatches tasks; agents read the plan
6. On Tier 3 platforms: agent works through the plan sequentially

This pattern works everywhere because it only requires file read/write — the universal primitive across all platforms.
