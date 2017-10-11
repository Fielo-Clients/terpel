/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase de prueba encargarda de cubrir la clase Ter_Account_cls. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 13-02-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

@isTest
private class Ter_Account_tst 
{
	@isTest static void validaCambioEstadoVisita()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contact objContact = Ter_DataGenerator_cls.crearContacto(true, objCuenta);
			objCuenta.Ter_Estado_de_cliente__c = 'Visita';
			update objCuenta;
		Test.stopTest();
	}
	
	@isTest static void validaCambioEstadoPropuesta()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contact objContact = Ter_DataGenerator_cls.crearContacto(true, objCuenta);
			Event objEvent = Ter_DataGenerator_cls.crearEvento(true, objCuenta, 'Acta Marinos');
			objCuenta.Ter_Estado_de_cliente__c = 'Visita';
			update objCuenta;
			objCuenta.Ter_Estado_de_cliente__c = 'Propuesta';
			update objCuenta;
		Test.stopTest();
	}
	
	@isTest static void validaCambioEstadoLegalizacion()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contact objContact = Ter_DataGenerator_cls.crearContacto(true, objCuenta);
			Event objEvent = Ter_DataGenerator_cls.crearEvento(true, objCuenta, 'Acta Marinos');
			Attachment objAtt = Ter_DataGenerator_cls.creaAdjunto(true, objCuenta);
			objCuenta.Ter_Estado_de_cliente__c = 'Visita';
			update objCuenta;
			objCuenta.Ter_Estado_de_cliente__c = 'Propuesta';
			update objCuenta;
			objCuenta.Ter_Estado_de_cliente__c = 'Legalización';
			update objCuenta;
		Test.stopTest();
	}
	
	@isTest static void validaCambioEstadoLegalizada()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contact objContact = Ter_DataGenerator_cls.crearContacto(true, objCuenta);
			Event objEvent = Ter_DataGenerator_cls.crearEvento(true, objCuenta, 'Acta Marinos');
			Attachment objAtt = Ter_DataGenerator_cls.creaAdjunto(true, objCuenta);
			Attachment objAtt2 = Ter_DataGenerator_cls.creaAdjunto(true, objCuenta);
			objCuenta.Ter_Estado_de_cliente__c = 'Visita';
			update objCuenta;
			objCuenta.Ter_Estado_de_cliente__c = 'Propuesta';
			update objCuenta;
			objCuenta.Ter_Estado_de_cliente__c = 'Legalización';
			update objCuenta;
			objCuenta.Ter_Estado_de_cliente__c = 'Legalizada';
			update objCuenta;
		Test.stopTest();
	}
}