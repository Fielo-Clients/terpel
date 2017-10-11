/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 28/06/2017
* 
* Name: Widget2APITest.trigger
* 
* Classe de teste do controller Widget2API.cls
*
*******************************************************************************/
@isTest
private class Widget2APITest {
	// Rectype of Account
	public final static String TARJETA_PREINSCRITA_ID = RecType.getID('Account', 'Tarjeta Preinscrita');


	@isTest static void updateTarjetaActiva() {

		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Account lAccTarjeta = SObjectForTest.getAccount();
		lAccTarjeta.F_TipoMember__c = 'Fielo_TarjetaPreinscrita';
        lAccTarjeta.RecordTypeId = TARJETA_PREINSCRITA_ID;
        lAccTarjeta.F_TipoTarjetaPreinscrita__c = 'Virtual';
        lAccTarjeta.F_CodigoTarjetaPreinscrita__c = 'T000000000001';
        lAccTarjeta.Ter_Numero_de_identificacion__c = '1239879871';
        lAccTarjeta.F_NumeroLifeMiles__c = '56712398edu'; 
		insert lAccTarjeta;

		FieloPLT__Member__c LMemberTarjeta =  [SELECT id
												FROM FieloPLT__Member__c 
												WHERE FieloPLT__Account__c = :lAccTarjeta.id];

		LMemberTarjeta.F_EstadoTarjetaPreinscrita__c = 'Activa';
		update LMemberTarjeta;

		Test.startTest();	

		system.runAs(LMemberCliente.FieloPLT__User__r) {

			Widget2API lTela = new Widget2API();
			Widget2API.fNumTarjetaAsignar = '';	
			lTela.searchTarjeta();
			Widget2API.fNumTarjetaAsignar = '1234567890';	
			lTela.searchTarjeta();

			Widget2API.fNumTarjetaAsignar = 'T000000000001';	
			lTela.searchTarjeta();

			lTela.save();
		}		

		Test.stopTest();
	}

	@isTest static void updateTarjetaExpirada() {

		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Account lAccTarjeta = SObjectForTest.getAccount();
		lAccTarjeta.F_TipoMember__c = 'Fielo_TarjetaPreinscrita';
        lAccTarjeta.RecordTypeId = TARJETA_PREINSCRITA_ID;
        lAccTarjeta.F_TipoTarjetaPreinscrita__c = 'Virtual';
        lAccTarjeta.F_CodigoTarjetaPreinscrita__c = 'T000000000001';
        lAccTarjeta.Ter_Numero_de_identificacion__c = '1239879871';
        lAccTarjeta.F_NumeroLifeMiles__c = '56712398edu'; 
		insert lAccTarjeta;

		FieloPLT__Member__c LMemberTarjeta =  [SELECT id
												FROM FieloPLT__Member__c 
												WHERE FieloPLT__Account__c = :lAccTarjeta.id];

		LMemberTarjeta.F_EstadoTarjetaPreinscrita__c = 'Expirada';
		update LMemberTarjeta;

		Test.startTest();	

		system.runAs(LMemberCliente.FieloPLT__User__r) {

			Widget2API lTela = new Widget2API();
			Widget2API.fNumTarjetaAsignar = 'T000000000001';	
			lTela.searchTarjeta();
		}		

		Test.stopTest();
	}

	@isTest static void updateTarjetaUtilizada() {

		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Account lAccTarjeta = SObjectForTest.getAccount();
		lAccTarjeta.F_TipoMember__c = 'Fielo_TarjetaPreinscrita';
        lAccTarjeta.RecordTypeId = TARJETA_PREINSCRITA_ID;
        lAccTarjeta.F_TipoTarjetaPreinscrita__c = 'Virtual';
        lAccTarjeta.F_CodigoTarjetaPreinscrita__c = 'T000000000001';
        lAccTarjeta.Ter_Numero_de_identificacion__c = '1239879871';
        lAccTarjeta.F_NumeroLifeMiles__c = '56712398edu'; 
		insert lAccTarjeta;

		FieloPLT__Member__c LMemberTarjeta =  [SELECT id
												FROM FieloPLT__Member__c 
												WHERE FieloPLT__Account__c = :lAccTarjeta.id];

		LMemberTarjeta.F_EstadoTarjetaPreinscrita__c = 'Utilizada';
		update LMemberTarjeta;

		Test.startTest();	

		system.runAs(LMemberCliente.FieloPLT__User__r) {

			Widget2API lTela = new Widget2API();
			Widget2API.fNumTarjetaAsignar = 'T000000000001';	
			lTela.searchTarjeta();
		}		

		Test.stopTest();
	}

	@isTest static void updateTarjetaAsignada() {

		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

		Account lAccTarjeta = SObjectForTest.getAccount();
		lAccTarjeta.F_TipoMember__c = 'Fielo_TarjetaPreinscrita';
        lAccTarjeta.RecordTypeId = TARJETA_PREINSCRITA_ID;
        lAccTarjeta.F_TipoTarjetaPreinscrita__c = 'Virtual';
        lAccTarjeta.F_CodigoTarjetaPreinscrita__c = 'T000000000001';
        lAccTarjeta.Ter_Numero_de_identificacion__c = '1239879871';
        lAccTarjeta.F_NumeroLifeMiles__c = '56712398edu'; 
		insert lAccTarjeta;

		FieloPLT__Member__c LMemberTarjeta =  [SELECT id
												FROM FieloPLT__Member__c 
												WHERE FieloPLT__Account__c = :lAccTarjeta.id];

		LMemberTarjeta.F_EstadoTarjetaPreinscrita__c = 'Asignada';
		update LMemberTarjeta;

		Test.startTest();	

		system.runAs(LMemberCliente.FieloPLT__User__r) {

			Widget2API lTela = new Widget2API();
			Widget2API.fNumTarjetaAsignar = 'T000000000001';	
			lTela.searchTarjeta();
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