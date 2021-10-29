<#
    .SYNOPSIS
    Setup windows environment.

    .DESCRIPTION
    Setup windows environment.

    .EXAMPLE
    PS> .\setup.ps1

    .EXAMPLE
    PS> .\setup.ps1 -Interactive
#>

Param([switch]$Interactive)

# Version check
if (!$PSVersionTable) {
    Write-Host -ForegroundColor Red "You need to use later version of PowerShell. (current: v1, required: [2..5])"
    exit 1
} elseif ($PSVersionTable.PSVersion.Major -ge 6) {
    Write-Host -ForegroundColor Red "You need to use older version of PowerShell. (current: v$($PSVersionTable.PSVersion.Major), required: [2..5])"
    exit 1
}

# Install scoop
where.exe scoop 2>&1 > $null
if (!$?) {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
} else {
    scoop update
}

# Install git
scoop install git

# Add buckets
scoop bucket add extras
scoop bucket add java

# Install packages w/ scoop
scoop install `
    7zip `
    aws `
    bottom `
    curl `
    dart `
    discord `
    fzf `
    genact `
    ghq `
    go `
    googlechrome `
    jq `
    lsd `
    lua `
    nvm `
    openjdk16 `
    peco `
    perl `
    pwsh `
    ruby `
    rust `
    slack `
    sqlite `
    starship `
    unxutils `
    unzip `
    vim `
    vscode `
    zip `

# Reload environment
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
$env:NVM_HOME = [System.Environment]::GetEnvironmentVariable('NVM_HOME', 'User')
$env:NVM_SYMLINK = [System.Environment]::GetEnvironmentVariable('NVM_SYMLINK', 'User')

# Install Node.js (latest)
if ($env:NVM_HOME -and (Test-Path -Path $env:NVM_HOME\settings.txt.original)) {
    Copy-Item -Path $env:NVM_HOME\settings.txt.original -Destination $env:NVM_HOME\settings.txt
}
nvm on
nvm install latest
nvm use newest
nvm current

# Install yarn
npm i -g yarn

# Copy .config
Copy-Item -Recurse -Path .\.config\* -Destination ~\.config\

# Set $profile
where.exe pwsh 2>&1 > $null
if ($?) {
    Copy-Item -Path .\profile -Destination (pwsh -c '$profile')
}
Copy-Item -Path .\profile -Destination $profile
. $profile

# Setup interactively
if ($Interactive) {
    # Git config
    git config --global user.name (Read-Host -Prompt 'git: user.name')
    git config --global user.email (Read-Host -Prompt 'git: user.email')
}

# Done
Write-Host -ForegroundColor Green Done
