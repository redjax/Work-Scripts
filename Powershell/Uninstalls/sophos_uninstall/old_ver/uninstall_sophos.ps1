# https://support.sophos.com/support/s/article/KB-000035419?language=en_US

$base_unins_cmd = "MsiExec.exe /X"
$unins_exe = "C:\Program Files\Sophos\Sophos Endpoint Agent\uninstallcli.exe"

# Flags
$silent = "/qn"
$delay_reboot = "REBOOT=ReallySuppress"
$create_logs = "/L*v c:\tmp\Uninstall_SAV10_Log.txt"

$json_file = "./uninstall_strings.json"
$json_content = Get-Content -Raw -Path $json_file | ConvertFrom-Json -Depth 5

# $json_size = $json_content.Length
$json_32 = $json_content.32
$json_32_length = ($json_32).Length
$json_64 = $json_content.64
$json_64_length = ($json_64).Length

$32i = 0
$64i = 0

# Array with uninstall strings
$arr_unins_strings = @()

# Sophos service names to stop with NET STOP
$arr_services = @(
    "Sophos AutoUpdate Service",
    "Sophos System Protection Service",
    "Sophos File Scanner Service",
    "Sophos Health Service",
    "Sophos Live Query",
    "Sophos Managed Threat Response",
    "Sophos MCS Agent",
    "Sophos MCS Client",
    "Sophos Network Threat Protection"
)

ForEach ($service in $arr_services) {
    try {
        Write-Output """$service"""
        cmd.exe /c "net stop ""$service"""
    }
    catch {
        Write-Host "err"
    }
}

# Create 32 bit array
While ($32i -lt $json_32_length) {
    ForEach ($obj in $json_32[$32i]) {
        # Write-Host "$32i. Name:" $obj.name
        # Write-Host "$32i. Uninstall string:" $obj.uninstall_string
        $obj_unins_string = $obj.uninstall_string
        $full_unins_string = "$base_unins_cmd$obj_unins_string $delay_reboot $silent"

        
        # Write-Host "$32i. Uninstall cmd:" $full_unins_string

        $arr_unins_strings += $full_unins_string
    }

    $32i++
}

# Create 64 bit array
While ($64i -lt $json_64_length) {
    ForEach ($obj in $json_64[$64i]) {
        # Write-Host "$64i. Name:" $obj.name
        # Write-Host "$64i. Uninstall string:" $obj.uninstall_string
        $obj_unins_string = $obj.uninstall_string
        
        $full_unins_string = "$base_unins_cmd$obj_unins_string $delay_reboot $silent"
        
        # Write-Host "$64i. Uninstall cmd:" $full_unins_string

        $arr_unins_strings += "$full_unins_string"
    }

    $64i++
}

# Loop over array with uninstall strings, pipe into cmd
ForEach ($obj in $arr_unins_strings) {
    try {
        # cmd.exe /c """$obj"""
    }
    catch {
        Write-Error "Error running command:" $obj
    }
}
