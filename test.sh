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
    
    if [[ -f "$config" ]] && \
       grep -q "^name:" "$config" && \
       grep -q "^command:" "$config" && \
       grep -q "^install:" "$config" && \
       grep -q "^tools:" "$config"; then
        echo "  ✓ $agent: CONFIG VALID"
        PASSED=$((PASSED + 1))
    else
        echo "  ✗ $agent: CONFIG INVALID"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "Results: $PASSED passed"

if [[ $FAILED -gt 0 ]]; then
    echo "$FAILED failed"
    exit 1
fi

exit 0
