/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de ejecutar las
*                   pruebas unitarias de la clase Ter_ConversionWsConsumer_cls
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		31/05/2017		Cristian Mosquera (CM)		Implementacion inicial de la prueba.
**/
@isTest
public class Ter_ConversionWsConsumer_tst {





    /**
     * Metodo encargado de probar la funcionalidad del metodo invokeMilesConversion(request, Map).
     */
    @isTest
    private static void testInvokeMilesConversionAuth() {
        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_ConversionWsConsumer_cls
                conversionWsConsumer_cls = new Ter_ConversionWsConsumer_cls();
        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls());

        Fielo_Autorizacion_LifeMiles__c objAuth =
                Ter_DataGenerator_cls.generateDataAuthFieloLifeMiles();
        //insert objAuth;
        Map<String, Fielo_Autorizacion_LifeMiles__c> mapauthLifeMiles =
                                new Map<String, Fielo_Autorizacion_LifeMiles__c>();
        mapauthLifeMiles.put('a0Q0v0000008xTZEAY', objAuth);
        Test.startTest();
        Ter_ConversionWsRequestDTO_cls request = Ter_DataGenerator_cls.generateRequestConversion(null);
        request.toString();
        request.setFieloAutorizacionLifeMilesId('a0Q0v0000008xTZEAY');
        Ter_ConversionWsResponseDTO_cls response =
                conversionWsConsumer_cls.invokeMilesConversion(request, mapauthLifeMiles);
        Test.stopTest();

        System.assertEquals('000', response.getResponseCode());
        System.assertEquals(50, response.getBonusMiles());
        System.assertEquals(1000, response.getConversionMiles());
        System.assertEquals('55545', response.getAuthoNum());
        System.assertEquals('123456', response.getLifeMilesNumber());
        System.assertEquals('554545', response.getMemberId());
        System.assertEquals('54545', response.getPrepurchaseTrans());
        System.assertEquals(300, response.getPromotionalMiles());
        System.assertEquals('19871030105410000010', response.getTransactionId());
        System.assertEquals('19871030105410000010', response.getTransactionIdSource());
        System.assertEquals('C', response.getTransactionType());

    }


    /**
     * Metodo encargado de probar la funcionalidad del metodo updateStatusAuthFielo.
     */
    @isTest static void testUpdateStatusAuthFielo() {
        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_ConversionWsConsumer_cls
                conversionWsConsumer_cls = new Ter_ConversionWsConsumer_cls();
        Fielo_Autorizacion_LifeMiles__c objAuth =
                    Ter_DataGenerator_cls.generateDataAuthFieloLifeMiles();
        conversionWsConsumer_cls.updateStatusAuthFielo(Label.TER_STATUS_RETRY_CONVERSION_WS, objAuth, '007');
                System.assertEquals(Label.TER_STATUS_RETRY_CONVERSION_WS, objAuth.F_Estado__c);
        System.assertEquals('007', objAuth.F_CodigoRespuestaLM__c);
        System.assertEquals(0, objAuth.F_ReintentosConexionLM__c);



        conversionWsConsumer_cls.updateStatusAuthFielo(Label.TER_STATUS_RETRY_CONVERSION_WS, objAuth, null);

        System.assertEquals(Label.TER_STATUS_RETRY_CONVERSION_WS, objAuth.F_Estado__c);
        System.assertEquals(1, objAuth.F_ReintentosConexionLM__c);

        for (integer i = 1; i <Integer.valueOf(Label.TER_MAX_RETRY_CONVERSION_WS); i++  ) {
            conversionWsConsumer_cls.updateStatusAuthFielo(Label.TER_STATUS_RETRY_CONVERSION_WS, objAuth, null);
        }

        System.assertEquals(Label.TER_STATUS_MAX_RETRY_CONVERSION_WS, objAuth.F_Estado__c);
        System.assertEquals(5, objAuth.F_ReintentosConexionLM__c);
    }

    /**
     * Metodo encargado de probar la funcionalidad del metodo validateInputData.
     */
    @isTest static void testValidateInputData() {
        Ter_ConversionWsConsumer_cls
                conversionWsConsumer_cls = new Ter_ConversionWsConsumer_cls();
        Ter_ConversionWsRequestDTO_cls request = Ter_DataGenerator_cls.generateRequestConversion(null);




        Ter_DataGenerator_cls.generateRequestConversion(request);

        try {
            request.setTransactionId('');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_ID_IS_REQUIRED, e.getMessage());
        }

        try {
            request.setTransactionId('444444444444444444444');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_ID_EXCEDED_MAX_CHARS, e.getMessage());
        }

        try {
            request.setTransactionId('4444444444444444444a');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_ID_INVALID_FORMAT, e.getMessage());
        }

        Ter_DataGenerator_cls.generateRequestConversion(request);


        try {
            request.setTransactionIdSource('444444444444444444444');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_ID_SOURCE_EXCEDED_MAX_CHARS, e.getMessage());
        }

        try {
            request.setTransactionIdSource('4444444444444444444s');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_ID_SOURCE_INVALID_FORMAT, e.getMessage());
        }

        Ter_DataGenerator_cls.generateRequestConversion(request);

        try {
            request.setMemberId('');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_MEMBER_ID_IS_REQUIRED, e.getMessage());
        }

        try {
            request.setMemberId('444444444444444444444444444444444444444445555555555');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_MEMBER_ID_EXCEDED_MAX_CHARS, e.getMessage());
        }

        Ter_DataGenerator_cls.generateRequestConversion(request);

        try {
            request.setTransactionType('');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_TYPE_IS_REQUIRED, e.getMessage());
        }

        try {
            request.setTransactionType('444');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_TYPE_EXCEDED_MAX_CHARS, e.getMessage());
        }

        try {
            request.setTransactionType('x');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_TRANSACTION_TYPE_INVALID_VALUE, e.getMessage());
        }

        Ter_DataGenerator_cls.generateRequestConversion(request);

       /* try {
            request.setPrepurchaseTrans('4444444');
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_PURSHASE_TRANS_EXCEDED_MAX_CHARS, e.getMessage());
        }*/

        Ter_DataGenerator_cls.generateRequestConversion(request);

        try {
            request.setConversionMiles(null);
            conversionWsConsumer_cls.validateInputData(request);
            System.assert(false, 'se esperaba un error');
        }
        catch(Ter_ValidationWsException e) {
            System.assertEquals(Label.TER_CONVERSION_MILES_IS_REQUIRED, e.getMessage());
        }


        Ter_DataGenerator_cls.generateRequestConversion(request);

        conversionWsConsumer_cls.validateInputData(request);
    }

}