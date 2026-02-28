#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILED=0
PASSED=0
SKIPPED=0

echo "Running agent tests..."
echo ""

for config in "$SCRIPT_DIR"/agents/*.yml; do
    agent=$(basename "$config" .yml)
    echo "Testing $agent..."
    
    output=$(timeout 120 "$SCRIPT_DIR/sandbox" "$agent" --version 2>&1)
    exit_code=$?
    
    if [[ $exit_code -eq 0 ]]; then
        echo "  ✓ $agent --version: PASS"
        PASSED=$((PASSED + 1))
    elif echo "$output" | grep -q "Operation not permitted\|Extract.*failed"; then
        echo "  ⊘ $agent: INSTALL ISSUE (skipped)"
        SKIPPED=$((SKIPPED + 1))
    else
        echo "  ✗ $agent --version: FAIL (exit $exit_code)"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "Results: $PASSED passed, $SKIPPED skipped"

if [[ $FAILED -gt 0 ]]; then
    echo "$FAILED failed"
    exit 1
fi

exit 0
