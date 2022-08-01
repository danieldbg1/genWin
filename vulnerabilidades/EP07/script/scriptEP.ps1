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


