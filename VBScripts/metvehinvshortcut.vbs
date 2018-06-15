' This script functions differently from the "metvehinmap.vbs"
' script. Instead of creating a mapped drive, this script
' simply copies/creates a direct shortcut to the vehinv folder.

' ----------------------------------------------------------'

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' --------------------------------------------------
' Delete the previous map and delete desktop shortcut
Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run "\\metrolx01\backup\jxk5224\scripts\vbscripts\metvehinvunmap.vbs"
Set oShell = Nothing

' Copy the shortcut to the Desktop
boolOverwrite = False
objFSO.CopyFile "\\metrolx01\backup\jxk5224\WebShortcuts\Sales\vehinv.lnk", strDesktop, boolOverwrite

' Run the append script to keep a record of who's clicked the shortcut
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run "\\metrolx01\backup\jxk5224\scripts\vbscripts\appendNameMet.vbs"
Set oShell = Nothing
