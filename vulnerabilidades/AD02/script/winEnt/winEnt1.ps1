net user $username1 $password_rand2 /add
#Añadir usuario a grupo Remote Desktop Users
net localgroup "Remote Desktop Users" /add genwin\$username1

net user administrator '$password_rand1'

Restart-Computer