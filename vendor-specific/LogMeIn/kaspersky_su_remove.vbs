const HKEY_CLASSES_ROOT  = &H80000000
const HKEY_CURRENT_USER  = &H80000001
const HKEY_LOCAL_MACHINE = &H80000002
const HKEY_USERS     = &H80000003
const HKEY_CURRENT_CONFIG = &H80000004
const HKEY_DYN_DATA    = &H80000005

strComputer = "."

set oWsh = createobject("wscript.shell")

Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" _
     & strComputer & "\root\default:StdRegProv")

strKeyPath = "Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" ' Root level
oReg.EnumKey HKEY_LOCAL_MACHINE, strKeyPath, arrSubKeys

sMatch = "Kaspersky Software Updater"
For Each subkey In arrSubKeys
 on error resume next
 sDisplayName = oWsh.Regread("HKLM\" & strKeyPath & "\" & subkey & "\DisplayName")
 if err.number = 0 then
  on error goto 0
  if instr(sDisplayName, sMatch) > 0 then
   On Error Resume Next
   sUninstall = oWsh.Regread("HKLM\" & strKeyPath & "\" & subkey & "\UnInstallString")
   If Err.Number = 0 Then
    wsh.echo subkey, vbCRLF, sDisplayName, vbCRLF, sUnInstall, vbCRLF, vbCRLF
   Else
     wsh.echo subKey, vbCrLf, sDisplayName, vbCrLf, "<None>", vbCrLf, vbCrLf
   End If
   On Error GoTo 0
  end if
 end if
Next
on error goto 0
