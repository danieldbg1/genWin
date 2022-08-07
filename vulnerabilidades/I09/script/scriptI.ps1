#Activar ssh y desactivar conexiones con contraseña
$ipv6 = ((ipconfig.exe | Select-String IPv6) -split " " | Select-String "fe80") -replace " "
Start-service sshd
(Get-Content -Path C:\ProgramData\ssh\sshd_config -Raw) -replace "#ListenAddress ::", "ListenAddress [$ipv6]:22" | Set-Content -Path C:\ProgramData\ssh\sshd_config
Restart-Service sshd

#Cerrar todos los puertos del IPv4