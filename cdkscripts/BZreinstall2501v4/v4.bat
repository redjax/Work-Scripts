@ ECHO off
color 17
REM ====================================================================================
REM == David Beresheim & Brad Centers
REM == Bluezone 4.1//6.1/6.2 adpinit/cdkinit Reinstall Tool
REM == 07/16/2018
REM == v.4
REM ====================================================================================

ECHO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ECHO THIS TOOL MUST BE RAN WITH ADMINISTRATOR PRIVILAGES TO WORK PROPERLY. 
ECHO.
ECHO RIGHT CLICK ON THE .EXE FILE AND CHOOSE "RUN AS ADMINISTRATOR"
ECHO MAKE SURE DRIVE IS CLOSED DOWN BEFORE STARTING

ECHO  YOU CAN IGNORE ERRORS ABOUT "NOT FOUND" - THOSE ARE NORMAL
ECHO.
ECHO BLUEZONE LOG FILE IS CREATED FROM DIRECTORY THIS SCRIPT IS EXECUTED FROM
ECHO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
ECHO REMOVING ALL BLUEZONE SOFTWARE - THIS COULD TAKE A FEW MINUTES: 


REM SAVING DIRECTORY FOR BATCH CALL LATER
@setlocal enableextensions
@cd /d "%~dp0"
setlocal



:START
CLS
ECHO ======================================================
ECHO PLEASE WAIT AS THIS WILL TAKE SOME TIME. THE ROUTINE
ECHO IS WORKING THOUGH IT MAY LOOK STALLED...
ECHO ======================================================
call :Logit>>BlueZoneReinstall.log 2>&1
:Logit

REM : Kill Drive processes
taskkill /IM wsstart.exe /F 
taskkill /IM wsstart_2.exe /F 
taskkill /IM wsstart_4.exe /F 
taskkill /IM BZVT.exe /F 
taskkill /IM BZVBA.exe /F 
taskkill /IM dfsvc.exe /F
taskkill /IM sw9c.exe /F 


REM : Copy BLuezone folders over in case user has custom Macros:

MKDIR "%userprofile%\Documents\BlueZone Backup\%Datefolder%"
xcopy "%userprofile%\Documents\BlueZone" "%userprofile%\Documents\BlueZone Backup\%Datefolder%" /E /Y >NUL

REM: Removel of Bluezone 6.2 VBA
start /wait MsiExec.exe /X{374C62B2-C3F7-4c33-841E-5AD4627ECF9F} /qn
start /wait MsiExec.Exe /x{90F50409-6000-11D3-8CFE-0150048383C9} /qn

REM: Remove sglw2hcm for 6.2:
start /wait MsiExec.exe /X{38A229CB-4547-478F-B2C4-FB0D336813FD} /qn

REM: Remove Patch 1
start /wait MsiExec.exe /X{359846D6-19CE-480E-9FDF-02359052CEA4} /qn
start /wait MsiExec.exe /X{E495B22B-232B-4094-90B3-0FD4BC4B7B64} /qn

REM: Remove Bluezone 6.2:
start /wait MsiExec.exe /X{49D3D8A3-F983-40B1-B668-2B7B2C4B2154} /qn

REM: Remove Bluezone VBA 6.1.9.2288
start /wait MsiExec.exe /X{383D7832-FC67-4BFA-816E-88B80A0D95ED} /qn

REM: Remove Bluezone VBA 6.1.00
start /wait MsiExec.exe /X{374C61B2-C3F7-4c33-841E-5AD4627ECF9F} /qn

REM: Remove EMulator VBA
start /wait MsiExec.exe /X{374C61B2-C3F7-4c33-841E-5AD4627ECF9F} /qn

REM: Remove Bluezone 6.1.9.2290
start /wait MsiExec.exe /X{498CDC54-B572-4B23-8E65-2C95DA2F0D08} /qn

REM: Remove Rebrander:
start /wait MsiExec.exe /X{5C6ADDC7-067C-4236-B788-2B3F4B6F47A4} /qn

REM: Remove VBA 952:
start /wait MsiExec.exe /X{69EF9BED-A297-4204-90F0-F1CC803AC4FA} /qn 

REM: remove BZ4 if exist
start /wait MsiExec.exe /X{374C88B2-C3F7-4c33-841E-5AD4627ECF9F} /qn


REM: Remove 1010:
start /wait MsiExec.exe /X{5DCA09DF-B911-48BB-82B7-89A35A0F49B7} /qn

REM: Adpinit 1.6.2
start /wait MsiExec.exe /X{BB3B5869-A650-425E-9985-76CA48A8DDAF} /qn

REM: Remove CDKInit:
start /wait MsiExec.exe /X{40FDC133-63DC-4B03-B74B-7573CEB2EA9F} /qn

REM: Delete Files/Folders

SET DIRECTORY_NAME="C:\program files (x86)\adp\websuite TE"
TAKEOWN /f %DIRECTORY_NAME% /r /d y
ICACLS %DIRECTORY_NAME% /grant administrators:F /t
attrib -r %DIRECTORY_NAME% 


RD "C:\program files (x86)\adp\websuite TE" /S /Q
RD "C:\ProgramData\Bluezone" /S /Q
RD "%userprofile%\AppData\Roaming\BlueZone" /S /Q
RD "%userprofile%\Documents\BlueZone" /S /Q
RD "C:\Users\Default\Documents\BlueZone" /S /Q
RD "C:\Users\Public\Documents\BlueZone" /S /Q
RD "C:\Program files (x86)\bluezone" /S /Q
RD "C:\program files (x86)\bluezone vba" /s /Q
RD "C:\windows\downloaded program files\6.2" /S /Q

REM: Unregister and delete OCX 
regsvr32 /u "C:\windows\downloaded program files\sglw2hcm.ocx" /s
CD /D "c:\windows\downloaded Program Files"
MOVE /Y "c:\windows\downloaded Program Files\sglw2hcm.ocx" "c:\windows\temp\sglw2hcm.ocx"

REM: DELETE REG KEYS

%SystemRoot%\system32\reg.exe delete HKCU\Software\Seagull\Bluezone /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Seagull\BluezoneWeb /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{a2f2261a-e04a-490a-a155-62193ea58753} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\{a2f2261a-e04a-490a-a155-62193ea58753} /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\ProgramData\\BlueZone\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\ProgramData\\BlueZone\\Macros\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\Program Files (x86)\\ADP\\webSuite TE\\Macros\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\ProgramData\\Bluezone\\Scripts\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\Program Files (x86)\\ADP\\websuite TE\\6.2\\Config\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\Program Files (x86)\\ADP\\websuite TE\\6.2\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\Program Files (x86)\\ADP\\websuite TE\\6.2\\Macros\\" /f 
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\Program Files (x86)\\ADP\\websuite TE\\6.2\\Scripts\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders /v "C:\\ProgramData\\Bluezone\\Config\\" /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "ADPInit" /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\BlueZone /f 
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\BlueZone /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Dependencies\{5C6ADDC7-067C-4236-B788-2B3F4B6F47A4}\Dependents\{a2f2261a-e04a-490a-a155-62193ea58753} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Dependencies\{38A229CB-4547-478F-B2C4-FB0D336813FD} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.OIA.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.QuickPad /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.QuickPad.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.QuickPads /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.QuickPads.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Screen /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Screen.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Session /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Session.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Sessions /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Sessions.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Vector /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Vector.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.WhllObj /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.WhllObj.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.WhllObj.6.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\SGLW2HCM.Sglw2hcmCtrl.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\SGLW2HCM.Sglw2hcmCtrl.6.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\TypeLib\{63EF98D3-EBB2-6166-B1FD-928B7F71BE4D} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{037790A7-1576-11D6-903D-00105AABADD3} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{1111BAA7-6F6F-45C4-A3BF-4C987E242D34} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{25A66EAA-5E16-4AA8-BAD1-263E44FC5334} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{63EF98D6-EBB2-6166-B1FD-928B7F71BE4D} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{DCBC6AFE-FB6D-43F8-98AB-69F0D3065EE0} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{E90CA4E8-9211-4E96-9F51-2371C2DF3AD5} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\TypeLib\{63EF98D3-EBB2-6166-B1FD-928B7F71BE4D} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{037790A7-1576-11D6-903D-00105AABADD3} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{1111BAA7-6F6F-45C4-A3BF-4C987E242D34} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{25A66EAA-5E16-4AA8-BAD1-263E44FC5334} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{63EF98D6-EBB2-6166-B1FD-928B7F71BE4D} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{DCBC6AFE-FB6D-43F8-98AB-69F0D3065EE0} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{E90CA4E8-9211-4E96-9F51-2371C2DF3AD5} /f 
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Classes\TypeLib\{63EF98D3-EBB2-6166-B1FD-928B7F71BE4D} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\SEAGULL\BlueZone /f
%SystemRoot%\system32\reg.exe delete "HKCU\Software\SEAGULL\BlueZone Web" /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.FTP.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.iSeriesDisplay.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.iSeriesPrinter.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.MainframeDisplay.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.MainframePrinter.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.SessionManagerLayout.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.TCP/IPPrintServer.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BlueZone.VTDisplay.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Bzvba.Vbahost /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Bzvba.Vbahost.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Bzvba.Vbahost.6.2 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Area /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Area.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutConnInfo /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutConnInfo.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutConnList /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutConnList.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutOIA /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutOIA.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutPS /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutPS.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutSess /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.AutSess.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.EmuWnd /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.EmuWnd.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Field /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.Field.1 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\BZWhll.OIA /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Dependencies\{5C6ADDC7-067C-4236-B788-2B3F4B6F47A4} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Dependencies\{a2f2261a-e04a-490a-a155-62193ea58753} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Features\FD90ACD5119BBB84287B983AA5F0947B /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Products\90405F0900063D11C8EF10054038389C /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Products\90406F0900063D11C8EF10054038389C /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{CB136257-2A7C-42C4-9E21-8F70C092C424} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Wow6432Node\TypeLib\{B018A152-7907-47E2-9120-075F158BC1CA} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\07F7EA7A448E0294C83FCBA124248A0A /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\6C1F25C4E1C626B4F8AED792A2C3066E /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\DDA1A0A48B6C3F9429091D99D8A60518 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\90406F0900063D11C8EF10054038389C /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\FD90ACD5119BBB84287B983AA5F0947B /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\90405F0900063D11C8EF10054038389C /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Classes\Wow6432Node\CLSID\{037790A6-1576-11D6-903D-00105AABADD3} /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Classes\Wow6432Node\CLSID\{037790A7-1576-11D6-903D-00105AABADD3} /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Classes\Wow6432Node\CLSID\{1111BAA7-6F6F-45C4-A3BF-4C987E242D34} /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Classes\Wow6432Node\CLSID\{25A66EAA-5E16-4AA8-BAD1-263E44FC5334} /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Classes\Wow6432Node\CLSID\{DCBC6AFE-FB6D-43F8-98AB-69F0D3065EE0} /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Classes\Wow6432Node\CLSID\{E90CA4E8-9211-4E96-9F51-2371C2DF3AD5} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Components\BAE01AA73F5E8CD5E97473E327F7D9CF /f
%SystemRoot%\system32\reg.exe delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\BlueZone VBA 6.2" /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{90F60409-6000-11D3-8CFE-0150048383C9} /f
REM Added post deploy
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Products\3A8D3D94389F1B046B86B2B7C2B41245 /f
%SystemRoot%\system32\reg.exe delete HKCU\Software\Microsoft\VBA\6.0\BlueZone /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{359846D6-19CE-480E-9FDF-02359052CEA4} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{90F50409-6000-11D3-8CFE-0150048383C9} /f
%SystemRoot%\system32\reg.exe delete HKU\.DEFAULT\Software\BlueZone /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Products\35C113B567AAF814A8050E1153BA8AB6 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Classes\Installer\Products\C539BE82CEEA18543B791E3630EDE64E /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\2B88C4737F3C33c448E1A54D26E7FCF9 /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\C539BE82CEEA18543B791E3630EDE64E /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{28EB935C-AEEC-4581-B397-E16303DE6EE4} /f
%SystemRoot%\system32\reg.exe delete HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{374C88B2-C3F7-4c33-841E-5AD4627ECF9F} /f

REM CALLING INSTALL SCRIPT
ENDLOCAL

goto INSTALL





:INSTALL
@ Echo off		

REM **************************************************************
REM Bluezone Install Script
REM Brad Centers
REM v 0.4
REM 07-16-2018
REM **************************************************************
CLS



@setlocal enableextensions
@cd /d "%~dp0"
setlocal

wmic Product where "name like 'ADP Terminal Emulator%%'" call uninstall 
Wmic product where "name like 'w.e.b.%%'" call uninstall 
Wmic product where "name like 'ADPinit%%'" call uninstall 
WMIC Product where "name like 'Rebrand CDK BlueZone%%'" call uninstall 
WMIC Product where "name like 'CDK Init%%'" call uninstall 
Wmic product where "name like 'ADP View Client%%'" call uninstall 
C:\ProgramData\Bluezone\ADPInit.exe -u 2>nul

ECHO ======================================================
ECHO INSTALLING THE TERMINAL EMULATOR 6.2 AND PATCHES... 
ECHO ======================================================
START /wait BlueZoneInstaller.exe /passive /quiet
START /wait VC.msi
START /wait CDK_ViewClient_Update.msi

REM FINDING OS TYPE
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if %OS%==32BIT (
START /wait Init86.msi 
) ELSE (
START /wait Init64.msi 
)

DEL *.bat /s /q 2>nul
DEL "%~f0" 2>nul
GOTO EXIT
:EXIT
END






















