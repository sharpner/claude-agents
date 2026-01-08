---
name: quality-gate
description: Use when providing responses involving code changes. Defines the quality checklist that MUST be reported in every response.
---

# Quality Gate Checklist

**MUST appear at START of every response involving code changes.**

## The Checklist (Report Every Time)

```
**Quality Gate [X/7]:**
- [ ] Worktree: Working in isolated branch, not main
- [ ] Graphiti: Checked memory for relevant context
- [ ] Delegation: Evaluated if subagents should handle task
- [ ] Tests: All tests passing (`npm test` / `go test`)
- [ ] Verification: Ran commands fresh, evidence attached
- [ ] TDD: Tests written before implementation (for new code)
- [ ] No Shortcuts: No TODOs, no mocks, no placeholders
```

## Detailed Checks

### 1. Worktree Check
```bash
pwd                       # Not in main repo
git branch --show-current # On feature/fix/chore branch
```

### 2. Graphiti Memory Check
```python
mcp__graphiti__search_nodes(query="[keywords]", group_ids=["patterns", "gotchas"])
```
- Did you check for relevant patterns?
- Did you check for known gotchas?

### 3. Delegation Check
- Is this task complex enough for subagent?
- Would a specialized reviewer help?
- Can tasks run in parallel?

### 4. Test Check
```bash
npm test        # or
go test ./...   # or
pytest
```
- Exit code 0?
- All tests pass?
- No new failures?

### 5. Verification Check
- Ran fresh commands (not from memory)?
- Read full output?
- Exit codes checked?

### 6. TDD Check (for new code)
- Test written first?
- Watched test fail?
- Implementation makes test pass?

### 7. No Shortcuts Check
- Zero TODOs in code?
- Zero mocks in production code?
- Zero placeholders?
- Complete implementation?

## Output Format

For code changes, START your response with:

```
**Quality Gate [7/7]:**
- ✅ Worktree: `feat/123-user-auth` in `repo-123/`
- ✅ Graphiti: Searched "auth patterns", found 3 relevant entries
- ✅ Delegation: Task self-contained, no subagent needed
- ✅ Tests: `npm test` → 47/47 passed
- ✅ Verification: Fresh run, exit code 0
- ✅ TDD: Test written first for validateUser()
- ✅ No Shortcuts: Zero TODOs, real implementation

[Then your actual response...]
```

## When Checks Fail

If ANY check fails:
1. **STOP** implementation
2. **FIX** the failing check first
3. **THEN** continue with task

Example:
```
**Quality Gate [5/7]:**
- ❌ Worktree: On main branch!
- ❌ Tests: 2 failing tests

⚠️ BLOCKED: Must create worktree and fix tests before proceeding.

Creating worktree now...
```

## Non-Negotiable Rules

- **Graphiti check**: Always (except trivial questions)
- **Worktree check**: Always before code changes
- **Test check**: Always before claiming completion
- **Verification**: Always before status claims

**No exceptions. Report honestly.**
