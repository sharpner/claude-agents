---
description: Complete pre-PR validation checklist before creating pull request
---

You are performing comprehensive pre-PR validation.

## PRE-PR CHECKLIST

### 1. Git Status Check
```bash
git status
git branch --show-current
```

Verify:
- No unexpected changes
- Correct branch (feat/*, fix/*, refactor/*)
- NOT on main branch

### 2. Extract Issue Number
```bash
# From branch name: feat/25-feature-name -> Issue #25
ISSUE=$(git branch --show-current | grep -oE '[0-9]+' | head -1)
if [ -n "$ISSUE" ]; then
    gh issue view $ISSUE --json title,body,labels
fi
```

### 3. Test Suite
```bash
npm test    # or: go test ./...
```

Requirements:
- MUST be 100% green
- Zero failures allowed

### 4. Forbidden Patterns Check
```bash
# No else statements
grep -rn "} else {" src/

# No TODOs
grep -rn "TODO" src/

# No mocks in production
grep -rn "mock" src/ --include="*.ts" --include="*.tsx" --include="*.go"

# No utils folders
find src/ -name "*utils*" -type d
```

### 5. Build Verification
```bash
npm run build    # or: go build ./...
```

Must complete without errors.

### 6. Lint Check
```bash
npm run lint    # or: golangci-lint run
```

No errors (warnings acceptable).

### 7. Code Review
Use review-agent to:
- Review changes against project standards
- Validate acceptance criteria
- Identify potential issues

### 8. Type Check (if applicable)
```bash
npm run typecheck    # TypeScript
```

## OUTPUT FORMAT

```markdown
## PR Readiness Report

### Branch: {branch-name}
### Linked Issue: #{issue} or "None detected"

### Acceptance Criteria
| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| 1 | {From issue} | PASS/FAIL | file:line |

### Tests
- Status: PASS/FAIL
- Count: X tests

### Code Standards
- No else statements: PASS/FAIL
- No TODOs: PASS/FAIL
- No mocks: PASS/FAIL
- No utils folders: PASS/FAIL

### Build: PASS/FAIL
### Lint: PASS/FAIL

### Suggested PR Title
{type}: {description} (closes #{issue})

---
## VERDICT: READY / NOT READY

[If NOT READY, list required fixes]
```
