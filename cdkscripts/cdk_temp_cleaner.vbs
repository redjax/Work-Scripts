' This script deletes the temporary files
' CDK creates during usage.
' It is the first step in troubleshooting typically,
' so the script is designed to save time.

' -------------------------------------------------------------------------- '

Dim fso, copyFile, vSystemDrive

Set fso = CreateObject("Scripting.FileSystemObject")

Set shell = WScript.CreateObject("Wscript.Shell")

' -------------------------------------------------------------------------- '

' Create the variable for the C:\ProgramData folder
vAPPDATA = shell.ExpandEnvironmentStrings("%PROGRAMDATA%")
appDataADPFolder = (vAPPDATA & "\ADP")
appDataBluezoneFolder = (vAPPDATA & "\BlueZone")


' Create the variable for the "My Documents" folder
vUSERFOLDER = CreateObject("Wscript.Shell").SpecialFolders("Mydocuments")
userFolder = (vUSERFOLDER & "\BlueZone")

' -------------------------------------------------------------------------- '

' Delete the "ADP" folder inside ProgramData
If fso.FolderExists(appDataADPFolder) Then
    fso.DeleteFolder(appDataADPFolder)
End If

' Delete the "BlueZone" folder in ProgramData
If fso.FolderExists(appDataBluezoneFolder) Then
    fso.DeleteFolder(appDataBluezoneFolder)
End If

' Delete the "BlueZone" folder ADP uses for Drive
If fso.FolderExists(userFolder) Then
    fso.DeleteFolder(userFolder)
End If

' %allusersprofile%\ADP\websuite
If Not fso.FolderExists(appDataADPFolder) Then
    fso.CreateFolder(appDataADPFolder)
End If

If Not fso.FolderExists(appDataADPFolder & "\websuite") Then
    fso.CreateFolder(appDataADPFolder & "\websuite")
End If
