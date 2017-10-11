public with sharing class Ter_LogicaServiciosGeneral_cls {



	/**
	 * Metodo encargado de validar la estacion de servicio.
	 * @param idEDS identificador de la estacion de servicio.
	 * @return estacion encontrada.
	 */
	public Ter_Estacion_de_Servicio__c validarEDSObject(String idEDS){
		Ter_Estacion_de_Servicio__c result = null;
		try {
			List<Ter_Estacion_de_Servicio__c> lstEstacion_de_servicios =
			[SELECT id, F_Acumula__c, F_ClubTerpel__c, F_Reclama__c, F_Redime__c  from  Ter_Estacion_de_Servicio__c where ID = :idEDS];

			if (!lstEstacion_de_servicios.isEmpty()) {
				result = lstEstacion_de_servicios.get(0);
			}

		}
		catch (Exception e) {
			System.debug(e.getStackTraceString());
		}
		return result;

	}
	
	/* 
	* Nombre: consultarEDS
    * Descripcion: Metodo encargado de consultar una Estacion de servicio a partir del codigo unico
    * Fecha Creación: 29/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            29-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public Ter_Estacion_de_Servicio__c consultarEDS(String strCodigoEDS){
		Ter_Estacion_de_Servicio__c result = null;
		try { 
			List<Ter_Estacion_de_Servicio__c> lstEDS =
			[SELECT id, F_Acumula__c, F_ClubTerpel__c, F_Reclama__c, F_Redime__c, Ter_Estatus__c  from  Ter_Estacion_de_Servicio__c where F_IdFidelizacion__c = :strCodigoEDS];

			if (!lstEDS.isEmpty()) {
				result = lstEDS.get(0);
			}

		}
		catch (Exception e) {
			System.debug(e.getStackTraceString());
		}
		return result;

	}

	/**
	 * Metodo encargado de validar la Tienda.
	 * @param idTDC identificador de la tienda.
	 * @return tienda encontrada.
	 */
	public Ter_Negocio_Complementario__c validarTDCObject(String idTDC){
		Ter_Negocio_Complementario__c result = null;
		try {

			List<Ter_Negocio_Complementario__c> lstEstacion_de_servicios =
			[SELECT id, F_Acumula__c, F_ClubTerpel__c, F_Redime__c, F_Reclama__c  FROM  Ter_Negocio_Complementario__c WHERE Id = :idTDC];
			if (!lstEstacion_de_servicios.isEmpty()) {
				result = lstEstacion_de_servicios.get(0);
			}

		}
		catch (Exception e) {
			System.debug(e.getStackTraceString());
		}

		return result;
	}
	
	/* 
	* Nombre: consultarEDS
    * Descripcion: Metodo encargado de consultar una Tienda de conveniencia a partir del codigo unico
    * Fecha Creación: 29/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            29-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public Ter_Negocio_Complementario__c consultarTTCC(String strCodigoTTCC){
		Ter_Negocio_Complementario__c result = null;
		try {

			List<Ter_Negocio_Complementario__c> lstTTCC =
			[SELECT id, F_Acumula__c, F_ClubTerpel__c, F_Redime__c, F_Reclama__c  FROM  Ter_Negocio_Complementario__c WHERE F_IdFidelizacion__c = :strCodigoTTCC];
			if (!lstTTCC.isEmpty()) {
				result = lstTTCC.get(0);
			}

		}
		catch (Exception e) {
			System.debug(e.getStackTraceString());
		}

		return result;
	}


	/**
	 * Metodo encargadi de validar la identificacion por tipo de identificacion.
	 * @param response la respuesta que sedesea llenar despues de validar.
	 * @param strErrores los errores previos a la validacion.
	 * @param objValidaCliente contiene la informacion de la identificacion.
	 */
	public void validateIdentificationByType
					(SrvIntClienteTransaccion_in.DT_ValidarResponse response, String strErrores,
							SrvIntClienteTransaccion_in.DT_ValidaCliente objValidaCliente) {
		Map<String, String> responses = new Map<String, String>();
		String strCMessage = null;
		String strCustomerName = null;
		FieloPLT__Member__c objMember = null;
		List<FieloPLT__Member__c> lstMembers = null;
		
		SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo objContextoRespuestaTipo; 
		SrvIntClienteTransaccion_in.DT_FalloTipo objFalloTipo;
		SrvIntClienteTransaccion_in.DT_ErrorTipo objErrorTipo;
		list<SrvIntClienteTransaccion_in.DT_ErrorTipo> lstErrorTipo;
		
		lstErrorTipo = new list<SrvIntClienteTransaccion_in.DT_ErrorTipo>();
		System.debug('Comparando -->' + objValidaCliente.tipoDocumento.codTipoidentificacion);


		if (Label.TER_NUMERO_LIFE_MILES_TYPE.equals
				(objValidaCliente.tipoDocumento.codTipoidentificacion)) {
			lstMembers = [select F_NumeroLifeMiles__c, FieloPLT__Status__c
			From FieloPLT__Member__c where
					F_NumeroLifeMiles__c =:objValidaCliente.tipoDocumento.valNumeroIdentificacion ];
			if (!lstMembers.isEmpty()) {
				objMember = lstMembers.get(0);

				System.debug('Status Member -->' + objMember.FieloPLT__Status__c);
				if (Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					strCMessage = Label.Fielo_ClienteIdentificado;
					strCustomerName = objMember.F_NumeroLifeMiles__c;
				}
				else {
					strErrores += '\n' + Label.Fielo_ClienteInactivo;
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Cliente_Inactivo;
					objErrorTipo.valDescError = label.Fielo_ClienteInactivo;
					objErrorTipo.valDescErrorTecnico = label.Fielo_ClienteInactivo;
					lstErrorTipo.add(objErrorTipo);
				}
			}
			else {
				strErrores += '\n' + Label.Fielo_ClienteInexistente;
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Cliente_Inexistente;
				objErrorTipo.valDescError = label.Fielo_ClienteInexistente;
				objErrorTipo.valDescErrorTecnico = label.Fielo_ClienteInexistente;
				lstErrorTipo.add(objErrorTipo);
			}
		}
		else if (Label.TER_TARJETA_PREINSCRITA_TYPE.equals
				(objValidaCliente.tipoDocumento.codTipoidentificacion)) {
			lstMembers = [select F_NumeroTarjetaPreinscrita__c, FieloPLT__Status__c, F_EstadoTarjetaPreinscrita__c,
					F_PrimerNombre__c, F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c
				From FieloPLT__Member__c where
					F_NumeroTarjetaPreinscrita__c
							=:objValidaCliente.tipoDocumento.valNumeroIdentificacion ];

			if (!lstMembers.isEmpty()) {
				objMember = lstMembers.get(0);
				System.debug('statusPre -->' + objMember.F_EstadoTarjetaPreinscrita__c);
				if (!Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					strErrores += '\n' + Label.Fielo_ClienteInactivo;
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Cliente_Inactivo;
					objErrorTipo.valDescError = label.Fielo_ClienteInactivo;
					objErrorTipo.valDescErrorTecnico = label.Fielo_ClienteInactivo;
					lstErrorTipo.add(objErrorTipo);
				} else if (label.TER_STATUS_CARD_EXPIRED.equals(objMember.F_EstadoTarjetaPreinscrita__c)) {
					strErrores += '\n' + Label.Fielo_TarjetaPreinscritaExpirada;
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Card_Expired;
					objErrorTipo.valDescError = label.Fielo_TarjetaPreinscritaExpirada;
					objErrorTipo.valDescErrorTecnico = label.Fielo_TarjetaPreinscritaExpirada;
					lstErrorTipo.add(objErrorTipo);

				} else if (Label.TER_STATUS_CARD_USED.equals(objMember.F_EstadoTarjetaPreinscrita__c)) {
					strErrores += '\n' + Label.Fielo_TarjetaPreinscritaUsada;
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Card_Expired;
					objErrorTipo.valDescError = label.Fielo_TarjetaPreinscritaUsada;
					objErrorTipo.valDescErrorTecnico = label.Fielo_TarjetaPreinscritaUsada;
					lstErrorTipo.add(objErrorTipo);
				}
				else if (Label.Ter_lbl_TPI_Activa.equals(objMember.F_EstadoTarjetaPreinscrita__c) 
						|| label.Ter_lbl_TPI_Inactiva.equals(objMember.F_EstadoTarjetaPreinscrita__c)
						|| label.Ter_lbl_TPI_Asignada.equals(objMember.F_EstadoTarjetaPreinscrita__c)) {
					strCMessage = Label.Fielo_TarjetaPreinscritaIdentificada ;
					/*strCustomerName = objMember.F_PrimerNombre__c + ' '
							+ objMember.F_SegundoNombre__c + ' ' + objMember.F_PrimerApellido__c
							+ ' ' + objMember.F_SegundoApellido__c ;*/
					strCustomerName = (String.isEmpty(objMember.F_PrimerNombre__c) ? '' : objMember.F_PrimerNombre__c + ' ') 
					+ (String.isEmpty(objMember.F_SegundoNombre__c) ? '' : objMember.F_SegundoNombre__c + ' ' ) 
					+ (String.isEmpty(objMember.F_PrimerApellido__c) ? '' : objMember.F_PrimerApellido__c + ' ')  
					+ (String.isEmpty(objMember.F_SegundoApellido__c) ? '' : objMember.F_SegundoApellido__c);
				} else {
					strErrores += '\n' + Label.Fielo_ClienteInactivo;
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Cliente_Inactivo;
					objErrorTipo.valDescError = label.Fielo_ClienteInactivo;
					objErrorTipo.valDescErrorTecnico = label.Fielo_ClienteInactivo;
					lstErrorTipo.add(objErrorTipo);
				}
			}
			else {
				strErrores += '\n' + Label.Fielo_TarjetaPreinscritaInexistente;
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_TPI_Inexistente;
				objErrorTipo.valDescError = label.Fielo_TarjetaPreinscritaInexistente;
				objErrorTipo.valDescErrorTecnico = label.Fielo_TarjetaPreinscritaInexistente;
				lstErrorTipo.add(objErrorTipo);
			}
		}
		else {
			lstMembers = [select F_IdentificationNumber__c, FieloPLT__Status__c,
					F_PrimerNombre__c, F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c
				From FieloPLT__Member__c where
					F_IdentificationNumber__c
							=:objValidaCliente.tipoDocumento.valNumeroIdentificacion ];
			if (!lstMembers.isEmpty()) {
				objMember = lstMembers.get(0);
				if (Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					strCMessage = Label.Fielo_ClienteIdentificado;
					/*strCustomerName = objMember.F_PrimerNombre__c + ' '
							+ objMember.F_SegundoNombre__c + ' ' + objMember.F_PrimerApellido__c
							+ ' ' + objMember.F_SegundoApellido__c ;*/
					strCustomerName = (String.isEmpty(objMember.F_PrimerNombre__c) ? '' : objMember.F_PrimerNombre__c + ' ') 
					+ (String.isEmpty(objMember.F_SegundoNombre__c) ? '' : objMember.F_SegundoNombre__c + ' ' ) 
					+ (String.isEmpty(objMember.F_PrimerApellido__c) ? '' : objMember.F_PrimerApellido__c + ' ')  
					+ (String.isEmpty(objMember.F_SegundoApellido__c) ? '' : objMember.F_SegundoApellido__c);
				} else {
					strErrores += '\n' + Label.Fielo_ClienteInactivo ;
					objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
					objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Cliente_Inactivo;
					objErrorTipo.valDescError = label.Fielo_ClienteInactivo;
					objErrorTipo.valDescErrorTecnico = label.Fielo_ClienteInactivo;
					lstErrorTipo.add(objErrorTipo);
				}
			}
			else {
				strErrores += '\n' + Label.Fielo_ClienteInexistente;
				objErrorTipo = new SrvIntClienteTransaccion_in.DT_ErrorTipo();
				objErrorTipo.codError = label.Ter_lbl_Codigo_Error_Cliente_Inexistente;
				objErrorTipo.valDescError = label.Fielo_ClienteInexistente;
				objErrorTipo.valDescErrorTecnico = label.Fielo_ClienteInexistente;
				lstErrorTipo.add(objErrorTipo);
			}
		}
		
		if(!lstErrorTipo.isEmpty()){
			objFalloTipo = new SrvIntClienteTransaccion_in.DT_FalloTipo();
			
			String strFecha = Ter_Utilidades_cls.obtenerFechaActualFormateadaStr(Ter_LogicaServiciosCore_cls.FORMATO_FECHA_RTA); 
			objFalloTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objFalloTipo.fechaTx = strFecha;
			objFalloTipo.errores = lstErrorTipo;
			
			objContextoRespuestaTipo = new SrvIntClienteTransaccion_in.DT_ContextoRespuestaTipo();
			objContextoRespuestaTipo.codEstadoTx = label.Ter_lbl_codEstadoTx_Error;
			objContextoRespuestaTipo.fechaTx = strFecha;
			
			response.falloTipo = objFalloTipo;
			response.contextoRespuestaTipo = objContextoRespuestaTipo;
			
			response.validaClienteRes.confirm = false;
			response.validaClienteRes.mensajePer = strErrores;
		} else{
			response.validaClienteRes.confirm = true;
			response.validaClienteRes.nombreCliente = strCustomerName != null ? strCustomerName : '';
			response.validaClienteRes.mensajePer = strCMessage;
		}

	}



	/**
	 * Metodo encargadi de validar la identificacion por tipo de identificacion.
	 * @param codTipoidentificacion codigo de identificacion.
	 * @param valNumeroIdentificacion numero de identificacion.
	 *
	 */
	public void validateIdentificationByType
			(String codTipoidentificacion, String valNumeroIdentificacion) {
		SrvIntClienteTransaccion_in.DT_ValidarResponse objValidarResponse = 
						new SrvIntClienteTransaccion_in.DT_ValidarResponse();
		SrvIntClienteTransaccion_in.DT_ValidaClienteResponse objValidaClienteResponse =
						new SrvIntClienteTransaccion_in.DT_ValidaClienteResponse();

		SrvIntClienteTransaccion_in.DT_ValidaCliente objValidaCliente =
							new SrvIntClienteTransaccion_in.DT_ValidaCliente();
		SrvIntClienteTransaccion_in.DT_Identificacion tipoDocumento =
						new SrvIntClienteTransaccion_in.DT_Identificacion();

		tipoDocumento.codTipoidentificacion = codTipoidentificacion;
		tipoDocumento.valNumeroIdentificacion = valNumeroIdentificacion;
		objValidaCliente.tipoDocumento = tipoDocumento;
		objValidarResponse.validaClienteRes = objValidaClienteResponse;
		System.debug('Antes de validar-->');
		validateIdentificationByType( objValidarResponse, '', objValidaCliente);
		System.debug('response.confirm -->' + objValidarResponse.validaClienteRes.confirm);
		System.debug('response.mensajePer -->' + objValidarResponse.validaClienteRes.mensajePer);

		if (!objValidarResponse.validaClienteRes.confirm) {
			throw new Ter_ValidationException(objValidarResponse.validaClienteRes.mensajePer);
		}
	}
	
	/* 
	* Nombre: obtenerMember
    * Descripcion: Metodo encargado de consultar un Member de acuerdo al tipo de documento y numero de identificacion
    * Fecha Creación: 20/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            20-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	public FieloPLT__Member__c obtenerMember(String strTipoIdentificacion, String strNumeroIdentificacion) {
		FieloPLT__Member__c objMember = null;
		List<FieloPLT__Member__c> lstMembers = null;

		if (Label.TER_NUMERO_LIFE_MILES_TYPE.equals(strTipoIdentificacion)) {
			lstMembers = [SELECT F_NumeroLifeMiles__c, FieloPLT__Status__c, FieloPLT__Account__c, F_PrimerNombre__c, 
								 F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c, RecordType.DeveloperName
						  FROM FieloPLT__Member__c 
						  WHERE F_NumeroLifeMiles__c = :strNumeroIdentificacion ];
			if (!lstMembers.isEmpty()) {
				objMember = lstMembers.get(0);

				if (Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					return objMember;
				}
				else {
					throw new Ter_ValidationException(Label.Fielo_ClienteInactivo);
				}
			}
			else {
				throw new Ter_ValidationException(Label.Fielo_ClienteInexistente);
			}
		}
		else if (Label.TER_TARJETA_PREINSCRITA_TYPE.equals(strTipoIdentificacion)) {
			lstMembers = [SELECT F_NumeroTarjetaPreinscrita__c, FieloPLT__Status__c, FieloPLT__Account__c,  F_NumeroLifeMiles__c, 
								 F_PrimerNombre__c, F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c, RecordType.DeveloperName, F_EstadoTarjetaPreinscrita__c
						  FROM FieloPLT__Member__c 
						  WHERE F_NumeroTarjetaPreinscrita__c = :strNumeroIdentificacion ];
			if (!lstMembers.isEmpty()) {
				objMember = lstMembers.get(0);
				if (label.TER_STATUS_CARD_EXPIRED.equals(objMember.F_EstadoTarjetaPreinscrita__c)) {
					throw new Ter_ValidationException(Label.Fielo_TarjetaPreinscritaExpirada);
				}
				else if (label.TER_STATUS_CARD_USED.equals(objMember.F_EstadoTarjetaPreinscrita__c)) {
					throw new Ter_ValidationException(Label.Fielo_TarjetaPreinscritaUsada);
				}
				else if (Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					return objMember;
				} else {
					throw new Ter_ValidationException(Label.Fielo_ClienteInactivo);
				}
			}
			else {
				throw new Ter_ValidationException(Label.Fielo_TarjetaPreinscritaInexistente);
			}
		}
		else {
			lstMembers = [SELECT F_IdentificationNumber__c, FieloPLT__Status__c, FieloPLT__Account__c, F_NumeroLifeMiles__c, 
								 F_PrimerNombre__c, F_SegundoNombre__c, F_PrimerApellido__c, F_SegundoApellido__c, RecordType.DeveloperName
						  FROM FieloPLT__Member__c 
						  WHERE F_IdentificationNumber__c = :strNumeroIdentificacion and F_IdentificationType__c =:strTipoIdentificacion ];
			if (!lstMembers.isEmpty()) {
				objMember = lstMembers.get(0);
				if (Label.TER_STATUS_ACTIVE_MEMBER.equals(objMember.FieloPLT__Status__c)) {
					return objMember;
				} else {
					throw new Ter_ValidationException(Label.Fielo_ClienteInactivo);
				}
			}
			else {
				throw new Ter_ValidationException(Label.Fielo_ClienteInexistente);
			}
		}
	}
	
	public map<String, Fielo_MedioDePago__c> consultarMedioPago(set<String> lstCodMedioPago, String strOrigen){
		list<Fielo_MedioDePago__c> lstMedioPago;
		map<String, Fielo_MedioDePago__c> mapMedioPago;
		
		mapMedioPago = new map<String, Fielo_MedioDePago__c>();
		
		if(label.Ter_lbl_EDS.equals(strOrigen)){
			lstMedioPago = [SELECT Id, F_IdMedioDePagoEDS__c, F_Acumula__c FROM Fielo_MedioDePago__c WHERE F_IdMedioDePagoEDS__c IN :lstCodMedioPago];
			if(!lstMedioPago.isEmpty()){
				for(Fielo_MedioDePago__c objMedioPagoAux : lstMedioPago){
					mapMedioPago.put(objMedioPagoAux.F_IdMedioDePagoEDS__c, objMedioPagoAux);
				}
			}
		}
		
		if(label.Ter_lbl_TDC.equals(strOrigen)){
			lstMedioPago = [SELECT Id, F_IdMedioDePagoTTCC__c, F_Acumula__c FROM Fielo_MedioDePago__c WHERE F_IdMedioDePagoTTCC__c IN :lstCodMedioPago];
			if(!lstMedioPago.isEmpty()){
				for(Fielo_MedioDePago__c objMedioPagoAux : lstMedioPago){
					mapMedioPago.put(objMedioPagoAux.F_IdMedioDePagoTTCC__c, objMedioPagoAux);
				}
			}
		}
		
		return mapMedioPago;
	}


}