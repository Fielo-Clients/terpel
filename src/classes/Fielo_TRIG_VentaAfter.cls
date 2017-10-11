/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 24/05/2017
* 
* Name: Fielo_TRIG_VentaAfter.cls
* 
* Class for after event of Fielo Venta
*
*******************************************************************************/
public with sharing class Fielo_TRIG_VentaAfter {
    // Origin Venta
    public final static String TIENDA = 'Tienda';
    public final static String ESTACION_DE_SERVICIO = 'Estación de Servicio';

    // Type Combustible
    public final static String EXTRA = 'Extra';
    public final static String DIESEL = 'Diesel';
    public final static String CORRIENTE = 'Corriente';

    // Status Venta 
    public final static String PROCESAR = 'Procesar';
    public final static String APROBADA = 'Aprobada';
    public final static String RECHAZADA = 'Rechazada';
    public final static String REVERTIDA = 'Revertida';

    public static boolean ISRUNNING = false;
    

    // Custom Settings for Variables Fraude
    private static final Fielo_VariablesFraude__c VARIABLES_FRAUDE = 
                Fielo_VariablesFraude__c.getInstance('Fielo - Club Terpel');

    private static final Decimal MAX_GALONES_EXTRA = VARIABLES_FRAUDE.F_MaxGalonesExtra__c;
    private static final Decimal MAX_GALONES_DIESEL = VARIABLES_FRAUDE.F_MaxGalonesDiesel__c;
    private static final Decimal PERIODO_INFRACCIONES = VARIABLES_FRAUDE.F_PeriodoInfracciones__c;
    private static final Decimal MAX_GALONES_CORRIENTE = VARIABLES_FRAUDE.F_MaxGalonesCorriente__c;
    private static final Decimal MAX_MONTO_VENTA_TIENDA = VARIABLES_FRAUDE.F_MaxMontoVentaTienda__c;
    private static final Decimal MIN_TIEMPO_ENTRE_VENTAS = VARIABLES_FRAUDE.F_MinTiempoEntreVentas__c;
    private static final Decimal MAX_CANTIDAD_VENTAS_TIENDA = VARIABLES_FRAUDE.F_MaxCantidadVentasTienda__c;
    private static final Decimal MAX_CANTIDAD_VENTAS_LIQUIDO = VARIABLES_FRAUDE.F_MaxCantidadVentasLiquido__c;

    private static Decimal factorConversion {get{
                                    if(factorConversion == null){     
                                        List<Fielo_TasaConversion__c> lTasConLst = [
                                            SELECT F_FactorConversion__c   
                                            FROM Fielo_TasaConversion__c 
                                            WHERE F_ConversionMonedas__c = 'COP -> USD' 
                                            ORDER BY F_FechaFin__c DESC LIMIT 1];

                                        factorConversion = lTasConLst.size() > 0 ? lTasConLst.get(0).F_FactorConversion__c : null;                                                                                                                                                            
                                    }
                                    return factorConversion;
                                }}  

    public static void montosFidelizables() {

        TriggerCheck.assert();

        Map<Id,Fielo_Venta__c> lVentaTypeEstacionServMap = new Map<Id,Fielo_Venta__c>();
        Map<Id,Fielo_Venta__c> lVentaTypeTiendaMap = new Map<Id,Fielo_Venta__c>();

        // Search venta witch state is updated for the method fraud control
        for(Fielo_Venta__c vt :[SELECT F_Estado__c FROM Fielo_Venta__c WHERE id IN :trigger.newmap.keySet()]) {

            if( vt.F_Estado__c == PROCESAR  ) {
                Fielo_Venta__c lVentaAux = (Fielo_Venta__c) trigger.newmap.get(vt.id).clone(true, true, true, true);

                if( lVentaAux.F_OrigenVenta__c == ESTACION_DE_SERVICIO ) {
                    lVentaAux.F_Estado__c = APROBADA;
                    lVentaTypeEstacionServMap.put(lVentaAux.id, lVentaAux);
                }
                
                if( lVentaAux.F_OrigenVenta__c == TIENDA ) {
                    lVentaAux.F_Estado__c = APROBADA;
                    lVentaTypeTiendaMap.put(lVentaAux.id, lVentaAux);
                }   
            }
                         
        }

        if((lVentaTypeEstacionServMap.size() == 0) && (lVentaTypeTiendaMap.size() ==0)) return;
        
        for(AggregateResult ar: [SELECT F_Venta__c venta, sum(F_Cantidad__c) qtde
                                FROM Fielo_ItemVenta__c 
                                WHERE F_Venta__c IN :lVentaTypeEstacionServMap.keySet()
                                GROUP BY F_Venta__c]) {
            Fielo_Venta__c lVenta = lVentaTypeEstacionServMap.get(String.valueOf(ar.get('venta')));
            if(lVenta != null) {
                lVenta.F_LiquidoFidelizable__c = math.floor((Decimal)ar.get('qtde'));
                // Rule 1
                if( lVenta.F_TipoCombustible__c == CORRIENTE && 
                    lVenta.F_LiquidoFidelizable__c > MAX_GALONES_CORRIENTE ) {
                    
                    lVenta.F_LiquidoFidelizable__c = MAX_GALONES_CORRIENTE;
                }
                // Rule 2
                else if( lVenta.F_TipoCombustible__c == EXTRA && 
                    lVenta.F_LiquidoFidelizable__c  > MAX_GALONES_EXTRA) {

                    lVenta.F_LiquidoFidelizable__c  = MAX_GALONES_EXTRA;
                }
                // Rule 3
                else if( lVenta.F_TipoCombustible__c == DIESEL && 
                    lVenta.F_LiquidoFidelizable__c  > MAX_GALONES_DIESEL ) {
                    
                    lVenta.F_LiquidoFidelizable__c  = MAX_GALONES_DIESEL;
                }
            }           
        }  

        Map<Id, Decimal> lMontoNofidelizableMap = new Map<Id, Decimal>();
        for(AggregateResult ar: [SELECT F_Venta__c venta, sum(F_Monto__c) soma
                                FROM Fielo_MedioDePagoVenta__c 
                                WHERE F_Venta__c IN :lVentaTypeTiendaMap.keySet()
                                AND F_MedioDePago__r.F_Acumula__c = false
                                GROUP BY F_Venta__c]) {
            lMontoNofidelizableMap.put( (Id) ar.get('venta'), (Decimal) ar.get('soma'));        
        }

        for(Fielo_Venta__c vt :lVentaTypeTiendaMap.values()) {

            Decimal lMontoAux = lMontoNofidelizableMap.get(vt.id);
            if(lMontoAux == null) lMontoAux = 0;

            vt.F_MontoNoFidelizables__c = lMontoAux;
            vt.F_MontoFidelizable__c = vt.F_MontoTotal__c - vt.F_MontoNoFidelizables__c;

            // Rule 4
            if(vt.F_MontoFidelizable__c > MAX_MONTO_VENTA_TIENDA) {

                vt.F_MontoFidelizable__c = MAX_MONTO_VENTA_TIENDA;
            }                
            
            if(factorConversion != null) {
                vt.F_MontoFidelizableUSD__c = math.floor(vt.F_MontoFidelizable__c * factorConversion);
            }
            else {
                vt.F_MontoFidelizableUSD__c.addError('Error: Factor Conversion not found.');
            }
        }

        List<Fielo_Venta__c> lVentaToUpdateLst = new List<Fielo_Venta__c>();
        if(!lVentaTypeEstacionServMap.values().isEmpty())
            lVentaToUpdateLst.addAll(lVentaTypeEstacionServMap.values());

        if(!lVentaTypeTiendaMap.values().isEmpty())
            lVentaToUpdateLst.addAll(lVentaTypeTiendaMap.values());

        if(lVentaToUpdateLst.isEmpty()) return;

        update lVentaToUpdateLst;

        if ( Trigger.isInsert ) {
            // Send to process venta aprobada
            system.debug('Process Records Insert: ' + lVentaToUpdateLst);
            //FieloPLT.SObjectService.processRecords(lVentaToUpdateLst, null);  
        }
        else if ( Trigger.isUpdate ) {
            // Get old values from venta aprobada to Process Records
            Map<Id,Fielo_Venta__c> lVentaOldToProcessMap = new Map<Id,Fielo_Venta__c>();
            for(Fielo_Venta__c vt :lVentaToUpdateLst) {

                lVentaOldToProcessMap.put(vt.id, (Fielo_Venta__c)Trigger.oldmap.get(vt.id));
            }
            // Send to process venta aprobada
            //system.debug('Process Records new Update: ' + lVentaToUpdateLst);
            //FieloPLT.SObjectService.processRecords(lVentaToUpdateLst, null); 
            system.debug('Process Records old Update: ' + lVentaOldToProcessMap.values());
            //FieloPLT.SObjectService.processRecords(lVentaToUpdateLst, lVentaOldToProcessMap);  
        }
    }  

    public static void revertVenta() {

        TriggerCheck.assert();

        Set<Id> lIdVentaSet = new Set<Id>();
        for(Fielo_Venta__c vt :(List<Fielo_Venta__c>)trigger.new) {

            if(TriggerCheck.isChangedTo(vt, Fielo_Venta__c.F_Estado__c, REVERTIDA)) {                

                lIdVentaSet.add(vt.id);  
            }
        }

        if(lIdVentaSet.isEmpty()) return;

        List<Id> lTransactionIdsLst = new List<Id>();
        Map<Id,Id> lTransactionIdsMap = new Map<Id,Id>();
        for(FieloPLT__Transaction__c lTransaction : [SELECT Id, F_Venta__c 
                                                    FROM FieloPLT__Transaction__c 
                                                    WHERE F_Venta__c IN :lIdVentaSet]){

             lTransactionIdsMap.put(lTransaction.Id, lTransaction.F_Venta__c);
             lTransactionIdsLst.add(lTransaction.Id);
        }

        if(lTransactionIdsLst.isEmpty()) return;

        Map<Id,String> lResultsMap = FieloPLT.TransactionService.revertTransactions(lTransactionIdsLst);
        if(lResultsMap != null){
            for(Id lTransactionId : lResultsMap.keySet()){
                Fielo_Venta__c lVenta = (Fielo_Venta__c) trigger.newmap.get(lTransactionIdsMap.get(lTransactionId));
                if(lVenta != null) {
                    lVenta.addError('Error: ' + lResultsMap.get(lTransactionId));
                }
            }
        }
    }
}