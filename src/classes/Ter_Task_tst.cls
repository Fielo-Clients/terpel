/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase de prueba para la clase Ter_Task_ctr. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 13-02-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

@isTest
private class Ter_Task_tst 
{
	@isTest static void modificaTarea()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Task objTarea = Ter_DataGenerator_cls.crearTarea(true, objCuenta);
			objTarea.Subject = 'Llamada';
			update objTarea;
		Test.stopTest();
	}
	
	@isTest static void borrarTarea()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Task objTarea = Ter_DataGenerator_cls.crearTarea(true, objCuenta);
			delete objTarea;
		Test.stopTest();
	}
}