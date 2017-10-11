@isTest
public with sharing class Ter_LogicaAlternativaTDC_tst {
	
	@isTest static void testFidelizarVenta() {

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
		Fielo_MedioDePago__c objMedioPagoFielo = Ter_DataGenerator_cls.crearMedioPago(true);
        Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
        
        Datetime dtLlegadaFielo =  Datetime.now();
		long miliLlegadaFielo = dtLlegadaFielo.getTime();
        
        Test.startTest();
            Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
            FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('1245377192154','88556699','T100000000012', null);
            FieloPLT__Program__c objProgram = Ter_DataGenerator_cls.generateProgramFielo();
            insert  objProgram;

            objMember.FieloPLT__Program__c = objProgram.Id;
            Contact objContact = Ter_DataGenerator_cls.generateContact();
            objContact.AccountId = objCuenta.Id;
            insert objContact;

            objMember.FieloPLT__Contact__c = objContact.Id;
            insert objMember;
            
            Ter_Negocio_Complementario__c objTTCC = Ter_DataGenerator_cls.crearTTCC(true);
            
            Ter_Venta_TDC__c objVenta = new Ter_Venta_TDC__c();
			objVenta.Ter_TipoTransaccion__c = 'Acumulación';
			objVenta.Ter_OrigenVenta__c = 'Tienda';
			objVenta.Ter_Tienda__c = objTTCC.Id;
			objVenta.Ter_Cliente__c = objMember.FieloPLT__Account__c;
			objVenta.Ter_Member__c = objMember.Id;
			objVenta.Ter_IdVenta__c = 'TC-000000009';
			objVenta.Ter_Estado__c = 'Pendiente';
			objVenta.Ter_TipoVenta__c = 'Tiendas';
			insert objVenta;
			
			objVenta = new Ter_Venta_TDC__c();
			objVenta.Ter_TipoTransaccion__c = 'Acumulación';
			objVenta.Ter_OrigenVenta__c = 'Tienda';
			objVenta.Ter_Tienda__c = objTTCC.Id;
			objVenta.Ter_Cliente__c = objMember.FieloPLT__Account__c;
			objVenta.Ter_Member__c = objMember.Id;
			objVenta.Ter_IdVenta__c = 'TC-000000001';
			objVenta.Ter_Estado__c = 'Pendiente';
			objVenta.Ter_TipoVenta__c = 'Tiendas';
			insert objVenta;
			
			SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente objAcumulaRedimeCliente = new SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente();
            SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo objContextoTransaccionalTipo = new SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo();
            SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse objAcumularRedimirResponse;
            
            SrvIntClienteTransaccion_in.DT_Identificacion objIdentificacion = new SrvIntClienteTransaccion_in.DT_Identificacion();
            SrvIntClienteTransaccion_in.DT_Producto objProducto = new SrvIntClienteTransaccion_in.DT_Producto();
            list<SrvIntClienteTransaccion_in.DT_Producto> lstProducto = new list<SrvIntClienteTransaccion_in.DT_Producto>();
            SrvIntClienteTransaccion_in.DT_MedioPago objMedioPago = new SrvIntClienteTransaccion_in.DT_MedioPago();
            list<SrvIntClienteTransaccion_in.DT_MedioPago> lstMedioPago = new list<SrvIntClienteTransaccion_in.DT_MedioPago>();
            
            Ter_LogicaAlternativaTDC_cls objLogicaAlternativaTDC = new Ter_LogicaAlternativaTDC_cls();

            objIdentificacion.codTipoidentificacion = 'NLM';
            objIdentificacion.valNumeroIdentificacion = '0v7zjIWadIlyAbvrDBNrCA==';
            
            objProducto.idProducto = '0001';
            objProducto.cantidad = 1;
            objProducto.valorUnitario = 15000;
            lstProducto.add(objProducto);
            
            objMedioPago.codigoMedioPago = 1;
            objMedioPago.monto = 15000;
            lstMedioPago.add(objMedioPago);
            
            objAcumulaRedimeCliente.idVenta = 'TC-000000009';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-08-28 18:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = 'XXX';//label.Ter_lbl_Acumulacion_TDC;
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
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
            objAcumulaRedimeCliente.idVenta = 'TC-000000008';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = 'XXX';//label.Ter_lbl_Acumulacion_TDC;
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
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
            objAcumulaRedimeCliente.idVenta = 'TC-000000009';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-06-29 22:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = label.Ter_lbl_Acumulacion_TDC;
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
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
            objVenta.Ter_TransaccionProcesada__c = true;
            update objVenta;
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
        Test.stopTest();
    }
    
    
    @isTest static void testFidelizarVentaUsrBloqueado() {
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
		Fielo_MedioDePago__c objMedioPagoFielo = Ter_DataGenerator_cls.crearMedioPago(true);
        Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
        
        Datetime dtLlegadaFielo =  Datetime.now();
		long miliLlegadaFielo = dtLlegadaFielo.getTime();
        
        Test.startTest();
    		Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
            FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('1245377192154','88556699','T100000000012', null);
            FieloPLT__Program__c objProgram = Ter_DataGenerator_cls.generateProgramFielo();
            insert  objProgram;

            objMember.FieloPLT__Program__c = objProgram.Id;
            Contact objContact = Ter_DataGenerator_cls.generateContact();
            objContact.AccountId = objCuenta.Id;
            insert objContact;

            objMember.FieloPLT__Contact__c = objContact.Id;
            objMember.F_EstadoTarjetaPreinscrita__c = 'Activa';
            objMember.FieloPLT__Status__c = 'Activo';
            insert objMember;
            
            Ter_Negocio_Complementario__c objTTCC = Ter_DataGenerator_cls.crearTTCC(true);
            
            Ter_Venta_TDC__c objVenta = new Ter_Venta_TDC__c();
			objVenta.Ter_TipoTransaccion__c = 'Acumulación';
			objVenta.Ter_OrigenVenta__c = 'Tienda';
			objVenta.Ter_Tienda__c = objTTCC.Id;
			objVenta.Ter_Cliente__c = objMember.FieloPLT__Account__c;
			objVenta.Ter_Member__c = objMember.Id;
			objVenta.Ter_IdVenta__c = 'TC-000000009';
			objVenta.Ter_Estado__c = 'Pendiente';
			objVenta.Ter_TipoVenta__c = 'Tiendas';
			insert objVenta;
			
			SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente objAcumulaRedimeCliente = new SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente();
            SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo objContextoTransaccionalTipo = new SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo();
            SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse objAcumularRedimirResponse;
            
            SrvIntClienteTransaccion_in.DT_Identificacion objIdentificacion = new SrvIntClienteTransaccion_in.DT_Identificacion();
            SrvIntClienteTransaccion_in.DT_Producto objProducto = new SrvIntClienteTransaccion_in.DT_Producto();
            list<SrvIntClienteTransaccion_in.DT_Producto> lstProducto = new list<SrvIntClienteTransaccion_in.DT_Producto>();
            SrvIntClienteTransaccion_in.DT_MedioPago objMedioPago = new SrvIntClienteTransaccion_in.DT_MedioPago();
            list<SrvIntClienteTransaccion_in.DT_MedioPago> lstMedioPago = new list<SrvIntClienteTransaccion_in.DT_MedioPago>();
            
            Ter_LogicaAlternativaTDC_cls objLogicaAlternativaTDC = new Ter_LogicaAlternativaTDC_cls();

            objIdentificacion.codTipoidentificacion = 'NLM';
            objIdentificacion.valNumeroIdentificacion = '0v7zjIWadIlyAbvrDBNrCA==';
            
            objProducto.idProducto = '0001';
            objProducto.cantidad = 1;
            objProducto.valorUnitario = 15000;
            lstProducto.add(objProducto);
            
            objMedioPago.codigoMedioPago = 1;
            objMedioPago.monto = 15000;
            lstMedioPago.add(objMedioPago);
            
            objAcumulaRedimeCliente.idVenta = 'TC-000000009';
            objAcumulaRedimeCliente.fechaTransaccion = '2017-08-28 18:34:45';
            objAcumulaRedimeCliente.tipoTransaccion = label.Ter_lbl_Acumulacion_TDC;
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
            
            objMember.FieloPLT__Status__c = 'Bloqueado';
            update objMember;
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
            
            RecordType objRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = :label.Ter_lbl_RT_ClienteLifeMiles AND SobjectType = 'FieloPLT__Member__c'];
            //objMember.FieloPLT__Status__c = 'Activo';
            objMember.RecordTypeId = objRecordType.Id;
            update objMember;
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
            
            
            objRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = :label.Ter_lbl_RT_TarjetaPreinscrita AND SobjectType = 'FieloPLT__Member__c'];
            //objMember.FieloPLT__Status__c = 'Activo';
            objMember.F_EstadoTarjetaPreinscrita__c = 'Expirada';
            objMember.RecordTypeId = objRecordType.Id;
            update objMember;
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
            
            
            objMember.F_EstadoTarjetaPreinscrita__c = 'Utilizada';
            update objMember;
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
            
            
            objMember.FieloPLT__Status__c = 'Bloqueado';
            objMember.F_EstadoTarjetaPreinscrita__c = 'Activa';
            update objMember;
            
            objAcumularRedimirResponse = objLogicaAlternativaTDC.procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTTCC, miliLlegadaFielo);
            
    	Test.stopTest();
    }
    
    @isTest static void testFidelizarVentaRedencion() {
    	
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
        Ter_Estacion_de_Servicio__c objEDS = Ter_DataGenerator_cls.crearEDS(true);
        Fielo_MedioDePago__c objMedioPagoFieloMillas =  Ter_DataGenerator_cls.crearMedioPagoMillas(true);
        Fielo_MedioDePago__c objMedioPagoFieloBono =  Ter_DataGenerator_cls.crearMedioPagoBono(true);
        FieloPLT__Reward__c reward = new FieloPLT__Reward__c();
        reward.Name = 'Redención Presencial Tiendas';
        reward.FieloPLT__Program__c = objFieloPLTProgram.Id;
        reward.FieloPLT__Points__c = 0;
        reward.FieloPLT__Stock__c = 1;
        reward.FieloPLT__StockManagement__c = 'Unlimited';
        insert reward;
        
        Datetime dtLlegadaFielo =  Datetime.now();
		long miliLlegadaFielo = dtLlegadaFielo.getTime();
		
		Account objCuenta = Ter_DataGenerator_cls.crearCuenta(true);
            FieloPLT__Member__c objMember = Ter_DataGenerator_cls.generateMember('1245377192154','88556699','T100000000012', null);
            FieloPLT__Program__c objProgram = Ter_DataGenerator_cls.generateProgramFielo();
            insert  objProgram;

            objMember.FieloPLT__Program__c = objProgram.Id;
            Contact objContact = Ter_DataGenerator_cls.generateContact();
            objContact.AccountId = objCuenta.Id;
            insert objContact;

            objMember.FieloPLT__Contact__c = objContact.Id;
            objMember.F_EstadoTarjetaPreinscrita__c = 'Activa';
            objMember.FieloPLT__Status__c = 'Activo';
            objMember.FieloPLT__Program__c = objFieloPLTProgram.Id;
            objMember.FieloPLT__Points__c = 500;
            insert objMember;
            
        Ter_Negocio_Complementario__c objTTCC = Ter_DataGenerator_cls.crearTTCC(true);
        
        Test.startTest();
        	
            Ter_LogicaAlternativaTDC_cls objLogicaAlternativaTDC = new Ter_LogicaAlternativaTDC_cls();
            
            Test.setMock(WebServiceMock.class, new Ter_LifeMilesPartnerConversionWsMock_cls());
            objLogicaAlternativaTDC.procesarRedencionTDC(objMember.Id, 10.0, objTTCC.Id, '9999', '1234');
            
            objLogicaAlternativaTDC.procesarReclamacionTDC(objMember.Id, 20000.0, objTTCC.Id, '9999', '0000000001');
        
        Test.stopTest();
    	
    }
    
    
}