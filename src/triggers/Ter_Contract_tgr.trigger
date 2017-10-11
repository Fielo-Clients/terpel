/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez M. (WRM)
Proyecto: Terpel
Descripción: Trigger objeto Contrato. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha	   Autor				   Descripción
------ ---------- ---------------------------------------------------------------
1.0 23-01-2017  Walter Rodríguez (WR)  Creación trigger.
***********************************************************************************/
trigger Ter_Contract_tgr on Contract (after delete, after insert, after update, before delete, before insert, before update)
{
	Ter_Contract_cls obContract =  new Ter_Contract_cls();
	
	if(Trigger.isBefore)
	{
		if(Trigger.isUpdate)
		{
			obContract.crearOportunidad(Trigger.old,Trigger.new);
		}
	}
}