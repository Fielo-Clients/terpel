/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase que contiene la logica especifica referente al manejo de Clientes
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    05/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
public with sharing class Ter_LogicaServiciosCliente_cls {
	
	/* 
	* Nombre: validarCliente
    * Descripcion: Metodo que contiene la logica para realizar la validacion de cliente e 
    * 			   implicitamente validar el punto de venta desde el cual se esta solicitando la validacion de cliente
    * Fecha Creación: 05/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            05-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public SrvIntClienteTransaccion_in.DT_ValidarResponse validarCliente(SrvIntClienteTransaccion_in.DT_ValidaCliente objValidaCliente){
		String strErrores;
		Boolean blnError;
		Boolean blnValidaPDV;
		Ter_LogicaServiciosGeneral_cls objLogicaServiciosGeneral;
		SrvIntClienteTransaccion_in.DT_ValidarResponse objValidarResponse;
		SrvIntClienteTransaccion_in.DT_ValidaClienteResponse objValidaClienteResponse;
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo;
		SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo objContextoRespuestaTipo;
		list<SrvIntClienteTransaccion_in.DT_ErrorTipo> lstErrorTipo;
		String strCustomerName = null;
		String strCMessage = null;
		String strFecha;
		
		objValidarResponse = new SrvIntClienteTransaccion_in.DT_ValidarResponse();
		objValidaClienteResponse = new SrvIntClienteTransaccion_in.DT_ValidaClienteResponse();
		objContextoRespuestaTipo = new SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo();
		lstErrorTipo = new list<SrvIntClienteTransaccion_in.DT_ErrorTipo>();
		
		blnError = false;
		blnValidaPDV = true;
		strErrores = '';
		
		if(String.isBlank(objValidaCliente.origenTransaccion)){
			blnError = true;
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.TER_ERROR_MSG_TRANSACTION_SOURCE_EMPTY;
			objErrorTipo.valDescErrorTecnico = label.TER_ERROR_MSG_TRANSACTION_SOURCE_EMPTY;
			lstErrorTipo.add(objErrorTipo);
			strErrores += '\n' + Label.TER_ERROR_MSG_TRANSACTION_SOURCE_EMPTY;
		}
		
		if(String.isBlank(objValidaCliente.idPuntoVenta)){
			blnError = true;
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.TER_ERROR_MSG_STORE_EMPTY;
			objErrorTipo.valDescErrorTecnico = label.TER_ERROR_MSG_STORE_EMPTY;
			lstErrorTipo.add(objErrorTipo);
			strErrores += '\n' + Label.TER_ERROR_MSG_STORE_EMPTY;
		}
		
		if(String.isBlank(objValidaCliente.fechaTransaccion)){
			blnError = true;
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.TER_ERROR_MSG_DATE_TRANSACTION_EMPTY;
			objErrorTipo.valDescErrorTecnico = label.TER_ERROR_MSG_DATE_TRANSACTION_EMPTY;
			lstErrorTipo.add(objErrorTipo);
			strErrores += '\n' + Label.TER_ERROR_MSG_DATE_TRANSACTION_EMPTY;
		}

		if (objValidaCliente.tipoDocumento == null) {
			blnError = true;
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
			objErrorTipo.valDescError = label.TER_ERROR_MSG_ID_TYPE_EMPTY;
			objErrorTipo.valDescErrorTecnico = label.TER_ERROR_MSG_ID_TYPE_EMPTY;
			lstErrorTipo.add(objErrorTipo);
			strErrores += '\n' +  Label.TER_ERROR_MSG_ID_TYPE_EMPTY;
		}
		else {
			if (objValidaCliente.tipoDocumento == null || String.isBlank
					(objValidaCliente.tipoDocumento.codTipoidentificacion)) {
				blnError = true;
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
				objErrorTipo.valDescError = label.TER_ERROR_MSG_ID_TYPE_EMPTY;
				objErrorTipo.valDescErrorTecnico = label.TER_ERROR_MSG_ID_TYPE_EMPTY;
				lstErrorTipo.add(objErrorTipo);
				strErrores += '\n' + Label.TER_ERROR_MSG_ID_TYPE_EMPTY;
			}

			if (String.isBlank(objValidaCliente.tipoDocumento.valNumeroIdentificacion)) {
				blnError = true;
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
				objErrorTipo.valDescError = label.TER_ERROR_MSG_ID_NUMBER_EMPTY;
				objErrorTipo.valDescErrorTecnico = label.TER_ERROR_MSG_ID_NUMBER_EMPTY;
				lstErrorTipo.add(objErrorTipo);
				strErrores += '\n' + Label.TER_ERROR_MSG_ID_NUMBER_EMPTY;
			}
			
			if(!String.isBlank(objValidaCliente.tipoDocumento.valNumeroIdentificacion)){
				try{
					objValidaCliente.tipoDocumento.valNumeroIdentificacion = new Ter_UtilEncriptacion_cls().desencriptarAES256Terpel_B64(objValidaCliente.tipoDocumento.valNumeroIdentificacion);
				} catch(Exception e){
					blnError = true;
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Campo_Faltante;
					objErrorTipo.valDescError = 'Error desencriptando el numero de documento';
					objErrorTipo.valDescErrorTecnico = 'Error desencriptando el numero de documento: ' + e.getMessage();
					lstErrorTipo.add(objErrorTipo);
					strErrores += '\n' + 'Error desencriptando el numero de documento';
					System.debug('Errror--->' + e.getMessage() + ' trace-->' + e.getStackTraceString()+ 'idnumber-->' + objValidaCliente.tipoDocumento.valNumeroIdentificacion);
				}
			}
		}
		
		if(!lstErrorTipo.isEmpty()){
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			
			strFecha = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFecha;
			objFalloTipo.errores = lstErrorTipo;
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFecha;
			
			objValidaClienteResponse.confirm = false;
			objValidaClienteResponse.mensajePer = strErrores;
			
			objValidarResponse.validaClienteRes = objValidaClienteResponse;
			objValidarResponse.falloTipo = objFalloTipo;
			objValidarResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			return objValidarResponse;
		}
		
		
		objLogicaServiciosGeneral = new Ter_LogicaServiciosGeneral_cls();
		SObject puntoVenta = null;
		
		//Se consulta el la EDS o la TTCC segun el campo origen transaccion
		if (label.Ter_lbl_EDS.equals(objValidaCliente.origenTransaccion)) {
			//puntoVenta = objLogicaServiciosGeneral.validarEDSObject(objValidaCliente.idPuntoVenta);
			System.debug('punto de venta-->' + objValidaCliente.idPuntoVenta);
			puntoVenta = objLogicaServiciosGeneral.consultarEDS(objValidaCliente.idPuntoVenta);
			if (puntoVenta != null && (!((Ter_Estacion_de_Servicio__c) puntoVenta).F_Acumula__c
					|| !((Ter_Estacion_de_Servicio__c) puntoVenta).F_ClubTerpel__c) ) {
				blnValidaPDV = false;
			}
		}
		else if (label.Ter_lbl_TDC.equals(objValidaCliente.origenTransaccion)) {
			//puntoVenta = objLogicaServiciosGeneral.validarTDCObject(objValidaCliente.idPuntoVenta);
			puntoVenta = objLogicaServiciosGeneral.consultarTTCC(objValidaCliente.idPuntoVenta);
			if ( puntoVenta != null && (!((Ter_Negocio_Complementario__c) puntoVenta).F_Acumula__c
					|| !((Ter_Negocio_Complementario__c) puntoVenta).F_ClubTerpel__c)) {
				blnValidaPDV = false;
			}
		}
		else {
			blnError = true;
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Homologacion;
			objErrorTipo.valDescError = label.TER_ERROR_MSG_SOURCE_INVALID;
			objErrorTipo.valDescErrorTecnico = label.TER_ERROR_MSG_SOURCE_INVALID;
			lstErrorTipo.add(objErrorTipo);
			strErrores += '\n' + Label.TER_ERROR_MSG_SOURCE_INVALID;
		}
		
		//Se valida si el PDV esta habilitado para acumular
		if (puntoVenta == null) {
			blnError = true;
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_PDV_No_Acumula;
			objErrorTipo.valDescError = label.Fielo_PuntoDeVentaInexistente;
			objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaInexistente;
			lstErrorTipo.add(objErrorTipo);
			strErrores += '\n' + Label.Fielo_PuntoDeVentaInexistente;
		}
		else if (!blnValidaPDV) {
			blnError = true;
			objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
			objErrorTipo.codError = label.Ter_lbl_Codigo_Error_PDV_No_Acumula;
			objErrorTipo.valDescError = label.Fielo_PuntoDeVentaNoAcumula;
			objErrorTipo.valDescErrorTecnico = label.Fielo_PuntoDeVentaNoAcumula;
			lstErrorTipo.add(objErrorTipo);
			strErrores += '\n' + Label.Fielo_PuntoDeVentaNoAcumula ;
		}
		
		if(!lstErrorTipo.isEmpty()){
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			
			strFecha = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFecha;
			objFalloTipo.errores = lstErrorTipo;
			
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFecha;
			
			objValidaClienteResponse.confirm = false;
			objValidaClienteResponse.mensajePer = strErrores;
			
			objValidarResponse.validaClienteRes = objValidaClienteResponse;
			objValidarResponse.falloTipo = objFalloTipo;
			objValidarResponse.contextoRespuestaTipo = objContextoRespuestaTipo;
			return objValidarResponse;
		}
		
		//Si llego a este punto es porque llegaron todos los campos y el punto de venta esta habilitado para acumular
		//por lo tanto se valida la informacion del cliente
		objValidarResponse.validaClienteRes = objValidaClienteResponse;
		objLogicaServiciosGeneral.validateIdentificationByType(objValidarResponse, strErrores, objValidaCliente);
		

	
		/*if (objValidaClienteResponse.mensajePer != null) {
			objValidaClienteResponse.mensajePer += strErrores;
		}
		else {
			objValidaClienteResponse.mensajePer = strErrores;
		}
		objValidaClienteResponse.confirm = false;*/

		//Si el PDV esta habilitado entonces se procede a consultar la informacion de cliente dependiendo del codTipoidentificacion

		return objValidarResponse;
	}
    
}