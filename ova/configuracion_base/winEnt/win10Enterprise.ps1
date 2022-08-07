#Se crea con el vboxmanage sharedfolder
cd Z:\

#Instalar ps2exe (https://github.com/MScholtes/PS2EXE)
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MScholtes/PS2EXE/master/Module/ps2exe.ps1 -Outfile .\ps2exe.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MScholtes/PS2EXE/master/Module/ps2exe.psd1 -Outfile .\ps2exe.psd1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MScholtes/PS2EXE/master/Module/ps2exe.psm1 -Outfile .\ps2exe.psm1
Install-Module ps2exe -Force

#Desactiar firewall:
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

#Disable Cloud-delivered Protection
PowerShell Set-MpPreference -MAPSReporting Disabled

#Disable Automatic Sample Submission
Set-MpPreference -SubmitSamplesConsent 2

#Desactivar Tamper Protection

#Desactivar antivirus en tiempo real:
Set-MpPreference -DisableRealtimeMonitoring $true

#Desactivar Windows Update
sc.exe stop "wuauserv"

#Instalar ssh
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

#Instalar ftp
Enable-WindowsOptionalFeature -Online -FeatureName IIS-FtpServer -All

#Instalar snmp
Add-WindowsCapability -Online -Name "SNMP.Client~~~~0.0.1.0"

#Instalar modulo AD
Get-WindowsCapability -Name RSAT.ActiveDirectory* -Online | Add-WindowsCapability -Online


#Cambiar nombre PC
Rename-Computer -NewName danielpc


#Borrar historial powershell
Clear-History

Restart-Computer