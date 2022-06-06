@echo off

@REM
@REM VARS

@ REM Vars for C:\Windows\ dirs to be renamed
SET /A DATASTORE_DIR=%SYSTEMROOT%\SoftwareDistribution\DataStore
SET /A DOWNLOAD_DIR=%SYSTEMROOT%\SoftwareDistribution\Download
SET /A CATROOT_DIR=%SYSTEMROOT%\System32\catroot2


@REM Find service state for WUAUSERV, skip if stopped
for /F "tokens=3 delims=: " %%H in ('sc query "WUAUServ" ^| findstr "        STATE"') do (
  if /I "%%H" NEQ "STOPPED" (
   @REM Kill WUAUServ service
   taskkill /F /FI "SERVICES eq wuauserv"
  )
)

@REM Stop services related to Windows Update
net stop cryptSvc
net stop bits
net stop msiserver

@REM Rename/backup Windows Update directories

IF EXIST %DATASTORE_DIR%.old del %DATASTORE_DIR%.old
ren %DATASTORE_DIR% DataStore.old

IF EXIST %DOWNLOAD_DIR%.old del %DOWNLOAD_DIR%.old
ren %DOWNLOAD_DIR% Download.old

IF EXIST %CATROOT_DIR%.old del %CATROOT_DIR%.old
ren %CATROOT_DIR% catroot2.old


@REM Restart Windows Update services
@REM net start wuauserv

net start cryptSvc
net start bits
net start msiserver
