net user $$username2 $$password_rand2 /add
#Añadir usuario a grupo Remote Desktop Users
net localgroup "Remote Desktop Users" /add genwin\$$username2

net user administrator '$$password_rand1'

Restart-Computer