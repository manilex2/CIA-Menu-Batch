cls
@echo off
rem *********************************************************************
rem Archivo: dns_revisa.bat
rem
rem  Descripcion: 
rem 	Utilizado para revisar / actualizar dns en servidores 
rem	
rem Creado por: Jose A. Rodriguez 
rem Fecha creacion: Oct 2013
rem 
rem Historia de cambios:
rem
rem	13-11-2013	Version 0101
rem			Se agrego para revisar / actualizar local Area Connection 1
rem
rem
rem	16-10-2013	Version 0100
rem			Revisa y actualiza dns a los siguientes DNS:
rem			10.5.10.127
rem			10.5.10.128
rem			10.5.10.129
rem			10.1.1.84
rem
rem               
rem **********************************************************************
c:
cd\temp
set PROG_ID=dns_revisa_srv
set ver=0101
set srv=%COMPUTERNAME%
set LOGF=%srv%.log
set ip=0.0.0.0
@title Validacion - actualizar dns en equipo %srv%
set paso=0
set n=0 

:QUERY_IP
:--------
set paso=QUERY-IP
@erase t*.txt /Q
set appl=SO
set remote=%srv%
set pdesc="Validando comunicacion con %remote%"
set codigo=0000
set desc=S
cls
@echo --
@echo -- %pdesc%
@echo --
@ipconfig  > t1.txt
IF NOT %ERRORLEVEL% == 0 set desc=N
@FINDSTR /I /C:"IPv4" t1.txt > t2.txt
FOR /F "eol=  tokens=14"  %%a in (t2.txt) do set ip=%%a
@echo "*** %PROG_ID%  Validacion - actualizacion dns en equipo %srv% - %ip%  " > %LOGF%
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %desc%  " >> %LOGF%
set tadaptador=Local Area Connection
IF %desc% == N GOTO SALIR

:QUERY-OS
:--------
set paso=QUERY-OS
set appl=SO
set pdesc="Validando version OS en %srv%"
set codigo=0000
cls
@echo --
@echo -- %pdesc%
@echo --
@title %pdesc%
@ver > ver.txt
@FINDSTR /I /C:"6." ver.txt 
IF %ERRORLEVEL% == 0 set desc=2008
@FINDSTR /I /C:"5." ver.txt 
IF %ERRORLEVEL% == 0 set desc=2003
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %ver% | " >> %LOGF%


:ACT-DNS
:-------
set ver=%desc% 
set paso=ACT-DNS
set appl=SO
set pdesc="Actualizando DNS en %srv% - %ip% "
set codigo=0000
cls
@echo --
@echo -- %pdesc%
@echo --
@title %pdesc%
IF %ver% == 2008 GOTO ACT-DNS-2008

:ACT-DNS-2003
:------------
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
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %ver% - %desc% | " >> %LOGF%
@ipconfig /all > %srv%_dns.txt
IF %n% == 1  GOTO SALIR
set n=1
set tadaptador=Local Area Connection %n%
GOTO ACT-DNS

:ACT-DNS-2008
:------------
netsh interface ip set dnsservers "%tadaptador%" dhcp
set n0=%ERRORLEVEL%
netsh interface ip set dnsservers "%tadaptador%" static 10.5.10.127  primary
set n1=%ERRORLEVEL%
netsh interface ip add dnsservers "%tadaptador%" 10.5.10.128 index=2
set n2=%ERRORLEVEL%
netsh interface ip add dnsservers "%tadaptador%" 10.5.10.129 index=3
set n3=%ERRORLEVEL%
netsh interface ip add dnsservers "%tadaptador%" 10.1.1.84 index=4
set n4=%ERRORLEVEL%
set desc=%n0%-%n1%-%n2%-%n3%-%n4%
@now.exe " %srv% | Appl:%appl% | Paso:%paso%-%pdesc% | %codigo% | %ver% - %desc% | " >> %LOGF%
@ipconfig /all > %srv%_dns.txt
IF %n% == 1 GOTO SALIR
set n=1
set tadaptador=Local Area Connection %n%
GOTO ACT-DNS

:SALIR
:-----
