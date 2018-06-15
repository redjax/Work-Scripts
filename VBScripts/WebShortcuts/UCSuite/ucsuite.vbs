' Use this script to launch the copy script without a security prompt.

' -------------------------------------------------------------------------

Set objShell=CreateObject("Wscript.Shell")
Set objENV=objShell.Environment("PROCESS")
objENV("SEE_MASK_NOZONECHECKS")=1

objShell.Run "ucsuitecopy.vbs /norestart",0,True
objShell.Run "ucsuiteAppendName.vbs /norestart",0,True
objENV.Remote("SEE_MASK_NOZONECHECKS")
