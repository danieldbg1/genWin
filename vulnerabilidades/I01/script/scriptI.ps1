
#Crear usuario
net user '$username1' '$password1' /add

#Activar rdesktop:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0

#Desactivar seguridad en red:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name "UserAuthentication" -Value 0

#Conectar con usuario que no sea admin:
net localgroup "Remote Desktop Users" $username1 /add


##configuracion_script_final:Start-Service sshd

##configuracion_script_final:net user Administrator '$password_rand1'

