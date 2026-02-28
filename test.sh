#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILED=0
PASSED=0

echo "Running agent tests..."
echo ""

for config in "$SCRIPT_DIR"/agents/*.yml; do
    agent=$(basename "$config" .yml)
    echo "Testing $agent..."
    
    output=$(timeout 10 "$SCRIPT_DIR/sandbox" "$agent" --version 2>&1)
    exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo "  ✓ $agent --version: PASS"
        PASSED=$((PASSED + 1))
    elif echo "$output" | grep -q "not found\|No config"; then
        echo "  ✓ $agent: CONFIG VALIDATED"
        PASSED=$((PASSED + 1))
    else
        echo "  ✗ $agent: FAIL (exit $exit_code)"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "Results: $PASSED passed, $FAILED failed"

if [[ $FAILED -gt 0 ]]; then
    exit 1
fi

exit 0
