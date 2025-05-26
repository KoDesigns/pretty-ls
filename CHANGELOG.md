# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Nothing yet

### Changed
- Nothing yet

### Deprecated
- Nothing yet

### Removed
- Nothing yet

### Fixed
- Nothing yet

### Security
- Nothing yet

## [1.0.0] - 2025-01-15

### Added
- 🎉 Initial release of Pretty-ls (pls)
- 📁 Emoji icons for folders and files
- 🎨 Color-coded output based on file type
- 📏 Smart truncation of long filenames
- 📊 Human-readable file sizes (B, KB, MB, GB)
- 🕒 File modification dates display
- 🖥️ Cross-platform support (macOS, Linux, Windows)
- 🐚 Multi-shell support (Bash, Zsh, PowerShell)
- ⚡ Fast and lightweight implementation
- 🔧 Easy installation scripts for all platforms
- 📖 Comprehensive documentation
- 🤝 Contributing guidelines
- 📄 Apache 2.0 license

### Features
- **Unix/Linux Script** (`scripts/pls.sh`):
  - Cross-platform compatibility detection
  - Robust error handling
  - Command-line argument support (`--help`, `--version`)
  - Support for directory arguments
  - Fallback for missing dependencies

- **PowerShell Script** (`scripts/pls.ps1`):
  - PowerShell module structure
  - Parameter validation
  - Error handling with try-catch blocks
  - Help and version functions
  - Alias support

- **Installation Scripts**:
  - macOS installer (`install/install-macos.sh`)
  - Linux installer (`install/install-linux.sh`)
  - Windows PowerShell installer (`install/install-windows.ps1`)
  - Automatic PATH configuration
  - Shell detection and configuration
  - Installation verification

### File Type Recognition
- 🟢 Shell scripts (.sh, .bash, .zsh) - Green
- 🟡 Text files (.txt, .log) - Yellow
- 🟣 Markdown files (.md, .markdown, .rst) - Magenta
- 🔵 Images (.jpg, .jpeg, .png, .gif, .bmp, .svg, .webp) - Blue
- 🔴 Executables (.exe, .bin, .app, .deb, .rpm, .dmg) - Red
- ⚪ Other files - Default color

### Platform Support
- **macOS**: 10.12+ with Bash 4.0+ or Zsh 5.0+
- **Linux**: Any modern distribution with Bash 4.0+ or Zsh 5.0+
- **Windows**: Windows 10+ with PowerShell 5.1+

### Documentation
- Comprehensive README with installation and usage instructions
- Contributing guidelines with development setup
- Code of conduct for community interactions
- Apache 2.0 license for open source compliance
- Examples and screenshots
- Cross-platform installation guides

---

## Release Notes

### Version 1.0.0 Highlights

This is the initial stable release of Pretty-ls, a modern replacement for the traditional `ls` command. The tool provides a clean, emoji-enhanced view of directory contents with intelligent color coding and human-readable formatting.

**Key Features:**
- Works seamlessly across macOS, Linux, and Windows
- Supports multiple shells including Bash, Zsh, and PowerShell
- One-command installation for each platform
- Comprehensive error handling and user feedback
- Extensible architecture for future enhancements

**Installation:**
```bash
# macOS
curl -sSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-macos.sh | bash

# Linux
curl -sSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-linux.sh | bash

# Windows (PowerShell)
iwr -useb https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1 | iex
```

**Usage:**
```bash
pls                    # List current directory
pls /path/to/directory # List specific directory
pls --help            # Show help
pls --version         # Show version
```

---

## Migration Guide

### From Legacy Scripts

If you were using the old `.zshrc_Mac` or `$PROFILE_Windows` files:

1. **Remove old configurations:**
   ```bash
   # Remove old function from your shell config
   # Edit ~/.zshrc (macOS) or PowerShell profile (Windows)
   ```

2. **Install new version:**
   ```bash
   # Use the appropriate installer for your platform
   ./install/install-macos.sh    # macOS
   ./install/install-linux.sh    # Linux
   ./install/install-windows.ps1 # Windows
   ```

3. **Restart your terminal** or source your configuration

### Breaking Changes

- Function name changed from `pretty-ls` to `pls` (alias maintained for compatibility)
- Configuration moved from shell configs to dedicated installation
- Improved error handling may show different messages
- Enhanced file type detection may show different colors

---

## Acknowledgments

- Thanks to early testers and feedback providers
- Inspired by modern CLI tools like `exa` and `lsd`
- Built with love for the command-line community

[Unreleased]: https://github.com/KoDesigns/pretty-ls/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/KoDesigns/pretty-ls/releases/tag/v1.0.0 