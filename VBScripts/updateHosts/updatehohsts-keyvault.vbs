' Launcher for updatehosts.vbs, specifically for
' updating hosts file to new KeyVault IP, when it changes.

Dim objShell
Set objShell = WScript.CreateObject("WScript.Shell")

objShell.Run "updatehosts.vbs 172.28.4.7 keyvault.KeyVault.WebManagement"
