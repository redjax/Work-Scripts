## ssh-keygen -t rsa -b 4096 -N '""'
param(
    [Switch]$Debug,
    [Switch]$DryRun,
    [String]$OutputDirectory = "$($HOME)\.ssh",
    [Switch]$Password
)

function Get-UserPassword {
    $securePassword = Read-Host "Enter your password" -AsSecureString
    return $securePassword
}

$debugStr = "[DEBUG]"
$errStr = "[ERROR]"
$dryRunStr = "[DRY-RUN]"
$noPwdStr = "-N '""'"

If ( $Debug ) {
    Write-Host "$($debugStr) Saving keys to directory: $($OutputDirectory)" -ForegroundColor Yellow
}

function Find-Directory {
    param(
        $Directory = $OutputDirectory
    )
    If ( -Not ( Test-Path -Path "$($Directory)" -PathType Container ) ) {
        If ( $Debug ) {
            Write-Host "$($debugStr) Output path does not exist: $($Directory)" -ForegroundColor Yellow
        }
    
        If ( $DryRun ) {
            Write-Host "$($dryRunStr) -DryRun enabled" -ForegroundColor Magenta
            Write-Host "$($dryRunStr) Would run command: mkdir $($Directory)" -ForegroundColor Magenta
        }
        else {
            If ( $Debug ) {
                Write-Host "$($debugStr) Directory not found: $($Directory). Creating now" -ForegroundColor Yellow
            }
            try {
                mkdir "$($Directory)"
            }
            catch {
                Write-Error "$($errStr) Unhandled exception creating directory: $($Directory). Details: $($_.Exception.Message)"

                exit 1
            }
        }
    }
    else {
        If ( $Debug ) {
            Write-Host "$($debugStr) Found output path: $($Directory)" -ForegroundColor Yellow
        }
    }

}

Find-Directory

$KeyPrepend = "epi_laptop"
$KeyAppend = "_id_rsa"

$KeyParts = @(
    "gitea",
    "github",
    "gitlab",
    "azdevops",
    "test"
)
$KeyNames = @()

$DefaultKey = "$($KeyPrepend)$($KeyAppend)"

If ( $Debug ) {
    Write-Host "$($debugStr) Default SSH Key: $($DefaultKey)" -ForegroundColor Yellow
}

ForEach ( $Part in $keyParts ) {
    # Combine the parts and handle double underscores
    $KeyName = "${KeyPrepend}_${part}_$keyAppend" -Replace "__", "_"
    $KeyNames += $KeyName
}

$KeyNames | ForEach-Object {

    If ( $Debug ) {
        Write-Host "$($debugStr) SSH Key: $($_)" -ForegroundColor Blue
    }

    $KeyPath = "$($OutputDirectory)\$($_)"
    $KeyPathExists = Test-Path $KeyPath -PathType Leaf

    If ( -Not $KeyPathExists ) {
        If ( $DryRun ) {
            Write-Host "$($dryRunStr) -Password flag detected. Would prompt user for password" -ForegroundColor Magenta
        }
        else {
            If ( $Password ) {
                Write-Host "-Password flag detected." -ForegroundColor Green
                Write-Host "Keyfile '$($_)' does not exist at $($KeyPath). Set a password for the keyfile" -ForegroundColor Green
                $keyfilePassword = Get-UserPassword

                If ( $Debug ) {
                    Write-Host "$($debugStr) Password saved to SecureString"
                }
            }
        }
    }

    If ( -Not $Password ) {
        $keygenCmd = "ssh-keygen -t rsa -b 4096 -f $($KeyPath) $($noPwdStr)"
    }
    else {
        If ( $DryRun ) {
            Write-Host "$($dryRunStr) Setting password '`example`'"
            $keyfilePassword = "example"
        }

        try {
            $keygenCmd = "ssh-keygen -t rsa -b 4096 -f $($KeyPath) -N `"$($keyfilePassword)`""
        }
        catch {
            Write-Error "$($errStr) Unable to set keygen command. Details: $($_.Exception.Message)"
        }
    }

    If ( $DryRun ) {
        If ( $Debug ) {
            Write-Host "$($debugStr)$($dryRunStr) SSH Key path: $($KeyPath)" -ForegroundColor Yellow
            Write-Host "$($debugStr)$($dryRunStr) Path exists: $($KeyPathExists)" -ForegroundColor Yellow
        }

        Write-Host "$($dryRunStr) Would run command: $($keygenCmd)"  -ForegroundColor Magenta
    }
    else {
        
        If ( $Debug ) {
            Write-Host "$($debugStr) SSH Key path: $($KeyPath)" -ForegroundColor Yellow
            Write-Host "$($debugStr) Path exists: $($KeyPathExists)" -ForegroundColor Yellow
        }

        If ( -Not ( Test-Path "$($KeyPath)" ) ) {
            Write-Host ""
            Write-Host "Keyfile does not exist at $($KeyPath). Creating now." -ForegroundColor Blue
            Write-Host ""

            try {
                Invoke-Command $keygenCmd
            }
            catch {
                Write-Error "$($errStr) Unhandled exception generating ssh key. Details: $($_.Exception.Message)"
            }
        }
        else {
            Write-Host "Keyfile already exists: $($KeyPath)" -ForegroundColor Blue
        }
    }
}