# 📂 Pretty-ls (`pls`) - A Better File Listing Tool

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/Shell-Bash%20%7C%20Zsh%20%7C%20PowerShell-green.svg)]()
[![Install](https://img.shields.io/badge/Install-One%20Command-brightgreen.svg)](#-quick-installation)

> **Transform your terminal file listings into something clear and readable.**  
> Pretty-ls provides a clean, colorful overview of your files and folders with intuitive icons, file type recognition, human-readable sizes, and modification dates.

![Pretty-ls Demo](docs/demo.png)

## Why Pretty-ls?

The default `ls` command works, but it's not particularly user-friendly. Pretty-ls improves the experience:

- **🎨 Clear visual design** – Colors and icons make file types immediately recognizable
- **🧠 Human-readable output** – File sizes in KB/MB instead of raw bytes
- **⚡ Simple installation** – One command to install across all platforms
- **🤝 Non-intrusive** – Installs as `pls`, leaving your original `ls` unchanged

## 🚀 Quick Installation

**Try it without installing:**

```bash
# Unix/Linux/macOS
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/scripts/pls.sh | bash
```

```powershell
# Windows PowerShell
iex (irm 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/scripts/pls.ps1')
```

**Install permanently:**

```bash
# Universal installer (all platforms)
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash
```

*After installation, restart your terminal and use `pls` to list files.*

## What You Get

### Standard `ls` output:
```
total 24
drwxr-xr-x  4 user user 4096 Jan 15 14:30 Documents
drwxr-xr-x  2 user user 4096 Jan 14 09:15 Pictures
-rw-r--r--  1 user user 2156 Jan 15 16:45 README.md
-rwxr-xr-x  1 user user 1534 Jan 15 10:20 install.sh
-rw-r--r--  1 user user  856 Jan 14 18:30 notes.txt
```

### Pretty-ls output:
```
Type         Name                                      Size   Modified
--------------------------------------------------------------------------------
📁 Folder    Documents                                <DIR>   2024-01-15 14:30
📁 Folder    Pictures                                 <DIR>   2024-01-14 09:15
📄 MD        README.md                                2.1 KB  2024-01-15 16:45
📄 SH        install.sh                               1.5 KB  2024-01-15 10:20
📄 TXT       notes.txt                                856 B   2024-01-14 18:30
```

## File Type Recognition

Pretty-ls automatically recognizes and color-codes different file types:

- 📁 **Directories** – Easy to distinguish from files
- 🟢 **Scripts** (.sh, .py, .js) – Executable scripts in green
- 🟡 **Text files** (.txt, .log) – Plain text files in yellow
- 🟣 **Markdown** (.md) – Documentation files in purple
- 🔵 **Images** (.jpg, .png, .gif) – Image files in blue
- 🔴 **Executables** (.exe, .bin) – Binary executables in red
- ⚪ **Other files** – Default styling for unrecognized types

## Platform Support

**Operating Systems:** macOS, Linux, Windows  
**Shells:** Bash, Zsh, Fish, PowerShell

Pretty-ls has been tested across different platforms and shell environments.

## Installation Options

### Recommended (Universal Installer)
```bash
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash
```

### Download and Review First
```bash
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh -o install.sh
chmod +x install.sh
./install.sh --verbose
```

### Platform-Specific Installers
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

### Manual Installation
```bash
git clone https://github.com/KoDesigns/pretty-ls.git
cd pretty-ls
./install.sh
```

## Usage

```bash
# List current directory
pls

# List specific directory
pls ~/Documents
pls /var/log
pls "C:\Program Files"  # Windows

# Show help
pls --help

# Show version
pls --version
```

## Troubleshooting

**Command not found after installation:**  
Restart your terminal or run `source ~/.bashrc` (or `~/.zshrc` for zsh users).

**Installation fails:**  
Check your internet connection and try again. If problems persist, [open an issue](https://github.com/KoDesigns/pretty-ls/issues).

**Need help:**  
Include your OS, shell type, and any error messages when reporting issues.

## Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash -s -- --uninstall
```

Your original `ls` command remains unchanged.

## Contributing

Contributions are welcome:

- **Bug reports:** [Create an issue](https://github.com/KoDesigns/pretty-ls/issues)
- **Feature requests:** Share your ideas
- **Code contributions:** Fork, improve, and submit a pull request

Please keep changes focused and test on your platform before submitting.

## Project Structure

```
pretty-ls/
├── scripts/
│   ├── pls.sh         # Unix/Linux/macOS implementation
│   └── pls.ps1        # Windows PowerShell implementation
├── install/           # Platform-specific installers
│   ├── install-macos.sh
│   ├── install-linux.sh
│   └── install-windows.ps1
├── install.sh         # Universal installer
├── README.md          # This file
└── INSTALL.md         # Detailed installation guide
```

## FAQ

**Q: Does this replace the built-in `ls` command?**  
A: No. Pretty-ls installs as `pls`, leaving your original `ls` command unchanged.

**Q: Do I need administrator privileges?**  
A: No. Installation uses your home directory (`~/.local/bin`).

**Q: Will this work over SSH?**  
A: Yes, as long as your terminal supports the character encoding.

**Q: What if emojis don't display correctly?**  
A: Use a modern terminal emulator that supports Unicode and emojis.

## License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

---

**Made with care for better terminal experiences.**
