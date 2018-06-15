' Lexus of Akron-Canton Showroom Computer Script
' Purpose: Ensure a set of icons/shortcuts are on every showroom
' computer at Lexus of Akron-Canton.
'
Option Explicit
Dim objShell, objDesktop, objLink, objProcess, objFSO
Dim strAppPath, strWorkDir, strIconPath
Dim firefoxPath64, firefoxPath32, iePath, chromePath

' --------------------------------------------------
' Variables
Set objFSO = CreateObject("Scripting.FileSystemObject")

firefoxPath64 = "C:\Program Files\Mozilla Firefox\firefox.exe"
firefoxPath32 = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
iePath = "C:\Program Files (x86)\Internet Explorer"
chromePath = "C:\Program Files (x86)\Google\Chrome\chrome.exe"

strWorkDir = objFSO.GetSpecialFolder(1) & "\"
' Use this if above doesn't work: strWorkDir = objFSO.GetSpecialFolder(1) & "\"
strAppPath = "" 'URL/Program Path, i.e. chromePath
strIconPath = "" ' Path to icon file

' --------------------------------------------------
' Shortcuts
Dim dealerDailyDesc, dealerDailyicon, dealerDailyTar, WshShell

' Dealer Daily
dealerDailyDesc = "Dealer Daily"
dealerDailyicon = "\\metrolx01\backup\jxk5224\WebShortcuts\akronshow\Icons\dealerDailyLogo.png"
dealerDailyTar = iePath

' --------------------------------------------------

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

WshShell = CreateObject("Wscript.shell")
objLink.Description = dealerDailyDesc
objLink.IconLocation = dealerDailyicon
ojbLink.TargetPath = dealerDailyTar
objLink.WindowStyle = 3
objLink.WorkingDirectory = strWorkDir
objLink.Save

WScript.Quit

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strDesktop = objProcess.Item("UserProfile") & "\Desktop\"

' ' --------------------------------------------------

' ' Copy the shortcut to the Desktop

' Const OverwriteExisting = True

' LocalScrPath = objFSO.GetSpecialFolder(1) & "\"

' ' Copy Kronos icon to system32
' objFSO.Copyfile "\\metrolx01\backup\jxk5224\WebShortcuts\kronos2.ico", LocalScrPath

' boolOverwrite = False

' ' Copy Kronos shortcut to desktop
' objFSO.CopyFile "\\metrolx01\backup\jxk5224\WebShortcuts\Kronos Cloud2.lnk", strDesktop, boolOverwrite
