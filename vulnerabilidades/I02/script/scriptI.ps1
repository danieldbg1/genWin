
#Cambiar pass usuarios y admin
net user '$username1' '$password_rand2' /add
net user '$username2' '$password1' /add

#Conectar con rdesktop usuario que no sea admin:
net localgroup "Remote Desktop Users" $username1 /add

mkdir C:\folder\

#Crear carpeta compartida
New-SmbShare -Name "folder" -Path 'C:\folder\' -FullAccess 'Administrator'

#Añadir usaurio a carpeta compartida
Grant-SmbShareAccess -Name "folder" -AccountName '$username2' -AccessRight Full -Force

#Activar protocolo smb1
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart



##configuracion_script_final:net user Administrator '$password_rand1'
##configuracion_script_final:Set-SmbServerConfiguration -EnableSMB1Protocol 1 -Force
##configuracion_script_final:Set-SmbServerConfiguration -AuditSmb1Access $true -Force

##configuracion_script:echo "$username1:$password_rand2" > ./content/config/script/secret.txt
##configuracion_script:sleep 2
##configuracion_script:zip --password password ./content/config/script/secret.zip ./content/config/script/secret.txt
##configuracion_script:sleep 2
##configuracion_script:steghide --embed -ef ./content/config/script/secret.zip -cf ./content/config/script/image.jpeg -p ""
##configuracion_script:sleep 2
##configuracion_script:rm ./content/config/script/secret.*
##configuracion_script:pwsh -c '$user = "administrator";$pass = ConvertTo-SecureString -String "$password_rand1" -AsPlainText -Force;$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass;Copy-Item -Path ./content/config/script/image.jpeg -Destination "C:\folder\image.jpeg" -ToSession (New-PSSession -Authentication Negotiate -ComputerName $IP -Credential $Credential)'


