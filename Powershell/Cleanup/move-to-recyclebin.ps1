# This script isn't finished. Careful when running it.

# Install Recycling bin module
Install-Module -Name Recycle -Scope CurrentUser

# Vars
$USR = $env:UserName
$USR_PATH = "C:\Users\" + $USR

# If desktop path is in, i.e. Onedrive, variable with path to Desktop i.e. \Onedrive\Desktop
$DESKTOP_PATH = $USR_PATH + "Desktop"
$DESKTOP_TMP_PATH = $DESKTOP_PATH + "\_tmp"
$DESKTOP_TMP_ISO_PATH = $DESKTOP_TMP_PATH + "\_ISO"
$DESKTOP_TMP_APEXSQL_PATH = $DESKTOP_TMP_PATH + "\_apexsql"
$DESKTOP_TEST_TMP_PATH = $DESKTOP_PATH + "\_test-tmp"

$DOWNLOADS_PATH = $USR_PATH + "\Downloads"
$DOWNLOADS_KEEP_DIR = $DOWNLOADS_PATH + "\_Keep"

function PrintPaths {
    Write-Host "Desktop tmp path: " $DESKTOP_TMP_PATH
    Write-Host "Desktop tmp/_iso path: " $DESKTOP_TMP_ISO_PATH
    Write-Host "Desktop tmp/_apexsql path: " $DESKTOP_TMP_APEXSQL_PATH
    Write-Host "Desktop test path: " $DESKTOP_TEST_TMP_PATH

    Write-Host "Downloads path: " $DOWNLOADS_PATH
    Write-Host "Downloads keepdir path: " $DOWNLOADS_KEEP_DIR
}

function ListFiles($ScanDir) {

    ForEach ($File in Get-ChildItem $ScanDir -Recurse) {
        Write-Host $File
    }
}

function DeleteOlderThan($ScanDir, $OlderThan) {
    
    Get-ChildItem $ScanDir -Recurse | Where-Object { $_.CreationTime -lt ($(Get-Date).AddDays(-$OlderThan)) } | ForEach-Object { remove-item $_.FullName -Recurse }
    # ForEach-Object { remove-Item $_.FullName –whatif }
    
}

function MAIN {

    # In days, how old a file needs to be for deletion
    $OlderThan = 0

    $MenuOptions = @'
"Press '1' to clear Desktop _tmp directory"
"Press '2' to clear Downloads directory"
"Press 'Q' to quit."
'@

    "`n$MenuOptions"

    while (($selection = Read-Host -Prompt "`nSelect an option") -ne 'Q') {
        Clear-Host

        "`n$MenuOptions"

        switch ( $selection ) {
            1 { DeleteOlderThan $DESKTOP_TEST_TMP_PATH $OlderThan }
            2 { RUN_RESTORE }
            Q { 'Quit' }
            default { 'Invalid entry' }
        }

        "`n$MenuOptions"
    }

}

MAIN