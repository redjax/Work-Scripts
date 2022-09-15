# Purpose: Run REG QUERY to get 32 and 64 bit uninstall strings. Output to txt files.
$32_cmd = "REG QUERY HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall /s /f SOPHOS > ""./Sophos_Uninstall_Strings32.txt"""
$64_cmd = "REG QUERY HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall /s /f SOPHOS > ""./Sophos_Uninstall_Strings64.txt"""

# Run commands
cmd .exe /c "$32_cmd"
cmd .exe /c "$64_cmd"
