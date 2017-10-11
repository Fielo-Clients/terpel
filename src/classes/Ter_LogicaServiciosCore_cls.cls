/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase que contiene la logica especifica para las transacciones de Acumulacion/Redencion/Reclamacion y cambio de medio de pago.
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    05/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class Ter_LogicaServiciosCore_cls {
	
	private Fielo_Venta__c objVenta;
	private Fielo_MedioDePagoVenta__c objMedioPagoVenta;
	private Fielo_ItemVenta__c objItemVenta;
	private Fielo_MedioDePago__c objMedioPagoFielo;
	private Fielo_Autorizacion_LifeMiles__c objAutorizacionLifeMiles;
	private Fielo_Autorizacion_LifeMiles__c objAutorizacionLifeMilesRedencion;
	private FieloPLT__Member__c objMember;
	private list<Fielo_MedioDePagoVenta__c> lstMedioPagoVenta;
	private list<Fielo_ItemVenta__c> lstItemVenta;
	private list<Fielo_MedioDePago__c> lstMedioPago;
	private list<Fielo_InfraccionFraude__c> lstInfraccionFraude;
	private list<FieloPLT__RedemptionItem__c> lstRedemptionItems;
	private map<string, Ter_Homologacion_Listas__c> mapDatosHomologados;
	private map<String, String> mapCodigosError;
	private boolean blnErrorAcumulacion;
	private String strOrigenTransaccion;
	private String strPIN;
	private Decimal decMillasRedimir;
	
	public static final String COMODIN_CAMPOS = '<<campo>>';
	public static final String FORMATO_FECHA_RTA = 'yyyy-MM-dd hh:mm:ss';
	
	
	/* 
	* Nombre: procesaTransaccion
    * Descripcion: Metodo que contiene la logica necesaria para el procesamiento de las transacciones de acumulacion
    * Fecha Creación: 06/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            06-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse procesaTransaccion(SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente objAcumulaRedimeCliente, SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo objContextoTransaccionalTipo){
		SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse objAcumularRedimirResponse;
		SrvIntClienteTransaccion_in.DT_AcumulaRedimeClienteResponse objAcumulaRedimeClienteResponse;
		SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo objContextoRespuestaTipo;
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo;
		list<SrvIntClienteTransaccion_in.DT_ErrorTipo> lstErrorTipo;
		list<Fielo_Venta__c> lstVentas;
		list<Fielo_MedioDePago__c> lstMedioPagoFielo;
		list<Fielo_MedioDePagoVenta__c> lstMedioDePagoVentaBorrar;
		set<String> lstCodigosMedioPago; 
		Ter_LogicaServiciosGeneral_cls objLogicaServiciosGeneral;
		Ter_Estacion_de_Servicio__c objEDS;
		Ter_Negocio_Complementario__c objTDC;
		Fielo_MedioDePago__c objMedioPagoFielo;
		Datetime dtFechaTransaccion;
		String strFechaRta;
		String strIdVenta;
		boolean blnExisteVenta;
		
		/*******************************************/
		Datetime dtLlegadaFielo =  Datetime.now();
		long miliLlegadaFielo = dtLlegadaFielo.getTime();
		/*******************************************/
		
		objAcumularRedimirResponse = new SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse();
		objAcumulaRedimeClienteResponse = new SrvIntClienteTransaccion_in.DT_AcumulaRedimeClienteResponse();
		mapDatosHomologados = Ter_Utilidades_cls.obtenerDatosHomologados(new set<String> { 'Fielo_Venta__c', 'FieloPLT__Member__c' });
		blnErrorAcumulacion = false;
		blnExisteVenta = false;
		lstErrorTipo = new list<SrvIntClienteTransaccion_in.DT_ErrorTipo>();
		objContextoRespuestaTipo = new SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo();
		this.lstItemVenta = new list<Fielo_ItemVenta__c>();
		
		dtFechaTransaccion = Ter_Utilidades_cls.stringToDatetime(objAcumulaRedimeCliente.fechaTransaccion);
		
		strIdVenta = objAcumulaRedimeCliente.idPuntoVenta + objAcumulaRedimeCliente.idVenta + Ter_Utilidades_cls.formatearFecha(dtFechaTransaccion);
		
		objFalloTipo = validarCamposObligatorios(objAcumulaRedimeCliente);
		
		if(objFalloTipo != null){
			//objAcumulaRedimeClienteResponse.falloTipo = objFalloTipo;
			objAcumulaRedimeClienteResponse.idResponse = 0;
			objAcumulaRedimeClienteResponse.descResponse = 'Error procesando la transacción';
			
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
		}
		
		//Se consulta y se valida la Estacion de Servicio o Tienda de Conveniencia segun haya llegado
		objLogicaServiciosGeneral = new Ter_LogicaServiciosGeneral_cls();
		if(label.Ter_lbl_EDS.equals(objAcumulaRedimeCliente.origenTransaccion)){
			objEDS = objLogicaServiciosGeneral.consultarEDS(objAcumulaRedimeCliente.idPuntoVenta);
			this.strOrigenTransaccion = label.Ter_lbl_EDS;
			if(objEDS == null){
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
				objErrorTipo.valDescError = label.Fielo_PuntoDeVentaInexistente;
				objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaInexistente;
				lstErrorTipo.add(objErrorTipo);
			} else if (!objEDS.F_ClubTerpel__c || !objEDS.Ter_Estatus__c.equals('Activa')) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
				objErrorTipo.valDescError = label.Ter_lbl_PDV_No_Es_ClubTerpel;
				objErrorTipo.valDescErrorTecnico = label.Ter_lbl_PDV_No_Es_ClubTerpel;
				lstErrorTipo.add(objErrorTipo);
			} else{
				if(label.Ter_lbl_TipoTransaccion_Acumulacion.equals(objAcumulaRedimeCliente.tipoTransaccion) && !objEDS.F_Acumula__c){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
					objErrorTipo.valDescError = label.Fielo_PuntoDeVentaNoAcumula;
					objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaNoAcumula;
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(label.Ter_lbl_TipoTransaccion_Reclamacion.equals(objAcumulaRedimeCliente.tipoTransaccion) && !objEDS.F_Reclama__c){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
					objErrorTipo.valDescError = label.Ter_lbl_PDV_No_Reclama;
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_PDV_No_Reclama;
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) && !objEDS.F_Redime__c){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
					objErrorTipo.valDescError = label.Ter_lbl_PDV_No_Redime;
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_PDV_No_Redime;
					lstErrorTipo.add(objErrorTipo);
				}
			}
		} else if(label.Ter_lbl_TDC.equals(objAcumulaRedimeCliente.origenTransaccion)){
			objTDC = objLogicaServiciosGeneral.consultarTTCC(objAcumulaRedimeCliente.idPuntoVenta);
			this.strOrigenTransaccion = label.Ter_lbl_TDC;
			
			if(objTDC == null){
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
				objErrorTipo.valDescError = label.Fielo_PuntoDeVentaInexistente;
				objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaInexistente;
				lstErrorTipo.add(objErrorTipo);
			} else if (!objTDC.F_ClubTerpel__c) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
				objErrorTipo.valDescError = label.Fielo_PuntoDeVentaNoAcumula;
				objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaNoAcumula;
				lstErrorTipo.add(objErrorTipo);
			} else{
				if((label.Ter_lbl_TipoTransaccion_Acumulacion.equals(objAcumulaRedimeCliente.tipoTransaccion) 
						|| label.Ter_lbl_Acumulacion_TDC.equals(objAcumulaRedimeCliente.tipoTransaccion)) 
						&& !objTDC.F_Acumula__c){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
					objErrorTipo.valDescError = label.Fielo_PuntoDeVentaNoAcumula;
					objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaNoAcumula;
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(label.Ter_lbl_TipoTransaccion_Reclamacion.equals(objAcumulaRedimeCliente.tipoTransaccion) && !objTDC.F_Reclama__c){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
					objErrorTipo.valDescError = label.Ter_lbl_PDV_No_Reclama;
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_PDV_No_Reclama;
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) && !objTDC.F_Redime__c){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
					objErrorTipo.valDescError = label.Ter_lbl_PDV_No_Redime;
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_PDV_No_Redime;
					lstErrorTipo.add(objErrorTipo);
				}
			}
		} else{
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
			objErrorTipo.valDescError = label.Ter_lbl_Error_Origen_Transaccion;
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Error_Origen_Transaccion;
			lstErrorTipo.add(objErrorTipo);
		}
		
		//Consultamos y validamos el member que llego en la transaccion
		if(!label.Ter_lbl_Acumulacion_TDC.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			try{
				String striTipoDocHomologado = mapDatosHomologados.get('FieloPLT__Member__c' + 'F_IdentificationType__c' +objAcumulaRedimeCliente.tipoDocumento.codTipoidentificacion).Ter_Valor_Homologado__c;
				this.objMember = objLogicaServiciosGeneral.obtenerMember(striTipoDocHomologado, objAcumulaRedimeCliente.tipoDocumento.valNumeroIdentificacion);
				this.strPIN = objAcumulaRedimeCliente.tipoDocumento.pin;
			} catch (Ter_ValidationException e){
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
				objErrorTipo.valDescError = e.getMessage();
				objErrorTipo.valDescErrorTecnico = e.getMessage();
				lstErrorTipo.add(objErrorTipo);
			}
		}
		
		if(label.Ter_lbl_TipoTransaccion_Acumulacion.equals(objAcumulaRedimeCliente.tipoTransaccion) 
			&& this.objMember != null 
			&& this.objMember.RecordType.DeveloperName.equals(label.Ter_lbl_RT_ClienteLifeMiles)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
			objErrorTipo.valDescError = label.Ter_lbl_Error_Cliente_No_Acumula;
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Error_Cliente_No_Acumula;
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(!lstErrorTipo.isEmpty()){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFechaRta;
			objFalloTipo.errores = lstErrorTipo;
			
			//objAcumulaRedimeClienteResponse.falloTipo = objFalloTipo;
			objAcumulaRedimeClienteResponse.idResponse = 0;
			objAcumulaRedimeClienteResponse.descResponse = 'Error procesando la transacción';
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
		}
		
		//Se valida si la transaccion llego por el proceso alternativo a las Tiendas de Conveniencia
		if(label.Ter_lbl_Acumulacion_TDC.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			return new Ter_LogicaAlternativaTDC_cls().procesaTransaccion(objAcumulaRedimeCliente, objContextoTransaccionalTipo, objTDC, miliLlegadaFielo);
		}
		
		//Se consulta si ya hay una venta registrada con el IdVenta que llego
		lstVentas = [SELECT F_IdVenta__c, F_FechaTransaccion__c, F_TipoTransaccion__c, F_MontoTotal__c, F_Descuento__c, 
							F_Impuesto__c, F_ValorAPagar__c, F_IDPromotorCajero__c, F_EstacionDeServicio__c, F_Tienda__c, 
							F_OrigenVenta__c, F_Cliente__c, F_TipoVenta__c, F_Member__c, F_Estado__c 
				    FROM Fielo_Venta__c 
				    WHERE F_IdVenta__c = :strIdVenta];
		
		//Si es acumulacion y la venta ya existia se considera una venta duplicada
		if(label.Ter_lbl_TipoTransaccion_Acumulacion.equals(objAcumulaRedimeCliente.tipoTransaccion) && !lstVentas.isEmpty()){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objAcumulaRedimeClienteResponse.idResponse = 1;
			objAcumulaRedimeClienteResponse.descResponse = 'Acumulación duplicada';
			
			objContextoRespuestaTipo.codEstadoTx = 'Acumulación duplicada';
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
		}
		
		//Se si la venta viene de una estacion de servicio y es una redencion o reclamacion la venta debio haber entrado previamente
		//y esto seria como una actualizacion de medio de pago, por lo tanto la venta tiene que existir para que sea actualizada
		if(label.Ter_lbl_EDS.equals(objAcumulaRedimeCliente.origenTransaccion) 
			&& (label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) || label.Ter_lbl_TipoTransaccion_Reclamacion.equals(objAcumulaRedimeCliente.tipoTransaccion))
			&& lstVentas.isEmpty()){
				
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objAcumulaRedimeClienteResponse.idResponse = 1;
			objAcumulaRedimeClienteResponse.descResponse = 'La venta debió haberse insertado previamente';
			
			objContextoRespuestaTipo.codEstadoTx = 'La venta debió haberse insertado previamente';
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
		}
		
		if(label.Ter_lbl_EDS.equals(objAcumulaRedimeCliente.origenTransaccion) 
			&& (label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) 
				|| label.Ter_lbl_TipoTransaccion_Reclamacion.equals(objAcumulaRedimeCliente.tipoTransaccion))){
			this.objVenta = lstVentas.get(0);
			blnExisteVenta = true;
			
			//Se consultan los medios de pago de la venta que ya se habia registrado antes
			lstMedioDePagoVentaBorrar = [SELECT Id FROM Fielo_MedioDePagoVenta__c WHERE F_Venta__c = :this.objVenta.Id];
			
		} else{
			this.objVenta = new Fielo_Venta__c();
			this.objVenta.F_IdVenta__c = strIdVenta;
			this.objVenta.F_FechaTransaccion__c = dtFechaTransaccion;
			this.objVenta.F_TipoTransaccion__c = mapDatosHomologados.get('Fielo_Venta__c'+'F_TipoTransaccion__c'+objAcumulaRedimeCliente.tipoTransaccion).Ter_Valor_Homologado__c;//Homologar
			this.objVenta.F_MontoTotal__c = objAcumulaRedimeCliente.montoTotal;
			this.objVenta.F_Descuento__c = objAcumulaRedimeCliente.descuento;
			this.objVenta.F_Impuesto__c = objAcumulaRedimeCliente.impuesto;
			this.objVenta.F_ValorAPagar__c = objAcumulaRedimeCliente.valorPagar;
			this.objVenta.F_IDPromotorCajero__c = objAcumulaRedimeCliente.idPromotor;
			this.objVenta.F_EstacionDeServicio__c = (objEDS == null)?null:objEDS.Id;
			this.objVenta.F_Tienda__c = (objTDC == null)?null:objTDC.Id;
			this.objVenta.F_OrigenVenta__c = mapDatosHomologados.get('Fielo_Venta__c'+'F_OrigenVenta__c'+objAcumulaRedimeCliente.origenTransaccion).Ter_Valor_Homologado__c;//Homologar
			this.objVenta.F_Cliente__c = objMember.FieloPLT__Account__c;
			this.objVenta.F_TipoVenta__c = mapDatosHomologados.get('Fielo_Venta__c'+'F_TipoVenta__c'+objAcumulaRedimeCliente.tipoVenta).Ter_Valor_Homologado__c;//Homologar
			this.objVenta.F_Member__c = this.objMember.Id;
			this.objVenta.F_Estado__c = 'Pendiente';
			
			if(objAcumulaRedimeCliente.productos == null || objAcumulaRedimeCliente.productos.size() > 0){
				for(SrvIntClienteTransaccion_in.DT_Producto objProducto : objAcumulaRedimeCliente.productos){
					this.objItemVenta = new Fielo_ItemVenta__c();
					this.objItemVenta.F_IdProducto__c = objProducto.idProducto;
					this.objItemVenta.F_Cantidad__c = objProducto.cantidad;
					this.objItemVenta.F_ValorUnitario__c = objProducto.valorUnitario;
					this.lstItemVenta.add(this.objItemVenta);
				}
			}
			
			this.objAutorizacionLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
			this.objAutorizacionLifeMiles.F_Member__c = this.objMember.Id;
			this.objAutorizacionLifeMiles.F_NumeroLifeMiles__c = this.objMember.F_NumeroLifeMiles__c;
		}
		
		
		
		if(objAcumulaRedimeCliente.mediosPago == null || objAcumulaRedimeCliente.mediosPago.size() > 0){
			this.lstMedioPagoVenta = new list<Fielo_MedioDePagoVenta__c>();
			lstCodigosMedioPago = new set<String>();
			
			for(SrvIntClienteTransaccion_in.DT_MedioPago objMedioPago : objAcumulaRedimeCliente.mediosPago){
				lstCodigosMedioPago.add(objMedioPago.codigoMedioPago+'');
			}
			
			map<String, Fielo_MedioDePago__c> mapMedioPago = objLogicaServiciosGeneral.consultarMedioPago(lstCodigosMedioPago, this.strOrigenTransaccion);
			
			this.decMillasRedimir = 0.0;
			for(SrvIntClienteTransaccion_in.DT_MedioPago objMedioPago : objAcumulaRedimeCliente.mediosPago){
				this.objMedioPagoVenta = new Fielo_MedioDePagoVenta__c();
				objMedioPagoFielo = mapMedioPago.get(objMedioPago.codigoMedioPago+'');
				this.objMedioPagoVenta.F_MedioDePago__c = objMedioPagoFielo.Id;
				this.objMedioPagoVenta.F_MillasRedimidas__c = objMedioPago.millasRedimidas;
				if(objMedioPago.millasRedimidas != null){
					this.decMillasRedimir += objMedioPago.millasRedimidas;
				}
				this.objMedioPagoVenta.F_Monto__c = objMedioPago.monto;
				this.objMedioPagoVenta.F_CodigoVoucher__c = objMedioPago.codigoVoucher;
				if(blnExisteVenta){
					this.objMedioPagoVenta.F_Venta__c = this.objVenta.Id;
				}
				this.lstMedioPagoVenta.add(this.objMedioPagoVenta);
			}
		}
		
		
		if(label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			try{
				procesaRedencion();
			} catch(Exception e){
				//Error Inesperado
				this.objVenta.F_Estado__c = 'Rechazada';
				this.objVenta.F_MotivoRechazo__c = e.getMessage();
				blnErrorAcumulacion = true;
				System.Debug('====================== EXCEPCION ======================');
	            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
	            System.Debug('=======================================================');
			}
		} else if(label.Ter_lbl_TipoTransaccion_Acumulacion.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			try{
				procesaAcumulacion();
			} catch(Ter_AcumulacionException ae){
				//Error Controlado
				this.objVenta.F_Estado__c = 'Reintentar';
				this.objVenta.F_MotivoRechazo__c = ae.getMessage();
				blnErrorAcumulacion = true;
			} catch(Ter_RespuestaFallidaException ae){
				//Error Controlado
				this.objVenta.F_Estado__c = 'Rechazada';
				this.objVenta.F_MotivoRechazo__c = ae.getMessage();
				blnErrorAcumulacion = true;
			} catch(Ter_FraudeException e){
				//Error Controlado
				//Cuando ocurre esta excepcion la venta ya viene en estado Rechazada y ya tiene un MotivoRechazo
				blnErrorAcumulacion = true;
			} catch(Exception e){
				//Error Inesperado
				this.objVenta.F_Estado__c = 'Reintentar';
				this.objVenta.F_MotivoRechazo__c = e.getMessage();
				blnErrorAcumulacion = true;
				System.Debug('====================== EXCEPCION ======================');
	            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
	            System.Debug('=======================================================');
			}
		} else if(label.Ter_lbl_TipoTransaccion_ReversoRedencion.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			
		} else if(label.Ter_lbl_TipoTransaccion_ReversoAcumulacion.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			
		} else if(label.Ter_lbl_TipoTransaccion_AcumulacionOffLine.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			
		} else if(label.Ter_lbl_TipoTransaccion_Reclamacion.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			objFalloTipo = null;
			
			objFalloTipo = procesaReclamacion();
			
			if(objFalloTipo != null){
				//objAcumulaRedimeClienteResponse.falloTipo = objFalloTipo;
				objAcumulaRedimeClienteResponse.idResponse = 0;
				objAcumulaRedimeClienteResponse.descResponse = 'Error procesando la transacción';
				
				strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
				
				objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
				objContextoRespuestaTipo.fechaTx = strFechaRta;
				
				objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
				objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
				objAcumularRedimirResponse.falloTipo = objFalloTipo;
				
				return objAcumularRedimirResponse;
			}
		} else if(label.Ter_lbl_TipoTransaccion_Cambio_MedioPago.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			
		} else{
			//Error tipo de transaccion invalida. 
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
			objErrorTipo.valDescError = label.Ter_lbl_Error_Origen_Transaccion;
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Error_Origen_Transaccion;
			lstErrorTipo.add(objErrorTipo);
			
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFechaRta;
			objFalloTipo.errores = lstErrorTipo;
			
			//objAcumulaRedimeClienteResponse.falloTipo = objFalloTipo;
			objAcumulaRedimeClienteResponse.idResponse = 0;
			objAcumulaRedimeClienteResponse.descResponse = 'El tipo de transaccion no se pudo identificar';
			
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
			
		}
		
		if(!blnErrorAcumulacion){
			this.objVenta.F_Estado__c = 'Pendiente';
		}
		
		if(!blnExisteVenta){
			insert this.objVenta;
			system.debug('............. this.objVenta.Id: ' + this.objVenta.Id);
		}else{
			system.debug('............. NO VA A INSERTAR VENTA');
		}
		
		if(this.lstInfraccionFraude != null && !this.lstInfraccionFraude.isEmpty()){
			for(Integer i=0; i < this.lstInfraccionFraude.size(); i++){
				lstInfraccionFraude[i].F_Venta__c = this.objVenta.Id;
				lstInfraccionFraude[i].F_Member__c = this.objMember.Id;
			}
			insert lstInfraccionFraude;
		}
		
		
		//if (!this.objVenta.F_Estado__c.equals('Rechazada')) {
		if (this.objVenta.Id != null) {	
			if(blnExisteVenta && (label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) 
								|| label.Ter_lbl_TipoTransaccion_Reclamacion.equals(objAcumulaRedimeCliente.tipoTransaccion))){
				system.debug('............. NO VA A INSERTAR AUTORIZACION LIFEMILES POR QUE ES RECLAMACION O REDENCION Y LA VENTA YA EXISTIA');
			} else{
				this.objAutorizacionLifeMiles.F_Venta__c = this.objVenta.Id;
				insert this.objAutorizacionLifeMiles;
			}
		}
		
		//Se actualizan los vouchers en caso que hayan sido procesados y se marcan como usado (en caso que aplique)
		/**** REVISAR SI LA ACUMULACION SE RECHAZA LA RECLAMACION NO SE DEBE PROCESAR O SI ***/
		if(this.objVenta.F_Estado__c.equals('Rechazada') && this.lstRedemptionItems != null && !this.lstRedemptionItems.isEmpty()){
			for(FieloPLT__RedemptionItem__c objRedemptionItem : this.lstRedemptionItems){
				objRedemptionItem.FieloPLT__Status__c = label.Ter_lbl_VoucherUsado;
			}
			
			update this.lstRedemptionItems;
		}
		
		if(label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion)){
			this.objAutorizacionLifeMilesRedencion.F_Venta__c = this.objVenta.Id;
			insert this.objAutorizacionLifeMilesRedencion;
		}
		
		if(lstMedioDePagoVentaBorrar != null && !lstMedioDePagoVentaBorrar.isEmpty() && ! blnErrorAcumulacion){
			system.debug('............. VA A BORRAR LOS MEDIOS DE PAGO');
			delete lstMedioDePagoVentaBorrar;
		}

		for(Fielo_ItemVenta__c objItemVentaAux : this.lstItemVenta){
			objItemVentaAux.F_Venta__c = this.objVenta.Id;
		}
		
		insert this.lstItemVenta;
		
		for(Fielo_MedioDePagoVenta__c objMedioPagoVentaAux : this.lstMedioPagoVenta){
			objMedioPagoVentaAux.F_Venta__c = this.objVenta.Id;
		}
		
		insert this.lstMedioPagoVenta;
		
		if(!blnErrorAcumulacion){
			if(!blnExisteVenta){
				this.objVenta.F_Estado__c = 'Procesar';
				update this.objVenta;
			} else{
				system.debug('............. NO VA A ACTUALIZAR VENTA');
			}
			
			objAcumulaRedimeClienteResponse.descResponse = 'Transacción Exitosa';
			if (lstInfraccionFraude != null && !lstInfraccionFraude.isEmpty()) {

				objAcumulaRedimeClienteResponse.descResponse += ' ' + lstInfraccionFraude.get(0).F_Descripcion__c;
			}
		} else{
			if (this.objVenta.F_Estado__c.equals('Rechazada')) {
				objAcumulaRedimeClienteResponse.descResponse = this.objVenta.F_MotivoRechazo__c;
			}
			else {
				objAcumulaRedimeClienteResponse.descResponse = label.Ter_lbl_Mensaje_Error_Acumulacion_LM;
			}
		}
		
		//Se debe armar respuesta para el POS
		//objAcumulaRedimeClienteResponse.falloTipo = objFalloTipo; 
		if(label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) && blnErrorAcumulacion){
			system.debug('............. VA A PONER 0 (ERROR) EN LA RESPUESTA');
			objAcumulaRedimeClienteResponse.idResponse = 0;
			objContextoRespuestaTipo.codEstadoTx = '0';
		} else{
			system.debug('............. VA A PONER 1 (OK) EN LA RESPUESTA');
			objAcumulaRedimeClienteResponse.idResponse = 1;
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Ok;
		}
		
		objAcumulaRedimeClienteResponse.infoMillasAcumuladas = Integer.valueOf(this.objAutorizacionLifeMiles.F_MillasBase__c);
		objAcumulaRedimeClienteResponse.nombreCliente = (String.isEmpty(objMember.F_PrimerNombre__c) ? '' : objMember.F_PrimerNombre__c + ' ') 
														+ (String.isEmpty(objMember.F_SegundoNombre__c) ? '' : objMember.F_SegundoNombre__c + ' ' ) 
														+ (String.isEmpty(objMember.F_PrimerApellido__c) ? '' : objMember.F_PrimerApellido__c + ' ')  
														+ (String.isEmpty(objMember.F_SegundoApellido__c) ? '' : objMember.F_SegundoApellido__c);
		
		strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
		
		
		objContextoRespuestaTipo.fechaTx = strFechaRta;
		
		objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
		objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
		objAcumularRedimirResponse.falloTipo = objFalloTipo;
		
		/*setIdVentas.remove(strIdVenta);
		system.debug('........... removio idVenta de cache');
		Cache.Org.put('local.partition1.cacheVentas', setIdVentas);*/
		
		/*******************************************/
		Datetime dtSalidaFielo =  Datetime.now();
		long miliSalidaFielo = dtSalidaFielo.getTime();
		/*******************************************/
		
		try{
			Ter_LogTransaccional__c objLog = new Ter_LogTransaccional__c();
			
			if(objContextoTransaccionalTipo != null){
                objLog.Ter_CodigoTipoEvento__c = objContextoTransaccionalTipo.codTipoEvento;
                objLog.Ter_FechaEvento__c = objContextoTransaccionalTipo.fecEvento;
                objLog.Ter_Usuario__c = objContextoTransaccionalTipo.valUsuario;
            } else{
                objLog.Ter_CodigoTipoEvento__c = 'N/A';
                objLog.Ter_FechaEvento__c = 'N/A';
                objLog.Ter_Usuario__c = 'N/A';
            }
			objLog.Ter_CodigoEstadoRespuesta__c = objAcumularRedimirResponse.contextoRespuestaTipo.codEstadoTx;
			objLog.Ter_FechaRespuesta__c = objAcumularRedimirResponse.contextoRespuestaTipo.fechaTx;
			if(this.objVenta != null && this.objVenta.Id != null){
				objLog.Ter_Venta__c = this.objVenta.Id;
			}
			objLog.Ter_TiempoLlegada__c = miliLlegadaFielo;
			objLog.Ter_TiempoSalida__c = miliSalidaFielo;
			objLog.Ter_JsonRequest__c = system.JSON.serialize(objAcumulaRedimeCliente);
			objLog.Ter_JsonResponse__c = system.JSON.serialize(objAcumularRedimirResponse);
			insert objLog;
		} catch(Exception e){
			system.debug('Error guardando LogTransaccional: ' + e.getMessage());
		}

		return objAcumularRedimirResponse;

	}
	
	/* 
	* Nombre: procesaAcumulacion
    * Descripcion: Metodo que contiene la logica necesaria para el procesamiento de las transacciones de acumulacion
    * Fecha Creación: 06/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            06-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public void procesaAcumulacion(){
		Ter_ConversionWsConsumer_cls objConversionWsConsumer;
		Ter_ConversionWsResponseDTO_cls objResponse;
		Fielo_Autorizacion_LifeMiles__c objAutorizacionLifeMilesAux;
		list<Fielo_Venta__c> lstVenta;
		list<Fielo_Autorizacion_LifeMiles__c> lstAutorizacionLifeMiles;
		
		//Llamar al sumulador de fielo
		this.objVenta.F_Estado__c = 'Procesar';
		System.Debug('========>>>> [Normal] ObjVenta antes de Simulador: ' + this.objVenta);
		Map<String, list<SObject>> mapMillasSimuladas;
		try{
			mapMillasSimuladas = Fielo_Simulador.SimularVenta(this.objVenta, this.lstItemVenta, this.lstMedioPagoVenta);
		} catch(Exception e){
			System.Debug('====================== EXCEPCION SimularVenta ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('====================================================================');
            throw new Ter_AcumulacionException('No se pudo calcular las millas para la venta.');
		}
		
		if(mapMillasSimuladas == null){
			throw new Ter_AcumulacionException('No se pudo calcular las millas para la venta.');
		}
		
		if(mapMillasSimuladas.containsKey('Fielo_Venta__c')){
			lstVenta = mapMillasSimuladas.get('Fielo_Venta__c');
			if (lstVenta != null && !lstVenta.isEmpty()) {
				System.debug('Estado Venta-->' + lstVenta.get(0).F_Estado__c);
			}
		}
		
		if(mapMillasSimuladas.containsKey('Fielo_Autorizacion_LifeMiles__c')){
			lstAutorizacionLifeMiles = mapMillasSimuladas.get('Fielo_Autorizacion_LifeMiles__c');
		}
		
		if(lstAutorizacionLifeMiles != null && !lstAutorizacionLifeMiles.isEmpty()){
			objAutorizacionLifeMilesAux = lstAutorizacionLifeMiles.get(0);
		}
		
		if(mapMillasSimuladas.containsKey('Fielo_InfraccionFraude__c')){
			lstInfraccionFraude = mapMillasSimuladas.get('Fielo_InfraccionFraude__c');
			if (lstInfraccionFraude != null && !lstInfraccionFraude.isEmpty()) {
				System.debug('Infracion desc-->' + lstInfraccionFraude.get(0).F_Descripcion__c);
			}
		}
		
		if(lstVenta != null && !lstVenta.isEmpty()){
			this.objVenta = lstVenta.get(0);
		}
		
		//El simulador retorna la venta como rechazada debido a las validaciones de fraude
		if(this.objVenta.F_Estado__c.equals('Rechazada')){
			throw new Ter_FraudeException(this.objVenta.F_MotivoRechazo__c);
		}
		
		this.objAutorizacionLifeMiles.F_MillasBase__c = objAutorizacionLifeMilesAux.F_MillasBase__c;
		this.objAutorizacionLifeMiles.F_MillasPromocionales__c = objAutorizacionLifeMilesAux.F_MillasPromocionales__c;
		this.objAutorizacionLifeMiles.F_TipoTransaccion__c = 'Crédito (C)';
		
		if(this.objMember != null  && this.objMember.RecordType.DeveloperName.equals(label.Ter_lbl_RT_TarjetaPreinscrita)){
			this.objAutorizacionLifeMiles.F_Estado__c = 'Cancelado';
			this.objAutorizacionLifeMiles.F_MotivoRechazo__c = Label.Fielo_TarjetaPreinscritaNoAcumulaEnLM;
			//No se envia la transaccion a LifeMiles
			return;
		}
		
		objConversionWsConsumer = new Ter_ConversionWsConsumer_cls();
		
		try{
			objResponse = objConversionWsConsumer.invokeMilesConversion(this.objAutorizacionLifeMiles);
			system.debug('=========== objResponse' + objResponse);
		} catch (Ter_AcumulacionException ae) {
			throw ae;
		} catch (Exception e) {
			System.Debug('====================== EXCEPCION ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=======================================================');
			throw new Ter_AcumulacionException(label.Ter_lbl_Mensaje_Error_Acumulacion_LM);
		} 
		
		mapCodigosError = Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_Proceso_Acumulacion);
		
		this.objAutorizacionLifeMiles.F_CodigoRespuestaLM__c = objResponse.getResponseCode();
		
		if(!label.Ter_lbl_Codigo_Exito_Acumulacion_LM.equals(objResponse.getResponseCode())){
			this.objAutorizacionLifeMiles.F_Estado__c = 'Rechazado';
			if(mapCodigosError.containsKey(objResponse.getResponseCode())){
				this.objAutorizacionLifeMiles.F_MotivoRechazo__c = mapCodigosError.get(objResponse.getResponseCode());
				throw new Ter_RespuestaFallidaException(mapCodigosError.get(objResponse.getResponseCode()));
			} else{
				this.objAutorizacionLifeMiles.F_MotivoRechazo__c = label.Ter_lbl_Error_General_Acumulacion;
				throw new Ter_RespuestaFallidaException(label.Ter_lbl_Error_General_Acumulacion);
			}
		}
		
		this.objAutorizacionLifeMiles.F_NumeroAutorizacionLM__c = objResponse.getAuthoNum();
		this.objAutorizacionLifeMiles.F_MillasBonus__c = objResponse.getBonusMiles();
		this.objAutorizacionLifeMiles.F_Estado__c = 'Aprobado';
	}
	
	/* 
	* Nombre: procesaRedencion
    * Descripcion: Metodo que contiene la logica necesaria para el procesamiento de las transacciones de redencion
    * Fecha Creación: 07/09/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            07-Sep-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public void procesaRedencion(){
		Ter_LifeMilesConversionWsConsumer_cls objLifeMilesConversionWsConsumer;
		Ter_ResponseRedentionDTO_cls objResponse;
		
		if(String.isBlank(this.strPIN)){
			throw new Ter_AcumulacionException(label.Ter_lbl_Error_No_PIN); 
		}
		
		if(label.Ter_lbl_TDC.equals(this.strOrigenTransaccion)){
			try{
				procesaAcumulacion();
			} catch(Ter_AcumulacionException ae){
				//Error Controlado
				this.objVenta.F_Estado__c = 'Reintentar';
				this.objVenta.F_MotivoRechazo__c = ae.getMessage();
				blnErrorAcumulacion = true;
			} catch(Ter_RespuestaFallidaException ae){
				//Error Controlado
				this.objVenta.F_Estado__c = 'Rechazada';
				this.objVenta.F_MotivoRechazo__c = ae.getMessage();
				blnErrorAcumulacion = true;
			} catch(Ter_FraudeException e){
				//Error Controlado
				//Cuando ocurre esta excepcion la venta ya viene en estado Rechazada y ya tiene un MotivoRechazo
				blnErrorAcumulacion = true;
			} catch(Exception e){
				//Error Inesperado
				this.objVenta.F_Estado__c = 'Reintentar';
				this.objVenta.F_MotivoRechazo__c = e.getMessage();
				blnErrorAcumulacion = true;
				System.Debug('====================== EXCEPCION ======================');
	            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
	            System.Debug('=======================================================');
			}
		}

		
		system.debug('........... decMillasRedimir: ' + this.decMillasRedimir);
		this.objAutorizacionLifeMilesRedencion = new Fielo_Autorizacion_LifeMiles__c();
		this.objAutorizacionLifeMilesRedencion.F_Member__c = this.objMember.Id;
		this.objAutorizacionLifeMilesRedencion.F_NumeroLifeMiles__c = this.objMember.F_NumeroLifeMiles__c;
		this.objAutorizacionLifeMilesRedencion.F_MillasBase__c = this.decMillasRedimir;
		this.objAutorizacionLifeMilesRedencion.F_MillasPromocionales__c = 0.0;
		this.objAutorizacionLifeMilesRedencion.F_TipoTransaccion__c = 'Débito (D)';
		this.objAutorizacionLifeMilesRedencion.F_MontoTransaccion__c = this.objVenta.F_ValorAPagar__c;
		
		objLifeMilesConversionWsConsumer = new Ter_LifeMilesConversionWsConsumer_cls();
		
		try{
			objResponse = objLifeMilesConversionWsConsumer.invokePostMilesStr(this.objAutorizacionLifeMilesRedencion, this.strPIN, null);
			system.debug('=========== objResponse Redencion: ' + objResponse);
		} catch (Ter_AcumulacionException ae) {
			throw ae;
		} catch (Exception e) {
			System.Debug('====================== EXCEPCION ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('=======================================================');
			throw new Ter_AcumulacionException(label.Ter_lbl_Mensaje_Error_Redencion_LM); 
		}
		
		mapCodigosError = Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_TipoTransaccion_Redencion);
		
		this.objAutorizacionLifeMilesRedencion.F_CodigoRespuestaLM__c = objResponse.getBody().getPostingResponse().getResponse_code();
		
		if(!label.Ter_lbl_Codigo_Exito_Redencion_LM.equals(objResponse.getBody().getPostingResponse().getResponse_code())){
			this.objAutorizacionLifeMilesRedencion.F_Estado__c = 'Rechazado';
			if(mapCodigosError.containsKey(objResponse.getBody().getPostingResponse().getResponse_code())){
				this.objAutorizacionLifeMilesRedencion.F_MotivoRechazo__c = mapCodigosError.get(objResponse.getBody().getPostingResponse().getResponse_code());
			} else{
				this.objAutorizacionLifeMilesRedencion.F_MotivoRechazo__c = label.Ter_lbl_Error_General_Redencion;
			}
			throw new Ter_AcumulacionException(this.objAutorizacionLifeMilesRedencion.F_MotivoRechazo__c);
		}
		
		this.objAutorizacionLifeMilesRedencion.F_NumeroAutorizacionLM__c = objResponse.getBody().getPostingResponse().getAutho_num();
		this.objAutorizacionLifeMilesRedencion.F_Estado__c = 'Aprobado';
	}

	/**
	 * Metodo encargado de realizacr el proceso de reclamaciónn.
	 */
	public SrvIntClienteTransaccion_in.DT_FalloTipo procesaReclamacion(){
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		
		objFalloTipo = validarVoucher();
		//if (result.isMemberValido() /*&& result.isPuntoVentaValido()*/ && result.isVoucherValido()) {
		if(objFalloTipo != null){
			return objFalloTipo;
		} else{
			//Si la transaccion es desde una tienda de conveniencia se procesa la acumulacion
			//ya que desde las EDS la acumulacion se proceso antes de enviar el voucher
			if(label.Ter_lbl_TDC.equals(this.strOrigenTransaccion)){
				try{
					procesaAcumulacion();
				} catch(Ter_AcumulacionException ae){
					//Error Controlado
					this.objVenta.F_Estado__c = 'Reintentar';
					this.objVenta.F_MotivoRechazo__c = ae.getMessage();
					blnErrorAcumulacion = true;
				} catch(Ter_RespuestaFallidaException ae){
					//Error Controlado
					this.objVenta.F_Estado__c = 'Rechazada';
					this.objVenta.F_MotivoRechazo__c = ae.getMessage();
					blnErrorAcumulacion = true;
				} catch(Ter_FraudeException e){
					//Error Controlado
					//Cuando ocurre esta excepcion la venta ya viene en estado Rechazada y ya tiene un MotivoRechazo
					blnErrorAcumulacion = true;
				} catch(Exception e){
					//Error Inesperado
					this.objVenta.F_Estado__c = 'Reintentar';
					this.objVenta.F_MotivoRechazo__c = e.getMessage();
					blnErrorAcumulacion = true;
					System.Debug('====================== EXCEPCION ======================');
		            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
		            System.Debug('=======================================================');
				}
				
				
				/*if(!this.lstRedemptionItems.isEmpty()){
					for(FieloPLT__RedemptionItem__c objRedemptionItem : this.lstRedemptionItems){
						objRedemptionItem.FieloPLT__Status__c = label.TER_STATUS_READY_RECLAMATION;
					}
					
					update this.lstRedemptionItems;
				}*/
				
				return null;
			} else{
				//Si la transaccion no es desde tienda se retorna null
				system.debug('............. NO VA A ACUMULAR EN LA RECLAMACION');
				return null;
			}
			
			
		}
		
		
	}

	/**
	 * Metodo encargado de validar un voucher.
	 * @return el resultado de la validacion.
	 */
	public SrvIntClienteTransaccion_in.DT_FalloTipo validarVoucher(){
		Ter_LogicaServiciosGeneral_cls objLogicaServiciosGeneral = new Ter_LogicaServiciosGeneral_cls();
		
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo;
		list<SrvIntClienteTransaccion_in.DT_ErrorTipo> lstErrorTipo;
		
		decimal montoVouchers = 0.0;
		decimal montoOthersMethods = 0.0;
		SObject puntoVenta = null;
		FieloPLT__Member__c objMember;

		List <Fielo_MedioDePagoVenta__c> lstMedioPagoVouchers = new List <Fielo_MedioDePagoVenta__c>();
		List<String> codesVouchers = new List<String>();
		for (Fielo_MedioDePagoVenta__c medioPago : this.lstMedioPagoVenta) {
			if (String.isNotBlank(medioPago.F_CodigoVoucher__c)) {
				lstMedioPagoVouchers.add(medioPago);
				montoVouchers += medioPago.F_Monto__c;
				codesVouchers.add(medioPago.F_CodigoVoucher__c);
			}
			else {
				montoOthersMethods += medioPago.F_Monto__c;
			}
		}

		this.lstRedemptionItems = [SELECT id, FieloPLT__UniqueCode__c, FieloPLT__Redemption__r.FieloPLT__Member__c, 
										  FieloPLT__Status__c, FieloPLT__Reward__r.F_Monto__c 
								   FROM FieloPLT__RedemptionItem__c
								   WHERE FieloPLT__UniqueCode__c in :codesVouchers];

		List<id> idsMembers = new List<Id>();
		for (FieloPLT__RedemptionItem__c redItem : this.lstRedemptionItems) {
			idsMembers.add(redItem.FieloPLT__Redemption__r.FieloPLT__Member__c);
		}

		Map<String, FieloPLT__Member__c>  mapMembers = new Map<String, FieloPLT__Member__c> (
			[SELECT  id, FieloPLT__Status__c
			 FROM FieloPLT__Member__c 
			 WHERE id in :idsMembers]);


		map<String, FieloPLT__RedemptionItem__c> mapRedemptionItem = new map<String, FieloPLT__RedemptionItem__c>();
		for(FieloPLT__RedemptionItem__c objRedemptionAux : this.lstRedemptionItems){
			mapRedemptionItem.put(objRedemptionAux.FieloPLT__UniqueCode__c, objRedemptionAux);
		}
					
		lstErrorTipo = new list<SrvIntClienteTransaccion_in.DT_ErrorTipo>();
		
		for (Fielo_MedioDePagoVenta__c voucher : lstMedioPagoVouchers) {
			FieloPLT__RedemptionItem__c objRedemption = mapRedemptionItem.get(voucher.F_CodigoVoucher__c);
			if (objRedemption == null) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = Label.Fielo_ReclamacionVoucherInexistente + ' ' + voucher.F_CodigoVoucher__c;
				objErrorTipo.valDescErrorTecnico = Label.Fielo_ReclamacionVoucherInexistente + ' ' + voucher.F_CodigoVoucher__c;
				lstErrorTipo.add(objErrorTipo);
			}
			else {
				if (Label.Ter_lbl_VoucherUsado.equals(objRedemption.FieloPLT__Status__c)) {
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
					objErrorTipo.valDescError = Label.Fielo_ReclamacionVoucherYaUtilizado + ', ' + voucher.F_CodigoVoucher__c;
					objErrorTipo.valDescErrorTecnico = Label.Fielo_ReclamacionVoucherYaUtilizado + ' ' + voucher.F_CodigoVoucher__c;
					lstErrorTipo.add(objErrorTipo);
				} else if (Label.Ter_lbl_VoucherExpirado.equals(objRedemption.FieloPLT__Status__c)) {
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
					objErrorTipo.valDescError = Label.Ter_lbl_MsjError_VoucherExpirado + ', ' + voucher.F_CodigoVoucher__c;
					objErrorTipo.valDescErrorTecnico = Label.Ter_lbl_MsjError_VoucherExpirado + ' ' + voucher.F_CodigoVoucher__c;
					lstErrorTipo.add(objErrorTipo);
				} else if(!Fielo_UTIL_MillasLifeMiles.READY.equals(objRedemption.FieloPLT__Status__c)){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
					objErrorTipo.valDescError = 'El voucher no se encuentra disponible, ' + ', ' + voucher.F_CodigoVoucher__c;
					objErrorTipo.valDescErrorTecnico = 'El voucher no se encuentra disponible, ' + ', ' + voucher.F_CodigoVoucher__c;
					lstErrorTipo.add(objErrorTipo);
				}
				//id memberId = objRedemption.FieloPLT__Redemption__r.FieloPLT__Member__c;
				objMember = mapMembers.get(objRedemption.FieloPLT__Redemption__r.FieloPLT__Member__c);
				if (Label.TER_STATUS_LOCK_RECLAMATION.equals(objMember.FieloPLT__Status__c)) {
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
					objErrorTipo.valDescError = Label.Fielo_ReclamacionMemberBloqueado;
					objErrorTipo.valDescErrorTecnico = Label.Fielo_ReclamacionMemberBloqueado;
					lstErrorTipo.add(objErrorTipo);
				}

			}

		}
		
		system.debug('::::::::::::::: montoVouchers: ' + montoVouchers);
		system.debug('::::::::::::::: montoOthersMethods: ' + montoOthersMethods);
		system.debug('::::::::::::::: F_ValorAPagar__c: ' + this.objVenta.F_ValorAPagar__c);
		Decimal montoFinal = montoVouchers + montoOthersMethods - this.objVenta.F_ValorAPagar__c;
		if (montoFinal < 0) {
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
			objErrorTipo.valDescError = label.Fielo_ReclamacionVoucherMontoInvalido;
			objErrorTipo.valDescErrorTecnico = label.Fielo_ReclamacionVoucherMontoInvalido;
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(!lstErrorTipo.isEmpty()){
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_CodigoErrorVoucher;
			objFalloTipo.fechaTx = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA);
			objFalloTipo.errores = lstErrorTipo;
			return objFalloTipo;
		} else{
			return null;
		}

	}
	
	public SrvIntClienteTransaccion_in.DT_FalloTipo validarCamposObligatorios(SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente objAcumulaRedimeCliente){
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo;
		list<SrvIntClienteTransaccion_in.DT_ErrorTipo> lstErrorTipo;
		
		
		lstErrorTipo = new list<SrvIntClienteTransaccion_in.DT_ErrorTipo>();
		if(String.isEmpty(objAcumulaRedimeCliente.idVenta)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id Venta');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id Venta');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(String.isEmpty(objAcumulaRedimeCliente.fechaTransaccion)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Fecha Transacción');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Fecha Transacción');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(String.isEmpty(objAcumulaRedimeCliente.tipoTransaccion)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Tipo Transacción');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Tipo Transacción');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(objAcumulaRedimeCliente.montoTotal == null){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Monto Total');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Monto Total');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(objAcumulaRedimeCliente.descuento == null){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Descuento');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Descuento');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(objAcumulaRedimeCliente.valorPagar == null){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Valor a Pagar');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Valor a Pagar');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(objAcumulaRedimeCliente.impuesto == null){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Impuesto');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Impuesto');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(String.isEmpty(objAcumulaRedimeCliente.idPromotor)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id Promotor');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id Promotor');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(String.isEmpty(objAcumulaRedimeCliente.idPuntoVenta)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id Punto de Venta');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id Punto de Venta');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(String.isEmpty(objAcumulaRedimeCliente.origenTransaccion)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Origen de Transacción');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Origen de Transacción');
			lstErrorTipo.add(objErrorTipo);
		}
		
		//Si la transaccion es de acumulacion desde tiendas de conveniencia no se valida la obligatoriedad del tipo de documento y numero de documento
		if(!String.isBlank(objAcumulaRedimeCliente.tipoTransaccion) && !objAcumulaRedimeCliente.tipoTransaccion.equals(label.Ter_lbl_Acumulacion_TDC)){
			if(objAcumulaRedimeCliente.tipoDocumento == null){
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
				objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Tipo Documento');
				objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Tipo Documento');
				lstErrorTipo.add(objErrorTipo);
			} else{
				//Se validan los campos iternos de TipoDocumento
				if(String.isEmpty(objAcumulaRedimeCliente.tipoDocumento.codTipoidentificacion)){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
					objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Códidgo de Tipo de Identificación de Tipo Documento');
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Códidgo de Tipo de Identificación de Tipo Documento');
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(String.isEmpty(objAcumulaRedimeCliente.tipoDocumento.valNumeroIdentificacion)){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
					objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Número de Identificación de Tipo Documento');
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Número de Identificación de Tipo Documento');
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) && String.isBlank(objAcumulaRedimeCliente.tipoDocumento.pin)){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
					objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'PIN');
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'PIN');
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(label.Ter_lbl_TipoTransaccion_Redencion.equals(objAcumulaRedimeCliente.tipoTransaccion) && !String.isBlank(objAcumulaRedimeCliente.tipoDocumento.pin)){
					try{
						objAcumulaRedimeCliente.tipoDocumento.pin = new Ter_UtilEncriptacion_cls().desencriptarAES256Terpel_B64(objAcumulaRedimeCliente.tipoDocumento.pin);
					} catch(Exception e){
						objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
						objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
						objErrorTipo.valDescError = 'Error desencriptando el PIN';
						objErrorTipo.valDescErrorTecnico = 'Error desencriptando el PIN: ' + e.getMessage();
						lstErrorTipo.add(objErrorTipo);
					}
				}
				
				if(!mapDatosHomologados.containsKey('FieloPLT__Member__c'+'F_IdentificationType__c'+objAcumulaRedimeCliente.tipoDocumento.codTipoidentificacion)){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Homologacion;
					objErrorTipo.valDescError = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Tipo Documento');
					objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Tipo Documento');
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(!String.isBlank(objAcumulaRedimeCliente.tipoDocumento.valNumeroIdentificacion)){
					try{
						objAcumulaRedimeCliente.tipoDocumento.valNumeroIdentificacion = new Ter_UtilEncriptacion_cls().desencriptarAES256Terpel_B64(objAcumulaRedimeCliente.tipoDocumento.valNumeroIdentificacion);
					} catch(Exception e){
						objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
						objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
						objErrorTipo.valDescError = 'Error desencriptando el numero de documento';
						objErrorTipo.valDescErrorTecnico = 'Error desencriptando el numero de documento: ' + e.getMessage();
						lstErrorTipo.add(objErrorTipo);
					}
				}
			}
		}
		
		if(String.isEmpty(objAcumulaRedimeCliente.tipoVenta)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Tipo de Venta');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Tipo de Venta');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(objAcumulaRedimeCliente.mediosPago == null || objAcumulaRedimeCliente.mediosPago.size() == 0){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Medios de Pago');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Medios de Pago');
			lstErrorTipo.add(objErrorTipo);
		} else{
			//Se validan los campos internos de MedioPago
			for(Integer i = 0; i < objAcumulaRedimeCliente.mediosPago.size(); i++){
				if(objAcumulaRedimeCliente.mediosPago[i].codigoMedioPago == null){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
					objErrorTipo.valDescError = '['+i+'] ' + label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Código Medio Pago en Medio de Pago');
					objErrorTipo.valDescErrorTecnico = '['+i+'] ' + label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Código Medio Pago en Medio de Pago');
					lstErrorTipo.add(objErrorTipo);
				}
				
				if(objAcumulaRedimeCliente.mediosPago[i].monto == null){
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
					objErrorTipo.valDescError = '['+i+'] ' + label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Monto en Medio de Pago');
					objErrorTipo.valDescErrorTecnico = '['+i+'] ' + label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Monto en Medio de Pago');
					lstErrorTipo.add(objErrorTipo);
				}
			}
		}
		
		//Se valida la homologacion de los datos que llegaron en el servicio
		if(!mapDatosHomologados.containsKey('Fielo_Venta__c'+'F_TipoTransaccion__c'+objAcumulaRedimeCliente.tipoTransaccion)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Homologacion;
			objErrorTipo.valDescError = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Tipo Transacción');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Tipo Transacción');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(!mapDatosHomologados.containsKey('Fielo_Venta__c'+'F_OrigenVenta__c'+objAcumulaRedimeCliente.origenTransaccion)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Homologacion;
			objErrorTipo.valDescError = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Origen Transacción');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Origen Transacción');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(!mapDatosHomologados.containsKey('Fielo_Venta__c'+'F_TipoVenta__c'+objAcumulaRedimeCliente.tipoVenta)){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Homologacion;
			objErrorTipo.valDescError = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Tipo Venta');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Dato_a_Homologar.replace(COMODIN_CAMPOS, 'Tipo Venta');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(!lstErrorTipo.isEmpty()){
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA);
			objFalloTipo.errores = lstErrorTipo;
			return objFalloTipo;
		} else{
			return null;
		}
		
	}
	
	/* 
	* Nombre: validarVoucherSync
    * Descripcion: Metodo encargado de validar un voucher desde las TTCC o EDS
    * Fecha Creación: 25/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public SrvIntClienteTransaccion_in.DT_ValidaVoucherClienteSalida validarVoucherSync(SrvIntClienteTransaccion_in.DT_ValidaVoucherClienteEntrada objValidaVoucherClienteEntrada){
		SrvIntClienteTransaccion_in.DT_ValidaVoucherClienteSalida objValidaVoucherClienteSalida;
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo;
		SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo objContextoRespuestaTipo;
		FieloPLT__RedemptionItem__c objRedemption;
		Ter_Estacion_de_Servicio__c objEDS;
		Ter_Negocio_Complementario__c objTDC;
		list<SrvIntClienteTransaccion_in.DT_ErrorTipo> lstErrorTipo;
		String strFechaRta;
		String strEstadoVoucher;
		
		Ter_LogicaServiciosGeneral_cls objLogicaServiciosGeneral;
		
		objValidaVoucherClienteSalida = new SrvIntClienteTransaccion_in.DT_ValidaVoucherClienteSalida();
		objContextoRespuestaTipo = new SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo();
		lstErrorTipo = new list<SrvIntClienteTransaccion_in.DT_ErrorTipo>();
		
		if(objValidaVoucherClienteEntrada.origenVenta == null){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Origen de Venta');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Origen de Venta');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(objValidaVoucherClienteEntrada.idPuntoVenta == null){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id de Punto de Venta');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Id de Punto de Venta');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(objValidaVoucherClienteEntrada.codVoucher == null){
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Codigo de Voucher');
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Campo_Obligatorio_WS.replace(COMODIN_CAMPOS, 'Codigo de Voucher');
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(!lstErrorTipo.isEmpty()){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFechaRta;
			objFalloTipo.errores = lstErrorTipo;
			
			objValidaVoucherClienteSalida.contextoRespuestaTipo = objContextoRespuestaTipo;
			objValidaVoucherClienteSalida.mensajePer = 'Error procesando la transacción';
			objValidaVoucherClienteSalida.falloTipo = objFalloTipo;
			
			return objValidaVoucherClienteSalida;
		}
		
		
		//Se consulta y se valida la Estacion de Servicio o Tienda de Conveniencia segun haya llegado
		/**************** SE COMENTAN ESTAS LINEAS YA QUE EN EL METODO DE FIELO PARA VALIDAR VOUCHER SE ESTA VALIDANDO EL PUNTO DE VENTA *******************/
		/*objLogicaServiciosGeneral = new Ter_LogicaServiciosGeneral_cls();
		if(label.Ter_lbl_EDS.equals(objValidaVoucherClienteEntrada.origenVenta)){
			objEDS = objLogicaServiciosGeneral.consultarEDS(objValidaVoucherClienteEntrada.idPuntoVenta);
			this.strOrigenTransaccion = label.Ter_lbl_EDS;
			if(objEDS == null){
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = label.Fielo_PuntoDeVentaInexistente;
				objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaInexistente;
				lstErrorTipo.add(objErrorTipo);
			} else if (!objEDS.F_ClubTerpel__c || !objEDS.Ter_Estatus__c.equals('Activa') || !objEDS.F_Reclama__c) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = label.Ter_lbl_PDV_No_Reclama;
				objErrorTipo.valDescErrorTecnico = label.Ter_lbl_PDV_No_Reclama;
				lstErrorTipo.add(objErrorTipo);
			} 
		} else if(label.Ter_lbl_TDC.equals(objValidaVoucherClienteEntrada.origenVenta)){
			objTDC = objLogicaServiciosGeneral.consultarTTCC(objValidaVoucherClienteEntrada.idPuntoVenta);
			this.strOrigenTransaccion = label.Ter_lbl_TDC;
			
			if(objTDC == null){
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = label.Fielo_PuntoDeVentaInexistente;
				objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaInexistente;
				lstErrorTipo.add(objErrorTipo);
			} else if (!objTDC.F_ClubTerpel__c || !objTDC.F_Reclama__c) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = label.Ter_lbl_PDV_No_Reclama;
				objErrorTipo.valDescErrorTecnico = label.Ter_lbl_PDV_No_Reclama;
				lstErrorTipo.add(objErrorTipo);
			} 
		} else{
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
			objErrorTipo.valDescError = label.Ter_lbl_Error_Origen_Transaccion;
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Error_Origen_Transaccion;
			lstErrorTipo.add(objErrorTipo);
		}
		
		if(!lstErrorTipo.isEmpty()){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFechaRta;
			objFalloTipo.errores = lstErrorTipo;
			
			objValidaVoucherClienteSalida.contextoRespuestaTipo = objContextoRespuestaTipo;
			objValidaVoucherClienteSalida.mensajePer = 'Error procesando la transacción';
			objValidaVoucherClienteSalida.falloTipo = objFalloTipo;
			
			return objValidaVoucherClienteSalida;
		}
		
		this.lstRedemptionItems = [SELECT id, FieloPLT__Status__c, FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Status__c 
								   FROM FieloPLT__RedemptionItem__c
								   WHERE FieloPLT__UniqueCode__c = :objValidaVoucherClienteEntrada.codVoucher];
		
		if (this.lstRedemptionItems.isEmpty()) {
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
			objErrorTipo.valDescError = Label.Fielo_ReclamacionVoucherInexistente + ' ' + objValidaVoucherClienteEntrada.codVoucher;
			objErrorTipo.valDescErrorTecnico = Label.Fielo_ReclamacionVoucherInexistente + ' ' + objValidaVoucherClienteEntrada.codVoucher;
			lstErrorTipo.add(objErrorTipo);
		} else {
			objRedemption = this.lstRedemptionItems.get(0);
			
			if (label.TER_STATUS_READY_RECLAMATION.equals(objRedemption.FieloPLT__Status__c)) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = Label.Fielo_ReclamacionVoucherYaUtilizado + ', ' + objValidaVoucherClienteEntrada.codVoucher;
				objErrorTipo.valDescErrorTecnico = Label.Fielo_ReclamacionVoucherYaUtilizado + ' ' + objValidaVoucherClienteEntrada.codVoucher;
				lstErrorTipo.add(objErrorTipo);
			} else if (label.Ter_lbl_VoucherExpirado.equals(objRedemption.FieloPLT__Status__c)) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = Label.Ter_lbl_MsjError_VoucherExpirado + ', ' + objValidaVoucherClienteEntrada.codVoucher;
				objErrorTipo.valDescErrorTecnico = Label.Ter_lbl_MsjError_VoucherExpirado + ' ' + objValidaVoucherClienteEntrada.codVoucher;
				lstErrorTipo.add(objErrorTipo);
			}
			
			if (label.TER_STATUS_LOCK_RECLAMATION.equals(objRedemption.FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Status__c)) {
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_CodigoErrorVoucher;
				objErrorTipo.valDescError = Label.Fielo_ReclamacionMemberBloqueado;
				objErrorTipo.valDescErrorTecnico = Label.Fielo_ReclamacionMemberBloqueado;
				lstErrorTipo.add(objErrorTipo);
			}
		}*/
		
		String strOrigenVenta;
		if(label.Ter_lbl_EDS.equals(objValidaVoucherClienteEntrada.origenVenta)){
			strOrigenVenta = Fielo_UTIL_MillasLifeMiles.ESTACION_DE_SERVICIO;
		} else if(label.Ter_lbl_TDC.equals(objValidaVoucherClienteEntrada.origenVenta)){
			strOrigenVenta = Fielo_UTIL_MillasLifeMiles.TIENDA;
		}
		
		Fielo_UTIL_MillasLifeMiles.ReturnValidacionVoucherWrapper objReturnValidacionVoucherWrapper = Fielo_UTIL_MillasLifeMiles.validacionVoucher(strOrigenVenta, objValidaVoucherClienteEntrada.idPuntoVenta, objValidaVoucherClienteEntrada.codVoucher, objValidaVoucherClienteEntrada.monto);
		
		//if(!lstErrorTipo.isEmpty()){
		if(objReturnValidacionVoucherWrapper.mensaje != null && objReturnValidacionVoucherWrapper.mensaje.equals(label.Fielo_ReclamacionValida)){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Ok;
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Ok;
			objFalloTipo.fechaTx = strFechaRta;
			objFalloTipo.errores = lstErrorTipo;
			
			objValidaVoucherClienteSalida.contextoRespuestaTipo = objContextoRespuestaTipo;
			objValidaVoucherClienteSalida.mensajePer = 'Voucher Valido.';
			objValidaVoucherClienteSalida.estado = 'Disponible';
			objValidaVoucherClienteSalida.monto = objReturnValidacionVoucherWrapper.monto; 
			objValidaVoucherClienteSalida.falloTipo = objFalloTipo;
			
			return objValidaVoucherClienteSalida;
			
		} else{
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(FORMATO_FECHA_RTA); 
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_codEstadoTx_Error;
			objErrorTipo.valDescError = objReturnValidacionVoucherWrapper.mensaje;
			objErrorTipo.valDescErrorTecnico = objReturnValidacionVoucherWrapper.mensaje;
			lstErrorTipo.add(objErrorTipo);
			
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFechaRta;
			objFalloTipo.errores = lstErrorTipo;
			
			if('Expired'.equals(objReturnValidacionVoucherWrapper.estadoVoucher)){
				strEstadoVoucher = 'Expirado';
			} else if('Delivered'.equals(objReturnValidacionVoucherWrapper.estadoVoucher)){
				strEstadoVoucher = 'Utilizado';
			} else{
				strEstadoVoucher = 'Invalido';
			}
			
			
			objValidaVoucherClienteSalida.contextoRespuestaTipo = objContextoRespuestaTipo;
			objValidaVoucherClienteSalida.mensajePer = objReturnValidacionVoucherWrapper.mensaje;
			objValidaVoucherClienteSalida.falloTipo = objFalloTipo;
			objValidaVoucherClienteSalida.estado = strEstadoVoucher;
			
			return objValidaVoucherClienteSalida;
		}
	}
	
}