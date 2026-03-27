param(
    [string]$Message = ""
)

$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot

function Fail($msg) {
    Write-Host "[sync] ERROR: $msg" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail "git is not installed or not in PATH."
}

try {
    $repoRoot = (git rev-parse --show-toplevel).Trim()
} catch {
    Fail "current directory is not a Git repository."
}

Set-Location $repoRoot

$status = git status --porcelain
if (-not $status) {
    Write-Host "[sync] No changes detected. Nothing to sync." -ForegroundColor Yellow
    exit 0
}

if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = "sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

Write-Host "[sync] Repository: $repoRoot" -ForegroundColor Cyan
Write-Host "[sync] Commit message: $Message" -ForegroundColor Cyan
Write-Host "[sync] Change preview:" -ForegroundColor Cyan
git status --short
Write-Host ""

Write-Host "[sync] git add -A" -ForegroundColor DarkGray
git add -A

Write-Host "[sync] git commit -m '$Message'" -ForegroundColor DarkGray
git commit -m "$Message"

Write-Host "[sync] git push" -ForegroundColor DarkGray
git push

Write-Host "[sync] Done." -ForegroundColor Green
