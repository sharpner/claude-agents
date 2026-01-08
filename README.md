# claude-agents

Production-ready Claude Code workflows with Graphiti memory, quality gates, and agent templates.

## Quick Start

### Installation

```bash
# In Claude Code, register the marketplace
/plugin marketplace add sharpner/claude-agents

# Install the core workflow plugin
/plugin install workflow-core@sharpner-claude-agents
```

### Initialize New Project

```bash
# Clone and run init script
git clone https://github.com/sharpner/claude-agents.git /tmp/claude-agents
/tmp/claude-agents/scripts/init-project.sh my-project
```

Or manually:
1. Install plugin (see above)
2. Create `docs/VISION.md`, `docs/LEARNINGS.md`, `docs/GUIDANCE.md`
3. Start using skills and agents

---

## What's Included

### Skills

| Skill | Purpose |
|-------|---------|
| `core-rules` | Guard clauses, no TODOs, no mocking, no utils |
| `graphiti-memory` | Knowledge graph memory for patterns/fixes |
| `pr-workflow` | PR lifecycle: CI, review, merge rules |

### Agents

| Agent | Purpose |
|-------|---------|
| `planning-agent` | Generate feature specs from master docs |
| `implementation-agent` | Implement with zero shortcuts |
| `testing-agent` | Comprehensive test coverage |
| `review-agent` | Quality gate validation |

### Commands

| Command | Purpose |
|---------|---------|
| `/pre-pr` | Pre-PR validation checklist |
| `/feature-branch` | Create and setup feature branch |

---

## Core Philosophy

### NO SHORTCUTS

- **IMMEDIATE FIXES**: Fix issues when discovered
- **COMPLETE IMPLEMENTATIONS**: No TODOs, no placeholders
- **REAL CONNECTIONS**: No mocking in production
- **PRODUCTION QUALITY**: Every line ready for production
- **COMPREHENSIVE TESTING**: >80% coverage

### Guard Clauses Everywhere

```typescript
// CORRECT
function process(data?: Data) {
  if (!data) return null;
  if (!data.valid) return null;

  // Happy path at lowest indentation
  return transform(data);
}

// FORBIDDEN - else blocks
function process(data?: Data) {
  if (data) {
    if (data.valid) {
      return transform(data);
    } else {  // NO
      return null;
    }
  }
}
```

---

## Workflow

```
Planning Agent (reads VISION/LEARNINGS/GUIDANCE)
        ↓
Feature Specification (docs/specs/feature-*.md)
        ↓
Implementation Agent (writes production code)
        ↓
Testing Agent (creates comprehensive tests)
        ↓
Review Agent (quality gate validation)
        ↓
PR Workflow (CI → Review → Merge)
```

---

## Master Documents

### VISION.md
- Long-term strategic direction
- Review: Quarterly

### LEARNINGS.md
- Historical decisions and outcomes
- Update: Weekly (Friday)

### GUIDANCE.md
- Current tactical standards
- Review: Bi-weekly

---

## Graphiti Memory

Store patterns, fixes, and learnings:

```python
# Session start - load context
mcp__graphiti__get_context(
    query="gotcha fix pattern",
    group_ids=["proj_<project>"]
)

# After fixing bug - save learning
mcp__graphiti__add_memory(
    name="FIX: Description",
    episode_body="Problem and solution",
    group_id="proj_<project>",
    source_description="fix"
)
```

---

## Project Structure

```
claude-agents/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   └── workflow-core/
│       ├── .claude-plugin/plugin.json
│       ├── skills/
│       │   ├── core-rules/SKILL.md
│       │   ├── graphiti-memory/SKILL.md
│       │   └── pr-workflow/SKILL.md
│       ├── agents/
│       │   ├── planning-agent.md
│       │   ├── implementation-agent.md
│       │   ├── testing-agent.md
│       │   └── review-agent.md
│       ├── commands/
│       │   ├── pre-pr.md
│       │   └── feature-branch.md
│       └── hooks/hooks.json
├── templates/
│   ├── CLAUDE.md.template
│   ├── VISION.md.template
│   ├── LEARNINGS.md.template
│   └── GUIDANCE.md.template
├── scripts/
│   └── init-project.sh
└── README.md
```

---

## Usage Examples

### Generate Feature Spec
```
"Use planning-agent to generate spec for: user authentication"
```

### Implement Feature
```
"Use implementation-agent to implement docs/specs/feature-auth.md"
```

### Create Tests
```
"Use testing-agent to create tests for feature-auth"
```

### Review Code
```
"Use review-agent to review feature-auth implementation"
```

### Pre-PR Check
```
/pre-pr
```

---

## Contributing

1. Fork the repository
2. Create feature branch
3. Follow the workflow (use your own agents!)
4. Submit PR

---

## License

MIT

---

## Credits

Built with battle-tested patterns from production projects.
