Dim username, hostname, strIP, phoneno

' Ask user for their name.
username=InputBox("Who is asking for help? ")

' Ask user if they want to add a contact number.
phoneno=InputBox("Would you like to request a phone call? 'Y' or 'N'")
' Set response to uppercase for If statement below.
phoneno = UCase(phoneno)

If phoneno = "Y" Then
    phonenum = InputBox("At what number would you like to be called?")
ElseIf phoneno = "N" Then
    phonenum = ""
Else
    Err = MsgBox("Your selection, " & phoneno & " was invalid. We'll move on without that.",1,"Woops!")
End If

' Get computer's hostname
Set wshShell = CreateObject( "WScript.Shell" )
hostname = wshShell.ExpandEnvironmentStrings( "%COMPUTERNAME%" )

' Get computer's IP address
strQuery = "SELECT * FROM Win32_NetworkAdapterConfiguration WHERE MACAddress > ''"

Set objWMIService = GetObject( "winmgmts://./root/CIMV2" )
Set colItems      = objWMIService.ExecQuery( strQuery, "WQL", 48 )

For Each objItem In colItems
    If IsArray( objItem.IPAddress ) Then
        If UBound( objItem.IPAddress ) = 0 Then
            strIP = objItem.IPAddress(0)
        End If
    End If
Next

WScript.Echo strIP


' Open text file for writing
Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile("helpme.txt",2,true)

' Write username to text file.
objFileToWrite.WriteLine("User: " & username)
objFileToWrite.WriteLine()

' Write computer's hostname to text file.
objFileToWrite.WriteLine("PC Name: " & hostname)
objFileToWrite.WriteLine()

' Write computer's IP address to text file.
objFileToWrite.WriteLine("IP Address: " & strIP)
objFileToWrite.WriteLine()

' Write phone number, if they asked for a call back.
objFileToWrite.WriteLine("Phone Number: " & phonenum)
objFileToWrite.Close

Set objFileToWrite = Nothing

box = MsgBox ("Thank you, " & username & ". Your help request has been submitted. Press OK to exit.",1,"HelpMe")
