/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                   date: 06/07/2017
* 
* Name: Fielo_TRIG_AutorizacionLifeMilesAfter.cls
* 
* Class for after event of Autorizacion LifeMiles object
*
*******************************************************************************/
public without sharing class Fielo_TRIG_AutorizacionLifeMilesAfter {

    // Origin Venta
    public final static String TIENDA = 'Tienda';
    public final static String ESTACION_DE_SERVICIO = 'Estación de Servicio';

	// Constants
    public final static String PENDIENTE = 'Pendiente';
    public final static String RECHAZADO = 'Rechazado';
    public final static String APROBADO = 'Aprobado';
    public final static String REINTENTAR = 'Reintentar';
    public final static String DEBITO = 'Débito (D)';

    public final static String OPEN = 'Open';
    public final static String CLOSED = 'Closed';    

    public final static String REDENCION_TIENDAS = 'Redención Presencial Tiendas';
    public final static String REDENCION_LIQUIDOS = 'Redención Presencial Líquidos';
    public final static String PRESENCIAL = 'Presencial';

	public static void execute() {

        TriggerCheck.assert();

        Set<Id> lAutorizacionLifeMilesSet = new Set<Id>();
        for(Fielo_Autorizacion_LifeMiles__c aut :(List<Fielo_Autorizacion_LifeMiles__c>)trigger.new) {

        	if(aut.F_Estado__c == PENDIENTE && String.isBlank(aut.F_Venta__c)) {

        		lAutorizacionLifeMilesSet.add(aut.id);
        	}
        }

		if(!lAutorizacionLifeMilesSet.isEmpty()) validateAutorizacionLifeMiles(lAutorizacionLifeMilesSet);
	}

	// Waiting for ajust
    @Future(callout=true)
    private static void validateAutorizacionLifeMiles( Set<Id> aIdAutorizacionLifeMilesSet ) {

        List<Fielo_Autorizacion_LifeMiles__c> lAutorizacionLifeMilesLst = [
            SELECT F_TipoTransaccion__c, F_NumeroLifeMiles__c, F_MillasBase__c, 
            F_MillasPromocionales__c, F_Estado__c, F_Member__c, F_IdTransaccion__c 
            FROM Fielo_Autorizacion_LifeMiles__c 
            WHERE id IN: aIdAutorizacionLifeMilesSet];

        Map<String, String> mapCodigosError = Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_Proceso_Acumulacion);

        Ter_ConversionWsConsumer_cls objConversionWsConsumer = new Ter_ConversionWsConsumer_cls();
        for(Fielo_Autorizacion_LifeMiles__c aut :lAutorizacionLifeMilesLst) {

            Ter_ConversionWsResponseDTO_cls objResponse;
            try{
                objResponse = objConversionWsConsumer.invokeMilesConversion(aut);
            } catch (Exception e) {
                //throw new Ter_AcumulacionException(label.Ter_lbl_Mensaje_Error_Acumulacion_LM);
                aut.F_Estado__c = REINTENTAR;
                continue;
            }            

            aut.F_CodigoRespuestaLM__c = objResponse.getResponseCode();

            if(!label.Ter_lbl_Codigo_Exito_Acumulacion_LM.equals(objResponse.getResponseCode())){
                aut.F_Estado__c = RECHAZADO;
                if(mapCodigosError.containsKey(objResponse.getResponseCode())){
                    //throw new Ter_AcumulacionException(mapCodigosError.get(objResponse.getResponseCode()));
                	aut.F_MotivoRechazo__c = mapCodigosError.get(objResponse.getResponseCode());
                } else{
                    //throw new Ter_AcumulacionException(label.Ter_lbl_Error_General_Acumulacion);
                    aut.F_MotivoRechazo__c = label.Ter_lbl_Error_General_Acumulacion;
                }
            }
            else {

                aut.F_NumeroAutorizacionLM__c = objResponse.getAuthoNum();
                aut.F_MillasBonus__c = objResponse.getBonusMiles();
                aut.F_Estado__c = APROBADO;
            }          
        }

        update lAutorizacionLifeMilesLst;
    }

    public static void autorizacionLifemilesDebito() {

        TriggerCheck.assert();

        Set<Id> lAutorizacionLifeMilesSet = new Set<Id>();
        Map<Id,FieloPLT__Redemption__c> lRedemptionMap = new Map<Id,FieloPLT__Redemption__c>();
        for(Fielo_Autorizacion_LifeMiles__c lAutorizacion :(List<Fielo_Autorizacion_LifeMiles__c>)trigger.new) {

            if(lAutorizacion.F_Estado__c == APROBADO && 
                    lAutorizacion.F_TipoTransaccion__c == DEBITO &&
                    String.isNotBlank(lAutorizacion.F_Venta__c)) {
                lAutorizacionLifeMilesSet.add(lAutorizacion.id);  
                lRedemptionMap.put(lAutorizacion.id, 
                                    new FieloPLT__Redemption__c(
                                        FieloPLT__Member__c = lAutorizacion.F_Member__c,
                                        F_AutorizacionLifeMiles__c = lAutorizacion.id, 
                                        FieloPLT__Status__c = OPEN,
                                        F_Tipo__c = PRESENCIAL
                                    )
                );              
            }
        }

        if(lRedemptionMap.isEmpty()) return;

        insert lRedemptionMap.values();

        Map<String,FieloPLT__Reward__c> lRewardMap = new Map<String,FieloPLT__Reward__c>();
        for(FieloPLT__Reward__c lReward :[SELECT Id, Name 
                                        FROM FieloPLT__Reward__c 
                                        WHERE NAME IN (:REDENCION_TIENDAS, :REDENCION_LIQUIDOS)]) {
            lRewardMap.put(lReward.Name, lReward);
        }

        List<FieloPLT__RedemptionItem__c> lRedemptionItemLst = new List<FieloPLT__RedemptionItem__c>();
        for(Fielo_Autorizacion_LifeMiles__c lAutorizacion :[SELECT F_Venta__r.F_OrigenVenta__c
                                                            FROM Fielo_Autorizacion_LifeMiles__c 
                                                            WHERE id IN: lAutorizacionLifeMilesSet]) {

            FieloPLT__Redemption__c lRedemption = lRedemptionMap.get(lAutorizacion.id);
            if(lRedemption != null) {
                FieloPLT__Reward__c lReward;
                if(lAutorizacion.F_Venta__r.F_OrigenVenta__c == ESTACION_DE_SERVICIO) {
                    lReward = lRewardMap.get(REDENCION_LIQUIDOS);
                    if(lReward == null) trigger.newMap.get(lAutorizacion.id).addError(REDENCION_LIQUIDOS + ' not found.');
                }
                else if(lAutorizacion.F_Venta__r.F_OrigenVenta__c == TIENDA) {
                    lReward = lRewardMap.get(REDENCION_TIENDAS);
                    if(lReward == null) trigger.newMap.get(lAutorizacion.id).addError(REDENCION_TIENDAS + ' not found.');                    
                }
                if(lReward != null) {
                    lRedemptionItemLst.add(new FieloPLT__RedemptionItem__c(
                            FieloPLT__Redemption__c = lRedemption.id,
                            FieloPLT__Reward__c = lReward.id,
                            //FieloPLT__Status__c = CLOSED,
                            FieloPLT__Quantity__c = 1
                        )
                    );
                }
            }            
        }
        system.debug('lRedemptionItemLst ' + lRedemptionItemLst);
        if(!lRedemptionItemLst.isEmpty()) insert lRedemptionItemLst;

        for(FieloPLT__Redemption__c lRedemption :lRedemptionMap.values()) {

            lRedemption.FieloPLT__Status__c = CLOSED;
        }
        FieloPLT.SObjectService.enableAdminPermission(true);
        update lRedemptionMap.values();

        for(FieloPLT__RedemptionItem__c lRedemptionItem :lRedemptionItemLst) {

            lRedemptionItem.FieloPLT__Status__c = CLOSED;
        }
        update lRedemptionItemLst;
        FieloPLT.SObjectService.enableAdminPermission(false);        
    }    
}