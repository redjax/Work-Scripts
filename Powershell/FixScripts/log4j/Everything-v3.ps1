<#
    This script searches hosts (defined in the $Computers file below as 'user,hostname') for all .jar files,
    copies them to C:\temp\log4j, and searches them for the vulnerable 'JndiLookup.class' Java class. This is the
    vulnerability exploited by Log4Shell (https://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2021-44228).

    !!IMPORTANT!!
    This script does not remediate Log4Shell. If the vulnerability is found in one of the archives, the host will
    still need manual remediation.
#>

## Path to .csv with 'user,hostname' contents
# $Computers = Import-Csv "C:\Temp\Log4j\computers.csv"
# $Computers = Import-Csv "C:\Temp\Log4j\testcomputers.csv"
$Computers = Import-CSV ".\computers.csv"

## Get username of script executor
$ScriptUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
## Prompt for credentials
$Credentials = Get-Credential $ScriptUser

## Scriptblock to send & execute on remote
$Script = {

    # # Write-Host"[DEBUG] Script start"

    ## Import library to open ZIP files
    Add-Type -Assembly "System.IO.Compression.Filesystem"

    ## Get current release from "All Everything Downloads" at: https://www.voidtools.com/
    $EverythingVersion = "Everything-1.4.1.1020.x64.zip"
    ## Build download URL
    $PortableEverythingURL = "https://www.voidtools.com/$EverythingVersion"
    ## C:\users\<scriptuser>
    $ExpandedDirectory = "$($ENV:TEMP)\Everything"
    $TempDirectory = "C:\Temp\Log4j"

    # Vulnerable file name
    $Vuln = "JndiLookup.class"

    ## Ensure $ExpandedDirectory exists on remote
    If (-Not (Test-Path -Path $ExpandedDirectory)) {
        New-Item -Path $ExpandedDirectory -ItemType Directory
    }

    ## Ensure $TempDirectory exists on remote
    If (-Not (Test-Path -Path $TempDirectory)) {
        New-Item -Path $TempDirectory -ItemType Directory
    }

    # Write-Host"[DEBUG] Install Everything on remote"

    # Wget Everything portable & install, if not present on remote
    If (-Not (Test-Path -Path "$ExpandedDirectory\Everything\Everything.exe" -PathType Leaf)) {
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
        Invoke-WebRequest -UseBasicParsing -Uri $PortableEverythingURL -OutFile "$ExpandedDirectory\Everything.zip"
        Expand-Archive "$ExpandedDirectory\Everything.zip" -DestinationPath $ExpandedDirectory -Force

        # Ensure Everything service is not running
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
    }
    else {
        Write-Host "'Everything' already installed, skipping."
    }

    # Write-Host"[DEBUG] Scanning remote with Everything"

    ## Run scan with everything, search for all .jar files. Exclude recycle bin from search
    $ScanResults = search-everything -global -extension jar folders:!C:\`$RECYCLE.BIN

    ## If .jar files found
    If ($ScanResults) {
        
        # Write-Host "All Results with vulnerable class:"
        Write-Host "Searching jar files for "$Vuln
        
        ## Not sure this line is necessary
        ($ScanResults | ForEach-Object { Select-String $Vuln $_ }).path
        
        ## Loop over .jar files in $ScanResults, move to $TempDirectory, convert to .zip
        ForEach ($result in $ScanResults) {
            # Write-Host"[DEBUG] Result: "$result
            
            ## Get name of file without extension
            $basename = (Get-Item "$result").Basename
            # Write-Host"[DEBUG] Basename: "$basename
            
            ## Set new filename for .zip
            $result_zip = "$basename.zip"
            # Write-Host"[DEBUG] Zip name: "$result_zip

            # Copy .zip to $TempDirectory
            If (-Not (Test-Path -Path "$TempDirectory\$result_zip" -PathType Leaf)) {

                Write-Host "Copy $result to $TempDirectory"
                Copy-Item -Path $result -Destination "$TempDirectory/$result_zip"

            }
        }

        ## Empty array to store found vulnerable files
        $Vulnerabilities = @()
        ## Loop over files in C:/tmp/*.zip, open them, check for $vuln
        # Write-Host "1-------------------------------------"
        ## Create object with contents of $TempDirectory
        $TempFiles = @(Get-ChildItem $TempDirectory)
        # Write-Host "2-------------------------------------"

        # Write-Host"[DEBUG] TempFiles:"
        Write-Host $TempFiles

        ## Search archives for $Vuln in $TempDirectory
        ForEach ($TempFile in $TempFiles) {
            ## Get file extension of $TempFile
            $tempfile_ext = [IO.Path]::GetExtension($tempfile.name)

            # Write-Host"[DEBUG] Temp File:"$TempFile

            ## Check for vulnerability if $TempFile is a .zip archive
            If ($tempfile_ext -eq ".zip") {
                
                # Write-Host "3-------------------------------------"
                ## Open ZIP archive
                $archive = [IO.Compression.ZipFile]::OpenRead("$TempDirectory\$TempFile").Entries

                # Write-Host"[DEBUG] Searching archive for $Vuln"
                
                ## Search archive contents
                ForEach ($file in $archive) {

                    ## Create new object with file's name, relative path, & file ext
                    $Object = New-Object -TypeName PSObject
                    $Object | Add-Member -MemberType NoteProperty -Name Filename -Value $file.name
                    $Object | Add-Member -MemberType NoteProperty -Name FullPath $file.FullName
                    $Object | Add-Member -MemberType NoteProperty -Name Extension -Value ([System.IO.Path]::GetExtension($file.FullName))
                    
                    ## Check for .class files
                    If ($Object.Extension -eq ".class") {
                        # Write-Host "Class file found: "$Object.FileName

                        ## If file matches name of $Vuln
                        If ($Object.Filename -eq $Vuln) {
                            # Write-Host "Vulnerability found in: "$Object.FullPath

                            ## Add to $Vulnerabilities object
                            $Vulnerabilities += $Object
                        }
                    }
                }
                
            }
        }

        ## Loop over $Vulnerabilities object
        ForEach ($vuln_file in $Vulnerabilities) {
            ## Get path of vulnerable file
            $vuln_path = $vuln_file.FullPath
            Write-Host "Vulnerability: ", $vuln_file.FileName, "in", "$tmpdir/$vuln_path"
        }
    }
    else {
        Write-Host "Did not find any vulnerable files."
    }

    ## Stop & remove 'Everything'
    Get-Process Everything | Stop-Process -Force
    & "$ExpandedDirectory\everything.exe" -uninstall-client-service
    Start-Sleep 2
    Remove-Item $ExpandedDirectory -Recurse -Force

}

## Loop over computers.csv, run $Script block on remote for each computer
ForEach ($Computer in $Computers) {
    Write-Host "Running script on: "$Computer.hostname
    Invoke-Command -ComputerName $Computer.hostname -Credential $Credentials -ScriptBlock $Script
}