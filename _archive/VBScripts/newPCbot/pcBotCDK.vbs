' This script moves the CDK installer to the desktop of the new computer.
' The setup still needs to be run manually.

' -------------------------------------------------------------------- '

' |System Object Variables|
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' -------------------------------------------------------------------- '

' |VARIABLES|
mlxCdk = ("" & "\")
adminDesktop = ""

' -------------------------------------------------------------------- '

' Move the CDK folder to the desktop
fso.CopyFolder mlxCdk, adminDesktop

' Launch the installer
shell.run(adminDesktop & "\")