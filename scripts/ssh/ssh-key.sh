#!/bin/bash

#   Script que generará las claves SSH y las pasará 
#   a las máquinas clientes de un csv.
#
#	Autor: Javier Moreno Sánchez
#	Fecha 26/04/2024

	####	  VARIABLES	####

params=$#
users=$1
key_path=$HOME/.ssh/id_rsa.pub


	####	  FUNCIONES	####

check_root() {
	if [ $UID -ne 0 ]
	then
		echo -e "ERROR! Asegurate de ejecutar el script con root."
	exit 1
	fi
}

check_param(){
    if [ $params -ne 1 ]; then    
        echo "ERROR! Número de parámetros incorrectos"
        echo -e "Asegurate de escribir como parámetro la ruta del csv el cual contenga los nombres y \ndirecciones IP de las máquinas clientes de la siguiente manera: \n$0 <ruta_csv>"
        exit 1
    fi
}

check_users_file(){
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
		read -p "En caso de no instalarlo, se cerrará el script.(s/n) " install
		if [ $install = "s" ]; then
			sudo apt-get install sshpass &> /dev/null
			echo -e "sshpass instalado..."
		else
			exit 1
		fi
	fi
}

check_rsa_id(){
	if [ -f "$key_path" ]; then
		echo "Ya existe un id_rsa.pub en tu directorio .ssh, ¿Quieres usar esa clave?"
		read -p "AVISO. En caso de darle a no, se sobreescribirá la clave y creará una nueva. (s/n) " key
		echo

		if [ $key == "s" ]; then
			echo "Se va a usar la clave que ya tienes en tu directorio .ssh/."
		else
			echo "Se eliminará la clave almacenada en .ssh/ y se creará una nueva."
			sudo rm ~/.ssh/id_rsa.pub
			sudo rm ~/.ssh/id_rsa
			echo
			key_gen

		fi
	else
		echo "Generando id_rsa.pub..."
		echo
		key_gen
		echo
		echo "Key generada exitosamente, copiandola a las máquinas especificadas en $users"
	fi	
}

key_gen(){
	if ssh-keygen -t rsa -b 4096 -N "" <<< $'\n' >/dev/null 2>/dev/null; then
		echo -e "Key generada exitosamente!"
	else
		echo -e "Hubo un fallo al generar la key!"
		echo -e "Asegurate de que no haya un id_rsa.pub en el directorio .ssh/ ya existente!"
	fi
}

ssh_copy(){
	while IFS=',' read -r user password host || [ -n "$host" ]; 
	do
		if [[ $host != "host" ]]; then
			echo -e "\nAgregando clave SSH a $host para el usuario $user\n"

			sshpass -p "$password" ssh-copy-id -i /root/.ssh/id_rsa.pub "$user@$host" #>/dev/null
			echo -e "\nClave importada con éxito en $host\n"
		fi
	done < "$users"

}

	####	  COMIENZO	####

check_root
check_param
check_users_file
check_sshpass
check_rsa_id
ssh_copy

