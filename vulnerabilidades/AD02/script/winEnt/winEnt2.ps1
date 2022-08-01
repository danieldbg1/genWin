net user $$username1 $$password_rand2 /add
#Añadir usuario a grupo Remote Desktop Users
net localgroup "Remote Desktop Users" /add genwin\$$username1


#FTP:
mkdir C:\ftp_server
echo '$$username1:$$password_rand2' > C:\ftp_server\secret.txt

#Crear servidor
New-WebFtpSite -Name 'ftp_server' -Port '21' -PhysicalPath 'C:\ftp_server\' -IPAddress 127.0.0.1 -Force

#Desactivar ssl:
Set-ItemProperty "IIS:\Sites\ftp_server" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0
Set-ItemProperty "IIS:\Sites\ftp_server" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0

#Habilitar conexion anonymous user:
Set-ItemProperty "IIS:\Sites\ftp_server" -Name ftpServer.security.authentication.anonymousAuthentication.enabled -Value $true

#Habilitar conexion usuario:
Add-WebConfiguration "/system.ftpServer/security/authorization" -value @{accessType="Allow";roles="";permissions="Read,Write";users="*"} -PSPath IIS: -location "ftp_server"


echo '
param(
    [Parameter()]
    [String]$ArgumentList
)

$pass = ConvertTo-SecureString "$$password_rand1" -AsPlainText -Force
$farmCredential = New-Object System.Management.Automation.PsCredential("administrator", $pass)
Start-Process powershell.exe "C:\Windows\System32\rundll32.exe $ArgumentList" -Credential $farmCredential -Wait -WindowStyle Hidden
' > C:\Users\Administrator\Desktop\script.ps1

ps2exe C:\Users\Administrator\Desktop\script.ps1 C:\Users\Administrator\Desktop\script.exe


net localgroup 'rundll32' /comment:"Puede ejecutar rundll32.exe.exe como administrator: C:\Users\Administrator\Desktop\script.exe -ArgumentList 'Args'" /add
net localgroup 'rundll32' $$username1 /add 

$acl = Get-Acl C:\Users\Administrator\Desktop\script.exe
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("rundll32","ReadAndExecute","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl C:\Users\Administrator\Desktop\script.exe



net user administrator '$$password_rand1'

Restart-Computer