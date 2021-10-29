########################################################
# General
########################################################
[System.Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
[System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
$env:LESSCHARSET = "utf-8"

########################################################
# Posh
########################################################
# Import-Module posh-git
# Import-Module oh-my-posh
# Set-PoshPrompt -Theme space

########################################################
# Starship
########################################################
Invoke-Expression (&starship init powershell)

########################################################
# Auto suggestions
########################################################
Import-Module PSReadLine
try {
    Set-PSReadLineOption -PredictionSource History
} catch {}

########################################################
# Linux commands
########################################################
Get-Command Remove-Alias 2>&1 > $null
if ($?) {
    Remove-Alias -Force sl 2>&1 > $null
}
Set-Alias -Name ls -Option AllScope lsd
Set-Alias -Name open -Option AllScope explorer
Set-Alias -Name python3 -Option AllScope python
Set-Alias -Name which -Option AllScope where.exe

function export() {
    ($key, $value) = $args[0] -split "=";
    Set-Item "env:${key}" $value;
}

function unset() {
    $key = $args[0];
    Remove-Item "env:${key}";
}

function touch() {
    if (Test-Path $args[0]) {
        (Get-Item $args[0]).LastWriteTime = (Get-Date);
    } else {
        New-Item -Type File $args[0] > $null;
    }
}

function ghd() {
    # $d = ghq list | fzf --preview "pwsh -c ls -l $(ghq root)/{}"
    $d = ghq list | fzf --preview "cd $(ghq root)/{} & powershell -c ls"
    if ($d) {
        Push-Location "$(ghq root)/$d"
    }
}

function hi() {
    # $c = Get-Content -path (Get-PSReadlineOption).HistorySavePath | Select-Object -Unique | peco
    $c = Get-Content -path (Get-PSReadlineOption).HistorySavePath | Select-Object -Unique | fzf
    if ($c) {
        Invoke-Expression $c
    }
}

function env() {
    $env:Path -split ';'
}

########################################################
# Princess Connect ReDive
########################################################
# reg add HKCU\SOFTWARE\Cygames\PrincessConnectReDive /v "Screenmanager Fullscreen mode_h3630240806" /t REG_DWORD /d 3 /f
