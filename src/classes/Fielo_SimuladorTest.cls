/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 26/06/2017
* 
* Name: Fielo_SimuladorTest.cls
* 
* Classe de teste da trigger Fielo_Simulador.trigger
*
*******************************************************************************/
@isTest
private class Fielo_SimuladorTest {

	public final static String VENTA_TYPE_LIQUIDO_ID = RecType.getID('Fielo_Venta__c', 'Líquido');
	public final static String VENTA_TYPE_TIENDA_ID = RecType.getID('Fielo_Venta__c', 'Tienda');

	// Origin Venta
	public final static String TIENDA = 'Tienda';
	public final static String ESTACION_DE_SERVICIO = 'Estación de Servicio';

	// Type Combustible
	public final static String EXTRA = 'Extra';
	public final static String DIESEL = 'Diesel';
	public final static String CORRIENTE = 'Corriente';

	// Status Venta	
	public final static String PROCESAR = 'Procesar';
	public final static String APROBADA = 'Aprobada';
	public final static String RECHAZADA = 'Rechazada';

	@isTest static void simulateVentaLiquid() {
		
		Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
		insert lVariablesFraude;

		FieloPLT__Program__c lPrg = SObjectForTest.getProgram('Teste'); 
		insert lPrg; 

		FieloPLT__Member__c lMb = SObjectForTest.loadMember();

		Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
		insert lTasa;

		Ter_Estacion_de_Servicio__c lEstacion = SObjectForTest.getEstacionDeServicio();
		insert lEstacion;

		Fielo_Venta__c lVenta = SObjectForTest.getVenta();
		lVenta.F_EstacionDeServicio__c = lEstacion.id;
		lVenta.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVenta.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
		lVenta.F_OrigenVenta__c = ESTACION_DE_SERVICIO;
		lVenta.F_FechaTransaccion__c = Datetime.now();
		lVenta.F_Estado__c  = 'Pendiente';

		Fielo_MedioDePagoVenta__c lMedPagoVenta = SObjectForTest.getMedioDePagoVenta();

		Fielo_ItemVenta__c lItemVenta = SObjectForTest.getItemVenta();
		lItemVenta.F_IdProducto__c = '1';
		lItemVenta.F_Cantidad__c = 51;

		Test.startTest();

			Map<String, List<SObject>> lResultMap = Fielo_Simulador.SimularVenta(lVenta, new List<Fielo_ItemVenta__c>{lItemVenta}, new List<Fielo_MedioDePagoVenta__c>{lMedPagoVenta});

		Test.stopTest();
	}

	@isTest static void simulateVentaLiquidMaxCantidade() {
		
		Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
		lVariablesFraude.F_MaxCantidadVentasLiquido__c = 1;
		insert lVariablesFraude;

		FieloPLT__Program__c lPrg = SObjectForTest.getProgram('Teste'); 
		insert lPrg; 

		FieloPLT__Member__c lMb = SObjectForTest.loadMember();

		Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
		insert lTasa;

		Ter_Estacion_de_Servicio__c lEstacion = SObjectForTest.getEstacionDeServicio();
		insert lEstacion;

		Fielo_Venta__c lVentaBase = SObjectForTest.getVenta();
		lVentaBase.F_EstacionDeServicio__c = lEstacion.id;
		lVentaBase.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVentaBase.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
		lVentaBase.F_OrigenVenta__c = ESTACION_DE_SERVICIO;
		lVentaBase.F_FechaTransaccion__c = Datetime.now();
		lVentaBase.F_Estado__c  = 'Pendiente';
		insert lVentaBase;

		Fielo_Venta__c lVenta = SObjectForTest.getVenta();
		lVenta.F_LiquidoFidelizable__c = lVariablesFraude.F_MaxGalonesCorriente__c + 1;
		lVenta.F_EstacionDeServicio__c = lEstacion.id;
		lVenta.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVenta.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
		lVenta.F_TipoCombustible__c = EXTRA;
		lVenta.F_OrigenVenta__c = ESTACION_DE_SERVICIO;
		lVenta.F_FechaTransaccion__c = Datetime.now();
		lVenta.F_Estado__c  = 'Pendiente';

		Fielo_MedioDePagoVenta__c lMedPagoVenta = SObjectForTest.getMedioDePagoVenta();

		Fielo_ItemVenta__c lItemVenta = SObjectForTest.getItemVenta();
		lItemVenta.F_IdProducto__c = '1';
		lItemVenta.F_Cantidad__c = 51;


		Test.startTest();

			Map<String, List<SObject>> lResultMap = Fielo_Simulador.SimularVenta(lVenta, new List<Fielo_ItemVenta__c>{lItemVenta}, new List<Fielo_MedioDePagoVenta__c>{lMedPagoVenta});

		Test.stopTest();
	}

	@isTest static void simulateVentaTienda() {
		
		Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
		insert lVariablesFraude;

		FieloPLT__Program__c lPrg = SObjectForTest.getProgram('Teste'); 
		insert lPrg; 

		FieloPLT__Member__c lMb = SObjectForTest.loadMember();

		Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
		insert lTasa;

		Ter_Estacion_de_Servicio__c lEstacion = SObjectForTest.getEstacionDeServicio();
		insert lEstacion;

		Fielo_Venta__c lVenta = SObjectForTest.getVenta();
		lVenta.F_EstacionDeServicio__c = lEstacion.id;
		lVenta.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVenta.RecordTypeId = VENTA_TYPE_TIENDA_ID;
		lVenta.F_OrigenVenta__c = TIENDA;
		lVenta.F_FechaTransaccion__c = Datetime.now();
		lVenta.F_Estado__c  = 'Pendiente';

		Fielo_MedioDePagoVenta__c lMedPagoVenta = SObjectForTest.getMedioDePagoVenta();

		Fielo_ItemVenta__c lItemVenta = SObjectForTest.getItemVenta();
		lItemVenta.F_IdProducto__c = '1';
		lItemVenta.F_Cantidad__c = 51;

		Test.startTest();

			Map<String, List<SObject>> lResultMap = Fielo_Simulador.SimularVenta(lVenta, new List<Fielo_ItemVenta__c>{lItemVenta}, new List<Fielo_MedioDePagoVenta__c>{lMedPagoVenta});

		Test.stopTest();
	}

	@isTest static void simulateVentaTiendaMaxCantidade() {
		
		Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
		lVariablesFraude.F_MaxCantidadVentasTienda__c = 1;
		insert lVariablesFraude;

		FieloPLT__Program__c lPrg = SObjectForTest.getProgram('Teste'); 
		insert lPrg; 

		FieloPLT__Member__c lMb = SObjectForTest.loadMember();

		Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
		insert lTasa;

		Ter_Estacion_de_Servicio__c lEstacion = SObjectForTest.getEstacionDeServicio();
		insert lEstacion;

		Fielo_Venta__c lVentaBase = SObjectForTest.getVenta();
		lVentaBase.F_EstacionDeServicio__c = lEstacion.id;
		lVentaBase.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVentaBase.RecordTypeId = VENTA_TYPE_TIENDA_ID;
		lVentaBase.F_OrigenVenta__c = TIENDA;
		lVentaBase.F_FechaTransaccion__c = Datetime.now();
		lVentaBase.F_Estado__c  = 'Pendiente';
		insert lVentaBase;

		Fielo_Venta__c lVenta = SObjectForTest.getVenta();
		lVenta.F_MontoTotal__c = lVariablesFraude.F_MaxMontoVentaTienda__c + 1;
		lVenta.F_EstacionDeServicio__c = lEstacion.id;
		lVenta.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVenta.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
		lVenta.F_OrigenVenta__c = TIENDA;
		lVenta.F_FechaTransaccion__c = Datetime.now();
		lVenta.F_Estado__c  = 'Pendiente';

		Fielo_MedioDePagoVenta__c lMedPagoVenta = SObjectForTest.getMedioDePagoVenta();

		Fielo_ItemVenta__c lItemVenta = SObjectForTest.getItemVenta();
		lItemVenta.F_IdProducto__c = '1';
		lItemVenta.F_Cantidad__c = 51;

		Test.startTest();

			Map<String, List<SObject>> lResultMap = Fielo_Simulador.SimularVenta(lVenta, new List<Fielo_ItemVenta__c>{lItemVenta}, new List<Fielo_MedioDePagoVenta__c>{lMedPagoVenta});

		Test.stopTest();
	}

		@isTest static void simulateExtraComb() {
		
		Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
		lVariablesFraude.F_MaxCantidadVentasTienda__c = 2;
		insert lVariablesFraude;

		FieloPLT__Program__c lPrg = SObjectForTest.getProgram('Teste'); 
		insert lPrg; 

		FieloPLT__Member__c lMb = SObjectForTest.loadMember();

		Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
		insert lTasa;

		Ter_Estacion_de_Servicio__c lEstacion = SObjectForTest.getEstacionDeServicio();
		insert lEstacion;

		Fielo_Venta__c lVentaBase = SObjectForTest.getVenta();
		lVentaBase.F_EstacionDeServicio__c = lEstacion.id;
		lVentaBase.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVentaBase.RecordTypeId = VENTA_TYPE_TIENDA_ID;
		lVentaBase.F_OrigenVenta__c = TIENDA;
		lVentaBase.F_FechaTransaccion__c = Datetime.now();
		lVentaBase.F_Estado__c  = 'Pendiente';
		insert lVentaBase;

		Fielo_Venta__c lVenta = SObjectForTest.getVenta();
		lVenta.F_MontoTotal__c = lVariablesFraude.F_MaxMontoVentaTienda__c + 1;
		lVenta.F_EstacionDeServicio__c = lEstacion.id;
		lVenta.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVenta.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
		lVenta.F_OrigenVenta__c = TIENDA;
		lVenta.F_FechaTransaccion__c = Datetime.now();
		lVenta.F_Estado__c  = 'Pendiente';
		lVenta.F_Member__c = lMb.id;

		Fielo_Venta__c lVenta2 = SObjectForTest.getVenta();
		lVenta2.F_MontoTotal__c = lVariablesFraude.F_MaxMontoVentaTienda__c + 1;
		lVenta2.F_EstacionDeServicio__c = lEstacion.id;
		lVenta2.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVenta2.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
		lVenta2.F_OrigenVenta__c = TIENDA;
		lVenta2.F_FechaTransaccion__c = Datetime.now();
		lVenta2.F_Estado__c  = 'Pendiente';
		lVenta2.F_Member__c = lMb.id;
		insert lVenta2;

		Fielo_MedioDePagoVenta__c lMedPagoVenta = SObjectForTest.getMedioDePagoVenta();

		Fielo_ItemVenta__c lItemVenta = SObjectForTest.getItemVenta();
		lItemVenta.F_IdProducto__c = '1';
		lItemVenta.F_Cantidad__c = 51;

		Test.startTest();

		Fielo_Simulador lSimulador = new Fielo_Simulador();

			Map<String, List<SObject>> lResultMap = Fielo_Simulador.SimularVenta(lVenta, new List<Fielo_ItemVenta__c>{}, new List<Fielo_MedioDePagoVenta__c>{lMedPagoVenta});

		Test.stopTest();
	}

	@isTest static void simulateVenta() {
		
		Fielo_VariablesFraude__c lVariablesFraude = SObjectForTest.getVariablesFraude();
		insert lVariablesFraude;

		FieloPLT__Program__c lPrg = SObjectForTest.getProgram('Teste'); 
		insert lPrg; 

		FieloPLT__Member__c lMb = SObjectForTest.loadMember();

		Fielo_TasaConversion__c lTasa = SObjectForTest.getTasaConversion();
		insert lTasa;

		Ter_Estacion_de_Servicio__c lEstacion = SObjectForTest.getEstacionDeServicio();
		insert lEstacion;

		Fielo_Venta__c lVentaBase = SObjectForTest.getVenta();
		lVentaBase.F_EstacionDeServicio__c = lEstacion.id;
		lVentaBase.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVentaBase.RecordTypeId = VENTA_TYPE_TIENDA_ID;
		lVentaBase.F_OrigenVenta__c = TIENDA;
		lVentaBase.F_FechaTransaccion__c = Datetime.now();
		lVentaBase.F_Estado__c  = 'Aprobada';
		insert lVentaBase;

		Fielo_Venta__c lVenta = SObjectForTest.getVenta();
		lVenta.F_EstacionDeServicio__c = lEstacion.id;
		lVenta.F_Cliente__c = lMb.FieloPLT__Account__c;
		lVenta.RecordTypeId = VENTA_TYPE_TIENDA_ID;
		lVenta.F_OrigenVenta__c = ESTACION_DE_SERVICIO;
		lVenta.F_FechaTransaccion__c = Datetime.now();
		lVenta.F_Estado__c  = 'Pendiente';

		Fielo_MedioDePagoVenta__c lMedPagoVenta = SObjectForTest.getMedioDePagoVenta();

		Fielo_ItemVenta__c lItemVenta = SObjectForTest.getItemVenta();
		lItemVenta.F_IdProducto__c = '1';
		lItemVenta.F_Cantidad__c = 51;

		Test.startTest();

			Map<String, List<SObject>> lResultMap = Fielo_Simulador.SimularVenta(lVenta, new List<Fielo_ItemVenta__c>{lItemVenta}, new List<Fielo_MedioDePagoVenta__c>{lMedPagoVenta});

		Test.stopTest();
	}
}