@isTest
private class Ter_TDC_Home_tst {
	
	@isTest static void testValidarClienteLifeMiles() {

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

			Ter_Negocio_Complementario__c objTienda = Ter_DataGenerator_cls.crearTTCC(false);
			insert objTienda;

			Ter_POS__c objPos = new Ter_POS__c();
			objPos.Ter_Usuario__c = UserInfo.getUserId();
			objPos.Name = 'Nombre POS';
			objPos.Ter_Codigo_DIAN__c = 'AVX';
			objPos.Ter_Negocio_Complementario__c = objTienda.Id;
			insert objPos;


			Ter_TDC_Home_Ctr.TDC_Wrapper objResult = Ter_TDC_Home_Ctr.validarCliente('NLM','1245377192154');
		
			System.assertEquals(false, objResult.blnError);
			System.assertNotEquals(null, objResult.idMemberId);
			System.assertNotEquals(null, objResult.strNumeroDocumento);
			System.assertEquals('1245377192154', objResult.strNombre);
		Test.stopTest();
	}
	
	@isTest static void testValidarClienteTarjetaPreinscrita() {
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

			Ter_Negocio_Complementario__c objTienda = Ter_DataGenerator_cls.crearTTCC(false);
			insert objTienda;

			Ter_POS__c objPos = new Ter_POS__c();
			objPos.Ter_Usuario__c = UserInfo.getUserId();
			objPos.Name = 'Nombre POS';
			objPos.Ter_Codigo_DIAN__c = 'AVX';
			objPos.Ter_Negocio_Complementario__c = objTienda.Id;
			insert objPos;

			Ter_TDC_Home_Ctr.TDC_Wrapper objResult = Ter_TDC_Home_Ctr.validarCliente('TPI','T100000000012');
		
			System.assertEquals(objResult.blnError, false);
			System.assertNotEquals(objResult.idMemberId, null);
			System.assertNotEquals(objResult.strNumeroDocumento, null);
		Test.stopTest();
	}

	@isTest static void testValidarClienteCedulaCiudadaniaOrExtrajeriaOrPasaporte() {
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
			objMember.F_IdentificationType__c = 'Cédula de ciudadanía';
			insert objMember;

			Ter_Negocio_Complementario__c objTienda = Ter_DataGenerator_cls.crearTTCC(false);
			insert objTienda;

			Ter_POS__c objPos = new Ter_POS__c();
			objPos.Ter_Usuario__c = UserInfo.getUserId();
			objPos.Name = 'Nombre POS';
			objPos.Ter_Codigo_DIAN__c = 'AVX';
			objPos.Ter_Negocio_Complementario__c = objTienda.Id;
			insert objPos;

			Ter_TDC_Home_Ctr.TDC_Wrapper objResult = Ter_TDC_Home_Ctr.validarCliente('Cédula de ciudadanía','88556699');
		
			System.assertEquals(false, objResult.blnError);
			System.assertNotEquals(null, objResult.idMemberId);
			System.assertNotEquals(null, objResult.strNumeroDocumento);
			System.assertEquals('Cristian Jose Mosquera Puello', objResult.strNombre);
		Test.stopTest();
	}

	@isTest static void testGuardarVentaAcumulacion() {

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

			Ter_Negocio_Complementario__c objTienda = Ter_DataGenerator_cls.crearTTCC(false);
			insert objTienda;

			Ter_POS__c objPos = new Ter_POS__c();
			objPos.Ter_Usuario__c = UserInfo.getUserId();
			objPos.Name = 'Nombre POS';
			objPos.Ter_Codigo_DIAN__c = 'AVX';
			objPos.Ter_Negocio_Complementario__c = objTienda.Id;
			insert objPos;

			Ter_TDC_Home_Ctr.TDC_Wrapper objResult = Ter_TDC_Home_Ctr.validarCliente('NLM','1245377192154');
			objResult.strNumeroFactura = '10987654321';
			objResult.strTipoTransaccion = Ter_TDC_Home_Ctr.TRANSACCION_ACUMULACION;
			objResult = Ter_TDC_Home_Ctr.guardarVenta(objResult);

			System.assertEquals(false, objResult.blnError);
		Test.stopTest();
	}



	@isTest static void testLogout() {
		Ter_TDC_Home_Ctr objTDCHomeCtr = new Ter_TDC_Home_Ctr();
		objTDCHomeCtr.logout();
	}

	@isTest static void testInitData() {
		Test.startTest();
			Ter_TDC_Valor_Milla__c objCustomConf = new Ter_TDC_Valor_Milla__c();
			objCustomConf.Name = 'ValorMilla';
			objCustomConf.Ter_TDC_Valor_Milla__c = 21;
			insert objCustomConf;

			Ter_Negocio_Complementario__c objTienda = Ter_DataGenerator_cls.crearTTCC(true);
			Ter_POS__c objPos = new Ter_POS__c();
			objPos.Ter_Usuario__c = UserInfo.getUserId();
			objPos.Name = 'Nombre POS';
			objPos.Ter_Codigo_DIAN__c = 'AVX';
			objPos.Ter_Negocio_Complementario__c = objTienda.Id;
			insert objPos;

			Ter_TDC_Home_Ctr.TDC_InitDataWrapper objResult = Ter_TDC_Home_Ctr.getInitData();
			System.assertEquals(objPos.Name, objResult.strNombreTienda);
		Test.stopTest();
	}
}