#Cambiar politica de contraseñas
Set-ADDefaultDomainPasswordPolicy -Identity genwin.local -MinPasswordLength 2 -ComplexityEnabled $false

#Cambiar contraseña al Administrador
net user Administrator hola

#Borrar historial
Clear-History