@echo off
SET user=""
xcopy c:\users\%user% <FILE_SERVER_PATH> /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\my documents" <FILE_SERVER_PATH> /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\desktop" <FILE_SERVER_PATH> /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\links" <FILE_SERVER_PATH> /D /E /C /H /R /K /O /Y
xcopy "c:\documents and settings\%user%\favorites" <FILE_SERVER_PATH> /D /E /C /H /R /K /O /Y
