' This script runs a few other scripts that will automate
' setting up a new PC. It will move icon files, desktop shortcuts,
' and setup files to the new computer.

' -------------------------------------------------------------------- '

' To call other scripts:
set shell = createobject("wscript.shell") 
' shell.run("c:\path\file.vbs") 

' -------------------------------------------------------------------- '

' STEP 1: Move icon files
'    >this script moves icon files for programs and desktop shortcuts

MsgBox "First, a script will run that copies icons and program shortcuts to the Public desktop, so they show up on anyone's desktop when they log in.",0
shell.run(pcBotShortcuts.vbs) ' call the shortcut mover program

' -------------------------------------------------------------------- '

' STEP 2: Altiris installation
'    >this script moves the Altiris files and starts the installation

MsgBox "This script will copy the Altiris installer, and a text file with instructions for setting it up, to the desktop, in a folder called Altiris."
shell.run(pcBotAltiris.vbs)

' -------------------------------------------------------------------- '

' STEP 3: CDK Drive installation
'    >this script moves the CDK installation files to the desktop

MsgBox "Next, the script will copy the CDK Drive installation files to the desktop. It will then launch the installer, which you need to manually finish."
shell.run(pcBotCDK.vbs)

' -------------------------------------------------------------------- '

' Step 4: Antivirus installation
'    >this script opens the folder with SEP installers. Because the versions change, you must manually copy it to the desktop.

MsgBox "A folder will open with the installer files for Norton SEP. Look for the most recent version for x86 (32-bit) or x64 (64-bit). You can find the most recent file by looking at the date field.",0
shell.run(pcBotAV.vbs)

' -------------------------------------------------------------------- '

' Step 5: Office Installer
'    >this script copies the Microsoft Office 2010 folder to the desktop, and runs the installer.

MsgBox "The Office 2010 folder will be copied to the desktop, and setup.exe will be run now."
shell.run(pcBotOffice.vbs)

' -------------------------------------------------------------------- '

' STEP 6: Printer Installation
'    >a message box will remind you to set up printers.
MsgBox "A text document with a list of printers for both stores will pop up next. Choose the printer(s) to set up, copy their IP address, and either run through the printer setup wizard, or (for Toshiba MFPs), use Windows Explorer to navigate to the printer, and run the Setup.exe inside the UNIV_driver folder."
shell.run("\\METROLX01\backup\jxk5224\Guides\For Admins\Printer List.txt")