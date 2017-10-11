/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase de prueba para la clase controladora Ter_GenerarPDF_ctr. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 16-02-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

@isTest
private class Ter_GenerarPDF_tst 
{
	@isTest static void test_method_save() 
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contact objContacto = Ter_DataGenerator_cls.crearContacto(true, objCuenta);
			Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
			Ter_Acta_Encuesta__c objActa = Ter_DataGenerator_cls.creaActa(true, objEDS);
			Event objEvento = Ter_DataGenerator_cls.crearEventoEDS(true, objEDS, objContacto);
			objEvento.Ter_Acta__c = objActa.Id;
			update objEvento;
			PageReference pageRef = Page.Ter_GenerarPDF_pag;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController objSC = new ApexPages.StandardController( objActa );
			Ter_GenerarPDF_ctr objCtr = new Ter_GenerarPDF_ctr(objSC);
			objCtr.enviarCorreo();
			objCtr.regresar();
		Test.stopTest();
	}
}