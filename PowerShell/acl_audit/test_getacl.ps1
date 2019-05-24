function Build-Filename {
	# Build & return full filepath to outfile
	Param ([string]$filepath, [string]$filename)

	# Create variable for outfile with full path, filename, & extension
	$BuiltFilename = $filepath + $filename + ".csv"
	# Return the built filepath
    return $BuiltFilename
}


function Prepare-Outfile {
	# Create file and add headers
	Param([string]$Header, [string]$OutFile)

	# Set up file for populating with results
	Add-Content -Value $Header -Path $OutFile
}


function Scan-Folder {
	# Scan directory & subdirectories for ACLs, write to file
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


function Map-Drive {
	# Temporarily map scan folder if it is on network share
	Param([string]$DriveLetter,
		  [string]$RootPath,
		  [string]$Username,
		  [string]$passwd)

	$net = new-object -comobject wscript.network
	$net.mapnetworkdrive($DriveLetter, "$RootPath", $false, "rtlsvcs\$username", "$passwd")

}


function Unmap-Drive {
	# Unmap drive at the end of script run
	Param([string]$RootPath)
}


# $DriveLetter: Letter to temporarily map drive to
# $OutPath: Path to write file to
# $OutFileName: Name of output file, without file extension
# $OutFile: Build filename & prepare to write to file
# $Header: Create the file and add CSV headers
# $RootPath: Path to run ops on
$DriveLetter = "p:"
$OutPath = "C:\Users\jxk5224\Desktop\"
$OutFilename = "test_file"
$OutFile = Build-Filename -filepath $OutPath -filename $OutFilename
$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
Prepare-Outfile -header $Header -outfile $OutFile
$RootPath = "\\metrolx01\backup\jxk5224\access"


Map-Drive -DriveLetter $DriveLetter -RootPath $RootPath -Username "jxk5224" -passwd "L3xusM3tro"
Scan-Folder -rootpath $RootPath -outfile $OutFile
