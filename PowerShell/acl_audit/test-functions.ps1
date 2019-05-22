function Build-Filename {
	Param ([string]$filepath, [string]$filename)

    $BuiltFilename = $filepath + $filename + ".csv"
    return $BuiltFilename
}

$OutFile = Build-Filename -filepath "C:\Users\jxk5224\Desktop\" -filename "test_file"

Write-Host($OutFile)
