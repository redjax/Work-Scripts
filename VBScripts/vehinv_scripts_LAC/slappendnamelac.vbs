' NewTextEC.vbs
' Sample VBScript to write to a file. With added error-correcting
' Author Guy Thomas http://computerperformance.co.uk/
' VBScript Write File
' ---------------------------------------------'

Option Explicit

' Declare the variables being used throughout the script
Dim objFSO, objFolder, objShell, objShellEnv, objTextFile, objFile, computerName
const overwrite = true ' Has to be here for some reason

Dim strDirectory, strFile, strText, strUser
' Directory containing report text file
strDirectory = "\\a8akg9p01\backup\jxk5224\Scripts\VBScripts\saleslogreport"
' Report text file
strFile = "\lacSalesLogreport.txt"

' Create the File System Object
Set objFSO = CreateObject("Scripting.FileSystemObject")
set objShell    = WScript.CreateObject("WScript.Shell")
set objShellEnv = objShell.Environment("Process")

' Get username of person logged in.
strUser = CreateObject("WScript.Network").UserName

' Get the computer's name, then prepare a variable for writing it to the text file.
computerName  = objShellEnv("ComputerName")
strText = computerName + "," + strUser

' Check that the strDirectory folder exists
If objFSO.FolderExists(strDirectory) Then
   Set objFolder = objFSO.GetFolder(strDirectory)
Else
   Set objFolder = objFSO.CreateFolder(strDirectory)
   WScript.Echo "Just created " & strDirectory
End If

If objFSO.FileExists(strDirectory & strFile) Then
   Set objFolder = objFSO.GetFolder(strDirectory)
Else
   Set objFile = objFSO.CreateTextFile(strDirectory & strFile)
   Wscript.Echo "Just created " & strDirectory & strFile
End If

set objFile = nothing
set objFolder = nothing

' OpenTextFile Method needs a Const value
' ForAppending = 8 ForReading = 1, ForWriting = 2
Const ForAppending = 8

' Open the text file in appending mode.
Set objTextFile = objFSO.OpenTextFile _
(strDirectory & strFile, ForAppending, True)

' Writes strText every time you run this VBScript
objTextFile.WriteLine(strText)
objTextFile.Close

' Bonus or cosmetic section to launch explorer to check file
If err.number = vbEmpty then
   Set objShell = CreateObject("WScript.Shell")
   'objShell.run ("Explorer" &" " & strDirectory & "\" )
Else WScript.echo "VBScript Error: " & err.number
End If

WScript.Quit

' End of VBScript to write to a file with error-correcting Code
