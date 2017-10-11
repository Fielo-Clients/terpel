/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 07/06/2017
* 
* Name: Fielo_Simulador.cls
* 
* Class API Rest for points simulator
*
*******************************************************************************/
public with sharing class Fielo_Simulador {

    // Type Combustible
    public final static String EXTRA = 'Extra';
    public final static String DIESEL = 'Diesel';
    public final static String CORRIENTE = 'Corriente';

    // Origin Venta
    public final static String TIENDA = 'Tienda';
    public final static String ESTACION_DE_SERVICIO = 'Estación de Servicio';

    // Status Venta 
    public final static String PROCESAR = 'Procesar';
    public final static String RECHAZADA = 'Rechazada';
    public final static String APROBADA = 'Aprobada';

    // Tipo de Transacción Venta 
    public final static String ACUMULACION = 'Acumulación';    

    // Custom Settings for Variables Fraude
    private static final Fielo_VariablesFraude__c VARIABLES_FRAUDE = 
                Fielo_VariablesFraude__c.getInstance('Fielo - Club Terpel');

    private static final Set<String> fCombCorriente = new Set<String>(
        VARIABLES_FRAUDE.F_CodigosCombustibleCorriente__c.split(','));
    private static final Set<String> fCombExtra = new Set<String>(
        VARIABLES_FRAUDE.F_CodigosCombustibleExtra__c.split(','));
    private static final Set<String> fCombDiesel = new Set<String>(
        VARIABLES_FRAUDE.F_CodigosCombustibleDiesel__c.split(',')); 

    private static final Decimal MAX_GALONES_EXTRA = VARIABLES_FRAUDE.F_MaxGalonesExtra__c;
    private static final Decimal MAX_GALONES_DIESEL = VARIABLES_FRAUDE.F_MaxGalonesDiesel__c;
    private static final Decimal PERIODO_INFRACCIONES = VARIABLES_FRAUDE.F_PeriodoInfracciones__c;
    private static final Decimal MAX_GALONES_CORRIENTE = VARIABLES_FRAUDE.F_MaxGalonesCorriente__c;
    private static final Decimal MAX_MONTO_VENTA_TIENDA = VARIABLES_FRAUDE.F_MaxMontoVentaTienda__c;
    private static final Decimal MIN_TIEMPO_ENTRE_VENTAS = VARIABLES_FRAUDE.F_MinTiempoEntreVentas__c;
    private static final Decimal MAX_CANTIDAD_VENTAS_TIENDA = VARIABLES_FRAUDE.F_MaxCantidadVentasTienda__c;
    private static final Decimal MAX_CANTIDAD_VENTAS_LIQUIDO = VARIABLES_FRAUDE.F_MaxCantidadVentasLiquido__c;
    
    public static Map<String,List<SObject>> SimularVenta(Fielo_Venta__c aVenta, 
                                            List<Fielo_ItemVenta__c> aItemVentaLst, 
                                            List<Fielo_MedioDePagoVenta__c> aMedioPagtoVentaLst) {

        system.debug('aVenta ' + aVenta);
        system.debug('aItemVentaLst ' + aItemVentaLst);
        system.debug('aMedioPagtoVentaLst ' + aMedioPagtoVentaLst);

        system.debug('VARIABLES_FRAUDE ' + VARIABLES_FRAUDE);

        List<Fielo_InfraccionFraude__c> lInfracFraudeLst = new List<Fielo_InfraccionFraude__c>();
        Map<String,List<SObject>> lResponseMap = new Map<String,List<SObject>>();

        // Get ventas in same day
        for(AggregateResult ar :[SELECT count(Id) qtde
                                FROM Fielo_Venta__c 
                                WHERE F_Member__c = :aVenta.F_Member__c
                                AND F_OrigenVenta__c = :aVenta.F_OrigenVenta__c
                                AND CALENDAR_YEAR(F_FechaTransaccion__c) = :aVenta.F_FechaTransaccion__c.year()
                                AND CALENDAR_MONTH(F_FechaTransaccion__c) = :aVenta.F_FechaTransaccion__c.month()
                                AND DAY_IN_MONTH(F_FechaTransaccion__c) = :aVenta.F_FechaTransaccion__c.day()
                                GROUP BY F_Member__c]) {
            
            Decimal lQtdeTipo = 0;
            if(aVenta.F_OrigenVenta__c == TIENDA) {

                lQtdeTipo = MAX_CANTIDAD_VENTAS_TIENDA;
            }
            else if(aVenta.F_OrigenVenta__c == ESTACION_DE_SERVICIO) {

                lQtdeTipo = MAX_CANTIDAD_VENTAS_LIQUIDO;
            }
            // Get total ventas in base and more one of test
            if(((Decimal)ar.get('qtde')) >= lQtdeTipo) {

                aVenta.F_Estado__c = RECHAZADA;
                aVenta.F_MotivoRechazo__c = Label.Fielo_InfraccionMaximaCantidadVentas;

                lInfracFraudeLst.add( new Fielo_InfraccionFraude__c(
                    F_Member__c = aVenta.F_Member__c,
                    //F_Venta__c = aVenta.id,
                    F_Descripcion__c = Label.Fielo_InfraccionMaximaCantidadVentas 
                ));
                lResponseMap.put('Fielo_Venta__c', new List<Fielo_Venta__c>{aVenta});
                lResponseMap.put('Fielo_InfraccionFraude__c', lInfracFraudeLst);
                return lResponseMap;
            }
        }

        for(Fielo_Venta__c vt :[SELECT F_FechaTransaccion__c, F_Member__c 
                                FROM Fielo_Venta__c 
                                WHERE F_Member__c = :aVenta.F_Member__c
                                AND F_FechaTransaccion__c <= :aVenta.F_FechaTransaccion__c
                                AND F_Estado__c = :APROBADA
                                ORDER BY F_FechaTransaccion__c DESC LIMIT 1]) {

            Long seconds = (aVenta.F_FechaTransaccion__c.getTime() - vt.F_FechaTransaccion__c.getTime()) / 1000;
            // if update old venta
            if(seconds < 0) seconds *= (-1);
            // Rule 7
            system.debug('seconds ' + seconds);
            system.debug('MIN_TIEMPO_ENTRE_VENTAS ' + MIN_TIEMPO_ENTRE_VENTAS);
            if(seconds < MIN_TIEMPO_ENTRE_VENTAS) {    

                aVenta.F_Estado__c = RECHAZADA;
                aVenta.F_MotivoRechazo__c = Label.Fielo_InfraccionMinimoTiempoEntreVentas;
                
                lInfracFraudeLst.add( new Fielo_InfraccionFraude__c(
                    F_Member__c = aVenta.F_Member__c,
                    //F_Venta__c = aVenta.id,
                    F_Descripcion__c = Label.Fielo_InfraccionMinimoTiempoEntreVentas 
                ));
                lResponseMap.put('Fielo_Venta__c', new List<Fielo_Venta__c>{aVenta});
                lResponseMap.put('Fielo_InfraccionFraude__c', lInfracFraudeLst);
                return lResponseMap;
            }     
        }
        
        if( aVenta.F_OrigenVenta__c == ESTACION_DE_SERVICIO ) {


            if(aItemVentaLst.size() > 0 ) {
                if(fCombCorriente.contains(aItemVentaLst[0].F_IdProducto__c)) {

                    aVenta.F_TipoCombustible__c = CORRIENTE;
                }
                else if(fCombExtra.contains(aItemVentaLst[0].F_IdProducto__c)) {

                    aVenta.F_TipoCombustible__c = EXTRA;
                }
                else if(fCombDiesel.contains(aItemVentaLst[0].F_IdProducto__c)) {

                    aVenta.F_TipoCombustible__c = DIESEL;
                }
            }

            Decimal lItemVenta = 0;
            for(Fielo_ItemVenta__c ivt :aItemVentaLst) {
                
                lItemVenta += ivt.F_Cantidad__c;                        
            }
            aVenta.F_LiquidoFidelizable__c = math.floor(lItemVenta);
            if(aVenta.F_LiquidoFidelizable__c == null) aVenta.F_LiquidoFidelizable__c = 0;
            Boolean lErrorMaxLiquid = false;
            // Rule 1
            if( aVenta.F_TipoCombustible__c == CORRIENTE && 
                aVenta.F_LiquidoFidelizable__c > MAX_GALONES_CORRIENTE ) {
                
                aVenta.F_LiquidoFidelizable__c = MAX_GALONES_CORRIENTE;
                lErrorMaxLiquid = true;
            }
            // Rule 2
            else if( aVenta.F_TipoCombustible__c == EXTRA && 
                aVenta.F_LiquidoFidelizable__c  > MAX_GALONES_EXTRA) {

                aVenta.F_LiquidoFidelizable__c  = MAX_GALONES_EXTRA;
                lErrorMaxLiquid = true;
            }
            // Rule 3
            else if( aVenta.F_TipoCombustible__c == DIESEL && 
                aVenta.F_LiquidoFidelizable__c  > MAX_GALONES_DIESEL ) {
                
                aVenta.F_LiquidoFidelizable__c  = MAX_GALONES_DIESEL;
                lErrorMaxLiquid = true;
            }

            if(lErrorMaxLiquid) {

                lInfracFraudeLst.add( new Fielo_InfraccionFraude__c(
                    F_Member__c = aVenta.F_Member__c,
                    //F_Venta__c = aVenta.id,
                    F_Descripcion__c = Label.Fielo_InfraccionMaximaCantidadLiquido 
                ));
            }
        }

        if( aVenta.F_OrigenVenta__c == TIENDA ) {            

            aVenta.F_MontoNoFidelizables__c = 0;
            if(aMedioPagtoVentaLst.size() > 0) {

                Set<Id> lIdMedioDePagoSet = new Set<Id>();
                for(Fielo_MedioDePagoVenta__c lMedioDePagoVenta :aMedioPagtoVentaLst) {
                    
                    if(lMedioDePagoVenta.F_MedioDePago__c != null) {
                        lIdMedioDePagoSet.add(lMedioDePagoVenta.F_MedioDePago__c);  
                    }                                                          
                }

                // Return only Medio de Pago with Acumula equal false
                Map<Id,Fielo_MedioDePago__c> lMedioDePagoMap = new Map<Id,Fielo_MedioDePago__c>([
                    SELECT F_Acumula__c 
                    FROM Fielo_MedioDePago__c 
                    WHERE id IN :lIdMedioDePagoSet AND F_Acumula__c = false]);

                if(lMedioDePagoMap.size() > 0) {
                    for(Fielo_MedioDePagoVenta__c lMedioDePagoVenta :aMedioPagtoVentaLst) {

                        Fielo_MedioDePago__c lMedioDePago = lMedioDePagoMap.get(lMedioDePagoVenta.F_MedioDePago__c);
                        if(lMedioDePago != null) {                        
                            aVenta.F_MontoNoFidelizables__c += lMedioDePagoVenta.F_Monto__c;                  
                        }                                         
                    }
                }                
            }

            aVenta.F_MontoFidelizable__c = aVenta.F_MontoTotal__c - aVenta.F_MontoNoFidelizables__c;

            // Rule 4
            if(aVenta.F_MontoFidelizable__c > MAX_MONTO_VENTA_TIENDA) {

                aVenta.F_MontoFidelizable__c = MAX_MONTO_VENTA_TIENDA;

                lInfracFraudeLst.add( new Fielo_InfraccionFraude__c(
                    F_Member__c = aVenta.F_Member__c,
                    //F_Venta__c = aVenta.id,
                    F_Descripcion__c = Label.Fielo_InfraccionMaximoMontoTienda 
                ));
            }

            List<Fielo_TasaConversion__c> lTasaConversionLst = [SELECT F_FactorConversion__c   
                                                                FROM Fielo_TasaConversion__c 
                                                                WHERE F_ConversionMonedas__c = 'COP -> USD' 
                                                                ORDER BY F_FechaFin__c DESC LIMIT 1];               
            
            if(lTasaConversionLst.size() > 0) {
                aVenta.F_MontoFidelizableUSD__c = math.floor(aVenta.F_MontoFidelizable__c * lTasaConversionLst[0].F_FactorConversion__c);
            }
            else {
                aVenta.F_Estado__c = RECHAZADA;
                aVenta.F_MotivoRechazo__c = Label.Fielo_ProcesarVentaConversionError;
                lResponseMap.put('Fielo_Venta__c', new List<Fielo_Venta__c>{aVenta});
                return lResponseMap;
            }      
        }
        if(aVenta.F_Estado__c != RECHAZADA) {
            aVenta.F_Estado__c = APROBADA;

            if(aVenta.F_TipoTransaccion__c == ACUMULACION)  {
                aVenta.F_RuleTrigger__c = aVenta.F_TipoTransaccion__c + aVenta.F_Estado__c;
            }
        }
              

        Map<String,List<SObject>> lSimulateVenta;
        try{
            // Store id of venta, method processRecordsSimulator change/create id
            Id lIdVenta = aVenta.id;
            //Building the final response            
            lSimulateVenta = FieloPLT.SobjectService.processRecordsSimulator(new List<Fielo_Venta__c>{aVenta} , null, new Set<Id>{aVenta.F_Member__c});    
            aVenta.id = lIdVenta;             
        }
        catch(Exception e){
            aVenta.F_Estado__c = RECHAZADA;
            aVenta.F_MotivoRechazo__c = e.getMessage();
            lResponseMap.put('Fielo_Venta__c', new List<Fielo_Venta__c>{aVenta});
            return lResponseMap;
        }

        //Completes the fields 
        Decimal lMillasBase = 0;
        Decimal lMillasPromocionales = 0;
        List<FieloPLT__Point__c> lPointsLst;
        if(lSimulateVenta.KeySet().Size() > 0){
            if(lSimulateVenta.ContainsKey('FieloPLT__Point__c')){

                List<FieloPLT__Point__c> lPontosLst = (List<FieloPLT__Point__c>)lSimulateVenta.get('FieloPLT__Point__c');
                Set<Id> lRuleSet = new Set<Id>();
                for(FieloPLT__Point__c pt :lPontosLst) {
                    lRuleSet.add(pt.FieloPLT__Rule__c);
                }

                Map<Id,FieloPLT__Rule__c> lRuleMap = new Map<Id,FieloPLT__Rule__c>([SELECT FieloPLT__Promotion__r.F_Default__c FROM FieloPLT__Rule__c WHERE id IN :lRuleSet]);
                
                for (FieloPLT__Point__c pt :lPontosLst) {
                    
                    FieloPLT__Rule__c lRule = lRuleMap.get(pt.FieloPLT__Rule__c);                    
                    if(lRule != null) {
                        if(lRule.FieloPLT__Promotion__r.F_Default__c) {

                            lMillasBase += pt.FieloPLT__TotalPoints__c;
                        }
                        else {
                            lMillasPromocionales += pt.FieloPLT__TotalPoints__c;
                        }
                    }
                }                        
            }
        }
        lResponseMap.put('Fielo_Venta__c', new List<Fielo_Venta__c>{aVenta});
        lResponseMap.put('Fielo_InfraccionFraude__c', lInfracFraudeLst);
        lResponseMap.put('Fielo_Autorizacion_LifeMiles__c', new List<Fielo_Autorizacion_LifeMiles__c>{
            new Fielo_Autorizacion_LifeMiles__c(
                F_MillasBase__c = lMillasBase,
                F_MillasPromocionales__c = lMillasPromocionales
                //F_Venta__c = aVenta.id
            )
        });
        system.debug('lResponseMap ' + lResponseMap);
        return lResponseMap; 
    }
}