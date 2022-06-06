$CHECK_USER = Read-Host -Prompt 'AD username to check for last login: '

Write-Host "Checking last login time for $CHECK_USER"

Get-ADUser -Identity $CHECK_USER -Properties LastLogon | Select-Object Name, @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}}