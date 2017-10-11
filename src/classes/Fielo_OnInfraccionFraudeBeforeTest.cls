/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 17/08/2017
* 
* Name: Fielo_OnInfraccionFraudeBeforeTest.trigger
* 
* Classe de teste do controller Fielo_OnInfraccionFraudeBefore.cls
*
*******************************************************************************/
@isTest
private class Fielo_OnInfraccionFraudeBeforeTest {

	@isTest static void metodo1() {

		Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
		insert lVariablesFraude;

		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Test.startTest();	

		system.runAs(LMemberCliente.FieloPLT__User__r) {

			List<Fielo_InfraccionFraude__c> lInfracFraudeLst = new List<Fielo_InfraccionFraude__c>();

			for(Integer i = 0; i < 5; i++) {

				lInfracFraudeLst.add( new Fielo_InfraccionFraude__c(
	                F_Member__c = LMemberCliente.id,
	                F_Descripcion__c = Label.Fielo_InfraccionMaximaCantidadVentas 
	            ));
			}			

            insert lInfracFraudeLst;
		}		

		Test.stopTest();
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