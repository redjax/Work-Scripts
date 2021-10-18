$USR = $env:UserName
$USR_PATH = "C:\Users\" + $USR
$TEAMS_BACKGROUND_PATH = $USR_PATH + "\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads"
$BACKUP_PATH = $USR_PATH + "\path\to\backup\teams_backgrounds"

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

    ForEach ($FILE in $RESTORE_FILES) {
        If (-not(Test-Path -Path $TEAMS_BACKGROUND_PATH\$($FILE.Name))) {
            Copy-Item $FILE.FullName -Destination $TEAMS_BACKGROUND_PATH"\$($FILE.Name)"
        }
        else {
            Write-Host "File $FILE exists in Teams backgrounds directory. Skipping."
        }
    }

    Write-Host ""
    Write-Host "Teams backgrounds restored."
    Write-Host ""

}

function MAIN {

    $MenuOptions = @'
"Press '1' to backup Teams backgrounds."
"Press '2' to restore Teams backgrounds."
"Press 'Q' to quit."
'@

    "`n$MenuOptions"

    while(($selection = Read-Host -Prompt "`nSelect an option") -ne 'Q') {
        Clear-Host

        "`n$MenuOptions"

        switch( $selection ) {
            1 { RUN_BACKUP }
            2 { RUN_RESTORE }
            Q { 'Quit' }
            default {'Invalid entry'}
        }

        "`n$MenuOptions"
    }

}

MAIN