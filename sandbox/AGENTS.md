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
git worktree add ../beebox-feature feature-branch

# Work on it
cd ../beebox-feature
./sandbox claude

# When done, merge and cleanup
git checkout master
git merge feature-branch
git worktree remove ../beebox-feature
```

## Security

- Capabilities dropped by default
- Network isolation when internet: false
- Auto-cleanup on exit
- Credential persistence in Docker volume

## Build Progress

Use `bd ready` to see what's ready to work on, or `bd list` to see all tasks.