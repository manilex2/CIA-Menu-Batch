CLs
Echo off

Echo **********************************************
Echo  Revisar conexión CDS
echo **********************************************

Pause

psexec \\%1srv1 cdsstat

Pause
