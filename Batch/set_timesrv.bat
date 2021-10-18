rem Stop w32time service.
net stop w32time

 

rem Manually setting list of time servers. Setting to EPIDC1 and time.windows.com.
w32tm /config /syncfromflags:manual /manualpeerlist:"garfield.embrace.local,time.windows.com"

 

rem Setting the connection as reliable.
w32tm /config /reliable:yes

 

rem Start w32time service.
net start w32time

 

rem Verify configuration.
w32tm /query /configuration
w32tm /query /status

 

rem Pause.
pause