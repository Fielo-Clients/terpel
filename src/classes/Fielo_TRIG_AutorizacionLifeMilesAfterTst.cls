/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: JNS                   date: 07/08/2017
* 
* Name: Fielo_TRIG_AutorizacionLifeMilesAfterTst.cls
* 
* Class for test Fielo_TRIG_AutorizacionLifeMilesAfter
*
*******************************************************************************/
@isTest
private class Fielo_TRIG_AutorizacionLifeMilesAfterTst
{
    public final static String VENTA_TYPE_LIQUIDO_ID = RecType.getID('Fielo_Venta__c', 'Líquido');
    public final static String VENTA_TYPE_TIENDA_ID = RecType.getID('Fielo_Venta__c', 'Tienda');

    // Origin Venta
    public final static String TIENDA = 'Tienda';
    public final static String ESTACION_DE_SERVICIO = 'Estación de Servicio';

    @isTest
    static void lifeMilesCredito() {

      Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_ConversionWsConsumer_cls
                conversionWsConsumer_cls = new Ter_ConversionWsConsumer_cls();
        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls());        

      FieloPLT__Member__c LMemberCliente =  createMemberByAccount();

      Test.startTest();   

      system.runAs(LMemberCliente.FieloPLT__User__r) {
          Fielo_Autorizacion_LifeMiles__c lAutoLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
          lAutoLifeMiles.F_NumeroLifeMiles__c = '123456789ASD';
          lAutoLifeMiles.F_Estado__c = 'Pendiente';
          lAutoLifeMiles.F_TipoTransaccion__c = 'Crédito (C)';
          insert lAutoLifeMiles;
      }

      Test.stopTest();
    }

    @isTest
    static void lifeMilesDebito() {

        Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
        insert lVariablesFraude;

        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_ConversionWsConsumer_cls conversionWsConsumer_cls = new Ter_ConversionWsConsumer_cls();
        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls());        

        FieloPLT__Member__c lMb =  createMemberByAccount();
        
        Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
        insert lTasa;

        Ter_Estacion_de_Servicio__c lEstacion = SObjectForTest.getEstacionDeServicio();
        lEstacion.Ter_Propia__c = true;
        lEstacion.F_Reclama__c = true;
        lEstacion.F_Redime__c = true;
        lEstacion.F_Acumula__c = true;
        lEstacion.F_ClubTerpel__c = true;
        lEstacion.F_IdFidelizacion__c = 'fielo123';
        insert lEstacion;

        FieloCMS__Category__c lCategoria = new FieloCMS__Category__c();
        lCategoria.Name = 'Catálogo - No Habilitados';
        insert lCategoria;      

        FieloPLT__Reward__c lReward = new FieloPLT__Reward__c();
        lReward.FieloPLT__Program__c = lMb.FieloPLT__Program__c;
        system.debug('## prog id: ' + lMb.FieloPLT__Program__c);
        lReward.Name = 'Redención Presencial Líquidos';
        lReward.FieloPLT__StockManagement__c = 'Unlimited';
        lReward.Category__c = lCategoria.id;
        lReward.FieloPLT__Points__c = 0;
        insert lReward;

        Fielo_Venta__c lVenta = SObjectForTest.getVenta();
        lVenta.F_EstacionDeServicio__c = lEstacion.id;
        lVenta.F_Cliente__c = lMb.FieloPLT__Account__c;
        lVenta.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
        lVenta.F_OrigenVenta__c = ESTACION_DE_SERVICIO;
        lVenta.F_Member__c = lMb.Id;
        insert lVenta;

        Test.startTest();   

        system.runAs(lMb.FieloPLT__User__r) {
            Fielo_Autorizacion_LifeMiles__c lAutoLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
            lAutoLifeMiles.F_NumeroLifeMiles__c = '123456789ASD';
            lAutoLifeMiles.F_Estado__c = 'Aprobado';
            lAutoLifeMiles.F_TipoTransaccion__c = 'Débito (D)';
            lAutoLifeMiles.F_Venta__c = lVenta.id;
            lAutoLifeMiles.F_Member__c = lMb.Id;

            FieloPLT.SObjectService.enableAdminPermission(true);
            insert lAutoLifeMiles;
            FieloPLT.SObjectService.enableAdminPermission(false); 
        }

        Test.stopTest();
    }

    private static FieloPLT__Member__c createMemberByAccount() {

        FieloPLT__Program__c lPr = SObjectForTest.getProgram('teste');
        lPr.SiteUrl__c = '';
        insert lPr;

        Account lAcc = SObjectForTest.getAccount();

        insert lAcc;

        return [SELECT FieloPLT__Email__c, FieloPLT__User__c, FieloPLT__User__r.userName, 
                FieloPLT__Program__c, FieloPLT__Account__c
                FROM FieloPLT__Member__c 
                WHERE FieloPLT__Account__c = :lAcc.id];
    }
}