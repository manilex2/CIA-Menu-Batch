cls
Echo off
Echo **********************************************
Echo  conectar a servidor %1srv1 
echo **********************************************


net use j: /delete

net use j: \\%1srv1\d$

j:

cd moaproj\demo\cds

Pause

cls
Echo off
Echo **********************************************
Echo  Revisar conexión servidor %1srv1
echo **********************************************

net use j: 


Pause

