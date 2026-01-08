---
name: tdd
description: Use when implementing ANY new feature or fixing bugs. Test-Driven Development - write tests BEFORE implementation code.
---

# Test-Driven Development (TDD)

**Core Rule: Write tests BEFORE implementation code.**

"If you didn't watch the test fail, you don't know if it tests the right thing."

## The Red-Green-Refactor Cycle

### 1. RED: Write Failing Test First

```typescript
// Write this FIRST
it('should validate email format', () => {
  const result = validateEmail('invalid');
  expect(result.valid).toBe(false);
  expect(result.error).toBe('Invalid email format');
});
```

Run test → **MUST FAIL** (for the right reason: missing feature, not typo)

### 2. GREEN: Implement Minimum Code

```typescript
// Write this SECOND - simplest code to pass
function validateEmail(email: string) {
  if (!email.includes('@')) {
    return { valid: false, error: 'Invalid email format' };
  }
  return { valid: true };
}
```

Run test → **MUST PASS**

### 3. REFACTOR: Clean Up

Improve code quality while keeping tests green.

## Mandatory Verification Points

| Point | What to Check |
|-------|---------------|
| After writing test | Test fails for correct reason (missing feature) |
| After implementing | Test passes, no other tests break |

## Non-Negotiable Rules

- ❌ **Delete** any production code written before tests
- ❌ **Never** keep pre-written code "as reference"
- ❌ **No exceptions** - TDD applies to ALL features and bug fixes
- ❌ **No unnecessary mocking** - tests use real code paths

## For Bug Fixes (Critical!)

1. Write test that **reproduces the bug** (must fail)
2. Verify test fails for the bug reason
3. Implement fix
4. Verify test passes
5. Verify no regression in other tests

```typescript
// Bug: User with spaces in name causes crash
it('should handle names with spaces', () => {
  // This MUST fail before fix
  expect(() => createUser('John Doe')).not.toThrow();
});
```

## Rationalizations to REJECT

| Excuse | Reality |
|--------|---------|
| "Manual testing is enough" | Manual testing doesn't catch regressions |
| "TDD slows me down" | Debugging untested code takes 10x longer |
| "This is too simple" | Simple code still needs regression protection |
| "I'll add tests later" | You won't. And you'll introduce bugs. |

## Output Format

When implementing:

```
**TDD Cycle:**
1. ✅ Test written: `validateEmail returns error for invalid format`
2. ✅ Test fails: "validateEmail is not defined" (correct reason)
3. ✅ Implementation: Added validateEmail function
4. ✅ Test passes: 1/1 assertions passed
5. ✅ No regressions: All 47 tests still pass
```
