/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de pruebas para las clases de utilidades
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class Ter_Case_tst {
    
    @isTest static void casos(){
        
        Account objCuentaAux = Ter_DataGenerator_cls.crearCuenta(true);
        
        FieloPLT__Program__c objFieloPLTProgram = Ter_DataGenerator_cls.crearFieloProgram(true);
        FieloPLT__Segment__c objFieloPLSegment = Ter_DataGenerator_cls.crearSegmento(true, objFieloPLTProgram.Id);
        FieloPLT__PointType__c objFieloPLTPointType = Ter_DataGenerator_cls.crearFieloPointType(true);
        FieloPLT__ProgramPointType__c objFieloPLTProgramPointType = Ter_DataGenerator_cls.crearProgramPointType(true, objFieloPLTProgram.Id, objFieloPLTPointType.Id);
        
        
        Test.startTest();
            Case objCaso = new Case();
            objCaso.AccountId = objCuentaAux.Id;
            //objCaso.ContactId = objCuentaAux.Id;
            objCaso.Status = 'New';
            objCaso.Origin = 'Phone';
            objCaso.Priority = 'Medium';
            objCaso.F_AsignarTarjetaPreinscrita__c = false;
            
            insert objCaso;
            
            Account objCuenta = new Account();
        
            list<RecordType> lstRecordTypeClienteLifeMiles;
            lstRecordTypeClienteLifeMiles = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Fielo_TarjetaPreinscrita'];
            
            objCuenta.F_TipoMember__c = 'Fielo_TarjetaPreinscrita';
            //objCuenta.Name = 'T000000000017';
            objCuenta.F_CreateMember__c = true;
            //objCuenta.Ter_Categoria__pc = 'Alta';
            objCuenta.F_CodigoTarjetaPreinscrita__c = 'T000000000017';
            objCuenta.F_EstadoTarjetaPreinscrita__c = 'Inactiva';
            objCuenta.F_TipoTarjetaPreinscrita__c = 'Virtual';
            objCuenta.RecordTypeId = lstRecordTypeClienteLifeMiles.get(0).Id;
            //objCuenta.F_FechaActivacionTarjeta__pc = 'Virtual';
            
            insert objCuenta;
            
            /*FieloPLT__Member__c objTarjeta = new FieloPLT__Member__c();
            objTarjeta.Name = ' T000000000017';
            objTarjeta.F_NumeroTarjetaPreinscrita__c = 'T000000000017';
            objTarjeta.FieloPLT__Type__c = 'Individual Account';
            objTarjeta.F_TipoTarjetaPreinscrita__c = 'Virtual';
            objTarjeta.FieloPLT__Status__c = 'Active';
            objTarjeta.F_EstadoTarjetaPreinscrita__c = 'Inactiva';
            insert objTarjeta;*/
            
            objCaso = new Case();
            objCaso.AccountId = objCuentaAux.Id;
            //objCaso.ContactId = objCuentaAux.Id;
            objCaso.Status = 'New';
            objCaso.Origin = 'Phone';
            objCaso.Priority = 'Medium';
            objCaso.F_AsignarTarjetaPreinscrita__c = false;
            
            insert objCaso;
            
            objCaso.F_AsignarTarjetaPreinscrita__c = true;
            
            update objCaso;
            
            objCaso.Subject = 'xxxxxxxxxxxxx';
            
            update objCaso;
        
        Test.stopTest();
    }
    
}