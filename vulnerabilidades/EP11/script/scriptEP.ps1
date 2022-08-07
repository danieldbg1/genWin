
cp "C:\Program Files (x86)\Microsoft\Temp\ProcessMonitor\Procmon64.exe" C:\Users\Administrator\Desktop\Procmon64.exe 

echo "
Start-Process powershell.exe `"C:\'Program Files (x86)'\Microsoft\Edge\Application\msedge.exe`"
" > C:\Users\Administrator\Desktop\script.ps1


echo "
`$pass = ConvertTo-SecureString '$password_rand1' -AsPlainText -Force
`$farmCredential = New-Object System.Management.Automation.PsCredential('administrator', `$pass)
Start-Process powershell.exe 'C:\Users\Administrator\Desktop\Procmon64.exe' -Credential `$farmCredential -Wait -WindowStyle Hidden
" > C:\Users\Administrator\Desktop\script_Procmon64.ps1

net localgroup 'ProcessMonitor' /comment:"Ejecutar Procmon64.exe como administrator: C:\Users\Administrator\Desktop\script_Procmon64.ps1" /add

net localgroup 'ProcessMonitor' $username1 /add 

$acl = Get-Acl C:\Users\Administrator\Desktop\script_Procmon64.ps1
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("ProcessMonitor","ReadAndExecute","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl C:\Users\Administrator\Desktop\script_Procmon64.ps1

$acl = Get-Acl "C:\Program Files (x86)\Microsoft\Edge\Application"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users","Write","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl "C:\Program Files (x86)\Microsoft\Edge\Application"


##configuracion_script:echo '#!/bin/bash' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'while true' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'do' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\\v1.0\powershell.exe" "C:\Users\Administrator\Desktop\script.ps1" 2>/dev/null &' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'sleep 60' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'done' >> ./content/config/programaWinGen.sh
##configuracion_script:chmod +x ./content/config/programaWinGen.sh
##configuracion_script:sh ./content/config/programaWinGen.sh 2>/dev/null &