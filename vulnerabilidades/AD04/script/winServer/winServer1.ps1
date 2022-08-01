#Cambiar politica de contraseñas para un dominio:
Set-ADDefaultDomainPasswordPolicy -Identity genwin.local -MinPasswordLength 2 -ComplexityEnabled $false

#Añadir usuario Ad desde DC:
$password = ConvertTo-SecureString '$$password1' -AsPlainText -Force
New-ADUser -Name '$$username1' -SamAccountName '$$username1' -AccountPassword $password -Enabled $true

#Añadir usuario Ad desde DC:
$password = ConvertTo-SecureString '$$password2' -AsPlainText -Force
New-ADUser -Name '$$username2' -SamAccountName '$$username2' -AccountPassword $password -Enabled $true

setspn -a genwin.local/$$username2.DC-Company genwin.local\$$username2

Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -Value 0
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name 'UserAuthentication' -Value 0

net user administrator '$$password_rand1' 