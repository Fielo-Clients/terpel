/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 23/05/2017
* 
* Name: Fielo_OnMemberAfter.trigger
* 
* Trigger responsavel pelos eventos de after do objeto Fielo Member
*
*******************************************************************************/
trigger Fielo_OnMemberAfter on FieloPLT__Member__c (after insert, after update) {

	if ( !TriggerCheck.isActive( 'FieloPLT__Member__c' ) ) return;

	if ( Trigger.isInsert ) {

		Fielo_TRIG_MemberAfter.updateTimeZoneMemberUser();
	}

	if ( Trigger.isUpdate ) {

		Fielo_TRIG_MemberAfter.updateAccount();

		Fielo_TRIG_MemberAfter.activeMemberUser();
	}
}