# Pretty-ls (pls) - A human-friendly ls replacement for PowerShell
# Copyright (c) 2025 Pretty-ls Contributors
# Licensed under the Apache License, Version 2.0

# Version
$Script:PLS_VERSION = "1.0.0"

# Configuration
$Script:FOLDER_EMOJI = [char]::ConvertFromUtf32(0x1F4C1)  # 📁
$Script:FILE_EMOJI = [char]::ConvertFromUtf32(0x1F4C4)    # 📄
$Script:MAX_NAME_LENGTH = 40

# Function to format file size
function Format-FileSize {
    param([long]$Size)
    
    if ($Size -eq 0) {
        return "     0 B"
    } elseif ($Size -lt 1KB) {
        return "{0,6} B" -f $Size
    } elseif ($Size -lt 1MB) {
        return "{0,6:N1} KB" -f ($Size / 1KB)
    } elseif ($Size -lt 1GB) {
        return "{0,6:N1} MB" -f ($Size / 1MB)
    } else {
        return "{0,6:N1} GB" -f ($Size / 1GB)
    }
}

# Function to get file color based on extension
function Get-FileColor {
    param([string]$Extension)
    
    switch -Regex ($Extension.ToLower()) {
        '\.ps1|\.bat|\.cmd|\.sh' { return 'Green' }
        '\.txt|\.log' { return 'Yellow' }
        '\.md|\.markdown|\.rst' { return 'Magenta' }
        '\.(jpg|jpeg|png|gif|bmp|svg|webp)' { return 'Blue' }
        '\.(exe|msi|app|deb|rpm|dmg)' { return 'Red' }
        default { return 'Gray' }
    }
}

# Function to truncate long names
function Get-TruncatedName {
    param(
        [string]$Name,
        [int]$MaxLength = $Script:MAX_NAME_LENGTH
    )
    
    if ($Name.Length -gt $MaxLength) {
        return $Name.Substring(0, $MaxLength - 1) + "…"
    }
    return $Name
}

# Main pls function
function Invoke-PrettyLs {
    param(
        [string]$Path = ".",
        [switch]$Help,
        [switch]$Version
    )
    
    # Handle help and version flags
    if ($Help) {
        Show-PlsHelp
        return
    }
    
    if ($Version) {
        Show-PlsVersion
        return
    }
    
    # Validate path
    if (-not (Test-Path -Path $Path -PathType Container)) {
        Write-Error "Error: Directory '$Path' does not exist."
        return
    }
    
    # Resolve path to absolute path
    $ResolvedPath = Resolve-Path -Path $Path
    
    Write-Host ""  # Top padding
    
    # Header
    $HeaderFormat = "{0,-12} {1,-45} {2,10}   {3}"
    Write-Host ($HeaderFormat -f "Type", "Name", "Size", "Modified") -ForegroundColor White
    Write-Host ("-" * 80)
    
    # Get items and process them
    try {
        $Items = Get-ChildItem -Path $ResolvedPath -Force -ErrorAction Stop
        $EntryCount = 0
        
        foreach ($Item in $Items) {
            $Name = Get-TruncatedName -Name $Item.Name
            $Date = $Item.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
            
            if ($Item.PSIsContainer) {
                $TypeLabel = "$Script:FOLDER_EMOJI Folder"
                $Size = "<DIR>"
                $Color = 'Cyan'
            } else {
                $Extension = if ($Item.Extension) { $Item.Extension.Substring(1).ToUpper() } else { "FILE" }
                $TypeLabel = "$Script:FILE_EMOJI $Extension"
                $Size = Format-FileSize -Size $Item.Length
                $Color = Get-FileColor -Extension $Item.Extension
            }
            
            $LineFormat = "{0,-12} {1,-45} {2,10}   {3}"
            Write-Host ($LineFormat -f $TypeLabel, $Name, $Size, $Date) -ForegroundColor $Color
            $EntryCount++
        }
        
        if ($EntryCount -eq 0) {
            Write-Host "No files or directories found."
        }
    }
    catch {
        Write-Error "Error accessing directory: $($_.Exception.Message)"
        return
    }
    
    Write-Host ""  # Bottom padding
}

# Show version information
function Show-PlsVersion {
    Write-Host "Pretty-ls (pls) version $Script:PLS_VERSION"
    Write-Host "Copyright (c) 2025 Pretty-ls Contributors"
    Write-Host "Licensed under the Apache License, Version 2.0"
}

# Show help information
function Show-PlsHelp {
    $HelpText = @"
Pretty-ls (pls) - A human-friendly ls replacement for PowerShell

Usage:
    pls [directory]     List contents of directory (default: current directory)
    pls -Version        Show version information
    pls -Help           Show this help message

Features:
    📁 Folder and 📄 file emoji icons
    🎨 Color-coded output based on file type
    📏 Truncates long names for clean display
    📊 Shows file sizes in human-readable format
    🕒 Displays modification dates
    🖥️  Windows PowerShell support

Examples:
    pls                 # List current directory
    pls C:\Users        # List specific directory
    pls ~\Documents     # List Documents folder

"@
    Write-Host $HelpText
}

# Create aliases for the function
Set-Alias -Name pls -Value Invoke-PrettyLs -Force
Set-Alias -Name pretty-ls -Value Invoke-PrettyLs -Force

# Export the function and aliases
Export-ModuleMember -Function Invoke-PrettyLs, Show-PlsVersion, Show-PlsHelp -Alias pls, pretty-ls 