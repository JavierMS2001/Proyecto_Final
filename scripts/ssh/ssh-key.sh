#!/bin/bash

#   Script que generará las claves SSH y las pasará 
#   a las máquinas clientes de un csv.
#
#	Autor: Javier Moreno Sánchez
#	Fecha 26/04/2024

	####	  VARIABLES	####

white="[0m"
red="[31m"
yellow="[33m"
green="[32m"

params=$#
users=$1
key_path=$HOME/.ssh/id_rsa
option=0

	####	  FUNCIONES	####

check_param(){
    if [ $params -ne 1 ]; then    
        echo -e "\e$red \nERROR! Número de parámetros incorrectos.\e$white"
        echo -e "\e$red \nAsegurate de escribir como parámetro la ruta del csv el cual contenga los nombres y \ndirecciones IP de las máquinas clientes de la siguiente manera:\e$yellow $0 <ruta_csv>\e$white"
        exit 1
    fi
}

check_users_file(){
	if [ ! -f $users ]; then
		echo -e "\e$red \nLa ruta que has introducido no lleva a un fichero existente!\e$yellow"
		echo -e "Asegurate de escribir correctamente la ruta hacia el csv.\e$white"
		exit 1
	else
		echo -e "\e$green \nArchivo $users encontrado!"
	fi
}

check_sshpass(){
	if sshpass -h &> /dev/null; then
		echo -e "\e$green \nPaquete sshpass instalado en el sistema!\e$white"
	else
		echo -e "\e$red \nPaquete sshpass NO está instalado"
		echo -e "\e$yellow¿Deseas instalar sshpass? En caso de no instalarlo, se cerrará el script. (s/n)\e$white" 
		read install
		if [ ${install,,} = "s" ]; then
			if sudo apt-get install sshpass -y &> /dev/null; then
				echo -e "\e$green \nPaquete sshpass instalado con éxito!"
			else
				echo -e "\e$red \nHubo un error al instalar sshpass! \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script. \e$white"
			fi
		else
			echo -e "\e$yellow \nEl paquete sshpass es necesario para la ejecución del script.\nEl programa se cerrará."
			exit 1
		fi
	fi
}

check_rsa_id(){
	if [ -f "$key_path" ]; then
		echo -e "\nYa existe un id_rsa.pub en tu directorio .ssh. \e$yellow¿Quieres sobreescribirlo?"
		echo -e "AVISO. En caso de darle a si, se sobreescribirá la clave y creará una nueva. (s/n)\e$white" 
		read key
		echo

		if [ ${key,,} == "s" ]; then
			echo  -e "\e$yellow \nSe eliminará la clave almacenada en .ssh/ y se creará una nueva.\e$white"
			sudo rm ~/.ssh/id_rsa.pub
			sudo rm ~/.ssh/id_rsa
			key_gen
		elif [ ${key,,} == "n" ]; then
			echo -e "\e$yellow \nSe va a utilizar la clave que tienes en el directorio .ssh/"
		fi
	else
		echo -e "\e$yellow \nGenerando id_rsa.pub...\e$white \n"
		key_gen
		echo -e "\e$green \nCopiandola a las máquinas especificadas en $users\e$white"
	fi	
}

key_gen(){
	if ssh-keygen -t rsa -b 4096 -N "" <<< $'\n' &> /dev/null ; then
		echo -e "\e$green\nKey generada exitosamente!\e$white"
	else
		echo -e "\e$red \nHubo un fallo al generar la key!\e$yellow"
		echo -e "Asegurate de que no haya un id_rsa.pub en el directorio .ssh/ ya existente!\e$white"
		exit 1
	fi
}

quest(){
	echo -e "\e$yellow\n¿Deseas autenticarte mediante contraseña o mediante una clave?\e$white"
	echo -e "1. Contraseña"
	echo -e "2. Clave"
}

ssh_copy_password(){
	while IFS=',' read -r user password host || [ -n "$host" ]; 
	do
		if [[ $host != "host" ]]; then
			echo -e "\e$yellow \nAgregando clave SSH a $host para el usuario $user en la máquina $host...\n\e$white"

			if sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no "$user@$host" &> /dev/null ; then
				echo -e "\e$green \nClave importada con éxito en $host\n"
			else
				echo -e "\e$red \nLa clave no se ha podido importar en $host\n"
			fi
		fi
	done < "$users"

	echo -e "\e$yellow \nAVISO!\e$white Recuerda confirmar que puedes conectarte a las máquinas con: ssh <usuario>@<host>\e$white"
}

ssh_copy_pem(){
	while IFS=',' read -r user host || [ -n "$host" ]; 
	do
		if [[ $host != "host" ]]; then
			echo -e "\e$yellow \nAgregando clave SSH a $host para el usuario $user en la máquina $host...\n\e$white"

			if ssh-copy-id -f -o IdentityFile=keys/vockey.pem "$user@$host" &> /dev/null ; then
				echo -e "\e$green \nClave importada con éxito en $host\n"
			else
				echo -e "\e$red \nLa clave no se ha podido importar en $host\n"
			fi
		fi
	done < "$users"

	echo -e "\e$yellow \nAVISO!\e$white Recuerda confirmar que puedes conectarte a las máquinas con: ssh <usuario>@<host>\e$white"
}


	####	  COMIENZO	####

check_param
check_users_file
check_sshpass
check_rsa_id

while [ $option -ne 3 ]; do
	quest
	read option
	case $option in
		1)
			ssh_copy_password
			exit
		;;

		2)
			ssh_copy_pem
			exit
		;;

		*)
			echo -e "\e$red\nValor añadido incorrecta! \e$yellow\nTrata de introducir una opción válida.\e$white"
		;;
	esac
done
