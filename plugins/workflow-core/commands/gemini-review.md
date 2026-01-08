---
description: "[OPTIONAL - requires Gemini CLI] Get Gemini AI code review and post as PR comment"
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

3. Run Gemini review using Gemini CLI:
```bash
gh pr diff $PR_NUMBER | gemini "Review this PR diff for: security vulnerabilities, error handling, type safety, architecture issues. Be specific with file:line references."
```

4. Post result as PR comment:
```bash
gh pr comment $PR_NUMBER --body "$(cat review-output.md)"
```

## Notes

- Requires Gemini CLI (`gemini`) - Install: https://github.com/google-gemini/gemini-cli
- Reviews: security, error handling, type safety, architecture
- Posts review directly as PR comment
