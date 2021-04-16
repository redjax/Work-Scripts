' This script will map the vehinv folder on metrolx01\mlx_carsales,
' and create a shortcut to the folder on the user's desktop.
' The script can be modified for different folder paths and desktop
' shortucts/icons.

' ----------------------------------------------------------'
Option Explicit
Dim objShell, objDesktop, objLink
Dim strAppPath, strWorkDir, strIconPath

' --------------------------------------------------

' Map the shortcut first
Dim objNetwork, strRemoteShare
Set objNetwork = WScript.CreateObject("WScript.Network")
strRemoteShare = ""
objNetwork.MapNetworkDrive "S:", strRemoteShare, False

' --------------------------------------------------

strWorkDir ="C:\Documents and Settings\%username%\Desktop"
strAppPath = "S:\"
strIconPath = "C:\Windows\system32\imageres.dll,-33"

Set objShell = CreateObject("WScript.Shell")
objDesktop = objShell.SpecialFolders("Desktop")
Set objLink = objShell.CreateShortcut(objDesktop & "\vehinv (metrolx01mlx_carsales) (S).lnk")

' ---------------------------------------------------
' Section which adds the shortcut's key properties

objLink.Description = ""
objLink.HotKey = "CTRL+SHIFT+X"
objLink.IconLocation = strIconPath
objLink.TargetPath = strAppPath
objLink.WindowStyle = 3
objLink.WorkingDirectory = strWorkDir
objLink.Save

WScript.Quit

' End of creating a desktop shortcut
