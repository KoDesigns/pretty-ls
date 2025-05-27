#!/usr/bin/env bash

# Pretty-ls (pls) - macOS Installation Script
# Copyright (c) 2025 Pretty-ls Contributors
# Licensed under the Apache License, Version 2.0
#
# This script can be executed directly from the web:
# curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-macos.sh | bash
#
# Or downloaded and run locally:
# curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-macos.sh -o install.sh && bash install.sh

set -euo pipefail

# Configuration
readonly SCRIPT_VERSION="1.0.0"
readonly INSTALL_DIR="$HOME/.local/bin"
readonly SCRIPT_NAME="pls"
readonly GITHUB_RAW_URL="https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/scripts/pls.sh"
readonly GITHUB_API_URL="https://api.github.com/repos/KoDesigns/pretty-ls"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
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
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

print_debug() {
    if [[ "${DEBUG:-}" == "1" ]]; then
        echo -e "${CYAN}[DEBUG]${NC} $1" >&2
    fi
}

# Error handling
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        print_error "Installation failed with exit code $exit_code"
    fi
    # Clean up any temporary files
    if [[ -n "${temp_file:-}" && -f "$temp_file" ]]; then
        rm -f "$temp_file"
    fi
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Show help
show_help() {
    cat << EOF
Pretty-ls (pls) - macOS Installation Script v${SCRIPT_VERSION}

This script installs the pretty-ls command line tool on macOS systems.

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    -d, --debug     Enable debug output
    --uninstall     Uninstall pretty-ls
    --force         Force reinstallation

EXAMPLES:
    # Install normally
    $0

    # Install with verbose output
    $0 --verbose

    # Uninstall
    $0 --uninstall

    # Web installation (recommended)
    curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-macos.sh | bash

EOF
}

# Parse command line arguments
parse_args() {
    VERBOSE=0
    DEBUG=0
    UNINSTALL=0
    FORCE=0

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -d|--debug)
                DEBUG=1
                VERBOSE=1
                shift
                ;;
            --uninstall)
                UNINSTALL=1
                shift
                ;;
            --force)
                FORCE=1
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    export DEBUG VERBOSE
}

# Check if running on macOS
check_macos() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        print_error "This installer is for macOS only."
        print_status "For other platforms, visit: https://github.com/KoDesigns/pretty-ls"
        exit 1
    fi
    print_debug "Operating system: macOS ($(uname -r))"
    
    # Check macOS version
    local macos_version
    macos_version=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
    print_debug "macOS version: $macos_version"
}

# Check if curl is available
check_curl() {
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required but not installed."
        print_status "curl should be available by default on macOS."
        print_status "If missing, install Xcode Command Line Tools:"
        print_status "  xcode-select --install"
        exit 1
    fi
    print_debug "curl version: $(curl --version | head -n1)"
}

# Check required dependencies (most should be available on macOS)
check_dependencies() {
    local missing_deps=()
    
    # Check for required commands
    local required_cmds=("stat" "awk" "grep" "sed" "cut" "head" "tail")
    
    for cmd in "${required_cmds[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_status "These should be available by default on macOS."
        print_status "If missing, install Xcode Command Line Tools:"
        print_status "  xcode-select --install"
        exit 1
    fi
    
    print_debug "All required dependencies are available"
}

# Test network connectivity
test_connectivity() {
    print_debug "Testing network connectivity to GitHub..."
    
    if ! curl -fsSL --connect-timeout 10 --retry 3 "https://api.github.com" >/dev/null 2>&1; then
        print_error "Cannot connect to GitHub. Please check your internet connection."
        exit 1
    fi
    
    print_debug "Network connectivity test passed"
}

# Create installation directory
create_install_dir() {
    if [[ ! -d "$INSTALL_DIR" ]]; then
        print_status "Creating installation directory: $INSTALL_DIR"
        if ! mkdir -p "$INSTALL_DIR"; then
            print_error "Failed to create installation directory: $INSTALL_DIR"
            exit 1
        fi
    fi
    print_debug "Installation directory ready: $INSTALL_DIR"
}

# Download and verify script
download_script() {
    print_status "Downloading pls script from GitHub..."
    
    local temp_file
    temp_file=$(mktemp) || {
        print_error "Failed to create temporary file"
        exit 1
    }
    
    # Download with proper error handling and security flags
    if ! curl -fsSL \
        --connect-timeout 30 \
        --retry 3 \
        --retry-delay 2 \
        --retry-max-time 60 \
        --proto '=https' \
        --tlsv1.2 \
        "$GITHUB_RAW_URL" \
        -o "$temp_file"; then
        print_error "Failed to download script from GitHub"
        print_status "URL: $GITHUB_RAW_URL"
        rm -f "$temp_file"
        exit 1
    fi
    
    # Verify the downloaded file is not empty and looks like a shell script
    if [[ ! -s "$temp_file" ]]; then
        print_error "Downloaded file is empty"
        rm -f "$temp_file"
        exit 1
    fi
    
    if ! head -n1 "$temp_file" | grep -q "^#!/.*bash"; then
        print_error "Downloaded file does not appear to be a bash script"
        rm -f "$temp_file"
        exit 1
    fi
    
    # Install the script
    print_status "Installing pls script to $INSTALL_DIR/$SCRIPT_NAME"
    if ! mv "$temp_file" "$INSTALL_DIR/$SCRIPT_NAME"; then
        print_error "Failed to install script to $INSTALL_DIR/$SCRIPT_NAME"
        rm -f "$temp_file"
        exit 1
    fi
    
    if ! chmod +x "$INSTALL_DIR/$SCRIPT_NAME"; then
        print_error "Failed to make script executable"
        exit 1
    fi
    
    print_success "Script installed successfully"
    
    # macOS-specific: Use different stat syntax
    local file_size
    if file_size=$(stat -f%z "$INSTALL_DIR/$SCRIPT_NAME" 2>/dev/null); then
        print_debug "Script size: $file_size bytes"
    else
        print_debug "Script size: unknown"
    fi
}

# Detect shell and configuration
detect_shell() {
    local shell_name="${SHELL##*/}"
    local shell_config=""
    
    case "$shell_name" in
        zsh)
            shell_config="$HOME/.zshrc"
            ;;
        bash)
            # On macOS, prefer .bash_profile over .bashrc
            if [[ -f "$HOME/.bash_profile" ]]; then
                shell_config="$HOME/.bash_profile"
            elif [[ -f "$HOME/.bashrc" ]]; then
                shell_config="$HOME/.bashrc"
            else
                shell_config="$HOME/.bash_profile"  # Default for macOS
            fi
            ;;
        fish)
            shell_config="$HOME/.config/fish/config.fish"
            mkdir -p "$(dirname "$shell_config")"
            ;;
        *)
            print_warning "Unknown shell: $shell_name"
            return 1
            ;;
    esac
    
    echo "$shell_config"
}

# Update PATH in shell configuration
update_path() {
    # Check if already in PATH
    if echo "$PATH" | grep -q "$INSTALL_DIR"; then
        print_status "$INSTALL_DIR is already in your PATH"
        return 0
    fi
    
    local shell_config
    if ! shell_config=$(detect_shell); then
        print_warning "Could not detect shell configuration file"
        print_status "Please manually add $INSTALL_DIR to your PATH"
        return 0
    fi
    
    # Check if already configured
    if [[ -f "$shell_config" ]] && grep -q "$INSTALL_DIR" "$shell_config"; then
        print_status "$INSTALL_DIR is already configured in $shell_config"
        return 0
    fi
    
    print_status "Adding $INSTALL_DIR to PATH in $shell_config"
    
    # Create config file if it doesn't exist
    if [[ ! -f "$shell_config" ]]; then
        touch "$shell_config"
    fi
    
    # Add PATH export (different syntax for fish)
    if [[ "$shell_config" == *"fish"* ]]; then
        cat >> "$shell_config" << 'EOF'

# Added by Pretty-ls (pls) installer
set -gx PATH $HOME/.local/bin $PATH
EOF
    else
        cat >> "$shell_config" << 'EOF'

# Added by Pretty-ls (pls) installer
export PATH="$HOME/.local/bin:$PATH"
EOF
    fi
    
    print_success "Updated shell configuration"
    print_warning "Please restart your terminal or run: source $shell_config"
}

# Test installation
test_installation() {
    print_status "Testing installation..."
    
    # Test if script exists and is executable
    if [[ ! -x "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        print_error "Script not found or not executable: $INSTALL_DIR/$SCRIPT_NAME"
        return 1
    fi
    
    # Test if command is available in PATH
    if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
        print_success "Installation test passed! You can now use 'pls' command."
        
        # Show version if available
        if "$SCRIPT_NAME" --version >/dev/null 2>&1; then
            print_status "Version information:"
            "$SCRIPT_NAME" --version
        fi
    else
        print_warning "Command 'pls' not found in PATH"
        print_status "You can run it directly: $INSTALL_DIR/$SCRIPT_NAME"
        print_status "Or restart your terminal to pick up PATH changes"
    fi
    
    # Basic functionality test
    if [[ "$VERBOSE" == "1" ]]; then
        print_status "Testing basic functionality..."
        if "$INSTALL_DIR/$SCRIPT_NAME" --help >/dev/null 2>&1; then
            print_debug "Help command works correctly"
        else
            print_warning "Help command failed, but installation may still be functional"
        fi
    fi
}

# Check for Homebrew (optional recommendation)
check_homebrew() {
    if [[ "$VERBOSE" == "1" ]] && ! command -v brew >/dev/null 2>&1; then
        print_status "Note: Homebrew is not installed."
        print_status "While not required for pretty-ls, Homebrew is recommended for managing packages on macOS."
        print_status "Visit https://brew.sh for installation instructions."
    fi
}

# Uninstall function
uninstall() {
    print_status "Uninstalling Pretty-ls..."
    
    # Remove script
    if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" ]]; then
        rm -f "$INSTALL_DIR/$SCRIPT_NAME"
        print_success "Removed $INSTALL_DIR/$SCRIPT_NAME"
    else
        print_status "Script not found at $INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    # Note about shell configuration
    print_warning "Note: Shell configuration was not modified."
    print_status "If you want to remove PATH modifications, edit your shell config manually:"
    
    local shell_config
    if shell_config=$(detect_shell); then
        print_status "  $shell_config"
    fi
    
    print_success "Uninstallation completed!"
}

# Main installation function
main() {
    echo "🚀 Pretty-ls (pls) - macOS Installer v${SCRIPT_VERSION}"
    echo "======================================================="
    echo
    
    # Parse command line arguments
    parse_args "$@"
    
    # Handle uninstall
    if [[ "$UNINSTALL" == "1" ]]; then
        uninstall
        return 0
    fi
    
    # Perform pre-installation checks
    print_status "Performing system checks..."
    check_macos
    check_curl
    check_dependencies
    test_connectivity
    check_homebrew
    
    # Check if already installed
    if [[ -f "$INSTALL_DIR/$SCRIPT_NAME" && "$FORCE" != "1" ]]; then
        print_warning "Pretty-ls is already installed at $INSTALL_DIR/$SCRIPT_NAME"
        print_status "Use --force to reinstall or --uninstall to remove"
        
        # Test existing installation
        test_installation
        return 0
    fi
    
    # Perform installation
    print_status "Starting installation..."
    create_install_dir
    download_script
    update_path
    test_installation
    
    echo
    print_success "Installation completed successfully!"
    echo
    echo "🎉 Pretty-ls (pls) is now installed!"
    echo
    echo "Usage:"
    echo "  pls              # List current directory"
    echo "  pls /path/to/dir # List specific directory"
    echo "  pls --help       # Show help"
    echo "  pls --version    # Show version"
    echo
    echo "For more information, visit:"
    echo "  https://github.com/KoDesigns/pretty-ls"
    echo
}

# Run main function
main "$@" 