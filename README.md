# AI Agent Sandbox

A **Docker-based agent sandbox** for running AI coding agents in a secure, isolated environment.

This is a simple, configuration-file-driven way to run common AI agents inside Docker using a single command.

---

## Why This Exists

There are many tools that achieve similar things.

I wanted:

* Something simple
* Not GUI-based
* Easy to control via configuration files
* Built entirely using local AI agents

So I built this.

It’s mostly an excuse to throw a real-world problem at local models and see what they could produce.

I also wanted something I could fully inspect and control without extra services, orchestration layers, or hidden complexity.

---

## How It Works

* Agents run inside isolated Docker containers
* Everything is controlled via plain YAML configuration files
* Additional tools (like beads or floop) can be exposed to the sandbox through config
* No orchestration, no background services, no GUI

Just Docker and bash.

---

## Key Features

* **Secure Isolation**: All agents run in isolated Docker containers with restricted capabilities
* **Agent Support**: Run multiple AI agents (Claude, OpenCode, Codex, Goose, Gemini)
* **Tool Integration**: Built-in support for common development tools (git, docker, bash, etc.)
* **Network Control**: Option to disable internet access for enhanced security
* **Credential Management**: Persistent credential storage in Docker volumes
* **Zero Dependencies**: Works with just Docker and bash

---

## Quick Start

```bash
./sandbox claude
```

---

## Usage Examples

```bash
./sandbox claude                     # Run Claude in current directory
./sandbox -d /path/to/project claude # Run Claude in specific directory
./sandbox claude "prompt"            # Run Claude with single prompt
```

---

## Configuration

All configuration is in plain YAML files:

* `config.yml` – Global settings
* `agents/*.yml` – Agent definitions
* `tools/*.yml` – Tool configurations

The configuration files expose ways to add additional tools used by the AI agent into the sandbox, like beads or floop, without adding complexity.

You can control:

* Which agents are available
* Whether internet access is enabled
* What tools are mounted into the container
* How credentials are persisted

Everything is explicit and file-driven.

---

## Security

* Capabilities dropped by default
* Network isolation when `internet: false`
* Auto-cleanup on exit
* Credential storage in Docker volume only

Security depends on configuration.
If you mount sensitive host paths or privileged sockets, you reduce isolation.

This is meant to reduce risk and contain mistakes — not eliminate all possible attack surfaces.

---

## Why Lightweight?

* No GUI
* No orchestration
* No extra services
* No hidden layers
* Fast startup
* Fully inspectable

Plain container.
Plain config.
Single command.

> Entirely built with [OpenCode](https://opencode.ai), [MiniMax M2.5 Free](https://www.minimax.io), [Ollama](https://ollama.com), and [Qwen](https://qwenlm.github.io)

