<#
    This script searches hosts (defined in the $Computers file below as 'user,hostname') for all .jar files,
    copies them to C:\temp\log4j, and searches them for the vulnerable 'JndiLookup.class' Java class. This is the
    vulnerability exploited by Log4Shell (https://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2021-44228).

    !!IMPORTANT!!
    This script does not remediate Log4Shell. If the vulnerability is found in one of the archives, the host will
    still need manual remediation.
#>

## Path to .csv with 'user,hostname' contents, import machines to scan
$Computers = Import-CSV ".\computers.csv"

## Get username of script executor
$ScriptUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
## Prompt for credentials
$Credentials = Get-Credential $ScriptUser

## Fileshare location to store CSVs with vulnerable files
$FileshareLoc = ""

## Scriptblock to send & execute on remote
$Script = {

    ## Get hostname of remote machine, set in variable
    $RemoteHostname = hostname
    # Write-Host "[DEBUG] Hostname: $RemoteHostname"

    ## Store location to c:\users\<current_user>\Documents
    $RemoteDocumentsDir = [Environment]::GetFolderPath("MyDocuments")

    ## Import library to open ZIP files
    Add-Type -Assembly "System.IO.Compression.Filesystem"

    ## Get current release from "All Everything Downloads" at: https://www.voidtools.com/
    $EverythingVersion = "Everything-1.4.1.1020.x64.zip"
    ## Build download URL
    $PortableEverythingURL = "https://www.voidtools.com/$EverythingVersion"
    ## C:\users\<scriptuser>
    $ExpandedDirectory = "$($ENV:TEMP)\Everything"
    ## Temp directory to store found JAR files to scan
    $TempDirectory = "C:\Temp\Log4j"

    ## Vulnerable file name
    $Vuln = "JndiLookup.class"

    ## Name of CSV to output found vulnerable classes
    [string]$vulnerabilities_csv = $($RemoteHostname) + "_found_jars.csv"

    # Write-Host "[DEBUG] Vulnerabilities CSV:" $vulnerabilities_csv

    ## Ensure $ExpandedDirectory exists on remote
    If (-Not (Test-Path -Path $ExpandedDirectory)) {
        New-Item -Path $ExpandedDirectory -ItemType Directory
    }

    ## Ensure $TempDirectory exists on remote
    If (-Not (Test-Path -Path $TempDirectory)) {
        New-Item -Path $TempDirectory -ItemType Directory
    }

    # Write-Host"[DEBUG] Install Everything on remote"

    ## Wget Everything portable & install, if not present on remote
    If (-Not (Test-Path -Path "$ExpandedDirectory\Everything\Everything.exe" -PathType Leaf)) {
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
        Invoke-WebRequest -UseBasicParsing -Uri $PortableEverythingURL -OutFile "$ExpandedDirectory\Everything.zip"
        Expand-Archive "$ExpandedDirectory\Everything.zip" -DestinationPath $ExpandedDirectory -Force

        ## Ensure Everything service is not running, install PSEverything module
        if (!(Get-Service "Everything Client" -ErrorAction SilentlyContinue)) {
            & "$ExpandedDirectory\everything.exe" -install-client-service
            & "$ExpandedDirectory\everything.exe" -reindex
            start-sleep 3
            Install-Module PSEverything
        }
        ## Everything already installed, install PSEverything module
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
    $ScanResults = search-everything -global -extension jar folders:C:\, !C:\`$RECYCLE.BIN

    ## Store original paths of found .jar files & vulnerability status
    $FoundJars = @()

    ## If .jar files found
    If ($ScanResults) {
        
        # Write-Host "All Results with vulnerable class:"
        Write-Host "Searching jar files for"$Vuln
        
        ## Not sure this line is necessary
        # ($ScanResults | ForEach-Object { Select-String $Vuln $_ }).path
        
        ## Loop over .jar files in $ScanResults, move to $TempDirectory, convert to .zip, scan .zip for vulnerability
        ForEach ($result in $ScanResults) {
            # Write-Host "[DEBUG] Result:" $result
            
            ## Get name of file without extension
            $basename = (Get-Item "$result").Basename
            # Write-Host "[DEBUG] Basename: "$basename
            
            ## Set new filename for .zip
            $result_zip = "$basename.zip"
            # Write-Host "[DEBUG] Zip name: "$result_zip

            ## Path to zip file in $TempDirectory
            $TempFile = "$TempDirectory\$result_zip"
            # Write-Host "[DEBUG] Tempfile:" $TempFile

            ## Copy .zip to $TempDirectory
            If (-Not (Test-Path -Path "$TempFile" -PathType Leaf)) {

                # Write-Host "[DEBUG] Copy $result to $TempDirectory"
                Copy-Item -Path $result -Destination "$TempFile"
            }

            ## Check for $Vuln in archive
            $archive = [IO.Compression.ZipFile]::OpenRead("$TempFile").Entries

            ## Loop over files in .zip archive
            ForEach ($File in $archive) {

                # Write-Host "[DEBUG] Building object for" $File

                ## Create new object with file's name, relative path, & file ext
                $Object = New-Object -TypeName PSObject
                $Object | Add-Member -MemberType NoteProperty -Name Filename -Value $file.name
                $Object | Add-Member -MemberType NoteProperty -Name FullPath $file.FullName
                $Object | Add-Member -MemberType NoteProperty -Name Extension -Value ([System.IO.Path]::GetExtension($file.FullName))

                ## Check for .class files
                If ($Object.Extension -eq ".class") {
                    # Write-Host "Class file found: "$Object.FileName

                    ## If .class file matches name of $Vuln
                    If ($Object.Filename -eq $Vuln) {
                        Write-Host "Vulnerability found in: "$Object.FullPath

                        ## Add to $FoundJars array
                        $FoundJars += New-Object psobject -Property @{
                            hostname      = $RemoteHostname
                            original_path = $result
                            scan_location = $TempFile
                            vulnerable    = "yes"
                        }
                    }
                }
            }

            # Write-Host "[DEBUG] Writing found vulnerable files to" "$($PWD)\$vulnerabilities_csv"
            ## Output results to CSV
            $FoundJars | Export-CSV $vulnerabilities_csv -NoTypeInformation

        }

        ## Stop & remove 'Everything'
        Get-Process Everything | Stop-Process -Force
        & "$ExpandedDirectory\everything.exe" -uninstall-client-service
        Start-Sleep 2
        Remove-Item $ExpandedDirectory -Recurse -Force

        ## Cleanup $TempDirectory
        # NOTE: NOT WORKING

        # Start-Sleep 5
        # Write-Host "Cleaning up $TempDirectory"

        # # Get-ChildItem -Path $TempDirectory\* -Recurse -Force | ForEach-Object { $_.Delete() }
        # Remove-Item "$TempDirectory\*" -Recurse -Force

        ## Copy found_jars CSV to network location.
        # NOTE: NOT WORKING
        Write-Host "[DEBUG] Vulnerabilities CSV:" $vulnerabilities_csv
        RoboCopy $RemoteDocumentsDir $FileshareLoc $vulnerabilities_csv

    }
}

## Loop over computers.csv, run $Script block on remote for each computer
ForEach ($Computer in $Computers) {
    Write-Host "Running script on: "$Computer.hostname
    Invoke-Command -ComputerName $Computer.hostname -Credential $Credentials -ScriptBlock $Script
}