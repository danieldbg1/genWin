mkdir C:\config
echo '
$pass = ConvertTo-SecureString "$password_username1" -AsPlainText -Force
$farmCredential = New-Object System.Management.Automation.PsCredential("$username1", $pass)
Start-Process powershell.exe "Start-Sleep 20" -Credential $farmCredential -Wait -WindowStyle Hidden
' > C:\config\sleep.ps1


echo '
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\ -Name Installer 
New-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\Installer\ -Name AlwaysInstallElevated -Value 1

New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\ -Name Installer 
New-ItemProperty HKCU:\Software\Policies\Microsoft\Windows\Installer\ -Name AlwaysInstallElevated -Value 1

$sid = ((Get-LocalUser -Name $username1 | select sid | Select-String S-1) -split {$_-eq "{" -or $_-eq "=" -or $_-eq "}"} | Select-String S-1) -replace " "
reg add HKU\$sid\Software\Policies\Microsoft\Windows\Installer\ /v AlwaysInstallElevated /t REG_DWORD /d 1
' > C:\config\config.ps1


##configuracion_script:vboxmanage guestcontrol winEnt --username "$username1" --password "$password_username1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" "C:\config\sleep.ps1" 2>/dev/null &
##configuracion_script:sleep 3
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" "C:\config\config.ps1" 2>/dev/null &
##configuracion_script:sleep 5
##configuracion_script:clear


##configuracion_script_final:net user Administrator '$password_rand1'