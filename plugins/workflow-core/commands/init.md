---
description: Initialize project with workflow-core - CLAUDE.md, docs, and optional Gemini
---

# Project Initialization

Setting up workflow-core for this project.

## PHASE 1: Gather Project Info

**Ask user for project details:**

Use AskUserQuestion tool:

```
Questions:
1. "Project name?" (short, kebab-case) - e.g., "my-awesome-app"
2. "Project tagline?" (one sentence) - e.g., "The best app ever"
3. "Tech stack?" - Options: ["Go", "TypeScript/Node", "Python", "Other"]
4. "Setup Gemini integration?" - Options: ["Yes (recommended)", "No"]
```

## PHASE 2: Create Directory Structure

```bash
mkdir -p docs/specs
mkdir -p claude-files
mkdir -p .claude/agents
```

## PHASE 3: Create CLAUDE.md

Create `CLAUDE.md` in project root with the following content.

**Replace placeholders:**
- `{{PROJECT_NAME}}` → User's project name
- `{{PROJECT_TAGLINE}}` → User's tagline
- `proj:{{project}}` → `proj:<project-name>`

```markdown
# CLAUDE.md — {{PROJECT_NAME}}

> **"{{PROJECT_TAGLINE}}"**

---

## CRITICAL: MANDATORY BEHAVIORS

**Diese Regeln sind NICHT optional. Bei JEDER Antwort mit Code-Änderungen:**

1. **CHECKLIST ZUERST** — Die `[x/8] Status Check` Checklist MUSS als ALLERERSTES in deiner Antwort erscheinen
2. **GRAPHITI VOR ARBEIT** — Bevor du Code schreibst: `mcp__graphiti__search_nodes(query="...", group_ids=["proj:{{project}}"])`
3. **PR MERGE NIE OHNE REVIEW** — Vor jedem `gh pr merge`: `Task(subagent_type="pr-review-toolkit:code-reviewer")`

**Wenn du diese Regeln nicht befolgst, ist die Antwort UNGÜLTIG.**

---

## QUALITY GATE: [8/8] Status Check

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

## Development Philosophy

**WE MUST NOT DO SHORTCUTS**

### Non-Negotiable Rules
- NO MOCKING — Real backend connections only
- NO TODOs — Fix immediately and completely
- NO else statements — Guard clauses everywhere
- NO utils/ folders — Proper package design
- 100% test pass rate required to commit
- Never push directly to main
- **NO MERGE WITHOUT REVIEW** — Always run code-reviewer subagent

---

## Quick Commands

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

## Graphiti Memory

Group ID: `proj:{{project}}`

```python
# Session start
mcp__graphiti__get_context(
    query="gotcha fix pattern",
    group_ids=["proj:{{project}}"]
)

# Save learning
mcp__graphiti__add_memory(
    name="HEUREKA: Description",
    episode_body="What was learned",
    group_id="proj:{{project}}",
    source="text"
)
```
```

## PHASE 4: Create Master Documents

### docs/VISION.md
```markdown
# VISION.md - {{PROJECT_NAME}}

**Version**: 1.0
**Created**: <today>

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
```

### docs/LEARNINGS.md
```markdown
# LEARNINGS.md - {{PROJECT_NAME}}

**Purpose**: Organizational memory
**Update Frequency**: Weekly

---

## Learnings

### <today> - Project Setup

**What we tried**: Setting up with claude-agents workflow

**What we learned**: Structured workflows improve consistency

**Decision**: Use planning -> implementation -> testing -> review
```

### docs/GUIDANCE.md
```markdown
# GUIDANCE.md - {{PROJECT_NAME}}

**Version**: 1.0
**Created**: <today>

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

---

## Testing

- Overall coverage: > 80%
- Business logic: 100%
```

## PHASE 5: Gemini Setup (if user said Yes)

**Only if user chose Gemini integration:**

### Check Gemini CLI
```bash
which gemini || echo "NOT INSTALLED"
```

If not installed, inform user:
- Install: `npm install -g @google/generative-ai-cli`
- Or: https://github.com/google-gemini/gemini-cli

### Ask for API Key
Use AskUserQuestion:
```
"Gemini API Key? (from https://aistudio.google.com/apikey)"
Options: ["I'll enter it", "Skip for now"]
```

If user provides key, add to shell config:
```bash
SHELL_CONFIG="$HOME/.zshrc"
[ ! -f "$SHELL_CONFIG" ] && SHELL_CONFIG="$HOME/.bashrc"

echo "" >> "$SHELL_CONFIG"
echo "# Gemini API Key (added by workflow-core)" >> "$SHELL_CONFIG"
echo "export GEMINI_API_KEY=\"<USER_KEY>\"" >> "$SHELL_CONFIG"
```

### Copy Gemini Scripts
```bash
mkdir -p scripts

# Download from GitHub
curl -sL https://raw.githubusercontent.com/sharpner/claude-agents/main/plugins/workflow-core/scripts/gemini-review.sh -o scripts/gemini-review.sh
curl -sL https://raw.githubusercontent.com/sharpner/claude-agents/main/plugins/workflow-core/scripts/gemini-subagent-impersonation.sh -o scripts/gemini-subagent-impersonation.sh
curl -sL https://raw.githubusercontent.com/sharpner/claude-agents/main/plugins/workflow-core/scripts/gemini-research.sh -o scripts/gemini-research.sh
chmod +x scripts/gemini-*.sh
```

## PHASE 6: Update .gitignore

```bash
cat >> .gitignore << 'EOF'

# Claude Code
.claude/settings.local.json
claude-files/
EOF
```

## PHASE 7: Summary

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ Project {{PROJECT_NAME}} initialized!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Created:
  ✅ CLAUDE.md (with 8/8 checklist)
  ✅ docs/VISION.md
  ✅ docs/LEARNINGS.md
  ✅ docs/GUIDANCE.md
  ✅ .gitignore updated
  [✅/⏭️] Gemini scripts (if selected)

Graphiti Group ID: proj:{{project}}

Next steps:
  1. Review docs/VISION.md - define your mission
  2. Start work: /workflow-core:feature-branch <name>
  3. Or pick issue: /workflow-core:next-issue

Commands available:
  /workflow-core:pre-pr        - Pre-PR validation
  /workflow-core:feature-branch - Create feature branch
  /workflow-core:next-issue    - Pick next GitHub issue
  /workflow-core:backlog-groom - Backlog refinement
```
