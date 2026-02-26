# Troubleshooting

## `gh auth status` failed

Run:

```bash
gh auth login
```

Choose `GitHub.com` + `HTTPS` + browser login.

## `remote origin already exists`

Run:

```bash
git remote remove origin
git remote add origin <repo-url>
```

## `403 Permission denied`

- Confirm you are logged in to the correct GitHub account.
- Confirm you have write permission to the target repo.
- Re-run `gh auth login` if needed.

## `non-fast-forward` on push

Run:

```bash
git pull --rebase origin main
git push -u origin main
```

## Current branch is not `main`

Run:

```bash
git branch -M main
```
