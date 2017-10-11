/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 31/05/2017
* 
* Name: Fielo_OnItemVentaAfter.trigger
* 
* Trigger responsavel pelos eventos de after do objeto Fielo Item Venta
*
*******************************************************************************/
trigger Fielo_OnItemVentaAfter on Fielo_ItemVenta__c (after insert, after update) {

	if ( !TriggerCheck.isActive( 'Fielo_ItemVenta__c' ) ) return;

	if ( Trigger.isInsert ) {

		Fielo_TRIG_ItemVentaAfter.tipoCombustible();
	}

	if ( Trigger.isUpdate ) {

		Fielo_TRIG_ItemVentaAfter.tipoCombustible();
	}
}