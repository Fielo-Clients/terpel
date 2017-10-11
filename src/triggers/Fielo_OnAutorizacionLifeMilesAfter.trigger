/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                    date: 06/07/2017
* 
* Name: Fielo_OnAutorizacionLifeMilesAfter.trigger
* 
* Trigger responsavel pelos eventos de after do objeto Fielo_Autorizacion_LifeMiles__c
*
*******************************************************************************/
trigger Fielo_OnAutorizacionLifeMilesAfter on Fielo_Autorizacion_LifeMiles__c (after insert, after update) {

	if ( !TriggerCheck.isActive( 'Fielo_Autorizacion_LifeMiles__c' ) ) return;

	if ( Trigger.isInsert ) {

		Fielo_TRIG_AutorizacionLifeMilesAfter.execute();
	}

	if ( Trigger.isInsert || Trigger.isUpdate ) {

		Fielo_TRIG_AutorizacionLifeMilesAfter.autorizacionLifemilesDebito();
	}
}