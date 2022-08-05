
#Cambiar pass de un usuario y admin
net user '$username1' '$password_rand2' /add

#Activar rdesktop:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0

#Desactivar seguridad en red:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name "UserAuthentication" -Value 0

#Conectar con usuario que no sea admin:
net localgroup "Remote Desktop Users" $username1 /add

#FTP:
mkdir C:\ftp_server
echo '$username1:$password_rand2' > C:\ftp_server\secret.txt

$IP = ((ipconfig.exe | Select-String "192*") -split ":" | Select-String "192") -replace " "

#Crear servidor
New-WebFtpSite -Name 'ftp_server' -Port '21' -PhysicalPath 'C:\ftp_server\' -IPAddress $IP -Force

#Desactivar ssl:
Set-ItemProperty "IIS:\Sites\ftp_server" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0
Set-ItemProperty "IIS:\Sites\ftp_server" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0

#Habilitar conexion anonymous user:
Set-ItemProperty "IIS:\Sites\ftp_server" -Name ftpServer.security.authentication.anonymousAuthentication.enabled -Value $true

#Habilitar conexion usuario:
Add-WebConfiguration "/system.ftpServer/security/authorization" -value @{accessType="Allow";roles="";permissions="Read,Write";users="*"} -PSPath IIS: -location "ftp_server"

##configuracion_script_final:net user Administrator '$password_rand1'
