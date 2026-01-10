#!/usr/bin/env bash
# Integration test for basic conversion workflow

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$TEST_DIR")")"
VYN_BIN="$PROJECT_ROOT/bin/vyn"

TESTS_RUN=0
TESTS_PASSED=0

echo "Testing basic conversion workflow..."
echo ""

# Test 1: Check if vyn binary exists and is executable
((TESTS_RUN++))
if [ -x "$VYN_BIN" ]; then
    echo "✓ Vyn binary exists and is executable"
    ((TESTS_PASSED++))
else
    echo "✗ Vyn binary not found or not executable"
    exit 1
fi

# Test 2: Test --version flag
((TESTS_RUN++))
if "$VYN_BIN" --version > /dev/null 2>&1; then
    echo "✓ --version flag works"
    ((TESTS_PASSED++))
else
    echo "✗ --version flag failed"
fi

# Test 3: Test --help flag
((TESTS_RUN++))
if "$VYN_BIN" --help > /dev/null 2>&1; then
    echo "✓ --help flag works"
    ((TESTS_PASSED++))
else
    echo "✗ --help flag failed"
fi

# Test 4: Test --list-plugins flag
((TESTS_RUN++))
if "$VYN_BIN" --list-plugins > /dev/null 2>&1; then
    echo "✓ --list-plugins flag works"
    ((TESTS_PASSED++))
else
    echo "✗ --list-plugins flag failed"
fi

# Test 5: Test --show-analytics flag
((TESTS_RUN++))
if "$VYN_BIN" --show-analytics > /dev/null 2>&1; then
    echo "✓ --show-analytics flag works"
    ((TESTS_PASSED++))
else
    echo "✗ --show-analytics flag failed"
fi

# Test 6: Test module loading
((TESTS_RUN++))
if bash -c "source '$PROJECT_ROOT/src/utils.sh'; source '$PROJECT_ROOT/src/config.sh'; source '$PROJECT_ROOT/src/gpu.sh'" 2>/dev/null; then
    echo "✓ All modules load without errors"
    ((TESTS_PASSED++))
else
    echo "✗ Module loading failed"
fi

# Print summary
echo ""
echo "=========================="
echo "Tests run: $TESTS_RUN"
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $((TESTS_RUN - TESTS_PASSED))"
echo "=========================="

if [ $TESTS_PASSED -eq $TESTS_RUN ]; then
    echo "✅ All integration tests passed!"
    exit 0
else
    echo "❌ Some integration tests failed"
    exit 1
fi
