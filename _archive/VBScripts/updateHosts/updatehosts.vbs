' Update Windows Host file with parameters passed as args.
' This script only takes 2 args (any more will likely not work).
' The script expects an IP address, and the host it will resolve to.

Const ForReading = 1, ForWriting = 2, ForAppending = 8, ReadOnly = 1
Set fso = CreateObject("Scripting.FileSystemObject")
Set WshShell=CreateObject("WScript.Shell")
WinDir =WshShell.ExpandEnvironmentStrings("%WinDir%")

HostsFile = WinDir & "\System32\Drivers\etc\Hosts"
Set args = WScript.Arguments  ' For passing args to script
ipupdate = args.Item(0)  ' First arg should be IP address
hostname = args.Item(1)  ' Second arg should be hostname

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(HostsFile, ForReading)

Do Until objFile.AtEndOfStream
If InStr (objFile.ReadLine, "10.10.10.105") <> 0 Then
WScript.Quit
End If
i = i + 1
Loop
objFile.Close

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile(HostsFile)
If objFile.Attributes AND ReadOnly Then
objFile.Attributes = objFile.Attributes XOR ReadOnly
End If

Set filetxt = fso.OpenTextFile(HostsFile, ForAppending, True)
filetxt.WriteLine(vbNewLine & ipupdate & " " & hostname)
filetxt.Close
WScript.quit
