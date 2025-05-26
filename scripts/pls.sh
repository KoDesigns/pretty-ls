#!/usr/bin/env bash

# Pretty-ls (pls) - A human-friendly ls replacement
# Copyright (c) 2025 Pretty-ls Contributors
# Licensed under the Apache License, Version 2.0

# Version
readonly PLS_VERSION="1.0.0"

# Configuration
readonly FOLDER_EMOJI="📁"
readonly FILE_EMOJI="📄"
readonly MAX_NAME_LENGTH=40
readonly HEADER_COLOR="\e[1;37m"  # Bold white
readonly RESET_COLOR="\e[0m"

# Color definitions
readonly COLOR_FOLDER="\e[36m"     # Cyan
readonly COLOR_SHELL="\e[32m"      # Green
readonly COLOR_TEXT="\e[33m"       # Yellow
readonly COLOR_MARKDOWN="\e[35m"   # Magenta
readonly COLOR_IMAGE="\e[34m"      # Blue
readonly COLOR_EXECUTABLE="\e[31m" # Red
readonly COLOR_DEFAULT="\e[0m"     # Default

# Function to convert string to uppercase (portable)
to_uppercase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Function to convert string to lowercase (portable)
to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Function to get file size in a cross-platform way
get_file_size() {
    local file="$1"
    local os="$2"
    
    if [[ "$os" == "macos" ]]; then
        stat -f "%z" "$file" 2>/dev/null || echo "0"
    else
        stat -c "%s" "$file" 2>/dev/null || echo "0"
    fi
}

# Function to get modification date in a cross-platform way
get_mod_date() {
    local file="$1"
    local os="$2"
    
    if [[ "$os" == "macos" ]]; then
        stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || echo "Unknown"
    else
        # Linux: Extract date and time, format as YYYY-MM-DD HH:MM
        stat -c "%y" "$file" 2>/dev/null | cut -d'.' -f1 | sed 's/T/ /' || echo "Unknown"
    fi
}

# Function to format file size
format_size() {
    local size="$1"
    
    if [[ "$size" -eq 0 ]]; then
        echo "     0 B"
    elif [[ "$size" -lt 1024 ]]; then
        printf "%6d B" "$size"
    elif [[ "$size" -lt 1048576 ]]; then
        printf "%6.1f KB" "$(echo "scale=1; $size / 1024" | bc -l 2>/dev/null || awk "BEGIN {printf \"%.1f\", $size/1024}")"
    elif [[ "$size" -lt 1073741824 ]]; then
        printf "%6.1f MB" "$(echo "scale=1; $size / 1048576" | bc -l 2>/dev/null || awk "BEGIN {printf \"%.1f\", $size/1048576}")"
    else
        printf "%6.1f GB" "$(echo "scale=1; $size / 1073741824" | bc -l 2>/dev/null || awk "BEGIN {printf \"%.1f\", $size/1073741824}")"
    fi
}

# Function to get file color based on extension
get_file_color() {
    local ext="$1"
    local ext_lower
    ext_lower=$(to_lowercase "$ext")
    
    case "$ext_lower" in
        sh|bash|zsh)
            echo "$COLOR_SHELL"
            ;;
        txt|log)
            echo "$COLOR_TEXT"
            ;;
        md|markdown|rst)
            echo "$COLOR_MARKDOWN"
            ;;
        jpg|jpeg|png|gif|bmp|svg|webp)
            echo "$COLOR_IMAGE"
            ;;
        exe|bin|app|deb|rpm|dmg)
            echo "$COLOR_EXECUTABLE"
            ;;
        *)
            echo "$COLOR_DEFAULT"
            ;;
    esac
}

# Function to truncate long names
truncate_name() {
    local name="$1"
    local max_length="$2"
    
    if [[ ${#name} -gt $max_length ]]; then
        echo "${name:0:$((max_length - 1))}…"
    else
        echo "$name"
    fi
}

# Main pls function
pls() {
    local target_dir="${1:-.}"
    local os
    
    # Check if target directory exists
    if [[ ! -d "$target_dir" ]]; then
        echo "Error: Directory '$target_dir' does not exist." >&2
        return 1
    fi
    
    # Detect operating system
    os=$(detect_os)
    if [[ "$os" == "unknown" ]]; then
        echo "Warning: Unsupported operating system. Some features may not work correctly." >&2
    fi
    
    # Change to target directory
    local original_dir="$PWD"
    cd "$target_dir" || return 1
    
    echo ""  # Top padding
    
    # Print header
    printf "${HEADER_COLOR}%-12s %-45s %10s   %s${RESET_COLOR}\n" "Type" "Name" "Size" "Modified"
    printf "%s\n" "--------------------------------------------------------------------------------"
    
    # Process entries
    local entry_count=0
    for entry in * .*; do
        # Skip . and .. and non-existent files (in case of no matches)
        [[ "$entry" == "." || "$entry" == ".." ]] && continue
        [[ ! -e "$entry" ]] && continue
        
        local type_label size color mod_date name
        
        if [[ -d "$entry" ]]; then
            type_label="${FOLDER_EMOJI} Folder"
            size="<DIR>"
            color="$COLOR_FOLDER"
            mod_date=$(get_mod_date "$entry" "$os")
        elif [[ -f "$entry" ]]; then
            local ext="${entry##*.}"
            [[ "$ext" == "$entry" ]] && ext=""  # No extension
            
            if [[ -n "$ext" ]]; then
                type_label="${FILE_EMOJI} $(to_uppercase "$ext")"
            else
                type_label="${FILE_EMOJI} FILE"
            fi
            
            color=$(get_file_color "$ext")
            
            local file_size
            file_size=$(get_file_size "$entry" "$os")
            size=$(format_size "$file_size")
            mod_date=$(get_mod_date "$entry" "$os")
        else
            continue  # Skip special files
        fi
        
        # Truncate long names
        name=$(truncate_name "$entry" "$MAX_NAME_LENGTH")
        
        # Print with color
        printf "${color}%-12s %-45s %10s   %s${RESET_COLOR}\n" "$type_label" "$name" "$size" "$mod_date"
        ((entry_count++))
    done
    
    echo ""  # Bottom padding
    
    # Show summary if no entries found
    if [[ $entry_count -eq 0 ]]; then
        echo "No files or directories found."
    fi
    
    # Return to original directory
    cd "$original_dir" || return 1
}

# Show version
pls_version() {
    echo "Pretty-ls (pls) version $PLS_VERSION"
    echo "Copyright (c) 2025 Pretty-ls Contributors"
    echo "Licensed under the Apache License, Version 2.0"
}

# Show help
pls_help() {
    cat << EOF
Pretty-ls (pls) - A human-friendly ls replacement

Usage:
    pls [directory]     List contents of directory (default: current directory)
    pls --version       Show version information
    pls --help          Show this help message

Features:
    📁 Folder and 📄 file emoji icons
    🎨 Color-coded output based on file type
    📏 Truncates long names for clean display
    📊 Shows file sizes in human-readable format
    🕒 Displays modification dates
    🖥️  Cross-platform support (macOS, Linux)

Examples:
    pls                 # List current directory
    pls /home/user      # List specific directory
    pls ~/Documents     # List Documents folder

EOF
}

# Handle command line arguments
case "${1:-}" in
    --version|-v)
        pls_version
        ;;
    --help|-h)
        pls_help
        ;;
    *)
        pls "$@"
        ;;
esac 