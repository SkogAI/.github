#!/bin/bash

# Setup Claude Code OAuth token for GitHub workflows
set -e

echo "🤖 Claude Code GitHub Setup"
echo "============================"
echo ""
echo "This script will configure CLAUDE_CODE_OAUTH_TOKEN as an organization secret"
echo "for all the automation workflows."
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo ""
    echo "Install it with:"
    echo "  brew install gh                    # macOS"
    echo "  sudo apt install gh                # Ubuntu/Debian"
    echo "  sudo dnf install gh                # Fedora"
    echo ""
    echo "Or visit: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI."
    echo ""
    echo "Run: gh auth login"
    exit 1
fi

# Get current repo
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
if [ -z "$REPO" ]; then
    echo "❌ Not in a GitHub repository."
    echo "Make sure you're in the repository directory."
    exit 1
fi

echo "Repository: $REPO"
echo ""

# Extract org name from repo
ORG=$(echo "$REPO" | cut -d'/' -f1)

# Check if user has admin rights to manage org secrets
echo "Checking permissions..."
if ! gh secret list --org "$ORG" &> /dev/null; then
    echo "❌ You don't have admin rights to manage organization secrets."
    echo ""
    echo "Run this to request admin permissions:"
    echo "  gh auth refresh -h github.com -s admin:org"
    echo ""
    echo "Or ask an admin to set up CLAUDE_CODE_OAUTH_TOKEN at:"
    echo "https://github.com/organizations/$ORG/settings/secrets/actions"
    echo ""
    exit 1
fi

echo "✅ Admin access confirmed"
echo ""

# Check for existing secrets
EXISTING_SECRETS=$(gh secret list --org "$ORG" --json name -q '.[].name' 2>/dev/null || echo "")

if echo "$EXISTING_SECRETS" | grep -q "CLAUDE_CODE_OAUTH_TOKEN"; then
    echo "⚠️  CLAUDE_CODE_OAUTH_TOKEN already exists"
    read -p "Do you want to update it? (y/n): " UPDATE_TOKEN
    if [[ ! "$UPDATE_TOKEN" =~ ^[Yy]$ ]]; then
        echo "Keeping existing token."
        exit 0
    fi
fi

echo ""
read -s -p "Enter CLAUDE_CODE_OAUTH_TOKEN: " CLAUDE_KEY
echo ""

echo ""
echo "Setting GitHub secret..."

# Set CLAUDE_CODE_OAUTH_TOKEN
echo -n "Setting CLAUDE_CODE_OAUTH_TOKEN... "
echo "$CLAUDE_KEY" | gh secret set CLAUDE_CODE_OAUTH_TOKEN --org "$ORG"
echo "✅"

echo ""
echo "✅ Secret configured successfully!"
echo ""
echo "Verifying setup..."
gh secret list --org "$ORG" | grep CLAUDE || true

echo ""
echo "🚀 Ready to use Claude workflows!"
echo ""
echo "Trigger workflows by commenting on issues or PRs:"
echo "  @claude <your request>"
echo ""
echo "Or manually run workflows:"
echo "  gh workflow list"
echo "  gh workflow run <workflow-name>.yml"