# Security Policy

## Reporting a Vulnerability

**Do not open a public issue for security vulnerabilities.**

Report security issues privately by emailing the maintainers or using [GitHub's private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing/privately-reporting-a-security-vulnerability) on the affected repository.

Include:
- A description of the vulnerability and its potential impact
- Steps to reproduce
- Any relevant file paths, line numbers, or workflow names

We will acknowledge receipt within 48 hours and aim to resolve confirmed vulnerabilities within 30 days.

## Scope

This policy covers all repositories in the skogai organization, with particular attention to:

- GitHub Actions workflows and reusable workflows
- Scripts that handle secrets or credentials (`scripts/`)
- Anything that interacts with organization-level secrets (`CLAUDE_CODE_OAUTH_TOKEN`)

## Workflow Security Notes

All Claude Code workflows in this org:
- Use `CLAUDE_CODE_OAUTH_TOKEN` as an organization-level secret (never hardcoded)
- Scope permissions to the minimum required for each workflow
- Pin `actions/checkout` to a specific major version tag
