' This script copies the files for the Altiris installer to a folder on
' AAGAdmin's desktop called "Altiris," and runs the installer.

' -------------------------------------------------------------------- '

' |System Object Variables|
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' -------------------------------------------------------------------- '

' |VARIABLES|

' Admin Desktop
adminDesktop = "C:\Users\AAGAdmin\Desktop"
' Altiris folder on Admin Desktop
altirisFolder = adminDesktop & "\Altiris"

' Altiris stuff
altirisInstaller = "\\metrolx01\backup\jxk5224\_New PC Setup\Altiris Client.lnk"
' Altiris setup instructions
altirisInstructions = "\\metrolx01\backup\jxk5224\_New PC Setup\New PC Setup Altiris Instrusctions.txt"

' -------------------------------------------------------------------- '

fso.CreateFolder(adminDesktop & "\Altiris") ' Create folder called "Altiris" on admin desktop

fso.CopyFile (altirisInstaller), altirisFolder ' Copy Altiris installer
fso.CopyFile (altirisInstructions), altirisFolder ' Copy Altiris instructions

shell.run(altirisFolder & "\Altiris Client.lnk")