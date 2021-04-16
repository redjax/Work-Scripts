' Chrome Update Fix Script
'
' If Chrome is stuck in a loop trying to update,
' change "RE.Pattern" variable to version number
' Chrome is stuck on, then run the script.
' ------------------------------------------------

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

Set RE = New RegExp  ' Init regex
RE.IgnoreCase = True  ' Tell regex to ignore character case

strProgFile="c:\program files (x86)\"  ' Program Files (x86)
strChromeFolder="google\chrome\application\"  ' Chrome application folder
strLoopFolder=strProgFile & strChromeFolder
RE.Pattern = "71.0.*"  ' Version Chrome is stuck on
strOldChrome=strLoopFolder & "chrome.exe"
strNewChrome=strLoopFolder & "new_chrome.exe"

' Remove old Chrome folder
RemoveOldDir strLoopFolder, RE.Pattern
' Rename new_chrome.exe to chrome.exe
fixShortcut strOldChrome, strNewChrome


Sub RemoveOldDir(scanDir, rePattern)
    ' Loops through scanDir, removes any found removeDir
    ' scanDir = directory to scan
    ' removeDir = directory to remove if found
    ' rePattern = regex to check removeDir against
    RE.Pattern = rePattern

    For Each oFile In objFSO.GetFolder(scanDir).SubFolders
        If RE.Test(oFile) Then objFSO.DeleteFolder(oFile)
    Next
End Sub


Sub fixShortcut(oldShortcut, newShortcut)
    ' Delete oldShortcut, rename newShortcut to oldShortcut
    objFSO.DeleteFile oldShortcut
    objFSO.MoveFile newShortcut, oldShortcut
End Sub
