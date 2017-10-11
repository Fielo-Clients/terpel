/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 22/06/2017
* 
* Name: Fielo_BAT_SCH_MemberExpiracionTarjetaTst.cls
* 
* Classe de teste do scheduler/batch Fielo_BAT_SCH_MemberExpiracionTarjeta.cls
*
*******************************************************************************/
@isTest
private class Fielo_BAT_SCH_MemberExpiracionTarjetaTst {
	// Rectype of Account
	public final static String TARJETA_PREINSCRITA_ID = RecType.getID('Account', 'Tarjeta Preinscrita');

	@isTest static void executeBatch() {

		FieloPLT__Member__c LMemberTarjeta =  createTarjeta();

		// Set state active in tarjeta (On change to active the date of expiration tarjeta = date now + 30)
		LMemberTarjeta.F_EstadoTarjetaPreinscrita__c = 'Activa';
		update LMemberTarjeta;	

		// Change expiration date for tajeta
		LMemberTarjeta.F_FechaExpiracionTarjeta__c = Date.newInstance(2017,6,20);		
		update LMemberTarjeta;

		Test.startTest();
		Fielo_BAT_SCH_MemberExpiracionTarjeta.expiracionTarjetaMember();
		Test.stopTest();
	}

	@isTest static void executeScheduler() {

		Test.startTest();

		Fielo_BAT_SCH_MemberExpiracionTarjeta obj = new Fielo_BAT_SCH_MemberExpiracionTarjeta();   
		String chron = '0 0 23 * * ?';        
		String jobid = System.schedule('Test Member Expiracion Tarjeta', chron, obj);

		CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
		System.assertEquals(chron,ct.CronExpression); 
		
		Test.stopTest();
	}

	private static FieloPLT__Member__c createTarjeta() {

		FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
		lPr.SiteUrl__c = 'teste';
		insert lPr;

		Account lAccTarjeta = SObjectForTest.getAccount();
		lAccTarjeta.F_TipoMember__c = 'Fielo_TarjetaPreinscrita';
        lAccTarjeta.RecordTypeId = TARJETA_PREINSCRITA_ID;
		insert lAccTarjeta;

		return [SELECT RecordType.DeveloperName, F_FechaExpiracionTarjeta__c, F_EstadoTarjetaPreinscrita__c 
				FROM FieloPLT__Member__c 
				WHERE FieloPLT__Account__c = :lAccTarjeta.id];
	}
}