# Workflow Templates

These are templates you can copy to individual repositories.

## claude-caller.yml

Copy this file to any repo's `.github/workflows/claude.yml` to enable Claude workflow assistance.

**Usage:**
```bash
# In your target repository
cp templates/claude-caller.yml .github/workflows/claude.yml
git add .github/workflows/claude.yml
git commit -m "Add Claude workflow assistant"
git push
```

Then mention `@claude` in any issue or PR to get help!
