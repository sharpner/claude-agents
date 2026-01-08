---
description: Setup Gemini integration - API key, CLI check, and scripts
---

# Gemini Setup

Setting up Gemini integration for AI-assisted code reviews.

## Step 1: Check Gemini CLI

```bash
which gemini || echo "NOT INSTALLED"
```

If not installed, inform user:
- Install: `npm install -g @google/generative-ai-cli`
- Or: https://github.com/google-gemini/gemini-cli

## Step 2: Check API Key

```bash
echo "${GEMINI_API_KEY:-NOT_SET}"
```

If NOT_SET, ask user:

**Frage den User:**
"Hast du einen Gemini API Key?

Get one from: https://aistudio.google.com/apikey

Bitte gib deinen Gemini API Key ein (oder 'skip' zum Überspringen):"

## Step 3: Save API Key

When user provides key, add to shell config:

```bash
# Detect shell config
SHELL_CONFIG="$HOME/.zshrc"
[ ! -f "$SHELL_CONFIG" ] && SHELL_CONFIG="$HOME/.bashrc"
[ ! -f "$SHELL_CONFIG" ] && SHELL_CONFIG="$HOME/.bash_profile"

# Add to config
echo "" >> "$SHELL_CONFIG"
echo "# Gemini API Key (added by claude-agents)" >> "$SHELL_CONFIG"
echo "export GEMINI_API_KEY=\"<USER_PROVIDED_KEY>\"" >> "$SHELL_CONFIG"

echo "✅ Added to $SHELL_CONFIG"
echo "Run: source $SHELL_CONFIG"
```

## Step 4: Copy Scripts

Copy Gemini scripts to project:

```bash
mkdir -p scripts

# Get scripts from plugin or GitHub
PLUGIN_DIR="$(find ~/.claude/plugins -name 'gemini-review.sh' -path '*workflow-core*' | head -1 | xargs dirname)"

if [ -d "$PLUGIN_DIR" ]; then
    cp "$PLUGIN_DIR/gemini-review.sh" scripts/
    cp "$PLUGIN_DIR/gemini-subagent-impersonation.sh" scripts/
    cp "$PLUGIN_DIR/gemini-research.sh" scripts/
    chmod +x scripts/gemini-*.sh
    echo "✅ Scripts copied to scripts/"
else
    echo "Downloading scripts from GitHub..."
    curl -sL https://raw.githubusercontent.com/sharpner/claude-agents/main/plugins/workflow-core/scripts/gemini-review.sh -o scripts/gemini-review.sh
    curl -sL https://raw.githubusercontent.com/sharpner/claude-agents/main/plugins/workflow-core/scripts/gemini-subagent-impersonation.sh -o scripts/gemini-subagent-impersonation.sh
    curl -sL https://raw.githubusercontent.com/sharpner/claude-agents/main/plugins/workflow-core/scripts/gemini-research.sh -o scripts/gemini-research.sh
    chmod +x scripts/gemini-*.sh
    echo "✅ Scripts downloaded to scripts/"
fi
```

## Step 5: Summary

Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ Gemini Setup Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Gemini CLI: [installed/not installed]
API Key: [configured/not configured]
Scripts: scripts/gemini-*.sh

Usage:
  ./scripts/gemini-review.sh <pr-number>
  ./scripts/gemini-subagent-impersonation.sh <pr> <agent>
  ./scripts/gemini-research.sh "<topic>"

Don't forget: source ~/.zshrc (if API key was added)
```

## Execution Notes

- Use AskUserQuestion tool to get the API key from user
- Run bash commands to check/setup environment
- Be helpful if things are missing, don't just fail
