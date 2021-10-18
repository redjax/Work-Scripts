# Time server URL to sync from
$TIME_SERVER = "time.windows.com"

# Stop the Windows time service
net stop w32time

Write-Host "Setting time server to "$TIME_SERVER

# Set the time service to use the $TIME_SERVER NTP server
w32tm /config /syncfromflags:manual /manualpeerlist:$TIME_SERVER
w32tm /config /reliable:yes

# Restart time service
net start w32time

Write-Host "Time server set. Please manually re-sync time in Windows settings."