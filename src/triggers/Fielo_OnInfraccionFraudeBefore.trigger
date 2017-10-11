/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 01/06/2017
* 
* Name: Fielo_OnInfraccionFraudeBefore.trigger
* 
* Trigger responsavel pelos eventos de after do objeto Fielo Infraccion Fraude
*
*******************************************************************************/
trigger Fielo_OnInfraccionFraudeBefore on Fielo_InfraccionFraude__c (before insert, before update) {

	if ( !TriggerCheck.isActive( 'Fielo_InfraccionFraude__c' ) ) return;

	if ( Trigger.isInsert ) {

		Fielo_TRIG_InfraccionFraudeBefore.bloqueoPorReincidente();
	}

	if ( Trigger.isUpdate ) {

		Fielo_TRIG_InfraccionFraudeBefore.bloqueoPorReincidente();
	}
}