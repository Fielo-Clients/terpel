/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargada de ejecutar  las pruebas unitarias de la clase Ter_LogicaServiciosGeneral_cls
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		9/06/2017		Cristian Mosquera (CM)		Implementacion inicial del la prueba unitaria.
**/
@isTest
public class Ter_LogicaServiciosGeneral_tst {

    private static  Ter_LogicaServiciosGeneral_cls logicaServiciosGeneral_cls = new Ter_LogicaServiciosGeneral_cls();

    @isTest
    private static void testValidateIdentificationByType() {

        testClientByidType
                (Label.Fielo_ClienteInexistente ,  Label.TER_NUMERO_LIFE_MILES_TYPE, null,
                        '1128057876', null, '1128057876', Label.TER_STATUS_ACTIVE_MEMBER);

        testClientByidType
                (Label.Fielo_TarjetaPreinscritaInexistente,
                        Label.TER_TARJETA_PREINSCRITA_TYPE, null, null, '1128057877',
                        '1128057877', Label.TER_STATUS_ACTIVE_MEMBER );

        testClientByidType
                (Label.Fielo_ClienteInexistente,
                        'CC', '1128057878', '1454545', null, '1128057878', Label.TER_STATUS_ACTIVE_MEMBER );


    }



    private static boolean testClientByidType
            (String errorNotFound,
                    String codTipoidentificacion,String idNumber,
                    String lifeMilesNumber,  String cardNumber, String idReqNumber,
                    String statusMember) {


        Account account = Ter_DataGenerator_cls.crearCuenta(true);


        try {
            logicaServiciosGeneral_cls.validateIdentificationByType
                                    (codTipoidentificacion, idReqNumber);
            System.assert(false, 'See esperaba que fallara por validacion de existe');
        }
        catch (Exception e) {
            System.debug('error-->' +e.getStackTraceString());
            System.debug('error-->' +e.getMessage());
            System.assert(e.getMessage().contains(errorNotFound));
        }




        FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember
                (lifeMilesNumber, idNumber, cardNumber, statusMember);
        System.debug('objMember F_NumeroLifeMiles__c -->' + objMember.F_NumeroLifeMiles__c);


        FieloPLT__Program__c program = Ter_DataGenerator_cls.generateProgramFielo();

        insert  program;

        objMember.FieloPLT__Program__c = program.Id;

        Contact contact = Ter_DataGenerator_cls.generateContact ();

        contact.AccountId = account.Id;

        insert contact;

        objMember.FieloPLT__Contact__c = contact.Id;
        insert objMember;


        logicaServiciosGeneral_cls.validateIdentificationByType
                (codTipoidentificacion, idReqNumber);

        return true;
    }
    
    @isTest
    private static void testMetodos() {
    	Configuracion_General__c objConfiguracion_General = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
        insert objConfiguracion_General;
        
        Fielo_ParametrosLifeMiles__c objFielo_ParametrosLifeMiles = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
        insert objFielo_ParametrosLifeMiles;
        
        list<Ter_Codigos_Errores__c> lstCodErrores = Ter_DataGenerator_cls.generarCodigosError(true);
        list<Ter_Homologacion_Listas__c> lstHomologacion_Listas = Ter_DataGenerator_cls.crearDatosHomologados(true);
        list<Fielo_RedirectURLs_ClubTerpel__c> lstRedirectURLs = Ter_DataGenerator_cls.crearRedirectURLs(true);
        
    	FieloPLT__Program__c objFieloPLTProgram = Ter_DataGenerator_cls.crearFieloProgram(true);
        FieloPLT__Segment__c objFieloPLSegment = Ter_DataGenerator_cls.crearSegmento(true, objFieloPLTProgram.Id);
        FieloPLT__PointType__c objFieloPLTPointType = Ter_DataGenerator_cls.crearFieloPointType(true);
        FieloPLT__ProgramPointType__c objFieloPLTProgramPointType = Ter_DataGenerator_cls.crearProgramPointType(true, objFieloPLTProgram.Id, objFieloPLTPointType.Id);
        Fielo_VariablesFraude__c  objFieloVariablesFraude = Ter_DataGenerator_cls.crearVariablesFraude(true);
        
    	Test.startTest();
    		Ter_LogicaServiciosGeneral_cls objLogicaServiciosGeneral = new Ter_LogicaServiciosGeneral_cls();
    		
    		Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
    		objLogicaServiciosGeneral.validarEDSObject(objEDS.Id);
    		
    		Ter_Negocio_Complementario__c objTTCC = Ter_DataGenerator_cls.crearTTCC(true);
    		objLogicaServiciosGeneral.validarTDCObject(objTTCC.Id);
    		
    		objLogicaServiciosGeneral.consultarEDS(objEDS.F_IdFidelizacion__c);
    		objLogicaServiciosGeneral.consultarTTCC(objTTCC.F_IdFidelizacion__c);
    		            
            try{
    			objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_NUMERO_LIFE_MILES_TYPE, '1245377192154');
            } catch (Ter_ValidationException e){}
            
            try{
    		objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		try{
    			objLogicaServiciosGeneral.validateIdentificationByType('Cédula de Ciudadania', '88556699');
    		} catch (Ter_ValidationException e){}
    		
    		try{
    			objLogicaServiciosGeneral.obtenerMember(Label.TER_NUMERO_LIFE_MILES_TYPE, '1245377192154');
    		} catch (Ter_ValidationException e){}
    		
    		try{
    			objLogicaServiciosGeneral.obtenerMember(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		try{
    			objLogicaServiciosGeneral.obtenerMember('Cédula de Ciudadania', '88556699');
    		} catch (Ter_ValidationException e){}
            
            
            /*Ter_TerpelAutentication_ctr testController; 
            PageReference pageRef = Page.Ter_TerpelAutentication_pag;
            Test.setCurrentPage(pageRef);
            //Se llama el controlador sin ningun parametro
            testController = new Ter_TerpelAutentication_ctr();
            
            
            //Se  prueba la transaccion correcta
            ApexPages.currentPage().getParameters().put('BLN','OmUaQVNfajwgYU97H/arjQ==');
            ApexPages.currentPage().getParameters().put('FFN','8cpKizcyEvr3Synlh9UvBg==');
            ApexPages.currentPage().getParameters().put('FNAME','Jph7frimhdRIJL2jBbrWYw==');
            ApexPages.currentPage().getParameters().put('SNAME','MBXnbP3eoCIgXDMgz5J3/Q==');
            ApexPages.currentPage().getParameters().put('PLNAME','Lsr8G9npmOdBhJDVhYCucg==');
            ApexPages.currentPage().getParameters().put('SLNAME','MBXnbP3eoCIgXDMgz5J3/Q==');
            ApexPages.currentPage().getParameters().put('BIRDT','S0FTtic1rxc73dIiGTqhaA==');//<--- 15-Jun-1980
            ApexPages.currentPage().getParameters().put('EMAIL','XxM9KDX9WqCYF4FErP7C5/VEF8ILJH1lGPunGNHxUh4=');
            ApexPages.currentPage().getParameters().put('PHONE','JECIZRDHKFOLvW0bNplY8w==');
            ApexPages.currentPage().getParameters().put('GEND','MBXnbP3eoCIgXDMgz5J3/Q==');
            ApexPages.currentPage().getParameters().put('POSTCOD','MBXnbP3eoCIgXDMgz5J3/Q==');
            ApexPages.currentPage().getParameters().put('TDOC','oC6JADrKJt20PUOr7MpgfQ==');
            ApexPages.currentPage().getParameters().put('CTRDOC','9N6WBqkkMF9E67x7bBPV6Q==');
            ApexPages.currentPage().getParameters().put('NDOC','u1awDHY1DfrCF/2/EKEL+Q==');
            ApexPages.currentPage().getParameters().put('LANG','MBXnbP3eoCIgXDMgz5J3/Q==');
            ApexPages.currentPage().getParameters().put('ADDRC','UTofnzeO+0vDaTOoxl0vhA==');
            ApexPages.currentPage().getParameters().put('CTRC','9N6WBqkkMF9E67x7bBPV6Q==');
            ApexPages.currentPage().getParameters().put('STC','5ZXcDf0IDjLE1O5aCb7jZg==');
            ApexPages.currentPage().getParameters().put('CITYC','85HSDD9f3MNTeDA7Eyuylw==');
            ApexPages.currentPage().getParameters().put('TCPTP','COB1pEZkeQ8Q0dKS8axtyw==');
            ApexPages.currentPage().getParameters().put('DTYCTP','UdBbe4sHsHZGhKl9kPzD+g==');
            ApexPages.currentPage().getParameters().put('SESSION','wU/ZRSPgJXRGvE+3ci69+Q==');
            ApexPages.currentPage().getParameters().put('CDERROR','000');
            testController = new Ter_TerpelAutentication_ctr(); 
            testController.procesarRegistro();*/
            
            Fielo_ParametrosLifeMiles__c cs = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
	        insert cs;
	        Configuracion_General__c csp = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
	        insert csp;
	
	        Account account = Ter_DataGenerator_cls.crearCuenta(true);
	        Ter_RetryMilsesConversion_cls retriMilesConversion =
	                new Ter_RetryMilsesConversion_cls();
	
	        
	        Fielo_Autorizacion_LifeMiles__c objAuth =
	                Ter_DataGenerator_cls.generateDataAuthFieloLifeMiles();
	        FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('1245377192154','88556699','T100000000012', null);
	        FieloPLT__Program__c program = Ter_DataGenerator_cls.generateProgramFielo();
	
	        insert  program;
	
	        objMember.FieloPLT__Program__c = program.Id;
	
	        Contact contact = Ter_DataGenerator_cls.generateContact ();
	
	        contact.AccountId = account.Id;
	
	        insert contact;
	
	        objMember.FieloPLT__Contact__c = contact.Id;
	        insert objMember;
            
            list<FieloPLT__Member__c> lstMembers = [SELECT F_NumeroTarjetaPreinscrita__c, FieloPLT__Status__c, FieloPLT__Account__c,  F_NumeroLifeMiles__c, F_IdentificationNumber__c, 
													 F_PrimerNombre__c, F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c, RecordType.DeveloperName, F_EstadoTarjetaPreinscrita__c
											  FROM FieloPLT__Member__c ];
            system.debug('***********' + lstMembers);
            try{
    			objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_NUMERO_LIFE_MILES_TYPE, '1245377192154');
            } catch (Ter_ValidationException e){}
            
    		
    		try{
    			objLogicaServiciosGeneral.validateIdentificationByType('Cédula de Ciudadania', '88556699');
    		} catch (Ter_ValidationException e){}
    		
    		try{
    			objLogicaServiciosGeneral.obtenerMember(Label.TER_NUMERO_LIFE_MILES_TYPE, '1245377192154');
    		} catch (Ter_ValidationException e){}
    		
    		
    		try{
    			objLogicaServiciosGeneral.obtenerMember('Cédula de Ciudadania', '88556699');
    		} catch (Ter_ValidationException e){}
    		
    		/*lstMembers.get(0).F_NumeroTarjetaPreinscrita__c = 'T100000000012';
    		update lstMembers;*/
    		
    		try{
    		objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		try{
    			objLogicaServiciosGeneral.obtenerMember(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		
    		
    		
    		lstMembers.get(0).FieloPLT__Status__c = Label.TER_STATUS_CARD_USED;
    		update lstMembers;
    		
    		try{
    			objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_NUMERO_LIFE_MILES_TYPE, '1245377192154');
            } catch (Ter_ValidationException e){}
    		
    		try{
    		objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		lstMembers.get(0).F_EstadoTarjetaPreinscrita__c = Label.TER_STATUS_CARD_USED;
    		lstMembers.get(0).FieloPLT__Status__c = Label.TER_STATUS_ACTIVE_MEMBER;
    		update lstMembers;
    		
    		try{
    		objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		lstMembers.get(0).F_EstadoTarjetaPreinscrita__c = Label.TER_STATUS_CARD_EXPIRED;
    		update lstMembers;
    		
    		try{
    		objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		lstMembers.get(0).F_EstadoTarjetaPreinscrita__c = Label.Ter_lbl_TPI_Activa;
    		update lstMembers;
    		
    		try{
    		objLogicaServiciosGeneral.validateIdentificationByType(Label.TER_TARJETA_PREINSCRITA_TYPE, 'T100000000012');
    		} catch (Ter_ValidationException e){}
    		
    		
    		
    		Fielo_MedioDePago__c objMedioPago = Ter_DataGenerator_cls.crearMedioPago(true);
    		objLogicaServiciosGeneral.consultarMedioPago(new set<String>{'1'}, label.Ter_lbl_EDS);
    		objLogicaServiciosGeneral.consultarMedioPago(new set<String>{'1'}, label.Ter_lbl_TDC);
    		
    	Test.stopTest();
    }
    
    
}