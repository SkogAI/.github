---
title: Project Research Plan
type: project
permalink: .skogai/plan/project
---

# Research Plan: skogai/.github

What I need to actually understand before making any recommendations about what this repo should do or contain.

## GitHub Actions: Distribution Mechanisms

- What exactly is `workflow_call` and what are its real constraints? (input/secret passing, permissions inheritance, nesting limits)
- What are `workflow-templates` actually for and how does GitHub surface them to org members?
- Can both coexist usefully, or do they serve the same need?
- What does a "caller" workflow look like in practice — how thin can it be?
- How do updates to a reusable workflow propagate to callers? Is it truly automatic or does the caller pin a ref?

## Org-Level `.github` Repo Behaviour

- Which files GitHub actually reads from an org `.github` repo vs which it ignores
- Exact paths for community health files, issue templates, PR templates — where does GitHub look?
- Does `workflow-templates/` require anything beyond the `.yml` + `.properties.json` pair?
- Are there any org-level workflow restrictions (required checks, rulesets) that interact with this repo?

## Secrets and Permissions

- How org-level secrets flow into called workflows vs direct workflows
- Whether `id-token: write` (OIDC) has any special behaviour at org level
- Permission scoping differences between `workflow_call` and a direct trigger

## Triggers and Composition

- Full list of events that can trigger workflows — specifically which ones fire on PR/issue activity without a push
- How `workflow_call` + `workflow_dispatch` can coexist in the same file
- Whether a workflow in `.github` org repo can trigger on events in *other* repos (it can't, but confirm)

## Practical Constraints

- Rate limits and concurrency limits relevant to running automation across many repos
- What happens when a reusable workflow is updated — do in-flight runs use old or new version?
- Any known issues with org-level workflow templates not appearing in the GitHub UI

## What I Don't Know Yet About This Project

- What the actual current state of workflow setup looks like across the skogai repos
- What "wiring up a repo" concretely means today (what files, what triggers, what the agent needs)
- Whether the goal is Claude-only, Copilot-only, both, or something else entirely
- What the `.skogai/` folder in each repo does and how workflows interact with it
