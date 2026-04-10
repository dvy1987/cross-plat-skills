# uninstall.ps1 -- Remove agent-loom from global skill directories
#
# Only removes junctions/symlinks that point into this repo. User-owned skills
# (real directories or links pointing elsewhere) are never touched.
#
# Usage:
#   .\uninstall.ps1              # remove all repo-managed links
#   .\uninstall.ps1 -DryRun     # show what would be removed without removing

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$RepoDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SkillsSrc  = Join-Path $RepoDir ".agents\skills"

# -- Target directories (must match install.ps1) --
$Targets = @(
    "$env:USERPROFILE\.agents\skills",
    "$env:USERPROFILE\.claude\skills"
)

Write-Host ""
Write-Host "agent-loom uninstaller (Windows)"
Write-Host "========================================"
Write-Host "Source : $SkillsSrc"
if ($DryRun) {
    Write-Host "Mode   : dry-run (no changes will be made)"
}
Write-Host ""

# -- Remove repo-managed junctions from each target --
$RemoveCount = 0
$SkipCount   = 0

foreach ($TargetBase in $Targets) {
    if (-not (Test-Path $TargetBase)) {
        Write-Host "  [skip]     $TargetBase (does not exist)"
        continue
    }

    Write-Host "  Scanning   $TargetBase"

    Get-ChildItem -Path $TargetBase -Directory | ForEach-Object {
        $Entry = $_
        $EntryPath = $Entry.FullName

        # Check if this is a junction or symlink (ReparsePoint)
        if (-not ($Entry.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
            Write-Host "    [skip]     $($Entry.Name) (real directory, not a link)"
            $script:SkipCount++
            return
        }

        # Resolve the junction target (Target can be an array, take the first)
        $LinkTargetRaw = (Get-Item $EntryPath).Target
        if (-not $LinkTargetRaw) {
            Write-Host "    [skip]     $($Entry.Name) (could not resolve link target)"
            $script:SkipCount++
            return
        }
        if ($LinkTargetRaw -is [array]) {
            $LinkTarget = $LinkTargetRaw[0]
        } else {
            $LinkTarget = $LinkTargetRaw
        }

        # Only remove if junction points into THIS repo's skills directory
        if (-not $LinkTarget.StartsWith($SkillsSrc, [System.StringComparison]::OrdinalIgnoreCase)) {
            Write-Host "    [skip]     $($Entry.Name) (points elsewhere: $LinkTarget)"
            $script:SkipCount++
            return
        }

        if ($DryRun) {
            Write-Host "    [would rm] $EntryPath -> $LinkTarget"
        } else {
            # Junctions need cmd /c rmdir to avoid recursing into the target
            cmd /c rmdir "$EntryPath" 2>$null
            if (Test-Path $EntryPath) { Remove-Item -Force $EntryPath }
            Write-Host "    [removed]  $EntryPath -> $LinkTarget"
        }
        $script:RemoveCount++
    }

    # If the target directory is now empty, remove it (but not the parent)
    if (-not $DryRun -and (Test-Path $TargetBase)) {
        $Remaining = Get-ChildItem -Path $TargetBase -Force -ErrorAction SilentlyContinue
        if (-not $Remaining) {
            Remove-Item -Force $TargetBase
            Write-Host "  [cleaned]  $TargetBase (was empty)"
        }
    }
}

# -- Summary --
Write-Host ""
if ($DryRun) {
    Write-Host "Dry run: $RemoveCount skill(s) would be removed, $SkipCount skipped"
} else {
    Write-Host "Done: $RemoveCount skill(s) removed, $SkipCount skipped"
}
Write-Host ""
