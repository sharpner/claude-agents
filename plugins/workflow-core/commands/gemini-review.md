---
description: "[OPTIONAL - requires Gemini CLI or PAL MCP] Get Gemini AI code review and post as PR comment"
---

Run Gemini code review for the current PR using Gemini CLI.

## Steps

1. Detect PR number from current branch:
```bash
BRANCH=$(git branch --show-current)
PR_NUMBER=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number')
```

2. Get the diff for review:
```bash
gh pr diff $PR_NUMBER
```

3. Run Gemini review using PAL MCP or Gemini CLI:
```bash
# Option A: Using PAL MCP
mcp__pal__codereview --model gemini-2.5-pro

# Option B: Using Gemini CLI directly
gemini -p "Review this PR for: security, error handling, type safety, architecture"
```

4. Post result as PR comment:
```bash
gh pr comment $PR_NUMBER --body "$(cat review-output.md)"
```

## Notes

- Requires Gemini CLI (`gemini`) or PAL MCP configured
- Reviews: security, error handling, type safety, architecture
- Posts review directly as PR comment
