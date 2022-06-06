$USR = $env:UserName
$USR_PATH = "C:\Users\" + $USR
$TEAMS_PATH = $USR_PATH + "\AppData\Roaming\Microsoft\Teams"
$TEAMS_BACKGROUND_PATH = $USR_PATH + "\AppData\Roaming\Microsoft\Teams\Backgrounds"
$TEAMS_OLD_BACKGROUND_PATH = $USR_PATH + "\AppData\Roaming\Microsoft\Teams_old\Backgrounds"
$TEAMS_UPLOAD_PATH = $TEAMS_BACKGROUND_PATH + "\Uploads"
$BACKUP_PATH = $USR_PATH + "\OneDrive - Embrace Pet Insurance\Documents\_backup\teams_backgrounds"

$TEAMS_CACHE_PATH = $USR_PATH + "\AppData\Roaming\Microsoft\Teams"
$TEAMS_OLD_CACHE_PATH = $USR_PATH + "\AppData\Roaming\Microsoft\Teams_Old"

# $TEAMS_PROCESS_PATH = ($ENV:USERPROFILE + "\AppData\Local\Microsoft\Teams")

$BACKUP_FILES = Get-ChildItem -Path $TEAMS_BACKGROUND_PATH
$RESTORE_FILES = Get-ChildItem -Path $BACKUP_PATH

function RUN_BACKUP {

    Write-Host ""
    Write-Host "Backing up Teams backgrounds."
    Write-Host ""

    ForEach ($FILE in $BACKUP_FILES) {
        
        If (-not(Test-Path -Path $BACKUP_PATH"\$($FILE.Name)")) {
            Copy-Item $FILE.FullName -Destination $BACKUP_PATH"\$($FILE.Name)"
        }
        else {
            Write-Host "File $FILE exists in backup location. Skipping"
        }

    }

    Write-Host ""
    Write-Host "Teams backgrounds backed up."
    Write-Host ""

}

function RUN_RESTORE {

    Write-Host ""    
    Write-Host "Restoring Teams backgrounds."
    Write-Host ""

    # ForEach ($FILE in $RESTORE_FILES) {
    #     If (-not(Test-Path -Path $TEAMS_BACKGROUND_PATH\$($FILE.Name))) {
    #         Copy-Item $FILE.FullName -Destination $TEAMS_BACKGROUND_PATH"\$($FILE.Name)"
    #     }
    #     else {
    #         Write-Host "File $FILE exists in Teams backgrounds directory. Skipping."
    #     }
    # }

    Copy-Item -Recurse $TEAMS_OLD_BACKGROUND_PATH -Destination $TEAMS_PATH

    Write-Host ""
    Write-Host "Teams backgrounds restored."
    Write-Host ""

}

function CLEAR_CACHE {

  If (-not(Test-Path -Path $TEAMS_OLD_CACHE_PATH)) {
      # Teams_old dir does not exist
      Write-Output "$TEAMS_OLD_CACHE_PATH does not exist. Backing up cache."
      Move-Item -Path $TEAMS_CACHE_PATH -Destination $TEAMS_OLD_CACHE_PATH

  } else {

      Write-Output "$TEAMS_OLD_CACHE_PATH exists. Deleting."

      Remove-Item $TEAMS_OLD_CACHE_PATH

      Write-Output "Backing up cache."
      Move-Item -Path $TEAMS_CACHE_PATH -Destination $TEAMS_OLD_CACHE_PATH
  }

}

function STOP_PROCESS {

  # $TEAMS_PROCESS_NAME = Get-Process -Name "Teams"

  # Stop the Teams process
  # Stop-Process -InputObject $TEAMS_PROCESS_NAME
  Stop-Process -Name "Teams"
  # Detect that the process has stopped. Outputs $True or $False
  Get-Process | Where-Object {$_.HasExited}

}

function START_PROCESS {

  # Start process (example "PowerShell") as administrator
  # Start-Process -FilePath "powershell" -Verb RunAs

  Set-Location ($ENV:USERPROFILE + '\AppData\Local\Microsoft\Teams')
  Start-Process -File "$($ENV:USERPROFILE)\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList "--processStart 'Teams.exe'"

}

function MAIN {

    $MenuOptions = @'
"Press '1' to backup Teams backgrounds."
"Press '2' to restore Teams backgrounds."
"Press '3' to test starting Teams process"
"Press 'Q' to quit."
'@

    "`n$MenuOptions"

    while(($selection = Read-Host -Prompt "`nSelect an option") -ne 'Q') {
        Clear-Host

        "`n$MenuOptions"

        switch( $selection ) {
            1 { RUN_BACKUP }
            2 { RUN_RESTORE }
            3 { START_PROCESS }
            Q { 'Quit' }
            default {'Invalid entry'}
        }

        "`n$MenuOptions"
    }

}

MAIN