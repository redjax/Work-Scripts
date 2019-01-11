' Copy shortcuts from the "Everyone" folder
Option Explicit
' ----------------------------------------------------------'

Dim LocalScrPath, strEveryone
Dim objFSO, objShell, objProcess

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
Set objProcess = objShell.Environment("Process")

strEveryone = "\\metrolx01\backup\jxk5224\webshortcuts\everyone"

' --------------------------------------------------

Call CopyShortcut(strEveryone)


Sub CopyShortcut(objFolder)
    ' Iterate over files in objFolder, copy to appropriate place
    Dim objFile, objSubFolder, PubDeskPath, boolOverwrite
    boolOverwrite = False

    set objFolder = objFSO.GetFolder(objFolder)

    ' The windows\system32 folder
    LocalScrPath = objFSO.GetSpecialFolder(1) & "\"
    PubDeskPath = "c:\users\public\desktop\"

    For Each objFile In objFolder.Files
        If Not objFSO.FileExists(objFile) Then
        ' If file is an icon file
            If LCase(objFSO.GetExtensionName(objFile.Name)) = "ico" Then
                'objFSO.CopyFile objFile, LocalScrPath, boolOverwrite
                Wscript.Echo objFile
            ' If file is a link
            ElseIf LCase(objFSO.GetExtensionName(objFile.Name)) = "lnk" Then
                'objFSO.CopyFile objFile, PubDeskPath, boolOverwrite
                Wscript.Echo objFile
            ElseIf LCase(objFSO.GetExtensionName(objFile.Name)) = "url" Then
                'objFSO.CopyFile objFile, PubDeskPath, boolOverwrite
                Wscript.Echo objFile
            End If
        End If
    Next

    boolOverwrite = False
End Sub
