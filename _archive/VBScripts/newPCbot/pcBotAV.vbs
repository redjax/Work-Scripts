' This script opens the folder for Norton SEP. You will have to download
' the latest, architecture-appropriate file and run the installer.
' This script is more of a "don't forget this step."

' -------------------------------------------------------------------- '

' |System Object Variables|
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' -------------------------------------------------------------------- '

' |VARIABLES|

avPath = ""

' -------------------------------------------------------------------- '

avExplore = "explorer.exe /e," & avPath

shell.run(avExplore)