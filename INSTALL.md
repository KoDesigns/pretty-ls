# 📦 Pretty-ls Installation Guide

## 🚀 Quick Installation

### Universal Installer (Recommended)
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

## 📋 Installation Methods

### Method 1: Direct Web Installation
```bash
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash
```

### Method 2: Download and Execute
```bash
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

### Method 3: Git Clone
```bash
git clone https://github.com/KoDesigns/pretty-ls.git
cd pretty-ls
./install/install-macos.sh  # or install-linux.sh, install-windows.ps1
```

## ⚙️ Installer Options

| Option | Description |
|--------|-------------|
| `--help` | Show help message |
| `--verbose` | Enable detailed output |
| `--debug` | Enable debug output (Unix/Linux only) |
| `--force` | Force reinstallation |
| `--uninstall` | Uninstall pretty-ls |

### Examples
```bash
# Verbose installation
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash -s -- --verbose

# Force reinstall
./install/install-linux.sh --force

# Uninstall
./install/install-macos.sh --uninstall
```

## 🖼️ Windows PowerShell

### Modern PowerShell (7+)
```powershell
iex (irm 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1')
```

### Legacy PowerShell (5.1)
```powershell
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1'))
```

## 📋 What the Installers Do

1. **System Check**: Verify OS and dependencies
2. **Download**: Get latest script from GitHub  
3. **Install**: Place in `~/.local/bin` (or Windows equivalent)
4. **Configure**: Update PATH and shell config
5. **Test**: Verify installation works

## 📍 Installation Locations

| Platform | Directory | Script |
|----------|-----------|--------|
| macOS/Linux | `~/.local/bin/` | `pls` |
| Windows | `%USERPROFILE%\.local\bin\` | `pls.ps1` |

## 🛠️ Troubleshooting

### Network Issues
```bash
# Test GitHub connectivity
curl -fsSL https://api.github.com
```

### PATH Issues
```bash
# Check if in PATH
echo $PATH | grep -q "$HOME/.local/bin" && echo "✓ In PATH" || echo "✗ Not in PATH"

# Add to PATH manually
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### PowerShell Execution Policy
```powershell
# Check policy
Get-ExecutionPolicy

# Allow scripts (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Manual Cleanup
```bash
# Remove script
rm -f ~/.local/bin/pls

# Remove from shell config (edit manually)
# ~/.bashrc, ~/.zshrc, ~/.config/fish/config.fish
```

## 🗑️ Uninstallation

```bash
# Using installer
curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash -s -- --uninstall

# Manual removal
rm -f ~/.local/bin/pls
# Edit shell config to remove PATH modification
```

## 🆘 Getting Help

1. Run with `--verbose` for detailed output
2. Check network connectivity to GitHub
3. Verify prerequisites are installed
4. Try manual installation method
5. Report issues at: https://github.com/KoDesigns/pretty-ls 