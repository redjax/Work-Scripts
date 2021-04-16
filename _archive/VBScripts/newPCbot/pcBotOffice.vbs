' This script copies the Office 2010 installer files to the desktop,
' and runs the setup. Make sure you have a key free!

' -------------------------------------------------------------------- '

' |System Object Variables|
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' -------------------------------------------------------------------- '

' |VARIABLES|

' Office folder on the server
officeFolder = ""

' Admin Desktop
adminDesktop = ""
adminOffice = adminDesktop & "\"

' -------------------------------------------------------------------- '

' Copy Office2010 folder to the admin desktop
fso.CopyFolder (officeFolder & "\"), adminDesktop
shell.run(adminOffice & "\")