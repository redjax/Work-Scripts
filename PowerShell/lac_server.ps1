##############################################
#                                            #
# This script imports the "userslac.csv,"    #
# or whatever CSV you are using, and creates #
# folders with the items in the CSV, in the  #
# directory the script was run from, then    #
# exports a log with the created directories #
#                                            #
##############################################

# Get current directory and set import file in variable
$path = Split-Path -parent $MyInvocation.MyCommand.Definition

$newpath = $path + "\userslac.csv" # replace with your CSV

# Define variables
$log = $path + "\logfile.log"
$date = Get-Date

# FUNCTIONS
Function createDirs
{
"Created following directories (on " + $date + ") " | Out-File $log -append
"--------------------------------------------" | Out-File $log -append
Import-CSV $newpath | ForEach-Object {
$dir = $path + "\" + $_.Folders
$dir = $dir.ToLower()
New-Item $dir -type directory
}
}

# RUN SCRIPT
createDirs