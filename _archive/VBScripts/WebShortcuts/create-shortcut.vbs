' Create shortcuts on a user's desktop, or in a specified folder
Dim objFSO, objShell, sourcedir, tardir, shortcut
Dim everyonedir, partsdir, salesdir, svcdir, iconsdir
Dim kronos, kronosico, compli, compliico, dealerdaily, helpdesk, ucsuite, metintra
Dim autoalert, mastermind, kbbico, vauto, vehinv

' Environment Setup
set objFSO = CreateObject("Scripting.FileSystemObject")
set objShell = CreateObject("WScript.Shell")
set objProcess = objShell.Environment("Process")

' Directory paths
sourcedir = ""
salesdir = sourcedir & "\sales\"
everyonedir = sourcedir & "\everyone\"
partsdir = sourcedir & "\parts\"
svcdir = sourceidr & "\service\"
iconsdir = sourcedir & "\icons\"

' User desktop object
strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' Shortcut paths
    ' Everyone shortcuts
kronos = everyonedir & ""
kronosico = everyonedir & ""
compli = everyonedir & ""
compliico = everyonedir & ""
dealerdaily = everyonedir & ""
helpdesk = everyonedir & ""
ucsuite = everyonedir & ""
metintra = everyonedir & ""

    ' Sales shortcuts
autoalert = salesdir & ""
mastermind = salesdir & ""
kbbico = salesdir & ""
vauto = salesdir & ""
vehinv = salesdir & ""


Sub copyShortcut(shortcut, dest)
    Const OverwriteExisting = True
    LocalScrPath = objFSO.GetSpecialFolder(1) & "\"
    boolOverwrite = False

    'Copy pay structure workbook shortcut to desktop
    objFSO.CopyFile shortcut, dest, boolOverwrite
End Sub


Call copyShortcut(vehinv, strDesktop)

Set oShell = Nothing
