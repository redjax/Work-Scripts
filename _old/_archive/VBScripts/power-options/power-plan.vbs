' Script to set power plan options to never go to sleep/hibernate.

On Error Resume Next

' Check if script will work, exit if it won't
Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists("c:\windowssystem32powercfg.exe") = False Then wscript.quit
If Err Then wscript.quit

Dim strOS : strOS = isClientOperatingSystem()

Dim objShell : Set objShell = WScript.CreateObject("WScript.Shell")

' Disable Hibernate
If objFSO.FileExists("c:hiberfil.sys") Then
    If InStr(strOS,"XP") > 0 Then
        objShell.Run "powercfg /hibernate off", 0, True
    Else
        objShell.Run "powercfg -h off", 0, True
    End If
End If

' Turn off standby & monitor timeout
If InSTR(strOS, "XP") > 0 Or InStr(strOS, "2000") > 0 Then
    'XP/2000 Settings
    objShell.Run "powercfg /X" & chr(34) & "home/office desk" & chr(34) & _
                 " /standby-timeout-ac 0", 0, True
    objShell.Run "powercfg /X" & chr(34) & "home/office desk" & chr(34) & _
                 "/monitor-timeout-ac 0", 0, True
    objShell.Run "powercfg /setactive" & chr(34) & "home/office desk" & chr(34), 0, True
Else
    ' Vista, Win7
    objShell.Run "powercfg -s 381B4222-F694-41F0-9685-FF5BB260DF2E", 0, True
    objShell.Run "powercfg -change -standby-timeout-ac 0", 0, True
    objShell.Run "powercfg -change -monitor-timeout-ac 0", 0, True
End If

' Cleanup
Set objShell = Nothing
Set objFSO = Nothing

Private Function isClientOperatingSystem()
    Dim objWMIService, objItem, colItems
    Dim strOS

    On Error Resume Next
        ' WMI connection to the object in CIM namespace
        Set objWMIService = GetObject("winmgmts:\.rootcimv2")

        ' WMI Query to Win32_OperatingSystem
        Set colItems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")

        For Each objItem in colItems
            strOS = objItem.Caption
        Next

        If InStr(strOS, "Windows 7") <> 0 Or InStr(strOS, "XP") <> 0 Or InStr(strOS, "2000 Professional") <> 0 Or InStr(strOS,"Vista") <> 0 Then
            isClientOperatingSystem = strOS
        Else
            isClientOperatingSystem = False
        End If

        If Err.Number <> 0 Then isClientOperatingSystem = False

        strOS = Empty
        Set objItem = Nothing
        Set colItems = Nothing
        Set objWMIService = Nothing
    On Error GoTo 0
End Function
