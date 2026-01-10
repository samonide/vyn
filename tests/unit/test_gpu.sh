#!/usr/bin/env bash
# Unit tests for src/gpu.sh module

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$TEST_DIR")")"
SOURCE_FILE="$PROJECT_ROOT/src/gpu.sh"

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

echo "Testing gpu.sh module..."
echo ""

# Test: Check if all required functions exist
assert_function_exists "detect_gpu_acceleration"
assert_function_exists "get_gpu_encoder"
assert_function_exists "gpu_module_info"

# Test: get_gpu_encoder function with different GPU types
GPU_TYPE="nvenc"
result=$(get_gpu_encoder)
if [ "$result" = "h264_nvenc" ]; then
    echo "✓ get_gpu_encoder returns correct encoder for NVENC"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ get_gpu_encoder failed for NVENC (got: $result)"
    ((TESTS_RUN++))
fi

GPU_TYPE="vaapi"
result=$(get_gpu_encoder)
if [ "$result" = "h264_vaapi" ]; then
    echo "✓ get_gpu_encoder returns correct encoder for VAAPI"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ get_gpu_encoder failed for VAAPI (got: $result)"
    ((TESTS_RUN++))
fi

GPU_TYPE="qsv"
result=$(get_gpu_encoder)
if [ "$result" = "h264_qsv" ]; then
    echo "✓ get_gpu_encoder returns correct encoder for QSV"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ get_gpu_encoder failed for QSV (got: $result)"
    ((TESTS_RUN++))
fi

GPU_TYPE=""
result=$(get_gpu_encoder)
if [ "$result" = "libx264" ]; then
    echo "✓ get_gpu_encoder returns fallback encoder"
    ((TESTS_RUN++))
    ((TESTS_PASSED++))
else
    echo "✗ get_gpu_encoder fallback failed (got: $result)"
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
