$WingetPowershell = "winget install --id Microsoft.Powershell --source winget"

Write-Host "Running Powershell install/update command"

Invoke-Expression $WingetPowershell