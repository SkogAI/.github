# SkogAI Organization Configurations

This is the special `.github` repository for the SkogAI organization. It contains:

## 🤖 Reusable Workflows

Org-level GitHub Actions workflows that can be used across all repositories.

### Claude Workflow Manager

An AI-powered workflow assistant that helps with:
- **Issue creation and management** - Create well-structured issues with acceptance criteria
- **Workflow orchestration** - Track dependencies, blockers, and project flow
- **Sprint planning** - Break down large tasks, manage sprints
- **Bug triage** - Systematically handle bug reports

**📚 Documentation:**
- [Usage Guide](CLAUDE_WORKFLOW_README.md) - How to use the Claude workflow
- [Deployment Guide](DEPLOYMENT.md) - How to set this up
- [Examples](EXAMPLES.md) - Real-world usage examples

**🚀 Quick Start:**

Add this to any repo's `.github/workflows/claude.yml`:

```yaml
name: Claude Workflow Assistant

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, assigned]
  pull_request_review:
    types: [submitted]

jobs:
  call-claude:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review' && contains(github.event.review.body, '@claude')) ||
      (github.event_name == 'issues' && (contains(github.event.issue.body, '@claude') || contains(github.event.issue.title, '@claude')))

    uses: SkogAI/.github/.github/workflows/claude-workflow-manager.yml@master
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Then just mention `@claude` in any issue or PR!

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── claude-workflow-manager.yml    # Reusable workflow for Claude
├── workflows/                             # Example workflows (reference)
│   ├── claude-code.yml
│   ├── doc-updater.yml
│   ├── lore-growth.yml
│   └── ...
├── skoglib-workflows/                     # Python package workflows
│   ├── ci.yml
│   ├── security.yml
│   ├── release.yml
│   └── ...
├── org-workflows/                         # Additional org templates
│   └── claude-caller.yml                  # Template for repos
├── CLAUDE_WORKFLOW_README.md              # Claude workflow documentation
├── DEPLOYMENT.md                          # Setup instructions
├── EXAMPLES.md                            # Usage examples
└── README.md                              # This file
```

## 🔐 Required Secrets

Set these at the organization level:
- `CLAUDE_CODE_OAUTH_TOKEN` - For Claude Code integration

## 📖 Resources

- [GitHub Reusable Workflows Documentation](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Special .github Repository](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/customizing-your-organizations-profile)

## 🤝 Contributing

To update org-level workflows:
1. Make changes to workflows in `.github/workflows/`
2. Test in a sandbox repo
3. Create a PR to this repo
4. Once merged, all repos using the workflow automatically get the update!

---

*Automating everything so we can drink mojitos on the beach* 🏖️
