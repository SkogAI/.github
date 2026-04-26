# Contributing to SkogAI

Thanks for your interest in contributing. Here's how to get started.

## Getting Help

Mention `@claude` in any issue or PR comment — Claude will read the context and assist. This works across all SkogAI repositories.

## Reporting Bugs

Open an issue using the **Bug Report** template. Include:
- What you expected to happen
- What actually happened
- Steps to reproduce
- Environment details (OS, tool versions)

## Suggesting Features

Open an issue using the **Feature Request** template. Describe the problem you're solving, not just the solution.

## Submitting Pull Requests

1. Fork the repository and create a branch from `main`
2. Make your changes — keep commits focused and atomic
3. Ensure existing workflows/scripts still work
4. Open a PR using the PR template and describe what changed and why

## Workflow Templates and Reusable Workflows

Changes to `workflow-templates/` or `workflows/` affect all SkogAI repositories that use them. Test carefully and document breaking changes clearly.

## Code Style

- Shell scripts: follow existing conventions, use `set -e`, quote variables
- YAML: 2-space indent, explicit types for workflow inputs
- Markdown: ATX headings, fenced code blocks with language tags

## Questions

Open a discussion or issue — or just mention `@claude` and ask.
