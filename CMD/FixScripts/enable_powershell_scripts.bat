@ECHO OFF

REM Run PowerShell, elevate session, and run Set-ExecutionPolicy Unrestricted
REM Policy options: Restricted (default), AllSigned, RemoteSigned, Unrestricted
PowerShell.exe -NoProfile -Command "&{ Start-Process PowerShell -ArgumentList '-NoProfile Set-ExecutionPolicy Unrestricted' -Verb RunAs}"