---
title: Vision
type: vision
permalink: .skogai/plan/vision
---

# Project Vision: skogai/.github

## Problem Statement

One person manages 400 git repositories with 6 full-time AI agents. Wiring each repo with the correct Claude Code and Copilot automation currently happens manually — JSON files passed via SSH, git-hooks that are literally workflow definitions, per-repo scripting. This doesn't scale and creates drift. The `.github` org repo is the mechanism GitHub provides to fix this, but only if it's designed for agent-first automation, not human-run one-time setup.

## Users and Core Use Cases

### Primary Users

- **AI agents** (Claude, Copilot) — call shared workflows, consume canonical patterns, act on any git event
- **skogix** (one human, the orchestrator) — adds new repos, reviews agent output, updates canonical workflows

### Core Use Cases

1. New repo bootstraps with full AI agent automation — zero manual workflow setup
2. Canonical workflow update propagates to all calling repos automatically
3. Agent in any repo can invoke shared automation (`@claude`, PR review, manual dispatch) without per-repo configuration
4. Human can inspect and update the canonical patterns in one place

## Success Criteria

### Definition of Done

Every skogai repo can have Claude Code and Copilot wired up by calling this repo's reusable workflows — no copying, no per-repo scripting, no SSH JSON passing.

### Quality Bar

Production automation infrastructure. These workflows run on every push/PR/comment across 400 repos. They must be reliable, minimal, and updatable without touching individual repos.

### Signals

- New repo → working `@claude` mention in under 2 minutes, no manual steps
- Updating canonical workflow → all calling repos get the change on next run, no per-repo PRs
- Zero "workflow drift" across repos (all call the same version)

## Design Principles

1. **Agent-first, not human-convenience-first**: Design for agents calling workflows programmatically. Human ergonomics (nice scripts, CLIs) are secondary and often wrong scope for this repo.
2. **Canonical over copied**: Reusable `workflow_call` workflows trump copy-paste templates. When the canonical pattern changes, callers get it automatically.
3. **Minimal surface area**: Every file in this repo is infrastructure for 400 repos. Complexity here multiplies. Default to removing things.
4. **Git events as the API**: The automation surface is GitHub events (push, PR, comment, dispatch). If it can't be triggered by a git event, it probably doesn't belong here.

## Tradeoffs and Defaults

- When choosing between reusable `workflow_call` and copy-paste `workflow-templates`, prefer `workflow_call` — callers stay current automatically.
- When choosing between a script and a workflow, prefer the workflow — scripts require a human to run them.
- Accept slightly more complex caller setup in order to preserve canonical control.
- Optimize for update propagation speed over installation simplicity.

## Anti-goals

- Not a place for one-time human-run scripts (bulk-install, secret setup CLI tools)
- Not per-repo customization — that lives in each repo's `.github/workflows/`
- Not documentation-as-infrastructure — README explains, it doesn't do
- Not a general-purpose automation platform — scope is Claude Code + Copilot wiring for skogai repos

## Constraints

- GitHub Actions as the runtime — no external CI, no self-hosted orchestration here
- `CLAUDE_CODE_OAUTH_TOKEN` must be an org-level secret (already is)
- 400 existing repos with inconsistent current state — changes must be non-breaking for callers
- 6 agents need consistent, stable workflow interfaces — avoid renaming or restructuring frequently

## Decision Framework

- If a file enables agent automation on git events → it belongs here
- If a file requires a human to run it → it probably doesn't
- If removing a file reduces surface area without breaking callers → remove it
- When two approaches are equal, prefer the one that propagates updates automatically
- Escalate only when a change would break existing callers or change the external workflow interface

## Open Questions

- Should `workflow-templates/` (copy-paste starters) be kept alongside `workflows/` (reusable), or replaced entirely by reusable workflows? Today's session removed `workflows/` — this may need revisiting given the "canonical over copied" principle.
- Copilot workflow manager pattern (exists in SkogBackup/.github) — does that migrate here?
- What is the canonical caller pattern for a new repo? (thin `.github/workflows/claude.yml` that calls this repo's reusable workflow?)
