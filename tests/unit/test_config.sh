#!/usr/bin/env bash
# Unit tests for src/config.sh module

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$TEST_DIR")")"
SOURCE_FILE="$PROJECT_ROOT/src/config.sh"

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

# Source utils first (config depends on it)
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

echo "Testing config.sh module..."
echo ""

# Test: Check if all required functions exist
assert_function_exists "load_config"
assert_function_exists "save_config"
assert_function_exists "load_vimeo_config"
assert_function_exists "config_module_info"

# Test: Module info function
if config_module_info | grep -q "Config"; then
    echo "✓ config_module_info returns valid info"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ config_module_info does not return valid info"
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
