' Create shortcuts on a user's desktop, or in a specified folder
Dim objFSO, objShell, sourcedir, tardir, shortcut, everyonedir, partsdir, salesdir, svcdir, iconsdir
Dim kronos, kronosico, compli, compliico, dealerdaily, helpdesk, ucsuite

set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")

' Directory paths
set sourcedir = "\\metrolx01\backup\jxk5224\webshortcuts"
set salesdir = sourcedir & "\sales"
set everyonedir = sourcedir & "\everyone"
set partsdir = sourcedir & "\parts"
set svcdir = sourceidr & "\service"
set iconsdir = sourcedir & "\icons"

' Shortcut paths
set kronos = everyonedir & "Kronos - New.lnk"
set kronosico = everyonedir & "kronos2.ico"
set compli = everyonedir & "Compli.url"
set compliico = everyonedir & "Compli_Logo.ico"
set dealerdaily = everyonedir & "Dealer Daily.url"
set helpdesk = everyonedir & "Helpdesk.url"
set ucsuite = everyonedir & "UC Suite.lnk"

'set tardir = "c:\users\public\desktop\"

Sub copyShortcut(shortcut, dest)
    Const OverwriteExisting = True

    LocalScrPath = objFSO.GetSpecialFolder(1) & "\"

    boolOverwrite = False

    'Copy pay structure workbook shortcut to desktop
    objFSO.CopyFile shortcut, dest, boolOverwrite
End Sub

Set oShell = Nothing
