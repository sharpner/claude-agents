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

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude Agents - Project Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Project: $PROJECT_NAME"
echo "Type: $PROJECT_TYPE"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GEMINI SETUP (Optional)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SETUP_GEMINI="n"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Gemini Integration (Optional)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Gemini enables:"
echo "  - gemini-review.sh: AI code reviews for PRs"
echo "  - gemini-subagent-impersonation.sh: Gemini as Claude agent (80% cheaper)"
echo "  - gemini-research.sh: Web + codebase research"
echo ""
read -p "Setup Gemini integration? [y/N]: " SETUP_GEMINI

if [[ "$SETUP_GEMINI" =~ ^[Yy]$ ]]; then
    echo ""

    # Check if Gemini CLI is installed
    if command -v gemini &> /dev/null; then
        echo "✅ Gemini CLI found"
    else
        echo "⚠️  Gemini CLI not found"
        echo ""
        echo "Install options:"
        echo "  npm install -g @anthropic-ai/gemini-cli"
        echo "  or: https://github.com/google-gemini/gemini-cli"
        echo ""
    fi

    # Check for existing API key
    if [ -n "$GEMINI_API_KEY" ]; then
        echo "✅ GEMINI_API_KEY already set in environment"
    else
        echo ""
        echo "Get your API key from: https://aistudio.google.com/apikey"
        echo ""
        read -p "Enter Gemini API Key (or press Enter to skip): " GEMINI_KEY

        if [ -n "$GEMINI_KEY" ]; then
            # Detect shell config file
            SHELL_CONFIG=""
            if [ -f "$HOME/.zshrc" ]; then
                SHELL_CONFIG="$HOME/.zshrc"
            elif [ -f "$HOME/.bashrc" ]; then
                SHELL_CONFIG="$HOME/.bashrc"
            elif [ -f "$HOME/.bash_profile" ]; then
                SHELL_CONFIG="$HOME/.bash_profile"
            fi

            if [ -n "$SHELL_CONFIG" ]; then
                echo "" >> "$SHELL_CONFIG"
                echo "# Gemini API Key (added by claude-agents)" >> "$SHELL_CONFIG"
                echo "export GEMINI_API_KEY=\"$GEMINI_KEY\"" >> "$SHELL_CONFIG"
                echo "✅ Added GEMINI_API_KEY to $SHELL_CONFIG"
                echo "   Run: source $SHELL_CONFIG"
                export GEMINI_API_KEY="$GEMINI_KEY"
            else
                echo "⚠️  Could not detect shell config file"
                echo "   Add manually: export GEMINI_API_KEY=\"$GEMINI_KEY\""
            fi
        fi
    fi

    # Copy Gemini scripts to project
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PLUGIN_SCRIPTS="$SCRIPT_DIR/../plugins/workflow-core/scripts"

    if [ -d "$PLUGIN_SCRIPTS" ]; then
        echo ""
        echo "Copying Gemini scripts to project..."
        mkdir -p scripts
        cp "$PLUGIN_SCRIPTS/gemini-review.sh" scripts/ 2>/dev/null || true
        cp "$PLUGIN_SCRIPTS/gemini-subagent-impersonation.sh" scripts/ 2>/dev/null || true
        cp "$PLUGIN_SCRIPTS/gemini-research.sh" scripts/ 2>/dev/null || true
        chmod +x scripts/gemini-*.sh 2>/dev/null || true
        echo "✅ Gemini scripts copied to scripts/"
    fi
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DIRECTORY STRUCTURE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "Creating directory structure..."
mkdir -p .claude/agents
mkdir -p .claude/skills
mkdir -p docs/specs
mkdir -p claude-files

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# PLUGIN INSTALLATION
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v claude &> /dev/null; then
    echo "Installing workflow-core plugin..."
    claude plugin marketplace add sharpner/claude-agents 2>/dev/null || true
    claude plugin install workflow-core@sharpner-claude-agents --scope project 2>/dev/null || true
else
    echo "Claude CLI not found. Manual plugin installation required:"
    echo "  /plugin marketplace add sharpner/claude-agents"
    echo "  /plugin install workflow-core@sharpner-claude-agents"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CLAUDE.MD
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "Creating CLAUDE.md..."
cat > CLAUDE.md << 'CLAUDEEOF'
# CLAUDE.md — PROJECT_NAME_PLACEHOLDER

## Development Philosophy

**WE MUST NOT DO SHORTCUTS**

### Non-Negotiable Rules
- NO MOCKING — Real backend connections only
- NO TODOs — Fix immediately and completely
- NO else statements — Guard clauses everywhere
- NO utils/ folders — Proper package design
- 100% test pass rate required to commit
- Never push directly to main
- **NO MERGE WITHOUT REVIEW** — Always run code-reviewer subagent before merging PRs

---

## SKILLS

| Skill | When to Use |
|-------|-------------|
| `core-rules` | **ALWAYS** — Guard clauses, no TODOs, no mocking |
| `quality-gate` | **ALWAYS bei Code-Änderungen** — 8/8 Checklist PFLICHT! |
| `worktree` | **VOR Code-Änderungen** — Isolation Check |
| `graphiti-memory` | Session-Start, neue Tasks, bei Fehlern |
| `delegation` | Komplexe Tasks — Subagent-Auswahl |
| `tdd` | Neue Features, Bug Fixes — Tests FIRST |
| `debugging` | Bei Fehlern — Root Cause vor Fix |
| `verification` | Vor Completion Claims — Evidence required |
| `pr-workflow` | PRs — CI, Review, Merge-Rules |

---

## 🎯 QUALITY GATE: [8/8] Status Check

**MUSS als ERSTES in jeder Antwort stehen bei Code-Änderungen:**

```
**[x/8] Status Check:**
- ✅ Graphiti: VOR der Arbeit nach [keywords] gesucht
- ✅ Delegation: Task delegiert / Begründet selbst gemacht
- ✅ Product Review: Team konsultiert / Keine Feature-Planung
- ✅ Design System: Style compliant / Keine UI-Änderungen
- ✅ Testing: Tests erfolgreich / Keine Code-Änderungen
- ✅ PR Review: CI grün + code-reviewer / Kein PR
- ✅ Mobile: mobile-reviewer passed / Keine UI-Änderungen
- ✅ Security: security-reviewer passed / Keine API/Auth-Änderungen
```

---

## QUICK COMMANDS

```bash
# Add your project-specific commands here
make dev      # Start dev server
make test     # Run tests
```

---

## Reference Docs

| Document | Content |
|----------|---------|
| [docs/VISION.md](./docs/VISION.md) | Strategic direction |
| [docs/LEARNINGS.md](./docs/LEARNINGS.md) | Historical decisions |
| [docs/GUIDANCE.md](./docs/GUIDANCE.md) | Current standards |

---

*Project initialized with claude-agents workflow*
CLAUDEEOF

# Replace placeholder with actual project name
sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" CLAUDE.md 2>/dev/null || \
sed -i "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" CLAUDE.md 2>/dev/null || true

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# VISION.MD
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "Creating docs/VISION.md..."
cat > docs/VISION.md << EOF
# VISION.md - $PROJECT_NAME

**Version**: 1.0
**Created**: $DATE

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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# LEARNINGS.MD
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "Creating docs/LEARNINGS.md..."
cat > docs/LEARNINGS.md << EOF
# LEARNINGS.md - $PROJECT_NAME

**Purpose**: Organizational memory
**Update Frequency**: Weekly

---

## Learnings

### $DATE - Project Setup

**What we tried**: Setting up with claude-agents workflow

**What we learned**: Structured workflows improve consistency

**Decision**: Use planning -> implementation -> testing -> review

---

*Last Updated: $DATE*
EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GUIDANCE.MD
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "Creating docs/GUIDANCE.md..."
cat > docs/GUIDANCE.md << EOF
# GUIDANCE.md - $PROJECT_NAME

**Version**: 1.0
**Created**: $DATE

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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# GITIGNORE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "Updating .gitignore..."
cat >> .gitignore << EOF

# Claude Code
.claude/settings.local.json
claude-files/
EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# DONE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Project $PROJECT_NAME initialized!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Graphiti Group ID: proj_$PROJECT_NAME"
echo ""
echo "Next steps:"
echo "  1. Review docs/VISION.md"
echo "  2. Review docs/GUIDANCE.md"
echo "  3. Start: /feature-branch <name>"
echo ""
echo "Commands:"
echo "  /pre-pr          - Pre-PR validation"
echo "  /feature-branch  - Create feature branch"
echo "  /next-issue      - Pick next GitHub issue"
echo "  /backlog-groom   - Backlog refinement"
echo ""
if [[ "$SETUP_GEMINI" =~ ^[Yy]$ ]]; then
echo "Gemini Scripts:"
echo "  ./scripts/gemini-review.sh <pr-number>"
echo "  ./scripts/gemini-subagent-impersonation.sh <pr> <agent>"
echo "  ./scripts/gemini-research.sh \"<topic>\""
echo ""
fi
echo "Agents:"
echo "  planning-agent       - Feature specs"
echo "  implementation-agent - Implement features"
echo "  testing-agent        - Create tests"
echo "  review-agent         - Code review"
echo "  gemini-explorer      - Large-context analysis (optional)"
echo ""
