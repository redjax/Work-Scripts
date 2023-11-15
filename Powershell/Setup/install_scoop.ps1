#Requires -RunAsAdministrator
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
}
catch {
    Write-Error "Failed to set ExecutionPolicy. Details: $($_.Exception.Message)"
}
try {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}
catch {
    Write-Error "Failed to install Scoop from URL. Details: $($_.Exception.Message)"
}
