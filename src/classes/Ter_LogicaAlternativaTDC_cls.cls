/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase que contiene la logica para validar las transaccion de acumulacion que llegan desde 
* 					las Tiendas de Conveniencia
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    08/09/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class Ter_LogicaAlternativaTDC_cls {
	
	private Fielo_Venta__c objVenta;
	private Fielo_MedioDePagoVenta__c objMedioPagoVenta;
	private Fielo_ItemVenta__c objItemVenta;
	private Fielo_MedioDePago__c objMedioPagoFielo;
	private Fielo_Autorizacion_LifeMiles__c objAutorizacionLifeMiles;
	private FieloPLT__Member__c objMember;
	private list<Fielo_MedioDePagoVenta__c> lstMedioPagoVenta;
	private list<Fielo_ItemVenta__c> lstItemVenta;
	private list<Fielo_MedioDePago__c> lstMedioPago;
	private list<Fielo_InfraccionFraude__c> lstInfraccionFraude;
	//private map<string, Ter_Homologacion_Listas__c> mapDatosHomologados;
	private map<String, String> mapCodigosError;
	private boolean blnErrorAcumulacion;
	private boolean blnExisteVenta;
	
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
	public SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse procesaTransaccion(SrvIntClienteTransaccion_in.DT_AcumulaRedimeCliente objAcumulaRedimeCliente, SrvIntClienteTransaccion_in.DT_ContextoTransaccionalTipo objContextoTransaccionalTipo, Ter_Negocio_Complementario__c objTDC, long miliLlegadaFielo){
		SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse objAcumularRedimirResponse;
		SrvIntClienteTransaccion_in.DT_AcumulaRedimeClienteResponse objAcumulaRedimeClienteResponse;
		SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo objContextoRespuestaTipo;
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo;
		list<SrvIntClienteTransaccion_in.DT_ErrorTipo> lstErrorTipo;
		list<Fielo_Venta__c> lstVentas;
		list<Ter_Venta_TDC__c> lstVentasTDC;
		list<Fielo_MedioDePago__c> lstMedioPagoFielo;
		set<String> lstCodigosMedioPago; 
		Fielo_MedioDePago__c objMedioPagoFielo;
		Ter_Venta_TDC__c objVentaTDC;
		Datetime dtFechaTransaccion;
		String strFechaRta;
		String strIdVenta; 
		
		objAcumularRedimirResponse = new SrvIntClienteTransaccion_in.DT_AcumularRedimirResponse();
		objAcumulaRedimeClienteResponse = new SrvIntClienteTransaccion_in.DT_AcumulaRedimeClienteResponse();
		this.blnErrorAcumulacion = false;
		this.blnExisteVenta = false;
		lstErrorTipo = new list<SrvIntClienteTransaccion_in.DT_ErrorTipo>();
		objContextoRespuestaTipo = new SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo();
		
		dtFechaTransaccion = Ter_Utilidades_cls.stringToDatetime(objAcumulaRedimeCliente.fechaTransaccion);
		//strIdVenta = objAcumulaRedimeCliente.idPuntoVenta + objAcumulaRedimeCliente.idVenta + Ter_Utilidades_cls.formatearFecha(dtFechaTransaccion);
		strIdVenta = objAcumulaRedimeCliente.idVenta;
		
		system.debug('----------------- strIdVenta: ' + strIdVenta);
		
		/*lstVentas = [SELECT F_IdVenta__c, F_FechaTransaccion__c, F_TipoTransaccion__c, F_MontoTotal__c, F_Descuento__c, 
							F_Impuesto__c, F_ValorAPagar__c, F_IDPromotorCajero__c, F_EstacionDeServicio__c, F_Tienda__c, 
							F_OrigenVenta__c, F_Cliente__c, F_TipoVenta__c, F_Member__c, F_Estado__c, F_TransaccionProcesada__c 
				    FROM Fielo_Venta__c 
				    WHERE F_IdVenta__c = :strIdVenta];*/
		
		//Se consulta si ya hay una venta registrada con el IdVenta que llego
		lstVentasTDC = [SELECT Ter_TipoTransaccion__c, Ter_OrigenVenta__c, Ter_Tienda__c, Ter_Cliente__c, 
							   Ter_Member__c, Ter_IdVenta__c, Ter_Estado__c, Ter_TipoVenta__c, Ter_TransaccionProcesada__c 
						FROM Ter_Venta_TDC__c 
						WHERE Ter_IdVenta__c = :strIdVenta];
				    
		system.debug('------------ La lista ' + lstVentasTDC);
		
		//Si es acumulacion y la venta ya existia se considera una venta duplicada
		if(lstVentasTDC.isEmpty()){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			
			objAcumulaRedimeClienteResponse.idResponse = 0;
			objAcumulaRedimeClienteResponse.descResponse = 'Esta transaccion no fue registrada previamente desde la página Web de Acumulación';
			
			objContextoRespuestaTipo.codEstadoTx = 'Esta transaccion no fue registrada previamente desde la página Web de Acumulación';
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
		} else if(lstVentasTDC.get(0).Ter_TransaccionProcesada__c){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			
			objAcumulaRedimeClienteResponse.idResponse = 0;
			objAcumulaRedimeClienteResponse.descResponse = 'La transacción ya se procesó previamente';
			
			objContextoRespuestaTipo.codEstadoTx = 'La transacción ya se procesó previamente';
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
		}
		
		objVentaTDC = lstVentasTDC.get(0);
		//this.objVenta = lstVentas.get(0);
		this.objMember = [SELECT Id, RecordType.DeveloperName, FieloPLT__Account__c, F_NumeroLifeMiles__c, FieloPLT__Status__c, 
								 F_PrimerNombre__c, F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c, F_EstadoTarjetaPreinscrita__c
						  FROM FieloPLT__Member__c 
						  WHERE Id = :objVentaTDC.Ter_Member__c];
		try{
			if (label.Ter_lbl_RT_ClienteLifeMiles.equals(this.objMember.RecordType.DeveloperName)) {
				if (!Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					throw new Ter_ValidationException(Label.Fielo_ClienteInactivo);
				}
			} else if (label.Ter_lbl_RT_TarjetaPreinscrita.equals(this.objMember.RecordType.DeveloperName)) {
				if (label.TER_STATUS_CARD_EXPIRED.equals(objMember.F_EstadoTarjetaPreinscrita__c)) {
					throw new Ter_ValidationException(Label.Fielo_TarjetaPreinscritaExpirada);
				}
				else if (label.TER_STATUS_CARD_USED.equals(objMember.F_EstadoTarjetaPreinscrita__c)) {
					throw new Ter_ValidationException(Label.Fielo_TarjetaPreinscritaUsada);
				}
				else if (Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					//No se hace nada, deja continuar la transaccion
				} else {
					throw new Ter_ValidationException(Label.Fielo_ClienteInactivo);
				}
			} else {
				if (!Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					throw new Ter_ValidationException(Label.Fielo_ClienteInactivo);
				} 
			}
		} catch(Ter_ValidationException ve){
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			
			objAcumulaRedimeClienteResponse.idResponse = 0;
			objAcumulaRedimeClienteResponse.descResponse = ve.getMessage();
			
			objContextoRespuestaTipo.codEstadoTx = ve.getMessage();
			objContextoRespuestaTipo.fechaTx = strFechaRta;
			
			objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
			objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			objAcumularRedimirResponse.falloTipo = objFalloTipo;
			
			return objAcumularRedimirResponse;
		}
		
		//Se consulta si ya hay una venta registrada con el IdVenta que llego
		lstVentas = [SELECT F_IdVenta__c, F_FechaTransaccion__c, F_TipoTransaccion__c, F_MontoTotal__c, F_Descuento__c, 
							F_Impuesto__c, F_ValorAPagar__c, F_IDPromotorCajero__c, F_EstacionDeServicio__c, F_Tienda__c, 
							F_OrigenVenta__c, F_Cliente__c, F_TipoVenta__c, F_Member__c, F_Estado__c 
				    FROM Fielo_Venta__c 
				    WHERE F_IdVenta__c = :strIdVenta];
		
		if(!lstVentas.isEmpty()){
			this.blnExisteVenta = true;
			if(lstVentas.get(0).F_TipoVenta__c == 'Acumulación'){
				strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			
				objAcumulaRedimeClienteResponse.idResponse = 1;
				objAcumulaRedimeClienteResponse.descResponse = 'Acumulación duplicada';
				
				objContextoRespuestaTipo.codEstadoTx = 'Acumulación duplicada';
				objContextoRespuestaTipo.fechaTx = strFechaRta;
				
				objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
				objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
				objAcumularRedimirResponse.falloTipo = objFalloTipo;
				
				return objAcumularRedimirResponse;
			} else{
				this.objVenta = lstVentas.get(0);
				this.objVenta.F_FechaTransaccion__c = dtFechaTransaccion;
				this.objVenta.F_TipoTransaccion__c = objVentaTDC.Ter_TipoTransaccion__c;
				this.objVenta.F_MontoTotal__c = objAcumulaRedimeCliente.montoTotal;
				this.objVenta.F_Descuento__c = objAcumulaRedimeCliente.descuento;
				this.objVenta.F_Impuesto__c = objAcumulaRedimeCliente.impuesto;
				this.objVenta.F_ValorAPagar__c = objAcumulaRedimeCliente.valorPagar;
				this.objVenta.F_Estado__c = 'Pendiente';
				this.objVenta.F_TipoVenta__c = objVentaTDC.Ter_TipoVenta__c;
				this.objVenta.F_Member__c = this.objMember.Id;
				this.objVenta.F_Cliente__c = this.objMember.FieloPLT__Account__c;
				this.objVenta.F_TransaccionProcesada__c = true;
				objVentaTDC.Ter_TransaccionProcesada__c = true;
				system.debug('======= Venta entcontrada: ' + this.objVenta);
			}
		} else{
			system.debug('============ La venta no se encontro.');
			RecordType objRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Fielo_Tienda'];
			
			this.objVenta = new Fielo_Venta__c();
			this.objVenta.RecordTypeId = objRecordType.Id;
			this.objVenta.F_IdVenta__c = strIdVenta;
			this.objVenta.F_FechaTransaccion__c = dtFechaTransaccion;
			this.objVenta.F_TipoTransaccion__c = objVentaTDC.Ter_TipoTransaccion__c;
			this.objVenta.F_MontoTotal__c = objAcumulaRedimeCliente.montoTotal;
			this.objVenta.F_Descuento__c = objAcumulaRedimeCliente.descuento;
			this.objVenta.F_Impuesto__c = objAcumulaRedimeCliente.impuesto;
			this.objVenta.F_ValorAPagar__c = objAcumulaRedimeCliente.valorPagar;
			this.objVenta.F_IDPromotorCajero__c = objAcumulaRedimeCliente.idPromotor;
			this.objVenta.F_EstacionDeServicio__c = null;
			this.objVenta.F_Tienda__c = objVentaTDC.Ter_Tienda__c;
			this.objVenta.F_OrigenVenta__c = objVentaTDC.Ter_OrigenVenta__c;
			this.objVenta.F_Cliente__c = this.objMember.FieloPLT__Account__c;
			this.objVenta.F_TipoVenta__c = objVentaTDC.Ter_TipoVenta__c;
			this.objVenta.F_Member__c = this.objMember.Id;
			this.objVenta.F_Estado__c = 'Pendiente';
			this.objVenta.F_TransaccionProcesada__c = true;
			objVentaTDC.Ter_TransaccionProcesada__c = true;
		}
		
		if(objAcumulaRedimeCliente.productos == null || objAcumulaRedimeCliente.productos.size() > 0){
			this.lstItemVenta = new list<Fielo_ItemVenta__c>();
			for(SrvIntClienteTransaccion_in.DT_Producto objProducto : objAcumulaRedimeCliente.productos){
				this.objItemVenta = new Fielo_ItemVenta__c();
				this.objItemVenta.F_IdProducto__c = objProducto.idProducto;
				this.objItemVenta.F_Cantidad__c = objProducto.cantidad;
				this.objItemVenta.F_ValorUnitario__c = objProducto.valorUnitario;
				//this.objItemVenta.F_Venta__c = this.objVenta.Id;
				this.lstItemVenta.add(this.objItemVenta);
			}
		}
		
		if(objAcumulaRedimeCliente.mediosPago == null || objAcumulaRedimeCliente.mediosPago.size() > 0){
			this.lstMedioPagoVenta = new list<Fielo_MedioDePagoVenta__c>();
			lstCodigosMedioPago = new set<String>();
			
			for(SrvIntClienteTransaccion_in.DT_MedioPago objMedioPago : objAcumulaRedimeCliente.mediosPago){
				lstCodigosMedioPago.add(objMedioPago.codigoMedioPago + '');
			}
			
			map<String, Fielo_MedioDePago__c> mapMedioPago = new Ter_LogicaServiciosGeneral_cls().consultarMedioPago(lstCodigosMedioPago, label.Ter_lbl_TDC);
			
			for(SrvIntClienteTransaccion_in.DT_MedioPago objMedioPago : objAcumulaRedimeCliente.mediosPago){
				this.objMedioPagoVenta = new Fielo_MedioDePagoVenta__c();
				objMedioPagoFielo = mapMedioPago.get(objMedioPago.codigoMedioPago+'');
				
				this.objMedioPagoVenta.F_MedioDePago__c = objMedioPagoFielo.Id;
				this.objMedioPagoVenta.F_MillasRedimidas__c = objMedioPago.millasRedimidas;
				this.objMedioPagoVenta.F_Monto__c = objMedioPago.monto;
				this.objMedioPagoVenta.F_CodigoVoucher__c = objMedioPago.codigoVoucher;
				//this.objMedioPagoVenta.F_Venta__c = this.objVenta.Id;
				this.lstMedioPagoVenta.add(this.objMedioPagoVenta);
			}
		}
		
		this.objAutorizacionLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
		this.objAutorizacionLifeMiles.F_Member__c = this.objMember.Id;
		this.objAutorizacionLifeMiles.F_NumeroLifeMiles__c = this.objMember.F_NumeroLifeMiles__c;
		
		if(label.Ter_lbl_Acumulacion_TDC.equals(objAcumulaRedimeCliente.tipoTransaccion)){
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
				
			}
		} else{
			//Error tipo de transaccion invalida. 
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Acumulacion;
			objErrorTipo.valDescError = label.Ter_lbl_Error_Origen_Transaccion;
			objErrorTipo.valDescErrorTecnico = label.Ter_lbl_Error_Origen_Transaccion;
			lstErrorTipo.add(objErrorTipo);
			
			strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			
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
		
		upsert this.objVenta;
		
		update objVentaTDC;
		
		if(this.lstInfraccionFraude != null && !this.lstInfraccionFraude.isEmpty()){
			for(Integer i=0; i < this.lstInfraccionFraude.size(); i++){
				lstInfraccionFraude[i].F_Venta__c = this.objVenta.Id;
				lstInfraccionFraude[i].F_Member__c = this.objMember.Id;
			}
			insert lstInfraccionFraude;
		}
		
		//if (!this.objVenta.F_Estado__c.equals('Rechazada')) {
		if (this.objVenta.Id != null) {
			this.objAutorizacionLifeMiles.F_Venta__c = this.objVenta.Id;
			insert this.objAutorizacionLifeMiles;
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
			this.objVenta.F_Estado__c = 'Procesar';
			update this.objVenta;
			
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
		objAcumulaRedimeClienteResponse.idResponse = 1;
		objAcumulaRedimeClienteResponse.infoMillasAcumuladas = Integer.valueOf(this.objAutorizacionLifeMiles.F_MillasBase__c);
		objAcumulaRedimeClienteResponse.nombreCliente = (String.isEmpty(this.objMember.F_PrimerNombre__c) ? '' : this.objMember.F_PrimerNombre__c + ' ') 
														+ (String.isEmpty(this.objMember.F_SegundoNombre__c) ? '' : this.objMember.F_SegundoNombre__c + ' ' ) 
														+ (String.isEmpty(this.objMember.F_PrimerApellido__c) ? '' : this.objMember.F_PrimerApellido__c + ' ')  
														+ (String.isEmpty(this.objMember.F_SegundoApellido__c) ? '' : this.objMember.F_SegundoApellido__c);
		
		strFechaRta = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
		
		objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
		objContextoRespuestaTipo.fechaTx = strFechaRta;
		
		objAcumularRedimirResponse.acumulaRedimeClienteRes = objAcumulaRedimeClienteResponse;
		objAcumularRedimirResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
		objAcumularRedimirResponse.falloTipo = objFalloTipo;
		
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
		System.Debug('========>>>> [TDC] ObjVenta antes de Simulador: ' + this.objVenta);
		Map<String, list<SObject>> mapMillasSimuladas;
		try{
			mapMillasSimuladas = Fielo_Simulador.SimularVenta(this.objVenta, this.lstItemVenta, this.lstMedioPagoVenta);
		} catch(Exception e){
			System.Debug('====================== EXCEPCION SimularVenta ======================');
            System.debug( e.getMessage() + ' ' + e.getStackTraceString());
            System.Debug('====================================================================');
            throw new Ter_AcumulacionException('No se pudo calcular las millas para la venta.');
		}
		
		System.debug('mapMillasSimuladas --> ' + mapMillasSimuladas);
		
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
				throw new Ter_RespuestaFallidaException(mapCodigosError.get(objResponse.getResponseCode()));
			} else{
				throw new Ter_RespuestaFallidaException(label.Ter_lbl_Error_General_Acumulacion);
			}
		}
		
		this.objAutorizacionLifeMiles.F_NumeroAutorizacionLM__c = objResponse.getAuthoNum();
		this.objAutorizacionLifeMiles.F_MillasBonus__c = objResponse.getBonusMiles();
		this.objAutorizacionLifeMiles.F_Estado__c = 'Aprobado';
	}
	
	
	
	public RespuestaRedencionWrapper procesarRedencionTDC(Id idMember, Decimal decMillasRedimir, Id idTDC, String strCodigoPromotor, String strPIN){
		RespuestaRedencionWrapper objRespuestaRedencionWrapper;
		FieloPLT__Member__c objMember;
		List<FieloPLT__Member__c> lstMembers;
		String strIdVentaGenerado;
		
		if(String.isBlank(strPIN)){
			throw new Ter_AcumulacionException(label.Ter_lbl_Error_No_PIN); 
		}
		
		objRespuestaRedencionWrapper = new RespuestaRedencionWrapper();
		
		lstMembers = [SELECT Id, F_NumeroLifeMiles__c, FieloPLT__Status__c, FieloPLT__Account__c, F_PrimerNombre__c, 
							 F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c, RecordType.DeveloperName, 
							 F_NumeroTarjetaPreinscrita__c, F_EstadoTarjetaPreinscrita__c
					  FROM FieloPLT__Member__c 
					  WHERE Id = :idMember ];
		this.objMember = lstMembers.get(0);
		
		strIdVentaGenerado = Ter_Utilidades_cls.generarIdVentaTDC();
		objRespuestaRedencionWrapper.idVentaGenerado = strIdVentaGenerado;
		
		RecordType objRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Fielo_Tienda'];
		
		this.objVenta = new Fielo_Venta__c();
		this.objVenta.RecordTypeId = objRecordType.Id;
		//this.objVenta.F_IdVenta__c = strNumeroFactura;
		this.objVenta.F_IdVenta__c = strIdVentaGenerado;
		this.objVenta.F_FechaTransaccion__c = DateTime.now();
		this.objVenta.F_TipoTransaccion__c = 'Redención';
		this.objVenta.F_MontoTotal__c = decMillasRedimir;
		this.objVenta.F_Descuento__c = 0.0;
		this.objVenta.F_Impuesto__c = 0.0;
		this.objVenta.F_ValorAPagar__c = decMillasRedimir;
		this.objVenta.F_IDPromotorCajero__c = strCodigoPromotor;
		this.objVenta.F_Tienda__c = idTDC;
		this.objVenta.F_OrigenVenta__c = 'Tienda';
		this.objVenta.F_Cliente__c = this.objMember.FieloPLT__Account__c;
		this.objVenta.F_TipoVenta__c = 'Tiendas';
		this.objVenta.F_Member__c = this.objMember.Id;
		this.objVenta.F_Estado__c = 'Pendiente';
	
		this.objAutorizacionLifeMiles = new Fielo_Autorizacion_LifeMiles__c();
		this.objAutorizacionLifeMiles.F_Member__c = this.objMember.Id;
		this.objAutorizacionLifeMiles.F_NumeroLifeMiles__c = this.objMember.F_NumeroLifeMiles__c;
	
		list<Fielo_MedioDePago__c> lstMedioPago;
		lstMedioPago = [SELECT Id, F_IdMedioDePagoEDS__c, F_Estado__c FROM Fielo_MedioDePago__c WHERE Name = 'Millas LifeMiles'];
	
		if(lstMedioPago.isEmpty()){
			//Error indicando que el medio de pago de Millas no es configurado
			objRespuestaRedencionWrapper.idVentaGenerado = null;
			objRespuestaRedencionWrapper.blnEstadoTransaccion = false;
			objRespuestaRedencionWrapper.strMensajeRespuesta = 'El medio de pago Millas LifeMiles no se encuentra configurado';
			return objRespuestaRedencionWrapper;
		} else if(!lstMedioPago.get(0).F_Estado__c.equals('Activo')){
			//Error indicando que el medio de pago no esta eactivo
			objRespuestaRedencionWrapper.idVentaGenerado = null;
			objRespuestaRedencionWrapper.blnEstadoTransaccion = false;
			objRespuestaRedencionWrapper.strMensajeRespuesta = 'El medio de pago Millas LifeMiles se encuentra inactivo';
			return objRespuestaRedencionWrapper;
		}
	
		this.objMedioPagoVenta = new Fielo_MedioDePagoVenta__c();
		this.objMedioPagoVenta.F_MedioDePago__c = lstMedioPago.get(0).Id; 
		this.objMedioPagoVenta.F_MillasRedimidas__c = decMillasRedimir;//Millas a redimir en la transaccion
		this.objMedioPagoVenta.F_Monto__c = this.objVenta.F_ValorAPagar__c;
		//this.objMedioPagoVenta.F_CodigoVoucher__c = '';//Aplica cuando se paga con voucher
		this.lstMedioPagoVenta = new list<Fielo_MedioDePagoVenta__c>();
		this.lstMedioPagoVenta.add(this.objMedioPagoVenta);
		
		
		this.lstItemVenta = new list<Fielo_ItemVenta__c>();
		
		/*try{ 
			procesaAcumulacion();
		} catch(Ter_AcumulacionException ae){
			//Error Controlado
			this.objVenta.F_Estado__c = 'Reintentar';
			this.objVenta.F_MotivoRechazo__c = ae.getMessage();
			this.blnErrorAcumulacion = true;
		} catch(Ter_RespuestaFallidaException ae){
			//Error Controlado
			this.objVenta.F_Estado__c = 'Rechazada';
			this.objVenta.F_MotivoRechazo__c = ae.getMessage();
			this.blnErrorAcumulacion = true;
		}catch(Ter_FraudeException e){
			//Error Controlado
			//Cuando ocurre esta excepcion la venta ya viene en estado Rechazada y ya tiene un MotivoRechazo
			this.blnErrorAcumulacion = true;
		} catch(Exception e){
			//Error Inesperado
			this.objVenta.F_Estado__c = 'Reintentar';
			this.objVenta.F_MotivoRechazo__c = e.getMessage();
			this.blnErrorAcumulacion = true;
			
		}*/
	
	
		Fielo_Autorizacion_LifeMiles__c objAutorizacionLifeMilesRedencion = new Fielo_Autorizacion_LifeMiles__c();
		objAutorizacionLifeMilesRedencion.F_Member__c = this.objMember.Id;
		objAutorizacionLifeMilesRedencion.F_NumeroLifeMiles__c = this.objMember.F_NumeroLifeMiles__c;
		objAutorizacionLifeMilesRedencion.F_MillasBase__c = decMillasRedimir;//Millas a redimir en la transaccion
		objAutorizacionLifeMilesRedencion.F_MillasPromocionales__c = 0.0;
		objAutorizacionLifeMilesRedencion.F_TipoTransaccion__c = 'Débito (D)';
		objAutorizacionLifeMilesRedencion.F_MontoTransaccion__c = this.objVenta.F_ValorAPagar__c;
		
		Ter_LifeMilesConversionWsConsumer_cls objLifeMilesConversionWsConsumer = new Ter_LifeMilesConversionWsConsumer_cls();
		Ter_ResponseRedentionDTO_cls objResponse;
		try{
			objResponse = objLifeMilesConversionWsConsumer.invokePostMilesStr(objAutorizacionLifeMilesRedencion, strPIN, null);
			system.debug('=========== objResponse Redencion: ' + objResponse);
		} catch (Ter_AcumulacionException ae) {
			throw ae;
		} catch (Exception e) {
			System.Debug('====================== EXCEPCION ======================');
			System.debug( e.getMessage() + ' ' + e.getStackTraceString());
			System.Debug('=======================================================');
			throw new Ter_AcumulacionException(label.Ter_lbl_Mensaje_Error_Redencion_LM); 
		}
		
		this.mapCodigosError = Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_TipoTransaccion_Redencion);
		
		objAutorizacionLifeMilesRedencion.F_CodigoRespuestaLM__c = objResponse.getBody().getPostingResponse().getResponse_code();
			
		if(!label.Ter_lbl_Codigo_Exito_Redencion_LM.equals(objResponse.getBody().getPostingResponse().getResponse_code())){
			objAutorizacionLifeMilesRedencion.F_Estado__c = 'Rechazado';
			objRespuestaRedencionWrapper.blnEstadoTransaccion = false;
			if(mapCodigosError.containsKey(objResponse.getBody().getPostingResponse().getResponse_code())){
				objAutorizacionLifeMilesRedencion.F_MotivoRechazo__c = mapCodigosError.get(objResponse.getBody().getPostingResponse().getResponse_code());
			} else{
				objAutorizacionLifeMilesRedencion.F_MotivoRechazo__c = label.Ter_lbl_Error_General_Redencion;
			}
			objRespuestaRedencionWrapper.strMensajeRespuesta = objAutorizacionLifeMilesRedencion.F_MotivoRechazo__c;
		} else{
			objRespuestaRedencionWrapper.blnEstadoTransaccion = true;
			objRespuestaRedencionWrapper.strMensajeRespuesta = 'Transacción Exitosa';
			objAutorizacionLifeMilesRedencion.F_NumeroAutorizacionLM__c = objResponse.getBody().getPostingResponse().getAutho_num();
			objRespuestaRedencionWrapper.strCodigoAutorizacon = objAutorizacionLifeMilesRedencion.F_NumeroAutorizacionLM__c;
			objAutorizacionLifeMilesRedencion.F_Estado__c = 'Aprobado';
		}
		
		this.objVenta.F_Estado__c = 'Pendiente';
		insert this.objVenta;
		
		objAutorizacionLifeMilesRedencion.F_Venta__c = this.objVenta.Id;
		insert objAutorizacionLifeMilesRedencion;
		
		/*if(this.lstInfraccionFraude != null && !this.lstInfraccionFraude.isEmpty()){
			for(Integer i=0; i < this.lstInfraccionFraude.size(); i++){
				this.lstInfraccionFraude[i].F_Venta__c = this.objVenta.Id;
				this.lstInfraccionFraude[i].F_Member__c = this.objMember.Id;
			}
			insert this.lstInfraccionFraude;
		}*/
		
		/*if (this.objVenta.Id != null) {
			this.objAutorizacionLifeMiles.F_Venta__c = this.objVenta.Id;
			insert this.objAutorizacionLifeMiles;
		}*/
		
		for(Fielo_MedioDePagoVenta__c objMedioPagoVentaAux : this.lstMedioPagoVenta){
			objMedioPagoVentaAux.F_Venta__c = this.objVenta.Id;
		}
		
		insert this.lstMedioPagoVenta;
		
		this.objVenta.F_Estado__c = 'Procesar';
		update this.objVenta;
		
		/*if(!this.blnErrorAcumulacion){
			this.objVenta.F_Estado__c = 'Procesar';
			update this.objVenta;
			
			if (this.lstInfraccionFraude != null && !this.lstInfraccionFraude.isEmpty()) {
				objRespuestaRedencionWrapper.lstFraudes = new list<String>();
				for(Integer i=0; i < this.lstInfraccionFraude.size(); i++){
					objRespuestaRedencionWrapper.lstFraudes.add(this.lstInfraccionFraude.get(i).F_Descripcion__c);
				}
			}
		}*/
		
		return objRespuestaRedencionWrapper;
	}
	
	public class RespuestaRedencionWrapper{
		public String idVentaGenerado {get; set;}
		public boolean blnEstadoTransaccion {get; set;}
		public String strMensajeRespuesta {get; set;}
		public String strCodigoAutorizacon {get; set;}
		public list<String> lstFraudes {get; set;}
	}
	
	
	public RespuestaReclamacionWrapper procesarReclamacionTDC(String strNumeroFactura, Decimal decMonto, Id idTDC, String strCodigoPromotor, String strCodigoVoucher){
		RespuestaReclamacionWrapper objRespuestaReclamacionWrapper;
		list<FieloPLT__RedemptionItem__c> lstRedemptionItems;
		list<Ter_Negocio_Complementario__c> lstTTCC;
		
		objRespuestaReclamacionWrapper = new RespuestaReclamacionWrapper();
		
		lstTTCC = [SELECT Id, F_IdFidelizacion__c 
					FROM  Ter_Negocio_Complementario__c 
					WHERE Id = :idTDC];
		
		list<Fielo_MedioDePago__c> lstMedioPago;
		lstMedioPago = [SELECT Id, F_IdMedioDePagoEDS__c, F_Estado__c FROM Fielo_MedioDePago__c WHERE Name = 'Bono Fidelización'];
	
		if(lstMedioPago.isEmpty()){
			//Error indicando que el medio de pago de Bono no es configurado
			objRespuestaReclamacionWrapper.blnEstadoTransaccion = false;
			objRespuestaReclamacionWrapper.strMensajeRespuesta = 'El medio de pago Bono Fidelización no se encuentra configurado.';
			return objRespuestaReclamacionWrapper;
		} else if(!lstMedioPago.get(0).F_Estado__c.equals('Activo')){
			//Error indicando que el medio de pago no esta activo
			objRespuestaReclamacionWrapper.blnEstadoTransaccion = false;
			objRespuestaReclamacionWrapper.strMensajeRespuesta = 'El medio de pago Bono Fidelización se encuentra inactivo.';
			return objRespuestaReclamacionWrapper;
		}
		
		Fielo_UTIL_MillasLifeMiles.ReturnValidacionVoucherWrapper objReturnValidacionVoucherWrapper = Fielo_UTIL_MillasLifeMiles.validacionVoucher(Fielo_UTIL_MillasLifeMiles.TIENDA, lstTTCC.get(0).F_IdFidelizacion__c, strCodigoVoucher, decMonto);
		
		if(objReturnValidacionVoucherWrapper.mensaje != null && objReturnValidacionVoucherWrapper.mensaje.equals(label.Fielo_ReclamacionValida)){
			
			RecordType objRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Fielo_Tienda'];
			
			lstRedemptionItems = [SELECT id, FieloPLT__Status__c, FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Status__c,
										 FieloPLT__Redemption__r.FieloPLT__Member__c, FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Account__c 
								  FROM FieloPLT__RedemptionItem__c
								  WHERE FieloPLT__UniqueCode__c = :strCodigoVoucher];
			
			this.objVenta = new Fielo_Venta__c();
			this.objVenta.RecordTypeId = objRecordType.Id;
			this.objVenta.F_IdVenta__c = strNumeroFactura;
			this.objVenta.F_FechaTransaccion__c = DateTime.now();
			this.objVenta.F_TipoTransaccion__c = 'Reclamación';
			this.objVenta.F_MontoTotal__c = decMonto;
			this.objVenta.F_Descuento__c = 0.0;
			this.objVenta.F_Impuesto__c = 0.0;
			this.objVenta.F_ValorAPagar__c = decMonto;
			this.objVenta.F_IDPromotorCajero__c = strCodigoPromotor;
			this.objVenta.F_Tienda__c = idTDC;
			this.objVenta.F_OrigenVenta__c = 'Tienda';
			this.objVenta.F_Cliente__c = lstRedemptionItems.get(0).FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Account__c;
			this.objVenta.F_TipoVenta__c = 'Tiendas';
			this.objVenta.F_Member__c = lstRedemptionItems.get(0).FieloPLT__Redemption__r.FieloPLT__Member__c;
			this.objVenta.F_Estado__c = 'Aprobada';
			
			this.objMedioPagoVenta = new Fielo_MedioDePagoVenta__c();
			this.objMedioPagoVenta.F_MedioDePago__c = lstMedioPago.get(0).Id; 
			this.objMedioPagoVenta.F_MillasRedimidas__c = 0.0;//Millas a redimir en la transaccion
			this.objMedioPagoVenta.F_Monto__c = this.objVenta.F_ValorAPagar__c;
			this.objMedioPagoVenta.F_CodigoVoucher__c = strCodigoVoucher;//Aplica cuando se paga con voucher
			this.lstMedioPagoVenta = new list<Fielo_MedioDePagoVenta__c>();
			this.lstMedioPagoVenta.add(this.objMedioPagoVenta);
			
			insert this.objVenta;
			
			for(Fielo_MedioDePagoVenta__c objMedioPagoVentaAux : this.lstMedioPagoVenta){
				objMedioPagoVentaAux.F_Venta__c = this.objVenta.Id;
			}
			
			insert this.lstMedioPagoVenta;
			
			lstRedemptionItems.get(0).FieloPLT__Status__c = label.Ter_lbl_VoucherUsado;
			update lstRedemptionItems;
			
			
			objRespuestaReclamacionWrapper.blnEstadoTransaccion = true;
			objRespuestaReclamacionWrapper.strMensajeRespuesta = 'Transacción Exitosa.';
		} else{
			objRespuestaReclamacionWrapper.blnEstadoTransaccion = false;
			objRespuestaReclamacionWrapper.strMensajeRespuesta = objReturnValidacionVoucherWrapper.mensaje;
		}
	
		
		
		return objRespuestaReclamacionWrapper;
	}
	
	public class RespuestaReclamacionWrapper{
		public boolean blnEstadoTransaccion {get; set;}
		public String strMensajeRespuesta {get; set;}
	}
	
    
}