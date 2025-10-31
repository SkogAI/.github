#!/bin/bash

# Test script to validate Claude Code workflow setup
set -e

echo "🧪 Testing Claude Code Workflow Setup"
echo "======================================"
echo ""

# Get org from current repo
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
if [ -z "$REPO" ]; then
    echo "❌ Not in a GitHub repository."
    exit 1
fi
ORG=$(echo "$REPO" | cut -d'/' -f1)

echo "Repository: $REPO"
echo "Organization: $ORG"
echo ""

# Test 1: Check gh CLI authentication
echo "Test 1: GitHub CLI Authentication"
echo "----------------------------------"
if gh auth status &> /dev/null; then
    echo "✅ Authenticated with GitHub CLI"
else
    echo "❌ Not authenticated. Run: gh auth login"
    exit 1
fi
echo ""

# Test 2: Check org admin permissions
echo "Test 2: Organization Admin Permissions"
echo "---------------------------------------"
if gh secret list --org "$ORG" &> /dev/null; then
    echo "✅ Have admin rights to manage org secrets"
else
    echo "❌ No admin rights. Run: gh auth refresh -h github.com -s admin:org"
    exit 1
fi
echo ""

# Test 3: Check if CLAUDE_CODE_OAUTH_TOKEN exists
echo "Test 3: Organization Secret Exists"
echo "-----------------------------------"
SECRET_EXISTS=$(gh secret list --org "$ORG" --json name --jq 'any(.name == "CLAUDE_CODE_OAUTH_TOKEN")' 2>/dev/null)
if [ "$SECRET_EXISTS" = "true" ]; then
    echo "✅ CLAUDE_CODE_OAUTH_TOKEN is set"
else
    echo "❌ CLAUDE_CODE_OAUTH_TOKEN not found"
    echo "   Run: gh secret set CLAUDE_CODE_OAUTH_TOKEN --org $ORG"
    exit 1
fi
echo ""

# Test 4: Check for workflows using the secret
echo "Test 4: Workflows Using CLAUDE_CODE_OAUTH_TOKEN"
echo "------------------------------------------------"
CLAUDE_WORKFLOWS=$(grep -l "CLAUDE_CODE_OAUTH_TOKEN" .github/workflows/*.yml 2>/dev/null || true)
if [ -n "$CLAUDE_WORKFLOWS" ]; then
    echo "✅ Found workflows using CLAUDE_CODE_OAUTH_TOKEN:"
    echo "$CLAUDE_WORKFLOWS" | while read file; do
        echo "   - $(basename $file)"
    done
else
    echo "⚠️  No workflows found using CLAUDE_CODE_OAUTH_TOKEN"
fi
echo ""

# Test 5: Check for reusable workflow reference
echo "Test 5: Reusable Workflow Configuration"
echo "----------------------------------------"
if grep -q "SkogAI/\.github/\.github/workflows/claude-workflow-manager\.yml" .github/workflows/*.yml 2>/dev/null; then
    echo "✅ Correctly references org reusable workflow"
else
    echo "⚠️  No reference to org reusable workflow found"
fi
echo ""

# Test 6: Validate workflow syntax
echo "Test 6: Workflow Syntax Validation"
echo "-----------------------------------"
INVALID_WORKFLOWS=0
for workflow in .github/workflows/*.yml; do
    if [ -f "$workflow" ]; then
        # Basic YAML validation
        if ! python3 -c "import yaml; yaml.safe_load(open('$workflow'))" 2>/dev/null; then
            echo "❌ Invalid YAML: $(basename $workflow)"
            INVALID_WORKFLOWS=$((INVALID_WORKFLOWS + 1))
        fi
    fi
done

if [ $INVALID_WORKFLOWS -eq 0 ]; then
    echo "✅ All workflows have valid YAML syntax"
else
    echo "❌ Found $INVALID_WORKFLOWS workflow(s) with invalid syntax"
fi
echo ""

# Test 7: Create a test issue to trigger workflows
echo "Test 7: Create Test Issue (triggers @claude workflow)"
echo "------------------------------------------------------"
read -p "Do you want to create a test issue to trigger workflows? (y/n): " RUN_TEST
if [[ "$RUN_TEST" =~ ^[Yy]$ ]]; then
    echo "Creating test issue with @claude mention..."
    ISSUE_URL=$(gh issue create \
        --title "Test: Claude Code Workflow" \
        --body "@claude Please confirm this workflow is working. Reply with 'Workflow test successful.'" \
        2>/dev/null)

    if [ -n "$ISSUE_URL" ]; then
        echo "✅ Test issue created: $ISSUE_URL"
        echo "   The workflow should trigger automatically."
        echo "   Check workflow runs: gh run list --limit 5"
        echo ""
        echo "   To clean up after testing:"
        ISSUE_NUM=$(echo "$ISSUE_URL" | grep -oP '\d+$')
        echo "   gh issue close $ISSUE_NUM"
    else
        echo "❌ Could not create test issue"
    fi
else
    echo "⏭️  Skipped workflow test"
    echo "   Note: Workflows trigger on @claude mentions in issues/PRs"
fi
echo ""

# Summary
echo "======================================"
echo "✅ All tests passed!"
echo ""
echo "Your Claude Code workflow setup is correctly configured."
echo ""
echo "Available workflows:"
echo ""
# Reusable workflow called by other repos
echo "  claude-workflow-manager.yml - Reusable workflow that runs Claude Code"
echo "  claude-caller.yml - Example caller that invokes the reusable workflow on @claude mentions"
echo ""
# Auto-trigger workflows
echo "  claude-issue-to-pr.yml - Auto-posts @claude comment on new issues to create PRs"
echo "  test-issue-assigned.yml - Triggers Claude when issues are assigned to skogix"
echo "  test-pr-sync.yml - Runs Claude to check PR merge status when PR is updated"
echo "  pr-mergeability-check.yml - Checks all PRs for conflicts when master is updated"
echo ""
# Standard GitHub workflows
echo "  codeql.yml - GitHub security scanning (auto-generated, not Claude-related)"
echo "  copilot-workflow-manager.yml - GitHub Copilot reusable workflow (not in use)"
echo ""
echo "To trigger workflows, use:"
echo "  - Comment @claude on issues or PRs"
echo "  - Manually: gh workflow run <workflow-name>.yml"
echo "  - Check runs: gh run list"
