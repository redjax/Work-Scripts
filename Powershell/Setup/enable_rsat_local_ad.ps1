<# Enable RSAT Active Directory Lightweight Directory Services 

   This will let you open Active Directory on your local machine, as well as install Powershell
   modules like Get-ADUser.
#>
#Requires -RunAsAdministrator
try {
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0

    Write-Host "RSAT Active Directory capabilities enabled. Please reboot your computer when possible. Active Directory will not work until you reboot." -ForegroundColor Green
}
catch {
    Write-Error "Unhandled exception enabling RSAT AD LDS Tools. Details: $($_.Exception.Message)"
}
