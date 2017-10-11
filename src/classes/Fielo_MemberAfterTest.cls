/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 30/05/2017
* 
* Name: Fielo_MemberAfterTest.trigger
* 
* Classe de teste da trigger Fielo_OnMemberAfter.trigger
*
*******************************************************************************/
@isTest
private class Fielo_MemberAfterTest {
	// Rectype of Account
	public final static String PERSON_TERPEL_ID = RecType.getID('Account', 'Cliente Terpel');

	@isTest static void updateMember() {

		FieloPLT__Member__c LMember =  createMemberByAccount();

		Test.startTest();
		// Change at least one field
		LMember.F_FechaExpiracionTarjeta__c = Date.newInstance(2017,7,11);
		update LMember;
		Test.stopTest();
	}

	private static FieloPLT__Member__c createMemberByAccount() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = 'teste';
		insert lPr;

		Account lAcc = SObjectForTest.getAccount();

		insert lAcc;

		return [SELECT FieloPLT__Email__c, FieloPLT__Account__c
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAcc.id];
	}
}