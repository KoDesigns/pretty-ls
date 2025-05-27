# 📂 Pretty-ls (`pls`)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh%20%7C%20PowerShell-green.svg)]()
[![Install](https://img.shields.io/badge/Install-curl%20%7C%20bash-brightgreen.svg)](#-quick-start)

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
- 🔧 **Easy Installation**: One-command installation for all platforms

## 🧪 Try Before Installing

Want to see pretty-ls in action without installing? Run it directly:

```bash
# Unix/Linux/macOS
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/scripts/pls.sh | bash

# Or download and test
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/scripts/pls.sh -o pls && chmod +x pls && ./pls
```

```powershell
# Windows PowerShell
iex (irm 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/scripts/pls.ps1')
```

## 🚀 Quick Start

### One-Command Installation
```bash
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash
```

### Platform-Specific
```bash
# macOS
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-macos.sh | bash

# Linux  
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-linux.sh | bash
```

```powershell
# Windows PowerShell
iex (irm 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1')
```

## 📦 Installation

### Prerequisites
- **macOS**: macOS 10.12+, curl
- **Linux**: Modern distro, curl, basic utilities (usually pre-installed)  
- **Windows**: Windows 10+, PowerShell 5.1+

### Installation Options

#### Web Installation (Recommended)
```bash
# Universal installer (detects your platform)
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash

# With options
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash -s -- --verbose
```

#### Download and Run
```bash
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

#### Manual Installation
```bash
git clone https://github.com/KoDesigns/pretty-ls.git
cd pretty-ls
./install/install-macos.sh  # or install-linux.sh, install-windows.ps1
```

### Installer Options
- `--help`: Show help
- `--verbose`: Detailed output  
- `--force`: Force reinstall
- `--uninstall`: Remove pretty-ls

### Troubleshooting
```bash
# Test connectivity
curl -fsSL https://api.github.com

# Check PATH
echo $PATH | grep -q "$HOME/.local/bin" && echo "✓ In PATH" || echo "✗ Not in PATH"

# Manual PATH setup (if needed)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
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

## 🗑️ Uninstallation

To uninstall pretty-ls, use the same installer with the `--uninstall` flag:

```bash
# Universal uninstaller
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash -s -- --uninstall

# Or run locally
./install/install-macos.sh --uninstall
```

## 📁 Project Structure

```
pretty-ls/
├── scripts/
│   ├── pls.sh         # Main script for Unix/Linux
│   └── pls.ps1        # Main script for Windows
├── install/
│   ├── install-macos.sh    # macOS installer
│   ├── install-linux.sh    # Linux installer  
│   └── install-windows.ps1 # Windows installer
├── install.sh         # Universal installer (detects platform)
├── README.md          # You are here
└── INSTALL.md         # Detailed installation guide
```

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
├── install.sh         # Universal installer
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
   chmod +x install.sh
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

Contributions are welcome! Here's how to get started:

```bash
# 1. Fork and clone
git clone https://github.com/yourusername/pretty-ls.git
cd pretty-ls

# 2. Make your changes
# Edit scripts/pls.sh or scripts/pls.ps1

# 3. Test your changes
./scripts/pls.sh  # Unix/Linux/macOS
# or
pwsh -File scripts/pls.ps1  # Windows

# 4. Submit a pull request
```

### What to contribute:
- 🐛 **Bug fixes**: Fix issues or improve compatibility
- ✨ **Features**: Add new functionality (keep it simple!)
- 📚 **Documentation**: Improve README, add examples
- 🧪 **Testing**: Test on different platforms/shells

### Guidelines:
- Keep changes simple and focused
- Test on your platform before submitting
- Follow existing code style
- Update documentation if needed

## 📋 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

## ❓ FAQ

**Q: Does pretty-ls replace the built-in `ls` command?**  
A: No, it installs as `pls` so your original `ls` command remains unchanged.

**Q: Can I use this without installing?**  
A: Yes! See the "Try Before Installing" section above.

**Q: What if I don't see emojis?**  
A: Use a modern terminal (iTerm2, Windows Terminal, etc.) with emoji support.

**Q: How do I uninstall?**  
A: Run the installer with `--uninstall` flag or see the uninstallation section.

**Q: Does this work in SSH/remote sessions?**  
A: Yes, as long as your terminal supports the character encoding.

## 🐛 Issues and Support

**Found a bug or have a suggestion?**  
[Create an issue](https://github.com/KoDesigns/pretty-ls/issues) on GitHub.

**Need help?**  
Check the [troubleshooting section](#troubleshooting) or [installation guide](INSTALL.md).

**Include when reporting issues:**
- Your OS and shell (e.g., "macOS 13.1, zsh")
- Error message (if any)
- Steps to reproduce

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
