
#Cambiar pass de un usuario y admin
net user '$username1' '$password1' /add

#Activar rdesktop:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0

#Desactivar seguridad en red:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name "UserAuthentication" -Value 0

#Conectar con usuario que no sea admin:
net localgroup "Remote Desktop Users" $username1 /add

mkdir C:\programa
echo 'ls \\share\\secreto' > C:\programa\programa.ps1





##configuracion_script_final:net user Administrator '$password_rand1'



##configuracion_script:echo '#!/bin/bash' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'while true' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'do' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'vboxmanage guestcontrol win10 --username "$username1" --password "$password1" run -- "C:\Windows\System32\WindowsPowershell\\v1.0\powershell.exe" "C:\programa\programa.ps1" 2>/dev/null &' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'sleep 10' >> ./content/config/programaWinGen.sh
##configuracion_script:echo 'done' >> ./content/config/programaWinGen.sh
##configuracion_script:chmod +x ./content/config/programaWinGen.sh
##configuracion_script:sh ./content/config/programaWinGen.sh 2>/dev/null &