# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
     $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
     Exit
    }
}

# Array with apps to remove. Uncomment to have the script uninstall the app
$apps=@(     
    "9E2F88E3.Twitter" #Twitter
    "ClearChannelRadioDigital.iHeartRadio" #iHeartRadio
    "Flipboard.Flipboard" #Flipboard
    "king.com.CandyCrushSodaSaga" #CandyCrushSodaSaga
    "Microsoft.3DBuilder" #3D Printing Software
    "Microsoft.BingFinance" #Bing Finance
    "Microsoft.BingNews" #Bing News
    "Microsoft.BingSports" #Bing Sports
    "Microsoft.CommsPhone" #Communications - Phone App
    "Microsoft.Getstarted" #Get Started Hub
    "Microsoft.Messaging" #Windows Messenger
    "Microsoft.Office.Sway" #Sway Presentation/Collab Software
    "Microsoft.People" #People Hub
    "Microsoft.SkypeApp" #Skype
    "Microsoft.Windows.Phone" #Windows Phone Connector
    "Microsoft.WindowsPhone" #More Windows Phone
    "Microsoft.XboxApp" #Xbox
    "Microsoft.ZuneMusic" #Zune or Groove Music
    "Microsoft.ZuneVideo" #Zune Video or Groove Video
    "Microsoft.MinecraftUWP" #Minecraft
    "ShazamEntertainmentLtd.Shazam" #Shazam    
	"Microsoft.FreshPaint" #FreshPaint
	"TheNewYorkTimes.NYTCrossword" #New York Times Crossword

    ## Move apps up and uncomment to add them to uninstall loop

    #"Microsoft.Appconnector" #Always required, not sure what it does -- DO NOT REMOVE
    #"Microsoft.BingWeather" #Bing Weather
    #"Microsoft.MicrosoftOfficeHub" #Office 2016 Hub
    #"Microsoft.MicrosoftSolitaireCollection" #Solitaire
    #"Microsoft.Office.OneNote" #OneNote
    #"Microsoft.Windows.Photos" #Photos Hub
    #"Microsoft.WindowsAlarms" #Alarms and Clock
    #"Microsoft.WindowsCalculator" #Calculator
    #"Microsoft.WindowsCamera" #Camera
    #"Microsoft.WindowsMaps" #Maps
    #"Microsoft.WindowsSoundRecorder" #Recorder
    #"Microsoft.WindowsStore" #App Store -- DO NOT REMOVE
    #"Microsoft.windowscommunicationsapps" #Default Mail and Calendar Apps
    #"Microsoft.SurfaceHub" #Surface Hub
    #"Microsoft.ConnectivityStore" #Microsoft WiFi App
)

# Loop over apps in list and run system uninstall command
foreach ($app in $apps) {
    # Print package name 
	Write-Output $app

    # Uninstall package
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
    # Uninstall provisioned package, removing it from all users
    Get-AppXProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online

    # Remove configurations for Modern UI apps
    $appPath="$Env:LOCALAPPDATA\Packages\$app*"
    Remove-Item $appPath -Recurse -Force -ErrorAction 0
}
