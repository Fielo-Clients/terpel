/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                   date: 31/08/2017
* 
* Name: Fielo_OnMedioDePagoVentaBefore.trigger
* 
* Trigger responsavel pelos eventos de before do objeto Fielo Medio De Pago Venta
*
*******************************************************************************/
trigger Fielo_OnMedioDePagoVentaBefore on Fielo_MedioDePagoVenta__c (before insert) {

    if ( !TriggerCheck.isActive( 'Fielo_MedioDePagoVenta__c' ) ) return;

    if ( Trigger.isInsert ) {

        Fielo_TRIG_MedioDePagoVentaBefore.bonoFidelizacion();
    }
}