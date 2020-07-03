@title Copiando RT1 %1 %2
@echo off
c:
cd\oper_mercantil\batch\Versiones_rt1\v_0804

set PROG_ID=copy_rt1_proc
set wks=%1
set conx=N
set rt1=N
set destino=\\%wks%\c$\moa\bin
set destino1=\\%wks%\c$\mproxy
set task=N

@ping -n 2 %wks%
IF NOT %ERRORLEVEL% == 0 GOTO SALIR
set conx=S

:INICIO
rem rename %destino%\rt1.bat yrt1.bat
IF %2 == XP (@copy rt1_xp.bat 	%destino%\rt1.bat /Y) ELSE @copy rt1_w7.bat 	%destino%\rt1.bat /Y
@copy *.ini 		%destino1%\* /Y
IF NOT %ERRORLEVEL% == 0 GOTO SALIR
set rt1=S


:SALIR
set m0=" %wks% | version rt1: %1 | conx: %conx% | Copy RT1: %rt1% | %2 %3" 
now.exe %MSG_HEADER% %m0% >> %PROG_ID%.log

:SALIDA