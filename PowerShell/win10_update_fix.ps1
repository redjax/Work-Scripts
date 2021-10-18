# Check if PowerShell being run as admin
# If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {    
#   Write-Output "This script needs to be run As Admin"
#   Break
# }

#Setting Scripts to Unrestricted - Will revert change at the end of the script
Set-ExecutionPolicy Unrestricted -force

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}
# Now running elevated so launch the script:
& ".\win10_update_fix.ps1"

## Vars

$DATASTORE_DIR = '%SYSTEMROOT%\SoftwareDistribution\DataStore'
$DOWNLOAD_DIR = '%SYSTEMROOT%\SoftwareDistribution\Download'
$CATROOT_DIR = '%SYSTEMROOT%\System32\catroot2'

$SERVICES_ARR = @('cryptSvc', 'bits', 'msiserver')
$DIRS_ARR = @($DATASTORE_DIR, $DOWNLOAD_DIR, $CATROOT_DIR)
$OLD_DIRS_ARR = @(-join($DATASTORE_DIR, ".old"), -join($DOWNLOAD_DIR, ".old"), -join($CATROOT_DIR, ".old"))


# Stop WUAUServ service if it's not stopped already
while (Get-Service -Name "WUAUServ" -ne "Stopped") {
    # Stop-Service -Name "WUAUServ" -Force
    Get-Service -DisplayName "WUAUServ" | Stop-Service -Force
}


# Loop over Services array, stop each service
ForEach ($SVC in $SERVICES_ARR) {
    # Stop-Service -Name $SVC
    Get-Service -DisplayName $SVC | Stop-Service -Force
}

ForEach ($DIR in $OLD_DIRS_ARR) {
    # Loop OLD_DIRS_ARR, remove directory if exists
    IF (Test-Path -Path $DIR) {
        # Path exists, delete
        Write-Output "Removing $DIR"
        Remove-Item $DIR
    } else {
        Write-Output "Path $DIR does not exist."
    }
}

ForEach ($DIR in $DIRS_ARR) {
    # Create backup of Windows Update directories
    If (Test-Path -Path $DIR) {
        # Path exists, create backup
        Move-Item $DIR -join($DIR, ".old")
    } else {
        Write-Output "Path $DIR does not exist."
    }
}

# Restart services
ForEach ($SVC in $SERVICES_ARR) {
    Get-Service -DisplayName $SVC | Start-Service
}
