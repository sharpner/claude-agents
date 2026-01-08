---
name: verification
description: Use before claiming ANY work is complete. Evidence before claims, always. Non-negotiable verification gate.
---

# Verification Before Completion

**Core Principle: "Evidence before claims, always."**

You MUST execute verification before asserting work is complete, fixed, or passing.

## The 5-Step Gate (Non-Negotiable)

1. **IDENTIFY** the command that proves your claim
2. **RUN** the complete command fresh (not from memory)
3. **READ** the full output, check exit codes and failure counts
4. **VERIFY** whether output actually confirms your claim
5. **ONLY THEN** state your claim with evidence attached

**Skipping any step = dishonest reporting.**

## What Requires Verification

Before claiming ANY of these, you MUST run fresh commands:

| Claim | Required Command |
|-------|------------------|
| "Tests pass" | `npm test` / `go test ./...` / `pytest` |
| "Build succeeds" | `npm run build` / `go build ./...` |
| "Linter is clean" | `npm run lint` / `golangci-lint run` |
| "Bug is fixed" | Reproduce steps + verify fix |
| "Feature works" | E2E test or manual verification |
| "Work is complete" | ALL above checks |

## Red Flags (Stop Immediately)

Watch for these language patterns that bypass verification:

- "should work"
- "probably"
- "seems to"
- "Great!" (before running checks)
- "I believe..."
- "This will..."

**If you catch yourself using these → STOP → Run verification.**

## Output Format

When reporting completion:

```
**Verification:**
- Command: `npm test`
- Exit code: 0
- Output: 47 tests passed, 0 failed
- Claim confirmed: ✅ All tests pass
```

## Why This Matters

**"If you lie, you'll be replaced."**

Prior failures included:
- Shipping undefined functions
- Claiming "fixed" when tests still fail
- Incomplete features marked complete

Trust depends on honest reporting backed by actual evidence.

**NO EXCEPTIONS. NO SHORTCUTS.**
