
# Build & return full filepath to outfile
function Build-Filename {
	# Takes 2 args, the outfile's desired path & file name without extension
	Param ([string]$filepath, [string]$filename)

	# Create variable for outfile with full path, filename, & extension
	$BuiltFilename = $filepath + $filename + ".csv"
	# Return the built filepath
    return $BuiltFilename
}

# Create file and add headers
function Prepare-Outfile {
	Param([string]$Header, [string]$OutFile)

	# Set up file for populating with results
	Add-Content -Value $Header -Path $OutFile
}

# Scan directory & subdirectories for ACLs, write to file
function Scan-Folder {
	Param([string]$RootPath, $OutFile)

	# Create object of all folders in scan path
	$Folders = dir $RootPath -recurse | where {$_.psiscontainer -eq $true}

	# Loop over folders
	foreach ($Folder in $Folders){
		# Get ACLs for each folder in scan path
		$ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  }
		# Loop over found ACLs
		Foreach ($ACL in $ACLs){
			# Output ACL to $Outfile
			$OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
			Add-Content -Value $OutInfo -Path $OutFile
		}
	}
}


# Path to write file to
$OutPath = "C:\Users\jxk5224\Desktop\"
# Name of output file, without file extension
$OutFilename = "test_file"

# Build the filename
$OutFile = Build-Filename -filepath $OutPath -filename $OutFilename
# Create file and add headers
$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
Prepare-Outfile -header $Header -outfile $OutFile

# Run the scan & output results to file
# Path to scan
$RootPath = "z:\"
Scan-Folder -rootpath $RootPath -outfile $OutFile
