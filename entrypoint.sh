#!/usr/bin/env bash

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

AGENT=""
REMAINING_ARGS=()

# Dynamically extract agent names from agents directory
AGENT_NAMES=""
for agent_file in /agents/*.yml; do
    agent_name=$(basename "$agent_file" .yml)
    if [[ -n "$AGENT_NAMES" ]]; then
        AGENT_NAMES="$AGENT_NAMES|$agent_name"
    else
        AGENT_NAMES="$agent_name"
    fi
done

while [[ $# -gt 0 ]]; do
    case "$1" in
        $AGENT_NAMES)
            AGENT="$1"
            shift
            break
            ;;
        *)
            REMAINING_ARGS+=("$1")
            shift
            ;;
    esac
done

while [[ $# -gt 0 ]]; do
    REMAINING_ARGS+=("$1")
    shift
done

install_agent() {
    local agent="$1"
    local config="/agents/${agent}.yml"
    
    if [[ ! -f "$config" ]]; then
        echo "Error: No config found for agent: $agent" >&2
        exit 1
    fi
    
    local command=$(grep "^command:" "$config" 2>/dev/null | sed 's/^command: *//')
    local install_cmd=$(grep "^install:" "$config" 2>/dev/null | sed 's/^install: *//' | tr -d '"')
    
    if command -v "$command" >/dev/null 2>&1; then
        exec "$command" "${REMAINING_ARGS[@]}"
    fi
    
    if [[ -n "$install_cmd" ]]; then
        echo "Installing $agent..." >&2
        if /bin/bash -c "export PATH=/usr/local/bin:/usr/bin:/bin:\$PATH && $install_cmd" 2>&1; then
            exec "$command" "${REMAINING_ARGS[@]}"
        else
            echo "Error: Failed to install $agent" >&2
            echo "You may need to authenticate first. Try running the agent interactively." >&2
            exit 1
        fi
    else
        echo "Error: $agent not installed and no install command found" >&2
        exit 1
    fi
}


if [[ -n "$AGENT" ]]; then
    install_agent "$AGENT" "${REMAINING_ARGS[@]}"
else
    exec "${REMAINING_ARGS[@]:-bash}"
fi
