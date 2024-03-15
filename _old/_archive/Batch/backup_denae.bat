@echo off
SET user="<USER_NAME>"
xcopy c:\users\%user% \\metrolx01\backup\%user%\local_drive\%user%\ /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\my documents" \\metrolx01\backup\%user%\local_drive\documents\ /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\desktop" \\metrolx01\backup\%user%\local_drive\desktop\ /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\links" \\metrolx01\backup\%user%\local_drive\links\ /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\favorites" \\metrolx01\backup\%user%\local_drive\favorites\ /D /E /C /H /R /K /O /Y
ECHO TRUE>>"<FILE_SERVER_PATH>"
