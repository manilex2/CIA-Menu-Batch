cls
@echo off
rem *********************************************************************
rem Archivo: server_valida.bat
rem
rem Version 010000 Agosto 2013
rem
rem  Descripcion: 
rem 	Utilizado para validar configuración de servidores 2008
rem	
rem Creado por: Jose A. Rodriguez 
rem Fecha creacion: Ago 2013
rem 
rem Historia de cambios:
rem
rem             Solo se muestran popups al ocurrir un error 
rem **********************************************************************

set PROG_ID=server_valida
set ofi=%1
set srv=%1SRV1
set nombre=%2
set LOGF=LOG\%ofi%.log
@title Validacion - configuracion servidor %srv% - IP: %ip% en oficina %ofi%-%nombre%
set paso=0 

:QUERY_IP
:--------


:F0-1-1
:-----
erase t*.txt /Q
set paso=F0-1-1
set npaso=F0-1-2
set appl=SO
set remote=%srv%
set pdesc="Validando comunicacion con %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@ping -n 1 %srv%
IF NOT %ERRORLEVEL% == 0 GOTO E-098
ping -n 1 %srv% > t1.txt
FINDSTR /I /C:"Reply from" t1.txt > t2.txt
FOR /F "eol=  tokens=3 "  %%a in (t2.txt) do echo %%a > t3.txt
FOR /F "eol=  tokens=1 delims=:"  %%a in (t3.txt) do set ip=%%a
@echo "*** %PROG_ID%  Validacion - configuracion servidor %srv% - IP: %ip% en oficina %ofi%-%nombre% " > %LOGF%
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F0-1-2
:-----
set paso=F0-1-2
set npaso=F1-1-1
set appl=SO
set remote=2008
set pdesc="Validando version OS %remote% en %srv%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@title %pdesc%
@psexec \\%srv% cmd /C ver > ver.txt
@FINDSTR /I /C:"6." ver.txt 
IF %ERRORLEVEL% == 0 GOTO F0-1-2-OK
set remote=2003
@FINDSTR /I /C:"5." ver.txt 
IF %ERRORLEVEL% == 0 GOTO E-099
set remote=????
GOTO E-099
:F0-1-2-OK
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:PASO_1
:Validar recursos compartidos
:------------------------------- 

:F1-1-1
:-----
@erase t1.txt /Q
@net view \\%srv% > t1.txt
set paso=F1-1-1
set npaso=F1-1-2
set appl=SO
set remote=MOAPROJ
set pdesc="Validando Recurso-%remote%"
cls

@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-1-2
:-----
set paso=F1-1-2
set npaso=F1-1-3
set appl=SO
set remote=BMLS100
set pdesc="Validando Recurso-%remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-1-3
:-----
set paso=F1-1-3
set npaso=F1-1-4
set appl=SO
set remote=CEMP_backup
set pdesc="Validando Recurso-%remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-1-4
:-----
set paso=F1-1-4
set npaso=F1-1-5
set appl=SO
set remote=buzon
set pdesc="Validando Recurso-%remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-1-5
:-----
set paso=F1-1-5
set npaso=F1-1-6
set appl=SO
set remote=envia
set pdesc="Validando Recurso-%remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-1-6
:-----
set paso=F1-1-6
set npaso=F1-1-7
set appl=SO
set remote=oficina_mercantil
set pdesc="Validando Recurso-%remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-1-7
set paso=F1-1-7
set npaso=F1-1-8
set appl=SO
set remote=log
set pdesc="Validando Recurso-%remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-1-8
set paso=F1-1-8
set npaso=F1-2-1
set appl=SO
set remote=Imagen
set pdesc="Validando Recurso-%remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-100
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:PASO_2
:Validar archivos / configuracion MOSAIC
: -------------------------------------- 

:F1-2-1
:-----
set paso=F1-2-1
set npaso=F1-2-2
set appl=MOSAIC
set remote=
set pdesc="Validando si existe carpeta CDS"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
IF NOT EXIST \\%srv%\moaproj\demo\cds\tables.dat GOTO E-101
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-2-2
:-----
set paso=F1-2-2
set npaso=F1-2-3
set appl=MOSAIC
set remote=ddproj.ini
set pdesc="Validando %ofi% en archivo %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%ofi%" \\%srv%\moaproj\demo\%remote% 
IF NOT %ERRORLEVEL% == 0 GOTO E-102
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-2-3
:-----
set paso=F1-2-3
set npaso=F1-2-4
set appl=MOSAIC
set remote=ddproj.ini.prod
set pdesc="Validando %ofi% en archivo %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%ofi%" \\%srv%\moaproj\demo\ddproj.ini.prod 
IF NOT %ERRORLEVEL% == 0 GOTO E-102
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-2-4
:-----
set paso=F1-2-4
set npaso=F1-2-5
set appl=MOSAIC
set remote= DDPROJ.ini.cont
set pdesc="Validando %ofi% en archivo %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%ofi%" \\%srv%\moaproj\demo\ddproj.ini.cont 
IF NOT %ERRORLEVEL% == 0 GOTO E-102
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-2-5
:-----
set paso=F1-2-5
set npaso=F1-3-1
set appl=MOSAIC
set remote=CDS_demo01
set pdesc="Validando %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@erase t1.txt /Q
@sc \\%srv% query CDS_demo01 > t1.txt
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-103
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:PASO_3
:Validar archivo CTSParameters de lectora
:----------------------------------------
 
:F1-3-1
:-----
set destino=\\%srv%\oficina_mercantil\soft\drivers_y_aplicaciones\Ls100\config
@erase t1.txt /Q
set paso=F1-3-1
set npaso=F1-3-2
set appl=Lectora
set remote=CTSParameters.ini
set pdesc="Validando %ofi% en archivo %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%ofi%" %destino%\%remote%
IF NOT %ERRORLEVEL% == 0 GOTO E-105
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-3-2
:----
@erase t1.txt /Q
set paso=F1-3-2
set npaso=F1-3-3
set appl=Lectora
set remote=CTSParameters.ini.prod
set pdesc="Validando %ofi% en archivo %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%ofi%" %destino%\%remote%
IF NOT %ERRORLEVEL% == 0 GOTO E-105
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F1-3-3
:-----
e@rase t1.txt /Q
set paso=F1-3-3
set npaso=F1-4-1
set appl=Lectora
set remote=CTSParameters.ini.cont
set pdesc="Validando %ofi% en archivo %Remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%ofi%" %destino%\%remote%
IF NOT %ERRORLEVEL% == 0 GOTO E-105
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Configuracion agendados
:-----------------------

:F1-4-1
:-----
@erase task.txt /Q 
@psexec \\%srv% cmd /C schtasks > task.txt
@title Validacion - configuracion servidor %srv% en oficina %ofi% 
set paso=F1-4-1
set npaso=F1-4-2
set appl=SO
set remote=cce_cont_cds
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-2
:-----
set paso=F1-4-2
set npaso=F1-4-3
set appl=SO
set remote=cce_cont_back
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-3
:-----
set paso=F1-4-3
set npaso=F1-4-4
set appl=SO
set remote=MOS_MANT_CDS
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-4
:-----
set paso=F1-4-4
set npaso=F1-4-5
set appl=SO
set remote=MOS_MANT_KILL
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-5
:-----
set paso=F1-4-5
set npaso=F1-4-6
set appl=SO
set remote=MOS_COMIS
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-6
:-----
set paso=F1-4-6
set npaso=F1-4-7
set appl=SO
set remote=MOS_COMIS_1
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-7
:-----
set paso=F1-4-7
set npaso=F1-4-8
set appl=SO
set remote=MOS_DEPO
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-8
:-----
set paso=F1-4-8
set npaso=F1-4-9
set appl=SO
set remote=MOS_RESP_CDS
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-8
:-----
set paso=F1-4-8
set npaso=F1-4-9
set appl=SO
set remote=MOS_RESP_CDS
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-9
:-----
set paso=F1-4-9
set npaso=F1-4-10
set appl=SO
set remote=MOS_SERVICOM
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-10
:-----
set paso=F1-4-10
set npaso=F1-4-11
set appl=SO
set remote=MOS_CHQ_GER
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-11
:-----
set paso=F1-4-11
set npaso=F1-4-12
set appl=SO
set remote=MOS_QL_PERFIL
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-12
:-----
set paso=F1-4-12
set npaso=F1-4-13
set appl=SO
set remote=RESPALDO_HOY-1
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-13
:-----
set paso=F1-4-13
set npaso=F1-4-14
set appl=SO
set remote=RESPALDO_HALL
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-14
:-----
set paso=F1-4-14
set npaso=F1-4-15
set appl=SO
set remote=SEG_FTP
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F1-4-15
:-----
set paso=F1-4-15
set npaso=F1-5-1
set appl=SO
set remote=DEL_CEMP
set pdesc="Validando tarea %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" task.txt
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Validar BIOSHOTOFFICESERVICE en archivo hosts
:-----------------------------------------------
 
:F1-5-1
:-----
set etc=\\%srv%\c$\windows\system32\drivers\etc
@erase t*.txt /Q
set paso=F1-5-1
set npaso=F1-5-2
set appl=BIOSHOT
set remote=BIOSHOTOFFICESERVICE
set pdesc="Validando %remote% en archivo hosts"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"%remote%" %etc%\hosts > t1.txt
@FINDSTR /I /C:"#" t1.txt
IF %ERRORLEVEL% == 0 GOTO E-106
@FINDSTR /I /C:"%ip%" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-106
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Validar servicio BioShotOfficeService
:-----------------------------------
 
:F1-5-2
:-----
@erase t1.txt /Q
set paso=F1-5-2
set npaso=F1-6-1
set appl=BIOSHOT
set remote=BioShotOfficeServiceCls
set pdesc="Validando servicio %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --


set codigo=000
set desc=OK
@sc \\%srv% query %remote% > t1.txt 
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-107
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Validad flag 218 - no grabar archivos dat en wks
:----------------------------------------------------------------
 
:F1-6-1
:-----
@erase t1.txt /Q
set paso=F1-6-1
set npaso=F1-7-1
set appl=MOSAIC
set remote=
set disco=*
set pdesc="Revisar activacion flag 218 - No grabar dat en C de wks  con win7"
rem Validar que posea ql instalado
IF EXIST c:\moa\bin\ql.exe IF EXIST c:\moaproj\demo\ddproj.ini set disco=C:
IF EXIST d:\moa\bin\ql.exe IF EXIST d:\moaproj\demo\ddproj.ini set disco=D:
IF %disco% == * GOTO F1-6-1-A
cls
@echo -- 
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
copy ddproj.txt ddproj.ini
@echo CDS_PRIMARY_NP=%srv% > junk.txt
@attrib -r d:\moaproj\demo\ddproj.ini
copy ddproj.txt + junk.txt d:\moaproj\demo\ddproj.ini /Y
@ql -ndemo < t228_218.ql
@FINDSTR /B /I /C:"1 record" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-108
:F1-6-1-A
IF %disco% == * set desc=NO APLICA
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:VALIDAR VARIOS SERVICIOS
:----------------------
 

:Servicio JBossWeb
:-----------------
 
:F1-7-1
:-----
@erase t1.txt /Q
set paso=F1-7-1
set npaso=F1-7-2
set appl=JBOSS
set remote=JBossWeb
set pdesc="Validar servicio %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@sc \\%srv% query %remote% > t1.txt
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-107
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Servicio MOSAIC MSW
:-------------------
 
:F1-7-2
:-----
@erase t1.txt /Q
set paso=F1-7-2
set npaso=F1-7-3
set appl=MOSAIC
set remote="MOSAIC MSW"
set pdesc="Validar servicio %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@sc \\%srv% query %remote% > t1.txt
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-107
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Servicio Mosaicproxy
:--------------------
 
:F1-7-3
:-----
@erase t1.txt /Q
set paso=F1-7-3
set npaso=F1-7-4
set appl=MosaicProxy
set remote=MosaicProxy
set pdesc="Validar servicio %remote% instalado"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@sc \\%srv% query %remote% > t1.txt
@FINDSTR /I /C:"STATE" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-107
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Servicio MosaicSpiderSrv
:------------------------
 
:F1-7-4
:-----
@erase t1.txt /Q
set paso=F1-7-4
set npaso=F1-7-5
set appl=MosaicSpider
set remote=MosaicSpiderSrv
set pdesc="Validar servicio %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@sc \\%srv% query %remote% > t1.txt
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-107
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:Servicio HallService
:--------------------
 
:F1-7-5
:-----
@erase t1.txt /Q
set paso=F1-7-5
set npaso=F2-1-1
set appl=HALL
set remote=HallService
set pdesc="Validar servicio %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@sc \\%srv% query %remote% > t1.txt
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-107
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:VALIDAR PASOS FASE II 
:---------------------

:Validar Configuracion BioShot
:-----------------------------

:F2-1-1
:------
@erase t1.txt /Q 
set destino=set destino=\\%srv%\c$\"Program files\Bioshot\Bioshot Office Service"\BioShotOfficeService.exe.config
set paso=F2-1-1
set npaso=F2-2-1
set appl=BIOSHOT
set remote=BioShotOfficeService.exe.config
set pdesc="Validando fecha en archivo %remote% "
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
dir %destino% > t1.txt 
@FINDSTR /I /C:"7:" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-110
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:F2-2-1
:-----
@erase t1.txt /Q
set destino=\\%srv%\oficina_mercantil\soft\drivers_y_aplicaciones\LS100\config\CTSParameters.ini
set paso=F2-2-1
set npaso=F2-3-1
set appl=Lectora
set remote="Imagen2"
set pdesc="Validar que %remote% no exista en CTSParameters.ini"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"Imagen2" %destino%
IF %ERRORLEVEL% == 0 GOTO E-111
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:F2-3-1
:-----
set destino=\\%srv%\d$\oper_mercantil\batch\CEMP
set paso=F2-3-1
set npaso=F2-4-1
set appl=SO
set remote=DEL_CEMP
set pdesc="Validando archivo %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@FINDSTR /I /C:"FORFILES" %destino%\%remote%.bat
IF NOT %ERRORLEVEL% == 0  GOTO E-109
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%

:Servicio BioShot Status Transfer Service
:----------------------------------------
 
:F2-4-1
:------
@erase t1.txt /Q
set paso=F2-4-1
set npaso=SALIR
set appl=BIOSHOT
set remote="BioShot Status Transfer Service"
set pdesc="Validar servicio %remote%"
cls
@echo --
@echo -- %pdesc%
@echo --
set codigo=000
set desc=OK
@sc \\%srv% query %remote% > t1.txt
@FINDSTR /I /C:"RUNNING" t1.txt
IF NOT %ERRORLEVEL% == 0 GOTO E-107
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
goto %npaso%


:MANEJO DE ERRORES
:-----------------

:E-098
:-----
set codigo=E-098
set desc="Sin conexion"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO SALIR

:E-099
:-----
set codigo=E-099
set desc="Version OS NO VALIDA - %remote%"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-100
:-----
set codigo=E-100
set desc="No compartido"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-101
:-----
set codigo=E-101
set desc="No existe. Debe copiarla"
@@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-102
:-----
set codigo=E-102
set desc="%remote% NO valido - Copiar carpeta d:\moaproj\demo del servidor origen"
@echo ** 
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-103
:-----
set codigo=E-103
set desc="Problemas con servicio CDS_demo01"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-104
:-----
set codigo=E-104
set desc="Servicio CDS_demo1 NO iniciado. Llamar a servicedesk"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-105
:-----
set codigo=E-105
set desc="%remote% NO fue actualizado con %srv%. Reportar"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-106
:-----
set codigo=E-106
set desc="BIOSHOTOFFICESERVICE sin configurar en archivo hosts"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%


:E-107
:-----
set codigo=E-107
set desc="Servicio %remote% NO fue iniciado. Reportar"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%


:E-108
:-----
set codigo=E-108
set desc="Flag 218 no esta activo. Reportar"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-109
:-----
set codigo=E-109
set desc="Tarea %remote% no existe. Reportar"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-110
:-----
set codigo=E-110
set desc="Archivo %remote% no actualizado . Reportar"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%

:E-111
:-----
set codigo=E-111
set desc="%remote% presente en CTSParameters.ini - Cheques BM sin capturar por el sistema CEMP. Reportar"
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
GOTO %npaso%



:SALIR
:-----
set appl=*
set paso=FIN
set pdesc="FIN Configuracion"
set codigo=000
@erase t1.txt /Q

set desc=OK 
@FINDSTR /I /C:"| E-" %LOGF%
IF NOT %ERRORLEVEL% == 0 GOTO SALIR_MSG 
set codigo=999
set desc="Con errores revisar archivo %LOGF%"

:SALIR_MSG
:---------
cls
@echo ***************
@echo Validacion Ofic. %ofi% %nombre% finalizo - %desc% 
@echo ***************
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
