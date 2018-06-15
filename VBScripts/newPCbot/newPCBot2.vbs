' Test version of the newPCBot script. Instead of breaking the steps into separate modules,
' they are all combined her in one script. If this works, I'll move the description of the script
' here, and clean up the code.

' -------------------------------------------------------------------- '

' |System Object Variables|
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' -------------------------------------------------------------------- '

' |VARIABLES|

'Public Desktop
pubDesktop = "C:\Users\Public\Desktop"
' Metrolx01 path
mlxPath = "\\metrolx01\backup\jxk5224"
' Web Shortcuts folder
mlxWebShortcuts = (mxlPath & "\WebShortcuts")

' Everyone folder
mlxWebShortcutsEveryone = (mlxWebShortcuts & "\Everyone")
' Sales folder
mlxWebShortcutsSales = (mlxWebShortcuts & "\Sales")
' Finanace folder
mlxWebShortcutsFinance = (mlxWebShortcuts & "\Finanace")
' Parts folder
mlxWebShortcutsParts = (mlxWebShortcuts & "\Parts")
' Service folder
mlxWebShortcutsService = (mlxWebShortcuts & "\Service")

' SEP Antivirus
avPath = "\\A1CLE7P01\eXpress\Library\CoreApps\SEP"

' Admin Desktop
adminDesktop = "C:\Users\AAGAdmin\Desktop"
adminOffice = adminDesktop & "\Office 2010"

' Altiris folder on Admin Desktop
altirisFolder = adminDesktop & "\Altiris"

' Altiris stuff
altirisInstaller = "\\metrolx01\backup\jxk5224\_New PC Setup\Altiris Client.lnk"
' Altiris setup instructions
altirisInstructions = "\\metrolx01\backup\jxk5224\_New PC Setup\New PC Setup Altiris Instrusctions.txt"

' CDK Drive installer
mlxCdk = ("\\metrolx01\backup\jxk5224\_New PC Setup\" & "\CDK Drive installer_270")

' Office folder on the server
officeFolder = "\\metrolx01\backup\jxk5224\_Programs & Fixes\Office"

' -------------------------------------------------------------------- '

' STEP 1: Move web/program shortcuts

' Copy web shortcuts
fso.CopyFile (mlxWebShortcutsEveryone & "\*.*"), (pubDesktop & "\")
' Move icon files to system32
fso.MoveFile (pubDesktop & "\*.ico"), ("C:\Windows\system32" & "\")

Wscript.Echo("Web and program shortcuts have been copied, and icon files moved. Press Enter to continue...")
' -------------------------------------------------------------------- '

' STEP 2: Install antivirus

' Run the Windows Explorer, opening to the path for SEP
avExplore = "explorer.exe /e," & avPath

shell.run(avExplore)

Wscript.Echo("Please finish the Antivirus installer, then press Enter to continue...")

' -------------------------------------------------------------------- '

' STEP 3: Altiris installer

' Create folder called "Altiris" on admin desktop
fso.CreateFolder(adminDesktop & "\Altiris")
' Copy Altiris installer
fso.CopyFile (altirisInstaller), altirisFolder
' Copy Altiris instructions
fso.CopyFile (altirisInstructions), altirisFolder
' Run the Altiris installer
shell.run(altirisFolder & "\Altiris Client.lnk")

Wscript.Echo("Please finish the Altiris installation, then press Enter to continue...")

' -------------------------------------------------------------------- '

' STEP 4: CDK Installer

' Move the CDK folder to the desktop
fso.CopyFolder mlxCdk, adminDesktop

' Launch the installer
shell.run(adminDesktop & "\CDK Drive installer_270\StartHta.exe")

Wscript.Echo("Please finish the CDK Drive installation, then press Enter to continue...")

' -------------------------------------------------------------------- '

' STEP 5: Office Installer

' Copy Office2010 folder to the admin desktop
fso.CopyFolder (officeFolder & "\Office 2010"), adminDesktop
shell.run(adminOffice & "\setup.exe")

Wscript.Echo("Please finish the Office installation, then press Enter to continue...")