/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: JNS                          date: 03/08/2017
* 
* Name: Widget1APITest.trigger
* 
* Classe de teste do controller Widget1API.cls
*
*******************************************************************************/
@isTest
private class Widget1APITest
{
	@isTest
	static void itShould()
	{
		FieloPLT__Member__c LMemberCliente =  createMemberByAccount();
		Ter_Estacion_de_Servicio__c lEstacionServ = SObjectForTest.getEstacionDeServicio();
		lEstacionServ.Ter_Longitud__c = 1;
		lEstacionServ.Ter_Latitud__c = 1;
		lEstacionServ.F_IdFidelizacion__c = LMemberCliente.id;
        lEstacionServ.Ter_Estatus__c = 'Activa';
        lEstacionServ.Ter_Marca__c = 'Terpel';
        lEstacionServ.F_ClubTerpel__c = TRUE;
		insert lEstacionServ;

		Test.startTest();	

		system.runAs(LMemberCliente.FieloPLT__User__r) {

			Widget1API lTela = new Widget1API();
			Widget1API.estacionDetail(lEstacionServ.id);
			String lTest = lTela.fLocationJson + lTela.fIdEstacion  + lTela.fEstacionDetail;

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