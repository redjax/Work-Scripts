' Use this script to launch the copy script without a security prompt.

' -------------------------------------------------------------------------

Set objShell=CreateObject("Wscript.Shell")

objShell.Run "ucsuitecopy.vbs /norestart"
objShell.Run "ucsuiteAppendName.vbs /norestart"
