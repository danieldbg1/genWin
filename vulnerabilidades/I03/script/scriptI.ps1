
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

#Activar protocolo smb1
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart

#FTP:
#Crear servidor en localhost
mkdir 'C:\Program Files\Windows Media Player\Media Renderer\ftp_server\'
echo '$username1:$password_rand2' > 'C:\Program Files\Windows Media Player\Media Renderer\ftp_server\secret.txt' 

New-WebFtpSite -Name 'ftp_public' -Port '21' -PhysicalPath 'C:\Program Files\Windows Media Player\Media Renderer\ftp_server'  -IPAddress '127.0.0.1' -Force

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


##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" 'Set-SmbServerConfiguration -EnableSMB1Protocol 1 -Force'
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" 'Set-SmbServerConfiguration -AuditSmb1Access $true -Force'
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" "New-SmbShare -Name 'folder' -Path 'C:\Users\$username2\' -FullAccess 'Administrator'"
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" 'Grant-SmbShareAccess -Name "folder" -AccountName "$username2" -AccessRight Full -Force'
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" 'mkdir C:\Users\$username2\.ssh\'
##configuracion_script:vboxmanage guestcontrol winEnt --username "Administrator" --password "$password_rand1" run -- "C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe" 'net localgroup "Remote Management Users" $username2 /delete'



##configuracion_script_final:Start-Service sshd
