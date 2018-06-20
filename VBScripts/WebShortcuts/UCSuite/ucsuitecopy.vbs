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
objFSO.Copyfile "UC Suite.lnk", strDesktop, boolOverwrite

Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run "\\metrolx01\backup\jxk5224\scripts\work-scripts\vbscripts\webshortcuts\ucsuite\ucsuiteappendname.vbs"
Set oShell = Nothing
