#!/usr/bin/env bash
# Vyn Test Runner
# Main test suite runner for all Vyn tests
# Version: 1.5.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test statistics
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Test directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
UNIT_TESTS_DIR="$SCRIPT_DIR/unit"
INTEGRATION_TESTS_DIR="$SCRIPT_DIR/integration"
FIXTURES_DIR="$SCRIPT_DIR/fixtures"

# Print functions
print_header() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  $1"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
}

print_test() {
    echo -e "${BLUE}▶${NC} Running: $1"
}

print_pass() {
    echo -e "${GREEN}✓${NC} PASS: $1"
    ((TESTS_PASSED++))
    ((TESTS_TOTAL++))
}

print_fail() {
    echo -e "${RED}✗${NC} FAIL: $1"
    echo -e "${RED}  └─${NC} $2"
    ((TESTS_FAILED++))
    ((TESTS_TOTAL++))
}

print_skip() {
    echo -e "${YELLOW}⊘${NC} SKIP: $1"
    ((TESTS_SKIPPED++))
}

# Test result summary
print_summary() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Test Summary${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "Total Tests:   $TESTS_TOTAL"
    echo -e "${GREEN}Passed:${NC}        $TESTS_PASSED"
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "${RED}Failed:${NC}        $TESTS_FAILED"
    fi
    if [ $TESTS_SKIPPED -gt 0 ]; then
        echo -e "${YELLOW}Skipped:${NC}       $TESTS_SKIPPED"
    fi
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "${RED}❌ TEST SUITE FAILED${NC}"
        return 1
    else
        echo -e "${GREEN}✅ ALL TESTS PASSED${NC}"
        return 0
    fi
}

# Run a single test file
run_test_file() {
    local test_file="$1"
    local test_name="$(basename "$test_file" .sh)"
    
    print_test "$test_name"
    
    if [ ! -f "$test_file" ]; then
        print_skip "$test_name - File not found"
        return
    fi
    
    if [ ! -x "$test_file" ]; then
        chmod +x "$test_file"
    fi
    
    # Run test and capture result
    local test_output
    local test_result
    
    test_output=$("$test_file" 2>&1)
    test_result=$?
    
    if [ $test_result -eq 0 ]; then
        print_pass "$test_name"
    else
        local error_msg=$(echo "$test_output" | tail -1)
        print_fail "$test_name" "$error_msg"
    fi
}

# Run all tests in a directory
run_tests_in_dir() {
    local test_dir="$1"
    local test_type="$2"
    
    if [ ! -d "$test_dir" ]; then
        print_skip "$test_type tests - Directory not found"
        return
    fi
    
    print_header "$test_type Tests"
    
    for test_file in "$test_dir"/test_*.sh; do
        if [ ! -e "$test_file" ]; then
            print_skip "$test_type tests - No test files found"
            return
        fi
        run_test_file "$test_file"
    done
}

# Setup test environment
setup_test_env() {
    # Create temporary directory for test outputs
    export VYN_TEST_TMP_DIR="/tmp/vyn_tests_$$"
    mkdir -p "$VYN_TEST_TMP_DIR"
    
    # Export project paths
    export VYN_PROJECT_ROOT="$PROJECT_ROOT"
    export VYN_BIN="$PROJECT_ROOT/bin/vyn"
    export VYN_SRC_DIR="$PROJECT_ROOT/src"
    
    # Create test fixtures if they don't exist
    mkdir -p "$FIXTURES_DIR"
}

# Cleanup test environment
cleanup_test_env() {
    # Remove temporary test directory
    if [ -d "$VYN_TEST_TMP_DIR" ]; then
        rm -rf "$VYN_TEST_TMP_DIR"
    fi
    
    # Remove test output logs
    rm -f /tmp/vyn_test_output.log
}

# Main test execution
main() {
    local run_unit=true
    local run_integration=true
    local test_pattern=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --unit)
                run_integration=false
                shift
                ;;
            --integration)
                run_unit=false
                shift
                ;;
            --pattern)
                test_pattern="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --unit          Run only unit tests"
                echo "  --integration   Run only integration tests"
                echo "  --pattern GLOB  Run tests matching pattern"
                echo "  -h, --help      Show this help message"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    print_header "🧪 Vyn Test Suite v1.5.0"
    
    # Setup
    setup_test_env
    
    # Run tests
    if [ "$run_unit" = true ]; then
        run_tests_in_dir "$UNIT_TESTS_DIR" "Unit"
    fi
    
    if [ "$run_integration" = true ]; then
        run_tests_in_dir "$INTEGRATION_TESTS_DIR" "Integration"
    fi
    
    # Print results
    print_summary
    local exit_code=$?
    
    # Cleanup
    cleanup_test_env
    
    exit $exit_code
}

# Run main function
main "$@"
