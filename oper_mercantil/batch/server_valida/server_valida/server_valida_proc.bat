@echo Copiando SEG a %1-%2
c:
cd\oper_mercantil\batch\server_valida
set PROG_ID=server_valida_proc
set LOGF=%PROG_ID%.log
set MSG_HEADER=%PROG_ID% "|" %USERDOMAIN% %USERNAME% "|" %COMPUTERNAME% "|"
now %PROG_ID% > %LOGF%

:PASO1

FOR /F "eol=  tokens=1-3 delims= " %%a in (lista_2008.txt) do call server_valida.bat  %%a %%b %%c  

:SALIR

