@title Copy diccionario a %1
@echo off

C:
cd\oper_mercantil\batch\copy_dicc
set LOGF=copy_dicc.log
set conx=N
set copy=N
set wks=%1
set ofi=%wks:~0,4%
set srv=%ofi%SRV1

:REV-CONX
:--------
@ping -n 3 %wks%
IF NOT %ERRORLEVEL% == 0 GOTO SALIR

:COPY-DICCIONARIO
:----------------
@title Copiando diccionarios a %wks%
cls
@echo ---
@echo Copiando diccionario a %wks%
@echo ---
set conx=S
@taskkill /S %wks%  /IM rt.exe /F 
@copy \\%srv%\moaproj\demo\ddobj* \\%wks%\c$\moaproj\demo\* /Y
IF %ERRORLEVEL% == 0 @copy \\%srv%\moaproj\demo\ddnotes* \\%wks%\c$\moaproj\demo\* /Y
IF NOT %ERRORLEVEL% == 0 GOTO ERROR
set copy=S
cls
@echo ---
@echo Copia de diccionario a estacion %wks% EXITOSA
@echo ---
GOTO SALIR

:ERROR
:-----
cls
@echo Copia de diccionario a estacion %wks% NO EXITOSA. Escalar a Soporte 1.5 CMIT
@echo ---

:SALIR
:-----
@now "| %wks% | conx:%conx% | copy:%copy% | " >> %LOGF%
