netsh interface ipv4 set dnsservers "Ethernet" static $IP primary 

$pass = ConvertTo-SecureString '$$password_rand2' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PsCredential('$$username1', $pass) 
Add-Computer -DomainName genwin.local -Credential $credential
