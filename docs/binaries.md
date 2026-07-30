# Binaries

These executables were previously kept in the utils folder but are not tracked in git.
`setup.ps1` will offer to install the winget-managed ones automatically.

## Installed by setup.ps1

| Tool | Winget ID |
|------|-----------|
| jq | `jqlang.jq` |
| wget | `JernejSimoncic.Wget` |
| GitHub CLI | `GitHub.cli` |
| Notepad++ | `Notepad++.Notepad++` |

## PowerShell built-ins (no install needed)

| Old binary | PowerShell equivalent |
|------------|----------------------|
| `GuidGen.exe` | `[guid]::NewGuid().ToString()` |
| `fciv.exe` | `Get-FileHash -Algorithm MD5 <file>` |

## Manual installs

| Binary | Notes |
|--------|-------|
| `renamer.exe` | Unknown origin — install manually |
| `dt.exe` | Unknown origin — install manually |
| `cplines.exe` | Unknown origin — install manually |
