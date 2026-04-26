# Support

## Getting Help

**In any SkogAI repository:** mention `@claude` in an issue or PR comment. Claude will read the context and respond directly.

**For workflow setup issues:** see [INSTALL.md](INSTALL.md) in this repository.

**For bugs or unexpected behavior:** open an issue in the relevant repository using the Bug Report template.

**For questions about Claude Code itself:** see the [official documentation](https://docs.claude.ai/en/docs/claude-code) and the [claude-code-action repo](https://github.com/anthropics/claude-code-action).

## Claude Code Troubleshooting

| Symptom | Check |
|---|---|
| `@claude` not responding | Workflow exists in repo? `CLAUDE_CODE_OAUTH_TOKEN` set at org level? |
| Permission errors in workflow | Workflow has `contents: write`, `pull-requests: write`, `issues: write`, `id-token: write`? |
| Workflow not visible in Actions UI | Template may take a few minutes to propagate — use manual install instead |

See [INSTALL.md § Troubleshooting](INSTALL.md#troubleshooting) for more.
