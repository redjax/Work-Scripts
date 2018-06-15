' This script copies the Office 2010 installer files to the desktop,
' and runs the setup. Make sure you have a key free!

' -------------------------------------------------------------------- '

' |System Object Variables|
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' -------------------------------------------------------------------- '

' |VARIABLES|

' Office folder on the server
officeFolder = "\\metrolx01\backup\jxk5224\_Programs & Fixes\Office"

' Admin Desktop
adminDesktop = "C:\Users\AAGAdmin\Desktop"
adminOffice = adminDesktop & "\Office 2010"

' -------------------------------------------------------------------- '

' Copy Office2010 folder to the admin desktop
fso.CopyFolder (officeFolder & "\Office 2010"), adminDesktop
shell.run(adminOffice & "\setup.exe")