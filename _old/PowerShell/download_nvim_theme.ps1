$nvim_conf_base = "~/AppData/Local/nvim"
$colors_dir = "$($nvim_conf_base)/colors"

Write-Host ""
Write-Host "URL to color's .vim file, i.e. 'https://raw.githubusercontent.com/joshdick/onedark.vim/main/colors/onedark.vim'"
$color_url = Read-Host " "
Write-Host "On Windows, the Invoke-WebRequest method requires an output file."
$color_file = Read-Host "Enter the name of the colorscheme (the filename, including '.vim')"
Write-Host ""

Write-Host "Downloading $color_url, saving output to $colors_dir"
Invoke-WebRequest -URI $color_url -OutFile "$($colors_dir)/$($color_file)"

