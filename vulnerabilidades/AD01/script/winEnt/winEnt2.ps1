net user $$username1 $$password1 /add
#Añadir usuario a grupo Remote Desktop Users
net localgroup "Remote Desktop Users" /add genwin\$$username1

echo '
param(
    [Parameter()]
    [String]$ArgumentList
)

$pass = ConvertTo-SecureString "$$password_rand1" -AsPlainText -Force
$farmCredential = New-Object System.Management.Automation.PsCredential("administrator", $pass)
Start-Process powershell.exe "C:\Windows\System32\msiexec.exe $ArgumentList" -Credential $farmCredential -Wait -WindowStyle Hidden
' > C:\Users\Administrator\Desktop\script.ps1

ps2exe C:\Users\Administrator\Desktop\script.ps1 C:\Users\Administrator\Desktop\script.exe


net localgroup 'msiexec' /comment:"Ejecutar msiexec.exe como administrator: C:\Users\Administrator\Desktop\script.exe -ArgumentList 'Args'" /add
net localgroup 'msiexec' $$username1 /add 

$acl = Get-Acl C:\Users\Administrator\Desktop\script.exe
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("msiexec","ReadAndExecute","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl C:\Users\Administrator\Desktop\script.exe


net user administrator '$$password_rand1'

Restart-Computer