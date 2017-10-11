/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 25/05/2017
* 
* Name: Fielo_OnPointAfter.trigger
* 
* Trigger responsavel pelos eventos de after do objeto Fielo Point
*
*******************************************************************************/
trigger Fielo_OnPointAfter on FieloPLT__Point__c (after insert, after update) {

    if ( !TriggerCheck.isActive( 'FieloPLT__Point__c' ) ) return;

    if ( Trigger.isInsert ) {

        Fielo_TRIG_PointAfter.presupuestoPromotion();
    }
}