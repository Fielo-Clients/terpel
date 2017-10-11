/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 29/05/2017
* 
* Name: Fielo_AccountAfterTest.trigger
* 
* Classe de teste da trigger Fielo_OnAccountAfter.trigger
*
*******************************************************************************/
@isTest
private class Fielo_AccountAfterTest {
	// Rectype of Account
	public final static String PERSON_TERPEL_ID = RecType.getID('Account', 'Cliente Terpel');

	@isTest static void createMemberClienteTerpel() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = 'teste';
		insert lPr;

		Account lAcc = SObjectForTest.getAccount();
		lAcc.F_TipoTarjetaPreinscrita__c = '';

		Test.startTest();
			insert lAcc;

			List<FieloPLT__Member__c> lMemberLst = [
				SELECT FieloPLT__Email__c
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAcc.id];

			// Member created for Account
			system.assert(lMemberLst.size() > 0);
			system.assertEquals(lMemberLst[0].FieloPLT__Email__c, lAcc.PersonEmail);

			lAcc.F_EstadoTarjetaPreinscrita__c = 'Utilizada';
			update lAcc;
		Test.stopTest();
	}

	@isTest static void createMemberTarjeta() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = 'teste';
		insert lPr;

		Account lAcc = SObjectForTest.getAccount();
		lAcc.F_TipoTarjetaPreinscrita__c = 'Virtual';
		lAcc.F_CodigoTarjetaPreinscrita__c = '9998887776665';

		Test.startTest();
			insert lAcc;

			List<FieloPLT__Member__c> lMemberLst = [
				SELECT FieloPLT__Email__c
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAcc.id];

			// Member created for Account
			system.assert(lMemberLst.size() > 0);
			system.assertEquals(lMemberLst[0].FieloPLT__Email__c, lAcc.PersonEmail);

			lAcc.F_EstadoTarjetaPreinscrita__c = 'Utilizada';
			update lAcc;
		Test.stopTest();
	}
}