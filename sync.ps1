param(
    [string]$Message = ""
)

$ErrorActionPreference = 'Stop'

Set-Location $PSScriptRoot

function Fail($msg) {
    Write-Host "[sync] $msg" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Fail "git 未安装或不在 PATH 中。"
}

try {
    $repoRoot = (git rev-parse --show-toplevel).Trim()
} catch {
    Fail "当前目录不是 Git 仓库。"
}

Set-Location $repoRoot

$status = git status --porcelain
if (-not $status) {
    Write-Host "[sync] 没有检测到变更，无需同步。" -ForegroundColor Yellow
    exit 0
}

if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = "sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

Write-Host "[sync] 仓库: $repoRoot" -ForegroundColor Cyan
Write-Host "[sync] 提交信息: $Message" -ForegroundColor Cyan
Write-Host "[sync] git add -A" -ForegroundColor DarkGray
git add -A

Write-Host "[sync] git commit -m '$Message'" -ForegroundColor DarkGray
git commit -m "$Message"

Write-Host "[sync] git push" -ForegroundColor DarkGray
git push

Write-Host "[sync] 同步完成。" -ForegroundColor Green
