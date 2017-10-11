/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 30/05/2017
* 
* Name: Fielo_PointAfterTest.trigger
* 
* Classe de teste da trigger Fielo_OnPointAfter.trigger
*
*******************************************************************************/
@isTest
private class Fielo_PointAfterTest {

	@isTest static void updateMember() {

		FieloPLT__Program__c lPrg = SObjectForTest.getProgram('Teste'); 
		insert lPrg; 

		FieloPLT__Member__c lMb = SObjectForTest.loadMember();

		Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
		insert lTasa;

		FieloPLT__Library__c lLib = SObjectForTest.getLibrary();
		insert lLib;

		FieloPLT__RuleTrigger__c lRT = SObjectForTest.getRuleTrigger();
		lRT.FieloPLT__Library__c = lLib.id;
		insert lRT;

		FieloPLT__Action__c lAc = SObjectForTest.getAction(lRT.id);
		insert lAc;

		FieloPLT__PointType__c lPtType = SObjectForTest.getPointType();		
        lPtType.FieloPLT__ConversionValueField__c = 'FieloPLT__ConversionValue__c';
        lPtType.FieloPLT__RecordFieldNameField__c = 'FieloPLT__RecordFieldName__c';
        lPtType.FieloPLT__ConversionModeField__c = 'FieloPLT__PointConversionMode__c';
        lPtType.FieloPLT__MonthsUntilExpirationField__c = 'FieloPLT__MonthsUntilExpiration__c';
		insert lPtType;

		FieloPLT__Promotion__c lPromo = SObjectForTest.getPromotion();
		lPromo.FieloPLT__Program__c = lPrg.id;
		insert lPromo;

		FieloPLT__ProgramPointType__c lProgPointType = SObjectForTest.getProgramPointType();
		lProgPointType.FieloPLT__Program__c = lPrg.id;
		lProgPointType.FieloPLT__PointType__c = lPtType.id;
		insert lProgPointType;

		FieloPLT__Rule__c lRu = SObjectForTest.getRule('teste');
		lRu.FieloPLT__Type__c = 'No Competition';
		lRu.FieloPLT__Promotion__c = lPromo.id;
		lRu.FieloPLT__Action__c = lAc.id;
		insert lRu;

		FieloPLT__Transaction__c lTr = SObjectForTest.getTransaction(lMb.id);
		insert lTr;

		Test.startTest();
			FieloPLT__Point__c lPo = SObjectForTest.getPoint(lMb.id, lRu.id);
			lPo.FieloPLT__Transaction__c = lTr.id;
			lPo.FieloPLT__PointType__c = lPtType.id;
			insert lPo;
		Test.stopTest();
	}
}