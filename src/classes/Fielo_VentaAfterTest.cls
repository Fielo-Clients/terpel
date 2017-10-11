/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 30/05/2017
* 
* Name: Fielo_VentaAfterTest.trigger
* 
* Classe de teste da trigger Fielo_OnVentaAfter.trigger
*
*******************************************************************************/
@isTest
private class Fielo_VentaAfterTest {
	
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

	@isTest static void montosFidelizables() {		

		Test.startTest();

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
			insert lVenta;

			Fielo_MedioDePago__c lMedPago = SObjectForTest.getMedioDePago();
			insert lMedPago;

			Fielo_MedioDePagoVenta__c lMedPagoVenta = SObjectForTest.getMedioDePagoVenta();
			lMedPagoVenta.F_MedioDePago__c = lMedPago.id;
			lMedPagoVenta.F_Venta__c = lVenta.id;
			insert lMedPagoVenta;

			Fielo_ItemVenta__c lItemVenta = SObjectForTest.getItemVenta();
			lItemVenta.F_Venta__c = lVenta.id;
			lItemVenta.F_IdProducto__c = '1';
			insert lItemVenta;

			lVenta.RecordTypeId = VENTA_TYPE_TIENDA_ID;
			lVenta.F_OrigenVenta__c = TIENDA;
			lVenta.F_Estado__c  = 'Procesar';
			update lVenta;

			lVenta.RecordTypeId = VENTA_TYPE_LIQUIDO_ID;
			lVenta.F_OrigenVenta__c = ESTACION_DE_SERVICIO;
			lVenta.F_Estado__c  = 'Procesar';
			update lVenta;
			
		Test.stopTest();
	}
}