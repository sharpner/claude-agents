---
description: Create and setup a new feature branch for development
argument-hint: <branch-name> [issue-number]
---

You are setting up a new feature branch.

BRANCH NAME: $1
ISSUE NUMBER (optional): $2

## TASKS

### 1. Graphiti Check (if available)
```python
# Load relevant context
mcp__graphiti__get_context(
    query="[keywords from branch name]",
    group_ids=["proj_<projectname>", "global_"]
)
```

### 2. Extract Issue Context (if applicable)
```bash
ISSUE=$2
if [ -n "$ISSUE" ]; then
    gh issue view $ISSUE --json title,body,labels
fi
```

### 3. Create Branch
```bash
# Ensure main is up to date
git fetch origin main

# Create and checkout branch
git checkout -b $1 origin/main
```

### 4. Setup Environment (if needed)
```bash
# Install dependencies
npm install    # or: go mod download

# Run initial tests
npm test       # or: go test ./...
```

### 5. Initial Commit (optional)
```bash
# Only if files were created
git add .
git commit -m "feat: Initialize $1"
```

## STANDARDS

Remember:
- Guard clauses everywhere, NO else
- Real implementations, NO mocks
- TypeScript/Go strict mode
- Follow project design system
- Colocate tests with components

## OUTPUT

```markdown
## Branch Created

### Branch: $1
### Based on: origin/main

### Issue Context (if applicable)
- Issue: #$2
- Title: {title}

### Files Initialized
- {list of created files}

### Next Steps
1. Implement feature
2. Run tests: `npm test`
3. Create PR: `/pre-pr` then `gh pr create`

### Cleanup Command (after merge)
```bash
git checkout main
git pull
git branch -d $1
```
```
