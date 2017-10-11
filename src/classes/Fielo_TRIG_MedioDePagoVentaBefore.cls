/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                  date: 31/08/2017
* 
* Name: Fielo_TRIG_MedioDePagoVentaBefore.cls
* 
* Class for before event of Fielo Medio De Pago Venta
*
*******************************************************************************/
public with sharing class Fielo_TRIG_MedioDePagoVentaBefore {

	public static void bonoFidelizacion() {

		TriggerCheck.assert();

		Set<String> lCodigoVoucherSet = new Set<String>();
		List<Fielo_MedioDePagoVenta__c> lMedioDePagoVentaLst = new List<Fielo_MedioDePagoVenta__c>();
		for(Fielo_MedioDePagoVenta__c lMedioDePagoVenta :(List<Fielo_MedioDePagoVenta__c>) trigger.new) {

			if(lMedioDePagoVenta.F_CodigoVoucher__c != null) {

				lCodigoVoucherSet.add(lMedioDePagoVenta.F_CodigoVoucher__c);
				lMedioDePagoVentaLst.add(lMedioDePagoVenta);
			}
		}

		if(lMedioDePagoVentaLst.size() == 0) return;

		Map<String,FieloPLT__RedemptionItem__c> lRedemptionItemMap = new Map<String,FieloPLT__RedemptionItem__c>();
		for(FieloPLT__RedemptionItem__c lRedemptionItem :[
				SELECT FieloPLT__UniqueCode__c 
				FROM FieloPLT__RedemptionItem__c 
				WHERE FieloPLT__UniqueCode__c IN :lCodigoVoucherSet]) {

			lRedemptionItem.FieloPLT__Status__c = 'Delivered';
			lRedemptionItemMap.put(lRedemptionItem.FieloPLT__UniqueCode__c, lRedemptionItem);
		}

		if(lRedemptionItemMap.size() == 0) return;

		for(Fielo_MedioDePagoVenta__c lMedioDePagoVenta :lMedioDePagoVentaLst) {

			FieloPLT__RedemptionItem__c lRedemptionItem = lRedemptionItemMap.get(lMedioDePagoVenta.F_CodigoVoucher__c);
			if(lRedemptionItem != null) {
				lMedioDePagoVenta.F_RedemptionItem__c = lRedemptionItem.id;
			}			
		}

		FieloPLT.SObjectService.enableAdminPermission(true);
		update lRedemptionItemMap.values();
		FieloPLT.SObjectService.enableAdminPermission(false);			
	}
}