@title actualizando rt1 en %1 
@echo on
c:
cd\oper_mercantil\batch\upd_rt1

@set PROG_ID=upd_rt1_proc
@set LOGF=%PROG_ID%.log
@set wks=%1
@set conx=N
@set upd=N
@set OA=N
@set msg=NO EXITOSA
@set destino=\\%wks%\c$\moa\bin
@set destino1=\\%wks%\c$\Users\Public\Desktop


@ping -n 2 %wks%
IF NOT %ERRORLEVEL% == 0 GOTO SALIR
@set conx=S

:INICIO
@erase %destino1%\"MOSAIC OA".lnk /F /Q
IF %ERRORLEVEL% == 0 set OA=S
@copy dns.txt		%destino%\* /Y
@copy rtesv.dll		%destino%\* /Y
@copy rt1.bat  		%destino%\* /Y
@copy mosaic.lnk	%destino1%\* /Y
IF NOT %ERRORLEVEL% == 0 GOTO SALIR
@set msg=EXITOSA
@set upd=S

:SALIR
@now.exe " %wks% | conx:%conx% | actualizar rt1:%upd% | OA:%OA%" >> %LOGF%

rem @cls
@echo ***
@echo Estatus Actualización de rt1 en %wks%: %msg%
@echo ***
