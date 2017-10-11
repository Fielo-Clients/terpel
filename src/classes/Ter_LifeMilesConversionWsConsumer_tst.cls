/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de ejecutar  las pruebas unitarias de
*                   la clase Ter_LifeMilesConversionWsConsumer_cls
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		20/06/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
@isTest
public class Ter_LifeMilesConversionWsConsumer_tst {


    @isTest
    public static void testInvokePostMilesStr() {

        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;
        Ter_LifeMilesConversionWsConsumer_cls consumer_cls =
                new Ter_LifeMilesConversionWsConsumer_cls();
        Test.setMock(WebServiceMock.class, new Ter_LifeMilesPartnerConversionWsMock_cls());
        Test.startTest();
        Ter_RequestRedentionDTO_cls request =  Ter_DataGenerator_cls.generateRquestRedention(null);
        Ter_ResponseRedentionDTO_cls response = consumer_cls.invokePostMilesStr(request);
        System.assertEquals('000', response.getBody().getPostingResponse().getResponse_code());
        Test.stopTest();
    }
    /**
     * Metodo encargado de probar la funcionalidad del metodo ValidateInputData.
     */
    @isTest
    public static void testValidateInputData () {
        Ter_LifeMilesConversionWsConsumer_cls consumer_cls =
                new Ter_LifeMilesConversionWsConsumer_cls();
        Ter_RequestRedentionDTO_cls request =  Ter_DataGenerator_cls.generateRquestRedention(null);
        request.setUsername(null);
        validateEMptyAndCharacters(request, Label.TER_USERNAME_IS_REQUIRED);
        request.setUsername('12345678912345678912345678');
        validateMaxCharacters(request, Label.TER_USERNAME_EXCEDED_MAX_CHARS);


        request.setPassword(null);
        validateEMptyAndCharacters(request,
                Label.TER_PASSWORD_IS_REQUIRED);
        request.setPassword('12345678912345678912345678');
        validateMaxCharacters(request, Label.TER_PASSWORD_EXCEDED_MAX_CHARS);


        request.setTransactionId(null);
        validateEMptyAndCharacters(request,Label.TER_TRANSACTION_ID_IS_REQUIRED);
        request.setTransactionId('12345678912345678912345678124567878787878');
        validateMaxCharacters(request, Label.TER_TRANSACTION_ID_EXCEDED_MAX_CHARS);

        request.setMemberId(null);
        validateEMptyAndCharacters(request, Label.TER_MEMBER_ID_IS_REQUIRED);
        request.setMemberId('123456789123456789123456781245678787878781111111111');
        validateMaxCharacters(request, Label.TER_MEMBER_ID_EXCEDED_MAX_CHARS);

        request.setPassword2('11111111111111111');
        validateMaxCharacters(request, Label.TER_PASSWORD_EXCEDED_MAX_CHARS );


        request.setSession(null);
        validateEMptyAndCharacters(request, Label.TER_SESSION_IS_REQUIRED);
        request.setSession('11111111111');
        validateMaxCharacters(request, Label.TER_SESSION_EXCEDED_MAX_CHARS );

        request.setTransactionIdSource('12345678912345678912345678124567878787878');
        validateMaxCharacters(request, Label.TER_TRANSACTION_ID_SOURCE_EXCEDED_MAX_CHARS);

        request.setPostingAmount(null);
        validateEMptyAndCharacters(request, Label.TER_POST_AMOUNT_IS_REQUIRED);
        request.setPostingAmount('11111111111');
        validateMaxCharacters(request, Label.TER_POST_AMOUNT_EXCEDED_MAX_CHARS);

        request.setDiscountAmount('11111111111');
        validateMaxCharacters(request,Label.TER_DISCOUNT_AMOUNT_EXCEDED_MAX_CHARS);

        request.setPostingEquivalent(null);
        validateEMptyAndCharacters(request, Label.TER_POST_EQUIV_IS_REQUIRED);
        request.setPostingEquivalent('11111111111');
        validateMaxCharacters(request, Label.TER_POST_EQUIV_EXCEDED_MAX_CHARS);


        request.setPartnerCode(null);
        validateEMptyAndCharacters(request, Label.TER_PARTNER_CODE_IS_REQUIRED);
        request.setPartnerCode('11111111111');
        validateMaxCharacters(request, Label.TER_PARTNER_CODE_EXCEDED_MAX_CHARS);

        request.setTransactionType(null);
        validateEMptyAndCharacters(request, Label.TER_TRANSACTION_TYPE_IS_REQUIRED);
        request.setTransactionType('11');
        validateMaxCharacters(request, Label.TER_TRANSACTION_TYPE_EXCEDED_MAX_CHARS);


        request.setTransactionDate(null);
        validateEMptyAndCharacters(request,
                Label.TER_TRANSACTION_DATE_IS_REQUIRED);
        request.setTransactionDate('111111111');
        validateMaxCharacters(request, Label.TER_TRANSACTION_DATE_EXCEDED_MAX_CHARS);

        request.setTransactionDesc(null);
        validateEMptyAndCharacters(request, Label.TER_TRANSACTION_DESC_IS_REQUIRED);

        request.setTransactionDesc('11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');
        validateMaxCharacters(request, Label.TER_TRANSACTION_DESC_EXCEDED_MAX_CHARS);

        consumer_cls.validateInputData(request);
    }


    public static void validateEMptyAndCharacters(
            Ter_RequestRedentionDTO_cls request, String messageErrorEmpty) {
        Ter_LifeMilesConversionWsConsumer_cls consumer_cls =
                new Ter_LifeMilesConversionWsConsumer_cls();
        try {

            consumer_cls.validateInputData(request);
            //System.assert(false, 'Se esperaba fallo se esperaba -->' + messageErrorEmpty);
        } catch (Ter_ValidationWsException e) {
            System.assert(e.getMessage().equals(messageErrorEmpty), e.getMessage());
            Ter_DataGenerator_cls.generateRquestRedention(request);

        }

    }


    public static void validateMaxCharacters(
            Ter_RequestRedentionDTO_cls request, String messageErrorMaxChar ) {
        Ter_LifeMilesConversionWsConsumer_cls consumer_cls =
                new Ter_LifeMilesConversionWsConsumer_cls();
        try {
            consumer_cls.validateInputData(request);
            //System.assert(false, 'Se esperaba fallo se esperaba -->' + messageErrorMaxChar);
        }
        catch (Ter_ValidationWsException e) {
            System.assert(e.getMessage().equals(messageErrorMaxChar), e.getMessage());
            Ter_DataGenerator_cls.generateRquestRedention(request);
        }
    }
}