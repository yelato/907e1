# Desarrollo de Servicio de Transcodificacion

## Problema

Varios organizmos tienen paginas en los cuales les gustaría incluir
contenido multimedia, según la manera mas funcional para el usuario
final. Facilita mucho la reproduccion en el navegador de los <audio> y
<video> de html, sin empargo existe cierta obstaculo la variad
implementaciones en los varias navegadores, que finalmente requiere que
uno presenta su audio/video en varios formatos (codificaciones), o que
los contenidos han sidos 'transcodificados' a varios formatos.  

Mientras que facilita el consumo de contenidos, por otro lado implica
mayor esfuerzo del parte del productor. Si puede compensar con con
algoritmos de transcodificaciones sencillos que hacen el trabajo
repituosa de forma automatica. Pero de todas formas estas algoritmos
tienen que ser escritos, o al menos instaldos. Y no una vez, cuando
visto desde un pespectivo sistemica, sino que una vez por cada
organizmo.

## Solución

Lo pensamos mas eficiente escribir el codigo una vez, y dar acesso a
ello areves del internet de manera de un 'servicio web'. Para ilustrar
el concepto podemos imaginar un oganizmo que produce contenidos de
video. Ellos codifican sus videos en el formato de mayor proporción
calidad/tamaño y de mayor conveniencia con respecto de su licencia. El
video codificado si sube a la pagina del mismo organizmo (si es que la
tiene). 

Ahora lo que sigue es mas dificil visualizar, porque de aqui en
adelante, para el productor de contenidos ya termino su trabajo. Pero
atreves de una seria de possiblies mechanismos, los de mas ficheros
(codificaciones) necesarios para el reprduccion sincillmente existen.
va diagrama:

productor >> servidor http >> video.webm
consumidor >> servidor http >> video.mp4
consumidor >> servidor http >> video.ogv
consumidor >> servidor http >> video.flv

## Como

Es possible sencillamente transcodificar todos los videos que sube el
organización a su sitio. Pero eventualmente si acaba el espacio, o si
acaban las finanzas para expandir recursos disponibles. Pero mientras
que si ocupa mucho el disco duro asi en un sitio de medios, lo que no
si ocupa mucho es el processador. Asi que tiene mas sentido, en lugar
de hospedar todos los formatos, producirlo unicamente cuando los
necesitamos.  Van diagramas 2 :

consumidor >> servidor http >> video.webm

Facil. pero que occure si un organizmos quiere consumir un 'video.mp4',
desde su mac o su ipad. en lugar de servir el fichero, la peticion del
consumidor es intervenido por un alogoritmo que transcodifica el
fichero y la presenta al navegador para descarga (o 'streaming').
diagrama 3:

consumidor >> servidor http >> cgi >> video.mp4

Para alivianar el exesco uso de ciclos del cpu implementaremos un
caché. Ficheros ya transcodificados tendran un tiempo de vida antes de
que si evaporan. El alogaritmo del 'cgi' antes de transcodificar un
fichero revisaria la existencia del mismo objectivo en el caché. si ya
existe, no hay necesidad de transcodificar. 

## Compatibilidad

El servicio es disponible segun los mechanimos de publicacion disponibles al productor. Si utiliza el servicio para enlacazar medios desde el servidor donde si hospeda el servicio. Para facilitar el uso del servicio por oganizmo productor, plugins podrian ser desarrollados para los los motores de contenidos favoritas de las masas. Pero no es necesario. En el siguente ejemplo, utilizando el elemento de <video> de html5, el dominio media.organizmo.org apunta el ip del servicio del transcodificacion, y organizmo.org es sencillamente la pagina del organizmo:

<video width="320" height="240" controls="controls">
  <source src="http://media.organizmo.org/video.mp4" type="video/mp4" />
  <source src="http://media.organizmo.org/video.ogv" type="video/ogg" />
  <source src="http://media.organizamo.org/video.webm" type="video/webm" />
</video> 
