# Pretty-ls (pls) - Windows PowerShell Installation Script
# Copyright (c) 2025 Pretty-ls Contributors
# Licensed under the Apache License, Version 2.0

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$Help
)

# Configuration
$Script:ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:ProjectDir = Split-Path -Parent $Script:ScriptDir
$Script:SourceScript = Join-Path $Script:ProjectDir "scripts\pls.ps1"
$Script:ModuleName = "PrettyLs"

# Show help
function Show-Help {
    $HelpText = @"
Pretty-ls (pls) - Windows PowerShell Installation Script

Usage:
    .\install-windows.ps1 [-Force] [-Help]

Parameters:
    -Force    Force reinstallation even if already installed
    -Help     Show this help message

This script will:
1. Install the Pretty-ls PowerShell module
2. Add it to your PowerShell profile
3. Create the 'pls' alias

"@
    Write-Host $HelpText
}

# Print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Check if running on Windows
function Test-Windows {
    if ($PSVersionTable.Platform -and $PSVersionTable.Platform -ne "Win32NT") {
        Write-Error "This installer is for Windows only. Use install-linux.sh or install-macos.sh for Unix systems."
        exit 1
    }
}

# Check PowerShell version
function Test-PowerShellVersion {
    $MinVersion = [Version]"5.1"
    $CurrentVersion = $PSVersionTable.PSVersion
    
    if ($CurrentVersion -lt $MinVersion) {
        Write-Error "PowerShell $MinVersion or higher is required. Current version: $CurrentVersion"
        exit 1
    }
    
    Write-Status "PowerShell version: $CurrentVersion"
}

# Get PowerShell modules directory
function Get-ModulesDirectory {
    $ModulesPath = Join-Path $env:USERPROFILE "Documents\PowerShell\Modules"
    
    # Fallback for Windows PowerShell
    if (-not (Test-Path $ModulesPath)) {
        $ModulesPath = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell\Modules"
    }
    
    return $ModulesPath
}

# Install the module
function Install-Module {
    $ModulesDir = Get-ModulesDirectory
    $ModuleDir = Join-Path $ModulesDir $Script:ModuleName
    
    Write-Status "Installing module to: $ModuleDir"
    
    # Check if source script exists
    if (-not (Test-Path $Script:SourceScript)) {
        Write-Error "Source script not found: $Script:SourceScript"
        exit 1
    }
    
    # Create module directory
    if (-not (Test-Path $ModuleDir)) {
        New-Item -ItemType Directory -Path $ModuleDir -Force | Out-Null
    }
    
    # Copy the script
    $DestinationScript = Join-Path $ModuleDir "$Script:ModuleName.psm1"
    Copy-Item $Script:SourceScript $DestinationScript -Force
    
    # Create module manifest
    $ManifestPath = Join-Path $ModuleDir "$Script:ModuleName.psd1"
    $ManifestContent = @"
@{
    ModuleVersion = '1.0.0'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author = 'Pretty-ls Contributors'
    CompanyName = 'Pretty-ls Project'
    Copyright = '(c) 2025 Pretty-ls Contributors. Licensed under Apache 2.0.'
    Description = 'A human-friendly and emoji-enhanced ls replacement for PowerShell'
    PowerShellVersion = '5.1'
    ProjectUri = 'https://github.com/KoDesigns/pretty-ls'
    LicenseUri = 'https://github.com/KoDesigns/pretty-ls/blob/main/LICENSE'
    Tags = @('ls', 'directory', 'listing', 'emoji', 'pretty', 'terminal')
    ReleaseNotes = 'Initial release of Pretty-ls PowerShell module'
    RootModule = '$Script:ModuleName.psm1'
    FunctionsToExport = @('Invoke-PrettyLs', 'Show-PlsVersion', 'Show-PlsHelp')
    AliasesToExport = @('pls', 'pretty-ls')
    PrivateData = @{
        PSData = @{
            Tags = @('ls', 'directory', 'listing', 'emoji', 'pretty')
            LicenseUri = 'https://www.apache.org/licenses/LICENSE-2.0'
            ProjectUri = 'https://github.com/KoDesigns/pretty-ls'
        }
    }
}
"@
    Set-Content -Path $ManifestPath -Value $ManifestContent -Encoding UTF8
    
    Write-Success "Module installed successfully"
}

# Update PowerShell profile
function Update-Profile {
    $ProfilePath = $PROFILE.CurrentUserAllHosts
    
    Write-Status "Updating PowerShell profile: $ProfilePath"
    
    # Create profile directory if it doesn't exist
    $ProfileDir = Split-Path $ProfilePath -Parent
    if (-not (Test-Path $ProfileDir)) {
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }
    
    # Check if module import already exists in profile
    $ImportLine = "Import-Module $Script:ModuleName -Force"
    
    if ((Test-Path $ProfilePath) -and (Get-Content $ProfilePath | Select-String -Pattern $Script:ModuleName -Quiet)) {
        Write-Status "Module import already exists in PowerShell profile"
        return
    }
    
    # Add module import to profile
    $ProfileContent = @"

# Added by Pretty-ls (pls) installer
Import-Module $Script:ModuleName -Force
"@
    
    Add-Content -Path $ProfilePath -Value $ProfileContent -Encoding UTF8
    Write-Success "Updated PowerShell profile"
}

# Test installation
function Test-Installation {
    Write-Status "Testing installation..."
    
    try {
        Import-Module $Script:ModuleName -Force -ErrorAction Stop
        
        if (Get-Command pls -ErrorAction SilentlyContinue) {
            Write-Success "Installation test passed! You can now use 'pls' command."
            
            # Show version
            Write-Status "Running pls -Version:"
            pls -Version
        } else {
            Write-Warning "Command 'pls' not found. You may need to restart PowerShell."
        }
    }
    catch {
        Write-Error "Failed to import module: $($_.Exception.Message)"
        Write-Status "You may need to restart PowerShell or run: Import-Module $Script:ModuleName"
    }
}

# Check if already installed
function Test-AlreadyInstalled {
    $ModulesDir = Get-ModulesDirectory
    $ModuleDir = Join-Path $ModulesDir $Script:ModuleName
    
    if ((Test-Path $ModuleDir) -and -not $Force) {
        Write-Warning "Pretty-ls is already installed. Use -Force to reinstall."
        
        try {
            Import-Module $Script:ModuleName -Force
            pls -Version
        }
        catch {
            Write-Status "Existing installation appears to be corrupted. Proceeding with reinstallation."
            return $false
        }
        
        return $true
    }
    
    return $false
}

# Main installation function
function Install-PrettyLs {
    Write-Host "🪟 Pretty-ls (pls) - Windows PowerShell Installer" -ForegroundColor Cyan
    Write-Host "=================================================" -ForegroundColor Cyan
    Write-Host ""
    
    if ($Help) {
        Show-Help
        return
    }
    
    Test-Windows
    Test-PowerShellVersion
    
    if (Test-AlreadyInstalled) {
        return
    }
    
    Install-Module
    Update-Profile
    Test-Installation
    
    Write-Host ""
    Write-Success "Installation completed!"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  pls              # List current directory"
    Write-Host "  pls C:\Path      # List specific directory"
    Write-Host "  pls -Help        # Show help"
    Write-Host "  pls -Version     # Show version"
    Write-Host ""
    Write-Warning "Please restart PowerShell to ensure all changes take effect."
}

# Run main function
Install-PrettyLs 