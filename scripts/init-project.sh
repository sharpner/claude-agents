#!/bin/bash
# init-project.sh - Initialize a new project with claude-agents workflow
# Usage: ./init-project.sh <project-name> [project-type]

set -e

PROJECT_NAME=$1
PROJECT_TYPE=${2:-"core"}
DATE=$(date +%Y-%m-%d)

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: ./init-project.sh <project-name> [project-type]"
    echo ""
    echo "Project types:"
    echo "  core      - Basic workflow (default)"
    echo "  ios       - iOS/Swift workflow"
    echo "  fullstack - Full-stack (Go/Node + Frontend)"
    exit 1
fi

echo "Initializing project: $PROJECT_NAME"
echo "Type: $PROJECT_TYPE"
echo ""

# 1. Create directories
echo "Creating directory structure..."
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p docs/specs

# 2. Install plugin (if claude CLI available)
if command -v claude &> /dev/null; then
    echo "Installing workflow-core plugin..."
    claude plugin marketplace add sharpner/claude-agents 2>/dev/null || true
    claude plugin install workflow-core@sharpner-claude-agents --scope project 2>/dev/null || true
else
    echo "Claude CLI not found. Manual plugin installation required."
    echo "Run: /plugin marketplace add sharpner/claude-agents"
    echo "Run: /plugin install workflow-core@sharpner-claude-agents"
fi

# 3. Create CLAUDE.md
echo "Creating CLAUDE.md..."
cat > CLAUDE.md << EOF
# CLAUDE.md - $PROJECT_NAME

---

## SKILLS

| Skill | When to Use |
|-------|-------------|
| \`core-rules\` | ALWAYS - Guard clauses, no TODOs, no mocking |
| \`graphiti-memory\` | Session-start, new tasks, errors |
| \`pr-workflow\` | PRs - CI, review, merge rules |

---

## QUICK COMMANDS

\`\`\`bash
# Add your project-specific commands here
\`\`\`

---

## Reference Docs

| Document | Content |
|----------|---------|
| [docs/VISION.md](./docs/VISION.md) | Strategic direction |
| [docs/LEARNINGS.md](./docs/LEARNINGS.md) | Historical decisions |
| [docs/GUIDANCE.md](./docs/GUIDANCE.md) | Current standards |

---

*Project initialized with claude-agents workflow*
EOF

# 4. Create VISION.md
echo "Creating docs/VISION.md..."
cat > docs/VISION.md << EOF
# VISION.md - $PROJECT_NAME

**Version**: 1.0
**Created**: $DATE
**Next Review**: Quarterly

---

## Mission

[Define your project mission here]

---

## Core Principles

1. **Quality Over Speed** - Production-ready from day one
2. **Maintainability** - Clear over clever
3. **Performance** - Fast and efficient

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Test Coverage | > 80% |
| Build Time | < 2 minutes |

---

*Last Updated: $DATE*
EOF

# 5. Create LEARNINGS.md
echo "Creating docs/LEARNINGS.md..."
cat > docs/LEARNINGS.md << EOF
# LEARNINGS.md - $PROJECT_NAME

**Purpose**: Organizational memory
**Update Frequency**: Weekly (every Friday)

---

## Learnings

### $DATE - Project Setup

**What we tried**: Setting up with claude-agents workflow

**What we learned**: Structured workflows improve consistency

**Decision**: Use planning -> implementation -> testing -> review

**Impact**: All features follow same quality process

---

*Last Updated: $DATE*
EOF

# 6. Create GUIDANCE.md
echo "Creating docs/GUIDANCE.md..."
cat > docs/GUIDANCE.md << EOF
# GUIDANCE.md - $PROJECT_NAME

**Version**: 1.0
**Created**: $DATE
**Next Review**: Bi-weekly

---

## Code Standards

### Guard Clauses (MANDATORY)
- NO else blocks
- Early returns
- Happy path at lowest indentation

### No TODOs
- Fix immediately or delete

### No Mocking
- Real implementations only

### No Utils/Misc
- Proper package organization

---

## Testing

- Overall coverage: > 80%
- Business logic: 100%

---

## Don'ts (FORBIDDEN)

- Else blocks
- TODOs in code
- Mocking in production
- Utils/misc folders

---

*Last Updated: $DATE*
EOF

# 7. Create .gitignore additions
echo "Updating .gitignore..."
cat >> .gitignore << EOF

# Claude Code
.claude/settings.local.json
claude-files/
EOF

# 8. Setup Graphiti group (if available)
echo ""
echo "Graphiti setup reminder:"
echo "  Group ID: proj_$PROJECT_NAME"
echo ""

# Done
echo "=========================================="
echo "Project $PROJECT_NAME initialized!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review and customize docs/VISION.md"
echo "2. Review and customize docs/GUIDANCE.md"
echo "3. Start development with: /feature-branch <name>"
echo ""
echo "Available commands:"
echo "  /pre-pr          - Pre-PR validation"
echo "  /feature-branch  - Create feature branch"
echo ""
echo "Available agents:"
echo "  planning-agent       - Generate feature specs"
echo "  implementation-agent - Implement features"
echo "  testing-agent        - Create tests"
echo "  review-agent         - Code review"
echo ""
