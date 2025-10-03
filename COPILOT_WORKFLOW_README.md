# Org-Level Reusable Workflows

This directory contains reusable GitHub Actions workflows that can be shared across all repositories in the organization.

## Copilot Workflow Manager

A powerful AI assistant for managing issues, workflows, and keeping projects moving forward.

### Setup Instructions

#### Option 1: Using Reusable Workflow (Recommended)

**Prerequisites:**
1. This repository must be public OR you need to allow private repo workflows in org settings
2. GitHub Copilot must be enabled for your organization

**In each target repository:**

1. Create `.github/workflows/copilot.yml`:

```yaml
name: Copilot Workflow Assistant

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
  call-copilot:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@copilot')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@copilot')) ||
      (github.event_name == 'pull_request_review' && contains(github.event.review.body, '@copilot')) ||
      (github.event_name == 'issues' && (contains(github.event.issue.body, '@copilot') || contains(github.event.issue.title, '@copilot')))

    uses: SkogAI/.github/.github/workflows/copilot-workflow-manager.yml@master
    secrets:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

2. The workflow path is already set to `SkogAI/.github`

3. Commit and push

**That's it!** Now you can use `@copilot` in any issue or PR.

#### Option 2: Direct Copy (Simpler but less maintainable)

Copy the template from `templates/copilot-caller.yml` to each repo's `.github/workflows/copilot.yml` directory. Updates need to be applied to each repo individually.

### Usage Examples

#### Creating Issues

**In any issue or PR comment:**
```
@copilot create an issue for implementing user authentication with OAuth2

Requirements:
- Support Google and GitHub providers
- Store tokens securely
- Add rate limiting
```

**Copilot will:**
- Create a well-structured issue
- Add appropriate labels
- Set up acceptance criteria
- Link related issues if they exist
- Suggest next steps

#### Managing Workflow

```
@copilot I need to break down #42 into smaller tasks
```

```
@copilot what are the blockers for completing the auth feature?
```

```
@copilot create a tracking issue for the Q1 roadmap with subtasks for each feature
```

#### General Assistance

```
@copilot review this PR and create follow-up issues for any concerns
```

```
@copilot what issues are related to database performance?
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
  call-copilot:
    uses: SkogAI/.github/.github/workflows/copilot-workflow-manager.yml@master
    with:
      custom_prompt: |
        Additional context for this repo:
        - This is a Python library focused on CLI tools
        - Use pytest for all tests
        - Follow PEP 8 style guide
    secrets:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Troubleshooting

**Copilot doesn't respond:**
- Verify `@copilot` is in the comment/body
- Check that GitHub Copilot is enabled for your organization
- Ensure the workflow file is committed to default branch

**Permission errors:**
- Verify the token has appropriate permissions
- Check workflow permissions in repo settings

**Reusable workflow not found:**
- Ensure this repo is public or org allows private reusable workflows
- Verify the path: `ORG/REPO/.github/workflows/WORKFLOW.yml@BRANCH`

### Best Practices

1. **Be Specific**: Give Copilot clear instructions about what you need
2. **Provide Context**: Mention related issues, requirements, or constraints
3. **Use Checklists**: Copilot creates better issues when you provide structured requirements
4. **Review Output**: Always review generated issues before they're created
5. **Iterate**: You can ask Copilot to modify or refine the issues it creates

### Security Notes

- Token has read/write access to issues and PRs only
- No code changes are made without explicit PR creation
- All actions are audited in GitHub Actions logs
- Token is stored as encrypted secret at org level
