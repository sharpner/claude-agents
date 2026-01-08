---
name: debugging
description: Use when facing ANY technical issue. Systematic debugging - root cause investigation BEFORE attempting fixes.
---

# Systematic Debugging

**Core Principle: "NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST."**

Random fixes create new bugs and waste time. Understand before you fix.

## When to Apply

Use for ANY technical issue:
- Test failures
- Production bugs
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Especially critical when:**
- Under time pressure
- "Obvious quick fix" tempts you
- Multiple fix attempts have failed

## The Four Mandatory Phases

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Analyze error messages carefully**
   - Don't skip warnings
   - Note line numbers, error codes
   - Error often contains the solution

2. **Reproduce consistently**
   - Document exact steps
   - Confirm it fails reliably

3. **Review recent changes**
   ```bash
   git log --oneline -10
   git diff HEAD~5
   ```

4. **Trace data flow backward**
   - Follow bad values upstream
   - Find the SOURCE, not the symptom

### Phase 2: Pattern Analysis

1. Find similar **working** code in codebase
2. Compare working vs broken versions
3. List **every difference**
4. Understand all dependencies

### Phase 3: Hypothesis Testing

1. Form ONE specific hypothesis:
   > "I believe X causes this because Y"

2. Test with **smallest possible change**

3. Verify result before proceeding

4. If unsuccessful → new hypothesis (don't compound fixes!)

### Phase 4: Implementation

1. Create failing test that reproduces bug
2. Implement ONE fix addressing root cause
3. Verify solution completely
4. **CRITICAL:** If 3+ fixes failed → question the architecture

## Red Flags (Restart from Phase 1)

Stop immediately if you're thinking:

- "Quick fix for now, investigate later"
- "Let me try this AND this AND this"
- "One more attempt..."
- Planning to skip test creation

**Partner signals to heed:**
- "Stop guessing"
- "We're stuck?"
- "What's the root cause?"

## Output Format

```
**Debugging Report:**

**Symptom:** [What's failing]

**Root Cause Investigation:**
- Error message: [exact error]
- Recent changes: [relevant commits]
- Data trace: [where bad value originates]

**Hypothesis:** [specific theory]

**Test:** [minimal change to verify]

**Result:** [confirmed/rejected]

**Fix:** [single targeted change]

**Verification:** [test output proving fix]
```

## Impact

| Approach | Time | Success Rate |
|----------|------|--------------|
| Systematic investigation | 15-30 min | 95% |
| Random guessing | 2-3 hours | 40% |

**Investigation beats guessing. Every time.**
