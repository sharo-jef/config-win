<#
    .SYNOPSIS
    Setup windows environment.

    .DESCRIPTION
    Setup windows environment.

    .EXAMPLE
    PS> .\setup.ps1
#>

# Version check
if (!$PSVersionTable) {
    Write-Host -ForegroundColor Red "You need to use later version of PowerShell. (current: v1, required: >=6)"
    exit 1
} elseif ($PSVersionTable.PSVersion.Major -le 5) {
    Write-Host -ForegroundColor Red "You need to use later version of PowerShell. (current: v$($PSVersionTable.PSVersion.Major), required: >=6)"
    exit 1
}

# Setup
powershell -c '.\setup.ps1'

# Reload environment
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
$env:NVM_HOME = [System.Environment]::GetEnvironmentVariable('NVM_HOME', 'User')
$env:NVM_SYMLINK = [System.Environment]::GetEnvironmentVariable('NVM_SYMLINK', 'User')

# Set $profile
. $profile
