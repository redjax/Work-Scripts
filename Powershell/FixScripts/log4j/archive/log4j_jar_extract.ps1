## Import library to open ZIP files
Add-Type -Assembly "System.IO.Compression.Filesystem"

## Script vars
$tmpdir = "C:/tmp"
$testfilename = "commons-codec-1.4.jar"
$testfile = "./$testfilename"
$testfile_basename = (Get-Item "$testfilename").Basename
$testfile_zip = "$testfile_basename.zip"
$vuln = "JndiLookup.class"

# Empty array to store found vulnerable files
$Vulnerabilities = @()

## Loop over files in C:/tmp/*.zip, open them, check for $vuln
Get-ChildItem "$tmpdir" -Filter *.zip | ForEach-Object {
    
    # Write-Host "Archive:" $_

    $archive_files = [io.compression.zipfile]::OpenRead("$_").Entries

    ForEach ($file in $archive_files) {

        $Object = New-Object -TypeName PSObject

        $Object | Add-Member -MemberType NoteProperty -Name Filename -Value $file.name
        $Object | Add-Member -MemberType NoteProperty -Name FullPath $file.FullName
        $Object | Add-Member -MemberType NoteProperty -Name Extension -Value ([System.IO.Path]::GetExtension($file.FullName))
        
        If ($Object.Extension -eq ".class") {

            # Write-Host "Class file found: "$Object.FileName
            
            If ($Object.Filename -eq $vuln) {

                # Write-Host "Vulnerability found in: "$Object.FullPath

                $Vulnerabilities += $Object
            }

        }
    }
}

ForEach ($vuln_file in $Vulnerabilities) {
    $vuln_path = $vuln_file.FullPath
    Write-Host "Vulnerability: ", $vuln_file.FileName, "in", "$tmpdir/$vuln_path"
}