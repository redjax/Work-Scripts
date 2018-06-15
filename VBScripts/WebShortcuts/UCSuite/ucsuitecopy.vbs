' copies the supplied shortcut to the desktop.

' ----------------------------------------------------------'

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

objProcess("SEE_MASK_NOZONECHECKS")=1

' --------------------------------------------------

' Copy the shortcut to the Desktop

Const OverwriteExisting = True

LocalScrPath = objFSO.GetSpecialFolder(1) & "\"

' Copy UC Suite shortcut to the desktop
objFSO.Copyfile "UC Suite.url", strDesktop, boolOverwrite

' Run the append script to keep a record of who's clicked the shortcut
'objShell.Run "ucsuiteAppendName.vbs /norestart",0,True
'objProcess.Remote("SEE_MASK_NOZONECHECKS")

boolOverwrite = False
