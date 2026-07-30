# dotfiles

Personal Windows dotfiles for Carlos Schults. Includes git configuration and command-line shortcuts.

## What's inside

| Path | Contents |
|------|---------|
| `.gitconfig` | Git config template — aliases, diff settings, rebase config, GPG signing |
| `bat/generic/` | Shortcuts installed on every machine |
| `bat/personal/` | Personal shortcuts (church, personal projects) |
| `docs/shortcuts.md` | Full reference for all shortcuts |
| `docs/binaries.md` | Tools installed by setup.ps1 and manual install notes |

## Setup

Clone the repo and run `setup.ps1`:

```powershell
git clone https://github.com/carlosschults/dotfiles C:\git\dotfiles
cd C:\git\dotfiles
.\setup.ps1
```

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `-Profile` | `work` | `work` or `personal` — controls which bat files are deployed and which email is suggested |
| `-UtilsDir` | `C:\utils` | Where bat files are copied on this machine |
| `-DotfilesDir` | *(repo root)* | Path to the cloned repo |
| `-DryRun` | off | Preview all actions without making changes |

**Example — personal machine:**
```powershell
.\setup.ps1 -Profile personal
```

**Example — work machine with a custom utils directory:**
```powershell
.\setup.ps1 -Profile work -UtilsDir D:\utils
```

**Dry run:**
```powershell
.\setup.ps1 -DryRun
```

### What setup.ps1 does

1. Prompts for name, email, and GPG signing key
2. Writes `~/.gitconfig` from the template (backs up any existing file first)
3. Ensures the `%src%` environment variable is set (your code root, e.g. `C:\git`)
4. Copies bat files to `$UtilsDir` and adds it to your User PATH
5. Offers to install optional tools (jq, wget, GitHub CLI, Notepad++) via winget

### After running

- Open a new terminal for the PATH change to take effect
- Import your GPG key if you use commit signing:
  ```
  gpg --import your-key.asc
  ```
- Add machine-specific safe directories as needed:
  ```
  git config --global safe.directory C:/path/to/repo
  ```

## Shortcuts

See [docs/shortcuts.md](docs/shortcuts.md) for the full reference.

Quick overview: git shortcuts (`gs`, `gco`, `gcm`, …), Docker/Kubernetes (`dc`, `k`, `pods`, …), navigation (`sr`, `dw`, `od`, …), and general utilities (`vs`, `n`, `limpar`, …).

## Binaries

Tools that are not tracked in git. See [docs/binaries.md](docs/binaries.md) for winget install commands and manual install notes.

## Adding machine-local shortcuts

Create bat files in `C:\git\dotfiles\bat\local\` — that folder is gitignored, so they stay on your machine without polluting the repo.
