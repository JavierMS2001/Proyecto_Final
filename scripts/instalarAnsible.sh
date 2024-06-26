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

###	 CÓDIGO		###

start_msg

clear

check_root
check_requirements

if ansible --version &> /dev/null; then
	echo -e "\e$green\nAnsible ya se encuentra instalado en el sistema!"
else
	install_ansible
fi
