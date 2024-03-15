Option Explicit
Dim objShell, objDesktop, objLink
Dim strAppPath, strWorkDir, strIconPath, strUrlPath

' --------------------------------------------------
' firefoxPath64 = "C:\Program Files\Mozilla Firefox\firefox.exe"
' firefoxPath32 = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
' iePath = "C:\Program Files (x86)\Internet Explorer"
' chromePath = "C:\Program Files (x86)\Google\Chrome\chrome.exe"

strWorkDir ="C:\windows"
strAppPath = "C:\Program Files (x86)\Internet Explorer\iexplore.exe"
strUrlPath = ""
strIconPath = ""
Set objShell = CreateObject("WScript.Shell")
objDesktop = objShell.SpecialFolders("Desktop" & "\test")
Set objLink = objShell.CreateShortcut(objDesktop & "\.lnk")

' ---------------------------------------------------
' Section which adds the shortcut's key properties

objLink.Description = "Dealer Daily"
objLink.IconLocation = strIconPath
objLink.WorkingDirectory = strAppPath
objLink.TargetPath = strUrlPath
objLink.WindowStyle = 3
objLink.WorkingDirectory = strWorkDir
objLink.Save

WScript.Quit
