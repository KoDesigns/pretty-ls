#!/usr/bin/env bash

# Pretty-ls (pls) - Linux Installation Script
# Copyright (c) 2025 Pretty-ls Contributors
# Licensed under the Apache License, Version 2.0

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
readonly INSTALL_DIR="$HOME/.local/bin"
readonly SCRIPT_NAME="pls"
readonly SOURCE_SCRIPT="$PROJECT_DIR/scripts/pls.sh"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Linux
check_linux() {
    if [[ "$(uname -s)" != "Linux" ]]; then
        print_error "This installer is for Linux only. Use install-macos.sh for macOS systems."
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    # Check for required commands
    if ! command -v stat >/dev/null 2>&1; then
        missing_deps+=("coreutils")
    fi
    
    if ! command -v awk >/dev/null 2>&1; then
        missing_deps+=("gawk")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_status "Please install them using your package manager:"
        print_status "  Ubuntu/Debian: sudo apt install ${missing_deps[*]}"
        print_status "  CentOS/RHEL:   sudo yum install ${missing_deps[*]}"
        print_status "  Fedora:        sudo dnf install ${missing_deps[*]}"
        print_status "  Arch:          sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi
}

# Create installation directory
create_install_dir() {
    if [[ ! -d "$INSTALL_DIR" ]]; then
        print_status "Creating installation directory: $INSTALL_DIR"
        mkdir -p "$INSTALL_DIR"
    fi
}

# Install the script
install_script() {
    print_status "Installing pls script to $INSTALL_DIR/$SCRIPT_NAME"
    
    if [[ ! -f "$SOURCE_SCRIPT" ]]; then
        print_error "Source script not found: $SOURCE_SCRIPT"
        exit 1
    fi
    
    cp "$SOURCE_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    
    print_success "Script installed successfully"
}

# Add to PATH if needed
update_path() {
    local shell_config=""
    local shell_name=""
    
    # Detect shell and config file
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_config="$HOME/.zshrc"
        shell_name="Zsh"
    elif [[ "$SHELL" == *"bash"* ]]; then
        # Check for different bash config files
        if [[ -f "$HOME/.bashrc" ]]; then
            shell_config="$HOME/.bashrc"
        else
            shell_config="$HOME/.bash_profile"
        fi
        shell_name="Bash"
    elif [[ "$SHELL" == *"fish"* ]]; then
        shell_config="$HOME/.config/fish/config.fish"
        shell_name="Fish"
        # Create fish config directory if it doesn't exist
        mkdir -p "$(dirname "$shell_config")"
    else
        print_warning "Unknown shell: $SHELL. You may need to manually add $INSTALL_DIR to your PATH."
        return
    fi
    
    # Check if PATH already includes install directory
    if echo "$PATH" | grep -q "$INSTALL_DIR"; then
        print_status "$INSTALL_DIR is already in your PATH"
        return
    fi
    
    # Check if shell config already has the PATH export
    if [[ -f "$shell_config" ]] && grep -q "$INSTALL_DIR" "$shell_config"; then
        print_status "$INSTALL_DIR is already configured in $shell_config"
        return
    fi
    
    print_status "Adding $INSTALL_DIR to PATH in $shell_config"
    
    # Create shell config if it doesn't exist
    if [[ ! -f "$shell_config" ]]; then
        touch "$shell_config"
    fi
    
    # Add PATH export to shell config (different syntax for fish)
    if [[ "$shell_name" == "Fish" ]]; then
        cat >> "$shell_config" << EOF

# Added by Pretty-ls (pls) installer
set -gx PATH \$HOME/.local/bin \$PATH
EOF
    else
        cat >> "$shell_config" << EOF

# Added by Pretty-ls (pls) installer
export PATH="\$HOME/.local/bin:\$PATH"
EOF
    fi
    
    print_success "Updated $shell_name configuration"
    print_warning "Please restart your terminal or run: source $shell_config"
}

# Test installation
test_installation() {
    print_status "Testing installation..."
    
    if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
        print_success "Installation test passed! You can now use 'pls' command."
        
        # Show version
        print_status "Running pls --version:"
        "$SCRIPT_NAME" --version
    else
        print_warning "Command 'pls' not found in PATH. You may need to restart your terminal."
        print_status "You can also run it directly: $INSTALL_DIR/$SCRIPT_NAME"
    fi
}

# Main installation function
main() {
    echo "🐧 Pretty-ls (pls) - Linux Installer"
    echo "====================================="
    echo
    
    check_linux
    check_dependencies
    create_install_dir
    install_script
    update_path
    test_installation
    
    echo
    print_success "Installation completed!"
    echo
    echo "Usage:"
    echo "  pls              # List current directory"
    echo "  pls /path/to/dir # List specific directory"
    echo "  pls --help       # Show help"
    echo "  pls --version    # Show version"
    echo
}

# Run main function
main "$@" 