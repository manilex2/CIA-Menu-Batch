@title RT1 %1 - Arranque MOSAIC
cls
@echo off
rem *********************************************************************
rem Archivo: rt1.bat 
rem
rem Version 0803 Oct 2013
rem
rem  Descripcion: 
rem 	Utilizado para ejecutar la instalacion ON DEMAND de diccionarios
rem	MOSAIC
rem	
rem Parametros: -n<proj>
rem Llamado por: 
rem
rem Creado por: Jose A. Rodriguez 
rem Fecha creacion: Jul 2005
rem 
rem Historia de cambios:
rem
rem 16-10-2013	Ver 0802	
rem		* Se agrega revision de conexion con los dns. Se creara el error RT-115 para 
rem 		inidcar que el @ping a los DNS no es exitoso, indicando a cual
rem
rem		* Se ajustar el nro. de @ping de 2 a 3
rem
rem 01-10-2013	Ver 0801
rem		Para disminuir lso errores RT-111, se agrego ejecutar un release y renew de
rem		la IP de la estacion de trabajo
rem
rem 11-07-2013  Se agrega validacion del recurso compartido log donde se escribe un archivo
rem             al instalar una version de diccionario. Tambien se agrega validacion de la
rem             escritura de este archivo. e no poderse esribir se muestra mensaje de error
rem             pero se permite continuar
rem
rem 08-07-2013  Se elimino validacion recurso compartido MOA 
rem
rem
rem 22-04-2013  Se agrega seccion REV_OTROS 
rem             en la cual si existe en el servidor las carpetas de soft mos_new_rt se copian 
rem             su contenido a la estacion de trabajo
rem
rem 25-03-2013  Se homologa tanto para el uso en Windows XP y Windows 7. 
rem             Se elimina el uso de activar / desactivar servicios ya que no se permite en Windows 7 por permisologia
rem             Se copia archivo CTSParameters.ini desde el servidor
rem             Se copian archivos para archivos rt para uso de usuario de servicio para mosaic 
rem 
rem 07-12-2010  El protocolo de comunicacion se obtendra del archivo MOA_COMM.ini en la ruta D:\MOACOMM del 
rem             servidor de la oficina.
rem             Se agrego auto instlacion para MOSAIC IP
rem
rem 03-11-2010  Se agrego logica para verificar versiones del mosaicproxy, tanto del ini como de exe
rem 
rem 24-5-2010   Se agreg� mantenimiento a los directorios del MosaicProxy (C:\Mproxy)
rem 
rem 17-11-2009	Se revisara en los archivos DDPROJ.ini, CTSParameters.ini que se esta apuntando al servidor
rem		basado en lo sprimeros 4 digitos del nombre de la estaci�n de tarbajo, que 
rem		seg�n los estandares es el codigo de oficina.
rem		De igual manera se hara con el nombre del mainframe usado en Mosaicproxy.ini
rem
rem 26-12-2008  Se agrego mejora para eliminar delay de 60 sec para MOSAC IP. Al realizar el primero se graba archivo IP.txt.
rem             De existir IP.txt se verifica si se requiere copiar diccionario
rem 
rem 13-11-2008  Se agrego validacion ue solo Usuarios del dominio OFICINA y que sean b o c carnet pueden ejecutar MOSAIC
rem        
rem 30-05-2008  Para preaparci�n de MOSAIC IP, se requiere agregar verificacion si el servicio esta instalado,
rem             y de estarlo se reuiere verificar si esta activo. A su vez, se debe agregar delay de 1 min. ejcutar el RT. Se utiliza el programa delay.exe
rem
rem
rem 27-10-2006  Se elimino el uso del D$ ya qu esto solo aplica con usuarios administradores
rem             Se agreg� el tener un solo archivo log con los datos de las estaciones de trabajo actualizadas
rem             Se utilizara el programa now para generar fecha y hora y cambiar el esquema actual
rem 
rem 04-10-2006  Se adapto en la ruta de acceso para uso con estaciones XP.
rem             Se agreg� d$ en esta ruta.
rem
rem 30-09-2005  Se agrego quitar el atributo de solo lectura de los archivos que comiencen por DD en el directorio
rem		c:\moaproj\demo de las estaciones de trabajo
rem 15-09-2005  Se quito el mensaje cuando culmina exitosamente la copia, ya que esto puede confun@dir al usuario.
rem             Solo se muestran popups al ocurrir un error 
rem **********************************************************************

taskkill /F /IM rt.exe        >nul 2>&1
taskkill /F /IM drwtsn32.exe  >nul 2>&1

set rtver=0802
set PROG_ID="RT1"
set LOGF=on_demand.log
set t1=%1
set tproj=%t1:~2,4%
set tipo=%USERNAME:~0,1%
set ofi=%COMPUTERNAME:~0,4%
set type=%COMPUTERNAME:~4,2%
set srv=%ofi%SRV1
set origen="| %USERNAME%-%COMPUTERNAME% "
set cont=N
set prot=IP
set soft=\\%srv%\oficina_mercantil\soft\drivers_y_aplicaciones

:VAL_USER
:--------
rem Validar que los usuario sde MOSAIC son b o c carnet
rem
IF %tipo% == b GOTO INICIO
IF %tipo% == B GOTO INICIO
IF %tipo% == c GOTO INICIO
IF %tipo% == C GOTO INICIO
rem IF %USERDOMAIN% == OFICINA GOTO INICIO
rem IF %USERDOMAIN% == oficina GOTO INICIO
GOTO RT-109

:INICIO
:------
c:
cd\moa\bin

:REL_IP
:------
rem 
rem Release / renew de la IP de la estacion
rem
@ipconfig /release
@ipconfig /renew

:CONX_SRV1
:---------
rem 1 - Verificar acceso a servidor
@title Ejecutando ping a servidor de la oficina %srv%

@ping -n 3 %srv% 
IF NOT %ERRORLEVEL% == 0 GOTO RT-100

:CONX_DNS-1
:--------

set paso=CONX_DNS-1
set npaso=CONX_DNS-2
rem Verificar @ping a servidores DNS BMADOFIC01, BMADOFIC02 y BMADOFIC03
rem
set dns=BMADOFICDC01
@tile Ejecutando ping al servidor DNS - %dns%
cls
@echo --
@echo Ejecutando ping al servidor DNS - %dns%
@echo -- 
@ping -n 3 %dns%
IF NOT %ERRORLEVEL% == 0 GOTO RT-115 
GOTO VAL_COMPARTIDO

:CONX_DNS-2
set paso=CONX_DNS-2
set npaso=CONX_DNS-3
set dns=BMADOFICDC02
@tile Ejecutando ping al servidor DNS - %dns%
cls
@echo --
@echo Ejecutando ping al servidor DNS - %dns%
@echo -- 
@ping -n 3 %dns%
IF NOT %ERRORLEVEL% == 0 GOTO RT-115 
GOTO VAL_COMPARTIDO

:CONX_DNS-3
set paso=CONX_DNS-3
set npaso=SALIR
set dns=BMADOFICDC03
@tile Ejecutando ping al servidor DNS - %dns%
cls
@echo --
@echo Ejecutando ping al servidor DNS - %dns%
@echo -- 
@ping -n 3 %dns%
IF NOT %ERRORLEVEL% == 0 GOTO RT-115 

:VAL_COMPARTIDO
:--------------
rem Validar recursos compartidos
rem 
@erase net.txt /Q
@net view \\%srv% > net.txt
set remote=moaproj
@FINDSTR /I /C:"moaproj" net.txt 
IF NOT %ERRORLEVEL% == 0 GOTO RT-101
set remote=BMLS100
@FINDSTR /I /C:"BMLS100" net.txt 
IF NOT %ERRORLEVEL% == 0 GOTO RT-101
rem set remote=Imagen2
rem @FINDSTR /I /C:"Imagen2" net.txt 
rem IF NOT %ERRORLEVEL% == 0 GOTO RT-101
set remote=log
@FINDSTR /I /C:"log" net.txt 
IF NOT %ERRORLEVEL% == 0 GOTO RT-101
@dir \\%srv%\moaproj\demo\dd*
IF NOT %ERRORLEVEL% == 0 GOTO RT-102

IF %type% == CO GOTO QMATIC
IF %type% == co GOTO QMATIC
GOTO REV_DDPROJ

:QMATIC
IF NOT EXIST C:\"Archivos de programa"\QMatic_Host\QmHost.ini GOTO REV_DDPROJ
@ping -n 3 10.0.4.56
IF %ERRORLEVEL% == 0 GOTO REV_DDPROJ
GOTO RT-103

:REV_DDPROJ
rem Revisar nombre de servidor en DDPROJ.ini
@FINDSTR /I /C:"CDS_PRIMARY_NP=%srv%" c:\moaproj\demo\ddproj.ini
IF %ERRORLEVEL% == 0 GOTO REV_CTS
@copy \\%srv%\moaproj\demo\ddproj.ini c:\moaproj\demo\* /Y
IF NOT %ERRORLEVEL% == 0 GOTO RT-104

:REV_CTS
rem  Copiar archivos CTSParameters.ini y Revisar nombre de servidor en CTSParameters.ini
IF EXIST %soft%\Ls100\Config @copy %soft%\Ls100\Config\CTSParameters.ini* c:\moa\bin\* /Y
IF EXIST %soft%\dllwincor @copy %soft%\dllwincor\CTSParameters.ini* c:\moa\bin\* /Y
IF NOT %USERDOMAIN% == OFICINA GOTO RT-106



rem *************************************************************************************************

:REV_OTROS
rem Verificar si impersonificacion esta activa
rem 
@FINDSTR /C:"ACTIVO=S" %soft%\MOS_NEW_RT\mos_new_rt.ini
IF NOT %ERRORLEVEL% == 0 GOTO MOSCAC
@copy %soft%\MOS_NEW_RT\RT\rt.exe c:\moa\bin\* /Y

:MOS_NEW_RT
rem 
rem Verificar version OS de la estacion
rem 
@copy %soft%\MOS_NEW_RT\NEW_RT\* c:\moa\bin\* /Y
@ver > twin.txt
@FINDSTR /C:" 6." twin.txt
IF %ERRORLEVEL% == 0 @copy c:\moa\bin\rt_w7.exe  rt.exe  /Y

rem **********************************************************************************************************

:MOSCAC
@erase q1.txt /Q
@FINDSTR /I /C:"MOSCACIP" c:\Mproxy\mosaicproxy.ini 
IF NOT %ERRORLEVEL% == 0 GOTO MOSPROD
cls
@echo **************************************************** 
@echo *  ESTIMADO USUARIO - %USERNAME% 
@echo * 
@echo *  BIENVENIDO  AL CENTRO ALTERNO  CAC / MOSAIC
@echo *  SU ESTACION ES LA  %COMPUTERNAME%
@echo *
@echo *  Presione cualquier tecla para continuar
@echo *
pause
GOTO PASO_1

:MOSPROD
@FINDSTR /I /C:"MOSPRODIP" c:\Mproxy\mosaicproxy.ini 
IF NOT %ERRORLEVEL% == 0 GOTO RT-112
@ping -n 3 MOSPRODIP
IF NOT %ERRORLEVEL% == 0 GOTO RT-111
GOTO PASO_1

:PASO_1
cd\moa\bin
@attrib -r c:\moaproj\%tproj%\dd*
IF EXIST c:\moaproj\log GOTO MANT_IP
@MD c:\MOAPROJ\LOG

:MANT_IP
@cls
@echo -
@echo - Mantenimiento trazas IP . Por favor espere
@echo -
@dir c:\Mproxy\trace\*.*-
IF NOT %ERRORLEVEL% == 0 GOTO MLOG
@erase c:\Mproxy\trace\*.*- /Q
@rename c:\Mproxy\trace\*.* *.*-
:MLOG
@erase c:\Mproxy\log\*.log- /Q
@rename c:\Mproxy\log\*.log *.log-

:MAIN
set cont=N
rem Revisar si se esta en contingencia
rem 
@FINDSTR /B /C:"CDS_CONTINGENCIA=" c:\moaproj\%tproj%\ddproj.ini > %COMPUTERNAME%.txt 
@for /f "tokens=1-2 delims== " %%a in ('type %COMPUTERNAME%.txt') do (set t2=%%a& set consrv=%%b)
IF NOT EXIST \\%consrv%\moaproj\ql\ce_contingencia\act.txt GOTO NORMAL

:CONTINGENCIA
IF NOT EXIST c:\windows\system32\drivers\ls100UD.sys GOTO NORMAL
set cont=S
cls
@echo **
@echo Modalidad de CONTINGENCIA - ACTIVADA
@echo **
@echo Presione ENTER para continuar
@echo **
Pause
IF NOT EXIST C:\moaproj\demo\DDproj.ini.cont GOTO NORMAL
cd\moa\bin
@copy c:\moaproj\demo\DDproj.ini.cont 		c:\moaproj\demo\DDproj.ini /Y
@copy c:\moa\bin\CTSParameters.ini.cont  	c:\moa\bin\CTSParameters.ini /Y 
GOTO NORMAL1

:NORMAL
IF NOT EXIST c:\moaproj\demo\DDproj.ini.prod GOTO NORMAL1
@copy c:\moaproj\demo\DDproj.ini.prod 		c:\moaproj\demo\DDproj.ini /Y
@copy c:\moa\bin\CTSParameters.ini.prod 		c:\moa\bin\CTSParameters.ini /Y


:NORMAL1
@echo|@FINDSTR /B /I /C:"CDS_PRIMARY_NP=" c:\moaproj\%tproj%\ddproj.ini > %COMPUTERNAME%.txt 
for /f "tokens=1-2 delims== " %%a in ('type %COMPUTERNAME%.txt') do (set t2=%%a& set moasrv=%%b)
IF EXIST \\%moasrv%\moaproj\demo\version.txt GOTO version
GOTO RT-102

:version
@erase q1.txt /Q
rem Revisar version instalada 
cls
@echo ** 
@echo ** Verificando version de MOSAIC instalada 
@echo **
@echo ** POR FAVOR ESPERE
@echo **

IF %cont% == S GOTO rt

for /f "tokens=1-2 delims== " %%a in ('type \\%moasrv%\MOAPROJ\%tproj%\version.txt') do (set t2=%%a & set tver=%%b)
set tdicc=%TPROJ%_%TVER%_%COMPUTERNAME%
set tfile=%tdicc%.log
if exist \\%moasrv%\log\%tdicc%.log  goto rt
@FINDSTR /I /C:"%tdicc%" \\%moasrv%\log\%logf%
IF %ERRORLEVEL% == 0 GOTO rt

cls
@echo **
@echo ** VERSION = %tver%
@echo ** Copia de diccionario en proceso.  POR FAVOR ESPERE .........
@echo **

@attrib -r dd*
@copy \\%moasrv%\MOAPROJ\%tproj%\dd* c:\moaproj\%tproj%\* /Y
IF NOT %ERRORLEVEL% == 0 GOTO RT-108
@attrib +r dd*

rem Copia de diccionario con exito

set msg="| OK | 000 | Copia exitosa del diccionario version "%tver%
@now.exe %PROG_ID% %origen% %tid% %MSG% >> c:\moaproj\log\%logf%
@now.exe %PROG_ID% %origen% %tid% %MSG% >> \\%moasrv%\log\%logf%
@now.exe %PROG_ID% %origen% %tid% %MSG% > c:\moaproj\%tproj%\dir_tmp.txt
@dir c:\moaproj\%tproj%\dd* >> c:\moaproj\%tproj%\dir_tmp.txt
@copy c:\moaproj\%tproj%\dir_tmp.txt \\%moasrv%\log\%tfile% 
IF NOT %ERRORLEVEL% == 0 GOTO RT-114

rem *
rem Borrar archivos temporales en c:
rem *

:BORRAR
c:
@erase dir_tmp.txt /Q
cd\moaproj\%tproj%
@erase %tid%*.txt /Q

rem ***
rem Ejecutar RT
rem ***

:rt
C:
cd\moa\bin
start rt.exe %1
goto SALIDA

:RT-100
cls
@echo ** 
@echo ** CODIGO ERROR: RT-100 Ping NO EXITOSO al servidor de la oficina %srv%
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
GOTO FIN

:RT-101
cls
@echo ** 
@echo ** CODIGO ERROR: RT-101 Carpeta - %remote% - no compartida en servidor %srv%
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
GOTO FIN

:RT-102
cls
@echo ** 
@echo ** CODIGO ERROR: RT-102 Usuario no tiene acceso a carpetas compartidas moaproj
@echo **               Revisar usuario. Puede estar bloqueado
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
GOTO FIN

:RT-103
cls
@echo **
@echo ** CODIGO ERROR: RT-103 Qmatic Host - Sin conexion al Host
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
@echo ** Presione cualquier tecla para continuar
@echo **
pause
goto REV_DDPROJ

:RT-104
cls
@echo **
@echo ** CODIGO ERROR: RT-104 DDPROJ.ini desconfigurado
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-105
cls
@echo **
@echo ** CODIGO ERROR: RT-105 CTSparameters.ini desconfigurado
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-106
cls
@echo **
@echo ** CODIGO ERROR: RT-106 Usuario del dominio %USERDOMAIN% no tiene permisolog�a
@echo **               para operar equipo con lectora 
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-107
cls
@echo **
@echo ** CODIGO ERROR: RT-107 MOSAIC IP no instalado
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-108
cls
@echo **
@echo ** CODIGO ERROR: RT-108 No se pudo copiar diccionario 
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-109
cls
@echo **
@echo ** CODIGO ERROR: RT-109 %USERNAME% Usuario NO AUTORIZADO a ejecutar MOSAIC 
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-110
cls
@echo **
@echo ** CODIGO ERROR: RT-110 Archivo luacfg no xiste en servidor 
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-111
cls
@echo **
@echo ** CODIGO ERROR: RT-111 Sin acceso a MOSPRODIP (IP del Host via DNS) 
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-112
cls
@echo **
@echo ** CODIGO ERROR: RT-112 mosaicproxy.ini no posee MOSPRODIP com parametro 
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-113
cls
@echo **
@echo ** CODIGO ERROR: RT-113 Nueva version de MOSAIC IP no se instal�.
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
goto FIN

:RT-114
cls
@echo **
@echo ** CODIGO ERROR: RT-114 Sin acceso de escritura en recurso compartido LOG.
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
@echo ** Presione cualquier tecla para continuar
@echo **
pause
goto BORRAR

:RT-115
cls
@echo **
@echo ** CODIGO ERROR: RT-115 Ping NO EXITOSO a DNS  %dns%
@echo **
@echo ** Llamar al Service Desk e indicar CODIGO ERROR
@echo **
@echo ** Presione cualquier tecla para continuar
@echo **
pause
goto %npaso%

:FIN
@echo ** 
@echo Presione cualquier tecla para continuar
@echo **
pause


:SALIDA
