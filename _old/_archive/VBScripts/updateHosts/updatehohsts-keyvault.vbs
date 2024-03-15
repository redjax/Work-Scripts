' Launcher for updatehosts.vbs, specifically for
' updating hosts file to new KeyVault IP, when it changes.

Dim objShell
Set objShell = WScript.CreateObject("WScript.Shell")

objShell.Run "updatehosts.vbs <IP> <URL>>"
