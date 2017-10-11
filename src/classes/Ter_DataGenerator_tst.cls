/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de pruebas para las clases de Ter_DataGenerator_cls
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    30/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class Ter_DataGenerator_tst {
	
	@isTest static void dataGenerator(){
		
		Test.startTest();
		
			FieloPLT__Program__c objFieloPLTProgram = Ter_DataGenerator_cls.crearFieloProgram(true);
			Account crearCuenta = Ter_DataGenerator_cls.crearCuenta(true);
			Account crearCuentaAcumulacion = Ter_DataGenerator_cls.crearCuentaAcumulacion(true);
			Contact crearContacto = Ter_DataGenerator_cls.crearContacto(true, crearCuenta);
			Ter_Estacion_de_Servicio__c crearEDS = Ter_DataGenerator_cls.crearEDS(true);
			Event crearEvento = Ter_DataGenerator_cls.crearEvento(true, crearCuenta, 'Acta Aviación');
			Event crearEventoEDS = Ter_DataGenerator_cls.crearEventoEDS(true, crearEDS, crearContacto);
			Task crearTarea = Ter_DataGenerator_cls.crearTarea(true, crearCuenta);
			Attachment creaAdjunto =  Ter_DataGenerator_cls.creaAdjunto(true, crearCuenta);
			Product2 creaProducto =  Ter_DataGenerator_cls.creaProducto(true);
			Ter_Acta_Encuesta__c creaActa =  Ter_DataGenerator_cls.creaActa(true, crearEDS);
			Contract creaContrato =  Ter_DataGenerator_cls.creaContrato(true, crearCuenta);
			Ter_ConversionWsRequestDTO_cls generateRequestConversion = Ter_DataGenerator_cls.generateRequestConversion(null);
			Ter_RequestRedentionDTO_cls generateRquestRedention =  Ter_DataGenerator_cls.generateRquestRedention(null);
			SrvIntClienteTransaccion_in.DT_ValidaCliente generateRequestValidateClient =  Ter_DataGenerator_cls.generateRequestValidateClient(null, null, null);
			Ter_Estacion_de_Servicio__c generateEST =  Ter_DataGenerator_cls.generateEST();
			Ter_Negocio_Complementario__c generateStore = Ter_DataGenerator_cls.generateStore();
			Ter_Negocio_Complementario__c crearTTCC = Ter_DataGenerator_cls.crearTTCC(true);
			Contact generateContact = Ter_DataGenerator_cls.generateContact();

			FieloPLT__Segment__c objFieloPLSegment = Ter_DataGenerator_cls.crearSegmento(true, objFieloPLTProgram.Id);
			FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('1245377192154','88556699','T100000000012', null);
			FieloPLT__Redemption__c objFieloPLTRedemption = Ter_DataGenerator_cls.crearRedenciones(objMember.Id,true);
			FieloPLT__Reward__c objFieloReward  = Ter_DataGenerator_cls.crearPremio(objFieloPLTProgram.Id,objFieloPLSegment.Id,true);
			FieloPLT__RedemptionItem__c objFieloRedemptionItem = Ter_DataGenerator_cls.crearItemRedencion(objFieloPLTRedemption.Id, objFieloReward.Id, true);
			
		Test.stopTest();
	}
    
}