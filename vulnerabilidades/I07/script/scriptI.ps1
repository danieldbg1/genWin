#Activar ssh y desactivar conexiones con contraseña
Start-service sshd
(Get-Content -Path C:\ProgramData\ssh\sshd_config -Raw) -replace '#PasswordAuthentication yes', 'PasswordAuthentication no' | Set-Content -Path C:\ProgramData\ssh\sshd_config
Restart-Service sshd


#Cambiar pass de un usuario y admin
net user '$username1' '$password_rand2' /add
#Username2 se crea en el script.txt y se mete en el grupo "Remote Management Users"
#net user '$username2' '$password1' /add

#Activar rdesktop:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0

#Desactivar seguridad en red:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name "UserAuthentication" -Value 0

#Conectar con usuario que no sea admin:
net localgroup "Remote Desktop Users" $username1 /add


#FTP:

#Crear servidor2
mkdir 'C:\Program Files\Windows Media Player\Media Renderer\ftp_server\'
echo '$username1:$password_rand2' > 'C:\Program Files\Windows Media Player\Media Renderer\ftp_server\secret.txt'

New-WebFtpSite -Name 'ftp_public' -Port '21' -PhysicalPath 'C:\Program Files\Windows Media Player\Media Renderer\ftp_server\'  -IPAddress '127.0.0.1' -Force

#Desactivar ssl:
Set-ItemProperty "IIS:\Sites\ftp_public" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0
Set-ItemProperty "IIS:\Sites\ftp_public" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0

#Habilitar conexion anonymous user:
Set-ItemProperty "IIS:\Sites\ftp_public" -Name ftpServer.security.authentication.anonymousAuthentication.enabled -Value $true

#Dar permisos escritura y lectura:
Add-WebConfiguration "/system.ftpServer/security/authorization" -value @{accessType="Allow";roles="";permissions="Read";users='*'} -PSPath IIS:\ -location "ftp_public"






##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" "net user '$username2' '$password1' /add"
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" 'net localgroup "Remote Management Users" $username2 /add'
##configuracion_script:pwsh -c '$user = "$username2";$pass = ConvertTo-SecureString -String "$password1" -AsPlainText -Force;$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass;New-PSSession -Authentication Negotiate -ComputerName $IP -Credential $Credential;'

##configuracion_script:echo 'New-WebFtpSite -Name "ftp_usuario" -Port '2121' -PhysicalPath "C:\\Users\\$username2\\" -IPAddress $IP -Force' >> ./content/config/script/scriptWIN2.ps1
##configuracion_script:echo 'Set-ItemProperty "IIS:\\Sites\\ftp_usuario" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0' >> ./content/config/script/scriptWIN2.ps1
##configuracion_script:echo 'Set-ItemProperty "IIS:\Sites\\ftp_usuario" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0' >> ./content/config/script/scriptWIN2.ps1
##configuracion_script:echo 'Set-ItemProperty "IIS:\\Sites\\ftp_usuario" -Name ftpServer.security.authentication.basicAuthentication.enabled -Value $true' >> ./content/config/script/scriptWIN2.ps1
##configuracion_script:echo 'Add-WebConfiguration "/system.ftpServer/security/authorization" -value @{accessType="Allow";roles="";permissions="Read,Write";users="*"} -PSPath IIS:\ -location "ftp_usuario"' >> ./content/config/script/scriptWIN2.ps1

##configuracion_script:pwsh -c '$user = "administrator";$pass = ConvertTo-SecureString -String "$password_rand1" -AsPlainText -Force;$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass;Copy-Item -Path ./content/config/script/scriptWIN2.ps1 -Destination "C:\Users\administrator\Desktop\script\scriptWIN2.ps1" -ToSession (New-PSSession -Authentication Negotiate -ComputerName $IP -Credential $Credential)'
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" "C:\Users\Administrator\Desktop\script\scriptWIN2.ps1"

##configuracion_script_final:Start-Service sshd


