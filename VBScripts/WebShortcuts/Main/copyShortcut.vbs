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
objFSO.Copyfile "\\metrolx01\backup\jxk5224\WebShortcuts\kronos2.ico", LocalScrPath

boolOverwrite = False

' Copy Kronos shortcut to desktop
objFSO.CopyFile "\\metrolx01\backup\jxk5224\WebShortcuts\Kronos Cloud2.lnk", strDesktop, boolOverwrite
