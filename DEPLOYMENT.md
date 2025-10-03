# Deployment Guide: Org-Level Claude Workflow

## Quick Start (5 minutes)

### Step 1: Set up the `.github` repository

This is a special repo that GitHub recognizes for org-level configurations.

**Set up this directory as the SkogAI/.github repo:**

```bash
# This directory is already structured correctly!
# Just initialize it as a git repo and push to GitHub

# Initialize git (if not already)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Org-level workflows"

# Create the .github repo in your org and push
gh repo create SkogAI/.github --public --description "SkogAI org-level GitHub configurations"
git remote add origin https://github.com/SkogAI/.github.git
git branch -M master
git push -u origin master
```

### Step 2: Configure org-level secret

1. Go to `https://github.com/organizations/SkogAI/settings/secrets/actions`
2. Click **New organization secret**
3. Name: `CLAUDE_CODE_OAUTH_TOKEN`
4. Value: Your Claude Code OAuth token
5. Repository access: **All repositories** (or select specific ones)

### Step 3: Deploy to individual repos

In each repo where you want Claude assistance:

```bash
# In your target repo
mkdir -p .github/workflows

# Create the caller workflow
cat > .github/workflows/claude.yml << 'EOF'
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
EOF

# The workflow already references SkogAI/.github - no changes needed!

# Commit
git add .github/workflows/claude.yml
git commit -m "Add Claude workflow assistant"
git push
```

### Step 4: Test it

1. Go to any repo with the workflow
2. Create a test issue
3. Comment: `@claude create a test issue for validating the workflow setup`
4. Watch the magic happen! ✨

## Alternative: Automated Deployment Script

Save this as `deploy-claude-to-repos.sh`:

```bash
#!/bin/bash

ORG="SkogAI"
REPOS=("repo1" "repo2" "repo3")  # List your repos

for repo in "${REPOS[@]}"; do
  echo "Deploying to $ORG/$repo..."

  # Clone repo
  gh repo clone "$ORG/$repo" "/tmp/$repo" || continue
  cd "/tmp/$repo"

  # Create workflow
  mkdir -p .github/workflows
  cat > .github/workflows/claude.yml << EOF
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

    uses: $ORG/.github/.github/workflows/claude-workflow-manager.yml@master
    secrets:
      CLAUDE_CODE_OAUTH_TOKEN: \${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      GH_TOKEN: \${{ secrets.GH_TOKEN }}
EOF

  # Commit and push
  git add .github/workflows/claude.yml
  git commit -m "Add Claude workflow assistant"
  git push

  cd -
  rm -rf "/tmp/$repo"

  echo "✅ Deployed to $ORG/$repo"
done

echo "🎉 Deployment complete!"
```

Run it:
```bash
chmod +x deploy-claude-to-repos.sh
./deploy-claude-to-repos.sh
```

## Copilot Workflow Deployment

### Quick Setup (3 minutes)

In each repo where you want Copilot assistance:

```bash
# In your target repo
mkdir -p .github/workflows

# Create the caller workflow
cat > .github/workflows/copilot.yml << 'EOF'
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
EOF

# Commit
git add .github/workflows/copilot.yml
git commit -m "Add Copilot workflow assistant"
git push
```

### Test it

1. Go to any repo with the workflow
2. Create a test issue
3. Comment: `@copilot create a test issue for validating the workflow setup`
4. Watch the magic happen! ✨

### Automated Deployment Script for Copilot

Save this as `deploy-copilot-to-repos.sh`:

```bash
#!/bin/bash

ORG="SkogAI"
REPOS=("repo1" "repo2" "repo3")  # List your repos

for repo in "${REPOS[@]}"; do
  echo "Deploying to $ORG/$repo..."

  # Clone repo
  gh repo clone "$ORG/$repo" "/tmp/$repo" || continue
  cd "/tmp/$repo"

  # Create workflow
  mkdir -p .github/workflows
  cat > .github/workflows/copilot.yml << EOF
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

    uses: $ORG/.github/.github/workflows/copilot-workflow-manager.yml@master
    secrets:
      GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
EOF

  # Commit and push
  git add .github/workflows/copilot.yml
  git commit -m "Add Copilot workflow assistant"
  git push

  cd -
  rm -rf "/tmp/$repo"

  echo "✅ Deployed to $ORG/$repo"
done

echo "🎉 Deployment complete!"
```

Run it:
```bash
chmod +x deploy-copilot-to-repos.sh
./deploy-copilot-to-repos.sh
```

## Verification Checklist

### Claude Workflow
- [ ] `.github` repo exists in your org
- [ ] `claude-workflow-manager.yml` is in `.github/.github/workflows/`
- [ ] `CLAUDE_CODE_OAUTH_TOKEN` is set at org level
- [ ] Target repos have `claude.yml` caller workflow
- [ ] Test issue comment with `@claude` works

### Copilot Workflow
- [ ] `.github` repo exists in your org
- [ ] `copilot-workflow-manager.yml` is in `.github/.github/workflows/`
- [ ] GitHub Copilot is enabled for your organization
- [ ] Target repos have `copilot.yml` caller workflow
- [ ] Test issue comment with `@copilot` works

## Maintenance

**To update the workflow across all repos:**

1. Modify `claude-workflow-manager.yml` in the `.github` repo
2. Commit and push
3. All repos automatically use the new version (no changes needed in individual repos!)

This is the power of reusable workflows! 🚀

## Troubleshooting

### Claude Workflow

**Error: workflow was not found**
- Check the path format: `ORG/.github/.github/workflows/FILE.yml@BRANCH`
- Ensure the `.github` repo is public or org allows private reusables

**Error: secret not found**
- Verify secret name exactly matches: `CLAUDE_CODE_OAUTH_TOKEN`
- Check org-level secret has correct repository access

**Claude doesn't respond**
- Ensure `@claude` appears in the comment body
- Check Actions tab for workflow run logs
- Verify workflow file is on the default branch

### Copilot Workflow

**Error: workflow was not found**
- Check the path format: `ORG/.github/.github/workflows/FILE.yml@BRANCH`
- Ensure the `.github` repo is public or org allows private reusables

**Copilot doesn't respond**
- Ensure `@copilot` appears in the comment body
- Check Actions tab for workflow run logs
- Verify workflow file is on the default branch
- Ensure GitHub Copilot is enabled for your organization
