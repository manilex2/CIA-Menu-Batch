@title Copy dns_revisa a %1
@echo off
@chcp 852

C:
cd\oper_mercantil\batch\dns_revisa
set LOGF=copy_dns_revisa_wks.log
set conx=N
set copy=N
set log=N
set srv=%1SRV1
set wks=%1
set destino=\\%wks%\c$\temp

:REV-CONX
:--------
@ping -n 3 %wks%
IF NOT %ERRORLEVEL% == 0 GOTO SALIR

:COPY-DNS
:--------
set conx=S
@md %destino%
@copy dns_revisa_wks.bat %destino%\* /Y  
IF NOT %ERRORLEVEL% == 0 GOTO SALIR
set copy=S

:REV-DNS
:-------
@psexec \\%wks% cmd /C c:\temp\dns_revisa_wks.bat
@copy %destino%\%wks%* 	wks\* /Y 
IF %ERRORLEVEL% == 0 set log=S


:SALIR
@now "| %wks% | conx:%conx% | copy:%copy% | log:%log% " >> %LOGF%
