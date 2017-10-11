/***************************************************************************************************************
* Avanxo 
* @author           Juan David Uribe Ruiz
* Proyecto:         Fielo/Terpel
* Descripción:      Clase Web Service la cual expone los servicios para validar clietes y para Realizar Acumulacion/Redencion/Reclamacion
* Cambios (Version)
* -------------------------------------------
*           No.     Fecha           Autor                               Descripción
*           -----   ----------      ---------------------               ---------------
* @version   1.0    02/06/2017      Juan David Uribe Ruiz               Creación de la clase
****************************************************************************************************************/
global class SrvIntClienteTransaccion_in {
	
	/* 
	* Nombre: OpClienteValidar_Sync
    * Descripcion: Metodo que exponen el servicio para validar si un PDV se encuentra habilitado para Acumular, adicionalmente 
    * 			   valida si el cliente recibido esta activo y no tiene restricciones para realizar acumulación
    * Fecha Creación: 02/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            02-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	webservice static DT_ValidarResponse OpClienteValidar_Sync( DT_ValidaCliente validaCliente, DT_ContextoTransaccionalTipo contextoTransaccionalTipo){
		DT_ValidarResponse validarResponse = new DT_ValidarResponse();
		Ter_LogicaServiciosCliente_cls objLogicaServiciosCliente; 
		
		/*******************************************/
		Datetime dtLlegadaFielo =  Datetime.now();
		long miliLlegadaFielo = dtLlegadaFielo.getTime();
		system.debug('[Valida]*************>>>>>>> miliLlegadaFielo: ' + miliLlegadaFielo);
		/*******************************************/
		
		system.debug('***********************************************************');
        system.debug(validaCliente);
        system.debug('***********************************************************');
		
		objLogicaServiciosCliente = new Ter_LogicaServiciosCliente_cls();
		validarResponse = objLogicaServiciosCliente.validarCliente(validaCliente);
		
        system.debug('***********************************************************');
        system.debug(validarResponse);
        system.debug('***********************************************************');
        
        /*******************************************/
		Datetime dtSalidaFielo =  Datetime.now();
		long miliSalidaFielo = dtSalidaFielo.getTime();
		system.debug('[Valida]*************>>>>>>> miliSalidaFielo: ' + miliSalidaFielo);
		system.debug('[Valida]*************>>>>>>> Diferencia: ' + (miliSalidaFielo - miliLlegadaFielo));
		/*******************************************/
		
		return validarResponse;
	}
	
	/* 
	* Nombre: OpClienteAcumularRedimir_Sync
    * Descripcion: Metodo que exponen el servicio para realizar el proceso de Acumulacion/Redencion/Reclamacion y cambio de medio de pago.
    * Fecha Creación: 02/06/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            02-Jun-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	webservice static DT_AcumularRedimirResponse OpClienteAcumularRedimir_Sync( DT_AcumulaRedimeCliente acumulaRedimeCliente, DT_ContextoTransaccionalTipo contextoTransaccionalTipo ){
		DT_AcumularRedimirResponse acumularRedimirResponse = new DT_AcumularRedimirResponse();
		Ter_LogicaServiciosCore_cls objLogicaServiciosCore;
		
		/*******************************************/
		Datetime dtLlegadaFielo =  Datetime.now();
		long miliLlegadaFielo = dtLlegadaFielo.getTime();
		system.debug('[AcumulaRedime]*************>>>>>>> miliLlegadaFielo: ' + miliLlegadaFielo);
		/*******************************************/
		
		system.debug('***********************************************************');
        system.debug(acumulaRedimeCliente);
        system.debug('***********************************************************');
		
		objLogicaServiciosCore = new Ter_LogicaServiciosCore_cls();
		acumularRedimirResponse = objLogicaServiciosCore.procesaTransaccion(acumulaRedimeCliente, contextoTransaccionalTipo);
		
		system.debug('***********************************************************');
        system.debug(acumularRedimirResponse);
        system.debug('***********************************************************');
        
        /*******************************************/
		Datetime dtSalidaFielo =  Datetime.now();
		long miliSalidaFielo = dtSalidaFielo.getTime();
		system.debug('[AcumulaRedime]*************>>>>>>> miliSalidaFielo: ' + miliSalidaFielo);
		system.debug('[AcumulaRedime]*************>>>>>>> Diferencia: ' + (miliSalidaFielo - miliLlegadaFielo));
		/*******************************************/
		
		return acumularRedimirResponse;
	}
	
	/* 
	* Nombre: OpClienteValidarVoucher_Sync
    * Descripcion: Metodo que exponen el servicio para realizar la validacion de Vouchers desde las EDS o TTCC.
    * Fecha Creación: 25/07/2017
    * Cambios de Version del Metodo:
    * --------------------------------------------------------------------------------------------------------------
    * Version        Fecha                   Autor                           Descripción
    * ---------     ------------     ----------------------      -----------------------------
    *   1            25-Jul-2017     Juan David Uribe Ruiz         Creacion del metodo.
    * --------------------------------------------------------------------------------------------------------------
    */
	webservice static DT_ValidaVoucherClienteSalida OpClienteValidarVoucher_Sync(DT_ValidaVoucherClienteEntrada MT_validaVoucherClienteRequest ){
		DT_ValidaVoucherClienteSalida MT_validaVoucherClienteResponse = new DT_ValidaVoucherClienteSalida();
		Ter_LogicaServiciosCore_cls objLogicaServiciosCore;
		
		/*******************************************/
		Datetime dtLlegadaFielo =  Datetime.now();
		long miliLlegadaFielo = dtLlegadaFielo.getTime();
		system.debug('[ValidarVoucher]*************>>>>>>> miliLlegadaFielo: ' + miliLlegadaFielo);
		/*******************************************/
		
		system.debug('***********************************************************');
        system.debug(MT_validaVoucherClienteRequest);
        system.debug('***********************************************************');
		
		objLogicaServiciosCore = new Ter_LogicaServiciosCore_cls();
		MT_validaVoucherClienteResponse = objLogicaServiciosCore.validarVoucherSync(MT_validaVoucherClienteRequest);
		
		system.debug('***********************************************************');
        system.debug(MT_validaVoucherClienteResponse);
        system.debug('***********************************************************');
        
        /*******************************************/
		Datetime dtSalidaFielo =  Datetime.now();
		long miliSalidaFielo = dtSalidaFielo.getTime();
		system.debug('[ValidarVoucher]*************>>>>>>> miliSalidaFielo: ' + miliSalidaFielo);
		system.debug('[ValidarVoucher]*************>>>>>>> Diferencia: ' + (miliSalidaFielo - miliLlegadaFielo));
		/*******************************************/
		
		return MT_validaVoucherClienteResponse;
	}
	
	global class DT_ValidaCliente{
		webservice String origenTransaccion;
		webservice String idPuntoVenta;
		webservice String fechaTransaccion;
		webservice DT_Identificacion tipoDocumento;
	}
	
	global class DT_Identificacion{
		webservice String codTipoidentificacion;
		webservice String valNumeroIdentificacion;
		webservice String codTipoPais;
		webservice String pin;
	}
	
	global class DT_ValidaClienteResponse{
		webservice Boolean confirm;
		webservice String mensajePer;
		webservice String nombreCliente = '';
	}
	
	global class DT_FalloTipo{
		webservice String codEstadoTx;
		webservice String fechaTx;
		webservice DT_ErrorTipo[] errores;
	}
	
	global class DT_ErrorTipo{
		webservice String codError;
		webservice String valDescError;
		webservice String valDescErrorTecnico;
	}
	
	global class DT_Producto{
		webservice String idProducto;
		webservice Decimal cantidad;
		webservice Decimal valorUnitario;

	}
	
	global class DT_MedioPago{
		webservice Integer codigoMedioPago;
		webservice Decimal monto;
		webservice Integer millasRedimidas;
		webservice String codigoVoucher;
	}
	
	global class DT_AcumulaRedimeCliente{
		webservice String idVenta;
		webservice String fechaTransaccion;
		webservice String tipoTransaccion;
		webservice Decimal montoTotal;
		webservice Decimal descuento;
		webservice Decimal valorPagar;
		webservice Decimal impuesto;
		webservice String idPromotor;
		webservice String idPuntoVenta;
		webservice String origenTransaccion;
		webservice DT_Identificacion tipoDocumento;
		webservice String tipoVenta;
		webservice DT_Producto[] productos;
		webservice DT_MedioPago[] mediosPago;
	}
	
	global class DT_AcumulaRedimeClienteResponse{
		webservice Integer infoMillasAcumuladas;
		webservice String nombreCliente;
		webservice Integer idResponse;
		webservice String descResponse;
		
	}
	
	global class DT_ContextoTransaccionalTipo{
		webservice String codTipoEvento;
		webservice String fecEvento;
		webservice String valUsuario;
	}
	
	global class DT_ContextoRespuestaTipo{
		webservice String codEstadoTx;
		webservice String fechaTx;
	}
	
	global class DT_ValidarResponse{
		webservice DT_ValidaClienteResponse validaClienteRes;
		webservice DT_ContextoRespuestaTipo contextoRespuestaTipo;
		webservice DT_FalloTipo falloTipo;
	}
	
	global class DT_AcumularRedimirResponse{
		webservice DT_AcumulaRedimeClienteResponse acumulaRedimeClienteRes;
		webservice DT_ContextoRespuestaTipo contextoRespuestaTipo;
		webservice DT_FalloTipo falloTipo;
	}
 
	global class DT_ValidaVoucherClienteEntrada{
		webservice DT_ContextoTransaccionalTipo contextoTransaccionalTipo;
		webservice String origenVenta;
		webservice String idPuntoVenta;
		webservice String codVoucher;
		webservice Decimal monto;
	}

	global class DT_ValidaVoucherClienteSalida{
		webservice DT_ContextoRespuestaTipo contextoRespuestaTipo;
		webservice String estado;
		webservice Decimal monto;
		webservice String mensajePer;
		webservice DT_FalloTipo falloTipo;
	}
	    
}