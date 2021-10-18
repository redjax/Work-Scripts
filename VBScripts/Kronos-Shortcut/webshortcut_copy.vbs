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

' Copy Kronos icon to system32
objFSO.Copyfile "\\path\to\shortcuticon.ico", LocalScrPath

boolOverwrite = False

' Copy Kronos shortcut to desktop
objFSO.CopyFile "\\path\to\shortcut.lnk", strDesktop, boolOverwrite
