/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 29/06/2017
* 
* Name: Fielo_OnAccountBefore.trigger
* 
* Trigger responsavel pelos eventos de before do objeto Account
*
*******************************************************************************/
trigger Fielo_OnAccountBefore on Account (before insert) {

	if ( !TriggerCheck.isActive( 'Account' ) ) return;

	if ( Trigger.isInsert ) {

		Fielo_TRIG_AccountBefore.nuevaTarjeta();
	}
}