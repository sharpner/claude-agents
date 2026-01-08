---
name: graphiti-memory
description: Use when starting a session, beginning a new task, or encountering errors. Graphiti is the knowledge graph memory system for storing patterns, fixes, preferences and learnings across all projects.
---

# Graphiti Memory System

**Knowledge graph memory for AI agents - stores patterns, fixes, and learnings.**

---

## ⚠️ REMINDER: Other Critical Skills

When this skill is invoked, also remember:

| Skill | When |
|-------|------|
| `quality-gate` | **EVERY response with code changes** — 7/7 Checklist! |
| `worktree` | **BEFORE any code changes** — Isolation check |
| `verification` | **BEFORE claiming completion** — Evidence required |

---

## GROUP ID CONVENTION

Use consistent group IDs per project:

| Group ID Pattern | Usage |
|------------------|-------|
| `proj_<projectname>` | Project-specific knowledge |
| `global_` | Cross-project patterns |

**NEVER use fragmented group_ids like `projectname_wip`, `projectname_fixes`!**

---

## SESSION START PROTOCOL

**Every session MUST start with context loading:**

```python
# Load project context at session start
context = mcp__graphiti__get_context(
    query="gotcha fix pattern architecture",
    group_ids=["proj_<projectname>", "global_"]
)
```

---

## WHEN TO SAVE MEMORY

### After Fixing a Bug
```python
mcp__graphiti__add_memory(
    name="FIX: [Brief description]",
    episode_body="Problem: [what was wrong]\nCause: [root cause]\nSolution: [how it was fixed]\nCode: [relevant snippet]",
    group_id="proj_<projectname>",
    source_description="fix",
    source="text"
)
```

### After Discovering a Gotcha
```python
mcp__graphiti__add_memory(
    name="GOTCHA: [Brief description]",
    episode_body="Context: [when this happens]\nProblem: [what goes wrong]\nSolution: [how to avoid/fix]",
    group_id="proj_<projectname>",
    source_description="gotcha",
    source="text"
)
```

### After Learning a Pattern
```python
mcp__graphiti__add_memory(
    name="PATTERN: [Brief description]",
    episode_body="Use case: [when to use]\nImplementation: [how to implement]\nExample: [code snippet]",
    group_id="proj_<projectname>",
    source_description="pattern",
    source="text"
)
```

### After Architecture Decision
```python
mcp__graphiti__add_memory(
    name="ARCH: [Brief description]",
    episode_body="Decision: [what was decided]\nRationale: [why]\nAlternatives considered: [what else]\nTradeoffs: [pros/cons]",
    group_id="proj_<projectname>",
    source_description="architecture",
    source="text"
)
```

---

## SOURCE DESCRIPTION TAGS

| Tag | When to Use |
|-----|-------------|
| `fix` | Bug fixes with solution |
| `gotcha` | Known pitfalls to avoid |
| `pattern` | Reusable code patterns |
| `architecture` | Design decisions |
| `preference` | User/project preferences |

---

## QUERYING MEMORY

### Get Formatted Context (Preferred)
```python
mcp__graphiti__get_context(
    query="[relevant keywords]",
    group_ids=["proj_<projectname>"]
)
```

### Search Specific Nodes
```python
mcp__graphiti__search_nodes(
    query="[search term]",
    group_ids=["proj_<projectname>"],
    max_nodes=10
)
```

### Search Facts/Relationships
```python
mcp__graphiti__search_memory_facts(
    query="[search term]",
    group_ids=["proj_<projectname>"],
    max_facts=10
)
```

### List Recent Episodes
```python
mcp__graphiti__get_episodes(
    group_ids=["proj_<projectname>"],
    max_episodes=10
)
```

---

## SUBAGENT CONTEXT LOADING

Each subagent should load relevant context at start:

| Subagent Type | Query Keywords |
|---------------|----------------|
| Code Reviewer | "patterns gotchas fixes code quality" |
| Security | "security vulnerabilities fixes auth" |
| Frontend | "UI patterns hooks components fixes" |
| Backend | "API database patterns fixes" |
| Testing | "test patterns CI gotchas coverage" |

---

## WEEKLY LEARNING EXTRACTION

Every week, extract learnings from Graphiti:

```
"Generate weekly learning report:
  - Top 5 problems encountered
  - Patterns (>= 3 occurrences)
  - Proposed documentation updates
  - Decisions that should be recorded"
```

---

*"Learn once, remember forever."*
