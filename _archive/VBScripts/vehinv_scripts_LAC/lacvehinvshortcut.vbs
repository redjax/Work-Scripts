' This script functions differently from the "lacvehinmap.vbs"
' script. Instead of creating a mapped drive, this script
' simply copies/creates a direct shortcut to the vehinv folder.

' ----------------------------------------------------------'

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' --------------------------------------------------
' Unmap the vehinv folder
Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run ""
Set oShell = Nothing

' Copy the vehinv shortcut to the desktop
boolOverwrite = False
objFSO.CopyFile "", strDesktop, boolOverwrite

' Run the append script to keep a record of who's clicked the shortcut
Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run ""
Set oShell = Nothing
