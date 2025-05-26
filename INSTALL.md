# Installation Guide

This guide provides detailed installation instructions for Pretty-ls on different platforms.

## 🚀 Quick Installation

### One-Line Installation

**macOS:**
```bash
curl -sSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-macos.sh | bash
```

**Linux:**
```bash
curl -sSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-linux.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1 | iex
```

## 📦 Manual Installation

### Step 1: Download

**Option A: Clone the repository**
```bash
git clone https://github.com/KoDesigns/pretty-ls.git
cd pretty-ls
```

**Option B: Download ZIP**
1. Go to the [GitHub repository](https://github.com/KoDesigns/pretty-ls)
2. Click "Code" → "Download ZIP"
3. Extract the ZIP file
4. Open terminal/PowerShell in the extracted folder

### Step 2: Run Installer

**macOS:**
```bash
chmod +x install/install-macos.sh
./install/install-macos.sh
```

**Linux:**
```bash
chmod +x install/install-linux.sh
./install/install-linux.sh
```

**Windows (PowerShell):**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install\install-windows.ps1
```

### Step 3: Restart Terminal

After installation, restart your terminal or source your shell configuration:

**Bash:**
```bash
source ~/.bashrc
```

**Zsh:**
```bash
source ~/.zshrc
```

**PowerShell:**
```powershell
# Just restart PowerShell
```

## 🔧 Advanced Installation

### Custom Installation Directory

By default, Pretty-ls installs to `~/.local/bin` (Unix) or PowerShell modules directory (Windows). To install to a custom location:

**Unix/Linux:**
```bash
# Edit the installer script and change INSTALL_DIR
INSTALL_DIR="/usr/local/bin" ./install/install-macos.sh
```

### Development Installation

For development or testing:

```bash
# Clone the repository
git clone https://github.com/KoDesigns/pretty-ls.git
cd pretty-ls

# Make scripts executable
chmod +x scripts/pls.sh

# Test directly
./scripts/pls.sh

# Or create a symlink
ln -s "$(pwd)/scripts/pls.sh" ~/.local/bin/pls
```

## 🐚 Shell-Specific Instructions

### Bash

The installer automatically detects Bash and updates `~/.bashrc` or `~/.bash_profile`.

**Manual setup:**
```bash
# Add to ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

### Zsh

The installer automatically detects Zsh and updates `~/.zshrc`.

**Manual setup:**
```bash
# Add to ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
```

### Fish

For Fish shell users on Linux:

```fish
# Add to ~/.config/fish/config.fish
set -gx PATH $HOME/.local/bin $PATH
```

### PowerShell

The installer creates a PowerShell module and updates your profile.

**Manual setup:**
```powershell
# Check your profile location
$PROFILE

# Add to your profile
Import-Module PrettyLs -Force
```

## 🔍 Verification

After installation, verify that Pretty-ls is working:

```bash
# Check if command is available
which pls
# or
command -v pls

# Test the command
pls --version
pls --help
pls
```

## 🚨 Troubleshooting

### Command Not Found

**Issue:** `pls: command not found`

**Solutions:**
1. Restart your terminal
2. Check if `~/.local/bin` is in your PATH:
   ```bash
   echo $PATH | grep -o ~/.local/bin
   ```
3. Manually source your shell config:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

### Permission Denied

**Issue:** `Permission denied` when running installer

**Solutions:**
1. Make the installer executable:
   ```bash
   chmod +x install/install-macos.sh
   ```
2. Run with bash explicitly:
   ```bash
   bash install/install-macos.sh
   ```

### PowerShell Execution Policy

**Issue:** PowerShell won't run the installer

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Missing Dependencies (Linux)

**Issue:** `stat: command not found` or similar

**Solution:**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install coreutils gawk

# CentOS/RHEL
sudo yum install coreutils gawk

# Fedora
sudo dnf install coreutils gawk

# Arch
sudo pacman -S coreutils gawk
```

### Emoji Not Displaying

**Issue:** Emojis show as boxes or question marks

**Solutions:**
1. Use a modern terminal emulator (iTerm2, Windows Terminal, etc.)
2. Install emoji fonts on your system
3. Check terminal encoding (should be UTF-8)

## 🗑️ Uninstallation

### Remove Pretty-ls

**Unix/Linux:**
```bash
# Remove the binary
rm ~/.local/bin/pls

# Remove from shell config (manual)
# Edit ~/.zshrc or ~/.bashrc and remove the PATH line
```

**Windows:**
```powershell
# Remove the module
Remove-Module PrettyLs
$ModulePath = Join-Path $env:USERPROFILE "Documents\PowerShell\Modules\PrettyLs"
Remove-Item $ModulePath -Recurse -Force

# Remove from profile (manual)
# Edit your PowerShell profile and remove the Import-Module line
```

## 📞 Support

If you encounter issues:

1. Check this troubleshooting guide
2. Search [existing issues](https://github.com/KoDesigns/pretty-ls/issues)
3. Create a [new issue](https://github.com/KoDesigns/pretty-ls/issues/new) with:
   - Your operating system and version
   - Shell type and version
   - Error messages
   - Steps you tried 