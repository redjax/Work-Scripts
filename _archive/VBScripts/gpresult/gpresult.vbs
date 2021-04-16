Set objFSO = CreateObject("Scripting.FileSystemObject")
Dim strDesktop, strGpres
strDesktop = objShell.SpecialFolders("Desktop")
strGpres = strDesktop & "gpreport.html"

objFSO.CopyFile strGpres, "", True
