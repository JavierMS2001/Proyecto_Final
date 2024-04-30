#!/bin/bash

#   Script que generará las claves SSH y las pasará 
#   a las máquinas clientes de un csv.
#
#	Autor: Javier Moreno Sánchez
#	Fecha 26/04/2024

	####	  VARIABLES	####

params=$#
users=$1


	####	  FUNCIONES	####

checkRoot() {
	if [ $UID -ne 0 ]
	then
		echo -e "ERROR! Asegurate de ejecutar el script como usuario root."
	exit 1
	fi
}

checkParam(){
    if [ $params -ne 1 ]; then    
        echo "ERROR! Número de parámetros incorrectos"
        echo -e "Asegurate de escribir como parámetro la ruta del csv el cual contenta los nombres y \ndirecciones IP de las máquinas clientes de la siguiente manera: \n$0 <ruta_csv>"
        exit 1
    fi
}

checkUsersFile(){
	if [ ! -f $users ]; then
		echo "La ruta que has introducido no lleva a un fichero existente!"
		echo "Asegurate de escribir correctamente la ruta"
		exit 1
	fi
}

check_sshpass(){
	if sshpass -h &> /dev/null; then
		echo
	else
		echo "sshpass NO está instalado"
		echo "¿Deseas instalar sshpass?" 
		read -p "En caso de no instalarlo, se cerrará el script. (s/n) " install
		if [ $install = "s" ]; then
			apt-get install sshpass &> /dev/null
			echo -e "sshpass instalado..."
		else
			exit 1
		fi
	fi
}

keyGen(){
	if ssh-keygen -t rsa -b 4096 -N "" <<< $'\n' >/dev/null 2>/dev/null; then
		echo -e "Key generada exitosamente!"
	else
		echo -e "Hubo un fallo al generar la key!"
		echo -e "Asegurate de que no haya un id_rsa.pub en el directorio .ssh/ ya existente!"
	fi
}

sshCopy(){
	while IFS=',' read -r user password host || [ -n "$host" ]; 
	do
		if [[ $host != "host" ]]; then
			echo -e "\nAgregando clave SSH a $host para el usuario $user"

			sshpass -p "$password" ssh-copy-id -i /root/.ssh/id_rsa.pub "$user@$host" >/dev/null
		fi
	done < "$users"

}

	####	  COMIENZO	####

checkRoot
checkParam
checkUsersFile
check_sshpass

read -p "¿Deseas generar una clave nueva? (s/n): " key

if [ $key == s ]; then
	echo -e "Seleccionaste crear una key"
	keyGen
else
	echo -e "Seleccionaste NO crear una key"
fi

sshCopy

