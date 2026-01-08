#!/bin/bash
# Gemini Code Review for GitHub PRs
# Usage: ./scripts/gemini-review.sh <pr-number> [focus-instructions]
#
# OPTIONAL: Requires Gemini CLI - Install: https://github.com/google-gemini/gemini-cli
#
# Features:
#   - Code review with PASS/NEEDS WORK/FAIL verdict
#   - Recommends specialized reviewers
#   - Creates GitHub tasks for critical issues
#
# Examples:
#   ./scripts/gemini-review.sh 236
#   ./scripts/gemini-review.sh 236 "focus on backward compatibility"

set -euo pipefail

PR_NUMBER="${1:-}"
FOCUS="${2:-}"

if [[ -z "$PR_NUMBER" ]]; then
  echo "Usage: $0 <pr-number> [focus-instructions]"
  echo ""
  echo "Examples:"
  echo "  $0 236"
  echo "  $0 236 \"focus on security\""
  exit 1
fi

# Check for Gemini CLI
if ! command -v gemini &> /dev/null; then
  echo "Error: Gemini CLI not found"
  echo "Install: https://github.com/google-gemini/gemini-cli"
  exit 1
fi

echo "Fetching PR #$PR_NUMBER info..."
DIFF=$(gh pr diff "$PR_NUMBER" 2>/dev/null)

if [[ -z "$DIFF" ]]; then
  echo "Error: Could not fetch diff for PR #$PR_NUMBER"
  exit 1
fi

# Get PR info for context
PR_TITLE=$(gh pr view "$PR_NUMBER" --json title -q '.title')
PR_BODY=$(gh pr view "$PR_NUMBER" --json body -q '.body' | head -50)

# Get changed files stats
CHANGED_FILES=$(gh pr diff "$PR_NUMBER" --name-only 2>/dev/null)
FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')
ADDITION_COUNT=$(gh pr view "$PR_NUMBER" --json additions -q '.additions')
DELETION_COUNT=$(gh pr view "$PR_NUMBER" --json deletions -q '.deletions')
TOTAL_CHANGES=$((ADDITION_COUNT + DELETION_COUNT))

echo "Changed files: $FILE_COUNT, Lines changed: $TOTAL_CHANGES"

# Detect file categories
HAS_UI_FILES=$(echo "$CHANGED_FILES" | grep -E '\.(tsx|css)$' | grep -v '\.test\.' | head -1 || true)
HAS_API_FILES=$(echo "$CHANGED_FILES" | grep -E 'api/|route\.ts|middleware' | head -1 || true)
HAS_AUTH_FILES=$(echo "$CHANGED_FILES" | grep -E 'auth|session|login|password|token' | head -1 || true)

# Determine complexity
IS_COMPLEX="false"
if [[ $FILE_COUNT -gt 10 ]] || [[ $TOTAL_CHANGES -gt 500 ]]; then
  IS_COMPLEX="true"
  echo "⚠️  Complex PR detected ($FILE_COUNT files, $TOTAL_CHANGES lines)"
fi

# Build focus section if provided
FOCUS_SECTION=""
if [[ -n "$FOCUS" ]]; then
  FOCUS_SECTION="
**SPECIAL FOCUS (prioritize this!):**
$FOCUS
"
  echo "Special focus: $FOCUS"
fi

FILE_CONTEXT="
**Changed Files ($FILE_COUNT files, $TOTAL_CHANGES lines):**
- UI Components: $([ -n "$HAS_UI_FILES" ] && echo "YES" || echo "no")
- API Routes: $([ -n "$HAS_API_FILES" ] && echo "YES" || echo "no")
- Auth/Security: $([ -n "$HAS_AUTH_FILES" ] && echo "YES" || echo "no")
- Complex PR: $IS_COMPLEX
"

echo "Running Gemini review..."

REVIEW=$(cat <<EOF | gemini
You are a senior code reviewer. Review this GitHub PR diff.

**PR Title:** $PR_TITLE

**PR Description:**
$PR_BODY
$FOCUS_SECTION
$FILE_CONTEXT
**Diff:**
\`\`\`diff
$DIFF
\`\`\`

**Review for:**
1. Security vulnerabilities (SQL injection, XSS, auth issues)
2. Error handling (silent failures, missing validation)
3. Type safety issues
4. Architecture concerns
5. Performance issues

**Format your response as:**
## Gemini Code Review

**Verdict:** PASS | NEEDS WORK | FAIL

### Critical Issues
- [List or 'None found']

### Warnings
- [List or 'None']

### Suggestions
- [List or 'None']

### Summary
[1-2 sentence summary]

---
## Required Before Merge

### 1. E2E Testing
Test the changed features manually in a production-like environment.

### 2. Automated Tests
All tests must pass.

### 3. Get Approval & Merge
After approval: gh pr merge --squash --delete-branch

Be concise. Only flag real issues, not style preferences.
EOF
)

echo ""
echo "Posting review as PR comment..."

gh pr comment "$PR_NUMBER" --body "$REVIEW"

echo ""
echo "=========================================="
echo "Review posted to PR #$PR_NUMBER"
echo "=========================================="

# Extract verdict
VERDICT=$(echo "$REVIEW" | grep -E '\*\*Verdict:\*\*' | head -1)
echo ""
echo "$VERDICT"
