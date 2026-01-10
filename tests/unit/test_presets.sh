#!/usr/bin/env bash
# Unit tests for src/presets.sh module

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$TEST_DIR")")"
SOURCE_FILE="$PROJECT_ROOT/src/presets.sh"

TESTS_RUN=0
TESTS_PASSED=0

# Setup colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

source "$PROJECT_ROOT/src/utils.sh" 2>/dev/null || true
source "$SOURCE_FILE" 2>/dev/null || true

assert_function_exists() {
    ((TESTS_RUN++))
    local func_name="$1"
    
    if declare -f "$func_name" > /dev/null; then
        echo "✓ Function $func_name exists"
        ((TESTS_PASSED++))
        return 0
    else
        echo "✗ Function $func_name does not exist"
        return 1
    fi
}

echo "Testing presets.sh module..."
echo ""

# Test: Check if all required functions exist
assert_function_exists "load_professional_presets"
assert_function_exists "setup_professional_presets"
assert_function_exists "setup_custom_professional_preset"
assert_function_exists "apply_preset"
assert_function_exists "presets_module_info"

# Test: apply_preset function
apply_preset "broadcast" > /dev/null 2>&1
if [ "$CRF_VALUE" = "18" ] && [ "$PROFESSIONAL_PRESET" = "broadcast" ]; then
    echo "✓ apply_preset correctly sets broadcast preset"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ apply_preset failed for broadcast"
    ((TESTS_RUN++))
fi

apply_preset "cinema" > /dev/null 2>&1
if [ "$CRF_VALUE" = "16" ] && [ "$PROFESSIONAL_PRESET" = "cinema" ]; then
    echo "✓ apply_preset correctly sets cinema preset"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ apply_preset failed for cinema"
    ((TESTS_RUN++))
fi

apply_preset "web" > /dev/null 2>&1
if [ "$CRF_VALUE" = "23" ] && [ "$PROFESSIONAL_PRESET" = "web_streaming" ]; then
    echo "✓ apply_preset correctly sets web preset"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ apply_preset failed for web"
    ((TESTS_RUN++))
fi

apply_preset "mobile" > /dev/null 2>&1
if [ "$CRF_VALUE" = "28" ] && [ "$PROFESSIONAL_PRESET" = "mobile" ]; then
    echo "✓ apply_preset correctly sets mobile preset"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ apply_preset failed for mobile"
    ((TESTS_RUN++))
fi

# Print summary
echo ""
echo "=========================="
echo "Tests run: $TESTS_RUN"
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $((TESTS_RUN - TESTS_PASSED))"
echo "=========================="

if [ $TESTS_PASSED -eq $TESTS_RUN ]; then
    echo "✅ All tests passed!"
    exit 0
else
    echo "❌ Some tests failed"
    exit 1
fi
