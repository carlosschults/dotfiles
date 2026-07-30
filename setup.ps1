param(
    [string] $Profile   = "work",           # "work" | "personal"
    [string] $UtilsDir  = "C:\utils",       # where bat files are deployed on this machine
    [string] $DotfilesDir = $PSScriptRoot,  # root of the cloned dotfiles repo
    [switch] $DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step([string]$msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok([string]$msg)   { Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Skip([string]$msg) { Write-Host "    [--] $msg" -ForegroundColor Gray }
function Write-Warn([string]$msg) { Write-Host "    [!!] $msg" -ForegroundColor Yellow }

# ---------------------------------------------------------------------------
# Phase 1 — Identity collection
# ---------------------------------------------------------------------------
Write-Step "Identity"

$defaultName = "Carlos Schults"
$nameInput = Read-Host "Name [$defaultName]"
$gitName = if ($nameInput.Trim() -ne "") { $nameInput.Trim() } else { $defaultName }

$defaultEmail = if ($Profile -eq "personal") { "carlos.schults@gmail.com" } else { "" }
$emailPrompt  = if ($defaultEmail -ne "") { "Email [$defaultEmail]" } else { "Email (work address)" }
do {
    $emailInput = Read-Host $emailPrompt
    $gitEmail   = if ($emailInput.Trim() -ne "") { $emailInput.Trim() } else { $defaultEmail }
    if ($gitEmail -eq "") { Write-Warn "Email cannot be empty for work profile." }
} while ($gitEmail -eq "")

$defaultKey = "CBD6303F15BD5991"
$keyInput   = Read-Host "GPG signing key [$defaultKey] (leave blank to disable signing)"
$gpgKey     = if ($keyInput.Trim() -ne "") { $keyInput.Trim() } else { $defaultKey }
$gpgSign    = $gpgKey -ne ""

Write-Host ""
Write-Warn "Remember to import your GPG key separately:"
Write-Warn "  gpg --import your-key.asc"
Write-Warn "  gpg --list-secret-keys"

# ---------------------------------------------------------------------------
# Phase 2 — Validate dotfiles directory
# ---------------------------------------------------------------------------
Write-Step "Validating dotfiles directory: $DotfilesDir"

foreach ($sub in @(".gitconfig", "bat\generic")) {
    if (-not (Test-Path (Join-Path $DotfilesDir $sub))) {
        Write-Error "Expected '$sub' not found in '$DotfilesDir'. Is this the right dotfiles directory?"
    }
}
Write-Ok "Dotfiles directory looks good."

# ---------------------------------------------------------------------------
# Phase 3 — Install gitconfig
# ---------------------------------------------------------------------------
Write-Step "Installing gitconfig"

$templatePath = Join-Path $DotfilesDir ".gitconfig"
$destPath     = Join-Path $env:USERPROFILE ".gitconfig"
$content      = Get-Content $templatePath -Raw -Encoding UTF8

$content = $content -replace '\{\{GIT_USER_NAME\}\}',  $gitName
$content = $content -replace '\{\{GIT_USER_EMAIL\}\}',  $gitEmail
$content = $content -replace '\{\{GPG_SIGNING_KEY\}\}', $gpgKey

if (-not $gpgSign) {
    $content = $content -replace 'gpgsign = true', 'gpgsign = false'
}

if (Test-Path $destPath) {
    $backup = "$destPath.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    if (-not $DryRun) { Copy-Item $destPath $backup }
    Write-Warn "Backed up existing .gitconfig to $backup"
}

if (-not $DryRun) {
    [System.IO.File]::WriteAllText($destPath, $content, [System.Text.UTF8Encoding]::new($false))
}
Write-Ok ".gitconfig written to $destPath"

# ---------------------------------------------------------------------------
# Phase 4 — Ensure %src% env var
# ---------------------------------------------------------------------------
Write-Step "Checking %src% environment variable"

$srcVar = [Environment]::GetEnvironmentVariable("src", "User")
if (-not $srcVar) {
    $srcInput = Read-Host "Enter your source/code root directory (e.g. C:\git)"
    if (-not $DryRun) {
        [Environment]::SetEnvironmentVariable("src", $srcInput.Trim(), "User")
    }
    Write-Ok "Set %src% = $($srcInput.Trim())"
} else {
    Write-Skip "%src% already set to '$srcVar'"
}

# ---------------------------------------------------------------------------
# Phase 5 — Deploy bat files to $UtilsDir and update PATH
# ---------------------------------------------------------------------------
Write-Step "Deploying bat files to $UtilsDir"

if (-not $DryRun) {
    New-Item -ItemType Directory -Force $UtilsDir | Out-Null
}

$sources = @(Join-Path $DotfilesDir "bat\generic")
if ($Profile -eq "personal") {
    $sources += Join-Path $DotfilesDir "bat\personal"
}

foreach ($src in $sources) {
    if (Test-Path $src) {
        Get-ChildItem "$src\*.bat" | ForEach-Object {
            $dest = Join-Path $UtilsDir $_.Name
            if (-not $DryRun) { Copy-Item $_.FullName $dest -Force }
            Write-Ok "Copied $($_.Name)"
        }
    }
}

Write-Step "Updating PATH"

$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$parts = $currentPath -split ";" | Where-Object { $_.Trim() -ne "" }

if ($parts -notcontains $UtilsDir) {
    if (-not $DryRun) {
        $newPath = ($parts + $UtilsDir) -join ";"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    }
    Write-Ok "Added $UtilsDir to User PATH"
} else {
    Write-Skip "$UtilsDir already in User PATH"
}

# ---------------------------------------------------------------------------
# Phase 6 — Optional tool installs
# ---------------------------------------------------------------------------
Write-Step "Optional tools"

$tools = @(
    [pscustomobject]@{ Name = "jq";          WingetId = "jqlang.jq";              Check = "jq" },
    [pscustomobject]@{ Name = "wget";         WingetId = "JernejSimoncic.Wget";    Check = "wget" },
    [pscustomobject]@{ Name = "GitHub CLI";   WingetId = "GitHub.cli";             Check = "gh" },
    [pscustomobject]@{ Name = "Notepad++";    WingetId = "Notepad++.Notepad++";    Check = "notepad++" }
)

$skippedManual = @()

foreach ($tool in $tools) {
    $already = $null -ne (Get-Command $tool.Check -ErrorAction SilentlyContinue)
    if ($already) {
        Write-Skip "$($tool.Name) already installed — skipping"
        continue
    }
    $answer = Read-Host "    Install $($tool.Name) (winget install $($tool.WingetId))? [y/N]"
    if ($answer.Trim() -match '^[Yy]') {
        if (-not $DryRun) {
            winget install --id $tool.WingetId --silent --accept-package-agreements --accept-source-agreements
        }
        Write-Ok "$($tool.Name) installed"
    } else {
        Write-Skip "Skipped $($tool.Name)"
    }
}

Write-Host ""
Write-Warn "The following tools have no known winget ID and must be installed manually:"
Write-Warn "  renamer.exe, dt.exe, cplines.exe"
Write-Warn "  See docs/binaries.md for details."

# ---------------------------------------------------------------------------
# Phase 7 — Summary
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "  Setup complete!" -ForegroundColor Cyan
Write-Host "----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "  Profile    : $Profile"
Write-Host "  Name       : $gitName"
Write-Host "  Email      : $gitEmail"
Write-Host "  GPG sign   : $(if ($gpgSign) { $gpgKey } else { 'disabled' })"
Write-Host "  Utils dir  : $UtilsDir"
Write-Host "----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "  Next steps:"
Write-Host "    1. Open a new terminal (PATH change takes effect on restart)"
Write-Host "    2. Import your GPG key if using signing:"
Write-Host "         gpg --import your-key.asc"
Write-Host "    3. Add machine-specific safe directories as needed:"
Write-Host "         git config --global safe.directory C:/path/to/repo"
Write-Host "    4. Install binaries — see docs/binaries.md"
Write-Host "================================================================" -ForegroundColor Cyan
