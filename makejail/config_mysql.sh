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

export mysql_bin=`which mysql`
########################################################
# FUNCIÓN  Manual o funcion de documentacion           #
########################################################
function manual {
	echo "
NOMBRE
       mydbgen - Mysql database generator.
RESUMEN
       mydbgen [OPTION]
DESCRIPCIÓN
		 Genera una Base de datos  

OPCIONES
	 -help: Muestra este menu.
	 -add: crea un usaurio mySql y su respectiva BD 
	 -rm: crea un usaurio mySql y su respectiva BD 

ARCHIVOS
	$0
		Es este script
"
}
########################################################
# MENSAJES DE ERROR!       							   #
########################################################
ERROR_1='Debe agregar la opcion y el nombre del usuario.'


########################################################
# Agrega una BD y un usuario con el mismo nombre       #
########################################################
function mysql_add_user_config {
	$mysql_bin --user=$mysql_bin_admin --password=$mysql_bin_admin_pass -e "CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';"
	$mysql_bin --user=$mysql_bin_admin --password=$mysql_bin_admin_pass -e "CREATE DATABASE $user;"
	$mysql_bin --user=$mysql_bin_admin --password=$mysql_bin_admin_pass -e "GRANT ALL PRIVILEGES ON $user.* TO '$user'@'localhost';"
	$mysql_bin --user=$mysql_bin_admin --password=$mysql_bin_admin_pass -e "FLUSH PRIVILEGES;"
}

########################################################
# Elimina a un usuario y su BD del sistema            #
########################################################
function mysql_rm_user_config {
	mysql='/opt/lampp/bin/./mysql'
	$mysql_bin --user=$mysql_bin_admin -e "DROP DATABASE IF EXISTS $user;"
	$mysql_bin --user=$mysql_bin_admin -e "DROP USER '$user'@'localhost';"
}

#revisando si no existe ningun argumento.
[ $# -ne 2 ] && { echo $ERROR_1; manual; exit 1; }

#
user="$2"
password="$2"

case "$1" in
   "")
	manual;
	exit 1;
      ;;
   -add)
      mysql_add_user_config
      exit 0;
      ;;
   -rm)
      mysql_rm_user_config
      exit 0;
	;;
esac

manual;
exit 1;

