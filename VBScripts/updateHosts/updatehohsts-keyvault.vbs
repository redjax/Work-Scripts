' Launcher for updatehosts.vbs, specifically for
' updating hosts file to new KeyVault IP, when it changes.

Dim objShell
Set objShell = WScript.CreateObject("WScript.Shell")

' Example URL string below, change to match your host
objShell.Run "updatehosts.vbs 172.28.4.7 keyvault.KeyVault.WebManagement"
