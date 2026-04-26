# skogai/.github

Central configuration hub for the [skogai](https://github.com/skogai) GitHub organization. Files here serve as org-wide defaults for all repositories.

## What lives here

| Path | Purpose |
|---|---|
| `profile/README.md` | Org profile shown on `github.com/skogai` |
| `workflow-templates/` | Starter workflows discoverable via GitHub Actions UI |
| `CODE_OF_CONDUCT.md` | Org-wide default |
| `CONTRIBUTING.md` | Org-wide default |
| `SECURITY.md` | Org-wide default |
| `SUPPORT.md` | Org-wide default |
| `.github/ISSUE_TEMPLATE/` | Default issue forms |
| `.github/PULL_REQUEST_TEMPLATE.md` | Default PR template |

## Workflow templates

Three Claude Code templates are available. Add one to any repo via the GitHub Actions UI ("New workflow" → skogai section) or manually:

```bash
mkdir -p .github/workflows
curl -o .github/workflows/claude.yml \
  https://raw.githubusercontent.com/skogai/.github/main/workflow-templates/claude-on-mention.yml
```

| Template | Trigger |
|---|---|
| `claude-on-mention.yml` | `@claude` in issues, PRs, comments |
| `claude-pr-review.yml` | PR opened or updated |
| `claude-manual.yml` | Manual workflow dispatch |

All templates require `CLAUDE_CODE_OAUTH_TOKEN` set as an org-level secret.

## Resources

- [GitHub: Default community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [GitHub: Creating starter workflows](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization)
- [Claude Code Action](https://github.com/anthropics/claude-code-action)
