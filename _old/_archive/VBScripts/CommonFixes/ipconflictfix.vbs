Dim oShell

Set oShell = WScript.CreateObject("WScript.Shell")

oShell.Run "..\..\Batch\ipconflictfix.bat", 1

Set oShell = Nothing
