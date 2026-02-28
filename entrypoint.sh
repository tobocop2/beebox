#!/usr/bin/env bash

export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

AGENT=""
TOOLS=""
REMAINING_ARGS=()

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
            REMAINING_ARGS+=("$1")
            shift
            ;;
    esac
done

while [[ $# -gt 0 ]]; do
    REMAINING_ARGS+=("$1")
    shift
done

install_tool() {
    local tool="$1"
    local config="/tools/${tool}.yml"
    
    if [[ ! -f "$config" ]]; then
        return 0
    fi
    
    local install_cmd=$(grep "^install:" "$config" 2>/dev/null | sed 's/^install: *//' | tr -d '"')
    
    if [[ -n "$install_cmd" ]]; then
        echo "Installing $tool..." >&2
        /bin/bash -c "export PATH=/usr/local/bin:/usr/bin:/bin:\$PATH && $install_cmd" 2>&1 || echo "Warning: $tool install failed" >&2
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

if [[ -n "$TOOLS" ]]; then
    IFS=',' read -ra TOOL_ARRAY <<< "$TOOLS"
    for tool in "${TOOL_ARRAY[@]}"; do
        install_tool "$tool"
    done
fi

if [[ -n "$AGENT" ]]; then
    install_agent "$AGENT" "${REMAINING_ARGS[@]}"
else
    exec "${REMAINING_ARGS[@]:-bash}"
fi
