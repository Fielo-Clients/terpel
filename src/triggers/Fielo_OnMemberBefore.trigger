/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 23/05/2017
* 
* Name: Fielo_OnMemberAfter.trigger
* 
* Trigger responsavel pelos eventos de before do objeto Fielo Member
*
*******************************************************************************/
trigger Fielo_OnMemberBefore on FieloPLT__Member__c (before insert, before update) {

    if ( !TriggerCheck.isActive( 'FieloPLT__Member__c' ) ) return;

    if ( Trigger.isInsert ) {

        Fielo_TRIG_MemberBefore.createUser();
        Fielo_TRIG_MemberBefore.updateBalanceLifeMilesToPoints();
    }

    if ( Trigger.isUpdate ) {

        Fielo_TRIG_MemberBefore.updateUser();
        Fielo_TRIG_MemberBefore.updateBalanceLifeMilesToPoints();
        
        Fielo_TRIG_MemberBefore.mergeTarjetaPreinscrita();
    }
}