# Path to export XML backup to
$ExportPath="c:\users\admin.envisage\desktop\"
# Filename of exported layout in XML format
$ExportFilename="startlayout.xml"


function Export-Layout {
    # Exports Start layout using passed variables
    param([string]$ExportPath,
    [string]$ExportFilename)

    Export-StartLayout -UseDesktopApplicationID -Path $ExportPath$ExportFilename
}


function Import-Layout{
    # Import a previously exported start/taskbar layout
    param([string]$ImportPath,
    [string]$ImportFilename)

    Import-StartLayout -LayoutPath $ImportPath$ImportFilename -MountPath $env:SystemDrive\
}


#Export-Layout -ExportPath $ExportPath -ExportFilename $ExportFilename
Import-Layout -ImportPath $ExportPath -ImportFilename $ExportFilename