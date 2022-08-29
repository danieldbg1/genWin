#Crear usuario
net user '$username1' '$password_rand2' /add
net user '$username1123' '$password1' /add

mkdir C:\credenciales\
echo '$username1:$password_rand2' > C:\credenciales\credenciales.txt

$acl = Get-Acl C:\credenciales\credenciales.txt
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule('$username1123',"Read","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl C:\credenciales\credenciales.txt


#Activar rdesktop:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0

#Desactivar seguridad en red:
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name "UserAuthentication" -Value 0

#Conectar con usuario que no sea admin:
net localgroup "Remote Desktop Users" '$username1123' /add


#SNMP
#Crear community public
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" -Name public -Value 4

#Deshabilitar reglas firewall
Get-NetFirewallRule SNMP-Out-UDP-NoScope | Disable-NetFirewallRule
Get-NetFirewallRule SNMP-In-UDP-NoScope | Disable-NetFirewallRule
Get-NetFirewallRule SNMP-Out-UDP | Disable-NetFirewallRule
Get-NetFirewallRule SNMP-In-UDP | Disable-NetFirewallRule

#Habilitar conexion IP
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers"  -Name 2 -Value '192.168.56.1'


##configuracion_script_final:Start-Service sshd
##configuracion_script_final:Start-service snmp

