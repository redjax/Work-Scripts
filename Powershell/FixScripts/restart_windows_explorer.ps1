## Remove the space between "#" and "Requires" to check that user running script is an Administrator
# Requires -RunAsAdministrator

function Stop-ExplorerProcess {
    try {
        Stop-Process -Name "explorer" -Force
    }
    catch {
        Write-Error "Unhandled exception restarting Windows Explorer service. Details: $($_.Exception.Message)"
    }
}

function main {
    Write-Host "Restarting Windows Explorer process" -ForegroundColor Yellow
    try { 
        Stop-ExplorerProcess
        Write-Host "Windows Explorer restarted" -ForegroundColor Green
    }
    catch {
        Write-Error "Unable to restart Windows Explorer"
    }
}

main
