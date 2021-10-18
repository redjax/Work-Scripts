# Path to output file (CSV)
$OutFile = ""
# Header row items
$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
# If there's a previous $Outfile, delete it
Remove-Item $OutFile
# Set up file for populating with results
Add-Content -Value $Header -Path $OutFile

# Path to scan.
$RootPath = ""

# Create object of all folders in scan path
$Folders = Get-ChildItem $RootPath -recurse | Where-Object {$_.psiscontainer -eq $true}

# Loop over folders
foreach ($Folder in $Folders){
	# Get ACLs for each folder in scan path
	$ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  }
	# Loop over found ACLs
	Foreach ($ACL in $ACLs){
		# Output ACL to $Outfile
		$OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
		Add-Content -Value $OutInfo -Path $OutFile
	}}
