/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de pruebas para el controlador Ter_LifemilesGuest_ctr
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class Ter_LifemilesGuest_tst {
    
    @isTest static void lifemilesGuest(){
		
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
		
		Test.startTest();
		
			Ter_LifemilesGuest_ctr testController; 
			PageReference pageRef = Page.Ter_LifemilesGuest_pag;
	        Test.setCurrentPage(pageRef);
	        //Se llama el controlador sin ningun parametro
	        testController = new Ter_LifemilesGuest_ctr();
	        
	        //Prueba con un codigo de error que no esta homologado
	        ApexPages.currentPage().getParameters().put('CDERROR','943');
	        testController = new Ter_LifemilesGuest_ctr();
	        
	        //Prueba con codigo error existente
	        ApexPages.currentPage().getParameters().put('CDERROR','001');
	        testController = new Ter_LifemilesGuest_ctr();
	        
	        //Prueba con todos los parametros pero con valores que no se pueden desencriptar
	        ApexPages.currentPage().getParameters().put('BLN','/arjQ==');
			ApexPages.currentPage().getParameters().put('FFN','==');
			ApexPages.currentPage().getParameters().put('FNAME','==');
			ApexPages.currentPage().getParameters().put('SNAME','/Q==');
			ApexPages.currentPage().getParameters().put('PLNAME','==');
			ApexPages.currentPage().getParameters().put('SLNAME','/Q==');
			ApexPages.currentPage().getParameters().put('BIRDT','+5A==');
			ApexPages.currentPage().getParameters().put('EMAIL','/MqJ0cDJk+=');
			ApexPages.currentPage().getParameters().put('PHONE','==');
			ApexPages.currentPage().getParameters().put('GEND','/Q==');
			ApexPages.currentPage().getParameters().put('POSTCOD','/Q==');
			ApexPages.currentPage().getParameters().put('TDOC','==');
			ApexPages.currentPage().getParameters().put('CTRDOC','==');
			ApexPages.currentPage().getParameters().put('NDOC','/2/EKEL+Q==');
			ApexPages.currentPage().getParameters().put('LANG','/Q==');
			ApexPages.currentPage().getParameters().put('ADDRC','+0vDaTOoxl0vhA==');
			ApexPages.currentPage().getParameters().put('CTRC','==');
			ApexPages.currentPage().getParameters().put('STC','==');
			ApexPages.currentPage().getParameters().put('CITYC','==');
			ApexPages.currentPage().getParameters().put('TCPTP','==');
			ApexPages.currentPage().getParameters().put('DTYCTP','+g==');
			ApexPages.currentPage().getParameters().put('SESSION','wU/+3ci69+Q==');
			ApexPages.currentPage().getParameters().put('CDERROR','000');
	        testController = new Ter_LifemilesGuest_ctr();
	        
	        //Se prueba con una fecha de nacimiento menor a 18 años
	        ApexPages.currentPage().getParameters().put('BLN','OmUaQVNfajwgYU97H/arjQ==');
			ApexPages.currentPage().getParameters().put('FFN','8cpKizcyEvr3Synlh9UvBg==');
			ApexPages.currentPage().getParameters().put('FNAME','Jph7frimhdRIJL2jBbrWYw==');
			ApexPages.currentPage().getParameters().put('SNAME','MBXnbP3eoCIgXDMgz5J3/Q==');
			ApexPages.currentPage().getParameters().put('PLNAME','Lsr8G9npmOdBhJDVhYCucg==');
			ApexPages.currentPage().getParameters().put('SLNAME','MBXnbP3eoCIgXDMgz5J3/Q==');
			ApexPages.currentPage().getParameters().put('BIRDT','pIXwqEbxRQWhqux8Re1rYw==');//<--- 15-Jun-2005
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
			testController = new Ter_LifemilesGuest_ctr();
			
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
			testController = new Ter_LifemilesGuest_ctr(); 
			testController.procesarRegistro();
			testController = new Ter_LifemilesGuest_ctr(); 
			
		Test.stopTest();
	}
    
}