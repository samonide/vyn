# 🚀 Quick Start Development Guide

**Jump right into developing Vyn!**

---

## ⚡ Immediate Action Plan

### This Week: Modularization Sprint

#### Day 1-2: Extract Utilities (Start Here!)

```bash
# 1. Create first module
cat > src/utils.sh << 'EOF'
#!/usr/bin/env bash
# Vyn Utilities Module
# Common helper functions used across Vyn

# Color output functions
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# File validation
is_video_file() {
    local file="${1}"
    local ext="${file##*.}"
    case "${ext,,}" in
        mp4|mkv|avi|mov|webm|flv|wmv|m4v|3gp|ts|vob|mpg|mpeg)
            return 0 ;;
        *)
            return 1 ;;
    esac
}

# More utility functions...
EOF

# 2. Update bin/vyn to source it
# Add near the top of bin/vyn:
# source "${SCRIPT_DIR}/../src/utils.sh"

# 3. Test
./bin/vyn --version
```

#### Day 3-4: Extract Presets

```bash
# Create presets module
cat > src/presets.sh << 'EOF'
#!/usr/bin/env bash
# Vyn Professional Presets Module

setup_broadcast_preset() {
    CRF_VALUE=18
    # ... preset logic
}

setup_cinema_preset() {
    CRF_VALUE=16
    # ... preset logic
}

# All other presets...
EOF

# Update bin/vyn to source presets
# Test all presets still work
```

#### Day 5-7: Testing Framework

```bash
# Create test runner
cat > tests/run_tests.sh << 'EOF'
#!/usr/bin/env bash
# Vyn Test Runner

run_test() {
    local test_name="$1"
    echo "Running: $test_name"
    if bash "$test_name"; then
        echo "✓ PASS: $test_name"
        return 0
    else
        echo "✗ FAIL: $test_name"
        return 1
    fi
}

# Run all tests
for test in tests/unit/*.sh; do
    run_test "$test"
done
EOF

chmod +x tests/run_tests.sh

# Create first test
cat > tests/unit/test_utils.sh << 'EOF'
#!/usr/bin/env bash
source "src/utils.sh"

# Test video file detection
test_is_video_file() {
    is_video_file "test.mp4" && echo "PASS" || echo "FAIL"
    ! is_video_file "test.txt" && echo "PASS" || echo "FAIL"
}

test_is_video_file
EOF
```

---

## 📋 Development Checklist

### Phase 1: Modularization (Week 1-2)

**Week 1:**
- [ ] Extract `src/utils.sh` with helper functions
- [ ] Extract `src/config.sh` with configuration management
- [ ] Update `bin/vyn` to source modules
- [ ] Test: `./bin/vyn --help` works
- [ ] Test: `./bin/vyn test.mkv test.mp4` works
- [ ] Commit: "feat: extract utils and config modules"

**Week 2:**
- [ ] Extract `src/presets.sh` with all presets
- [ ] Extract `src/gpu.sh` with GPU detection
- [ ] Extract `src/plugins.sh` with plugin system
- [ ] Test: All presets work
- [ ] Test: GPU detection works
- [ ] Commit: "feat: complete core modularization"

### Phase 2: Testing (Week 3)

- [ ] Create `tests/run_tests.sh` framework
- [ ] Write tests for utils module
- [ ] Write tests for presets module
- [ ] Write integration test for conversion
- [ ] Document testing in Contributing.md
- [ ] Commit: "test: add test suite framework"

### Phase 3: Documentation (Week 4)

- [ ] Update Architecture.md with module info
- [ ] Create module documentation
- [ ] Add development examples
- [ ] Update Contributing.md
- [ ] Commit: "docs: update for modular architecture"

---

## 🎯 Priority Order (What to Build Next)

### Must-Have (Do First)
1. **Modularization** - Split the monolithic script
2. **Testing** - Create test framework
3. **Bug Fixes** - Fix any reported issues

### Should-Have (Do Soon)
4. **Subtitle Support** - Extract/embed subtitles
5. **YouTube Plugin** - Most requested feature
6. **Advanced Filters** - More video processing options

### Nice-to-Have (Do Later)
7. **Thumbnail Generator Plugin**
8. **Metadata Editor**
9. **Web Interface** (Optional)

---

## 🛠️ Development Commands

```bash
# Setup development environment
cd /home/samonide/CODE/vyn
git checkout -b feature/modularization

# Create a module
vim src/utils.sh

# Test your changes
./bin/vyn --version
./bin/vyn test.mkv test.mp4

# Run tests
./tests/run_tests.sh

# Check code quality
shellcheck bin/vyn src/*.sh

# Commit
git add src/utils.sh
git commit -m "feat: extract utils module"

# Push and create PR
git push origin feature/modularization
```

---

## 📊 Success Metrics

### After Week 1:
- ✅ 2-3 modules extracted
- ✅ All existing features work
- ✅ No regressions
- ✅ Code is more organized

### After Week 2:
- ✅ All major modules extracted
- ✅ bin/vyn is < 1000 lines
- ✅ Each module is < 500 lines
- ✅ Clear separation of concerns

### After Week 3:
- ✅ Test framework working
- ✅ 10+ tests written
- ✅ Tests passing
- ✅ CI/CD setup (optional)

---

## 🎓 Quick References

### Module Structure Template

```bash
#!/usr/bin/env bash
# Vyn [Module Name] Module
# Description of what this module does

# Set script directory
readonly MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Module-specific variables
declare -g MODULE_VARIABLE=""

# Public functions
function_name() {
    local param="${1}"
    # Function logic
    return 0
}

# Private functions (prefix with _)
_internal_function() {
    # Internal logic
}
```

### Test Template

```bash
#!/usr/bin/env bash
# Test: [Feature Name]

source "src/module.sh"

test_feature() {
    local result=$(function_to_test "input")
    [[ "$result" == "expected" ]] && echo "PASS" || echo "FAIL"
}

test_feature
```

---

## 🚨 Common Pitfalls to Avoid

1. **Breaking Changes** ❌
   - Always test existing functionality
   - Maintain backward compatibility
   - Don't change command-line interface

2. **Large Commits** ❌
   - Keep commits focused
   - One feature per PR
   - Make it easy to review

3. **Missing Tests** ❌
   - Write tests for new code
   - Test edge cases
   - Test error conditions

4. **Poor Documentation** ❌
   - Document new functions
   - Update Usage.md
   - Add examples

---

## 💡 Pro Tips

### Speed Up Development

```bash
# Create aliases
alias vyn-dev='cd /home/samonide/CODE/vyn'
alias vyn-test='./tests/run_tests.sh'
alias vyn-check='shellcheck bin/vyn src/*.sh'

# Use these in ~/.bashrc or ~/.zshrc
```

### Test While Developing

```bash
# Watch mode (requires entr)
ls src/*.sh | entr -c ./tests/run_tests.sh

# Quick test one feature
./bin/vyn --preset cinema test.mkv test.mp4

# Test batch processing
./bin/vyn --batch test-videos/
```

### Debug Mode

```bash
# Add to bin/vyn
if [[ "${DEBUG}" == "true" ]]; then
    set -x  # Print commands
fi

# Use it
DEBUG=true ./bin/vyn input.mkv output.mp4
```

---

## 📞 Need Help?

### Resources
- **Full Roadmap**: [ROADMAP.md](ROADMAP.md)
- **Architecture**: [docs/Architecture.md](docs/Architecture.md)
- **Contributing**: [docs/Contributing.md](docs/Contributing.md)

### Community
- **GitHub Issues**: Report bugs
- **GitHub Discussions**: Ask questions
- **Pull Requests**: Submit code

---

## 🎉 Your First Contribution

### 5-Minute Quick Win

```bash
# 1. Find a simple issue
# Look for "good first issue" label on GitHub

# 2. Create branch
git checkout -b fix/simple-bug

# 3. Make the change
vim bin/vyn

# 4. Test
./bin/vyn --version

# 5. Commit
git commit -m "fix: simple bug description"

# 6. Push
git push origin fix/simple-bug

# 7. Create PR on GitHub
```

---

**Ready to build? Start with Week 1, Day 1 above! 🚀**

*See [ROADMAP.md](ROADMAP.md) for the complete development plan.*
