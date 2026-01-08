# claude-agents

Production-ready Claude Code workflows with Graphiti memory, quality gates, and agent templates.

## Quick Start

```bash
# In Claude Code, register the marketplace
/plugin marketplace add sharpner/claude-agents

# Install the core workflow plugin
/plugin install workflow-core@sharpner-claude-agents

# Optional: Setup Gemini integration
/workflow-core:setup-gemini
```

---

## Prerequisites

- **GitHub CLI (`gh`)** — Required for PR workflows and scripts
  ```bash
  # Install: https://cli.github.com/
  brew install gh        # macOS

  # Authenticate
  gh auth login
  ```

---

## What's Included

### Skills (9)

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

### Agents (5)

| Agent | Purpose |
|-------|---------|
| `planning-agent` | Generate feature specs from master docs |
| `implementation-agent` | Implement with zero shortcuts |
| `testing-agent` | Comprehensive test coverage |
| `review-agent` | Quality gate validation |
| `gemini-explorer` | [OPTIONAL] Large-context codebase analysis (1M tokens) |

### Commands (6)

| Command | Purpose |
|---------|---------|
| `/workflow-core:pre-pr` | Pre-PR validation checklist |
| `/workflow-core:feature-branch` | Create and setup feature branch |
| `/workflow-core:next-issue` | Pick next GitHub issue, create worktree, start implementation |
| `/workflow-core:backlog-groom` | Goal-driven backlog refinement |
| `/workflow-core:gemini-review` | [OPTIONAL] Gemini AI code review |
| `/workflow-core:setup-gemini` | Setup Gemini API key and scripts |

### Scripts (3, optional)

| Script | Purpose |
|--------|---------|
| `gemini-review.sh` | PR code review with PASS/NEEDS WORK/FAIL verdict |
| `gemini-subagent-impersonation.sh` | Make Gemini impersonate Claude agents (80% cheaper) |
| `gemini-research.sh` | Web + codebase research |

---

## 🎯 Quality Gate: 8/8 Checklist

**MUST appear at START of every response with code changes:**

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

## Core Philosophy

### NO SHORTCUTS

- **NO MOCKING** — Real backend connections only
- **NO TODOs** — Fix immediately and completely
- **NO else statements** — Guard clauses everywhere
- **NO utils/ folders** — Proper package design
- **100% test pass rate** required to commit
- **Never push directly to main**
- **NO MERGE WITHOUT REVIEW** — Always run code-reviewer subagent

### Guard Clauses

```typescript
// ✅ CORRECT
function process(data?: Data) {
  if (!data) return null;
  if (!data.valid) return null;

  // Happy path at lowest indentation
  return transform(data);
}

// ❌ FORBIDDEN - else blocks
function process(data?: Data) {
  if (data) {
    if (data.valid) {
      return transform(data);
    } else {  // NO!
      return null;
    }
  }
}
```

---

## Workflow

```
/next-issue (picks from GitHub, creates worktree)
        ↓
Planning Agent (reads VISION/LEARNINGS/GUIDANCE)
        ↓
Feature Specification (docs/specs/feature-*.md)
        ↓
Implementation Agent (TDD, guard clauses, no shortcuts)
        ↓
Testing Agent (>80% coverage)
        ↓
Review Agent (8/8 quality gate)
        ↓
/pre-pr (validation checklist)
        ↓
PR Workflow (CI → code-reviewer → Merge)
```

---

## Gemini Integration (Optional)

Setup Gemini for 80% cheaper code reviews:

```bash
/workflow-core:setup-gemini
```

This will:
1. Check if Gemini CLI is installed
2. Ask for your API key (from https://aistudio.google.com/apikey)
3. Add to your shell config
4. Copy scripts to your project

Usage:
```bash
./scripts/gemini-review.sh 123                    # Review PR #123
./scripts/gemini-subagent-impersonation.sh 123 security-reviewer
./scripts/gemini-research.sh "performance optimization"
```

---

## Master Documents

| Document | Purpose | Review |
|----------|---------|--------|
| `docs/VISION.md` | Long-term strategic direction | Quarterly |
| `docs/LEARNINGS.md` | Historical decisions and outcomes | Weekly |
| `docs/GUIDANCE.md` | Current tactical standards | Bi-weekly |

---

## Graphiti Memory

```python
# Session start - load context
mcp__graphiti__get_context(
    query="gotcha fix pattern",
    group_ids=["proj:<project>"]
)

# After fixing bug - save learning (HEUREKA rule!)
mcp__graphiti__add_memory(
    name="HEUREKA: Description",
    episode_body="What was learned, what was wrong, how it really works",
    group_id="proj:<project>",
    source="text"
)
```

---

## Project Structure

```
claude-agents/
├── plugins/
│   └── workflow-core/
│       ├── .claude-plugin/plugin.json
│       ├── skills/
│       │   ├── core-rules/SKILL.md
│       │   ├── quality-gate/SKILL.md
│       │   ├── worktree/SKILL.md
│       │   ├── graphiti-memory/SKILL.md
│       │   ├── delegation/SKILL.md
│       │   ├── tdd/SKILL.md
│       │   ├── debugging/SKILL.md
│       │   ├── verification/SKILL.md
│       │   └── pr-workflow/SKILL.md
│       ├── agents/
│       │   ├── planning-agent.md
│       │   ├── implementation-agent.md
│       │   ├── testing-agent.md
│       │   ├── review-agent.md
│       │   └── gemini-explorer.md
│       ├── commands/
│       │   ├── pre-pr.md
│       │   ├── feature-branch.md
│       │   ├── next-issue.md
│       │   ├── backlog-groom.md
│       │   ├── gemini-review.md
│       │   └── setup-gemini.md
│       ├── scripts/
│       │   ├── gemini-review.sh
│       │   ├── gemini-subagent-impersonation.sh
│       │   └── gemini-research.sh
│       └── templates/
│           └── CLAUDE.md.template
├── scripts/
│   └── init-project.sh
└── README.md
```

---

## Initialize New Project

```bash
# Option 1: Use init script (interactive, asks for Gemini)
git clone https://github.com/sharpner/claude-agents.git /tmp/claude-agents
/tmp/claude-agents/scripts/init-project.sh my-project

# Option 2: Manual
/plugin marketplace add sharpner/claude-agents
/plugin install workflow-core@sharpner-claude-agents
/workflow-core:setup-gemini  # optional
```

---

## License

MIT

---

*"8/8 oder nichts."*
