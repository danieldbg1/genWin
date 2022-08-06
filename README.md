# winGen
 
- Descargar los siguientes ficheros ova y guardar en la carpeta ova:

	- https://drive.google.com/file/d/1VgTg8QotYyTq66W06LO0PS-ejrmvfo7a/view?usp=sharing
	- https://drive.google.com/file/d/1iZS8cxENVKeMnua4bSe6Y8epVxdj5giR/view?usp=sharing

- Configurar ova en blanco a partir de un fichero iso:
	1.- Descargar iso:
		- Windows 10 -> https://www.microsoft.com/es-es/evalcenter/evaluate-windows-10-enterprise
		- Windows server 2022 -> https://www.microsoft.com/es-es/evalcenter/evaluate-windows-server-2022
	
	2.- Configurar iso:
		2.1.- Configurar windows 10:
			- Elegir el idioma por defecto, ingles.
			- Añadir teclado por defecto, ingles.
			- Añadir segundo telado a gusto del usuario, en mi caso, spanish(spain)
			- Añadir un usuario cualquiera(administrator@administrator.com) y saldrá un error. Justo debajo saldrá una opción para crear un usuario local, elegimos esa opción y elegimos un usuario cualquiera.
			- Si no podemos poner el @, abajo a la derecha podemos cambiar al otro teclado elegido anteriormente.
			- Terminar configuracion.
			- Añadir guest additions:
				- Pinchar en "Dispositivos" y luego en "Insertar imagen de CD de las guest additions".
				- Abrir el explorador, pinchar en "This PC", Virtualbox guest additions, instalar la opcion amd64 y reiniciar.
			- Crear ova:
				- Apagar la maquina.
				- En la configuración de la maquina, en sistema, poner 1 procesador y 32MB de memoria base. 
				- vboxmanage export nombre_maquina -o fichero.ova
		
		2.2.- Configurar windows server 2022:
