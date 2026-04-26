---
name: Git identity — don't set it
description: Never set git user.email or user.name — user manages their own git config
type: feedback
---

Do not run `git config user.email` or `git config user.name`. The user manages their own git identity.

**Why:** User rejected the tool call and said "i did set them for you" — they handle identity themselves.

**How to apply:** If a commit fails with "Author identity unknown", ask the user to set it rather than doing it yourself.
