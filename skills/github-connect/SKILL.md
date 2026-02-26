---
name: github-connect
description: Connect a local project to GitHub and publish code safely with Git and GitHub CLI. Use when a user asks to log in to GitHub from terminal, add/set a remote, create a repository, push code, verify auth, or troubleshoot common GitHub connection errors on Windows.
---

# Github Connect

## Quick Start

Use `scripts/github_connect.ps1` for a guided, no-surprises flow:

```powershell
pwsh -File scripts/github_connect.ps1 -RepoName my-project
```

Use `-Private` to create a private repo:

```powershell
pwsh -File scripts/github_connect.ps1 -RepoName my-project -Private
```

## Workflow

1. Confirm tools are available (`git`, optional `gh`).
2. Initialize Git repo if missing.
3. Ensure at least one commit exists.
4. Authenticate with GitHub CLI if available.
5. Create or reuse GitHub repo.
6. Set `origin` to the GitHub URL.
7. Push current branch and set upstream.

## If `gh` Is Missing

Use plain Git with a pre-created remote URL:

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <your-github-repo-url>
git push -u origin main
```

## Troubleshooting

Read `references/troubleshooting.md` for common fixes:

- auth failures
- 403 permission denied
- remote already exists
- non-fast-forward push
- branch name mismatch
