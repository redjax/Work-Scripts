' Script to copy shortcuts to the public desktop.
' This script is the "main" script, which will take
' arguments from other scripts to copy shortcuts
' to the desktop.

' -------------------Variables------------------------------'

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' -----------------Parameters-----------------------

Dim Arg, shortcut
Set Arg = WScript.Arguments

' -----------------------------------------------------

' Copy the shortcut to the Desktop

Const OverwriteExisting = True

LocalScrPath = objFSO.GetSpecialFolder(1) & "\"

' Copy Kronos icon to system32
objFSO.Copyfile "\\path\to\shortcut\shortcutfile.ico", LocalScrPath

boolOverwrite = False

' Copy Kronos shortcut to desktop
objFSO.CopyFile "\\path\to\shortcut.lnk", strDesktop, boolOverwrite
