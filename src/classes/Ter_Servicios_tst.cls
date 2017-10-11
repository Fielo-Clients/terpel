/**********************************************************************************
Desarrollado por: Avanxo
Autor: Walter Rodríguez (WRM)
Proyecto: Terpel
Descripción: Clase de prueba para el servicio Ter_Servicios_ws y la clase Ter_Contract_cls encargada de la logíca del servicio. 
Cambios (Versiones)
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 20-02-2017  Walter Rodríguez M (WRM)      Creación de la Clase.
***********************************************************************************/

@isTest
private class Ter_Servicios_tst 
{
	@isTest static void ejecutaServicioContrato()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contract objContratoOpp = Ter_DataGenerator_cls.creaContrato(true, objCuenta);
			list<Ter_Servicios_ws.TER_Contrato> lstObjContract = new list<Ter_Servicios_ws.TER_Contrato>();
			
			Ter_Servicios_ws.TER_Contrato objContrato = new Ter_Servicios_ws.TER_Contrato();
			objContrato.strNumContrato = '321123';
			objContrato.strNombreContrato = 'Contrato Test';
			objContrato.strTituloContrato = 'Test';
			objContrato.strEstadoContrato = 'CANCELADO';
			objContrato.strFechaFinContrato = '22/12/2017';
			objContrato.strFechaIniContrato = '22/12/2016';
			objContrato.decValorContrato = 3000000;
			objContrato.strTituloContrato = 'Título';
			objContrato.strMoneda = 'PESOS';
			objContrato.strCuentaContrato = objCuenta.Name;
			lstObjContract.add(objContrato);
			
			Ter_Servicios_ws.TER_Contrato objContrato2 = new Ter_Servicios_ws.TER_Contrato();
			objContrato2.strNumContrato = '123321';
			objContrato2.strNombreContrato = 'Contrato test';
			objContrato2.strCuentaContrato = objCuenta.Name;
			objContrato2.strEstadoContrato = 'EN TRAMITE';
			objContrato2.strTituloContrato ='Titulo Test';
			objContrato2.decValorContrato = 3000000;
			objContrato2.strMoneda = 'Pesos';
			objContrato2.strFechaIniContrato = '22/12/2016';
			objContrato2.strFechaFinContrato = '22/12/2017';
			lstObjContract.add(objContrato2);
			
			Ter_Servicios_ws.TER_Response objResponse = Ter_Servicios_ws.crearActualizarContrato( lstObjContract );
		Test.stopTest();
	}
	
	@isTest static void crearOportunidad()
	{
		Test.startTest();
			Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Contract objContrato = Ter_DataGenerator_cls.creaContrato(true, objCuenta);
			objContrato.Ter_Generar_Oportunidad__c = true;
			update objContrato;
		Test.stopTest();
	}
}