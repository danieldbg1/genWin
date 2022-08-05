#Guardar credenciales administrador en el Credential Manager
C:\Windows\System32\cmdkey.exe /add:administrator /user:administrator /pass:'$password_rand1'

net localgroup 'Administrators' $username1 /add
