/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 30/05/2017
* 
* Name: Fielo_MemberBeforeTest.cls
* 
* Classe de teste da trigger Fielo_OnMemberBefore.trigger
*
*******************************************************************************/
@isTest
private class Fielo_MemberBeforeTest {
	// Rectype of Account
	public final static String TARJETA_PREINSCRITA_ID = RecType.getID('Account', 'Tarjeta Preinscrita');

	@isTest static void updateMember() {

		FieloPLT__Member__c LMember =  createMemberByAccount();

		Test.startTest();
			// Change at least one field
			LMember.F_SessionId__c = '9876KA54321';
			LMember.F_NumeroLifeMiles__c = '987654321DSA';
			update LMember;
		Test.stopTest();
	}

	@isTest static void updateTarjeta() {

		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Account lAccTarjeta = SObjectForTest.getAccount();
		lAccTarjeta.F_TipoMember__c = 'Fielo_TarjetaPreinscrita';
        lAccTarjeta.RecordTypeId = TARJETA_PREINSCRITA_ID;
        lAccTarjeta.F_CodigoTarjetaPreinscrita__c = 'T000000000111';
        lAccTarjeta.Ter_Numero_de_identificacion__c = '1239879871';
        lAccTarjeta.F_NumeroLifeMiles__c = '56712398edu'; 
		insert lAccTarjeta;

		FieloPLT__Member__c LMemberTarjeta =  [SELECT id
												FROM FieloPLT__Member__c 
												WHERE FieloPLT__Account__c = :lAccTarjeta.id];

		LMemberTarjeta.F_EstadoTarjetaPreinscrita__c = 'Activa';
		update LMemberTarjeta;

		Test.startTest();		

		LMemberCliente.F_AsignarTarjetaPreinscrita__c = 'T000000000111';		
		update LMemberCliente;

		Test.stopTest();
	}

	private static FieloPLT__Member__c createMemberByAccount() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = 'teste';
		insert lPr;

		Account lAcc = SObjectForTest.getAccount();

		insert lAcc;

		return [SELECT FieloPLT__Email__c
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAcc.id];
	}
}