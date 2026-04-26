# Installing Claude Code Workflows

## Prerequisites

Verify `CLAUDE_CODE_OAUTH_TOKEN` is set as an org-level secret:

```bash
gh secret list --org skogai | grep CLAUDE_CODE_OAUTH_TOKEN
```

## Option 1: GitHub Actions UI

1. Go to your repository → **Actions** → **New workflow**
2. Look for the **skogai** section
3. Choose a Claude Code template and commit

> UI discovery of org templates can take a few minutes after the template is pushed.

## Option 2: Manual install

```bash
mkdir -p .github/workflows

# @claude mentions (most common)
curl -o .github/workflows/claude.yml \
  https://raw.githubusercontent.com/skogai/.github/main/workflow-templates/claude-on-mention.yml

# Auto PR review
curl -o .github/workflows/claude-pr-review.yml \
  https://raw.githubusercontent.com/skogai/.github/main/workflow-templates/claude-pr-review.yml

# Manual dispatch
curl -o .github/workflows/claude-manual.yml \
  https://raw.githubusercontent.com/skogai/.github/main/workflow-templates/claude-manual.yml

git add .github/workflows/claude*.yml
git commit -m "feat: add Claude Code workflows"
git push
```

## Verifying

```bash
gh workflow list | grep -i claude
```

## Customizing

### Limit to specific paths

```yaml
on:
  pull_request:
    types: [opened, synchronize]
    paths:
      - "src/**/*.py"
```

### Restrict allowed tools

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
    claude_args: '--allowed-tools "Bash(gh pr:*),Read,Grep"'
```

## Troubleshooting

| Symptom | Check |
|---|---|
| `@claude` not responding | Workflow file exists? `CLAUDE_CODE_OAUTH_TOKEN` set at org level? |
| Workflow not triggering | `gh workflow list` — is it active? Check permissions block. |
| Permission errors | Workflow needs `contents: write`, `pull-requests: write`, `issues: write`, `id-token: write` |
