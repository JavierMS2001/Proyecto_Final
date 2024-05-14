#!/bin/bash

#   Script que se encargará de instalar Ansible y los 
#   paquetes necesarios para su instalación en Debian12.
#
#	Autor: Javier Moreno Sánchez
#	Fecha 02/05/2024

###	VARIABLES	###

white="[0m"
red="[31m"
yellow="[33m"
green="[32m"
option=0

###	FUNCIONES	###

check_root() {
	if [ $UID -ne 0 ]
	then
		echo -e "\e$red \nERROR! Asegurate de ejecutar el script con usuario root o privilegios de super usuario.\e$white"
	exit 1
	fi
}

start_msg(){
	while [ $option -ne 1 ]; do
		clear
		echo -e "\e$yellow"
		echo -e "	####################################################################"
		echo -e "	#								   #"
		echo -e "	#				AVISO				   #"
		echo -e "	#								   #"
		echo -e "	#	Este script instalará programas y realizará cambios	   #"
		echo -e "	#		en el sistema.	¿Quieres continuar? (s/n)	   #"
		echo -e "	#								   #"
		echo -e "	####################################################################\e$white"
		read start
		if [ ${start,,} == "s" ]; then
			option=1
		elif [ ${start,,} == "n" ]; then
			echo -e "\nSaliendo del script..."
			exit 1
		else
			echo -e "\e$red \nSelecciona una opción valida!"
		fi
	done	
}

print_menu(){
	echo "############ [ MENÚ ] ############"
	echo -e "\n1. Instalación Ansible."
	echo -e "2. Instalación AWX."
	echo -e "3. Salir.\n"
}

check_requirements(){
	if python3 -V &> /dev/null; then
		echo -e "\e$green \nPython3 ya se encuentra instalado en el sistema.\e$white"
	else
		echo -e "\e$red \nPython3 no se encuentra instalado en el sistema. \e$yellow \nSe procedera con la instalación...\e$white"
		install_python3
	fi

	if pip -V &> /dev/null; then
		echo -e "\e$green \nPaquete pip ya está instalado en el sistema.\e$white"
	else
		echo -e "\e$red \nPaquete pip no se encuentra instalado en el sistema.\e$yellow \nSe procederá con la instalación...\e$white"
		install_pip
	fi

	if sudo apt-get install software-properties-common -y &> /dev/null; then
		echo -e "\e$green \nDependencias necesarias para instalar Ansible instaladas y actualizadas.\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar las dependencias necesarias para instalar Ansible. \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script. \e$white"
		exit 1
	fi
}

check_ansible(){
	if ansible --version &> /dev/null; then
		echo -e "\e$green\nAnsible ya se encuentra instalado en el sistema!"
	else
		install_ansible
	fi
}

install_python3(){
	if sudo apt-get install python3 -y &> /dev/null; then
		echo -e "\e$green \nPython3 instalado correctamente en el sistema!\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar Python3! \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script.\e$white"
		exit 1
	fi
}

install_pip(){
	if sudo apt-get install pip -y &> /dev/null; then
		echo -e "\e$green \nPip instalado correctamente en el sistema!\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar Pip! \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script.\e$white"
		exit 1
	fi
}

install_ansible(){
	echo -e "\e$yellow\e|Se procederá con la instalación de Ansible"
	if sudo apt-get install ansible -y &> /dev/null; then
		echo -e "\e$green \nAnsible instalado correctamente en el sistema!\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar Ansible! \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script.\e$white"
		exit 1
	fi
}

required_packets(){
	echo -e "\e$yellow\nInstalando paquetes necesarios para la instalación de AWX.\e$white"
	if sudo apt-get install apt-transport-https ca-certificates software-properties-common unzip gnupg2 curl -y &> /dev/null; then
		echo -e "\e$green\nPaquetes necesarios instalados correctamente!\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar los paquetes necesarios para instalar AWX. \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script. \e$white"
		exit 1
	fi

}

install_docker(){
	echo -e "\e$yellow\nInstalando versión necesaria de docker, pyyaml y docker-compose para AWX.\e$white"
	if sudo pip install docker==6.1.3 --break-system-packages &> /dev/null; then
		echo -e "\e$green\nDocker 6.1.3 instalado con éxito!\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar la versión necesaria de Docker. \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script. \e$white"
		exit 1
	fi

	if sudo pip install pyyaml==5.3.1 --break-system-packages &> /dev/null; then
		echo -e "\e$green\nVersión necesaria de pyyaml instalada con éxito!\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar la versión necesaria de pyyaml. \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script. \e$white"
		exit 1
	fi

	if sudo pip install docker-compose --break-system-packages &> /dev/null; then
		echo -e "\e$green\nDocker-compose instalado con éxito!\e$white"
	else
		echo -e "\e$red \nHubo un error al instalar docker-compose. \e$yellow \nAsegurate de tener los repositorios actualizados, conexión a internet y prueba a ejecutar de nuevo el script. \e$white"
		exit 1
	fi
}

###	 CÓDIGO		###

check_root
start_msg
clear

while [ $option -ne 3 ]; do
	print_menu
	read -p "Selecciona que deseas hacer: " option
	case $option in
	
		1)
			echo -e "\e$green\nHas seleccionado instalar Ansible.\e$white"
			check_requirements
			check_ansible
		;;

		2)
			echo -e "\e$green\nHas seleccionado instalar AWX.\e$white"
			required_packages
			check_requirements
			check_ansible
			install_docker

			echo -e "\e$yellow\nInstalando AWX... Espere por favor.\e$white"
			if sudo ansible-playbook -i awx_playbook/inventory awx_playbook/awx.yml &> /dev/null; then
				echo -e "\e$green\nAWX instalado con éxito! Para acceder a este, acceda en un navegador a la IP del equipo donde se ha ejecutado el script.\e$white\nLas credenciales son:\nUser: admin\nPassword: password"
			else
				echo -e "\e$red \nHubo un error al instalar AWX.\e$white\n"
				exit 1
			fi
		;;

		3)
			echo -e "\nSaliendo del script..."
			exit
		;;

		*)
			clear
			echo -e "\e$red\nValor añadido incorrecto! \e$yellow\nTrata de introducir una opción válida.\e$white"				
		;;
	esac
done
