# AGENTS.md - AI Agent Sandbox

This project uses [beads](https://github.com/steveyegge/beads) for task tracking
and [floop](https://github.com/nvandessel/floop) for behavior learning.

## Setup

Run this once to initialize tools:
```bash
bd init --quiet
floop init
```

## Available Agents

- claude - Anthropic Claude
- opencode - OpenCode
- codex - OpenAI Codex  
- goose - Goose

## Usage

```bash
./sandbox claude              # Use current directory
./sandbox -d /path/to/project claude  # Use specific directory
./sandbox claude "prompt"   # Single prompt
```

## Tools

- **beads** (bd) - Task tracking
- **floop** - Behavior corrections
- **docker** - Docker integration
- **git** - Git integration

## Git Worktrees

This project uses git worktrees for working on features without disrupting the main codebase:

```bash
# Create a worktree for a new feature
git worktree add ../beebox-feature -b feature-branch

# Work on it
cd ../beebox-feature
./sandbox claude

# When done, merge and cleanup
git checkout main
git merge feature-branch
git worktree remove ../beebox-feature
git branch -d feature-branch
```

## Security

- Capabilities dropped by default
- Network isolation when internet: false
- Auto-cleanup on exit
- Credential persistence in Docker volume

## Testing

Run the test suite to validate all agents:
```bash
./test.sh
```

This tests that each agent config is valid and can be invoked.

## Build Progress

Use `bd ready` to see what's ready to work on, or `bd list` to see all tasks.

---

## Beads Integration

This project uses **bd (beads)** for issue tracking. Run `bd onboard` to get started.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git
```

### Important Rules

- ✅ Use bd for ALL task tracking
- ✅ Always use `--json` flag for programmatic use
- ✅ Link discovered work with `discovered-from` dependencies
- ✅ Check `bd ready` before asking "what should I work on?"
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems