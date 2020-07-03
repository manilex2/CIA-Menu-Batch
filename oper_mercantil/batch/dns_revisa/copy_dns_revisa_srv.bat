@title Copy dns_revisa a %1
@echo off

C:
cd\oper_mercantil\batch\dns_revisa
set LOGF=copy_dns_revisa_srv.log
set conx=N
set copy=N
set log=N
set srv=%1SRV1
set ofi=%1
set destino=\\%srv%\c$\temp

:REV-CONX
:--------
@ping -n 3 %srv%
IF NOT %ERRORLEVEL% == 0 GOTO SALIR

:COPY-DNS
:--------
set conx=S
@md %destino%
@md srv\%ofi%
@copy dns_revisa_srv.bat %destino%\* /Y  
IF NOT %ERRORLEVEL% == 0 GOTO SALIR
set copy=S

:REV-DNS
:-------
@psexec \\%srv% cmd /C c:\temp\dns_revisa_srv.bat
@copy %destino%\%srv%*	srv\%ofi%\* /Y 
IF %ERRORLEVEL% == 0 set log=S


:SALIR
@now "| %srv% | conx:%conx% | copy:%copy% | log:%log% " >> %LOGF%
