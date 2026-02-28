#!/usr/bin/env bash

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
    local config="/tools/${tool}.yml"
    
    if [[ ! -f "$config" ]]; then
        return 0
    fi
    
    local install_cmd=$(grep "^install:" "$config" 2>/dev/null | sed 's/^install: *//')
    local verify_cmd=$(grep "^verify:" "$config" 2>/dev/null | sed 's/^verify: *//')
    
    if [[ -n "$verify_cmd" ]]; then
        eval "$verify_cmd" >/dev/null 2>&1 && return 0
    fi
    
    if [[ -n "$install_cmd" ]]; then
        eval "$install_cmd" 2>/dev/null || true
    fi
}

install_agent() {
    local agent="$1"
    local config="/agents/${agent}.yml"
    
    if [[ ! -f "$config" ]]; then
        echo "Error: No config found for agent: $agent" >&2
        exit 1
    fi
    
    local command=$(grep "^command:" "$config" 2>/dev/null | sed 's/^command: *//')
    local install_cmd=$(grep "^install:" "$config" 2>/dev/null | sed 's/^install: *//')
    
    if [[ -n "$install_cmd" ]]; then
        eval "$install_cmd" 2>/dev/null || true
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
