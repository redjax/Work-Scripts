function Use-Filename {
	Param ([string]$filepath, [string]$filename)

    $BuiltFilename = $filepath + $filename + ".csv"
    return $BuiltFilename
}

$OutFile = Use-Filename -filepath "" -filename "test_file"

Write-Host($OutFile)
