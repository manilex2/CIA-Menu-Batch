@ECHO OFF
REM Esto es un script que nos ayuda a juntar todos los comandos que se ejecutan referentes al CDS de la
REM oficina en solo programa, que a su vez tiene un menú para poder ejecutarlos de manera mas práctica.
color 3F
cd/
cd oper_mercantil\batch\cds_revisa
GOTO home
:home
cls
ECHO ==================================
ECHO ==================================
ECHO ========== CDS COMANDOS ==========
ECHO ===== SERVICE DESK MERCANTIL =====
ECHO ==================================
ECHO ==================================
ECHO.
ECHO Buenos dias Service Desk. Indiqueme el codigo de la oficina por favor.
Set /p ofi=
GOTO main
:main
ECHO Que comando desea ejecutar?
ECHO 1.- CDS Revisa
ECHO 2.- Revisar CDS Log
ECHO 3.- Revisar Servicio
ECHO 4.- Revisar Not Run
ECHO 5.- Revisar Conexion CDS
ECHO 6.- Activar Servicio
ECHO 7.- Es otra oficina
ECHO 8.- Salir del programa
set /p seleccion=
if '%seleccion%'=='1' GOTO :eleccion1
if '%seleccion%'=='2' GOTO :eleccion2
if '%seleccion%'=='3' GOTO :eleccion3
if '%seleccion%'=='4' GOTO :eleccion4
if '%seleccion%'=='5' GOTO :eleccion5
if '%seleccion%'=='6' GOTO :eleccion6
if '%seleccion%'=='7' GOTO :home
if '%seleccion%'=='8' GOTO :salir1

:eleccion1
cls
@echo off
rem *********************************************************************
rem Archivo: CDS_revisa.bat
rem
rem Version 1.3.3 
rem
rem  Descripcion: 
rem 	Utilizado para revisar CDS cuando se reporta falla CDS
rem	
rem Creado por: Jose A. Rodriguez 
rem Fecha creacion: Sep 26 2013
rem 
rem Errores con recuperacion automatica:
rem
rem	NOT_RUN en OUT 	-  Can't rename file
rem			-  file corruption
rem			-  CDS 852: Incomplete read
rem
rem	NOT_RUN		-  5277 timeout
rem			-  1969 No se puede abrir archivo
rem                     -  5312: read error
rem 
rem Errores que requieren escalamiento:
rem
rem	OUT		-  LogWrite (problema en espacio en disco
rem
rem	NOT_RUN		- 5270 Espacio en disco	   
rem 	
rem	
rem Historia de cambios:
rem
rem	1.3.0	14-10-2013
rem				* Se elimino echo on, utilizado para debugging
rem				
rem
rem	1.3.1	14-10-2013
rem				* Se agrego pista d eejecucion de 1er intento de recuperacion automatica
rem				* Se ejecuta el respaldo de archivos out y not_run despues del 1er intento
rem				de recuperacion automatica y es fallida. se procede con el diagnostico
rem
rem	1.3.2	15-10-2013	* Se modifcó validación si el cds esta activo
rem				* Se agrego registro en log para la 1ra recuperacion automatica
rem
rem
rem	1.3.3	16-10-2013	* Se aplica fix para incidente reportado donde el paso P0-1 no existe
rem				  El paso correcto es P1 si hay comunicaciópn con el servidor
rem           
rem **********************************************************************

C:
cd\oper_mercantil\batch\CDS_revisa
set PROG_ID=CDS_revisa 1.3.3
set ofi=%ofi%
set srv=%ofi%SRV1
set ticket=300-123456
set origen=\\%srv%\moaproj\demo\cds
set destino=%ofi%-%ticket%
md %destino%
set LOGF=%destino%\%ofi%.log
@title %PROG_ID% Revision CDS en servidor %srv% en oficina %ofi%
@echo "*** %PROG_ID%  %ofi%-%ticket% " > %LOGF%

:P0
:----
rem Validar comunicacion con servidor
set paso=P0
set npaso=P0-1
set appl=SO
set remote=%srv%
set pdesc="Validando comunicacion con %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@ping -n 2 %srv%
IF %ERRORLEVEL% == 0 GOTO P1
set desc="Sin conexion"
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO SALIR

:P1
:-----
rem Obtener version Version
set paso=P1
set npaso=P2-0
set appl=SO
set remote=%srv%
set pdesc=Obtener version OS en %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=2008
@erase ver.txt /Q
@psexec \\%srv% cmd /C ver > ver.txt
@FINDSTR /I /C:"5." ver.txt 
IF %ERRORLEVEL% == 0 set desc=2003
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:P2-0
:--
rem Intento de recuperacion automatica
set paso=P2-0
set npaso=P2-1
set remote=%srv%
set pdesc="Intento de recuperacion automatica inicial en  %remote% "
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
@erase %origen%\NOT_RUN /Q
@erase %origen%\ddtime /Q
@erase %origen%\cds_log /Q
@erase %origen%\out* /Q
@erase t*.txt
@sc \\%srv% start cds_demo01
@echo
@echo Iniciando CDS - Por favor espere
delay 60
set desc="Recuperacion automatica"
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:P2-1
rem Revisar status CDS
@erase t*.txt /Q
@sc \\%srv% query cds_demo01 > t1.txt
set paso=P2-1
set npaso=P3-0
set appl=MOS
set remote=CDS_demo01
set pdesc=Revisar status %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 set desc=STOPPED
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
IF %desc% == OK GOTO SALIR

:P3-0
:--
:P3-0-1
rem Respaldar out y NOT_RUN
set paso=P3-0-1
set npaso=P1
set appl=CDS
set remote=%srv%
set pdesc="Respaldando archivos out y NOT_RUN en %remote%"
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set desc="Respaldo out NO exitoso"
@copy %origen%\out %destino%\%ofi%_out
IF %ERRORLEVEL% == 0 set desc="Respaldo out exitoso"
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
set desc="Respaldo NOT_RUN NO exitoso"
@copy %origen%\NOT_RUN %ofi%-%ticket%\%ofi%_NOT_RUN
IF %ERRORLEVEL% == 0 set desc="Respaldo NOT_RUN exitoso"
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:P3-0-2
:------
rem Revisar out por NOT_RUN 
@erase t*.txt /Q
set paso=P3-0
set npaso=P3-1
set appl=MOS-CDS
set remote=NOT_RUN
set pdesc=Revisar si existe %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" %origen%\out > t1.txt
IF NOT %ERRORLEVEL% == 0 IF NOT EXIST %origen%\NOT_RUN GOTO P4-0
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:P3-1
:--
rem Revisar out por mensajes con acciones automatizadas para NOT_RUN
@erase t*.txt /Q
set paso=P3-1
set npaso=P3-2
set appl=MOS-CDS
set remote="Can't rename"
set pdesc=Revisar OUT por %remote%
cls

@echo --
@echo -- %pdesc%
@echo --
set codigo=000
@FINDSTR /I /C:%remote% %origen%\out > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P3-2
FOR /F "eol=  tokens=3 delims='"  %%a in (t1.txt) do set desc=%%a
@echo %desc% > t3.txt
@FINDSTR /I /C:".dat" t3.txt
IF %ERRORLEVEL% == 0 GOTO P4-99
@copy %origen%\%desc% %origen%\t_%desc% /Y
@erase %origen%\%desc% /Q
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% borrado | " >> %LOGF%
GOTO P999-0

:P3-2
:--
rem Revisar out por file corruption
@erase t*.txt /Q
set paso=P3-2
set npaso=P3-3
set appl=MOS-CDS
set remote="file corruption"
set pdesc=Revisar OUT por %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
@FINDSTR /I /C:%remote% %origen%\out > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P3-3
@FINDSTR /I /C:"hdr_blk" %origen%\out > t1.txt
FOR /F "eol=  tokens=5 "  %%a in (t1.txt) do set desc=%%a
@echo %desc% > t3.txt
@FINDSTR /I /C:".dat" t3.txt
IF %ERRORLEVEL% == 0 GOTO P4-99
@copy %origen%\%desc% %origen%\t_%desc% /Y
@erase %origen%\%desc% /Q
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% borrado | " >> %LOGF%
GOTO P999-0

:P3-3
:--
rem Revisar NOT_RUN por time-out
@erase t*.txt /Q
set paso=P3-3
set npaso=P3-4
set appl=MOS-CDS
set remote="5277 - Timeout"
set pdesc=Revisar NOT_RUN por %remote%
itle %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"5277 " %origen%\NOT_RUN > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P3-4
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO P999-0

:P3-4
:--
rem Revisar NOT_RUN - out por Read incomplete
@erase t*.txt /Q
set paso=P3-4
set npaso=P3-5
set appl=MOS-CDS
set remote="CDS  852: Incomplete read"
set pdesc=Revisar out por %remote%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:%remote% %origen%\out > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P3-5
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO P999-0

:P3-5
:--
rem Revisar NOT_RUN - CDS 820 Can t open file
@erase t*.txt /Q
set paso=P3-5
set npaso=P3-6
set appl=MOS-CDS
set remote="CDS  820"
set pdesc=Revisar NOT_RUN por %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:%remote% %origen%\NOT_RUN > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P3-6
FOR /F "eol=  tokens=6 delims='"  %%a in (t1.txt) do set desc=%%a
@echo %desc% > t3.txt
@FINDSTR /I /C:".dat" t3.txt
IF %ERRORLEVEL% == 0 GOTO P4-99
@erase %origen%\%desc% /Q
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% borrado | " >> %LOGF%
GOTO P999-0

:P3-6
:--
rem Revisar NOT_RUN - 5270 Problema d eespacio en disco
@erase t*.txt /Q
set paso=P3-6
set npaso=P3-7
set appl=MOS-CDS
set remote="5270:"
set pdesc=Revisar NOT_RUN por %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:%remote% %origen%\NOT_RUN > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P3-7
set escalar=Soporte 1.5-CMIT
FOR /F "eol=  tokens=2 delims='"  %%a in (t1.txt) do set desc=%%a
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% sin espacio en disco - Escalar a %escalar% | " >> %LOGF%
GOTO SALIR

:P3-7
:--
rem Revisar NOT_RUN - 5312 Read error
@erase t*.txt /Q
set paso=P3-7
set npaso=P3-8
set appl=MOS-CDS
set remote="5312:"
set pdesc=Revisar NOT_RUN por %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:%remote% %origen%\NOT_RUN > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P3-8
FOR /F "eol=  tokens=9 delims= "  %%a in (t1.txt) do set desc=%%a
@erase %origen%\%desc%.idx  /Q
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% borrado | " >> %LOGF%
GOTO P999-0

:P3-8
:--
rem Revisar out por file corruption
@erase t*.txt /Q
set paso=P3-8
set npaso=P4-0
set appl=MOS-CDS
set remote=".dat  file corruption"
set pdesc=Revisar out por %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:%remote% %origen%\NOT_RUN > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P4-0
FOR /F "eol=  tokens=8 delims= "  %%a in (t1.txt) do set desc=%%a
@echo %desc% > t3.txt
@FINDSTR /I /C:".dat" t3.txt
IF %ERRORLEVEL% == 0 GOTO P4-99
@erase %origen%\%desc%  /Q
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% borrado | " >> %LOGF%
GOTO P999-0

:P4-0
:--
rem Errores P4 son errores en OUT sin NOT_RUN identificado en el 
rem Revisar OUT por falta de espacio en disco
@erase t*.txt /Q
set paso=P4-0
set npaso=SALIR
set appl=MOS-CDS
set remote="LogWrite"
set pdesc=Revisar OUT por %remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set escalar=Soporte 1.5-CMIT
set desc=OK
@FINDSTR /I /C:%remote% %origen%\out > t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO P4-99
set desc="Escalar a %escalar% - Problema espacio en disco"
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO SALIR

:P4-99
:--
rem Out con error desconocido  - Escalar a 6314
@erase t*.txt /Q
set paso=P4-99
set npaso=SALIR
set appl=MOS-CDS
set remote=error desconocido
set pdesc=Revisar OUT por %remote%
@@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set escalar=6314
set desc="Escalar a %escalar% - Error desconocido"
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO SALIR

:P999-0
:------
rem Recuperacion automatica
set paso=P999-0
set npaso=P999-1
set appl=MOS-CDS
set remote=Borrado de archivos
set pdesc=%remote%
@title %PROG_ID% %pdesc%
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc="Borrado de archivos"
@erase %origen%\NOT_RUN /Q
@erase %origen%\ddtime /Q
IF NOT %ERRORLEVEL% == 0 set codigo=001
@erase %origen%\cds_log /Q
IF NOT %ERRORLEVEL% == 0 set codigo=001
@erase %origen%\out* /Q
IF NOT %ERRORLEVEL% == 0 set codigo=001
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:P999-1
@erase t*.txt
set paso=P999-1
set npaso=SALIR
set appl=MOS-CDS
set remote=cds_demo01
set pdesc=Activar servicio %remote%
set state=*
set desc=OK
set escalar=6314
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
@sc \\%srv% start cds_demo01
delay 60
@sc \\%srv% query cds_demo01 > t1.txt
@FINDSTR /I /C:"RUNNING" t1.txt 
IF %ERRORLEVEL% == 0 SET state=RUNNING
@FINDSTR /I /C:"STOPPED" t1.txt 
IF %ERRORLEVEL% == 0 SET state=STOPPED
IF %state% == STOPPED set desc="%state%-Escalar a %escalar%"
@FINDSTR /B /I /C:"Completed table opens" %origen%\out
IF NOT %ERRORLEVEL% == 0 set desc="%state%-Escalar a %escalar%"  
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:SALIR
:-----
set paso=FIN
set desc=OK
set desc=*
@FINDSTR /I /C:"escalar" %LOGF%
IF %ERRORLEVEL% == 0 set desc="Escalar a %escalar%"
set pdesc="Fin Revision CDS en servidor %srv% ticket %ticket%"
echo
@echo ---------------
@echo %pdesc% -- %desc%
@echo ---------------
set appl=MOS
set codigo=000
@now.exe " %srv% | %ticket% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO main

:eleccion2
CLs
Echo off

Echo **********************************************
Echo  Editar Log
echo **********************************************

Pause

type \\%ofi%srv1\d$\moaproj\demo\cds\out

Pause
GOTO main

:eleccion3
cls
Echo off
Echo **********************************************
Echo  Revisar Servicio de CDS 
echo **********************************************



sc \\%ofi%srv1 interrogate  CDS_demo01

Pause

Echo **********************************************
Echo  Editar Log
echo **********************************************




type \\%ofi%srv1\d$\moaproj\demo\cds\out

Pause
GOTO main

:eleccion4
cls
Echo off

Echo **********************************************
Echo  Editar archivo NOT_RUN
echo **********************************************


type \\%ofi%srv1\d$\moaproj\demo\cds\Not_run

Pause
GOTO main

:eleccion5
CLs
Echo off

Echo **********************************************
Echo  Revisar conexión CDS
echo **********************************************

Pause

psexec \\%ofi%srv1 cdsstat

Pause
GOTO main

:eleccion6
cls
Echo off
Echo **********************************************
Echo  Activar Servicio de CDS 
echo **********************************************



sc \\%ofi%srv1 Start CDS_demo01

Pause

cls
Echo off
Echo **********************************************
Echo  Revisar Servicio de CDS 
echo **********************************************

sc \\%ofi%srv1 interrogate  CDS_demo01

Pause


cls

Echo off

Echo **********************************************
Echo  Editar Log
echo **********************************************


type \\%ofi%srv1\d$\moaproj\demo\cds\out

Pause
GOTO main



:salir1
ECHO Gracias por usar el programa, que tengas un buen dia.
ECHO Presione cualquier tecla para finalizar el menu de comandos CDS.
Pause>nul