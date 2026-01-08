---
name: pr-workflow
description: Use when creating, reviewing, or merging pull requests. Includes CI checks, review requirements, and merge approval rules.
---

# PR Merge Workflow

**NEVER MERGE YOURSELF - ALWAYS WAIT FOR USER APPROVAL!**

## STEPS (All Required)

### 1. Pre-PR Validation
```bash
# Run quality checks
npm test           # or: go test ./...
npm run build      # or: go build ./...
npm run lint       # or: golangci-lint run
```

### 2. Create PR
```bash
gh pr create --title "type: description (closes #issue)" --body "..."
```

### 3. Wait for CI
```bash
gh pr checks <pr-number> --watch
```

### 4. Request Reviews
- Code review from team member
- Security review (if auth/API changes)
- Mobile review (if UI changes)

### 5. Address Feedback
- Fix all CRITICAL issues immediately
- Fix HIGH issues before merge
- Create follow-up tickets for MEDIUM/LOW

### 6. Wait for Approval
```bash
gh pr view <pr-number> --json reviews --jq '.reviews[] | select(.state == "APPROVED")'
```

**IF NO APPROVAL -> STOP AND WAIT!**

### 7. After Approval Only
```bash
gh pr merge <pr-number> --squash --delete-branch
```

---

## REVIEW VERDICTS

| Verdict | Action |
|---------|--------|
| **PASS** | Can be merged |
| **NEEDS WORK** | DO NOT merge! Fix first! |
| **FAIL** | DO NOT merge! Blocker! |

---

## PR TITLE CONVENTION

```
type: short description (closes #issue)

Types:
- feat: New feature
- fix: Bug fix
- refactor: Code refactoring
- docs: Documentation
- test: Adding tests
- chore: Maintenance
```

---

## PR DESCRIPTION TEMPLATE

```markdown
## Summary
- What changed and why

## Test Plan
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] Edge cases verified

## Checklist
- [ ] Code follows project standards
- [ ] Tests pass (100% green)
- [ ] No TODOs in code
- [ ] Documentation updated (if needed)
```

---

## ISSUE LABEL WORKFLOW

| Label | When to Use |
|-------|-------------|
| `in progress` | Actively working on issue |
| `blocked` | Waiting on dependency |
| `ready for review` | PR created, awaiting review |

```bash
# Add label
gh issue edit <nr> --add-label "in progress"

# Add blocker comment
gh issue comment <nr> --body "Blocked by #<dependency> - [reason]"
```

---

## NEVER DO

- Merge without approval
- Force push to shared branches
- Skip CI checks
- Merge with failing tests
- Push directly to main

---

*"Quality gates exist for a reason."*
