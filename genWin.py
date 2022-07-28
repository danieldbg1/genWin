from curses import intrflush
from distutils.log import error
from posixpath import split
import random
import signal, os
import string
import subprocess
import sys
from telnetlib import IP
from time import sleep
from unittest import result
from click import command
from django import conf
from matplotlib import lines
from numpy import asfarray, character
from sqlalchemy import false, true
from progress.bar import Bar
from progressbar import progressbar

#No funciona siempre
def control_c(signum, frame):
    print('\n\n[!] Saliendo...')
    sys.exit(1)
signal.signal(signal.SIGINT, control_c)

def help():
    os.system("clear")
    os.system("figlet genWin.py")
    os.system("echo \n")

    print("Se puede generar un entorno normal(1 solo PC windows) o AD(2 o mas PCs, un windows server y el resto windows 10\n")
    print("Se puede generar el entorno de forma aleatoria o manual. En el archivo extra/listaVulerabilidades.txt estan las vulneravilidades explicadas\n")
    print("Cuando se genera un entorno y este se apaga(apaga la/s maquina/s, no se podran encender otra vez correctamente. Para ello siga las siguientes pasos:")
    print("\n\t 1.- Eliminar las maquinas creadas.")
    print("\n\t 2.- Generar el entorno deseado de forma manual.")
    print("\n\t 3.- Las vulnerabilidad estan apuntadas en el archivo ./content/walkthrough.txt")
    print("\n\n\t\tIMPORTANTE!!! Mirar las vulnerabilidades en el ./content/walkthrough.txt antes de ejecutar el programa o se elminaran.")
    

    sys.exit(0)


############ Funciones Entorno Normal ############
def prepararConf(vulI, vulEP): 
    os.system("mkdir ./content/ 2>/dev/null")
    sleep(0.03)
    os.system("mkdir ./content/config 2>/dev/null")
    sleep(0.03)
    os.system("mkdir ./content/config/script 2>/dev/null")
    vInfo= vulI + " - " + vulEP
    sleep(0.03)
    os.system("touch ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    with open('./content/walkthrough.txt', 'w') as file:
        file.write(vInfo + "\n\n")
        file.write("Vulnerabilidades -> Intrusion: "+vulI+", Escalada Privilegios: "+vulEP+"\n\n")
    sleep(0.03)
    os.system("cat ./vulnerabilidades/"+vulI+"/walkthrough.txt >> ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    os.system("echo '\n\n' >> ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    os.system("cat ./vulnerabilidades/"+vulEP+"/walkthrough.txt >> ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    os.system("echo '\n\n' >> ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    #os.system("cp ./vulnerabilidades/"+vulI+"/script.txt ./content/config/script.txt 2>/dev/null")
    os.system("cp ./vulnerabilidades/script/script_win_enterprise.txt ./content/config/script.txt 2>/dev/null")
    sleep(0.03)
    os.system("cp ./vulnerabilidades/"+vulI+"/script/* ./content/config/script/ 2>/dev/null")
    sleep(0.03)
    os.system("cp ./vulnerabilidades/"+vulEP+"/script/* ./content/config/script/ 2>/dev/null")
    sleep(0.03)
    os.system("cat ./content/config/script/scriptI.ps1 >> ./content/config/script/scriptWIN.ps1 2>/dev/null")
    sleep(0.03)
    os.system("echo '\n\n' >> ./content/config/script/scriptWIN.ps1 2>/dev/null")
    sleep(0.03)
    os.system("cat ./content/config/script/scriptEP.ps1 >> ./content/config/script/scriptWIN.ps1 2>/dev/null")


def prepararVulerabilidades():
    file1 = open("./content/config/script/scriptWIN.ps1", "r")
    scriptWIN = file1.read()
    scriptWIN+="\nRestart-Computer -Force\n"
    file1.closed
    
    file2 = open("./content/config/script.txt", "r")
    script = file2.read()
    file2.closed
    status = true
    
    #Evitar repeticiones
    lista_usernames = [] 
    lista_passwords = []

    num_rand = 19
    i=1
    while status == true:
        status=false
        if '$username'+str(i) in scriptWIN:
            user = random.randint(0, num_rand)
            while user in lista_usernames:
                user = random.randint(0, num_rand)
            lista_usernames.append(user)
            with open('./diccionarios/names.txt', 'r') as userFile :
                content = userFile.readlines()
                username = content[user].strip()
            scriptWIN = scriptWIN.replace('$username'+str(i), username)
            script = script.replace('$username'+str(i), username)
            status=true

        if '$password'+str(i) in scriptWIN:
            password = random.randint(0, num_rand)
            while password in lista_passwords:
                password = random.randint(0, num_rand)
            lista_passwords.append(password)
            with open('./diccionarios/passwords.txt', 'r') as passFile :
                content = passFile.readlines()
                password = content[password].strip()
            scriptWIN = scriptWIN.replace('$password'+str(i), password)
            script = script.replace('$password'+str(i), password)
            status=true

        if '$password_rand'+str(i) in scriptWIN:
            specialCharacters = "@#%=?*-_,.:+"
            characters = string.ascii_letters + string.digits + specialCharacters
            password = ''.join(random.choice(characters) for i in range(8))
            scriptWIN = scriptWIN.replace('$password_rand'+str(i), password)
            script = script.replace('$password_rand'+str(i), password)
            status=true      
        i+=1
        
        
    with open('./content/config/script/scriptWIN.ps1', 'w') as file:
        file.write(scriptWIN)
        file.write("\n\n")

    
def configuracion_final():
    with open('./content/config/script/script_final.ps1', 'a') as file:
        file.write("Enable-PSRemoting -SkipNetworkProfileCheck\n")
        file.write("winrm quickconfig -Force\n")
        file.write("Set-MpPreference -DisableRealtimeMonitoring $true\n")
        file.write("Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name 'fDenyTSConnections' -Value 0\n")
        file.write("Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\' -Name 'UserAuthentication' -Value 0\n")

    file = open("./content/config/script/scriptWIN.ps1", "r")
    file.closed
    linea = file.readline()
    while linea:
        #Se ejecutan EN VM despues del reinicio
        if "##configuracion_script_final:" in linea:
            aux = linea.split("##configuracion_script_final:")
            with open('./content/config/script/script_final.ps1', 'a') as file_aux:
                file_aux.write(aux[1])
        #Se ejecutan en consola del host despues del reinicio
        if "##configuracion_script:" in linea:
            aux = linea.split("##configuracion_script:")
            with open('./content/config/script.txt', 'a') as file_aux:
                file_aux.write(aux[1])
        linea = file.readline()
    


def crearMaquina(): 
    file = open("./content/config/script.txt", "r")
    aux = file.readline()
    count = 0
    while aux:
        count+=1
        aux = file.readline()
    file.closed

    script_vm = open("./content/config/script.txt", "r")
    linea = script_vm.readline()
    script_vm.closed

    os.system("clear")
    os.system("figlet genWin.py")
    os.system("echo \n")

    ip=""
    print("\tCreando el entorno windows\n")
    for i in progressbar(range(count), redirect_stdout=True):
        if "##mensaje:" in linea:
            aux = linea.split("##mensaje:")
            print("\t" + aux[1])
            print("\n")

        if "$IP" in linea:
            if ip =="":
                aux=subprocess.Popen("vboxmanage guestcontrol win10 --username 'Administrator' --password 'hola' run -- 'C:\Windows\System32\WindowsPowershell\\v1.0\powershell.exe' 'ipconfig.exe' | grep '192.168' | awk '{print $NF}'", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                err = aux.stderr.read().decode()
                if err != "":
                    print("\nError IP:\n" + err)
                    print("\nComando fallido: " + linea + "\n")
                    sys.exit(-1)
                ip = aux.stdout.read().decode().strip()
        
            linea = linea.replace('$IP', ip)
            
        #print(linea.strip()+"\n")
        
        if "2>/dev/null &" in linea:
            os.system(linea)
            '''
            aux=subprocess.Popen(linea, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            out, err = aux.communicate()
            errOutput = err.decode().strip()
            if errOutput != "":
                print("\nError:\n" + errOutput)
                sys.exit(-1)
            '''
        else:
            aux=subprocess.Popen(linea, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            errOutput = aux.stderr.read().decode()
            if errOutput != "":
                if "already" not in errOutput:
                    if "OK" not in errOutput:
                        if "Closing the remote server shell instance" not in errOutput:
                            print("\nError:\n" + errOutput)
                            print("\nComando fallido: " + linea + "\n")
                            sys.exit(-1)
        
        #os.system(linea.strip())
        
        linea = script_vm.readline()
        


def actualizar_consola(vulI, vulEP):
    os.system("clear")
    os.system("figlet genWin.py")
    os.system("echo \n")

    print("" + "El entorno windows ya esta creado. Las vulnerabilidades utilizadas son las siguientes: ")
    print("\n\t" + "- Intrusion: " + vulI)
    print("\n\t" + "- Escalada de privilegios: " + vulEP)
    print("\n\nRecuerda que una vez apagada las maquinas, no podras encenderlas otra vez. Deberas crear el entorno de nuevo, eligiendo la vulnerabilidad mencionada, esta vulnerabilidad esta guardada en el archivo ./content/walkthrough.txt")
    print("\n Para mas informacion, ejecutar el programa e introducir el '3' para entrar en el panel de ayuda.")
    print("\n\nMucha suerte y good hack!!!")

def borrarConf():
    os.system("rm -r content/config/ 2>/dev/null")
    '''
    #programaWinGen.sh??
    os.system("rm -r content/config/script/ 2>/dev/null")
    os.system("rm content/config/script.txt 2>/dev/null")
    '''


############ Funciones AD ############
def prepararConf_AD(vulAD):
    #Si uso alguna vul extra?? IX y/o EPX?? como lo pongo en los walkthrough, scripts, etc????????
    os.system("mkdir ./content/ 2>/dev/null")
    sleep(0.03)
    os.system("mkdir ./content/config 2>/dev/null")
    sleep(0.03)
    os.system("mkdir ./content/config/script 2>/dev/null")
    sleep(0.03)
    os.system("mkdir ./content/config/script/winEnt 2>/dev/null")
    sleep(0.03)
    os.system("mkdir ./content/config/script/winServer 2>/dev/null")
    vInfo =  vulAD
    sleep(0.03)
    os.system("touch ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    with open('./content/walkthrough.txt', 'w') as file:
        file.write(vInfo + "\n\n")
        file.write("Vulnerabilidades -> AD: " + vulAD + "\n\n")
    sleep(0.03)
    os.system("cat ./vulnerabilidades/"+vulAD+"/walkthrough.txt >> ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    os.system("echo '\n\n' >> ./content/walkthrough.txt 2>/dev/null")
    sleep(0.03)
    os.system("cp ./vulnerabilidades/"+vulAD+"/script/script.txt ./content/config/script/script.txt 2>/dev/null")
    sleep(0.03)
    os.system("cp ./vulnerabilidades/"+vulAD+"/script/winEnt/* ./content/config/script/winEnt/ 2>/dev/null")
    sleep(0.03)
    os.system("cp ./vulnerabilidades/"+vulAD+"/script/winServer/* ./content/config/script/winServer 2>/dev/null")
    

def prepararVulerabilidades_AD():
    ##Abrir todos los archivos, guardar en lista e iterar
    lista_scripts_winEnt = [] 
    lista_scripts_winServer = []
    i = 1
    while os.path.isfile("./content/config/script/winEnt/winEnt" + str(i) + ".ps1"):
        file = open("./content/config/script/winEnt/winEnt" + str(i) + ".ps1", "r")
        script = file.read()
        file.closed
        lista_scripts_winEnt.append(script)
        i+=1

    i = 1
    while os.path.isfile("./content/config/script/winServer/winServer" + str(i) + ".ps1"):
        file = open("./content/config/script/winServer/winServer" + str(i) + ".ps1", "r")
        script = file.read()
        file.closed
        lista_scripts_winServer.append(script)
        i+=1
 
    file2 = open("./content/config/script/script.txt", "r")
    script = file2.read()
    file2.closed

    #Se puede quitar uno de los 2 whiles y hacerlo todo en uno
    num_rand = 19
    lista_usernames = [] 
    lista_passwords = []
    lista_passwords_random = []
    lista_scripts_winEnt_final = []    
    for contenido_script in lista_scripts_winEnt:
        i = 1
        status  = true
        while status == true:
            status=false
            if '$username'+str(i) in contenido_script:
                if i <= len(lista_usernames):
                    username = lista_usernames[i-1]
                    contenido_script = contenido_script.replace('$username'+str(i), username)
                else:
                    user = random.randint(0, num_rand)
                    while user in lista_usernames:
                        user = random.randint(0, num_rand)
                    with open('./diccionarios/names.txt', 'r') as userFile :
                        content = userFile.readlines()
                        username = content[user].strip()
                    contenido_script = contenido_script.replace('$username'+str(i), username)
                    lista_usernames.append(username)
                if '$username'+str(i) in script:
                    file = open("./content/config/script/script.txt", "r")
                    file.closed
                    linea_aux = file.readline()
                    contenido_aux = ""
                    while linea_aux:
                        if '$username'+str(i) in linea_aux and "winEnt" in linea_aux:
                            linea_aux = linea_aux.replace('$username'+str(i), username)
                        contenido_aux += linea_aux
                        linea_aux = file.readline()    
                    with open("./content/config/script/script.txt", "w") as file:
                        file.write(contenido_aux)
                status=true
            if '$password'+str(i) in contenido_script:
                if i <= len(lista_passwords):
                    password = lista_passwords[i-1]
                    contenido_script = contenido_script.replace('$password'+str(i), password)
                else:
                    password = random.randint(0, num_rand)
                    while password in lista_passwords:
                        password = random.randint(0, num_rand)
                    with open('./diccionarios/passwords.txt', 'r') as passFile :
                        content = passFile.readlines()
                        password = content[password].strip()
                    contenido_script = contenido_script.replace('$password'+str(i), password)
                    lista_passwords.append(password)
                if '$password'+str(i) in script:
                    file = open("./content/config/script/script.txt", "r")
                    file.closed
                    linea_aux = file.readline()
                    contenido_aux = ""
                    while linea_aux:
                        if '$password'+str(i) in linea_aux and "winEnt" in linea_aux:
                            linea_aux = linea_aux.replace('$password'+str(i), password)
                        contenido_aux += linea_aux
                        linea_aux = file.readline()    
                    with open("./content/config/script/script.txt", "w") as file:
                        file.write(contenido_aux)
                status=true
            if '$password_rand'+str(i) in contenido_script:
                if i <= len(lista_passwords_random):
                    password = lista_passwords_random[i-1]
                    contenido_script = contenido_script.replace('$password_rand'+str(i), password)
                else:
                    specialCharacters = "@#%=?*-_,.:+"
                    characters = string.ascii_letters + string.digits + specialCharacters
                    password = ''.join(random.choice(characters) for i in range(8))
                    contenido_script = contenido_script.replace('$password_rand'+str(i), password)
                    lista_passwords_random.append(password)
                if '$password_rand'+str(i) in script:
                    file = open("./content/config/script/script.txt", "r")
                    file.closed
                    linea_aux = file.readline()
                    contenido_aux = ""
                    while linea_aux:
                        if '$password_rand'+str(i) in linea_aux and "winEnt" in linea_aux:
                            linea_aux = linea_aux.replace('$password_rand'+str(i), password)
                        contenido_aux += linea_aux
                        linea_aux = file.readline()    
                    with open("./content/config/script/script.txt", "w") as file:
                        file.write(contenido_aux)
                status=true      
            
            i+=1
        lista_scripts_winEnt_final.append(contenido_script)
    
    lista_scripts_winServer_final = []
    for contenido_script in lista_scripts_winServer:
        i = 1
        status  = true
        while status == true:
            status=false
            #Comprobar si ya hay usuario
            if '$username'+str(i) in contenido_script:
                if i <= len(lista_usernames):
                    username = lista_usernames[i-1]
                    contenido_script = contenido_script.replace('$username'+str(i), username)
                else:
                    user = random.randint(0, num_rand)
                    while user in lista_usernames:
                        user = random.randint(0, num_rand)
                    with open('./diccionarios/names.txt', 'r') as userFile :
                        content = userFile.readlines()
                        username = content[user].strip()
                    contenido_script = contenido_script.replace('$username'+str(i), username)
                    lista_usernames.append(username)
                if '$username'+str(i) in script:
                    file = open("./content/config/script/script.txt", "r")
                    file.closed
                    linea_aux = file.readline()
                    contenido_aux = ""
                    while linea_aux:
                        if '$username'+str(i) in linea_aux and "winServer" in linea_aux:
                            linea_aux = linea_aux.replace('$username'+str(i), username)
                        contenido_aux += linea_aux
                        linea_aux = file.readline()    
                    with open("./content/config/script/script.txt", "w") as file:
                        file.write(contenido_aux)
                status=true
            if '$password'+str(i) in contenido_script:
                if i <= len(lista_passwords):
                    password = lista_passwords[i-1]
                    contenido_script = contenido_script.replace('$password'+str(i), password)
                else:
                    password = random.randint(0, num_rand)
                    while password in lista_passwords:
                        password = random.randint(0, num_rand)
                    with open('./diccionarios/passwords.txt', 'r') as passFile :
                        content = passFile.readlines()
                        password = content[password].strip()
                    contenido_script = contenido_script.replace('$password'+str(i), password)
                    lista_passwords.append(password)
                if '$password'+str(i) in script:
                    file = open("./content/config/script/script.txt", "r")
                    file.closed
                    linea_aux = file.readline()
                    contenido_aux = ""
                    while linea_aux:
                        if '$password'+str(i) in linea_aux and "winServer" in linea_aux:
                            linea_aux = linea_aux.replace('$password'+str(i), password)
                        contenido_aux += linea_aux
                        linea_aux = file.readline()    
                    with open("./content/config/script/script.txt", "w") as file:
                        file.write(contenido_aux)
                status=true
            if '$password_rand'+str(i) in contenido_script:
                if i <= len(lista_passwords_random):
                    password = lista_passwords_random[i-1]
                    contenido_script = contenido_script.replace('$password_rand'+str(i), password)
                else:
                    specialCharacters = "@#%=?*-_,.:+"
                    characters = string.ascii_letters + string.digits + specialCharacters
                    password = ''.join(random.choice(characters) for i in range(8))
                    contenido_script = contenido_script.replace('$password_rand'+str(i), password)
                    lista_passwords_random.append(password)
                if '$password_rand'+str(i) in script:
                    file = open("./content/config/script/script.txt", "r")
                    file.closed
                    linea_aux = file.readline()
                    contenido_aux = ""
                    while linea_aux:
                        if '$password_rand'+str(i) in linea_aux and "winServer" in linea_aux:
                            linea_aux = linea_aux.replace('$password_rand'+str(i), password)
                        contenido_aux += linea_aux
                        linea_aux = file.readline()    
                    with open("./content/config/script/script.txt", "w") as file:
                        file.write(contenido_aux)
                status=true      
            
            
            i+=1
        lista_scripts_winServer_final.append(contenido_script)

    i = 1
    for contenido_script in lista_scripts_winEnt_final:
        with open("./content/config/script/winEnt/winEnt" + str(i) + ".ps1", 'w') as file:
            file.write(contenido_script)
            file.write("\n")
        i+=1

    i = 1
    for contenido_script in lista_scripts_winServer_final:
        with open("./content/config/script/winServer/winServer" + str(i) + ".ps1", 'w') as file:
            file.write(contenido_script)
            file.write("\n")
        i+=1


def configuracion_final_AD(vulAD):
    #Mirar primero si existe el archivo
    if os.path.exists("./vulnerabilidades/"+vulAD+"/script/winServer/script_final.ps1"):
        os.system("cp ./vulnerabilidades/"+vulAD+"/script/winServer/script_final.ps1 ./content/config/script/winServer/script_final.ps1 2>/dev/null")

    if os.path.exists("cp ./vulnerabilidades/"+vulAD+"/script/winEnt/script_final.ps1"):
        os.system("cp ./vulnerabilidades/"+vulAD+"/script/winEnt/script_final.ps1 ./content/config/script/winEnt/script_final.ps1 2>/dev/null")


def crearMaquina_AD():
    file = open("./content/config/script/script.txt", "r")
    aux = file.readline()
    count = 0
    while aux:
        count+=1
        aux = file.readline()
    file.closed

    script_vm = open("./content/config/script/script.txt", "r")
    linea = script_vm.readline()
    script_vm.closed

    os.system("clear")
    os.system("figlet genWin.py")
    os.system("echo \n")

    ipWinEnt=""
    ipWinServer=""

    print("\tCreando el entorno windows\n")
    for i in progressbar(range(count), redirect_stdout=True):
        if "##mensaje:" in linea:
            aux_mensaje = linea.split("##mensaje:")
            print("\t" + aux_mensaje[1])
            print("\n")

        if "IP_winServer" in linea:
            linea = linea.replace('IP_winServer', ipWinServer)

        if "##winServer:" in linea:
            aux_linea = linea.split("##winServer:")
            linea = aux_linea[1]
            if "$IP" in linea:
                if ipWinServer =="":
                    aux=subprocess.Popen("vboxmanage guestcontrol winServer --username 'Administrator' --password 'hola' run -- 'C:\Windows\System32\WindowsPowershell\\v1.0\powershell.exe' 'ipconfig.exe' | grep '192.168' | awk '{print $NF}'", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    err = aux.stderr.read().decode()
                    if err != "":
                        print("\nError IP:\n" + err)
                        print("\nComando fallido: " + linea + "\n")
                        sys.exit(-1)
                    ipWinServer = aux.stdout.read().decode().strip()

                linea = linea.replace('$IP', ipWinServer)

        if "##winEnt:" in linea:
            aux_linea = linea.split("##winEnt:")
            linea = aux_linea[1]
            if "$IP" in linea:
                if ipWinEnt =="":
                    aux=subprocess.Popen("vboxmanage guestcontrol winEnt --username 'Administrator' --password 'hola' run -- 'C:\Windows\System32\WindowsPowershell\\v1.0\powershell.exe' 'ipconfig.exe' | grep '192.168' | awk '{print $NF}'", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    err = aux.stderr.read().decode()
                    if err != "":
                        print("\nError IP:\n" + err)
                        print("\nComando fallido: " + linea + "\n")
                        sys.exit(-1)
                    ipWinEnt = aux.stdout.read().decode().strip()
            
                linea = linea.replace('$IP', ipWinEnt)
        
        print(linea.strip()+"\n")

        if "2>/dev/null &" in linea:
            os.system(linea)
        else:
            aux=subprocess.Popen(linea, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            errOutput = aux.stderr.read().decode()
            if errOutput != "":
                if "already" not in errOutput:
                    if "OK" not in errOutput:
                        if "Closing the remote server shell instance" not in errOutput:
                            print("\nError:\n" + errOutput)
                            print("\nComando fallido: " + linea + "\n")
                            sys.exit(-1)

        linea = script_vm.readline()


def actualizar_consola_AD(vulAD):
    os.system("clear")
    os.system("figlet genWin.py")
    os.system("echo \n")

    print("" + "El entorno windows ya esta creado. Las vulnerabilidades utilizadas son las siguientes: ")
    print("\n\t" + "- Vulnerabilidad: " + vulAD)
    print("\n\nRecuerda que una vez apagada las maquinas, no podras encenderlas otra vez. Deberas crear el entorno de nuevo, eligiendo la vulnerabilidad mencionada, esta vulnerabilidad esta guardada en el archivo ./content/walkthrough.txt")
    print("\n Para mas informacion, ejecutar el programa e introducir el '3' para entrar en el panel de ayuda.")
    print("\n\nMucha suerte y good hack!!!")
    



def pruebas():
    lista = []
    lista.append(1)
    lista.append(2)
    i = 1
    print("indice: " + str(len(lista)) + "\n")
    if i <= len(lista):
        print("okey")
    else:
        print("Error")


#def main():
#    print("Hello World!")

if __name__ == "__main__":
    #main()
    
    print("1.- Generar entorno de forma manual (1)")
    print("2.- Generar entorno de forma aleatoria (2)")
    print("3.- Help (3)")
    
    conf = input("Introduce un número: ")
    if conf == "1":
        print("\nElige un tipo de entorno:\n")
        print("\t1.- Entorno windows normal(1)\n")
        print("\t2.- Entorno Active Directory(2)\n")
        tipoEntorno = input("Introduce un número: ")

        if tipoEntorno == "1":
            status = false
            while status != true:
                status = true
                vulI = input("\nElige una intrusion: ")
                vulEP = input("Elige una escaladade privilegios: ")
                if "I" not in vulI or "EP"  not in vulEP:
                    print("Vulve a introducir las vulnerabilidades con el formato correcto(Ejemplo: I01 o EP10)")
                    status = false
                else:
                    auxVulI = vulI.split("I")
                    auxvulEP = vulEP.split("EP")
                    auxVulI = auxVulI[1]
                    auxvulEP = auxvulEP[1]
                    numbersI = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14',' 15', '16', '17']
                    numbersEP= ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14',' 15', '16', '17']
                    if auxVulI not in numbersI or auxvulEP not in numbersEP:
                        print("Vulve a introducir las vulnerabilidades con el formato correcto(Ejemplo: I01 o EP10)")
                        status = false
        elif tipoEntorno == "2":
            status = false
            while status != true:
                status = true
                vulAD = input("\nElige una vulnerabilidad AD: ")
                if "AD" not in vulAD:
                    print("Vulve a introducir las vulnerabilidades con el formato correcto(Ejemplo: AD01)")
                    status = false
                else:
                    auxVulAD = vulAD.split("AD")
                    auxVulAD = auxVulAD[1]
                    numbersAD= ['01', '02', '03', '04', '05']
                    if auxVulAD not in numbersAD:
                        print("Vulve a introducir las vulnerabilidades con el formato correcto(Ejemplo: AD01)")
                        status = false
        else:
            print("Opcion no válida\n")
            sys.exit(-1)

    
    elif conf == "2":
        print("En proceso...")
        sys.exit(0)
    elif conf=="3":
        help() 
    else:
        print("Introduce un numero correcto. (1-4)")
        sys.exit(0)
    
    if tipoEntorno == "1":
        prepararConf(vulI, vulEP)
        prepararVulerabilidades()
        configuracion_final()
        #pruebas()
        crearMaquina()
        actualizar_consola(vulI, vulEP)
        #borrarConf()
    else:
        prepararConf_AD(vulAD)
        prepararVulerabilidades_AD()
        configuracion_final_AD(vulAD)
        #pruebas()
        crearMaquina_AD()
        actualizar_consola_AD(vulAD)
        #borrarConf_AD()
    

    
    
    
