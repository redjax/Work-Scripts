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

objFSO.CopyFile "\\metrolx01\mlx_carsales\saleslogs\MLX_Sales_Log.xlsx - Shortcut.lnk", strDesktop, boolOverwrite

' Run the append script to keep a record of who's clicked the shortcut
Dim oShell
Set oShell = Wscript.CreateObject("WScript.Shell")
oShell.Run "\\metrolx01\backup\jxk5224\scripts\vbscripts\saleslogreport\slappendNameMet.vbs"
Set oShell = Nothing
