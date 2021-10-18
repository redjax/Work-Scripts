@echo off
SET user=""
SET backup_server=""
xcopy c:\users\%user% \\metrolx01\backup\%user%\local_drive\%user%\ /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\my documents" %backup_server% /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\desktop" %backup_server% /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\links" %backup_server% /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\favorites" %backup_server% /D /E /C /H /R /K /O /Y
