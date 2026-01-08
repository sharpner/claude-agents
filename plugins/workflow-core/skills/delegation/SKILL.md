---
name: delegation
description: Use when deciding whether to delegate work to subagents. Lists available agents with triggers and capabilities. Delegate aggressively.
---

# Subagent Delegation

**Principle: Delegate aggressively. Fresh subagents work better than overloaded context.**

## When to Delegate

| Situation | Action |
|-----------|--------|
| Complex code review | → Spawn code-reviewer agent |
| Security concerns | → Spawn security reviewer |
| UI/Mobile changes | → Spawn mobile/design reviewer |
| Large exploration (10+ files) | → Spawn Explore agent |
| Multiple independent tasks | → Spawn parallel agents |

## Available Subagents

### Review Agents

| Agent | Trigger | Focus |
|-------|---------|-------|
| `pr-review-toolkit:code-reviewer` | Complex PRs (>10 files) | Code quality, patterns |
| `pr-review-toolkit:silent-failure-hunter` | Error handling changes | Silent failures, catch blocks |
| `pr-review-toolkit:type-design-analyzer` | New types introduced | Type invariants, encapsulation |
| `loose-ends-hunter` | Refactoring, deletions | Dead code, orphaned imports |

### Utility Agents

| Agent | When |
|-------|------|
| `Explore` | Codebase exploration, pattern search |
| `Plan` | Implementation strategy, architecture |
| `gemini-explorer` | [OPTIONAL] Large-context analysis (1M tokens) |

### Custom Project Agents

Define in `.claude/agents/`:
- `security-reviewer.md` - OWASP Top 10 checks
- `mobile-reviewer.md` - Touch targets, responsive
- `design-reviewer.md` - Design system compliance

## Parallel Dispatch Pattern

When multiple independent issues exist:

```
# Launch ALL in same message block = PARALLEL
Task(subagent_type="code-reviewer", prompt="Review PR #123 for code quality")
Task(subagent_type="security-reviewer", prompt="Review PR #123 for security")
Task(subagent_type="mobile-reviewer", prompt="Review PR #123 for mobile")
```

**Rules for parallel dispatch:**
- One agent per independent problem domain
- No shared state between investigations
- Each agent gets complete context
- Review and integrate results

## Gemini vs Claude Subagents

| Feature | Gemini (via script) | Claude Subagent |
|---------|---------------------|-----------------|
| Cost | ~$0.02/review | ~$0.10/review |
| Context | 1M tokens | ~200K tokens |
| Speed | 30-40 sec | 60-90 sec |

**Use Gemini for:** Diff-based reviews (security, mobile, design)
**Use Claude for:** Complex analysis (loose-ends, user-journey)

## Gemini Scripts (Optional)

```bash
# PR Review with verdict
./scripts/gemini-review.sh 236

# Gemini impersonates Claude agent
./scripts/gemini-subagent-impersonation.sh 236 security-reviewer

# Research topic
./scripts/gemini-research.sh "performance optimization"
```

## Output Format

When delegating:

```
**Delegation:**
- Task: [what needs review]
- Agent: [which subagent]
- Reason: [why this agent]
- Dispatched: ✅ / Running in background
```
