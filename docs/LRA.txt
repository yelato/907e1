
Automatización de Radio con aplicaciones GNU/LinuxTabla de
Contenido

Tabla de Contenido

Automatización de Radio con aplicaciones GNU/Linux  1

Motivación  1

Principios de Desarrollo  2

Experiencias Previas  2

Método de Trabajo  2

Necesidades  3

Aplicaciones de Evaluación  3

Elementos De la Sistema Operativa Radiofónica  3

Reproducción  4

Grabación  4

Temporalizacion  4

Sincronización y Manipulación de audio  5

Flujos  5

Criterio de Evaluación de aplicaciones  5

Evaluación  6

Reproducción  6

Motivación

...

Principios de Desarrollo
------------------------

En lugar de caernos en la mentalidad comercial del producto
maravilloso que resuelva todo y únicamente cuesta $..., la
lección del ecosistema GNU/Linux es que si resuelva una
problema a la vez. Y si una problema resulta ser dos, si las
divides en dos. Asi que puede ser unos con trabajan en una cosa
y otros en otro. Si hace así mas fácil compartir. Entonces
lógicamente si hace cosas grandes por combinar muchas cosas
que ya otra gente están haciendo. Así que aplicaremos esfuerza
nosotros únicamente donde le hace falta a la comunidad.

Para la reproducción, edición de audio hay aplicaciones muy
buenos para Linux. Por que hacer uno nuevo? Todos incluyen
alguna tipo de temporalizacion, pero cuando esta es inadecuado
si puede recurrir a la sistema de temporalizaron de la sistema
operativo, Cron. necesitamos un nuevo programa para eso?
Pensamos que es contraproducente ofrecer aplicaciones hechizas
mantenido por uno o dos personas (o en muchos casos no
mantenidos), cuando existen programas muy buenos mantenidos por
miles de personas en todos partes del planeta.

En fin, para resolver la problemática como la estamos planteando
es necesario recurrir también a la experiencia del comunidad de
uso de software libre. Seleccionamos el mejor inaplicación para
cada tarea especifica y escribimos código únicamente para
rellenar los huecos.

En este sentido nuestra herramienta de trabajo es la sistema
operativo, y pensamos que una sistema operativo como Debian
GNU/Linux con su rico diversidad de paquetes y su filosofía de
desarrollo es tierra fertil para semprar algo proprio. Ademas
creamos que cualquier applicacion que desarrollamos
beneficiaria mucho de estar incluido dentro de Debian, asi que
permitaria ser probado, criticado y mejorado de manera facil
por todo los que utilizan Debian en todos partes del mundo.

Podemos considerar esta proyecto terminado en el momento que
uno, desde su instalaccion de Debían normal, hacer ´aptitute
install cabina´ y obtener el fruto de proyecto aquí descrita.

Experiencias Previas
--------------------

Unos experiencias previas que tenemos en este campo es el plugin
de la hora1

http://yaxhil.flujos.org/wiki/hora/

para el reproductor rhythmbox y la distribución vivo linux
flujos-vivos2

http://flujos.org/fv/

, lo cual también de su manera es un intento responder a muchos
de los mismos problemas.

Método de Trabajo
-----------------

Pensamos para lograr nuestra objetivo es la necesidad de un
equipo de trabajo hecho tanto por radialistas con experiencia
continuo en las comunidades desde las cuales miramos la
problema de automatización de radio, como de informáticos (lea
hackers), como de usuarios de linux, Debian y lo demás. Para
facilidad de comprensión si puede organizar el trabajo en los
siguientes elementos:

evaluación de problema, 2. reducción de problema a sus partes 3.
investigar de applicacion que resuelvan cada uno de los sub
problemas. 4. escribir codigo 5 probar novedades 6 evaluar 7
escribir mas código 8 escribir documentación 9 implementación
en el campo (capacitaciones y lo demás) 10 procedemento para
incluir nuestros cambios en Debian

Necesidades
-----------

Requerimos unir un pequeño grupo (5 o menos) gentes que reúne
las experiencias de audio en Linux y radio en comunidades, y
sostenerlos dentro el tiempo de trabajo. Proponemos un tiempo
aproximado de 6 meses para su realización. Mientras que
pensamos la creación de una cabina para Debian seria util para
muchos de por si, observamos cierta limitación en cuanto a
sostentabilidad.

Encanto que resolvemos la problemática que pretendimos, su
comunidad de uso tenderá de crecer de manera rápida.
Proporcional con ello incrementara la necesidad de soporte
técnico tanto para el grupo de aplicaciones de la cabían como
a Linux mismo. Como resulto natural, una olla de nuevos
necesidad seguramente surgiera en cuanto que Debian GNU/Linux
sea apropiado de manera mas general por las comunidades.

Proponemos entonces la inclusión de al menos 2 participantes del
grupo de trabajo reciben ´becas de estudio´.

Aplicaciones de Evaluación

Nuestras Herramientas de trabajo son la sistema operativo Debian
GNU/Linux, y lo venimos llamando su ecosistema de aplicaciones.
En realidad a lo referimos son las aplicaciones o programas
empaquetados y distribuidos con Debian. Prefiriendo siempre su
versión actual estable, pero sin limitarnos a ello cuando hay
un buen motivo para ello. De alguna manera el ecosistema
también incluye mucho mas que únicamente programas o paquetes,
también es la documentación que los acompaña, padrones de uso.
Eso de la ecosistema tiene que ser al menos suficientemente
amplio para contemplar la misma gente que participa. Además
opciones proporcionados por derivados como 64studio, musix y
flujos-vivos merecen una mirada, o varias.

Elementos De la Sistema Operativa Radiofónica
---------------------------------------------

De alguna manera tenemos que identificar que vamos a
desarrollar. Que visión tenemos de las herramientas de trabajo
en la cabina.

Reproducción de musica

Manejar biblioteca de musca (búsquedas por titulo artista etc,
agregar nueva musica, organizar musica)

Reproducción de la hora

mezclar

efectos (cruzada)

temporalizaron

grabación de programas

Desde un principios algunos proyectos saltan a la vista. Por
adelantar la programa presentamos algunas de las aplicaciones
que saltan a la vista, ordenados por categoría de uso.

Reproducción
------------

MPD - El Demonio de Reproducción de Musica (MPD) es un servidor
de musica, que puede ser utilizados por cualquier cliente que
entiende a su protocolo. Significa que uno no necesita un
monitor para escuchar musica. Es una programa además muy
eficiente y su uso de recursos muy bajo permitiendo su uso en
computadoras viejas y sistemas empotradas. Que es un servidor
también significa que el cliente no tiene que estar en la misma
maquina que el servidor, por lo cual hay usos interesantes.
Complementa muy bien la sistema de audio en Linux en general,
tiene algunos efectos sencillos y utiliza alrededor de 5MB de
RAM. Su clientes que nos resultan mas interesante, mpc, ncmpc y
gmpc.

Rhythmbox – reproductor de musica en base de gstreamer, parte
del proyecto Gnome, y reproductor predeterminado de Debian.
Incluye un muy amigable ventana con un buscador avanzado y una
cola de reproducción que da respuesta sencilla a la problema de
programación de audio o lo que llamamos temporalizaron.

IDJC (Internet DJ Consol)

Ademas existen muchos reproductores de linea de comandos que
pueden servir ciertos propositos. Como por ejempl aplay,
ogg123, etc.

Grabación
---------

Alsarecord

jackrec

jack-stdio

gstreamer

audacity

ardour

Temporalizacion
---------------

Cron

Sincronización y Manipulación de audio

Alsa- el driver de audio proporcionado por linux. Existen muchos
configuraciones y plugins que al uso diario

Jackd- servidor de audio en tiempo real. Suporte midi, y un
rendimiento en tiempo real utilizando varias “backends” tales
como alsa y inclusive para interacción sobre la red.

Gstreamer – framework para construcción de tuberías de
multimedia. En esencia uno escribe en C, python o perl,
utilizando Gobject una tubería que fluye generalmente entre un
fuente (src) y destino (sink). Aun que esta proporcionado
únicamente para hacer pruebas, mucho si puede hacer con el
inaplicación de linea de comandos gst-launch. Gstreamer es la
sistema de audio utilizado por el entorno gráfica Gnome.

liquidsoap

Flujos
------

Darkice

gstreamer

netjack (jackd)

idjc

oggfwd

netcat

Criterio de Evaluación de aplicaciones
--------------------------------------

Algunas consideraciones de para tomar en cuenta al evaluar
aplicaciones son:

Dado que en todos otros respectos dos aplicaciones son iguales,
la que consume menos recursos de la sistema es preferible. Nos
encantaría poder hacer funcionar nuestro radio desde el CPU en
el museo de la comunidad. Y si corre también en una computadora
que cabe en una lata de faros que bueno.

Es preferible un aplicación mantenido, donde bugs son cerrados
con frecuencia, que una programa que no recibe manteamiento.

Es preferible un aplicación que quepa de manera orgánica dentro
del ecosistema particular a nuestra sistema como aquí la
vayamos diseñando. Si utilizamos gnome, por ejemplo, ya tenemos
a la mano gstreamer. Un punto para rhythmbox y así. es un opción
obvio en este caso.

Evaluación
----------

Reproducción
------------

Rhythmbox fue elegido por el plugin de la hora por su sencilla
interfaz, y por exponer todo relacionado a su uso cotidiano en
un única vista. El usuario no tiene que moverse dentro e la
programa para buscar una canción, por ejemplo. Al nivel mas
técnico, proporciona un método que dispara al reproducir un
audio, lo cual permite que Plugin de la hora combina el fichero
de la hora con la del minuto al momento de reproducir. Es
mantenido sobre todo por una persona quien ya ha anunciado que
pronto va a discontinuar el desarrollo de rhythmbox. No
funciona el efecto de cruzada que algunos requieren. Tiene una
'colo de reproducción' que si ha ocupado para programar una
secuencia de audio.

Al contrario MPD es resultado de un esfuerzo realmente amplio
con un comunidad de desarrollo activa. Aun no sabemos si mpd o
gmpc tiene un método parecida a esta, o si hay alguna forma de
imitarlo. Es tema de investigación. Pero debido a su
estabilidad, diversidad y activo comunidad de uso y desarrollo,
y su impresionan muy ligero en los recursos de la sistema,
pensamos que mpd es muy recomendable. Efecto de Cruzada es muy
bueno. Complementariamente a la ´cola´ de Rhythmbox, mpd tiene
una lista de reproducción actual en lo cual si puede organizar
audio secuencialmente o dejarlo como ruleta, como dicen. Sin
saber que tan diferente sean la ´cola´ de rhythmbox del ´lista´
en términos de código, al nuestro ojo si diferencian únicamente
en terminios de diseño de interfaz. Los interfaz de mpd como
gmpc siempre han preferidos mantener los distos funciones de
mpd en disntas pestañas. Pero no veamos razon nigun que no si
puede hacer pequeños adaptaciones al interfaz para hacer su
´lista´ de mpd aparecer a la ´cola´ de rhythmbox. O incluir un
buscador en otro parte, como la tiene rhythmbox.

El atractivo de IDJC es que esta integrado codificación y subida
al servidor para flujos de audio sobre http. Especialmente sus
dos ventanitas como mezclador de DJ inspira uno pensar en usos
mas avanzadas de mesclaje de musica desde la misma ordenadora
de cabina. Trae varias dependencias inconvenientes que son las
bibliotecas de ffmpeg. Nos ha ocurrido la idea un rehacer sus
funciones de reproducción y codificación con gstreamer. Otra
idea de mutación seria dejar sus ventanitas conectar a mpd un
sesión de mpd.

