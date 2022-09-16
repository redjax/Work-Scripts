## Import library to open ZIP files
Add-Type -Assembly "System.IO.Compression.Filesystem"

## Script vars
$tmpdir = "C:\tmp"
# Name of the vulnerable file to search for
$vuln = "JndiLookup.class"

### START MOVE JAR TO ZIP
# Get basename of file (i.e. filename, without extension)
$file_basename = (Get-Item "$file").Basename
# Append .zip to filename
$file_zipname = "$file_basename.zip"

# Check if C:\tmp\$file.zip exists
If (-Not (Test-Path -Path "$tmpdir/$file_zipname" -PathType Leaf)) {
    # C:\tmp\$file.zip does not exist
    Write-Host "Copy $file to $tmpdir"
    
    # Copy $file.jar to c:\tmp\$file.zip
    Copy-Item -Path $file -Destination "$tmpdir/$file_zipname"
}

### END MOVE JAR TO ZIP

# Empty array to store found vulnerable files
$Vulnerabilities = @()

# Check if $tmpdir exists
If (-Not (Test-Path -Path $tmpdir)) {
    Write-Host "$tmpdir does not exist. Creating"

    New-Item -Path $tmpdir -ItemType Directory
}

## Loop over files in C:\tmp\*.zip, open them, check for $vuln
Get-ChildItem "$tmpdir" -Filter *.zip | ForEach-Object {
    
    Write-Host "Archive:" $_

    $archive_files = [IO.Compression.ZipFile]::OpenRead($_).Entries

    ForEach ($file in $archive_files) {

        $Object = New-Object -TypeName PSObject

        $Object | Add-Member -MemberType NoteProperty -Name Filename -Value $file.name
        $Object | Add-Member -MemberType NoteProperty -Name FullPath $file.FullName
        $Object | Add-Member -MemberType NoteProperty -Name Extension -Value ([System.IO.Path]::GetExtension($file.FullName))
        
        If ($Object.Extension -eq ".class") {

            # Write-Host "Class file found: "$Object.FileName
            
            If ($Object.Filename -eq $vuln) {

                Write-Host "Vulnerability found in: "$Object.FullPath

                $Vulnerabilities += $Object
            }

        }
    }
}
