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

' Copy UC Suite shortcut to the desktop
boolOverwrite = False
objFSO.Copyfile "", strDesktop, boolOverwrite

Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run ""
Set oShell = Nothing
