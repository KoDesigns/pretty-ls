# Pretty-ls (pls) - Windows PowerShell Installation Script
# Copyright (c) 2025 Pretty-ls Contributors
# Licensed under the Apache License, Version 2.0
#
# This script can be executed directly from the web:
# [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
# iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1'))
#
# Or using Invoke-RestMethod (PowerShell 3.0+):
# Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1')
#
# Or downloaded and run locally:
# Invoke-WebRequest 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1' -OutFile install.ps1
# .\install.ps1

[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$Help,
    [switch]$Verbose,
    [switch]$Debug,
    [switch]$Uninstall
)

# Configuration
$Script:Version = "1.0.0"
$Script:InstallDir = Join-Path $env:USERPROFILE ".local\bin"
$Script:ScriptName = "pls.ps1"
$Script:ModuleName = "PrettyLs"
$Script:GitHubRawUrl = "https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/scripts/pls.ps1"
$Script:GitHubApiUrl = "https://api.github.com/repos/KoDesigns/pretty-ls"

# Global variables
$Script:TempFile = $null

# Show help
function Show-Help {
    $HelpText = @"
Pretty-ls (pls) - Windows PowerShell Installation Script v$($Script:Version)

This script installs the pretty-ls command line tool on Windows systems.

USAGE:
    .\install-windows.ps1 [OPTIONS]

OPTIONS:
    -Help           Show this help message
    -Verbose        Enable verbose output
    -Debug          Enable debug output
    -Force          Force reinstallation even if already installed
    -Uninstall      Uninstall pretty-ls

EXAMPLES:
    # Install normally
    .\install-windows.ps1

    # Install with verbose output
    .\install-windows.ps1 -Verbose

    # Force reinstallation
    .\install-windows.ps1 -Force

    # Uninstall
    .\install-windows.ps1 -Uninstall

    # Web installation (recommended)
    iex (irm 'https://raw.githubusercontent.com/KoDesigns/pretty-ls/main/install/install-windows.ps1')

REQUIREMENTS:
    - Windows PowerShell 5.1+ or PowerShell 7+
    - Internet connection for downloading

"@
    Write-Host $HelpText
}

# Print colored output functions
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

function Write-ErrorMsg {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Debug {
    param([string]$Message)
    if ($Debug) {
        Write-Host "[DEBUG] $Message" -ForegroundColor Cyan
    }
}

# Error handling and cleanup
function Cleanup {
    if ($Script:TempFile -and (Test-Path $Script:TempFile)) {
        Remove-Item $Script:TempFile -Force -ErrorAction SilentlyContinue
        Write-Debug "Cleaned up temporary file: $Script:TempFile"
    }
}

# Register cleanup on exit
$null = Register-EngineEvent PowerShell.Exiting -Action { Cleanup }

# Trap for unexpected errors
trap {
    Write-ErrorMsg "Installation failed with error: $($_.Exception.Message)"
    Cleanup
    exit 1
}

# Check if running on Windows
function Test-Windows {
    if ($IsLinux -or $IsMacOS) {
        Write-ErrorMsg "This installer is for Windows only."
        Write-Status "For other platforms, visit: https://github.com/KoDesigns/pretty-ls"
        exit 1
    }
    Write-Debug "Operating system: Windows"
}

# Check PowerShell version
function Test-PowerShellVersion {
    $MinVersion = [Version]"5.1"
    $CurrentVersion = $PSVersionTable.PSVersion
    
    if ($CurrentVersion -lt $MinVersion) {
        Write-ErrorMsg "PowerShell $MinVersion or higher is required. Current version: $CurrentVersion"
        Write-Status "Please upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell"
        exit 1
    }
    
    Write-Debug "PowerShell version: $CurrentVersion"
}

# Test network connectivity
function Test-Connectivity {
    Write-Debug "Testing network connectivity to GitHub..."
    
    try {
        $null = Invoke-RestMethod -Uri "https://api.github.com" -TimeoutSec 10 -ErrorAction Stop
        Write-Debug "Network connectivity test passed"
    }
    catch {
        Write-ErrorMsg "Cannot connect to GitHub. Please check your internet connection."
        Write-Debug "Connectivity error: $($_.Exception.Message)"
        exit 1
    }
}

# Configure TLS/SSL settings for secure downloads
function Set-SecurityProtocol {
    try {
        # Enable TLS 1.2 and TLS 1.3 if available
        $protocols = [System.Net.SecurityProtocolType]::Tls12
        
        # Try to add TLS 1.3 if available (.NET 4.8+)
        try {
            $tls13 = [System.Net.SecurityProtocolType]::Tls13
            $protocols = $protocols -bor $tls13
        }
        catch {
            # TLS 1.3 not available, continue with TLS 1.2
        }
        
        [System.Net.ServicePointManager]::SecurityProtocol = $protocols
        Write-Debug "Security protocol configured: $([System.Net.ServicePointManager]::SecurityProtocol)"
    }
    catch {
        Write-Warning "Could not configure security protocol: $($_.Exception.Message)"
    }
}

# Get PowerShell modules directory
function Get-ModulesDirectory {
    # Prefer PowerShell Core location, fallback to Windows PowerShell
    $PowerShellCoreModules = Join-Path $env:USERPROFILE "Documents\PowerShell\Modules"
    $WindowsPowerShellModules = Join-Path $env:USERPROFILE "Documents\WindowsPowerShell\Modules"
    
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        # PowerShell Core/7
        if (-not (Test-Path $PowerShellCoreModules)) {
            New-Item -ItemType Directory -Path $PowerShellCoreModules -Force | Out-Null
        }
        return $PowerShellCoreModules
    }
    else {
        # Windows PowerShell
        if (-not (Test-Path $WindowsPowerShellModules)) {
            New-Item -ItemType Directory -Path $WindowsPowerShellModules -Force | Out-Null
        }
        return $WindowsPowerShellModules
    }
}

# Create installation directory
function New-InstallDirectory {
    if (-not (Test-Path $Script:InstallDir)) {
        Write-Status "Creating installation directory: $Script:InstallDir"
        try {
            New-Item -ItemType Directory -Path $Script:InstallDir -Force | Out-Null
        }
        catch {
            Write-ErrorMsg "Failed to create installation directory: $Script:InstallDir"
            Write-Debug "Directory creation error: $($_.Exception.Message)"
            exit 1
        }
    }
    Write-Debug "Installation directory ready: $Script:InstallDir"
}

# Download and verify script
function Get-PrettyLsScript {
    Write-Status "Downloading pls script from GitHub..."
    
    try {
        $Script:TempFile = [System.IO.Path]::GetTempFileName()
        
        # Download with retry logic
        $maxRetries = 3
        $retryCount = 0
        $downloaded = $false
        
        while (-not $downloaded -and $retryCount -lt $maxRetries) {
            try {
                Invoke-WebRequest -Uri $Script:GitHubRawUrl -OutFile $Script:TempFile -TimeoutSec 30 -ErrorAction Stop
                $downloaded = $true
                Write-Debug "Download successful on attempt $($retryCount + 1)"
            }
            catch {
                $retryCount++
                Write-Debug "Download attempt $retryCount failed: $($_.Exception.Message)"
                if ($retryCount -lt $maxRetries) {
                    Write-Status "Retrying download in 2 seconds..."
                    Start-Sleep -Seconds 2
                }
            }
        }
        
        if (-not $downloaded) {
            Write-ErrorMsg "Failed to download script from GitHub after $maxRetries attempts"
            Write-Status "URL: $Script:GitHubRawUrl"
            exit 1
        }
        
        # Verify the downloaded file
        if (-not (Test-Path $Script:TempFile) -or (Get-Item $Script:TempFile).Length -eq 0) {
            Write-ErrorMsg "Downloaded file is empty or missing"
            exit 1
        }
        
        # Basic validation - check if it looks like a PowerShell script
        $firstLine = Get-Content $Script:TempFile -TotalCount 1
        if ($firstLine -notmatch "^#.*PowerShell" -and $firstLine -notmatch "^function" -and $firstLine -notmatch "^param") {
            Write-ErrorMsg "Downloaded file does not appear to be a PowerShell script"
            exit 1
        }
        
        Write-Success "Script downloaded and verified successfully"
        
        $fileSize = (Get-Item $Script:TempFile).Length
        Write-Debug "Script size: $fileSize bytes"
    }
    catch {
        Write-ErrorMsg "Failed to download script: $($_.Exception.Message)"
        exit 1
    }
}

# Install as standalone script
function Install-StandaloneScript {
    $scriptPath = Join-Path $Script:InstallDir $Script:ScriptName
    
    Write-Status "Installing pls script to $scriptPath"
    
    try {
        Copy-Item $Script:TempFile $scriptPath -Force
        Write-Success "Script installed successfully"
    }
    catch {
        Write-ErrorMsg "Failed to install script to $scriptPath"
        Write-Debug "Installation error: $($_.Exception.Message)"
        exit 1
    }
}

# Install as PowerShell module
function Install-PowerShellModule {
    $modulesDir = Get-ModulesDirectory
    $moduleDir = Join-Path $modulesDir $Script:ModuleName
    
    Write-Status "Installing module to: $moduleDir"
    
    try {
        # Create module directory
        if (-not (Test-Path $moduleDir)) {
            New-Item -ItemType Directory -Path $moduleDir -Force | Out-Null
        }
        
        # Copy the script as module
        $moduleScript = Join-Path $moduleDir "$Script:ModuleName.psm1"
        Copy-Item $Script:TempFile $moduleScript -Force
        
        # Create module manifest
        $manifestPath = Join-Path $moduleDir "$Script:ModuleName.psd1"
        $manifestContent = @"
@{
    ModuleVersion = '$($Script:Version)'
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
        Set-Content -Path $manifestPath -Value $manifestContent -Encoding UTF8
        
        Write-Success "Module installed successfully"
    }
    catch {
        Write-ErrorMsg "Failed to install module: $($_.Exception.Message)"
        exit 1
    }
}

# Update PowerShell profile
function Update-PowerShellProfile {
    $profilePath = $PROFILE.CurrentUserAllHosts
    
    Write-Status "Updating PowerShell profile: $profilePath"
    
    try {
        # Create profile directory if it doesn't exist
        $profileDir = Split-Path $profilePath -Parent
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        
        # Check if module import already exists in profile
        $importLine = "Import-Module $Script:ModuleName -Force"
        
        if ((Test-Path $profilePath) -and (Get-Content $profilePath | Select-String -Pattern $Script:ModuleName -Quiet)) {
            Write-Status "Module import already exists in PowerShell profile"
            return
        }
        
        # Add module import to profile
        $profileContent = @"

# Added by Pretty-ls (pls) installer
Import-Module $Script:ModuleName -Force
"@
        
        Add-Content -Path $profilePath -Value $profileContent -Encoding UTF8
        Write-Success "Updated PowerShell profile"
        Write-Warning "Please restart PowerShell or run: . `$PROFILE"
    }
    catch {
        Write-Warning "Could not update PowerShell profile: $($_.Exception.Message)"
        Write-Status "You can manually import the module with: Import-Module $Script:ModuleName"
    }
}

# Add to PATH environment variable
function Update-PathEnvironment {
    Write-Status "Checking PATH environment variable..."
    
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    
    if ($currentPath -like "*$Script:InstallDir*") {
        Write-Status "$Script:InstallDir is already in your PATH"
        return
    }
    
    try {
        Write-Status "Adding $Script:InstallDir to user PATH"
        $newPath = "$Script:InstallDir;$currentPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        
        # Update current session PATH
        $env:PATH = "$Script:InstallDir;$env:PATH"
        
        Write-Success "Updated PATH environment variable"
        Write-Warning "You may need to restart your terminal for PATH changes to take effect"
    }
    catch {
        Write-Warning "Could not update PATH: $($_.Exception.Message)"
        Write-Status "You can manually add $Script:InstallDir to your PATH"
    }
}

# Test installation
function Test-Installation {
    Write-Status "Testing installation..."
    
    # Test standalone script
    $scriptPath = Join-Path $Script:InstallDir $Script:ScriptName
    if (Test-Path $scriptPath) {
        Write-Debug "Standalone script found at: $scriptPath"
    }
    
    # Test module installation
    try {
        Import-Module $Script:ModuleName -Force -ErrorAction Stop
        
        if (Get-Command pls -ErrorAction SilentlyContinue) {
            Write-Success "Installation test passed! You can now use 'pls' command."
            
            # Show version if available
            try {
                Write-Status "Version information:"
                pls -Version
            }
            catch {
                Write-Debug "Version command not available"
            }
        }
        else {
            Write-Warning "Command 'pls' not found. You may need to restart PowerShell."
        }
    }
    catch {
        Write-Warning "Failed to import module: $($_.Exception.Message)"
        Write-Status "You may need to restart PowerShell or run: Import-Module $Script:ModuleName"
    }
    
    # Basic functionality test
    if ($Verbose) {
        Write-Status "Testing basic functionality..."
        try {
            pls -Help | Out-Null
            Write-Debug "Help command works correctly"
        }
        catch {
            Write-Warning "Help command failed, but installation may still be functional"
        }
    }
}

# Check if already installed
function Test-ExistingInstallation {
    $moduleDir = Join-Path (Get-ModulesDirectory) $Script:ModuleName
    $scriptPath = Join-Path $Script:InstallDir $Script:ScriptName
    
    return (Test-Path $moduleDir) -or (Test-Path $scriptPath)
}

# Uninstall function
function Uninstall-PrettyLs {
    Write-Status "Uninstalling Pretty-ls..."
    
    $removed = $false
    
    # Remove module
    $moduleDir = Join-Path (Get-ModulesDirectory) $Script:ModuleName
    if (Test-Path $moduleDir) {
        try {
            Remove-Item $moduleDir -Recurse -Force
            Write-Success "Removed module: $moduleDir"
            $removed = $true
        }
        catch {
            Write-ErrorMsg "Failed to remove module: $($_.Exception.Message)"
        }
    }
    
    # Remove standalone script
    $scriptPath = Join-Path $Script:InstallDir $Script:ScriptName
    if (Test-Path $scriptPath) {
        try {
            Remove-Item $scriptPath -Force
            Write-Success "Removed script: $scriptPath"
            $removed = $true
        }
        catch {
            Write-ErrorMsg "Failed to remove script: $($_.Exception.Message)"
        }
    }
    
    if (-not $removed) {
        Write-Status "Pretty-ls was not found on this system"
    }
    
    # Note about manual cleanup
    Write-Warning "Note: PowerShell profile and PATH were not modified."
    Write-Status "If you want to remove profile modifications, edit your PowerShell profile manually:"
    Write-Status "  $($PROFILE.CurrentUserAllHosts)"
    
    Write-Success "Uninstallation completed!"
}

# Main installation function
function Install-PrettyLs {
    Write-Host "🪟 Pretty-ls (pls) - Windows Installer v$($Script:Version)" -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Handle help
    if ($Help) {
        Show-Help
        return
    }
    
    # Handle uninstall
    if ($Uninstall) {
        Uninstall-PrettyLs
        return
    }
    
    # Perform pre-installation checks
    Write-Status "Performing system checks..."
    Test-Windows
    Test-PowerShellVersion
    Set-SecurityProtocol
    Test-Connectivity
    
    # Check if already installed
    if ((Test-ExistingInstallation) -and -not $Force) {
        Write-Warning "Pretty-ls is already installed"
        Write-Status "Use -Force to reinstall or -Uninstall to remove"
        
        # Test existing installation
        Test-Installation
        return
    }
    
    # Perform installation
    Write-Status "Starting installation..."
    New-InstallDirectory
    Get-PrettyLsScript
    
    # Install both as module and standalone script
    Install-PowerShellModule
    Install-StandaloneScript
    Update-PowerShellProfile
    Update-PathEnvironment
    
    # Clean up temporary file
    Cleanup
    
    # Test installation
    Test-Installation
    
    Write-Host ""
    Write-Success "Installation completed successfully!"
    Write-Host ""
    Write-Host "🎉 Pretty-ls (pls) is now installed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  pls              # List current directory"
    Write-Host "  pls C:\path      # List specific directory"
    Write-Host "  pls -Help        # Show help"
    Write-Host "  pls -Version     # Show version"
    Write-Host ""
    Write-Host "For more information, visit:"
    Write-Host "  https://github.com/KoDesigns/pretty-ls"
    Write-Host ""
}

# Only run if script is executed directly (not sourced/imported)
if ($MyInvocation.InvocationName -ne '.' -and $MyInvocation.Line -notmatch '^\s*\.\s+') {
    Install-PrettyLs
} 