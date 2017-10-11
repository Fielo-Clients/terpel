/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 22/05/2017
* 
* Name: Fielo_OnAccountAfter.trigger
* 
* Trigger responsavel pelos eventos de after do objeto Account
*
*******************************************************************************/
trigger Fielo_OnAccountAfter on Account (after insert, after update) {

	if ( !TriggerCheck.isActive( 'Account' ) ) return;

	if ( Trigger.isInsert ) {

		Fielo_TRIG_AccountAfter.createMember();
	}
	if ( Trigger.isUpdate ) {

		Fielo_TRIG_AccountAfter.updateMember();
	}
}