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


##Como hacer EP?? Poner un EP normal, conseguir creds, y entrar en DC?? con algun hash??antes hacer AD02