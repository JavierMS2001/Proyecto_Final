# Proyecto Final - Automatización de Servicios desde Ansible mediante AWS.

## Introducción
Repositorio donde iré subiendo el código y demás contenido necesario para mi proyecto final.

## Contenidos del repositorio
Aquí ire incluyendo un breve índice acerca del contenido que vaya subiendo en el repositorio.

### 1. scripts
  Directorio donde guardo los scripts creados por mí, necesarios para la realización del proyecto.
  - **InstalarAnsible.sh**  -  *Script que debe ejecutarse con sudo o como root, el cual instala Ansible y los paquetes necesarios para utilizarlo.*
  - **ssh**  -  *Directorio con contenido necesario para realizar la conexión ssh entre nodo administrador y administrado.*
    - **ssh-key.sh**  -  *Script que genera una clave en caso de no tenerla y la copia en los nodos administrados. Necesario ejecutarse con root o sudo.*
    - **hosts.csv**  -  *Archivo csv, el cual contiene el username, contraseña y direcciones de los distintos nodos controlados, necesario para ejecutar ssh-key.sh*
### 2. ansible
  Como su nombre indica, consiste en un directorio donde guardaré el contenido relacionado con Ansible, más concretamente las playbooks.
  Por el momento, este directorio contiene otro directorio con las siguientes playbooks:
  - **ansibleConfig**  -  *Playbook que llama a un rol el cual establecerá los archivos de configuración de ansible con la configuración que necesitare.*
### 3. test_machines
  Para la realización de las playbooks y comprobación del funcionamiento de estas, antes de pasar al entorno real de AWS y Proxmox, estoy escribiendo el código y realizando las pruebas en máquinas virtuales. En este directorio se encuentran los vagrantfiles necesarios para levantar y utilizar dichas máquinas.
  - **master_tests**  -  *La máquina donde estoy realizando las pruebas del nodo administrador. Con Debian12*
  - **clients_tests**  -  *Máquinas donde estoy realizando las pruebas de los nodos administrados (conectar con estos mediante ssh, probar a instalar los servicios, etc.). Debian12 y rhel9*


## ¿En qué consistirá?
Aprovechando la plataforma de Amazon Web Services, y el servidor Proxmox del instituto, levantaré distintas máquinas. Una de estas máquinas estará en proxmox, y contará con Ansible, el cuál es un software pensado para la automatización de tareas, esta máquina será conocida como ***el nodo de control***. El resto de máquinas, estarán en AWS y serán ***nodos administrados***, es decir, son equipos administrados por el ***nodo de control***. Estos ***nodos administrados*** proveerán distintos servicios. Los cuales son los siguientes:
  - ***Nodo A.*** *Un servidor web con Apache, que ofrezca Wordpress.*
  - ***Nodo B.*** *Un servidor mariaDB, que ofrezca acceso remoto.*
  - ***Nodo C.*** *Un servidor DNS, para resolver nombres.*
Todo ello con la peculiaridad de que los servicios serán instalados y configurados en los respectivos ***nodos administrados*** de forma automatizada y remota desde ***el nodo de control***.

## Finalidad
La principal función a destacar de este proyecto es la potencia que tiene Ansible con la automatización de tareas, haciendo que trabajos que pueden requerir bastante tiempo, cómo instalar y configurar un servidor, se realicen de forma automatizada, reduciendo enormemente el tiempo que puede tomar.
Además, al estar montado en AWS, una herramienta muy utilizada hoy en día en las empresas, nos podemos permitir el lujo de acceder a las distintas máquinas donde será realizado el proyecto desde cualquier equipo, independientemente de su Sistema Operativo o potencia.
Mi idea principal es montar en cada ***nodo administrado*** un servicio que tenga algo que ver con las distintas asignaturas, en el **Nodo A** un _gestor de contenidos_ (Wordpress), en el **Nodo B** la _base de datos_ remota que usará el Wordpress y en el **Nodo C** un _servidor DNS_.

## Objetivos
Una vez puesto en marcha todo, el ***nodo de control*** nos permitirá automatizar tareas mediante unas ***playbooks***, que son archivos en formato _yml_ donde se escribe el código de la tarea a realizar.
Hablando en claro, el equipo donde se encuentra instalado Ansible, instalará automáticamente los programas y servicios requeridos en las otras máquinas.
