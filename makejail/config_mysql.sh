#!/bin/bash
#descripcion: Configuracion de mysql
#  __ _        _                            
# / _| |_   _ (_) ___  ___   ___  _ __ __ _ 
#| |_| | | | || |/ _ \/ __| / _ \| '__/ _` |
#|  _| | |_| || | (_) \__ \| (_) | | | (_| |
#|_| |_|\__,_|/ |\___/|___(_)___/|_|  \__, |
#           |__/                      |___/


#Configuracion general
mysql_admin='root'
mysql_admin_pass='secret'

########################################################
# FUNCIÓN        							   #
########################################################
function msg_opciones {
	echo "
NOMBRE
       mydbgen - Mysql database generator.
RESUMEN
       mydbgen [OPTION]
DESCRIPCIÓN
		 Genera una Base de datos  

OPCIONES
	 -help: Muestra este menu.
	 -start: inicia el conky.
	 -update: Actualiza los archivos.
	 -revision: Muestra el número de la ultima revisión.
	 -author: Muestra el autor de la ultima revisión.
	 -date: Muestra la fecha de la ultima revisión.
	 -msg N: Imprime en un párrafo de longitud N mensaje de la ultima revisión.

ARCHIVOS
	$HOME/.cofig/conky/proyectos.xml
		Contiene la configuracion de las variables de los proyectos a mostrar
"
}
########################################################
# MENSAJES DE ERROR!       							   #
########################################################
ERROR_1='Debe agregar la opcion y el nombre del usuario.'

########################################################
# Agrega una BD y un usuario con el mismo nombre       #
########################################################
function mysql_add_usser_config {
	#/usr/bin/mysql --user='root' --password='passX'
	mysql='/opt/lampp/bin/./mysql'
	$mysql --user=$mysql_admin --password=$mysql_admin_pass -e "CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';"
	$mysql --user=$mysql_admin --password=$mysql_admin_pass -e "CREATE DATABASE $user;"
	$mysql --user=$mysql_admin --password=$mysql_admin_pass -e "GRANT ALL PRIVILEGES ON $user.* TO '$user'@'localhost';"
	$mysql --user=$mysql_admin --password=$mysql_admin_pass -e "FLUSH PRIVILEGES;"
	## Borrando:
	#DROP USER '$user'@'localhost';
	#DROP DATABASE IF EXISTS `$user`;
}
########################################################
# Elimina a unn usuario y su BD del sistema            #
########################################################
function mysql_rm_usser_config {
	#/usr/bin/mysql --user='root' --password='passX'
	mysql='/opt/lampp/bin/./mysql'
	$mysql --user=$mysql_admin -e "DROP DATABASE IF EXISTS $user;"
	$mysql --user=$mysql_admin -e "DROP USER '$user'@'localhost';"
}
#mysql_rm_usser_config
#revisando si no existe ningun argumento.
[ $# -ne 1 ] && { echo $ERROR_1; msg_opciones; exit 1; }

#
user="$1"
password="$1"

mysql_add_usser_config
