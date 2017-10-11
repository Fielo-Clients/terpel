/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase de prueba para la clase Ter_Eventos_ctr. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 13-02-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

@isTest
private class Ter_Eventos_tst 
{
	@isTest static void creaEventoEDS()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
			Event objEvento = Ter_DataGenerator_cls.crearEvento(false, objCuenta, 'Acta Bitácora Ambiental GA');
			objEvento.whatId = objEDS.Id;
			insert objEvento;
		Test.stopTest();
	}
	
	/*@isTest static void creaEventoEDSFallo()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Event objEvento = Ter_DataGenerator_cls.crearEvento(false);
			objEvento.whatId = objCuenta.Id;
			insert objEvento;
		Test.stopTest();
	}*/
	
	@isTest static void creaEventoCuenta()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Event objEvento = Ter_DataGenerator_cls.crearEvento(true, objCuenta, 'Acta Marinos');
			//objEvento.Ter_Tipo_Acta__c = 'Acta Marinos';
			//objEvento.whatId = objCuenta.Id;
			//insert objEvento;
		Test.stopTest();
	}
	
	/*@isTest static void creaEventoCuentaFallo()
	{
		Test.startTest();
			Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
			Event objEvento = Ter_DataGenerator_cls.crearEvento(false);
			objEvento.Ter_Tipo_Acta__c = 'Acta Marinos';
			objEvento.whatId = objEDS.Id;
			insert objEvento;
		Test.stopTest();
	}*/
	
	@isTest static void modificaEvento()
	{
		Test.startTest();
			//Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Event objEvento = Ter_DataGenerator_cls.crearEvento(true, objCuenta, 'Acta Marinos');
			//objEvento.whatId = objEDS.Id;
			//insert objEvento;
			objEvento.Subject = 'Llamada';
			update objEvento;
		Test.stopTest();
	}
	
	@isTest static void borrarEvento()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			//Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
			Event objEvento = Ter_DataGenerator_cls.crearEvento(true, objCuenta, 'Acta Marinos');
			//objEvento.whatId = objEDS.Id;
			//insert objEvento;
			delete objEvento;
		Test.stopTest();
	}
}