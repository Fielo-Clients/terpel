/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de pruebas para el controlador Ter_Encriptar_ctr
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    30/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class Ter_Encriptar_tst {
	
	@isTest static void utilidades(){
		
		Configuracion_General__c objConfiguracion_General = Ter_DataGenerator_cls.generateCustomSettingsGeneral();
		insert objConfiguracion_General;
		
		Fielo_ParametrosLifeMiles__c objFielo_ParametrosLifeMiles = Ter_DataGenerator_cls.generateCustomSettingsLifeMiles();
		insert objFielo_ParametrosLifeMiles;
		
		Test.startTest();
			Ter_Encriptar_ctr testController; 
			PageReference pageRef = Page.Ter_Encriptar_pag;
	        Test.setCurrentPage(pageRef);
	        //Se llama el controlador sin ningun parametro
	        testController = new Ter_Encriptar_ctr();
	        
	        testController.strFfn = 'XXXX';
			testController.strFname = 'XXXX';
			testController.strSname = 'XXXX';
			testController.strPlname = 'XXXX';
			testController.strSlname = 'XXXX';
			testController.strBirdt = 'XXXX';
			testController.strEmail = 'XXXX';
			testController.strPhone = 'XXXX';
			testController.strGend = 'XXXX';
			testController.strPostcod = 'XXXX';
			testController.strTdoc = 'XXXX';
			testController.strCtrdoc = 'XXXX';
			testController.strNdoc = 'XXXX';
			testController.strLang = 'XXXX';
			testController.strAddrc = 'XXXX';
			testController.strCtrc = 'XXXX';
			testController.strStc = 'XXXX';
			testController.strCityc = 'XXXX';
			testController.strTyctp = 'XXXX';
			testController.strDtyctp = 'XXXX';
			testController.strSession = 'XXXX';
			testController.strBln = 'XXXX';
			testController.strCderror = 'XXXX';
			
			testController.encriptar();
		Test.stopTest();
	}
    
}