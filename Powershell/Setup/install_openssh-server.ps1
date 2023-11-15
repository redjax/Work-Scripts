#Requires -RunAsAdministrator
try {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 
}
catch {
    Write-Error "Unhandled exception installing OpenSSH Server. Details: $($_.Exception.Message)"
}
