param(
    [Parameter(Mandatory = $true)]
    [string]$RepoName,

    [switch]$Private
)

$ErrorActionPreference = "Stop"

function Has-Command([string]$Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (-not (Has-Command "git")) {
    throw "git not found. Install Git first: https://git-scm.com/downloads"
}

$branch = "main"

if (-not (Test-Path ".git")) {
    git init | Out-Null
}

if (-not (git rev-parse --verify HEAD 2>$null)) {
    git add -A
    git commit -m "Initial commit" | Out-Null
}

if (Has-Command "gh") {
    gh auth status 1>$null 2>$null
    if ($LASTEXITCODE -ne 0) {
        gh auth login
    }

    $visibility = if ($Private) { "--private" } else { "--public" }

    gh repo view "$RepoName" 1>$null 2>$null
    if ($LASTEXITCODE -ne 0) {
        gh repo create "$RepoName" $visibility --source . --remote origin --push
        exit 0
    }

    $url = "https://github.com/$((gh api user --jq .login).Trim())/$RepoName.git"
    git remote remove origin 2>$null
    git remote add origin $url
}
else {
    Write-Host "gh not found. Install GitHub CLI: https://cli.github.com/"
    Write-Host "Then run: gh auth login"
    Write-Host "Or manually add origin: git remote add origin <repo-url>"
    exit 1
}

git branch -M $branch
git push -u origin $branch
Write-Host "Done. Repo connected and pushed."