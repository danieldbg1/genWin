echo '
param(
    [Parameter()]
    [String]$ArgumentList
)

$pass = ConvertTo-SecureString "$$password_rand11" -AsPlainText -Force
$farmCredential = New-Object System.Management.Automation.PsCredential("administrator", $pass)
Start-Process powershell.exe "C:\Windows\System32\reg.exe $ArgumentList" -Credential $farmCredential -Wait -WindowStyle Hidden
' > C:\Users\Administrator\Desktop\script.ps1

ps2exe C:\Users\Administrator\Desktop\script.ps1 C:\Users\Administrator\Desktop\script.exe


net localgroup 'SeBackupPrivilege' /comment:"Privilegios SeBackupPrivilege. Puede ejecutar reg.exe como administrator: C:\Users\Administrator\Desktop\script.exe -ArgumentList 'Args'" /add
net localgroup 'SeBackupPrivilege' $$username1 /add 

$acl = Get-Acl C:\Users\Administrator\Desktop\script.exe
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SeBackupPrivilege","ReadAndExecute","Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl C:\Users\Administrator\Desktop\script.exe


##configuracion_final:net user administrator '$$password_rand11'