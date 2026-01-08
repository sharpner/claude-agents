---
name: core-rules
description: Use ALWAYS. Core development rules for production-ready code - guard clauses, no shortcuts, no mocking.
---

# Core Development Rules

## Code Style (ENFORCED)

- **Guard clauses everywhere** - NO `else` blocks allowed
- **NO TODOs** - Fix immediately, no placeholders
- **NO mocking** - Real backend connections only
- **NO utils/ folders** - Proper package design

## Quality Gates

- **100% test pass rate** required before commit
- **Never push to main** - Always use feature branches
- **TDD for bugs** - Test MUST fail first, then fix

## What We Don't Accept

- Shortcuts or "good enough" implementations
- Simplifications that skip functionality
- Over-engineering beyond current requirements
- Backwards-compatibility hacks (unused vars, re-exports, etc.)

## Guard Clause Examples

```typescript
// CORRECT
function processUser(user?: User) {
  if (!user) return null;
  if (!user.isActive) return null;

  // Happy path at lowest indentation
  return user.process();
}

// FORBIDDEN
function processUser(user?: User) {
  if (user) {
    if (user.isActive) {
      return user.process();
    } else {  // NO - else blocks forbidden
      return null;
    }
  }
}
```

```swift
// CORRECT
func processUser(_ user: User?) {
    guard let user = user else { return }
    guard user.isActive else { return }

    // Happy path
    user.process()
}

// FORBIDDEN
func processUser(_ user: User?) {
    if let user = user {
        if user.isActive {  // NO - nested conditions
            user.process()
        }
    }
}
```

```go
// CORRECT
func processUser(user *User) error {
    if user == nil {
        return ErrNoUser
    }
    if !user.IsActive {
        return ErrInactiveUser
    }

    // Happy path
    return user.Process()
}

// FORBIDDEN - else blocks
func processUser(user *User) error {
    if user != nil {
        if user.IsActive {
            return user.Process()
        } else {  // NO
            return ErrInactiveUser
        }
    } else {  // NO
        return ErrNoUser
    }
}
```

## Commit Philosophy

```
BEFORE COMMIT:
- All tests green (100%)
- No TODOs in code
- No placeholder implementations
- Real connections (no mocks)
- Guard clauses used everywhere
```

*"Quality is not negotiable."*
