$PATHS = @("HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
           "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")
$SOFTWARE = "Kaspersky Software Updater"

ForEach ($path in $PATHS) {
    $installed = Get-ChildItem -Path $path |
                 ForEach-Object { Get-ItemProperty $_.PSPath } |
                 Where-Object { $_.DisplayName -match $SOFTWARE } |
                 Select-Object -Property DisplayName,UninstallString

    ForEach ($app in $installed) {
        # Write-Output "$($app.DisplayName,$app.UninstallString)"
        If ($app.UninstallString) {
            $uninst = $app.UninstallString
            & cmd /c $uninst /quiet /norestart
        }
    }
}
