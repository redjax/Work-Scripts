' This is the shortcut mover script. It moves all web shortcuts and icon
' files to the new PC, and then sets the .ico files in the proper place.

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
' Admin Desktop
adminDesktop = "C:\Users\AAGAdmin\Desktop"
' Altiris folder on Admin Desktop
altirisFolder = adminDesktop & "\Altiris"

' Altiris stuff
altirisInstaller = "\\metrolx01\backup\jxk5224\_New PC Setup\Altiris Client.lnk"
' Altiris setup instructions
altirisInstructions = "\\metrolx01\backup\jxk5224\_New PC Setup\New PC Setup Altiris Instrusctions.txt"

' -------------------------------------------------------------------- '

' Subfolders in WebShortcuts folder

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

' -------------------------------------------------------------------- '

fso.CopyFile (mlxWebShortcutsEveryone & "\*.*"), (pubDesktop & "\") ' Copy web shortcuts

fso.MoveFile (pubDesktop & "\*.ico"), ("C:\Windows\system32" & "\") ' Move icon files to system32