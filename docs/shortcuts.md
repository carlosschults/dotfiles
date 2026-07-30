# Shortcuts Reference

All shortcuts are `.bat` files deployed to `C:\utils` (or your configured `$UtilsDir`) by `setup.ps1`.

## Git

| Command | Expands to |
|---------|-----------|
| `g <args>` | `git <args>` |
| `gs` | `git status` |
| `gb <args>` | `git branch <args>` |
| `gc <args>` | `git commit <args>` |
| `gcm <msg>` | `git commit -m <msg>` |
| `gcam <msg>` | `git commit -am <msg>` |
| `gco <args>` | `git checkout <args>` |
| `gcob <branch>` | `git checkout -b <branch>` |
| `gi <args>` | `git init <args>` |
| `gl <args>` | `git log <args>` |
| `glo <args>` | `git log --oneline <args>` |
| `gfa` | `git fetch --all` |
| `gpl <args>` | `git pull <args>` |
| `gps <args>` | `git push <args>` |
| `adog` | `git log --all --decorate --oneline --graph` |

## Docker / Kubernetes / .NET

| Command | Expands to |
|---------|-----------|
| `dc <args>` | `docker <args>` |
| `dn <args>` | `dotnet <args>` |
| `k <args>` | `kubectl <args>` |
| `pods` | `kubectl get pods` |
| `deps` | `kubectl get deployments` |
| `serv` | `kubectl get services` |
| `services` | `kubectl get services` |

## Navigation

| Command | Goes to |
|---------|---------|
| `c` | `C:\` |
| `dw` | `%UserProfile%\Downloads` |
| `od` | `%OneDrive%` |
| `sr` | `%src%` (your code root, e.g. `C:\git`) |
| `us` | `%UserProfile%` |
| `ut` | `C:\utils` |
| `wr` | `%OneDrive%\work` |
| `in` | `%OneDrive%\#inbox` |

All navigation shortcuts also open Explorer when invoked directly (not from another script).

## Utilities

| Command | What it does |
|---------|-------------|
| `cat <file>` | Print file contents (`type`) |
| `ls <args>` | List directory (`dir`) |
| `clear` | Clear the terminal (`cls`) |
| `mcd <dir>` | Create directory and `cd` into it |
| `n <file>` | Open file in Notepad++ (falls back to Notepad) |
| `op <path>` | Open path in Explorer |
| `vs` | Find and open the first `.sln` / `.slnx` file recursively |
| `limpar` | Clear recent files, Run MRU, and TypedPaths from the registry |

## Personal (installed with `--profile personal` only)

| Command | What it does |
|---------|-------------|
| `ig` | Navigate to `%OneDrive%\Igreja` |
| `sl` | Navigate to the latest dated folder inside `%OneDrive%\Igreja\Slides` |
| `ev` | Navigate to `%OneDrive%\evernote` |
| `pd` | Navigate to `%src%\projects\project-david` |
| `mu` | Open liturgical music websites in the browser |
