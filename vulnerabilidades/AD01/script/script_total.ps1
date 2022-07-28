#winEnt1.ps1
net user $username1 $password1 /add
#Añadir usuario a grupo Remote Desktop Users
net localgroup "Remote Desktop Users" /add genwin\$username1
net user administrator '$password_rand1'
Restart-Computer

#winEnt2.ps1
netsh interface ipv4 set dnsservers "Ethernet" static $IP primary 
$pass = ConvertTo-SecureString '$password1' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PsCredential('$username1', $pass) 
Add-Computer -DomainName genwin.local -Credential $credential

#winServer1.ps1
#Cambiar politica de contraseñas para un dominio:
Set-ADDefaultDomainPasswordPolicy -Identity genwin.local -MinPasswordLength 2 -ComplexityEnabled $false

#Añadir usuario Ad desde DC:
$password = ConvertTo-SecureString '$password1' -AsPlainText -Force
New-ADUser -Name '$username1' -SamAccountName '$username1' -AccountPassword $password -Enabled $true

#Simular acceso a fichero comaprtido a nivel de red
mkdir C:\programa
echo '#Programa para la intrusion' >> C:\programa\programa.ps1
echo 'ls \\share\secreto' >> C:\programa\programa.ps1

net user administrator '$password_rand1' 

Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -Value 0
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name 'UserAuthentication' -Value 0
