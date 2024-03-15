' This script copies the files for the Altiris installer to a folder on
' AAGAdmin's desktop called "Altiris," and runs the installer.

' -------------------------------------------------------------------- '

' |System Object Variables|
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' -------------------------------------------------------------------- '

' |VARIABLES|

' Admin Desktop
adminDesktop = ""
' Altiris folder on Admin Desktop
altirisFolder = adminDesktop & ""

' Altiris stuff
altirisInstaller = ""
' Altiris setup instructions
altirisInstructions = ""

' -------------------------------------------------------------------- '

fso.CreateFolder(adminDesktop & "\") ' Create folder called "Altiris" on admin desktop

fso.CopyFile (altirisInstaller), altirisFolder ' Copy Altiris installer
fso.CopyFile (altirisInstructions), altirisFolder ' Copy Altiris instructions

shell.run(altirisFolder & "\.lnk")