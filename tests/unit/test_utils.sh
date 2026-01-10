#!/usr/bin/env bash
# Unit tests for src/utils.sh module

# Setup test environment
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$TEST_DIR")")"
SOURCE_FILE="$PROJECT_ROOT/src/utils.sh"

# Test counter
TESTS_RUN=0
TESTS_PASSED=0

# Source the module (need color vars first)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

source "$SOURCE_FILE" 2>/dev/null || true

# Test helper functions
assert_equals() {
    ((TESTS_RUN++))
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    if [ "$expected" = "$actual" ]; then
        echo "✓ $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo "✗ $test_name"
        echo "  Expected: $expected"
        echo "  Got: $actual"
        return 1
    fi
}

assert_true() {
    ((TESTS_RUN++))
    local test_name="$1"
    
    if [ $? -eq 0 ]; then
        echo "✓ $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo "✗ $test_name"
        return 1
    fi
}

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

# Run tests
echo "Testing utils.sh module..."
echo ""

# Test 1: Check if all required functions exist
assert_function_exists "print_color"
assert_function_exists "print_error"
assert_function_exists "print_warning"
assert_function_exists "print_info"
assert_function_exists "print_success"
assert_function_exists "check_dependencies"
assert_function_exists "is_video_file"
assert_function_exists "is_audio_file"
assert_function_exists "validate_input_file"
assert_function_exists "validate_output_path"
assert_function_exists "format_bytes"
assert_function_exists "format_duration"
assert_function_exists "confirm"

# Test 2: Test is_video_file function
is_video_file "test.mp4"
assert_true "is_video_file recognizes .mp4"

is_video_file "test.mkv"
assert_true "is_video_file recognizes .mkv"

is_video_file "test.avi"
assert_true "is_video_file recognizes .avi"

! is_video_file "test.txt"
assert_true "is_video_file rejects .txt"

# Test 3: Test is_audio_file function
is_audio_file "test.mp3"
assert_true "is_audio_file recognizes .mp3"

is_audio_file "test.flac"
assert_true "is_audio_file recognizes .flac"

! is_audio_file "test.mp4"
assert_true "is_audio_file rejects .mp4"

# Test 4: Test format_bytes function
result=$(format_bytes 1024)
assert_equals "1KB" "$result" "format_bytes converts 1024 bytes to KB"

result=$(format_bytes 1048576)
assert_equals "1MB" "$result" "format_bytes converts 1MB correctly"

result=$(format_bytes 1073741824)
assert_equals "1GB" "$result" "format_bytes converts 1GB correctly"

# Test 5: Test format_duration function
result=$(format_duration 60)
assert_equals "1m 0s" "$result" "format_duration converts 60 seconds"

result=$(format_duration 3661)
assert_equals "1h 1m 1s" "$result" "format_duration converts 3661 seconds"

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
