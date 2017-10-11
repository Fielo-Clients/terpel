/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terperl
* Description:		Classe encargada de ejecutar  las pruebas de la clase Ter_RetryMilsesConversion_cls
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		31/05/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase de prueba.
**/
@isTest
public class Ter_RetryMilsesConversion_tst {

    /**
     * Metodo encargado de realizar las pruebas unitarias del metodo execute.
     */
    @isTest
    private static void textExecute() {
        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;

        Account account = Ter_DataGenerator_cls.crearCuenta(true);
        Ter_RetryMilsesConversion_cls retriMilesConversion =
                new Ter_RetryMilsesConversion_cls();

        
        Fielo_Autorizacion_LifeMiles__c objAuth =
                Ter_DataGenerator_cls.generateDataAuthFieloLifeMiles();
        FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('5455','545544','5454', null);
        FieloPLT__Program__c program = Ter_DataGenerator_cls.generateProgramFielo();

        insert  program;

        objMember.FieloPLT__Program__c = program.Id;

        Contact contact = Ter_DataGenerator_cls.generateContact ();

        contact.AccountId = account.Id;

        insert contact;

        objMember.FieloPLT__Contact__c = contact.Id;
        insert objMember;


        objAuth.F_Estado__c = Label.TER_STATUS_RETRY_CONVERSION_WS;
        objAuth.F_Member__c = objMember.id;
        objAuth.F_NumeroLifeMiles__c = objMember.F_NumeroLifeMiles__c;
        insert objAuth;
        Test.startTest();
	        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls('000'));
	        retriMilesConversion.execute(null);
	        
        Test.stopTest();
        Fielo_Autorizacion_LifeMiles__c objAuthorizationFind =
            [SELECT ID, F_Estado__c, F_ReintentosConexionLM__c
                    FROM Fielo_Autorizacion_LifeMiles__c WHERE Id  = :objAuth.Id];
        //System.assertEquals(Label.TER_STATUS_SUCESS_CONVERSION_WS, objAuthorizationFind.F_Estado__c);
    }
    
    @isTest
    private static void textExecute2() {
        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;

        Account account = Ter_DataGenerator_cls.crearCuenta(true);
        Ter_RetryMilsesConversion_cls retriMilesConversion =
                new Ter_RetryMilsesConversion_cls();

        
        Fielo_Autorizacion_LifeMiles__c objAuth =
                Ter_DataGenerator_cls.generateDataAuthFieloLifeMiles();
        FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('5455','545544','5454', null);
        FieloPLT__Program__c program = Ter_DataGenerator_cls.generateProgramFielo();

        insert  program;

        objMember.FieloPLT__Program__c = program.Id;

        Contact contact = Ter_DataGenerator_cls.generateContact ();

        contact.AccountId = account.Id;

        insert contact;

        objMember.FieloPLT__Contact__c = contact.Id;
        insert objMember;


        objAuth.F_Estado__c = Label.TER_STATUS_RETRY_CONVERSION_WS;
        objAuth.F_Member__c = objMember.id;
        objAuth.F_NumeroLifeMiles__c = objMember.F_NumeroLifeMiles__c;
        insert objAuth;
        Test.startTest();
	        
	        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls('010'));
	        retriMilesConversion.execute(null);
	        
        Test.stopTest();
        Fielo_Autorizacion_LifeMiles__c objAuthorizationFind =
            [SELECT ID, F_Estado__c, F_ReintentosConexionLM__c
                    FROM Fielo_Autorizacion_LifeMiles__c WHERE Id  = :objAuth.Id];
        //System.assertEquals(Label.TER_STATUS_SUCESS_CONVERSION_WS, objAuthorizationFind.F_Estado__c);
    }
    
    @isTest
    private static void textExecute3() {
        Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert cs;
        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert csp;

        Account account = Ter_DataGenerator_cls.crearCuenta(true);
        Ter_RetryMilsesConversion_cls retriMilesConversion =
                new Ter_RetryMilsesConversion_cls();

        
        Fielo_Autorizacion_LifeMiles__c objAuth =
                Ter_DataGenerator_cls.generateDataAuthFieloLifeMiles();
        FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('5455','545544','5454', null);
        FieloPLT__Program__c program = Ter_DataGenerator_cls.generateProgramFielo();

        insert  program;

        objMember.FieloPLT__Program__c = program.Id;

        Contact contact = Ter_DataGenerator_cls.generateContact ();

        contact.AccountId = account.Id;

        insert contact;

        objMember.FieloPLT__Contact__c = contact.Id;
        insert objMember;


        objAuth.F_Estado__c = Label.TER_STATUS_RETRY_CONVERSION_WS;
        objAuth.F_Member__c = objMember.id;
        objAuth.F_NumeroLifeMiles__c = objMember.F_NumeroLifeMiles__c;
        insert objAuth;
        Test.startTest();
	        Test.setMock(WebServiceMock.class, new Ter_ConversionWsMock_cls('XXX'));
	        retriMilesConversion.execute(null);
        Test.stopTest();
        Fielo_Autorizacion_LifeMiles__c objAuthorizationFind =
            [SELECT ID, F_Estado__c, F_ReintentosConexionLM__c
                    FROM Fielo_Autorizacion_LifeMiles__c WHERE Id  = :objAuth.Id];
        //System.assertEquals(Label.TER_STATUS_SUCESS_CONVERSION_WS, objAuthorizationFind.F_Estado__c);
    }


}