# Docs: https://docs.sophos.com/esg/endpoint/help/en-us/help/Uninstall/index.html
# Purpose: Pipe the Sophos uninstallcli.exe into a cmd session to uninstall Sophos Antivirus

# Check if Sophos directory exists
If (-Not (Test-Path -Path "C:\Program Files\Sophos")) {
    # Sophos dir does not exist. Exit successully
    Exit 0
}
else {
    # Sophos dir exists. Run path to uninstallcli.exe

    # Stop the Sophos AutoUpdate service
    cmd.exe /C "net stop ""Sophos AutoUpdate Service"""
    # Run uninstaller
    cmd.exe /c "C:\Program Files\Sophos\Sophos Endpoint Agent\uninstallcli.exe"
}
