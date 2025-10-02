# Org-Level Reusable Workflows

This directory contains reusable GitHub Actions workflows that can be shared across all repositories in the organization.

## Claude Workflow Manager

A powerful AI assistant for managing issues, workflows, and keeping projects moving forward.

### Setup Instructions

#### Option 1: Using Reusable Workflow (Recommended)

**Prerequisites:**
1. This repository must be public OR you need to allow private repo workflows in org settings
2. `CLAUDE_CODE_OAUTH_TOKEN` must be set at the org level (Settings → Secrets → Actions)

**In each target repository:**

1. Create `.github/workflows/claude.yml`:

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
      GH_TOKEN: ${{ secrets.GH_TOKEN }}
```

2. The workflow path is already set to `SkogAI/.github`

3. Commit and push

**That's it!** Now you can use `@claude` in any issue or PR.

#### Option 2: Direct Copy (Simpler but less maintainable)

Copy the template from `templates/claude-caller.yml` to each repo's `.github/workflows/claude.yml` directory. Updates need to be applied to each repo individually.

### Usage Examples

#### Creating Issues

**In any issue or PR comment:**
```
@claude create an issue for implementing user authentication with OAuth2

Requirements:
- Support Google and GitHub providers
- Store tokens securely
- Add rate limiting
```

**Claude will:**
- Create a well-structured issue
- Add appropriate labels
- Set up acceptance criteria
- Link related issues if they exist
- Suggest next steps

#### Managing Workflow

```
@claude I need to break down #42 into smaller tasks
```

```
@claude what are the blockers for completing the auth feature?
```

```
@claude create a tracking issue for the Q1 roadmap with subtasks for each feature
```

#### General Assistance

```
@claude review this PR and create follow-up issues for any concerns
```

```
@claude what issues are related to database performance?
```

### Features

✅ **Smart Issue Creation**: Automatically formats issues with descriptions, acceptance criteria, and labels

✅ **Dependency Tracking**: Identifies blockers and related issues

✅ **Context-Aware**: Searches existing work before creating duplicates

✅ **Workflow Suggestions**: Recommends next steps and task breakdowns

✅ **Multi-Repo Support**: Same experience across all repos

### Customization Per Repo

You can customize behavior by modifying the reusable workflow or creating repo-specific overrides:

**Add repo-specific context:**
```yaml
jobs:
  call-claude:
    uses: SkogAI/.github/.github/workflows/claude-workflow-manager.yml@master
    with:
      custom_prompt: |
        Additional context for this repo:
        - This is a Python library focused on CLI tools
        - Use pytest for all tests
        - Follow PEP 8 style guide
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      GH_TOKEN: ${{ secrets.GH_TOKEN }}
```

### Troubleshooting

**Claude doesn't respond:**
- Verify `@claude` is in the comment/body
- Check that `CLAUDE_CODE_OAUTH_TOKEN` is set at org level
- Ensure the workflow file is committed to default branch

**Permission errors:**
- Verify the token has `repo` scope
- Check workflow permissions in repo settings

**Reusable workflow not found:**
- Ensure this repo is public or org allows private reusable workflows
- Verify the path: `ORG/REPO/.github/workflows/WORKFLOW.yml@BRANCH`

### Best Practices

1. **Be Specific**: Give Claude clear instructions about what you need
2. **Provide Context**: Mention related issues, requirements, or constraints
3. **Use Checklists**: Claude creates better issues when you provide structured requirements
4. **Review Output**: Always review generated issues before they're created
5. **Iterate**: You can ask Claude to modify or refine the issues it creates

### Security Notes

- Token has read/write access to issues and PRs only
- No code changes are made without explicit PR creation
- All actions are audited in GitHub Actions logs
- Token is stored as encrypted secret at org level
