/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase de pruebas para la clase Ter_LogicaServiciosCore_cls
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    28/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
@isTest
public with sharing class Ter_LogicaServiciosCore_tst {
    
    @isTest static void procesaTransaccion(){
        
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
        
        /*Account objCuenta = Ter_DataGenerator_cls.crearCuentaAcumulacion(true);
        FieloPLT__Member__c objMember =  Ter_DataGenerator_cls.generateMember('1983002834993', '90000009', null, null);
        objMember.FieloPLT__Account__c = objCuenta.Id;
        insert objMember;
        objCuenta.F_Member__c = objMember.Id;
        update objCuenta;*/
        Fielo_MedioDePago__c objMedioPagoFielo = Ter_DataGenerator_cls.crearMedioPago(true);
        Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
        Ter_Negocio_Complementario__c objTTCC = Ter_DataGenerator_cls.crearTTCC(true);
        
        Test.startTest();
            Ter_LogicaServiciosCore_cls objLogicaServiciosCore = new Ter_LogicaServiciosCore_cls();
            SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente objAcumulaRedimeCliente = new SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente();
            SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo objContextoTransaccionalTipo = new SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo();
            SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse objAcumularRedimirResponse;
            
            SrvIntClienteTransaccion_in.DT_Identificacion objIdentificacion = new SrvIntClienteTransaccion_in.DT_Identificacion();
            SrvIntClienteTransaccion_in.DT_Producto objProducto = new SrvIntClienteTransaccion_in.DT_Producto();
            list<SrvIntClienteTransaccion_in.DT_Producto> lstProducto = new list<SrvIntClienteTransaccion_in.DT_Producto>();
            SrvIntClienteTransaccion_in.DT_MedioPago objMedioPago = new SrvIntClienteTransaccion_in.DT_MedioPago();
            list<SrvIntClienteTransaccion_in.DT_MedioPago> lstMedioPago = new list<SrvIntClienteTransaccion_in.DT_MedioPago>();
            
            objIdentificacion.codTipoidentificacion = 'CC';
            objIdentificacion.valNumeroIdentificacion = 'MmR0ZIFZk4zRj5GI1APcBA==';
            
            objProducto.idProducto = '0001';
            objProducto.cantidad = 1;
            objProducto.valorUnitario = 15000;
            lstProducto.add(objProducto);
            
            objMedioPago.codigoMedioPago = 1;
            objMedioPago.monto = 15000;
            lstMedioPago.add(objMedioPago);
            
            objAcumulaRedimeCliente.idVenta = '57439587439857';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = label.Ter_lbl_TipoTransaccion_Acumulacion;
            objAcumulaRedimeCliente.montoTotal = 15000;
            objAcumulaRedimeCliente.descuento = 0;
            objAcumulaRedimeCliente.valorPagar = 15000;
            objAcumulaRedimeCliente.impuesto = 0;
            objAcumulaRedimeCliente.idPromotor = '9999';
            objAcumulaRedimeCliente.idPuntoVenta = '1234';
            objAcumulaRedimeCliente.origenTransaccion = 'XX';//label.Ter_lbl_EDS;
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            objAcumulaRedimeCliente.tipoVenta = 'L';
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            
            //Se prueba transaccion con tipoTransaccion y origenTransaccion invalidos
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
        
        
            Ter_TerpelAutentication_ctr testController; 
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
            testController.procesarRegistro();
        
        
            objLogicaServiciosCore = new Ter_LogicaServiciosCore_cls();
            objAcumulaRedimeCliente = new SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente();
            objContextoTransaccionalTipo = new SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo();

            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            //
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 1' + objAcumularRedimirResponse);
            
            objIdentificacion = new SrvIntClienteTransaccion_in.DT_Identificacion();
            objProducto = new SrvIntClienteTransaccion_in.DT_Producto();
            lstProducto = new list<SrvIntClienteTransaccion_in.DT_Producto>();
            objMedioPago = new SrvIntClienteTransaccion_in.DT_MedioPago();
            lstMedioPago = new list<SrvIntClienteTransaccion_in.DT_MedioPago>();
            
            objContextoTransaccionalTipo.codTipoEvento = '01';
            objContextoTransaccionalTipo.fecEvento = '2017-06-29 22:34:45';
            objContextoTransaccionalTipo.valUsuario = 'pepito';
            
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            
            //
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 2' + objAcumularRedimirResponse);
            
            objIdentificacion.codTipoidentificacion = 'CC';
            objIdentificacion.valNumeroIdentificacion = 'MmR0ZIFZk4zRj5GI1APcBA==';//'88556699';
            
            objProducto.idProducto = '0001';
            objProducto.cantidad = 1;
            objProducto.valorUnitario = 15000;
            lstProducto.add(objProducto);
            
            objMedioPago.codigoMedioPago = 1;
            objMedioPago.monto = 15000;
            lstMedioPago.add(objMedioPago);
            
            objAcumulaRedimeCliente.idVenta = '57439587439857';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = 'XXXX';
            objAcumulaRedimeCliente.montoTotal = 15000;
            objAcumulaRedimeCliente.descuento = 0;
            objAcumulaRedimeCliente.valorPagar = 15000;
            objAcumulaRedimeCliente.impuesto = 0;
            objAcumulaRedimeCliente.idPromotor = '9999';
            objAcumulaRedimeCliente.idPuntoVenta = '1234';
            objAcumulaRedimeCliente.origenTransaccion = 'XWXW';
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            objAcumulaRedimeCliente.tipoVenta = 'L';
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            
            //Se prueba transaccion con tipoTransaccion y origenTransaccion invalidos
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 3' + objAcumularRedimirResponse);
            
            objIdentificacion.codTipoidentificacion = 'CC';
            objIdentificacion.valNumeroIdentificacion = 'MmR0ZIFZk4zRj5GI1APcBA==';
            
            objAcumulaRedimeCliente.idVenta = '57439587439857';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = label.Ter_lbl_TipoTransaccion_Acumulacion;
            objAcumulaRedimeCliente.montoTotal = 15000;
            objAcumulaRedimeCliente.descuento = 0;
            objAcumulaRedimeCliente.valorPagar = 15000;
            objAcumulaRedimeCliente.impuesto = 0;
            objAcumulaRedimeCliente.idPromotor = '9999';
            objAcumulaRedimeCliente.idPuntoVenta = '1234';
            objAcumulaRedimeCliente.origenTransaccion = label.Ter_lbl_EDS;
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            objAcumulaRedimeCliente.tipoVenta = 'L';
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            
            delete objEDS;
            
            //Se prueba transaccion SIN EDS
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 4' + objAcumularRedimirResponse);
            
            
            objEDS = Ter_DataGenerator_cls.crearEDS(true);
            
            objIdentificacion.codTipoidentificacion = 'CC';
            objIdentificacion.valNumeroIdentificacion = 'MmR0ZIFZk4zRj5GI1APcBA==';
            
            objAcumulaRedimeCliente.idVenta = '57439587439857';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = label.Ter_lbl_TipoTransaccion_Acumulacion;
            objAcumulaRedimeCliente.montoTotal = 15000;
            objAcumulaRedimeCliente.descuento = 0;
            objAcumulaRedimeCliente.valorPagar = 15000;
            objAcumulaRedimeCliente.impuesto = 0;
            objAcumulaRedimeCliente.idPromotor = '9999';
            objAcumulaRedimeCliente.idPuntoVenta = '1234';
            objAcumulaRedimeCliente.origenTransaccion = label.Ter_lbl_EDS;
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            objAcumulaRedimeCliente.tipoVenta = 'L';
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            
            //Se prueba transaccion OK con EDS
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 4.1' + objAcumularRedimirResponse);
            
            objEDS.F_Acumula__c = false;
            objEDS.F_ClubTerpel__c = false;

            update objEDS;
            
            //Se prueba transaccion EDS NO acumula
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 5' + objAcumularRedimirResponse);
            
            objIdentificacion.codTipoidentificacion = 'CC';
            objIdentificacion.valNumeroIdentificacion = 'MmR0ZIFZk4zRj5GI1APcBA==';
            
            objAcumulaRedimeCliente.idVenta = '57439587439857';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = label.Ter_lbl_TipoTransaccion_Acumulacion;
            objAcumulaRedimeCliente.montoTotal = 15000;
            objAcumulaRedimeCliente.descuento = 0;
            objAcumulaRedimeCliente.valorPagar = 15000;
            objAcumulaRedimeCliente.impuesto = 0;
            objAcumulaRedimeCliente.idPromotor = '9999';
            objAcumulaRedimeCliente.idPuntoVenta = '1234';
            objAcumulaRedimeCliente.origenTransaccion = label.Ter_lbl_TDC;
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            objAcumulaRedimeCliente.tipoVenta = 'L';
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            
            delete objTTCC;
            
            //Se prueba transaccion SIN TDC
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 6' + objAcumularRedimirResponse);
            
            objTTCC = Ter_DataGenerator_cls.crearTTCC(true);
            
            objIdentificacion.codTipoidentificacion = 'CC';
            objIdentificacion.valNumeroIdentificacion = 'MmR0ZIFZk4zRj5GI1APcBA==';
            
            objAcumulaRedimeCliente.idVenta = '57439587439857';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = label.Ter_lbl_TipoTransaccion_Acumulacion;
            objAcumulaRedimeCliente.montoTotal = 15000;
            objAcumulaRedimeCliente.descuento = 0;
            objAcumulaRedimeCliente.valorPagar = 15000;
            objAcumulaRedimeCliente.impuesto = 0;
            objAcumulaRedimeCliente.idPromotor = '9999';
            objAcumulaRedimeCliente.idPuntoVenta = '1234';
            objAcumulaRedimeCliente.origenTransaccion = label.Ter_lbl_TDC;
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            objAcumulaRedimeCliente.tipoVenta = 'L';
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            
            //Se prueba transaccion OK con TDC
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 6' + objAcumularRedimirResponse);
            
            objIdentificacion.codTipoidentificacion = 'CC';
            objIdentificacion.valNumeroIdentificacion = 'MmR0ZIFZk4zRj5GI1APcBA==';
            
            objAcumulaRedimeCliente.idVenta = '57439587439857';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = 'XX';
            objAcumulaRedimeCliente.montoTotal = 15000;
            objAcumulaRedimeCliente.descuento = 0;
            objAcumulaRedimeCliente.valorPagar = 15000;
            objAcumulaRedimeCliente.impuesto = 0;
            objAcumulaRedimeCliente.idPromotor = '9999';
            objAcumulaRedimeCliente.idPuntoVenta = '1234';
            objAcumulaRedimeCliente.origenTransaccion = label.Ter_lbl_TDC;
            objAcumulaRedimeCliente.tipoDocumento = objIdentificacion;
            objAcumulaRedimeCliente.tipoVenta = 'L';
            objAcumulaRedimeCliente.productos = lstProducto;
            objAcumulaRedimeCliente.mediosPago = lstMedioPago;
            
            //Se prueba con un origen transaccion invalido
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 7' + objAcumularRedimirResponse);
            
            objTTCC.F_Acumula__c = false;
            objTTCC.F_ClubTerpel__c = false;
            update objTTCC;
            
            objAcumulaRedimeCliente.origenTransaccion = label.Ter_lbl_TDC;
            
            //Se prueba transaccion TTCC NO acumula
            objAcumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo);
            system.debug('............. 8' + objAcumularRedimirResponse);
            
            SrvIntClienteTransaccion_in.OpClienteAcumularRedimir_Sync(objAcumulaRedimeCliente, objContextoTransaccionalTipo); 
            
            
            SrvIntClienteTransaccion_in.DT_ValidaCliente objValidaCliente = new SrvIntClienteTransaccion_in.DT_ValidaCliente();
            objValidaCliente.origenTransaccion = label.Ter_lbl_TDC;
            objValidaCliente.idPuntoVenta = '1234';
            objValidaCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objValidaCliente.tipoDocumento = objIdentificacion;

            SrvIntClienteTransaccion_in.OpClienteValidar_Sync(objValidaCliente , objContextoTransaccionalTipo);
            
        Test.stopTest();
    }
    
}