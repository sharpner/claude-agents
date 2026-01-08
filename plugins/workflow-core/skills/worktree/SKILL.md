---
name: worktree
description: Use before ANY code changes. Ensures work happens in isolated git worktrees, not on main branch. Critical safety check.
---

# Worktree Isolation

**CRITICAL: NEVER modify code directly on main branch.**

## Mandatory Check (Before ANY Code Change)

```bash
pwd                       # MUST end with -<issue> or -<feature>
git branch --show-current # MUST be feat/*, fix/*, or chore/*
```

**If checks fail → Create worktree FIRST:**

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
ISSUE=<issue-number>
TYPE=<feat|fix|chore>
DESC=<short-description>

# Create worktree
git worktree add ../$REPO_NAME-$ISSUE -b $TYPE/$ISSUE-$DESC

# Enter worktree
cd ../$REPO_NAME-$ISSUE

# Install dependencies
npm install 2>/dev/null || go mod download 2>/dev/null || pip install -e . 2>/dev/null || true

# Verify clean state
npm test 2>/dev/null || go test ./... 2>/dev/null || pytest 2>/dev/null || true
```

## Worktree Directory Convention

- `.worktrees/` (hidden, preferred)
- `../repo-name-<issue>/` (sibling directory)

**MUST be gitignored** - verify before creating.

## Finishing Work

When work is complete, use `/pre-pr` command, then:

```bash
# Option 1: Push and create PR
git push -u origin HEAD
gh pr create --fill

# Option 2: Merge locally (after PR approval)
git checkout main
git pull
git merge --squash $BRANCH
git branch -d $BRANCH
git worktree remove ../$REPO_NAME-$ISSUE
```

## Safety Rules

- **NEVER** push to main directly
- **NEVER** skip worktree check
- **ALWAYS** run tests before leaving worktree
- **ALWAYS** clean up worktrees after merge
