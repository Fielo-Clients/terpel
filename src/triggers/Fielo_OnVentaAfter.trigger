/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 23/05/2017
* 
* Name: Fielo_OnVentaAfter.trigger
* 
* Trigger responsavel pelos eventos de after do objeto Fielo Venta
*
*******************************************************************************/
trigger Fielo_OnVentaAfter on Fielo_Venta__c (after insert, after update) {

    if ( !TriggerCheck.isActive( 'Fielo_Venta__c' ) ) return;

    if ( Trigger.isInsert ) {
        // First execution
        //Fielo_TRIG_VentaAfter.fraudControl();
        // Second execution
        Fielo_TRIG_VentaAfter.montosFidelizables();
        FieloPLT.SObjectService.processRecords(Trigger.new, null);
    }

    if ( Trigger.isUpdate ) {
        // First execution
        //Fielo_TRIG_VentaAfter.fraudControl();
        // Second execution
        Fielo_TRIG_VentaAfter.montosFidelizables(); 
        Fielo_TRIG_VentaAfter.revertVenta();

        // Rule trigger of ventas
        FieloPLT.SObjectService.processRecords(Trigger.new, Trigger.oldMap);  
    }
}