' VBScript to check file extension.

' Method 1:

Set objfso = CreateObject("Scripting.FileSystemObject")
     objStartFolder = "D:\"
     Set objFolder = objfso.GetFolder(objStartFolder)
     For Each objFile In objFolder.Files
          If objfso.GetExtensionName(objFile) = "jpeg" Then
               Wscript.Echo objFile.Name
          End If
     Next

' Method 2:

'Set x = CreateObject("scripting.filesystemobject")
'WScript.Echo x.GetExtensionName("foo.pdf")

'For Each objFile in colFiles
'    If UCase(objFSO.GetExtensionName(objFile.name)) = "PDF" Then
        Wscript.Echo objFile.Name
'    End If
'Next
