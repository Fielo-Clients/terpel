/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: JNS                   date: 07/08/2017
* 
* Name: Fielo_UTIL_MillasLifeMilesTest.cls
* 
* Class for test Fielo_UTIL_MillasLifeMiles
*
*******************************************************************************/
@isTest
private class Fielo_UTIL_MillasLifeMilesTest
{
	@isTest
	static void itShould()
	{		

		Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_ConversionWsConsumer_cls
                conversionWsConsumer_cls = new Ter_ConversionWsConsumer_cls();
        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls());  

        FieloPLT__Member__c lMemberCliente = createMemberByAccount();


		Fielo_Autorizacion_LifeMiles__c lAutoLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
		lAutoLifeMiles.F_NumeroLifeMiles__c = '123456789ASF';
		lAutoLifeMiles.F_Estado__c = 'Aprobado';
		lAutoLifeMiles.F_TipoTransaccion__c = 'Crédito (C)';
		insert lAutoLifeMiles;

		Fielo_Autorizacion_LifeMiles__c lAutoLifeMiles2 = new Fielo_Autorizacion_LifeMiles__c();
		lAutoLifeMiles2.F_NumeroLifeMiles__c = '123456789ASg';
		lAutoLifeMiles2.F_Estado__c = 'Reintentar';
		lAutoLifeMiles2.F_TipoTransaccion__c = 'Reversión (R)';
		insert lAutoLifeMiles2; 		

		system.runAs(lMemberCliente.FieloPLT__User__r) {

			Test.startTest();	

			Fielo_UTIL_MillasLifeMiles.reversionMillasLifeMiles(lAutoLifeMiles.id);		

			Fielo_UTIL_MillasLifeMiles.reintentarseMillasLifeMiles(lAutoLifeMiles2.id);

			Test.stopTest();

		}
	}

	@isTest
	static void testeFuncional()
	{		

		Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_ConversionWsConsumer_cls
                conversionWsConsumer_cls = new Ter_ConversionWsConsumer_cls();
        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls());  

        FieloPLT__Member__c lMemberCliente = createMemberByAccount();


		Fielo_Autorizacion_LifeMiles__c lAutoLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
		lAutoLifeMiles.F_NumeroLifeMiles__c = '123456789ASF';
		lAutoLifeMiles.F_Estado__c = 'Revertido';
		lAutoLifeMiles.F_TipoTransaccion__c = 'Crédito (C)';
		insert lAutoLifeMiles;		

		system.runAs(lMemberCliente.FieloPLT__User__r) {

			Test.startTest();	
			Fielo_UTIL_MillasLifeMiles.reintentarseMillasLifeMiles(lAutoLifeMiles.id);		
			Test.stopTest();

		}
	}

	@isTest
	static void withOutMock()
	{		

        FieloPLT__Member__c lMemberCliente = createMemberByAccount();


		Fielo_Autorizacion_LifeMiles__c lAutoLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
		lAutoLifeMiles.F_NumeroLifeMiles__c = '123456789ASF';
		lAutoLifeMiles.F_Estado__c = 'Aprobado';
		lAutoLifeMiles.F_TipoTransaccion__c = 'Crédito (C)';
		insert lAutoLifeMiles;

		Fielo_Autorizacion_LifeMiles__c lAutoLifeMiles2 = new Fielo_Autorizacion_LifeMiles__c();
		lAutoLifeMiles2.F_NumeroLifeMiles__c = '123456789ASg';
		lAutoLifeMiles2.F_Estado__c = 'Reintentar';
		lAutoLifeMiles2.F_TipoTransaccion__c = 'Reversión (R)';
		insert lAutoLifeMiles2; 		

		system.runAs(lMemberCliente.FieloPLT__User__r) {

			Test.startTest();	

			Fielo_UTIL_MillasLifeMiles.reversionMillasLifeMiles(lAutoLifeMiles.id);		

			Fielo_UTIL_MillasLifeMiles.reintentarseMillasLifeMiles(lAutoLifeMiles2.id);
			
			Test.stopTest();

		}
	}

	private static FieloPLT__Member__c createMemberByAccount() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = '';
		insert lPr;

		Account lAcc = SObjectForTest.getAccount();

		insert lAcc;

		return [SELECT FieloPLT__Email__c, FieloPLT__User__c, FieloPLT__User__r.userName
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAcc.id];
	}
}