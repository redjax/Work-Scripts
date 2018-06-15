' This script functions differently from the "metvehinmap.vbs"
' script. Instead of creating a mapped drive, this script
' simply copies/creates a direct shortcut to the vehinv folder.

' ----------------------------------------------------------'

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' --------------------------------------------------

' Copy the shortcut to the Desktop

boolOverwrite = False

objFSO.CopyFile "\\a8akg9p01\lac\lac_sales\LAC_Sales_Log.xlsx - Shortcut.lnk", strDesktop, boolOverwrite

' Run the append script to keep a record of who's clicked the shortcut
Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run "\\a8akg9p01\backup\jxk5224\Scripts\VBScripts\appendNameLac.vbs"
Set oShell = Nothing
