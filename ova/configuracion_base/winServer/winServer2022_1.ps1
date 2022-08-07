#Desinstalar  el defender
Uninstall-WindowsFeature -Name Windows-Defender

#Desactiar firewall:
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

#Cambiar nombre PC
Rename-Computer -NewName DC-Company

#Instalar Feature Active Directory Domain Services
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Restart-Computer

