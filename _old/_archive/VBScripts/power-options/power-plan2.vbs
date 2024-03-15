' =========================================== '
' Power Options Script
' =========================================== '

' =========================================== '
'           || Declare Variables ||
' =========================================== '

Dim powercfg, pDuplicate, pChangeName, pSetActive, pChange
Dim guidDefault, guidDuplicate, guidCustom
Dim flMonTOac, flMonTOdc, flDiskTOac, flDiskTOdc, flSbyTOac, flSbyTOdc, flHibTOac, flHibTOdc
Dim cmdMonAc, cmdMonDc, cmdDiskAc, cmdDiskDc, cmdSbyAc, cmdSbyDc, cmdHibAc, cmdHibDc
Dim cmdDup, cmdChangeName, cmdSetActive, cmdChange

' =========================================== '
'           || Create Environment ||
' =========================================== '

Dim objFSO : Set objFSO = CreateObject("Scripting.FileSystemObject")
Dim objShell : Set objShell = WScript.CreateObject("WScript.Shell")

' =========================================== '
'       || Powercfg command and flags ||
' =========================================== '

powercfg = "POWERCFG"
pDuplicate = powercfg & " -DUPLICATESCHEME"
pChangeName = powercfg & " -CHANGENAME"
pSetActive = powercfg & " -SETACTIVE"
pChange = powercfg & " -CHANGE"

' =========================================== '
'          || GUIDs for Power Plans ||
' =========================================== '

guidDefault = "381b4222-f694-41f0-9685-ff5bb260df2e"
guidDuplicate = "381b4222-f694-41f0-9685-ff5bb260aaaa"
guidCustom = "Custom1"

' =========================================== '
'           || Timeout Options ||
' =========================================== '

flMonTOac = "-monitor-timeout-ac " & 0
flMonTOdc = "-monitor-timeout-dc " & 0
flDiskTOac = "-disk-timeout-ac " & 0
flDiskTOdc = "-disk-timeout-dc " & 0
flSbyTOac = "-standby-timeout-ac " & 0
flSbyTOdc = "-standby-timeout-dc " & 0
flHibTOac = "-hibernate-timeout-ac " & 0
flHibTOdc = "-hibernate-timeout-dc " & 0

' Build commands to be run. chr(34) = " symbol
cmdDup = pDuplicate & " " & guidDefault & " " & guidDuplicate
cmdChangeName = pChangeName & " " & guidDuplicate & " " & chr(34) & guidCustom & chr(34)
cmdSetActive = pSetActive & " " & guidDuplicate
cmdMonAc = pChange & " " & flMonTOac
cmdMonDc = pChange & " " & flMonTODc
cmdDiskAc = pChange & " " & flDiskTOac
cmdDiskDc = pChange & " " & flDiskTOdc
cmdSbyAc = pChange & " " & flSbyTOac
cmdSbyDc = pChange & " " & flSbyTOdc
cmdHibAc = pChange & " " & flHibTOac
cmdHibDc = pChange & " " & flHibTOdc
