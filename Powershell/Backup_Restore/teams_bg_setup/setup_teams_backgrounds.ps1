# Get username from env
$USR = $env:UserName
# Set Teams backgrounds\uploads path
$TEAMS_BG_DIR = "c:\users\$USR\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads"

# Load json file with backgrounds
$bgs_json_file = "./backgrounds.json"
# Load json into Powershell variable
$bgs_json = Get-Content -Raw -Path $bgs_json_file | ConvertFrom-Json

# Initialize counter
$i = 0
# Get length/size of json object
$json_size = $bgs_json.Length

function download_bgs {
    # While the counter is smaller than the length of the json object
    While ($i -lt $json_size) {
        # Loop over items in json object
        ForEach ($bg in $bgs_json[$i]) {
            # Set output path for download
            $outpath = "$TEAMS_BG_DIR/" + $bg.name

            # Check if file already exists
            If ( -Not (Test-Path -Path $outpath) ) {
                # File doesn't exist. Try to download
                try {
                    Write-Host "Saving background to: $outpath"

                    Invoke-WebRequest -URI $bg.url -OutFile $outpath
                }
                # Download failed
                catch {
                    throw $_.Exception.Message
                }
            }
            # File already exists
            else {
                Write-Host "Skipping: background " $bg.name "exists at $outpath"
            }

            # Increment counter
            $i++
        }
    }
}

# Check that script was run from elevated command prompt
function check_elevated {

    # Get id of user running script
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    # Check if id is an administrator
    $p = New-Object System.Security.Principal.WindowsPrincipal($id)
    
    # Script launched from elevated prompt
    if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        # Run backgrounds download function
        download_bgs

        Write-Host "Backgrounds downloaded. Re-launch Teams to see new backgrounds."
    }
    # Script not launched from elevated prompt
    else {
        Write-Error "Script must be run as administrator. Please re-launch the script from an elevated terminal"
    }
}

# Check script was run from elevated prompt
check_elevated