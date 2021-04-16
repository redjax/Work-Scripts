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

' Remove the desktop shortcut
Set Shell = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")
DesktopPath = Shell.SpecialFolders("Desktop")
FSO.DeleteFile DesktopPath & ""

WScript.Quit

' End of creating a desktop shortcut
