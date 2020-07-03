@ECHO OFF
setlocal enabledelayedexpansion
REM Este programa es un menú que nos ayuda a mejorar la productividad dandonos opciones para ejecutar
REM y hacer más fácil nuestro servicio. 
Color 1F
TITLE Eliminando Archivo Comprimido Archivos Service Desk.zip
DEL "%USERPROFILE%\Desktop\Archivos Service Desk - Coordinador.zip"
cls
TITLE Bienvenido
ECHO ==========================================
ECHO ============= Service Desk ===============
ECHO ========== Programa de Inicio  ===========
ECHO ==========================================
ECHO Indiqueme su nombre por favor
Set /p nombre=
:main
Color 1F
cls
TITLE Menu Inicio de Service Desk
ECHO ==========================================
ECHO ============= Service Desk ===============
ECHO ========== Programa de Inicio  ===========
ECHO ==========================================
ECHO Buenos dias %nombre%
ECHO Que desea realizar?
ECHO.
ECHO Escriba 1 si desea copiar los archivos para el servicio.
ECHO Escriba 2 si desea iniciar las aplicaciones para el servicio.
ECHO Escriba 3 si desea ejecutar PING a un equipo, servidor o ip.
ECHO Escriba 4 si desea ejecutar el menu de Comandos CDS.
ECHO Escriba 5 si desea ejecutar el programa de Enlace o IP masivos.
ECHO Escriba 6 si desea salir del sistema.
Set /p seleccione=
ECHO.
IF '%seleccione%'=='1' GOTO copia
IF '%seleccione%'=='2' GOTO iniciar
IF '%seleccione%'=='3' GOTO ping
IF '%seleccione%'=='4' GOTO validar
IF '%seleccione%'=='5' GOTO enlace
IF '%seleccione%'=='6' (GOTO fin) else (GOTO error1)




REM Esta es la opción 1, esto copiara en el sistema los archivos necesarios para ejecutar las distintas
REM herramientas para poder prestar un optimo servicio
:copia
cls
color 0F
TITLE Comando de Copia de Archivos
ECHO El siguiente programa copiara los archivos correspondientes
ECHO para el optimo funcionamiento de las herramientas.
ECHO.
ECHO Recuerde que debe haber ya descomprimido la carpeta Archivos Service Desk
ECHO en el escritorio, de lo contrario la copia no se realizara.
ECHO.
:acuerdo
ECHO %nombre% esta usted de acuerdo con continuar con la copia?
Set /p opcion=Si o No?
IF '%opcion%'=='si' GOTO si
IF '%opcion%'=='Si' GOTO si
IF '%opcion%'=='SI' GOTO si
IF '%opcion%'=='sI' GOTO si
IF '%opcion%'=='no' GOTO no
IF '%opcion%'=='No' GOTO no
IF '%opcion%'=='NO' GOTO no
IF '%opcion%'=='nO' (GOTO no) else (GOTO error)

:si
TITLE Copiando Archivos...
ECHO Espere mientras el sistema copia los archivos por favor.
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Plantilla Service Desk.xlsx" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\caf.lnk" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\eventcombMT.lnk" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\i2050.lnk" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\DSM Remote Control Viewer.lnk" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\mmc.lnk" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Inicio.bat" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\caf.exe" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\DIRECTORIO ACTIVO.msc" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\zephyr.zcc" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\zephyr.zws" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\Comedor.url" /-Y %USERPROFILE%\Desktop\
COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\Compartida V2 BETA (6GD8MS1) - Acceso directo.lnk" /-Y %USERPROFILE%\Desktop
XCOPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\eventcombMT" %USERPROFILE%\Desktop\eventcombMT /E /I /-Y
XCOPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil" C:\oper_mercantil /E /I /-Y
ECHO.
TITLE Copia de Archivos Finalizada
ECHO El Programa finalizo la copia de archivos.
ECHO.
ECHO ================================================
GOTO siguiente

:no
TITLE Copia de Archivos Cancelada
ECHO La copia de archivos fue cancelada.
ECHO.
ECHO Presione una tecla para volver al menu principal.
Pause>nul
GOTO main

:error
TITLE ERROR EN OPCION
cls
ECHO No selecciono una opcion valida, intente nuevamente.
ECHO.
GOTO acuerdo

:siguiente
TITLE Iniciar Aplicaciones del Service Desk
Color b0
cls
:iniciarapp
ECHO %nombre% desea iniciar las aplicaciones para el servicio?
ECHO Ingrese Si, si desea ejecutarlas o No, si desea ir al menu.
Set /p iniciar=
If '%iniciar%'=='Si' GOTO iniciar
If '%iniciar%'=='si' GOTO iniciar
If '%iniciar%'=='SI' GOTO iniciar
If '%iniciar%'=='sI' GOTO iniciar
If '%iniciar%'=='No' GOTO main
If '%iniciar%'=='NO' GOTO main
If '%iniciar%'=='no' GOTO main
If '%iniciar%'=='nO' (GOTO main) else (GOTO error2)

:error2
cls
TITLE ERROR EN OPCION
ECHO Opcion invalida, intente nuevamente.
ECHO.
GOTO iniciarapp




REM Esta es la opción 2, esto se usará para iniciar las aplicaciones que solemos usar para brindar el soporte.
:iniciar
TITLE Verificando Archivos Necesarios Instalados
ECHO Se estan verificando los archivos para las aplicaciones, espere por favor.
ECHO.
IF NOT EXIST "%USERPROFILE%\Desktop\Plantilla Service Desk.xlsx" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Plantilla Service Desk.xlsx" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\caf.lnk" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\caf.lnk" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\eventcombMT.lnk" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\eventcombMT.lnk" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\i2050.lnk" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\i2050.lnk" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\DSM Remote Control Viewer.lnk" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\DSM Remote Control Viewer.lnk" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\mmc.lnk" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\mmc.lnk" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\Comandos" (XCOPY "%USERPROFILE%\Desktop\Archivos Service Desk\Comandos" %USERPROFILE%\Desktop\Comandos /E /I) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\eventcombMT.exe" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\caf.exe" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\DIRECTORIO ACTIVO.msc" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\DIRECTORIO ACTIVO.msc" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\zephyr.zcc" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\zephyr.zcc" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\zephyr.zws" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\zephyr.zws" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\Inicio.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Inicio.bat" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\Comedor.url" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\Accesos Directos\Comedor.url" %USERPROFILE%\Desktop\) Else (ECHO OFF)
IF NOT EXIST "%USERPROFILE%\Desktop\eventcombMT" (XCOPY "%USERPROFILE%\Desktop\Archivos Service Desk\Programas\eventcombMT" %USERPROFILE%\Desktop\eventcombMT /E /I) Else (ECHO OFF)
cls
Color b0
REM Este es un script que nos ayuda a inciar los programas que usamos para el día a día con los cuales
REM prestamos el soporte al cliente.
Echo ==================================================
Echo =========== Buenos dias %nombre% ============ 
Echo ==================================================
ECHO Por favor espere mientras se ejecutan los programas...
Start "Avaya" "%USERPROFILE%\Desktop\i2050.lnk"
Start "DSMRemoteControlViewer" "%USERPROFILE%\Desktop\DSM Remote Control Viewer.lnk"
Start "ServiceAide" "https://csm3.serviceaide.com/"
Start "Outlook" "https://outlook.office365.com/"
Start "Gmail" "https://mail.google.com/"
Start "Comedor" "%USERPROFILE%\Desktop\Comedor.url"
Start "Plantilla Service Desk.xlsx" "C:\Users\c616140\Desktop\Plantilla Service Desk.xlsx"
Start "Zephyr" "%USERPROFILE%\Desktop\zephyr.zws"
Start "Eventcomb" "%USERPROFILE%\Desktop\eventcombMT.lnk"
Start "Directorio" "%USERPROFILE%\Desktop\mmc.lnk"
Start "Cafe" "%USERPROFILE%\Desktop\caf.lnk"
color 3F
ECHO.
ECHO.

:menucds
ECHO %nombre% desea abrir el menu de Comandos CDS?
Set /p opcion=Si o No?
IF '%opcion%'=='si' GOTO CDS
IF '%opcion%'=='Si' GOTO CDS
IF '%opcion%'=='SI' GOTO CDS
IF '%opcion%'=='sI' GOTO CDS
IF '%opcion%'=='no' GOTO finalizado
IF '%opcion%'=='No' GOTO finalizado
IF '%opcion%'=='NO' GOTO finalizado
IF '%opcion%'=='nO' (GOTO finalizado) else (GOTO errorproini)

:errorproini
cls
ECHO Opcion invalida, intente de nuevo.
ECHO.
GOTO menucds

:finalizado
Color b0
ECHO.
ECHO Los programas han sido ejecutados correctamente, presione una tecla para ir al
ECHO menu principal.
Pause>nul
GOTO main




REM Esto se refiere a la opción numero 3, esto se usa para revisar que respondan los distintos
REM servidores o equipos que se les haga PING.
:ping
cls
color 4F
TITLE Indique nombre del HOST
ECHO %nombre% indiqueme nombre del host (equipo, servidor o ip).
set /p ip= 
ECHO.
:mainping
cls
TITLE Menu Comandos Ping
ECHO Host o IP: %ip%
ECHO %nombre% que desea hacer?
ECHO.
ECHO 1.- Hacer ping.
ECHO 2.- Hacer ping al host y al enlace.
ECHO 3.- Hacer ping extendido.
ECHO 4.- Comprobar nombre del Host (si esta disponible).
ECHO 5.- Seleccionar otro Host
ECHO 6.- Ir al menu principal.
set /p pinghost=

IF '%pinghost%'=='1' GOTO hostping
IF '%pinghost%'=='2' GOTO enlhostping
IF '%pinghost%'=='3' GOTO exthost
IF '%pinghost%'=='4' GOTO comphost
IF '%pinghost%'=='5' GOTO ping
IF '%pinghost%'=='6' (GOTO main) else (GOTO errorping)

:hostping
TITLE Haciendo Ping.
cls
ping %ip%
ECHO.
ECHO.
ECHO Presione una tecla para volver al menu anterior.
TITLE Ping Finalizado
PAUSE>nul
cls
GOTO mainping

:enlhostping
TITLE Haciendo Ping al Host y al Enlace
cls
ECHO %IP%>%USERPROFILE%\Desktop\servidor.txt
for /f %%i in (%USERPROFILE%\Desktop\servidor.txt) do (
    set SERVER_ADDRESS=-
    for /f "tokens=1,2,3,4,5" %%a in ('ping -n 1 %%i ^&^& echo SERVER_IS_UP') do (
	if %%a==Estad¡sticas set SERVER_ADDRESS=%%e
    )
    echo !SERVER_ADDRESS::=!>>%USERPROFILE%\Desktop\resultadoip.txt
)
for /F "tokens=1-3 delims=.:" %%a in (%USERPROFILE%\Desktop\resultadoip.txt) do (
  set concatena=%%a.%%b.%%c)
ECHO %ip%
ping %ip%
ping %concatena%.254
ECHO.
ECHO.
TITLE Ping Finalizado.
ECHO Presione una tecla para volver al menu anterior.
PAUSE>nul
DEL %USERPROFILE%\Desktop\servidor.txt
DEL %USERPROFILE%\Desktop\resultadoip.txt
GOTO mainping

:exthost
TITLE Haciendo Ping Extendido.
cls
ECHO.
ECHO Haciendo ping a %ip%. Presione CTRL + C para terminar el ping.
ECHO.
ECHO NOTA: VISUALICE EL PING, LUEGO PRESIONE "N" PARA QUE EL PROGRAMA NO SE CIERRE.
ping %ip% -t
TITLE Ping Finalizado
GOTO mainping

:comphost
cls
TITLE Obteniendo Nombre del Host
ECHO Si introdujo una IP en vez de un nombre de Host, el programa le indicara
ECHO el nombre del host si se encuentra disponible, de lo contrario arrojara
ECHO un mensaje que indicara "Nombre de Host no disponible."
ECHO %IP%>%USERPROFILE%\Desktop\servidor.txt
for /f %%i in (%USERPROFILE%\Desktop\servidor.txt) do (
    set SERVER_ADDRESS=-
    for /f "tokens=1,2,3,4" %%a in ('ping -a %%i') do (
	if %%a==Haciendo set SERVER_ADDRESS=%%d
    )
    echo !SERVER_ADDRESS::=!>%USERPROFILE%\Desktop\resultadohostname.txt
)
for /F "tokens=1-3 delims=.:" %%a in (%USERPROFILE%\Desktop\resultadohostname.txt) do (
  set servidornombre=%%a)
ECHO.
IF '%servidornombre%'=='10' set servidornombre=Nombre de Host no disponible.
ECHO El nombre de Host es: %servidornombre%
ECHO.
TITLE Verificacion de Nombre de Host Terminada
ECHO Presione una tecla para volver al menu anterior.
PAUSE>nul
DEL %USERPROFILE%\Desktop\servidor.txt
DEL %USERPROFILE%\Desktop\resultadohostname.txt
GOTO mainping

:errorping
TITLE ERROR EN OPCION
ECHO Ha introducido una opción incorrecta. Vuelva a intentarlo
GOTO mainping




REM Esto se refiere a la opción 4, esto ejecutara el menú de comandos de CDS.
:validar
TITLE Verificando Archivos para Menu Comandos CDS
color 3F
ECHO %nombre% el sistema verficara si se encuentran los archivos para ejecutar, espere...
ECHO.
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Activar_servicio.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Activar_servicio.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\cds_revisa.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\cds_revisa.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\CDS_revisa.exe" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\CDS_revisa.exe" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\cds_revisav1.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\cds_revisav1.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Comandos.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Comandos.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Comandos_av.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Comandos_av.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\conectar_servidor.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\conectar_servidor.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\delay.exe" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\delay.exe" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\NOW.exe" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\NOW.exe" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\PsExec.exe" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\PsExec.exe" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Revisar_CDS_log.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Revisar_CDS_log.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Revisar_conexion_CDS.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Revisar_conexion_CDS.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Revisar_log.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Revisar_log.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Revisar_not_run.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Revisar_not_run.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\Revisar_servicio.bat" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\Revisar_servicio.bat" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\t1.txt" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\t1.txt" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
IF NOT EXIST "C:\oper_mercantil\batch\cds_revisa\ver.txt" (COPY "%USERPROFILE%\Desktop\Archivos Service Desk\oper_mercantil\batch\cds_revisa\ver.txt" C:\oper_mercantil\batch\cds_revisa\) Else (ECHO archivo encontrado.)
ECHO.
TITLE Verificacion Completada
ECHO Verificacion completada.
GOTO CDS

:CDS
TITLE Ingrese un admin
ECHO.
ECHO %nombre% Ingrese un admin por favor. Ejemplo: admin-c6161XX
Set /p admin=
runas /user:oficina\%admin% /savedcred C:\oper_mercantil\batch\cds_revisa\Comandos_av.bat
GOTO main

:error1
TITLE ERROR EN OPCION
ECHO Opcion no valida, intente de nuevo.
ECHO Presione una tecla para volverlo a intentar.
Pause>nul
GOTO main




REM Esto se refiere a la opción 5, mediante esto podremos obtener las ips de manera masiva de los equipos
REM o hacer ping de manera masiva indicandonos si se encuentran operativos o no.
:enlace
ECHO.
TITLE INFORMACION
cls
color 2F
ECHO Para ejecutar este programa correctamente debe colocar los 
ECHO nombres de HOST (equipos) separados por saltos de lineas
ECHO en el archivo de texto "Equipos.txt" y guardar el archivo.
ECHO.
:menu
TITLE Verificacion de ingreso de Host
ECHO %nombre%, ya coloco los nombres de host o IPs?
ECHO.
ECHO Introduzca Si, si ya lo realizo o No, para colocar los equipos o
ECHO introduzca salir, para volver al menu inicial.
Set /p hosts=
IF '%hosts%'=='si' GOTO yes
IF '%hosts%'=='Si' GOTO yes
IF '%hosts%'=='SI' GOTO yes
IF '%hosts%'=='sI' GOTO yes
IF '%hosts%'=='no' GOTO not
IF '%hosts%'=='No' GOTO not
IF '%hosts%'=='NO' GOTO not
IF '%hosts%'=='nO' GOTO not
IF '%hosts%'=='salir' GOTO salir
IF '%hosts%'=='Salir' GOTO salir
IF '%hosts%'=='SALIR' (GOTO salir) else (GOTO enlerror)

:enlerror
TITLE ERROR EN OPCION
ECHO.
cls
ECHO Opcion invalida, intente nuevamente.
ECHO.
GOTO menu

:not
TITLE Ingrese los Host en el TXT, guardelo y cierre el bloc de notas.
cls
ECHO Esperando que guarde y cierre el bloc de notas...
@ECHO OFF >%USERPROFILE%\Desktop\Equipos.txt
%USERPROFILE%\Desktop\Equipos.txt
cls
GOTO menu

:salir
ECHO.
GOTO main

:yes
TITLE Indique que Desea Hacer
ECHO.
ECHO %nombre% que desea ejecutar?
ECHO Presione 1 para Disponibilidad de Enlace.
ECHO Presione 2 para mostrar solo la direccion IP de los Host.
ECHO Presione 3 para salir al menu anterior.
Set /p disp=
IF '%disp%'=='1' GOTO Dispon
IF '%disp%'=='2' GOTO IPS 
IF '%disp%'=='3' (GOTO menu) Else (GOTO selerror)

:Dispon
TITLE Verificando Disponibilidad de Hosts...
cls
ECHO El programa arrojara un bloc de notas con los datos al finalizar la ejecucion.
ECHO Este proceso puede durar de varios minutos a horas, dependiendo de la
ECHO cantidad de Hosts colocados en "Equipos.txt".
ECHO.
ECHO Presione cualquier tecla para empezar a ejecutar el programa.
Pause>nul
TITLE Programa iniciado...
ECHO Programa iniciado, espere por favor...
set OUTPUT_FILE=%USERPROFILE%\Desktop\resultado.txt
>nul copy nul %OUTPUT_FILE%
for /f %%i in (%USERPROFILE%\Desktop\Equipos.txt) do (
    set SERVER_ADDRESS=esta fuera de la Red
    for /f "tokens=1,2,3,4,5" %%a in ('ping -n 2 %%i ^&^& echo SERVER_IS_UP') do (
	if %%a==Estad¡sticas set SERVER_ADDRESS=su IP es %%e
        if %%a==SERVER_IS_UP (set SERVER_STATE=Operativo) else (set SERVER_STATE=Caido)
    )
    echo El Host %%i se encuentra !SERVER_STATE!, !SERVER_ADDRESS::=! >>%OUTPUT_FILE%
)
TITLE Cuando este listo, cierre el bloc de notas para continuar.
cls
ECHO Esperando que cierre bloc de notas...
%USERPROFILE%\Desktop\resultado.txt
ECHO.
cls
TITLE Programa finalizado.
ECHO Programa finalizo correctamente.
ECHO.
:introduzca
ECHO Introduzca 1 para continuar ejecutando el menu de enlace, o 2 para salir
ECHO al menu principal.
Set /p opcienl=
IF '%opcienl%'=='1' GOTO menu
IF '%opcienl%'=='2' (GOTO salirenl) Else (GOTO errorenldi)

:salirenl
cls
ECHO Si esta seguro de que ya realizo todas las operaciones, presione una tecla 
ECHO para continuar, esto borrara los bloc de notas creados "Equipos.txt" 
ECHO y "resultado.txt", no se podra recuperar los archivos.
ECHO Si por el contrario necesita los archivos copielos en otra carpeta,
ECHO renombrelos o haga las operaciones primero y luego presione una tecla
ECHO en este programa.
ECHO.
ECHO Presione una tecla solo si esta seguro de salir al menu principal.
PAUSE>nul
DEL %USERPROFILE%\Desktop\Equipos.txt
DEL %USERPROFILE%\Desktop\resultado.txt
GOTO main

:errorenldi
TITLE ERROR EN OPCION
cls
ECHO Opcion invalida, intente nuevamente.
ECHO.
GOTO introduzca

:IPS
TITLE Verificando IPS de los Hosts...
cls
ECHO El programa arrojara un bloc de notas con los datos al finalizar la ejecucion.
ECHO Este proceso puede durar de varios minutos a horas, dependiendo de la
ECHO cantidad de Hosts colocados en "Equipos.txt".
ECHO.
ECHO Presione cualquier tecla para empezar a ejecutar el programa.
Pause>nul
TITLE Programa iniciado...
ECHO Programa iniciado, espere por favor...
set OUTPUT_FILE=%USERPROFILE%\Desktop\resultado.txt
>nul copy nul %OUTPUT_FILE%
for /f %%i in (%USERPROFILE%\Desktop\Equipos.txt) do (
    set SERVER_ADDRESS=-
    for /f "tokens=1,2,3,4,5" %%a in ('ping -n 1 %%i ^&^& echo SERVER_IS_UP') do (
	if %%a==Estad¡sticas set SERVER_ADDRESS=%%e
        if %%a==SERVER_IS_UP (set SERVER_STATE=Operativo) else (set SERVER_STATE=Caido)
    )
    echo !SERVER_ADDRESS::=! >>%OUTPUT_FILE%
)
TITLE Cuando este listo, cierre el bloc de notas para continuar.
cls
ECHO Esperando que cierre bloc de notas...
%USERPROFILE%\Desktop\resultado.txt
cls
TITLE Programa finalizado.
ECHO Programa finalizo correctamente.
ECHO.
:introduzca
ECHO Introduzca 1 para continuar ejecutando el menu de enlace, o 2 para salir
ECHO al menu principal.
Set /p opcienl=
IF '%opcienl%'=='1' GOTO menu
IF '%opcienl%'=='2' (GOTO salirenl) Else (GOTO errorenldi)

:selerror
TITLE ERROR EN OPCION
ECHO.
cls
ECHO Opcion invalida, intente nuevamente.
GOTO yes




REM Esta opción es la 6 y finaliza la ejecución del programa.
:fin
TITLE Gracias por Usar El Programa.
ECHO El Programa finalizo correctamente. Ten un lindo dia %nombre%.
ECHO Presione cualquier tecla para cerrar.
PAUSE>nul