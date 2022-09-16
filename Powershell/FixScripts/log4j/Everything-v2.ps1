## Import library to open ZIP files
Add-Type -Assembly "System.IO.Compression.Filesystem"

# $Computers = Import-Csv "C:\Temp\Log4j\computers.csv"
$Computers = Import-Csv "C:\Temp\Log4j\testcomputers.csv"
# $Credentials = Get-Credential "kmanring"
$Credentials = Get-Credential "jkenyon"

$Script = {
    ## Import library to open ZIP files
    Add-Type -Assembly "System.IO.Compression.Filesystem"

    $EverythingVersion = "Everything-1.4.1.1020.x64.zip"
    $PortableEverythingURL = "https://www.voidtools.com/$EverythingVersion"
    $ExpandedDirectory = "$($ENV:TEMP)\Everything"
    $TempDirectory = "C:\Temp\Log4j"

    # Vulnerable file name
    $Vuln = "JndiLookup.class"

    If (-Not (Test-Path -Path $ExpandedDirectory)) {
        New-Item -Path $ExpandedDirectory -ItemType Directory
    }
    If (-Not (Test-Path -Path $TempDirectory)) {
        New-Item -Path $TempDirectory -ItemType Directory
    }

    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    Invoke-WebRequest -UseBasicParsing -Uri $PortableEverythingURL -OutFile "$ExpandedDirectory\Everything.zip"
    Expand-Archive "$ExpandedDirectory\Everything.zip" -DestinationPath $ExpandedDirectory -Force

    if (!(Get-Service "Everything Client" -ErrorAction SilentlyContinue)) {
        & "$ExpandedDirectory\everything.exe" -install-client-service
        & "$ExpandedDirectory\everything.exe" -reindex
        start-sleep 3
        Install-Module PSEverything
    }
    else {
        & "$ExpandedDirectory\everything.exe" -reindex
        Install-Module PSEverything
    }

    $ScanResults = search-everything -global -extension jar -FolderExclude C:\$Recycle.Bin\

    if ($ScanResults) {
        # Write-Host "Potential vulnerable JAR files found. Please investigate:"
        # Write-Host "all Results:"
        # $scanresults
        Write-Host "All Results with vulnerable class:"
        ($ScanResults | ForEach-Object { Select-String $Vuln $_ }).path
        ForEach ($result in $ScanResults) {
            $basename = (Get-Item "$result").Basename
            $result_zip = "$basename.zip"
            # Copy .jar to $tmp
            If (-Not (Test-Path -Path "$TempDirectory\$result_zip" -PathType Leaf)) {
                Write-Host "Copy $result to $TempDirectory"
                Copy-Item -Path $result -Destination "$TempDirectory/$result_zip"
            }
        }

        # Empty array to store found vulnerable files
        $Vulnerabilities = @()
        ## Loop over files in C:/tmp/*.zip, open them, check for $vuln
        Write-Host "1-------------------------------------"
        $TempFiles = @(Get-ChildItem $TempDirectory)
        Write-Host "2-------------------------------------"

        ForEach ($TempFile in $TempFiles) {
            $tempfile_ext = [IO.Path]::GetExtension($tempfile.name)
            If ($tempfile_ext -eq ".zip") {
                # Open ZIP archive
                Write-Host "3-------------------------------------"
                Write-Host "$TempDirectory\$TempFile"
                $archive = [IO.Compression.ZipFile]::OpenRead("$TempDirectory\$TempFile").Entries
                <#
                ForEach ($file in $archive) {
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
                #>
            }
        }

        

        ForEach ($vuln_file in $Vulnerabilities) {
            $vuln_path = $vuln_file.FullPath
            Write-Host "Vulnerability: ", $vuln_file.FileName, "in", "$tmpdir/$vuln_path"
        }
    }
    else {
        Write-Host "Did not find any vulnerable files."
    }
    Get-Process Everything | Stop-Process -Force
    & "$ExpandedDirectory\everything.exe" -uninstall-client-service
    Start-Sleep 2
    Remove-Item $ExpandedDirectory -Recurse -Force
    # ($ScanResults | ForEach-Object { Copy-Item -Credential $Credentials -Path $_ -Destination "C:\Temp\Test\"(($_).basename)".zip" })
}

foreach ($Computer in $Computers) {
    Write-Host $Computer.hostname
    Invoke-Command -ComputerName $Computer.hostname -Credential $Credentials -ScriptBlock $Script
}