mkdir C:\temp
mkdir C:\Users\Administrator\backup
#El k modifico(hacer link a este)
Write-Output '
query user /server:$SERVER >> C:\Users\Administrator\backup\log.txt
' | Set-Content C:\temp\backup.ps1

#El k veo
Write-Output '
C:\temp\backup.ps1
' | Set-Content 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\script.ps1'


#Start
Write-Output "
while(`$true){
`$pass = ConvertTo-SecureString '`$`$password_rand1' -AsPlainText -Force
`$farmCredential = New-Object System.Management.Automation.PsCredential('administrator', `$pass)
Start-Process powershell.exe `"Get-ChildItem 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\`' | ForEach-Object { if (```$_.FullName -like '*.ps1'){ & ```$_.FullName } }`" -Credential `$farmCredential -Wait -WindowStyle Hidden
sleep 60
}
" | Set-Content C:\Users\Administrator\Desktop\start.ps1

#Añadir usuario privs escritura en el path 
$acl = Get-Acl 'C:\temp\backup.ps1'
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule('$username1','Write','Allow')
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl 'C:\temp\backup.ps1'



#Ejecutar en consola
##configuracion_script:echo '#!/bin/bash' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'vboxmanage guestcontrol win10 --username "administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\\v1.0\powershell.exe" "C:\Users\Administrator\Desktop\start.ps1" 2>/dev/null &' >> ./content/config/programaWinGen.sh
##configuracion_script:chmod +x ./content/config/programaWinGen.sh
##configuracion_script:sh ./content/config/programaWinGen.sh 2>/dev/null &