CLs
Echo off

Echo **********************************************
Echo  Revisar conexi�n CDS
echo **********************************************

Pause

psexec \\%1srv1 cdsstat

Pause
