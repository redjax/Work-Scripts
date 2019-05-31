' copies the supplied shortcut to the desktop.

' ----------------------------------------------------------'
Option Explicit

Dim objFSO, objShell, objProcess, RE, objNetwork
Dim strDesktop, strServerFolder, strKronosIco, strKronosIcoPath, strKronosLnk, strKronosLnkPath
Dim LocalScrPath, boolOverwrite
Dim strPCName, strUser, strTextfile


Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")
Set objNetwork = CreateObject("WScript.Network")

Set RE = New RegExp
RE.IgnoreCase = True

' strDesktop = objProcess.Item("UserProfile") & "\Desktop"
strDesktop = "C:\Users\public\Desktop\"
strServerFolder = "\\metrolx01\backup\jxk5224\Access\WebShortcuts\"
' Kronos items
strKronosIco = "kronos2.ico"
strKronosIcoPath = strServerFolder & strKronosIco
strKronosLnk = "Kronos - New.lnk"
strKronosLnkPath = strServerFolder & strKronosLnk

' Any old Kronos shortcut
RE.Pattern = "kronos *"

strPCName = objShell.ExpandEnvironmentStrings("%COMPUTERNAME%")
strUser = objNetwork.UserName
strTextfile = "kronosreport.txt"

' --------------------------------------------------
Const OverwriteExisting = True

LocalScrPath = objFSO.GetSpecialFolder(1) & "\"  ' system32 folder

' Copy Kronos icon to system32
CopyFile strKronosIcoPath, LocalScrPath, strKronosIco
' Copy Kronos shortcut to desktop
CopyFile strKronosLnkPath, strDesktop, strKronosLnk

boolOverwrite = False

AppendName strPCName, strUser, strTextfile

Sub RemoveOldShortcut(scanDir, pattern)
    ' Removes old Kronos shortcut
    RE.Pattern = pattern

    For Each oFile In objFSO.GetFolder(scanDir).Files
        If RE.Test(oFile) Then objFSO.DeleteFile(oFile)
    Next
End Sub


Sub CopyFile(source, tar, file)
    ' Copy source to tar
    If Not objFSO.FileExists(tar & file) Then
        objFSO.CopyFile source, tar & file, boolOverwrite
    Else
    End If
End Sub


Sub AppendName(pcName, userName, file)
    ' Append pcname, username to file, indicating script has been run
    Dim nowTime
    nowTime = Now()

    Const ForReading = 1, ForAppending = 8

    If Not objFSO.FileExists(file) Then
        Set file = objFSO.CreateTextFile(file, True)
        file.Close
    Else
        Set file = objFSO.OpenTextFile(file, 8, True, 0)
        file.WriteLine pcName & ", " & userName & ", " & nowTime
        file.Close
    End If
End Sub
