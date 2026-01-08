---
description: Pick next issue from GitHub, create worktree, and start implementation with subagents
---

You are starting work on the next GitHub issue following agile workflow.

## PHASE 1: GRAPHITI CHECK (REQUIRED!)

**Search working memory first:**

```python
# Session context
mcp__graphiti__get_episodes(group_ids=["proj:<project>"], max_episodes=5)

# Known issues/gotchas
mcp__graphiti__search_nodes(
    query="current work progress blockers",
    group_ids=["proj:<project>"],
    max_nodes=5
)
```

## PHASE 2: ISSUE SELECTION (Label-based)

**Find open issues by priority:**

```bash
# 1. "next" Label = PO explicitly prioritized (ALWAYS FIRST!)
gh issue list --label "next" --state open --json number,title,labels --jq '.[0]'

# 2. If no "next": P0 (not blocked, not in progress)
gh issue list --label "P0" --state open --json number,title,labels --jq '
  [.[] | select(.labels | map(.name) | contains(["blocked"]) | not)]
  | [.[] | select(.labels | map(.name) | contains(["in progress"]) | not)]
  | .[0]'

# 3. If no P0: P1
gh issue list --label "P1" --state open --json number,title,labels --jq '
  [.[] | select(.labels | map(.name) | contains(["blocked"]) | not)]
  | [.[] | select(.labels | map(.name) | contains(["in progress"]) | not)]
  | .[0]'

# 4. If no P1: P2
gh issue list --label "P2" --state open --json number,title,labels --jq '
  [.[] | select(.labels | map(.name) | contains(["blocked"]) | not)]
  | [.[] | select(.labels | map(.name) | contains(["in progress"]) | not)]
  | .[0]'

# 5. If no priority: bug
gh issue list --label "bug" --state open --json number,title,labels --jq '
  [.[] | select(.labels | map(.name) | contains(["blocked"]) | not)]
  | [.[] | select(.labels | map(.name) | contains(["in progress"]) | not)]
  | .[0]'
```

**Priority order:**
1. `next` — PO marked this as next
2. `P0` (not `blocked`, not `in progress`) — Critical
3. `P1` — High priority
4. `P2` — Medium priority
5. `bug` — Bugs without priority label
6. Any open issue

**Select issue and load details:**
```bash
gh issue view <issue-number> --json number,title,body,labels
```

**Derive type from labels:**
- `bug` → Branch-Prefix: `fix/`
- `story` → Branch-Prefix: `feat/`
- other → Branch-Prefix: `chore/`

## PHASE 3: GRAPHITI CONTEXT

**Search relevant knowledge for the issue:**

```python
mcp__graphiti__search_nodes(
    query="[keywords from issue title/body]",
    group_ids=["proj:<project>"],
    max_nodes=10
)

mcp__graphiti__search_memory_facts(
    query="[component or feature name from issue]",
    group_ids=["proj:<project>"],
    max_facts=10
)
```

## PHASE 4: WORKTREE CREATION

```bash
# Set variables
ISSUE=<issue-number>
TYPE=<feat|fix|chore>
DESC=<short-kebab-case-description>
REPO_NAME=$(basename $(git rev-parse --show-toplevel))

# Create worktree
git worktree add ../$REPO_NAME-$ISSUE -b $TYPE/$ISSUE-$DESC

# Switch to worktree
cd ../$REPO_NAME-$ISSUE

# Ensure dependencies
npm install 2>/dev/null || go mod download 2>/dev/null || true
```

## PHASE 4.5: STATUS UPDATE (Labels)

**Mark issue as "in progress":**

```bash
# Set label
gh issue edit $ISSUE --add-label "in progress"

# Remove "next" label if present
gh issue edit $ISSUE --remove-label "next" 2>/dev/null || true
```

## PHASE 5: CODEBASE EXPLORATION

**Launch explore-agent for relevant areas:**

```
Task(
    subagent_type="Explore",
    prompt="Explore the codebase for issue #<number>: <title>

    Context from issue:
    <issue body>

    Find:
    1. Existing code related to this feature/bug
    2. Similar patterns already implemented
    3. Files that will need modification
    4. Test patterns used in similar features

    Be thorough - this informs our implementation plan.",
    model="sonnet"
)
```

## PHASE 6: IMPLEMENTATION PLANNING

**Plan-agent for implementation strategy:**

```
Task(
    subagent_type="Plan",
    prompt="Create implementation plan for issue #<number>: <title>

    Issue Details:
    <issue body with acceptance criteria>

    Exploration Results:
    <findings from Explore agent>

    Graphiti Context:
    <relevant patterns/gotchas found>

    Requirements:
    - Follow TDD (tests first for bugs!)
    - Guard clauses only (no else)
    - Real implementations (no mocks)

    Create a step-by-step plan with specific files and changes.",
    model="sonnet"
)
```

## PHASE 7: START IMPLEMENTATION

**Convert plan to tasks with TodoWrite:**

Based on Plan-agent result:
1. Create TodoWrite with all steps
2. Mark first task as `in_progress`
3. Begin implementation

**For Bugs (TDD!):**
- FIRST write test that reproduces the bug
- Test MUST fail
- Then implement fix
- Test must pass

**For Features:**
- Tests parallel to implementation
- All ACs from issue must be covered

## OUTPUT

After completing all phases, report:

```
## Issue Selected: #<number> - <title>

### Graphiti Context
- [Relevant patterns/gotchas found]

### Worktree Created
- Path: ../<repo>-<issue>
- Branch: <type>/<issue>-<desc>

### Status Updated
- Label "in progress" set

### Exploration Summary
- [Key findings from Explore agent]

### Implementation Plan
- [Summary from Plan agent]

### Todo List Created
- [X tasks queued]

### Next Step
- Currently implementing: [first task]
```

## REMINDERS

- **NEVER** push to main
- **ALWAYS** run tests before commit (`make test` or `npm test`)
- **ALWAYS** pre-pr before PR creation (`/pre-pr`)
- **ALWAYS** code-reviewer before merge
- **ALWAYS** wait for GitHub Approve before merge
- **ALWAYS** save insights to Graphiti (EUREKA rule!)
- If blocked: `gh issue edit $ISSUE --add-label "blocked"` + comment
