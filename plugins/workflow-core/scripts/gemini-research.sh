#!/bin/bash
# Gemini Research: Web + Codebase Analysis
# Usage: ./scripts/gemini-research.sh "topic to research"
#
# OPTIONAL: Requires Gemini CLI - Install: https://github.com/google-gemini/gemini-cli
#
# Example: ./scripts/gemini-research.sh "improve UX for form validation"

set -euo pipefail

TOPIC="${1:-}"

if [[ -z "$TOPIC" ]]; then
  echo "Usage: $0 \"<research topic>\""
  echo ""
  echo "Examples:"
  echo "  $0 \"improve UX for forms\""
  echo "  $0 \"accessibility best practices\""
  echo "  $0 \"React performance optimization\""
  exit 1
fi

# Check for Gemini CLI
if ! command -v gemini &> /dev/null; then
  echo "Error: Gemini CLI not found"
  echo "Install: https://github.com/google-gemini/gemini-cli"
  exit 1
fi

# Get project root
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
OUTPUT_DIR="$PROJECT_ROOT/claude-files"
OUTPUT_FILE="$OUTPUT_DIR/research-$(date +%Y%m%d-%H%M%S).md"

echo "🔍 Researching: $TOPIC"
echo ""

# Create output directory if needed
mkdir -p "$OUTPUT_DIR"

# Run Gemini with research prompt
cat <<EOF | gemini | tee "$OUTPUT_FILE"
You are a senior software engineer researching a topic for a software project.

## Research Topic
$TOPIC

## Your Task

### Phase 1: Web Research
Search the web for:
1. Current best practices (2024-2025)
2. Common pitfalls to avoid
3. Industry standards and guidelines
4. Examples from similar products

### Phase 2: Codebase Analysis
Analyze the project codebase at: $PROJECT_ROOT

Look for relevant code patterns and existing implementations.

### Phase 3: Gap Analysis
Compare best practices against current implementation:
1. What's done well?
2. What could be improved?
3. What's missing?

## Output Format

# Research Report: $TOPIC

## Executive Summary
[2-3 sentences]

## Best Practices Found
1. [Practice] - [Why it matters]
2. ...

## Current State
- ✅ [What's done well]
- ⚠️ [What needs improvement]
- ❌ [What's missing]

## Recommended Actions
1. [High priority action]
2. [Medium priority action]
3. [Low priority action]

## Code Examples
[Specific code snippets showing suggested improvements]

## Sources
- [URL 1]
- [URL 2]
EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📄 Report saved to: $OUTPUT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
