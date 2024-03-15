$destination_dir = "$env:USERPROFILE\AppData\Local\nvim\autoload\"

Write-Host "Ensuring dir exists: $($desintation_dir)"
mkdir $destination_dir -Force

$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

(New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$destination_dir\plug.vim"))

