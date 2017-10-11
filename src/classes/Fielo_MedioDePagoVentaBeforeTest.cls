/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                  date: 05/10/2017
* 
* Name: Fielo_MedioDePagoVentaBeforeTest.cls
* 
* Classe de teste da trigger Fielo_OnMedioDePagoVentaBeforeTest.trigger
*
*******************************************************************************/
@isTest
private class Fielo_MedioDePagoVentaBeforeTest {	
	
    //  Status Redemption
    public final static String CLOSED = 'Closed';

	@isTest static void montosFidelizables() {		

		// Given
        FieloPLT__Program__c program = new FieloPLT__Program__c(Name = 'test');
        insert program;
        FieloPLT__Member__c member = new FieloPLT__Member__c(Name = 'test', FieloPLT__Email__c = 'test@fielo.com', FieloPLT__Program__c = program.Id, FieloPLT__User__c = UserInfo.getUserId());
        insert member;

        member.FieloPLT__Points__c = 500;
        FieloPLT.SObjectService.enableAdminPermission(true);
        update member;
        FieloPLT.SObjectService.enableAdminPermission(false);
        
        System.debug(loggingLevel.Error, '*** redemptions: ' + [Select id, fieloplt__points__c from FieloPLT__Member__c]);
        // create reward. reward items and redemption
        
        FieloPLT__Reward__c reward = MockUpFactory.createRewards('Test', 10, program.Id, 10)[0];
        insert reward;
        Map<Id, Integer> quantityPerReward = new Map<Id, Integer>{reward.Id => 1};
        List<FieloPLT__Redemption__c> lRedemptionLst = FieloPLT.RedemptionService.createRedemptions(quantityPerReward, member.Id);
        lRedemptionLst[0].FieloPLT__Status__c = CLOSED;
    	update lRedemptionLst[0];
        
        List<FieloPLT__RedemptionItem__c> lRedemptionItemLst = [SELECT FieloPLT__UniqueCode__c 
        														FROM FieloPLT__RedemptionItem__c
        														WHERE FieloPLT__Redemption__c = :lRedemptionLst[0].id];

        Fielo_MedioDePagoVenta__c lMedioDePagoVenta = SObjectForTest.getMedioDePagoVenta();
        lMedioDePagoVenta.F_CodigoVoucher__c = lRedemptionItemLst[0].FieloPLT__UniqueCode__c;

		Test.startTest();
			insert lMedioDePagoVenta;
		Test.stopTest();
	}
}