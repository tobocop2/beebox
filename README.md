# AI Agent Sandbox

A **lightweight** Docker-based sandbox for running AI coding agents securely.

## Why Lightweight?

- **No dependencies** - Just bash and Docker
- **Simple configuration** - Plain YAML files
- **Minimal overhead** - No orchestration, no extra services
- **Fast startup** - Plain container, not Kubernetes

## Quick Start

```bash
./sandbox claude
```

## Features

- Multi-agent support (Claude, OpenCode, Codex, Goose, Gemini)
- Tool integration (beads, floop, docker, git)
- Network isolation option
- Credential persistence
- Security hardening (capability dropping)
- Auto-build Docker image on first run

## Security

- Capabilities dropped by default
- Network isolation when internet: false
- Auto-cleanup on exit
- Credential storage in Docker volume only

## Configuration

All configuration is in plain YAML files:
- `config.yml` - Global settings
- `agents/*.yml` - Agent definitions
- `tools/*.yml` - Tool configurations

## Usage

```bash
./sandbox claude              # Current directory
./sandbox -d /path/to/project claude  # Specific directory
./sandbox claude "prompt"   # Single prompt
```

## Build Progress

This project uses beads for task tracking. Run `bd ready` to see what's ready to work on.

---

> Built with [opencode](https://opencode.ai) and [MiniMax M2.5 Free](https://www.minimax.io)