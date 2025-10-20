# Claude Code Action Reference

Complete technical documentation for the `anthropics/claude-code-action@v1` GitHub Action.

## Overview

**Action Name:** Claude Code Action v1.0
**Source:** https://github.com/anthropics/claude-code-action
**Marketplace:** https://github.com/marketplace/actions/claude-code-action-official
**License:** MIT

The Claude Code Action is an AI-powered GitHub Action that automates code development workflows. It can respond to comments, create PRs, implement features, fix bugs, review code, and perform repository maintenance tasks.

---

## How It Works

1. **Trigger Detection** - Monitors GitHub events for activation conditions
2. **Context Collection** - Gathers event data (comment text, PR/issue details, repository info)
3. **Environment Setup** - Installs Claude Code CLI on the GitHub runner
4. **Execution** - Runs Claude Code with the provided context and configuration
5. **Response** - Posts results as comments, creates PRs, or performs requested actions

The action automatically detects its mode based on:
- Event type (comment, assignment, label)
- Trigger phrase presence (default: `@claude`)
- Explicit prompts in workflow configuration

---

## Action Inputs

All inputs for the `anthropics/claude-code-action@v1` action:

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `trigger_phrase` | string | No | `"@claude"` | Phrase to look for in comments or issue body |
| `assignee_trigger` | string | No | - | Username that triggers action when assigned |
| `label_trigger` | string | No | `"claude"` | Label that triggers the action |
| `base_branch` | string | No | - | Branch to use as base when creating new branches |
| `anthropic_api_key` | string | No* | - | Anthropic API key (required for direct API) |
| `claude_code_oauth_token` | string | No* | - | OAuth token for Claude Pro/Max users |
| `github_token` | string | Yes | - | GitHub token with repo and PR permissions |
| `use_bedrock` | boolean | No | `false` | Use Amazon Bedrock with OIDC authentication |
| `use_vertex` | boolean | No | `false` | Use Google Vertex AI with OIDC authentication |
| `prompt` | string | No | - | Instructions for Claude (for automation mode) |
| `claude_args` | string | No | - | Additional CLI arguments for Claude Code |

*One authentication method required: `anthropic_api_key`, `claude_code_oauth_token`, `use_bedrock`, or `use_vertex`

---

## Action Outputs

| Output | Description |
|--------|-------------|
| `execution_file` | Path to the Claude Code execution output file |
| `branch_name` | Name of the branch created by Claude Code |
| `github_token` | GitHub token used by the action |

---

## Supported Triggers

The action can be triggered by various GitHub events:

### 1. Comment-based Triggers
- **Issue comments** (`issue_comment`)
- **PR review comments** (`pull_request_review_comment`)
- **PR reviews** (`pull_request_review`)

Activates when `trigger_phrase` (default `@claude`) appears in the comment/review body.

### 2. Assignment Triggers
- **Issue assignment** (`issues.assigned`)

Activates when `assignee_trigger` username is assigned to an issue.

### 3. Label Triggers
- **Issue/PR labeled** (`issues.labeled`, `pull_request.labeled`)

Activates when `label_trigger` label is added.

### 4. Automation Triggers
- **Scheduled workflows** (`schedule`)
- **Manual dispatch** (`workflow_dispatch`)
- **Custom events** (any GitHub event)

Activates when `prompt` input is provided explicitly.

---

## Authentication Methods

### Option 1: Direct Anthropic API (Recommended)
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

**Setup:**
1. Get API key from https://console.anthropic.com/
2. Add as repository secret: `ANTHROPIC_API_KEY`
3. Key format: `sk-ant-api03-...`

### Option 2: OAuth Token (Pro/Max Users)
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

**Setup:**
1. Run `claude setup-token` locally
2. Copy the generated token
3. Add as repository secret: `CLAUDE_CODE_OAUTH_TOKEN`

### Option 3: AWS Bedrock
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_bedrock: true
    github_token: ${{ secrets.GITHUB_TOKEN }}
  permissions:
    id-token: write  # Required for OIDC
```

**Setup:**
- Configure AWS OIDC provider
- Grant GitHub Actions access to Bedrock

### Option 4: Google Vertex AI
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_vertex: true
    github_token: ${{ secrets.GITHUB_TOKEN }}
  permissions:
    id-token: write  # Required for OIDC
```

**Setup:**
- Configure GCP OIDC provider
- Grant GitHub Actions access to Vertex AI

---

## Required Permissions

The action requires these GitHub permissions:

```yaml
permissions:
  contents: write        # Read/write repository files
  issues: write          # Create/update issues and comments
  pull-requests: write   # Create/update PRs and comments
  id-token: write        # Required for cloud provider OIDC auth
```

### Permission Details

| Permission | Access | Purpose |
|------------|--------|---------|
| `contents` | write | Clone repo, read code, create branches, commit changes |
| `issues` | write | Comment on issues, create new issues, add labels |
| `pull-requests` | write | Create PRs, comment on PRs, request reviews |
| `id-token` | write | Authenticate with AWS Bedrock or Google Vertex AI |

---

## Claude Code Capabilities

### Built-in Tools

When running in GitHub Actions, Claude Code has access to:

**File Operations:**
- `Read` - Read files from repository
- `Write` - Create new files
- `Edit` - Modify existing files
- `Glob` - Search for files by pattern
- `Grep` - Search file contents

**Git Operations:**
- `Bash(git:*)` - All git commands (commit, branch, push, etc.)

**GitHub CLI Operations:**
- `Bash(gh issue:*)` - Issue management
- `Bash(gh pr:*)` - PR management
- `Bash(gh search:*)` - Search issues/PRs/code
- `Bash(gh label:*)` - Label management
- `Bash(gh milestone:*)` - Milestone management

**Code Operations:**
- `Bash(npm:*)` - Node.js package management
- `Bash(python:*)` - Python execution
- `Bash(uv:*)` - Python package management
- Other language-specific tools as configured

### MCP Tools (Model Context Protocol)

GitHub-specific tools available via MCP:
- `mcp__github_inline_comment__create_inline_comment` - Create inline PR comments
- Additional MCP tools as configured

### Tool Restrictions

You can restrict available tools using `claude_args`:

```yaml
claude_args: '--allowed-tools "Bash(gh issue:*),Bash(gh pr:*),Read,Write"'
```

This limits Claude to only the specified tools for security.

---

## Common Use Cases

### 1. Automated Code Review
```yaml
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
          prompt: |
            Review this PR for:
            - Code quality and best practices
            - Potential bugs
            - Security vulnerabilities
            - Performance issues
```

### 2. Interactive Assistant
```yaml
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

jobs:
  assistant:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    permissions:
      contents: write
      issues: write
      pull-requests: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### 3. Scheduled Maintenance
```yaml
on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday

jobs:
  maintenance:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
          prompt: |
            Check for and update:
            - Outdated dependencies
            - Broken documentation links
            - TODO comments that can be addressed
```

### 4. Security Scanning
```yaml
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  security:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
          prompt: |
            Analyze this PR for security vulnerabilities:
            - Check against OWASP Top 10
            - Identify injection vulnerabilities
            - Check for exposed secrets
            - Review authentication/authorization

            Rate severity: Critical, High, Medium, Low, None
```

---

## Configuration via CLAUDE.md

Create a `CLAUDE.md` file in your repository root to provide context:

```markdown
# Project: MyApp

## Tech Stack
- Node.js 20
- React 18
- PostgreSQL 15
- Docker

## Code Style
- Use TypeScript strict mode
- Follow Airbnb style guide
- Prefer functional components
- Use async/await over promises

## Testing
- Write tests with Jest
- Minimum 80% coverage
- E2E tests with Playwright

## CI/CD
- All PRs must pass tests
- Require 2 approvals
- Deploy to staging first
```

Claude Code automatically reads and follows this configuration.

---

## Progress Tracking

Claude Code supports dynamic progress tracking with checkboxes:

**Input:**
```yaml
prompt: |
  Refactor the authentication system:
  - [ ] Update login endpoint
  - [ ] Add JWT validation
  - [ ] Implement refresh tokens
  - [ ] Write tests
```

**Claude will:**
- Check off completed tasks: `- [x] Update login endpoint`
- Update progress in comments
- Show what's done and what's remaining

---

## Execution Environment

| Property | Value |
|----------|-------|
| **Runner OS** | ubuntu-latest (Ubuntu 22.04) |
| **Node.js** | Installed by action (latest LTS) |
| **Claude Code** | Installed via npm |
| **Working Directory** | Repository root |
| **Timeout** | Default GitHub Actions timeout (360 min) |

---

## Advanced Configuration

### Custom Branch Naming
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    base_branch: develop
    # Claude creates branches from 'develop' instead of 'main'
```

### Multiple Triggers
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    trigger_phrase: "@claude"
    assignee_trigger: "claude-bot"
    label_trigger: "ai-assist"
    # Activates on @claude mention, claude-bot assignment, OR ai-assist label
```

### Tool Restrictions
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    claude_args: |
      --allowed-tools "Bash(gh issue:*),Bash(gh pr:*),Read,Grep"
      --max-tokens 4000
```

---

## Security Best Practices

1. **Never commit API keys**
   - Always use GitHub Secrets
   - Never hardcode in workflow files

2. **Limit permissions**
   - Grant minimum required permissions
   - Use `contents: read` when possible

3. **Restrict tools**
   - Use `--allowed-tools` to limit capabilities
   - Block destructive operations if not needed

4. **Review AI changes**
   - Always review AI-generated code
   - Use PRs for code changes (don't auto-merge)

5. **Rotate keys regularly**
   - Update API keys periodically
   - Revoke compromised keys immediately

6. **Use branch protection**
   - Require reviews for main branch
   - Prevent direct pushes to main

---

## Troubleshooting

### Action doesn't trigger
- ✓ Check trigger phrase spelling
- ✓ Verify workflow permissions
- ✓ Ensure workflow is on default branch
- ✓ Check if condition in `if:` statement

### Authentication errors
- ✓ Verify API key is valid and not expired
- ✓ Check secret name matches workflow reference
- ✓ Ensure one auth method is configured

### Permission denied
- ✓ Grant required permissions in workflow
- ✓ Check GitHub token has repo access
- ✓ Verify branch protection rules

### Claude not responding
- ✓ Check GitHub Actions logs
- ✓ Verify API quota/limits
- ✓ Ensure prompt is clear and specific

---

## Resources

- **Official Docs:** https://docs.claude.com/en/docs/claude-code/github-actions
- **GitHub Repo:** https://github.com/anthropics/claude-code-action
- **Setup Guide:** https://github.com/anthropics/claude-code-action/blob/main/docs/setup.md
- **Solutions Guide:** https://github.com/anthropics/claude-code-action/blob/main/docs/solutions.md
- **Migration Guide:** https://github.com/anthropics/claude-code-action/blob/main/docs/migration-guide.md
- **Quick Install:** Run `/install-github-app` in Claude Code CLI

---

## Comparison with Your Setup

### What You Created (Wrapper Workflows)
- `templates/claude-caller.yml` - Trigger configuration for each repo
- `.github/workflows/claude-workflow-manager.yml` - Reusable wrapper

### What Anthropic Provides (The Action)
- `anthropics/claude-code-action@v1` - The actual AI execution engine
- Claude Code CLI - The tool that does the work
- Authentication and GitHub integration

**Your workflows call the Anthropic action → which runs Claude Code → which performs the tasks**
