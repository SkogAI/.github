---
name: skogai/.github
description: Organization-level GitHub configurations and reusable workflows.
---

# SkogAI/.github

Organization-level GitHub configurations and reusable workflows.

## Claude Code Workflow

Add these two lines to any workflow:

```yaml
uses: SkogAI/.github/.github/workflows/claude-workflow-manager.yml@master
secrets:
  CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
```

Example workflow that triggers on `@claude` mentions:

```yaml
name: Claude Workflow Assistant

on: [issue_comment, pull_request_review_comment]

jobs:
  call-claude:
    if: contains(github.event.comment.body, '@claude')
    uses: SkogAI/.github/.github/workflows/claude-workflow-manager.yml@master
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
```

See [GitHub Actions documentation](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows) for event triggers and conditions.

## Required Secrets

Set at organization level:

- `CLAUDE_CODE_OAUTH_TOKEN` - Claude Code OAuth token

Run `./setup-claude-secrets.sh` to configure.

## Resources

- [Reusable Workflows Documentation](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Special .github Repository](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/customizing-your-organizations-profile)
