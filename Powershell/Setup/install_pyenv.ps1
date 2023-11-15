[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $PythonVersion
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
Set-StrictMode -Version Latest

function _runCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Command,
        [switch] $PassThru
    )

    try {
        if ( $PassThru ) {
            $res = Invoke-Expression $Command
        }
        else {
            Invoke-Expression $Command
        }

        if ( $LASTEXITCODE -ne 0 ) {
            $errorMessage = "'$Command' reported a non-zero status code [$LASTEXITCODE]."
            if ($PassThru) {
                $errorMessage += "`nOutput:`n$res"
            }
            throw $errorMessage
        }

        if ( $PassThru ) {
            return $res
        }
    }
    catch {
        $PSCmdlet.WriteError( $_ )
    }
}

function _addToUserPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $AppName,
        [Parameter(Mandatory = $true, Position = 1)]
        [string[]] $PathsToAdd
    )

    $pathEntries = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User) -split ";"

    $pathUpdated = $false
    foreach ( $pathToAdd in $PathsToAdd ) {
        if ( $pathToAdd -NotIn $pathEntries ) {
            $pathEntries += $pathToAdd
            $pathUpdated = $true
        }
    }
    if ( $pathUpdated ) {
        Write-Host "$($AppName): Updating %PATH%..." -f Green
        # Remove any duplicate or blank entries
        $cleanPaths = $pathEntries | Select-Object -Unique | Where-Object { -Not [string]::IsNullOrEmpty($_) }

        # Update the user-scoped PATH environment variable
        [System.Environment]::SetEnvironmentVariable("PATH", ($cleanPaths -join ";").TrimEnd(";"), [System.EnvironmentVariableTarget]::User)
        
        # Reload PATH in the current session, so we don't need to restart the console
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
    }
    else {
        Write-Host "$($AppName): PATH already setup." -f Cyan
    }
}

# Install pyenv
if ( -Not ( Test-Path $HOME/.pyenv ) ) {
    if ( $IsWindows ) {
        Write-Host "pyenv: Installing for Windows..." -f Green
        & git clone https://github.com/pyenv-win/pyenv-win.git $HOME/.pyenv
        if ($LASTEXITCODE -ne 0) {
            Write-Error "git reported a non-zero status code [$LASTEXITCODE] - check previous output."
        }
    }
    else {
        Write-Error "This script currently only supports Windows."
    }
}
else {
    Write-Host "pyenv: Already installed." -f Cyan
}

# Add pyenv to PATH
_addToUserPath "pyenv" @(
    "$HOME\.pyenv\pyenv-win\bin"
    "$HOME\.pyenv\pyenv-win\shims"
)

# Install default pyenv python version
$pyenvVersions = _runCommand "pyenv versions" -PassThru | Select-String $PythonVersion
if ( -Not ( $pyenvVersions ) ) {
    Write-Host "pyenv: Installing python version $PythonVersion..." -f Green
    _runCommand "pyenv install $PythonVersion"
}
else {
    Write-Host "pyenv: Python version $PythonVersion already installed." -f Cyan
}

# Set pyenv global version
$globalPythonVersion = _runCommand "pyenv global" -PassThru
if ( $globalPythonVersion -ne $PythonVersion ) {
    Write-Host "pyenv: Setting global python version: $PythonVersion" -f Green
    _runCommand "pyenv global $PythonVersion"
}
else {
    Write-Host "pyenv: Global python version already set: $globalPythonVersion" -f Cyan
}

# Update pip
_runCommand "python -m pip install --upgrade pip"

# Install pipx, pdm, black, cookiecutter
_runCommand "pip install pipx"
_runCommand "pip install pdm"
_runCommand "pip install black"
_runCommand "pip install cookiecutter"

# Inject PDM dependencies
# _runCommand "pipx inject pdm pdm-packer"
_runCommand "pipx inject pdm pdm-publish"
# https://github.com/carstencodes/pdm-bump
_runCommand "pdm self add [--pip-args=--user] pdm-bump"
# https://github.com/pdm-project/pdm-autoexport
# _runCommand "pipx inject pdm pdm-autoexport"
