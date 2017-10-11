/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 31/05/2017
* 
* Name: Fielo_TRIG_ItemVentaAfter.cls
* 
* Class for after event of Fielo Item Venta
*
*******************************************************************************/
public with sharing class Fielo_TRIG_ItemVentaAfter {

	// Origin Venta
	public final static String ESTACION_DE_SERVICIO = 'Estación de Servicio';

	// Constants
	public final static String EXTRA = 'Extra';
	public final static String DIESEL = 'Diesel';
	public final static String CORRIENTE = 'Corriente';

	// Custom Settings for Variables Fraude
	private static final Fielo_VariablesFraude__c VARIABLES_FRAUDE = 
				Fielo_VariablesFraude__c.getInstance('Fielo - Club Terpel');

    private static final Set<String> fCombCorriente = new Set<String>(
    			VARIABLES_FRAUDE.F_CodigosCombustibleCorriente__c.split(','));
    private static final Set<String> fCombExtra = new Set<String>(
    			VARIABLES_FRAUDE.F_CodigosCombustibleExtra__c.split(','));
    private static final Set<String> fCombDiesel = new Set<String>(
    			VARIABLES_FRAUDE.F_CodigosCombustibleDiesel__c.split(',')); 

	public static void tipoCombustible() {

		TriggerCheck.assert();

		Set<id> lIdVentaSet = new Set<id>();
		for(Fielo_ItemVenta__c ivt :(List<Fielo_ItemVenta__c>) trigger.new) {

			lIdVentaSet.add(ivt.F_Venta__c);
		}

		Map<Id,Fielo_Venta__c> lVentaMap = new Map<Id,Fielo_Venta__c>([
												SELECT F_OrigenVenta__c
												FROM Fielo_Venta__c 
												WHERE id IN :lIdVentaSet
												AND F_OrigenVenta__c = :ESTACION_DE_SERVICIO]);
		
		List<Fielo_Venta__c> lVentaLst = new List<Fielo_Venta__c>();
		for(Fielo_ItemVenta__c ivt :(List<Fielo_ItemVenta__c>) trigger.new) {

			Fielo_Venta__c lVentaAux = lVentaMap.get(ivt.F_Venta__c);
			if(lVentaAux != null) {

				if(fCombCorriente.contains(ivt.F_IdProducto__c)) {

					lVentaAux.F_TipoCombustible__c = CORRIENTE;
					lVentaLst.add(lVentaAux);
				}
				else if(fCombExtra.contains(ivt.F_IdProducto__c)) {

					lVentaAux.F_TipoCombustible__c = EXTRA;
					lVentaLst.add(lVentaAux);
				}
				else if(fCombDiesel.contains(ivt.F_IdProducto__c)) {

					lVentaAux.F_TipoCombustible__c = DIESEL;
					lVentaLst.add(lVentaAux);
				}
			}
		}

		if(!lVentaLst.isEmpty()) update lVentaLst;
	}
}