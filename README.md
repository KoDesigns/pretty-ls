# 📂 Pretty-ls (`pls`)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh%20%7C%20PowerShell-green.svg)]()

A human-friendly and emoji-enhanced `ls` replacement for the terminal. Pretty-ls provides a clean, colorful overview of your files and folders with intuitive icons, file type labels, human-readable sizes, and modification dates.

![Pretty-ls Demo](docs/demo.png)

## ✨ Features

- 📁 **Emoji Icons**: Folders and files are distinguished with clear emoji icons
- 🎨 **Color Coding**: Different file types are color-coded for easy identification
- 📏 **Smart Truncation**: Long filenames are intelligently truncated with ellipsis
- 📊 **Human-Readable Sizes**: File sizes displayed in B, KB, MB, GB as appropriate
- 🕒 **Modification Dates**: Shows when files were last modified
- 🖥️ **Cross-Platform**: Works on macOS, Linux, and Windows
- 🐚 **Multi-Shell**: Supports Bash, Zsh, Fish, and PowerShell
- ⚡ **Fast**: Lightweight and responsive
- 🔧 **Easy Installation**: One-command installation for each platform

## 🚀 Quick Start

### macOS
```bash
curl -sSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-macos.sh | bash
```

### Linux
```bash
curl -sSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-linux.sh | bash
```

### Windows (PowerShell)
```powershell
iwr -useb https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1 | iex
```

## 📦 Installation

### Prerequisites

#### macOS
- macOS 10.12 or later
- Bash 4.0+ or Zsh 5.0+

#### Linux
- Any modern Linux distribution
- Bash 4.0+ or Zsh 5.0+
- `coreutils` package (usually pre-installed)
- `gawk` package (usually pre-installed)

#### Windows
- Windows 10 or later
- PowerShell 5.1 or later (PowerShell Core 6+ recommended)

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/KoDesigns/pretty-ls.git
   cd pretty-ls
   ```

2. **Run the appropriate installer:**

   **macOS:**
   ```bash
   ./install/install-macos.sh
   ```

   **Linux:**
   ```bash
   ./install/install-linux.sh
   ```

   **Windows (PowerShell):**
   ```powershell
   .\install\install-windows.ps1
   ```

3. **Restart your terminal** or source your shell configuration:
   ```bash
   # For Bash
   source ~/.bashrc
   
   # For Zsh
   source ~/.zshrc
   ```

## 🎯 Usage

### Basic Usage
```bash
# List current directory
pls

# List specific directory
pls /path/to/directory
pls ~/Documents
pls C:\Users\Username\Documents  # Windows
```

### Command Options
```bash
# Show help
pls --help
pls -h

# Show version
pls --version
pls -v
```

### PowerShell Usage
```powershell
# List current directory
pls

# List specific directory
pls C:\Users\Username\Documents

# Show help
pls -Help

# Show version
pls -Version
```

## 📸 Examples

### Directory Listing
```
Type         Name                                      Size   Modified
--------------------------------------------------------------------------------
📁 Folder    Documents                                <DIR>   2024-01-15 14:30
📁 Folder    Pictures                                 <DIR>   2024-01-14 09:15
📄 MD        README.md                                2.1 KB  2024-01-15 16:45
📄 SH        install.sh                               1.5 KB  2024-01-15 10:20
📄 TXT       notes.txt                                856 B   2024-01-14 18:30
```

### File Type Recognition
Pretty-ls recognizes and color-codes various file types:

- 🟢 **Shell scripts** (.sh, .bash, .zsh) - Green
- 🟡 **Text files** (.txt, .log) - Yellow  
- 🟣 **Markdown files** (.md, .markdown) - Magenta
- 🔵 **Images** (.jpg, .png, .gif, .svg) - Blue
- 🔴 **Executables** (.exe, .bin, .app) - Red
- ⚪ **Other files** - Default color

## 🛠️ Development

### Project Structure
```
pretty-ls/
├── scripts/           # Core scripts
│   ├── pls.sh        # Unix/Linux script
│   └── pls.ps1       # PowerShell script
├── install/           # Installation scripts
│   ├── install-macos.sh
│   ├── install-linux.sh
│   └── install-windows.ps1
├── docs/             # Documentation
├── LICENSE           # Apache 2.0 License
└── README.md         # This file
```

### Building from Source

1. **Clone the repository:**
   ```bash
   git clone https://github.com/KoDesigns/pretty-ls.git
   cd pretty-ls
   ```

2. **Make scripts executable (Unix/Linux):**
   ```bash
   chmod +x scripts/pls.sh
   chmod +x install/*.sh
   ```

3. **Test the script:**
   ```bash
   # Unix/Linux
   ./scripts/pls.sh
   
   # Windows
   pwsh -File scripts/pls.ps1
   ```

### Running Tests

```bash
# Test on current directory
./scripts/pls.sh

# Test with different directories
./scripts/pls.sh /tmp
./scripts/pls.sh ~/Documents

# Test help and version
./scripts/pls.sh --help
./scripts/pls.sh --version
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Quick Contribution Guide

1. **Fork the repository**
2. **Create a feature branch:** `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Test thoroughly** on your platform
5. **Commit your changes:** `git commit -m 'Add amazing feature'`
6. **Push to the branch:** `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Development Guidelines

- Follow existing code style and conventions
- Add comments for complex logic
- Test on multiple platforms when possible
- Update documentation for new features
- Ensure backward compatibility

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

## 🐛 Issues and Support

- **Bug Reports**: [GitHub Issues](https://github.com/KoDesigns/pretty-ls/issues)
- **Feature Requests**: [GitHub Issues](https://github.com/KoDesigns/pretty-ls/issues)
- **Questions**: [GitHub Discussions](https://github.com/KoDesigns/pretty-ls/discussions)

When reporting issues, please include:
- Operating system and version
- Shell type and version
- Steps to reproduce the issue
- Expected vs actual behavior

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for a more user-friendly `ls` command
- Thanks to all contributors who help improve this project
- Special thanks to the open source community

## 🔗 Related Projects

- [exa](https://github.com/ogham/exa) - A modern replacement for ls
- [lsd](https://github.com/Peltoche/lsd) - The next gen ls command
- [colorls](https://github.com/athityakumar/colorls) - A Ruby gem to beautify ls

---

**Made with ❤️ by the Pretty-ls community**
