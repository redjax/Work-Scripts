@ECHO OFF

echo Performing winsock reset...

@REM Reset IP settings
netsh winsock reset
netsh int ip reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

@REM Reboot computer
shutdown /r /t 0