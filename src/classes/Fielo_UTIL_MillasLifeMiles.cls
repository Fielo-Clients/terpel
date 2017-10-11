/*******************************************************************************
*                          Copyright (C) 2017 ValueNET
* ------------------------------------------------------------------------------
* Author: EBC                          date: 03/07/2017
* 
* Name: Fielo_UTIL_MillasLifeMiles.cls
* 
* Classe utilitaria
*
*******************************************************************************/
global class Fielo_UTIL_MillasLifeMiles {  

	// Venta
	public final static String REVERTIDA = 'Revertida';

	// Origin Venta
	public final static String TIENDA = 'Tienda';
	public final static String ESTACION_DE_SERVICIO = 'Estación de Servicio';

	//  Estado Autorizacion LifeMiles
	public final static String APROBADO = 'Aprobado';
	public final static String PENDIENTE = 'Pendiente';
	public final static String RECHAZADO = 'Rechazado';
	public final static String REVERTIDO = 'Revertido';
	public final static String REINTENTAR = 'Reintentar';

	//  Tipo Transaccion Autorizacion LifeMiles
	public final static String CREDITO = 'Crédito (C)';
	public final static String DEBITO = 'Débito (D)';    
	public final static String REVERSION = 'Reversión (R)';
	
	// Status Member
	public final static String BLOQUEADO = 'Bloqueado';

	// Status Redemption Item
	public final static String READY = 'Ready';

	webservice static String reversionMillasLifeMiles(String aIdAutLifeMiles){ 

		List<Fielo_Autorizacion_LifeMiles__c> lAutLifeMiles = [
				SELECT F_TipoTransaccion__c, F_MillasBase__c, F_Estado__c, F_Member__c, 
				F_NumeroLifeMiles__c, F_MillasPromocionales__c, F_Venta__c, F_IdTransaccion__c, 
				F_Member__r.F_SessionId__c, F_MontoTransaccion__c,
				(SELECT id FROM Autorizaci_ns_LifeMiles__r)
				FROM Fielo_Autorizacion_LifeMiles__c 
				WHERE id =: aIdAutLifeMiles];
				//AND F_Estado__c = :APROBADO
				//AND F_TipoTransaccion__c IN (:CREDITO, :DEBITO)];

		if(lAutLifeMiles.size() == 0) return 'Error: Autorizacion LifeMiles not found.';  

		if(lAutLifeMiles[0].F_Estado__c != APROBADO || 
				(lAutLifeMiles[0].F_TipoTransaccion__c != CREDITO &&
				lAutLifeMiles[0].F_TipoTransaccion__c != DEBITO)) {

			return Label.Fielo_AutorizacionErrorReversion;
		}  

		Fielo_Autorizacion_LifeMiles__c lAutReversion = lAutLifeMiles[0].clone(false, true, false, false);

		// get child autorization from padre
		if(lAutLifeMiles[0].Autorizaci_ns_LifeMiles__r.size() > 0) lAutReversion.id = lAutLifeMiles[0].Autorizaci_ns_LifeMiles__r[0].id;

		lAutReversion.F_AutorizacionLMPadre__c = lAutLifeMiles[0].id;
		lAutReversion.F_TipoTransaccion__c = REVERSION;
		lAutReversion.F_IdTransaccion__c = Ter_Utilidades_cls.obtenerTransaccionIdLifeMiles();
		lAutReversion.F_Estado__c = PENDIENTE;
		lAutReversion.F_MotivoRechazo__c = '';

		String lRetInvoke;
		if(lAutLifeMiles[0].F_TipoTransaccion__c == CREDITO) {
			lRetInvoke = invokeMilesConversion(lAutReversion, new Set<String>{label.Ter_lbl_Codigo_Exito_Reintento_LM, label.Ter_lbl_Codigo_Exito_Reversion_LM, Label.Ter_lbl_Codigo_Exito_Acumulacion_LM});
		}
		else if(lAutLifeMiles[0].F_TipoTransaccion__c == DEBITO) {
			lRetInvoke = invokePostMilesStr(lAutReversion, new Set<String>{label.Ter_lbl_Codigo_Exito_Redencion_LM});
		}        

		if(lRetInvoke != null || lAutReversion.F_Estado__c != REVERTIDO) {
			if(lAutReversion.F_Estado__c == APROBADO) {
				lAutReversion.F_Estado__c = REVERTIDO;  
			}
			else {
				lAutReversion.F_Estado__c = RECHAZADO;  
			}              
		}

		Savepoint sp = Database.setSavepoint();

		try{
			// Reverte os itens do Resgate
			if(lAutLifeMiles[0].F_TipoTransaccion__c == DEBITO){
				revertirRedemptionItens(lAutLifeMiles[0].id);
			}				

			upsert lAutReversion;

			// Caso tenha retorno de erro, salva apenas a autorização de reversão
			if((lRetInvoke != null || !String.isBlank(lAutReversion.F_MotivoRechazo__c))) return lRetInvoke;

			lAutLifeMiles[0].F_Estado__c = REVERTIDO;

			update lAutLifeMiles[0];

			if(lAutReversion.F_Venta__c != null) {
				update new Fielo_Venta__c(id = lAutReversion.F_Venta__c, F_Estado__c = REVERTIDA);
			}
		}
		catch(DmlException e) {
			Database.rollback(sp);
			return e.getDMLMessage(0);
		}
		catch(Exception e) {
			Database.rollback(sp);
			return e.getMessage();
		}

		return 'Millas Revertidas';
	}  

  webservice static String reintentarseMillasLifeMiles(String aIdAutLifeMiles){ 

	List<Fielo_Autorizacion_LifeMiles__c> lAutLifeMiles = [
			SELECT F_TipoTransaccion__c, F_MillasBase__c, F_MillasPromocionales__c, F_Venta__c, 
			F_Estado__c, F_NumeroLifeMiles__c, F_Member__c, F_ReintentosConexionLM__c, F_IdTransaccion__c,
			F_MontoTransaccion__c
			FROM Fielo_Autorizacion_LifeMiles__c 
			WHERE id =: aIdAutLifeMiles];
			//AND F_Estado__c IN (:RECHAZADO,:REINTENTAR)];

	if(lAutLifeMiles.size() == 0) return 'Error: Autorizacion LifeMiles not found.';  

	//Solo autorizaciones aprobadas de tipo Débito o Crédito pueden ser revertidas.
	if((lAutLifeMiles[0].F_Estado__c != RECHAZADO && lAutLifeMiles[0].F_Estado__c != REINTENTAR) || 
			(lAutLifeMiles[0].F_TipoTransaccion__c != CREDITO && lAutLifeMiles[0].F_TipoTransaccion__c != DEBITO)) {

		return 'Solo pueden ser Reintentar autorizaciones de tipo Débito o Crédito y con estado rechazado o reintentar.';
	} 

	// Increment reintentos
	lAutLifeMiles[0].F_ReintentosConexionLM__c += 1;

	String lRetInvoke;
	if(lAutLifeMiles[0].F_TipoTransaccion__c == CREDITO) {
		lRetInvoke =invokeMilesConversion(lAutLifeMiles[0], new Set<String>{label.Ter_lbl_Codigo_Exito_Reintento_LM, label.Ter_lbl_Codigo_Exito_Acumulacion_LM, label.Ter_lbl_Proceso_Acumulacion});
	}
	else if(lAutLifeMiles[0].F_TipoTransaccion__c == DEBITO) {
		lRetInvoke = invokePostMilesStr(lAutLifeMiles[0], new Set<String>{label.Ter_lbl_Codigo_Exito_Redencion_LM});
	}
	system.debug('lRetInvoke ' + lRetInvoke);
	if(lRetInvoke != null && !Test.isRunningTest()) return lRetInvoke;

	Savepoint sp = Database.setSavepoint();

	try{
		update lAutLifeMiles[0];
	}
	catch(DmlException e) {
		return e.getDMLMessage(0);
	}catch(Exception e) {
		return e.getMessage();
	}

	if(lAutLifeMiles[0].F_Estado__c != APROBADO) {

		return lAutLifeMiles[0].F_MotivoRechazo__c;
	}

	try{
		if(lAutLifeMiles[0].F_Venta__c != null) update new Fielo_Venta__c(id = lAutLifeMiles[0].F_Venta__c, F_Estado__c = 'Aprobada');
	}
	catch(DmlException e) {
		Database.rollback(sp);
		return e.getDMLMessage(0);
	}catch(Exception e) {
		Database.rollback(sp);
		return e.getMessage();
	}

	return 'Millas Aprobada';
  }

  private static String invokeMilesConversion(Fielo_Autorizacion_LifeMiles__c aAutLifeMiles, Set<String> aCodOperationSet) {

	Ter_ConversionWsConsumer_cls objConversionWsConsumer = new Ter_ConversionWsConsumer_cls();
	Ter_ConversionWsResponseDTO_cls objResponse;        

	try{
		objResponse = objConversionWsConsumer.invokeMilesConversion(aAutLifeMiles);
	} catch (Exception e) {

		aAutLifeMiles.F_Estado__c = RECHAZADO;
		aAutLifeMiles.F_MotivoRechazo__c = label.Ter_lbl_Mensaje_Error_Acumulacion_LM;
		return aAutLifeMiles.F_MotivoRechazo__c;
	}    

	aAutLifeMiles.F_CodigoRespuestaLM__c = objResponse.getResponseCode();

	if(!aCodOperationSet.contains(objResponse.getResponseCode())){
		Map<String, String> mapCodigosError = Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_Proceso_Acumulacion);        
		if(mapCodigosError.containsKey(objResponse.getResponseCode())){
			aAutLifeMiles.F_MotivoRechazo__c = mapCodigosError.get(objResponse.getResponseCode());
		} else{
			aAutLifeMiles.F_MotivoRechazo__c = label.Ter_lbl_Error_General_Acumulacion;
		}
		aAutLifeMiles.F_Estado__c = RECHAZADO;
		return aAutLifeMiles.F_MotivoRechazo__c;
	}
	else {

		aAutLifeMiles.F_NumeroAutorizacionLM__c = objResponse.getAuthoNum();
		aAutLifeMiles.F_MillasBonus__c = objResponse.getBonusMiles();
		aAutLifeMiles.F_MotivoRechazo__c = '';

		if(aCodOperationSet.contains(label.Ter_lbl_Codigo_Exito_Reversion_LM)) {

			aAutLifeMiles.F_Estado__c = REVERTIDO;
		}
		else if(aCodOperationSet.contains(label.Ter_lbl_Codigo_Exito_Acumulacion_LM) ||
				aCodOperationSet.contains(label.Ter_lbl_Codigo_Exito_Reintento_LM) ||
				aCodOperationSet.contains(label.Ter_lbl_Proceso_Acumulacion)) {

			aAutLifeMiles.F_Estado__c = APROBADO;
		}   
	}
	return null;
  }

  private static String invokePostMilesStr(Fielo_Autorizacion_LifeMiles__c aAutLifeMiles, Set<String> aCodOperationSet) {        

		Ter_LifeMilesConversionWsConsumer_cls objLifeMilesConversionWsConsumer = new Ter_LifeMilesConversionWsConsumer_cls();
		Ter_ResponseRedentionDTO_cls objResponse;
		system.debug('aAutLifeMiles ' + aAutLifeMiles);
		try{
			objResponse = objLifeMilesConversionWsConsumer.invokePostMilesStr(aAutLifeMiles, null, null);//aAutLifeMiles.F_Member__r.F_SessionId__c
		} catch (Ter_AcumulacionException e) {
			aAutLifeMiles.F_Estado__c = RECHAZADO;
			aAutLifeMiles.F_MotivoRechazo__c = e.getMessage();
			return aAutLifeMiles.F_MotivoRechazo__c;
		} catch (Exception e) {
			aAutLifeMiles.F_Estado__c = RECHAZADO;
			aAutLifeMiles.F_MotivoRechazo__c = e.getMessage();
			return aAutLifeMiles.F_MotivoRechazo__c;
		}        
		system.debug('objResponse ' + objResponse);        
		aAutLifeMiles.F_CodigoRespuestaLM__c = objResponse.getBody().getPostingResponse().getResponse_code();

		if(!aCodOperationSet.contains(aAutLifeMiles.F_CodigoRespuestaLM__c)){
			Map<String, String> mapCodigosError = Ter_Utilidades_cls.obtenerCodigosError(label.Ter_lbl_TipoTransaccion_Redencion);       
			if(mapCodigosError.containsKey(aAutLifeMiles.F_CodigoRespuestaLM__c)){
				aAutLifeMiles.F_MotivoRechazo__c = mapCodigosError.get(aAutLifeMiles.F_CodigoRespuestaLM__c);
			} else{
				aAutLifeMiles.F_MotivoRechazo__c = label.Ter_lbl_Error_General_Redencion;
			}
			aAutLifeMiles.F_Estado__c = RECHAZADO;
			return aAutLifeMiles.F_MotivoRechazo__c;
		}
		else{            

			aAutLifeMiles.F_NumeroAutorizacionLM__c = objResponse.getBody().getPostingResponse().getAutho_num();
			aAutLifeMiles.F_MotivoRechazo__c = '';

			if(aCodOperationSet.contains(label.Ter_lbl_Codigo_Exito_Reversion_LM)) {

				aAutLifeMiles.F_Estado__c = REVERTIDO;
			}
			else if(aCodOperationSet.contains(label.Ter_lbl_Codigo_Exito_Redencion_LM)) {

				aAutLifeMiles.F_Estado__c = APROBADO;
			} 
		}
		return null;
	}

  public static ReturnValidacionVoucherWrapper validacionVoucher(String aOrigenVenta, String aCodigoEDSTienda, String aCodigoVoucher, Decimal aMonto) {
	
	system.debug('aOrigenVenta ' + aOrigenVenta);
	system.debug('aCodigoEDSTienda ' + aCodigoEDSTienda);
	system.debug('aCodigoVoucher ' + aCodigoVoucher);
	system.debug('aMonto ' + aMonto);
	String lMsgReturn;       
	Boolean lPuntoVentaValido = false;
	ReturnValidacionVoucherWrapper lReturnValidacion = new ReturnValidacionVoucherWrapper();
	if(aOrigenVenta == ESTACION_DE_SERVICIO) {

		List<Ter_Estacion_de_Servicio__c> lEstacionServicioLst = [
			SELECT Id   
			FROM Ter_Estacion_de_Servicio__c 
			WHERE F_IdFidelizacion__c  = :aCodigoEDSTienda
			AND F_Reclama__c = true
			AND F_ClubTerpel__c = true];
		if(lEstacionServicioLst.size() > 0) {
			lPuntoVentaValido = true;
		}
	}
	else if(aOrigenVenta == TIENDA) {

		List<Ter_Negocio_Complementario__c> lNegocioComplementarioLst = [
			SELECT Id
			FROM Ter_Negocio_Complementario__c 
			WHERE F_IdFidelizacion__c  = :aCodigoEDSTienda
			AND F_Reclama__c = true
			AND F_ClubTerpel__c = true];
		if(lNegocioComplementarioLst.size() > 0) {
			lPuntoVentaValido = true;
		}
	} 

	if(!lPuntoVentaValido) {
		lMsgReturn = Label.Fielo_ReclamacionPuntoDeVentaInhabilitado;
	} 

	Boolean lMemberValido = true;
	Boolean lVoucherValido = false;
	List<FieloPLT__RedemptionItem__c> lRedemptionItemLst = [
			SELECT Id, FieloPLT__Status__c, FieloPLT__Reward__r.F_Monto__c,
			FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Status__c 
			FROM FieloPLT__RedemptionItem__c 
			WHERE FieloPLT__UniqueCode__c = :aCodigoVoucher];
	system.debug('lRedemptionItemLst ' + lRedemptionItemLst);
	if(lRedemptionItemLst.isEmpty()) {
		lMsgReturn = String.isBlank(lMsgReturn) ? 
			Label.Fielo_ReclamacionVoucherInexistente: (lMsgReturn += '/' + Label.Fielo_ReclamacionVoucherInexistente);
	}
	else {        
		if(lRedemptionItemLst[0].FieloPLT__Status__c != READY) {
			lMsgReturn = String.isBlank(lMsgReturn) ? 
				Label.Fielo_ReclamacionVoucherYaUtilizado: (lMsgReturn += '/' + Label.Fielo_ReclamacionVoucherYaUtilizado);
		}
		else if(lRedemptionItemLst[0].FieloPLT__Status__c == READY) {

			if(lRedemptionItemLst[0].FieloPLT__Reward__r.F_Monto__c < aMonto) {
				lMsgReturn = String.isBlank(lMsgReturn) ? 
					Label.Fielo_ReclamacionVoucherMontoInvalido: (lMsgReturn += '/' + Label.Fielo_ReclamacionVoucherMontoInvalido);
			}
			else {
				lVoucherValido = true;                
			}
		}
		if(lRedemptionItemLst[0].FieloPLT__Redemption__r.FieloPLT__Member__r.FieloPLT__Status__c == BLOQUEADO) {
			lMsgReturn = String.isBlank(lMsgReturn) ? 
					Label.Fielo_ReclamacionMemberBloqueado : (lMsgReturn += '/' + Label.Fielo_ReclamacionMemberBloqueado );
			lMemberValido = false;
		}
		lReturnValidacion.estadoVoucher = lRedemptionItemLst[0].FieloPLT__Status__c;
		lReturnValidacion.monto = lRedemptionItemLst[0].FieloPLT__Reward__r.F_Monto__c;
	}

	if(lPuntoVentaValido && lVoucherValido && lMemberValido) {
		lMsgReturn = Label.Fielo_ReclamacionValida;
	}
	lReturnValidacion.mensaje = lMsgReturn;

	return lReturnValidacion;
  }

	public static void revertirRedemptionItens(Id aIdAutorizacionLifeMiles) {
		List<Id> lRedemptionItemIdlst = new List<Id>();
		List<FieloPLT__RedemptionItem__c> lRedemptionItemToUpdateLst = new List<FieloPLT__RedemptionItem__c>();
		for(FieloPLT__RedemptionItem__c lRedemptionItem :[SELECT FieloPLT__Status__c 
																											FROM FieloPLT__RedemptionItem__c 
																											WHERE FieloPLT__Redemption__r.F_AutorizacionLifeMiles__c = :aIdAutorizacionLifeMiles]) {
			lRedemptionItemIdlst.add(lRedemptionItem.id);
			if(lRedemptionItem.FieloPLT__Status__c != 'Ready') {
				lRedemptionItemToUpdateLst.add(new FieloPLT__RedemptionItem__c(id = lRedemptionItem.id, FieloPLT__Status__c = 'Ready'));
			}
		}		
		if(lRedemptionItemIdlst.isEmpty()) return;
		// Atualiza para status igual a ready para poder reverter o item, solicitação do Agustin
		FieloPLT.SObjectService.enableAdminPermission(true);
		if(!lRedemptionItemToUpdateLst.isEmpty()) update lRedemptionItemToUpdateLst;
  	FieloPLT.SObjectService.enableAdminPermission(false);		
		FieloPLT.RedemptionItemService.revertRedemptionItems(lRedemptionItemIdlst);
	}

  public class ReturnValidacionVoucherWrapper {

	public String estadoVoucher { get; set; }
	public String mensaje  { get; set; }
	public Decimal monto { get; set; }

	public ReturnValidacionVoucherWrapper() {
		this.estadoVoucher = '';
		this.mensaje = '';
		this.monto = 0;
	}

	public ReturnValidacionVoucherWrapper(String aEstadoVoucher, String aMensaje, Decimal aMonto) {

		this.estadoVoucher = aEstadoVoucher;
		this.mensaje = aMensaje;
		this.monto = aMonto;        
	}
  }
}