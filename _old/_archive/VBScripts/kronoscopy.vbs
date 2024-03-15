' copies the supplied shortcut to the desktop.

' ----------------------------------------------------------'

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

' strDesktop = objProcess.Item("UserProfile") & "\Desktop\"
' strPubDesktop = WshShell.ExpandEnvironmentStrings("%PUBLIC%" + "\desktop")
strPubDesktop = objProcess.Item("C:\Users\public\desktop")

' --------------------------------------------------

' Copy the shortcut to the Desktop

Const OverwriteExisting = True

LocalScrPath = objFSO.GetSpecialFolder(1) & "\"

' Copy Kronos icon to system32
objFSO.Copyfile "", LocalScrPath

boolOverwrite = False

' Copy Kronos shortcut to desktop
objFSO.CopyFile "", strPubDesktop, boolOverwrite

' Run the append script to keep a record of who's clicked the shortcut
Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run ""
Set oShell = Nothing
