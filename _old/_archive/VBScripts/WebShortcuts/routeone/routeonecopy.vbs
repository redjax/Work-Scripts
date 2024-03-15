' copies the supplied shortcut to the desktop.

' ----------------------------------------------------------'

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' --------------------------------------------------

' Copy the shortcut to the Desktop

Const OverwriteExisting = True

LocalScrPath = objFSO.GetSpecialFolder(1) & "\"

boolOverwrite = False

' Copy Kronos shortcut to desktop
objFSO.CopyFile "routeone2.lnk", strDesktop, boolOverwrite
