# install.ps1 -- Windows global setup for agent-loom
#
# Run this once on any Windows machine. Skills become available in Codex CLI,
# Ampcode, Claude Code, Warp, Gemini CLI, GitHub Copilot, and any other
# agentskills.io-compatible tool -- no per-project setup needed.
#
# Usage (in PowerShell, run as Administrator for symlinks):
#   .\install.ps1              # junction-link all skills globally
#   .\install.ps1 -Copy        # copy instead of link (safer, no admin needed)
#   .\install.ps1 -Update      # pull latest from git and refresh links
#
# NOTE: Junction links (default) work without Developer Mode on Windows.
# They behave like symlinks for directories -- tools see live files.

param(
    [switch]$Copy,
    [switch]$Update
)

$ErrorActionPreference = "Stop"

$RepoDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SkillsSrc  = Join-Path $RepoDir ".agents\skills"

# -- Target directories (all platforms read at least one of these) --
$Targets = @(
    "$env:USERPROFILE\.agents\skills",    # Codex, Warp, Gemini, Replit, Bolt.new
    "$env:USERPROFILE\.claude\skills"     # Claude Code, Ampcode
)

$Mode = if ($Copy) { "copy" } else { "junction" }

if ($Update) {
    Write-Host "-> Pulling latest skills..."
    git -C $RepoDir pull
    Write-Host "-> Refreshing links..."
}

Write-Host ""
Write-Host "agent-loom installer (Windows)"
Write-Host "======================================"
Write-Host "Source : $SkillsSrc"
Write-Host "Mode   : $Mode"
Write-Host ""

function Install-Skill {
    param([string]$SkillDir)

    $SkillName = Split-Path -Leaf $SkillDir

    foreach ($TargetBase in $Targets) {
        # Ensure target base exists
        if (-not (Test-Path $TargetBase)) {
            New-Item -ItemType Directory -Path $TargetBase -Force | Out-Null
        }

        $Dest = Join-Path $TargetBase $SkillName

        # Remove stale junction or directory if it exists
        if (Test-Path $Dest) {
            Remove-Item -Recurse -Force $Dest
        }

        if ($Mode -eq "copy") {
            Copy-Item -Recurse -Force $SkillDir $Dest
            Write-Host "  [copied]   $Dest"
        } else {
            # Use junction (works without Developer Mode, no admin needed for dirs)
            cmd /c mklink /J "$Dest" "$SkillDir" | Out-Null
            Write-Host "  [linked]   $Dest -> $SkillDir"
        }
    }
}

# -- Install each skill --
$SkillCount = 0
Get-ChildItem -Path $SkillsSrc -Directory | ForEach-Object {
    $SkillMd = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $SkillMd) {
        Install-Skill -SkillDir $_.FullName
        $SkillCount++
    }
}

# -- Summary --
Write-Host ""
Write-Host "Done: $SkillCount skill(s) installed globally"
Write-Host ""
Write-Host "Works immediately in:"
Write-Host "  * Codex CLI    -- run 'codex' in any project, type /skills to verify"
Write-Host "  * Ampcode      -- skills auto-load on next session"
Write-Host "  * Claude Code  -- run 'claude' in any project"
Write-Host "  * Warp         -- type / in agent chat to see skill list"
Write-Host "  * Gemini CLI   -- skills auto-load on next session"
Write-Host "  * GitHub Copilot CLI -- skills auto-load on next session"
Write-Host ""
Write-Host "To update skills later:"
Write-Host "  .\install.ps1 -Update"
Write-Host ""
Write-Host "To uninstall:"
Write-Host "  .\uninstall.ps1"
Write-Host ""
Write-Host "To add skills to a specific project (for teammates):"
Write-Host '  Copy-Item -Recurse $env:USERPROFILE\.agents\skills\<skill-name> your-project\.agents\skills'
Write-Host ""
