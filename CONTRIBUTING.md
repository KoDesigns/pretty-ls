# Contributing to Pretty-ls

Thank you for your interest in contributing to Pretty-ls! We welcome contributions from everyone, whether you're fixing a bug, adding a feature, improving documentation, or helping with testing.

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct. Please be respectful and constructive in all interactions.

## 🚀 Getting Started

### Prerequisites

- Git
- Basic knowledge of shell scripting (Bash/Zsh) or PowerShell
- A terminal emulator that supports emoji and colors

### Setting Up Your Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork:**
   ```bash
   git clone https://github.com/KoDesigns/pretty-ls.git
   cd pretty-ls
   ```
3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/originalowner/pretty-ls.git
   ```
4. **Create a new branch** for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📝 How to Contribute

### Reporting Bugs

Before creating a bug report, please check the existing issues to avoid duplicates.

When filing a bug report, include:
- **Operating System**: macOS, Linux distribution, or Windows version
- **Shell**: Bash, Zsh, PowerShell version
- **Pretty-ls version**: Run `pls --version`
- **Steps to reproduce** the issue
- **Expected behavior**
- **Actual behavior**
- **Screenshots** if applicable

### Suggesting Features

We welcome feature suggestions! Please:
- Check existing issues and discussions first
- Clearly describe the feature and its benefits
- Consider how it fits with the project's goals
- Provide examples of how it would work

### Contributing Code

#### Types of Contributions

- **Bug fixes**: Fix existing issues
- **New features**: Add functionality that enhances the tool
- **Performance improvements**: Make the tool faster or more efficient
- **Documentation**: Improve README, comments, or add examples
- **Platform support**: Extend compatibility to new platforms/shells

#### Development Guidelines

1. **Follow existing code style**:
   - Use consistent indentation (2 spaces for shell scripts)
   - Add comments for complex logic
   - Use meaningful variable names
   - Follow shell scripting best practices

2. **Cross-platform compatibility**:
   - Test on multiple platforms when possible
   - Use portable commands and syntax
   - Handle platform differences gracefully

3. **Error handling**:
   - Check for command failures
   - Provide helpful error messages
   - Fail gracefully when possible

4. **Performance**:
   - Keep the tool fast and lightweight
   - Avoid unnecessary external dependencies
   - Test with large directories

#### Code Style Guidelines

**Shell Scripts (Bash/Zsh):**
```bash
# Use readonly for constants
readonly CONSTANT_VALUE="value"

# Use local variables in functions
function my_function() {
    local variable="value"
    # function body
}

# Check command success
if command -v git >/dev/null 2>&1; then
    echo "Git is available"
fi

# Use proper error handling
if [[ ! -f "$file" ]]; then
    echo "Error: File not found" >&2
    return 1
fi
```

**PowerShell:**
```powershell
# Use approved verbs for functions
function Get-Something {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    # Use proper error handling
    try {
        # code here
    }
    catch {
        Write-Error "Error: $($_.Exception.Message)"
        return
    }
}

# Use consistent formatting
$Variable = "Value"
```

### Testing Your Changes

Before submitting a pull request:

1. **Test basic functionality**:
   ```bash
   # Test in current directory
   ./scripts/pls.sh
   
   # Test with different directories
   ./scripts/pls.sh /tmp
   ./scripts/pls.sh ~/Documents
   
   # Test help and version
   ./scripts/pls.sh --help
   ./scripts/pls.sh --version
   ```

2. **Test edge cases**:
   - Empty directories
   - Directories with many files
   - Files with special characters in names
   - Very long filenames
   - Symbolic links (Unix/Linux)

3. **Test on your platform**:
   - Verify colors display correctly
   - Check emoji rendering
   - Test with different terminal emulators

4. **Test installation** (if you modified installers):
   ```bash
   # Test the installer
   ./install/install-macos.sh  # or appropriate installer
   
   # Verify installation works
   pls --version
   ```

### Submitting Changes

1. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add feature: brief description"
   ```

2. **Write good commit messages**:
   - Use the imperative mood ("Add feature" not "Added feature")
   - Keep the first line under 50 characters
   - Add a detailed description if needed

3. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Create a Pull Request**:
   - Use a clear title and description
   - Reference any related issues
   - Include screenshots for UI changes
   - List what you tested

#### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Other (please describe)

## Testing
- [ ] Tested on macOS
- [ ] Tested on Linux
- [ ] Tested on Windows
- [ ] Tested with Bash
- [ ] Tested with Zsh
- [ ] Tested with PowerShell

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated if needed
- [ ] No breaking changes (or clearly documented)
```

## 📚 Documentation

### Updating Documentation

- Keep README.md up to date with new features
- Update help text in scripts when adding options
- Add examples for new functionality
- Update installation instructions if needed

### Writing Style

- Use clear, concise language
- Include code examples
- Use emoji sparingly but effectively
- Follow the existing tone and style

## 🔄 Release Process

Releases are managed by maintainers. The process includes:

1. Version bump in scripts
2. Update CHANGELOG.md
3. Create GitHub release
4. Update installation URLs

## 🆘 Getting Help

If you need help:

- Check existing [Issues](https://github.com/KoDesigns/pretty-ls/issues)
- Start a [Discussion](https://github.com/KoDesigns/pretty-ls/discussions)
- Ask questions in your pull request

## 🏆 Recognition

Contributors are recognized in:
- GitHub contributors list
- CHANGELOG.md for significant contributions
- README.md acknowledgments

## 📋 Development Roadmap

Current priorities:
- [ ] Add more file type recognition
- [ ] Improve performance for large directories
- [ ] Add configuration file support
- [ ] Add sorting options
- [ ] Improve Windows compatibility

## 🎯 Project Goals

Keep these in mind when contributing:
- **Simplicity**: Easy to install and use
- **Performance**: Fast and lightweight
- **Compatibility**: Works across platforms and shells
- **User-friendly**: Clear output and helpful messages
- **Maintainable**: Clean, well-documented code

Thank you for contributing to Pretty-ls! 🎉 