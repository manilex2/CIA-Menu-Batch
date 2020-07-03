cls
@echo off
rem *********************************************************************
rem Archivo: dns_revisa.bat
rem
rem  Descripcion: 
rem 	Utilizado para revisar / actualizar dns en estaciones de trabajo 
rem	
rem Creado por: Jose A. Rodriguez 
rem Fecha creacion: Oct 2013
rem 
rem Historia de cambios:
rem
rem	16-10-2013	Version 010000
rem			Revisa y actualiza dns a lso siguientes BMADOFIC01               
rem **********************************************************************
c:
cd\temp
chcp 852
set PROG_ID=dns_valida
set ver=010000
set wks=%COMPUTERNAME%
set LOGF=%wks%.log
set ip=0.0.0.0
@title Validacion - actualizar dns en equipo %wks%
set paso=0 

:QUERY_IP
:--------
set paso=QUERY-IP
erase t*.txt /Q
set appl=SO
set remote=%wks%
set pdesc="Validando comunicacion con %remote%"
set codigo=0000
set desc=S
cls
@echo --
@echo -- %pdesc%
@echo --
@ipconfig  > t1.txt
IF NOT %ERRORLEVEL% == 0 set desc=N
FINDSTR /I /C:"Direcci¢n IPV4" t1.txt > t2.txt
FOR /F "eol=  tokens=14"  %%a in (t2.txt) do set ip=%%a
@echo "*** %PROG_ID%  Validacion - actualizacion dns en equipo %wks% - %ip%  " > %LOGF%
@now.exe " %wks% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc%  " >> %LOGF%
FINDSTR /I /C:"Adaptador de Ethernet" t1.txt > t3.txt
FOR /F "eol=  tokens=1 delims=:"  %%a in (t3.txt) do set temp=%%a
@echo %temp% > t4.txt
set tadaptador=Conexi¢n de  rea local
IF %desc% == N GOTO SALIR

:QUERY OS
:--------
set paso=QUERY-OS
set appl=SO
set pdesc="Validando version OS en %wks%"
set codigo=0000
cls
@echo --
@echo -- %pdesc%
@echo --
@title %pdesc%
@ver > ver.txt
@FINDSTR /I /C:"6." ver.txt 
IF %ERRORLEVEL% == 0 set desc=Win7
set remote=XP
@FINDSTR /I /C:"5." ver.txt 
IF %ERRORLEVEL% == 0 set desc=XP
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%


:ACT_DNS
:-------
set ver=%desc% 
set paso=ACT-DNS
set appl=SO
set pdesc="Actualizando DNS en %wks% - %ip% "
set codigo=0000
cls
@echo --
@echo -- %pdesc%
@echo --
@title %pdesc%
IF %ver% == Win7 GOTO ACT-DNS-W7

:ACT-DNS-XP
netsh  interface ip set dns "%tadaptador%" dhcp
set n0=%ERRORLEVEL%
netsh  interface ip set dns "%tadaptador%" static 10.5.10.127  primary
set n1=%ERRORLEVEL%
netsh  interface ip add dns "%tadaptador%" 10.5.10.128 index=2
set n2=%ERRORLEVEL%
netsh  interface ip add dns "%tadaptador%" 10.5.10.129 index=3
set n3=%ERRORLEVEL%
netsh  interface ip add dns "%tadaptador%" 10.1.1.84 	index=4
set n4=%ERRORLEVEL%
set desc=%n0%-%n1%-%n2%-%n3%-%n4%
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
@ipconfig /all > %wks%_dns.txt
GOTO SALIR

:ACT-DNS-W7
netsh interface ipv4 set dnsservers "%tadaptador%" dhcp
set n0=%ERRORLEVEL%
netsh interface ipv4 set dnsservers "%tadaptador%" static 10.5.10.127  primary
set n1=%ERRORLEVEL%
netsh interface ipv4 add dnsservers "%tadaptador%" 10.5.10.128 index=2
set n2=%ERRORLEVEL%
netsh interface ipv4 add dnsservers "%tadaptador%" 10.5.10.129 index=3
set n3=%ERRORLEVEL%
netsh interface ipv4 add dnsservers "%tadaptador%" 10.1.1.84 index=4
set n4=%ERRORLEVEL%
set desc=%n0%-%n1%-%n2%-%n3%-%n4%
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc% | " >> %LOGF%
@ipconfig /all > %wks%_dns.txt

:SALIR
