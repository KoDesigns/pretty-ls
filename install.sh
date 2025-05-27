#!/usr/bin/env bash

# Pretty-ls (pls) - Universal Installation Script
# Copyright (c) 2025 Pretty-ls Contributors
# Licensed under the Apache License, Version 2.0
#
# This script detects your platform and installs the appropriate version of pretty-ls.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash
#
# Or download and run locally:
#   curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh -o install.sh && bash install.sh

set -euo pipefail

# Configuration
readonly SCRIPT_VERSION="1.0.0"
readonly GITHUB_BASE_URL="https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install"

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

# Show help
show_help() {
    cat << EOF
Pretty-ls (pls) - Universal Installation Script v${SCRIPT_VERSION}

This script detects your platform and installs the appropriate version of pretty-ls.

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    -d, --debug     Enable debug output
    --force         Force reinstallation
    --uninstall     Uninstall pretty-ls

EXAMPLES:
    # Install normally (recommended)
    curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash

    # Install with verbose output
    curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh | bash -s -- --verbose

    # Download and run locally
    curl -fsSL https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install.sh -o install.sh
    chmod +x install.sh
    ./install.sh

SUPPORTED PLATFORMS:
    - Linux (x86_64, arm64)
    - macOS (Intel, Apple Silicon)
    - Windows (PowerShell)

For more information, visit:
    https://github.com/KoDesigns/pretty-ls

EOF
}

# Parse command line arguments
parse_args() {
    VERBOSE=0
    DEBUG=0
    FORCE=0
    UNINSTALL=0

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
            --force)
                FORCE=1
                shift
                ;;
            --uninstall)
                UNINSTALL=1
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

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "macos" ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *)
            print_error "Unsupported operating system: $(uname -s)"
            print_status "Pretty-ls supports Linux, macOS, and Windows."
            print_status "Visit https://github.com/KoDesigns/pretty-ls for manual installation."
            exit 1
            ;;
    esac
}

# Check if curl is available
check_curl() {
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required but not installed."
        print_status "Please install curl using your package manager."
        exit 1
    fi
    print_debug "curl version: $(curl --version | head -n1)"
}

# Download and execute platform-specific installer
install_for_platform() {
    local os="$1"
    local installer_url=""
    local installer_args=""
    
    # Build installer arguments
    if [[ "$VERBOSE" == "1" ]]; then
        installer_args="$installer_args --verbose"
    fi
    if [[ "$DEBUG" == "1" ]]; then
        installer_args="$installer_args --debug"
    fi
    if [[ "$FORCE" == "1" ]]; then
        installer_args="$installer_args --force"
    fi
    if [[ "$UNINSTALL" == "1" ]]; then
        installer_args="$installer_args --uninstall"
    fi
    
    case "$os" in
        linux)
            installer_url="$GITHUB_BASE_URL/install-linux.sh"
            print_status "Downloading and running Linux installer..."
            ;;
        macos)
            installer_url="$GITHUB_BASE_URL/install-macos.sh"
            print_status "Downloading and running macOS installer..."
            ;;
        windows)
            print_error "Windows detected, but this script is for Unix-like systems."
            print_status "For Windows installation, use PowerShell:"
            print_status "  iex (irm 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1')"
            print_status ""
            print_status "Or download and run manually:"
            print_status "  Invoke-WebRequest 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1' -OutFile install.ps1"
            print_status "  .\\install.ps1"
            exit 1
            ;;
        *)
            print_error "Unsupported platform: $os"
            exit 1
            ;;
    esac
    
    print_debug "Installer URL: $installer_url"
    print_debug "Installer args: $installer_args"
    
    # Download and execute the platform-specific installer
    if ! curl -fsSL \
        --connect-timeout 30 \
        --retry 3 \
        --retry-delay 2 \
        --retry-max-time 60 \
        --proto '=https' \
        --tlsv1.2 \
        "$installer_url" | bash -s -- $installer_args; then
        print_error "Failed to download or execute platform-specific installer"
        print_status "You can try downloading the installer manually:"
        print_status "  $installer_url"
        exit 1
    fi
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

# Main function
main() {
    echo "🌍 Pretty-ls (pls) - Universal Installer v${SCRIPT_VERSION}"
    echo "=========================================================="
    echo

    # Parse command line arguments
    parse_args "$@"

    # Detect platform and run checks
    print_status "Detecting platform..."
    local os
    os=$(detect_os)
    check_curl
    test_connectivity

    print_status "Platform: $(uname -s) $(uname -m) → $os installer"
    
    if [[ "$VERBOSE" == "1" ]]; then
        print_status "System details:"
        print_status "  Kernel: $(uname -r)"
        if command -v lsb_release >/dev/null 2>&1; then
            print_status "  Distribution: $(lsb_release -d -s 2>/dev/null || echo "unknown")"
        fi
    fi

    echo

    # Run platform-specific installer
    install_for_platform "$os"
}

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 