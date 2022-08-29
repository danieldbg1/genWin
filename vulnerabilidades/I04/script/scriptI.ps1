
#Cambiar pass de un usuario y admin
net user '$username1' '$password_rand2' /add
net user '$username2' '$password1' /add

#Rdesktop
net localgroup "Remote Desktop Users" $username1 /add

#Anadir usuario al grupo de winrm
net localgroup "Remote Management Users" $username1 /add


mkdir C:\folder
echo '$username1:$password_rand2' > C:\folder\secret.txt

#Crear carpeta compartida
New-SmbShare -Name "folder" -Path 'C:\folder' -FullAccess "Administrator"

#Anadir usaurio a carpeta compartida
Grant-SmbShareAccess -Name "folder" -AccountName '$username2' -AccessRight Full -Force

#Activar protocolo smb1
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart



##configuracion_script_final:Set-SmbServerConfiguration -EnableSMB1Protocol 1 -Force
##configuracion_script_final:Set-SmbServerConfiguration -AuditSmb1Access $true -Force


