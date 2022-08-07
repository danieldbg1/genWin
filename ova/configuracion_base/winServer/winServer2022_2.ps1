#Crear bosque AD
$pass = ConvertTo-SecureString '$password' -AsPlainText -Force
Install-ADDSForest -DomainName genwin.local -InstallDns -SafeModeAdministratorPassword $pass -Force
