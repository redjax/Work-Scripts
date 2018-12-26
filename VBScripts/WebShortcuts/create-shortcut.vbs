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
sourcedir = "\\metrolx01\backup\jxk5224\webshortcuts"
salesdir = sourcedir & "\sales\"
everyonedir = sourcedir & "\everyone\"
partsdir = sourcedir & "\parts\"
svcdir = sourceidr & "\service\"
iconsdir = sourcedir & "\icons\"

' User desktop object
strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' Shortcut paths
    ' Everyone shortcuts
kronos = everyonedir & "Kronos - New.lnk"
kronosico = everyonedir & "kronos2.ico"
compli = everyonedir & "Compli.url"
compliico = everyonedir & "Compli_Logo.ico"
dealerdaily = everyonedir & "Dealer Daily.url"
helpdesk = everyonedir & "Helpdesk.url"
ucsuite = everyonedir & "UC Suite.lnk"
metintra = everyonedir & "Intranet-MET.lnk"

    ' Sales shortcuts
autoalert = salesdir & "AutoAlert Client Portfolio Management.url"
mastermind = salesdir & "Mastermind.lnk"
kbbico = salesdir & "KBB Instant Cash Offer.url"
vauto = salesdir & "vAuto Login.url"
vehinv = salesdir & "vehinv.lnk"


Sub copyShortcut(shortcut, dest)
    Const OverwriteExisting = True
    LocalScrPath = objFSO.GetSpecialFolder(1) & "\"
    boolOverwrite = False

    'Copy pay structure workbook shortcut to desktop
    objFSO.CopyFile shortcut, dest, boolOverwrite
End Sub


Call copyShortcut(vehinv, strDesktop)

Set oShell = Nothing
