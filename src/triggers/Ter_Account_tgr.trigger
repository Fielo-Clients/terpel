/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez M. (WRM)
Proyecto: Terpel
Descripción: Trigger objeto Cuentas. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha	   Autor				   Descripción
------ ---------- ---------------------------------------------------------------
1.0 23-01-2017  Walter Rodríguez (WR)  Creación trigger.
***********************************************************************************/
trigger Ter_Account_tgr on Account (after delete, after insert, after update, before delete, before insert, before update) 
{
	Ter_Account_cls objAcc = new Ter_Account_cls();
	
	if(Trigger.isBefore)
	{
		if(Trigger.isUpdate)
		{
			objAcc.validaCambioEstado(Trigger.old,Trigger.new);
		}
	}
}