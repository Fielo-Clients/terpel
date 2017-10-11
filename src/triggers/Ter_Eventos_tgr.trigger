/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez M. (WRM)
Proyecto: Terpel
Descripción: Trigger objeto Eventos. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha	   Autor				   Descripción
------ ---------- ---------------------------------------------------------------
1.0 19-01-2017  Walter Rodríguez (WR)  Creación trigger.
***********************************************************************************/
trigger Ter_Eventos_tgr on Event (after delete, after insert, after update, before delete, before insert, before update) 
{
	
	Ter_Eventos_cls objEventos = new Ter_Eventos_cls();
	
	if(Trigger.isAfter)
	{
		
	}
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
		{
			objEventos.crearActa(Trigger.new);
		}

		if(Trigger.isUpdate)
		{
			objEventos.permisoModificar(Trigger.new);

		}
		if(Trigger.isDelete)
		{
			objEventos.permisoBorrar(Trigger.old);
		}
	}
}