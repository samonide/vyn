# Vyn Test Suite

Comprehensive testing framework for Vyn video converter.

## Structure

```
tests/
├── run_tests.sh          # Main test runner
├── unit/                 # Unit tests for modules
│   ├── test_utils.sh
│   ├── test_config.sh
│   ├── test_gpu.sh
│   └── test_presets.sh
├── integration/          # Integration tests
│   └── test_conversion.sh
└── fixtures/             # Test video files
```

## Running Tests

### Run All Tests
```bash
./tests/run_tests.sh
```

### Run Only Unit Tests
```bash
./tests/run_tests.sh --unit
```

### Run Only Integration Tests
```bash
./tests/run_tests.sh --integration
```

### Run Specific Test
```bash
./tests/unit/test_utils.sh
./tests/integration/test_conversion.sh
```

## Writing Tests

### Unit Test Template

```bash
#!/usr/bin/env bash
# Unit tests for src/module.sh

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$TEST_DIR")")"
SOURCE_FILE="$PROJECT_ROOT/src/module.sh"

TESTS_RUN=0
TESTS_PASSED=0

# Setup colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Source dependencies
source "$PROJECT_ROOT/src/utils.sh" 2>/dev/null || true
source "$SOURCE_FILE" 2>/dev/null || true

# Test function exists
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
echo "Testing module.sh..."
assert_function_exists "my_function"

# Print summary
echo ""
echo "Tests run: $TESTS_RUN"
echo "Tests passed: $TESTS_PASSED"

if [ $TESTS_PASSED -eq $TESTS_RUN ]; then
    exit 0
else
    exit 1
fi
```

## Test Coverage

Current modules with tests:
- ✅ `src/utils.sh` - Core utilities (25 tests)
- ✅ `src/config.sh` - Configuration (5 tests)
- ✅ `src/gpu.sh` - GPU acceleration (8 tests)
- ✅ `src/presets.sh` - Professional presets (8 tests)
- ✅ Integration - Basic workflow (6 tests)

Total: 52 tests

## Continuous Integration

Tests are run automatically on:
- Every commit
- Pull requests
- Release tags

## Test Fixtures

Place test video files in `tests/fixtures/` directory:
- `sample.mp4` - Small test video
- `sample.mkv` - MKV format test
- `sample.avi` - AVI format test

## Troubleshooting

### Tests Hang
Some tests may require user input. Make sure to run in non-interactive mode or mock user input.

### Module Not Found
Ensure you're running tests from the project root or tests have correct paths.

### Permission Denied
Make test files executable:
```bash
chmod +x tests/**/*.sh
```

## Future Enhancements

- [ ] Performance benchmarks
- [ ] Code coverage reports
- [ ] Automated fixture generation
- [ ] Mock FFmpeg for faster tests
- [ ] CI/CD integration (GitHub Actions)
