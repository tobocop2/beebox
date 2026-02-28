#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT=""
TOOLS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --tools)
            TOOLS="$2"
            shift 2
            ;;
        claude|opencode|codex|goose|gemini)
            AGENT="$1"
            shift
            break
            ;;
        *)
            shift
            ;;
    esac
done

install_tool() {
    local tool="$1"
    local config="$SCRIPT_DIR/tools/${tool}.yml"
    
    if [[ ! -f "$config" ]]; then
        return 0
    fi
    
    local install_cmd=$(grep "^install:" "$config" | sed 's/^install: *//')
    local verify_cmd=$(grep "^verify:" "$config" | sed 's/^verify: *//')
    
    if [[ -n "$verify_cmd" ]] && eval "$verify_cmd" >/dev/null 2>&1; then
        return 0
    fi
    
    eval "$install_cmd"
}

install_agent() {
    local agent="$1"
    local config="$SCRIPT_DIR/agents/${agent}.yml"
    
    if [[ ! -f "$config" ]]; then
        echo "Error: No config found for agent: $agent" >&2
        return 1
    fi
    
    local command=$(grep "^command:" "$config" | sed 's/^command: *//')
    local install_cmd=$(grep "^install:" "$config" | sed 's/^install: *//')
    
    if [[ -n "$install_cmd" ]]; then
        eval "$install_cmd"
    fi
    
    exec "$command" "$@"
}

if [[ -n "$TOOLS" ]]; then
    IFS=',' read -ra TOOL_ARRAY <<< "$TOOLS"
    for tool in "${TOOL_ARRAY[@]}"; do
        install_tool "$tool"
    done
fi

if [[ -n "$AGENT" ]]; then
    install_agent "$AGENT" "$@"
else
    exec "$@"
fi
