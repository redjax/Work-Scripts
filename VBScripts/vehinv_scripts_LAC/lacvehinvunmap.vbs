' This script will remove the map created by the "metvehinvmap.vbs" script

' ----------------------------------------------------------'
Option Explicit
Dim objShell, objDesktop, objLink
Dim strAppPath, strWorkDir, strIconPath

' --------------------------------------------------

' Unmap the shortcut
Dim objNetwork, strRemoteShare
Set objNetwork = WScript.CreateObject("WScript.Network")
strRemoteShare = ""
objNetwork.RemoveNetworkDrive "S:"

WScript.Quit

' End of creating a desktop shortcut
