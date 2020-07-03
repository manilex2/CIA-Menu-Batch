cls
Echo off
Echo **********************************************
Echo  Activar Servicio de CDS 
echo **********************************************



sc \\%1srv1 Start CDS_demo01

Pause

cls
Echo off
Echo **********************************************
Echo  Revisar Servicio de CDS 
echo **********************************************

sc \\%1srv1 interrogate  CDS_demo01

Pause


cls

Echo off

Echo **********************************************
Echo  Editar Log
echo **********************************************


type \\%1srv1\d$\moaproj\demo\cds\out

Pause

