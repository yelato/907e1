#!/bin/bash

#
#-----------------------
#Revisar manual addgroup.
#Achivo de grupos: cat /etc/group
#
#
#/usr/sbin/adduser
#LISTA DE ERRORES.
#configuraciones.

ERROR_0='Ejecute: agregar_proyecto nombreProyecto'
ERROR_1='Ejecute: agregar_proyecto nombreProyecto'
ERROR_2='Ya existe un usuario con nombre'
ERROR_3='Los nombres de los dominios son en Minusculas y numeros, el nombre debe empezar con un letra, la longitud de definida es de 3,9'

#validaciones
if [ `whoami` != "root" ]
    then
    echo ERROR_0
    exit 1
fi
#revisando si no existe ningun argumento.
[ $# -ne 1 ] && { echo ERROR_1; exit 1; }
USER="$1"
#revisando que el usuario que intentamos crear no exista.
grep -q -E "^$USER:" /etc/passwd && { echo ERROR_2; exit 1; }
#Revisamos si el usuario tiene un nombre valido.
{ echo "$USER" | grep -v -q -E "^[a-z][-a-z0-9]{2,9}$"; } && { echo ERROR_3; exit 1;}
#Creamos el directorio public_html.
#HOMEDIR="/home/$USER/"


