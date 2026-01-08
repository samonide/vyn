# Contributing to Vyn

Thank you for your interest in contributing to Vyn! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Plugin Development](#plugin-development)

---

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions.

### Our Standards

- Use welcoming and inclusive language
- Respect differing viewpoints and experiences
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards other community members

---

## Getting Started

### Prerequisites

- Bash 4.0 or higher
- FFmpeg (for testing video conversions)
- Git
- Basic shell scripting knowledge
- jq (for JSON processing)

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/vyn.git
cd vyn

# Add upstream remote
git remote add upstream https://github.com/samonide/vyn.git
```

---

## How to Contribute

### Reporting Bugs

Before creating bug reports, check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce**
- **Expected vs actual behavior**
- **System information** (OS, FFmpeg version, Bash version)
- **Sample files** (if applicable)
- **Error messages** (full output)

**Template:**

```markdown
## Bug Description
[Clear description of the issue]

## Steps to Reproduce
1. Run command: `vyn input.mkv output.mp4`
2. Select options: [...]
3. Observe error: [...]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## System Information
- OS: [e.g., Ubuntu 22.04]
- Bash: [bash --version]
- FFmpeg: [ffmpeg -version]
- Vyn: [vyn --version]

## Error Output
```
[Paste full error output]
```
```

### Suggesting Features

Feature requests are welcome! Include:

- **Use case**: Why is this feature needed?
- **Description**: What should it do?
- **Examples**: How would it work?
- **Alternatives**: Other approaches considered?

**Template:**

```markdown
## Feature Request

### Use Case
[Describe the problem this solves]

### Proposed Solution
[Describe your proposed feature]

### Examples
```bash
# How it would work
vyn --new-feature input.mkv output.mp4
```

### Alternatives Considered
[Other approaches you've thought about]

### Additional Context
[Any other relevant information]
```

### Contributing Code

1. **Find or create an issue** to discuss your changes
2. **Fork the repository** and create a branch
3. **Make your changes** following coding standards
4. **Test thoroughly** on multiple scenarios
5. **Commit with clear messages**
6. **Push and create a Pull Request**

---

## Development Setup

### Local Development

```bash
# Clone and setup
git clone https://github.com/YOUR_USERNAME/vyn.git
cd vyn

# Install dependencies
./install-vyn.sh

# Make changes to bin/vyn or src/ modules

# Test your changes
./bin/vyn --version
./bin/vyn test_input.mkv test_output.mp4

# Run tests (if available)
cd tests && ./run_tests.sh
```

### Project Structure

```
vyn/
├── bin/            # Main executable
│   └── vyn         # Core script
├── src/            # Source modules (future)
│   ├── core.sh
│   ├── presets.sh
│   ├── plugins.sh
│   └── utils.sh
├── plugins/        # Plugin repository
│   ├── README.md
│   ├── vimeo-uploader.sh
│   └── quality-analyzer.sh
├── docs/           # Documentation
│   ├── Usage.md
│   ├── Plugins.md
│   └── Contributing.md
├── config/         # Configuration templates
├── tests/          # Test suite
└── install-vyn.sh  # Installer
```

---

## Coding Standards

### Shell Scripting Guidelines

#### General Rules

- Use `bash` shebang: `#!/usr/bin/env bash`
- Enable strict mode: `set -euo pipefail`
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

#### Naming Conventions

```bash
# Variables: lowercase with underscores
local input_file="video.mkv"
declare -g USE_GPU=false

# Constants: uppercase with underscores
readonly VERSION="1.4.0"
readonly SCRIPT_NAME="vyn"

# Functions: lowercase with underscores
function convert_video() {
    # Function code
}

# Private functions: prefix with underscore
function _internal_helper() {
    # Internal function
}
```

#### Code Style

```bash
# Proper quoting
echo "${variable}"
local file_name="${1}"

# Conditional statements
if [[ -f "$file" ]]; then
    echo "File exists"
fi

# Loops
for file in *.mkv; do
    echo "Processing: $file"
done

# Functions
function process_video() {
    local input="${1}"
    local output="${2}"
    
    # Validate inputs
    [[ -f "$input" ]] || return 1
    
    # Process
    ffmpeg -i "$input" "$output"
    
    return 0
}
```

#### Error Handling

```bash
# Check command success
if ! ffmpeg -i "$input" "$output"; then
    print_error "Conversion failed"
    return 1
fi

# Use trap for cleanup
cleanup() {
    rm -f /tmp/vyn_temp_*
}
trap cleanup EXIT

# Validate inputs
[[ -f "$input" ]] || {
    print_error "Input file not found: $input"
    return 1
}
```

#### Documentation

```bash
# Function documentation
# Convert video file using FFmpeg
# Arguments:
#   $1 - Input file path
#   $2 - Output file path
#   $3 - (Optional) Quality CRF value
# Returns:
#   0 on success, 1 on failure
function convert_video() {
    local input="${1}"
    local output="${2}"
    local crf="${3:-23}"
    
    # Implementation
}
```

### Best Practices

#### Do's

✅ Use `[[ ]]` for conditionals (not `[ ]`)  
✅ Quote all variables: `"$var"`  
✅ Use `local` for function variables  
✅ Check command existence: `command -v ffmpeg`  
✅ Use `shellcheck` to lint code  
✅ Add error messages with context  
✅ Use functions for reusable code  
✅ Return meaningful exit codes  

#### Don'ts

❌ Don't use `eval`  
❌ Don't use backticks (use `$()`)  
❌ Don't ignore errors (`set -e`)  
❌ Don't use global variables unnecessarily  
❌ Don't hardcode paths (use variables)  
❌ Don't forget to quote variables  
❌ Don't use `ls` in scripts  
❌ Don't write functions longer than 50 lines  

---

## Testing

### Manual Testing

Test your changes with various scenarios:

```bash
# Basic conversion
./bin/vyn test.mkv test.mp4

# Different formats
./bin/vyn test.avi test.mp4
./bin/vyn test.mov test.webm

# Presets
./bin/vyn --preset cinema test.mkv test.mp4
./bin/vyn --preset web test.avi test.mp4

# Batch processing
./bin/vyn --batch test_videos/

# GPU acceleration
./bin/vyn --gpu test.mkv test.mp4

# Audio extraction
./bin/vyn --audio-only test.mp4 test.mp3

# Plugins
./bin/vyn --list-plugins
./bin/vyn --plugin quality-analyzer test.mp4

# Edge cases
./bin/vyn nonexistent.mkv output.mp4
./bin/vyn --invalid-flag test.mkv test.mp4
```

### Test Checklist

Before submitting a PR, verify:

- [ ] Basic conversions work
- [ ] All presets function correctly
- [ ] Batch processing works
- [ ] GPU acceleration (if available)
- [ ] Audio extraction works
- [ ] Plugins load and execute
- [ ] Error handling is proper
- [ ] Help text is accurate
- [ ] No regressions in existing features
- [ ] Code passes `shellcheck`
- [ ] Documentation is updated

### Running ShellCheck

```bash
# Install shellcheck
sudo pacman -S shellcheck    # Arch
sudo apt install shellcheck  # Ubuntu
brew install shellcheck      # macOS

# Check your changes
shellcheck bin/vyn
shellcheck plugins/*.sh
```

---

## Pull Request Process

### Before Submitting

1. **Update documentation** if adding features
2. **Test thoroughly** on your system
3. **Run shellcheck** on modified scripts
4. **Update CHANGELOG.md** with your changes
5. **Ensure no merge conflicts** with main branch

### Creating a Pull Request

1. **Create a feature branch**
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes**
   ```bash
   # Edit files
   vim bin/vyn
   
   # Test changes
   ./bin/vyn --version
   ```

3. **Commit with clear messages**
   ```bash
   git add bin/vyn
   git commit -m "feat: add new video filter feature
   
   - Added deinterlace filter support
   - Updated help text with filter examples
   - Added tests for filter functionality"
   ```

4. **Push to your fork**
   ```bash
   git push origin feature/my-new-feature
   ```

5. **Open Pull Request** on GitHub

### Commit Message Format

Use conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, no logic change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**

```bash
feat(gpu): add AMD GPU acceleration support

- Implemented VAAPI encoder detection
- Added AMD-specific encoder settings
- Updated documentation with AMD GPU info

Closes #42

---

fix(batch): correct file extension handling

Fixed bug where batch mode would skip files with
uppercase extensions like .MKV and .AVI.

Fixes #56

---

docs(readme): update installation instructions

- Added Windows WSL installation steps
- Updated dependency list
- Fixed broken links

---

refactor(core): split main script into modules

- Created src/core.sh for main logic
- Created src/utils.sh for helper functions
- Improved code organization and readability
```

### PR Template

```markdown
## Description
[Describe your changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring
- [ ] Other (describe):

## Testing
[Describe how you tested your changes]

## Checklist
- [ ] Code passes shellcheck
- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] No breaking changes (or documented)

## Related Issues
Closes #[issue number]
```

---

## Plugin Development

See [Plugins.md](Plugins.md) for detailed plugin development guide.

### Quick Start

```bash
# Create plugin
cat > plugins/my-plugin.sh << 'EOF'
#!/usr/bin/env bash

# Plugin: My Custom Plugin
# Description: What it does
# Author: Your Name

main() {
    local input="${1}"
    echo "Processing: $input"
    # Your plugin logic here
}

main "$@"
EOF

chmod +x plugins/my-plugin.sh

# Add to plugins.json
# Test plugin
./bin/vyn --plugin my-plugin test.mp4
```

---

## Recognition

Contributors will be recognized in:
- **CHANGELOG.md** - Feature/fix credits
- **README.md** - Acknowledgments section
- **GitHub Contributors** - Automatic recognition

---

## License

By contributing to Vyn, you agree that your contributions will be licensed under the [Unlicense](https://unlicense.org/) (Public Domain).

This means:
- Your code becomes public domain
- No copyright restrictions
- Anyone can use without attribution
- Maximum freedom for users

---

## Questions?

- **GitHub Issues**: For bugs and features
- **GitHub Discussions**: For questions and ideas
- **Pull Requests**: For code contributions

---

## Quick Reference

### Common Commands

```bash
# Setup
git clone https://github.com/YOUR_USERNAME/vyn.git
cd vyn
./install-vyn.sh

# Create branch
git checkout -b feature/my-feature

# Make changes and test
vim bin/vyn
./bin/vyn --version

# Check code quality
shellcheck bin/vyn

# Commit
git add .
git commit -m "feat: description"

# Push and PR
git push origin feature/my-feature
# Then create PR on GitHub
```

### Resources

- **Bash Guide**: https://mywiki.wooledge.org/BashGuide
- **ShellCheck**: https://www.shellcheck.net/
- **FFmpeg Docs**: https://ffmpeg.org/documentation.html
- **Conventional Commits**: https://www.conventionalcommits.org/

---

Thank you for contributing to Vyn! 🎬
