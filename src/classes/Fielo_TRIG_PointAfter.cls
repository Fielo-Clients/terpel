/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 25/05/2017
* 
* Name: Fielo_TRIG_PointAfter.cls
* 
* Class for after event of Fielo Point
*
*******************************************************************************/
public without sharing class Fielo_TRIG_PointAfter {

    private static Decimal factorConversion {get{
                                    if(factorConversion == null){     
                                        List<Fielo_TasaConversion__c> lTasConLst = [
                                            SELECT F_FactorConversion__c 
                                            FROM Fielo_TasaConversion__c 
                                            WHERE F_ConversionMonedas__c = 'USD -> COP'
                                            ORDER BY F_FechaFin__c DESC LIMIT 1];

                                        factorConversion = lTasConLst.size() > 0 ? lTasConLst.get(0).F_FactorConversion__c : null;                                                                                                                                                            
                                    }
                                    return factorConversion;
                                }}  

    public static void presupuestoPromotion() {
        
        TriggerCheck.assert();

        Map<Id,FieloPLT__Point__c> lPointsMap = (Map<Id,FieloPLT__Point__c>) trigger.newmap;

        List<FieloPLT__Point__c> lPointsLst = [
            SELECT FieloPLT__Rule__c, FieloPLT__PointType__c, 
                FieloPLT__Rule__r.FieloPLT__Promotion__c, 
                FieloPLT__PointType__r.F_TarifaMillaUSD__c, FieloPLT__TotalPoints__c,
                FieloPLT__Transaction__r.FieloPLT__Type__c, FieloPLT__Redemption__c 
            FROM FieloPLT__Point__c 
            WHERE id IN :lPointsMap.keySet()
            AND FieloPLT__Redemption__c = null
            AND FieloPLT__Transaction__r.FieloPLT__IsReverted__c = false
            AND FieloPLT__Transaction__r.FieloPLT__Type__c NOT IN ('Reversion')];

        if(lPointsLst.isEmpty()) return;

        Set<Id> lIdPromotionSet = new Set<Id>();
        for(FieloPLT__Point__c pt :lPointsLst) {

            if(pt.FieloPLT__Rule__c != null && pt.FieloPLT__Rule__r.FieloPLT__Promotion__c != null) {
                
                lIdPromotionSet.add(pt.FieloPLT__Rule__r.FieloPLT__Promotion__c);
            }
            else {
                if(!test.isRunningTest()) {
                    lPointsMap.get(pt.id).addError('Error: Rule or Promotion not found in Point.');
                }                
            }
        }

        Map<Id,FieloPLT__Promotion__c> lPromotionMap = new Map<Id,FieloPLT__Promotion__c>([
            SELECT id, F_Presupuesto__c, F_MontoConsumido__c, F_PresupuestoConsumido__c 
            FROM FieloPLT__Promotion__c 
            WHERE id IN :lIdPromotionSet]);

        if(lPromotionMap.isEmpty()) return;

        for(FieloPLT__Point__c pt :lPointsLst) {
            
            if(pt.FieloPLT__PointType__c != null) {
                FieloPLT__Promotion__c lPromoAux = lPromotionMap.get(pt.FieloPLT__Rule__r.FieloPLT__Promotion__c);
                if(lPromoAux != null) {

                    if(factorConversion != null) 
                        lPromoAux.F_MontoConsumido__c += Math.Ceil(pt.FieloPLT__TotalPoints__c * pt.FieloPLT__PointType__r.F_TarifaMillaUSD__c * factorConversion);
                    else 
                        lPromoAux.F_MontoConsumido__c.addError('Error: Factor Conversion not found.');

                    lPromoAux.F_PresupuestoConsumido__c = lPromoAux.F_MontoConsumido__c * 100 / lPromoAux.F_Presupuesto__c;
                }
            }
            else  {
                lPointsMap.get(pt.id).addError('Error: Point Type not found in Point.');
            }
        }

        FieloPLT.SObjectService.enableAdminPermission(true);
        if(!lPromotionMap.values().isEmpty()) update lPromotionMap.values();
        FieloPLT.SObjectService.enableAdminPermission(false); 
    }
}