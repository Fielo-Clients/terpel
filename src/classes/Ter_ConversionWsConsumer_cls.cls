/**
* Avanxo Colombia
* @author 			Cristian Jose Mosquera Puello href=<cmosquera@avanxo.com>
* Project:			Terpel
* Description:		Classe encargado de Envolver la funcionalidad
*                   de invocar el servicio de rednción.
*					
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		30/05/2017		Cristian Mosquera (CM)		Implementacion inicial de la clase.
**/
public class Ter_ConversionWsConsumer_cls {
	
	private Fielo_ParametrosLifeMiles__c customSettingsLifeMiles;

      /** La utileria de cifrado. **/
    private Ter_UtilEncriptacion_cls ter_utilEncriptacion_cls = new Ter_UtilEncriptacion_cls();
    /**
     * Metodo encargado de invocar el servicio de redencion de millas (Batch o single).
     * @param request los parametros de la peticion.
     * @param mapauthLifeMiles las autorizaciones relacionadas.
     */
    public Ter_ConversionWsResponseDTO_cls invokeMilesConversion
                            (Ter_ConversionWsRequestDTO_cls request,
                                    Map<String, Fielo_Autorizacion_LifeMiles__c>
                                                mapauthLifeMiles) {
        long miliEnviaLM;
        long miliRtaLM;
        Datetime dtRtaLM;
        Ter_LifMilesConversionSchemas_cls.ReqEnvelope requestWs =
                new Ter_LifMilesConversionSchemas_cls.ReqEnvelope();
        Ter_ConversionWsResponseDTO_cls response = null;
        Ter_LifMilesConversionSchemas_cls.ResEnvelope responseWs = null;
        try {
        	this.customSettingsLifeMiles = Fielo_ParametrosLifeMiles__c.getInstance('Ter_Custom_Settings_WS');
        	
            validateInputData(request);

            populateRequest(request, requestWs);
            system.debug('========> requestWs: ' + requestWs);
            /*******************************************/
			Datetime dtEnviaLM =  Datetime.now();
			miliEnviaLM = dtEnviaLM.getTime();
			system.debug('[PostMilesConversion]*************>>>>>>> miliEnviaLM: ' + miliEnviaLM);
			/*******************************************/
            Ter_LifMilesConversionService_cls.CustomBinding_Iws_LMConversion servicio =
                        new Ter_LifMilesConversionService_cls.CustomBinding_Iws_LMConversion();
            servicio.endpoint_x = this.customSettingsLifeMiles.TER_ENDPOINT__c;
            servicio.timeout_x = Integer.ValueOf(this.customSettingsLifeMiles.TER_TIMEOUT__c);
            responseWs = servicio.PostMilesConversion(requestWs);
            Ter_LifMilesConversionSchemas_cls.ResBody resBody = responseWs.body;
            /*******************************************/
			dtRtaLM =  Datetime.now();
			miliRtaLM = dtRtaLM.getTime();
			system.debug('[PostMilesConversion]*************>>>>>>> miliRtaLM: ' + miliRtaLM);
			system.debug('[PostMilesConversion]*************>>>>>>> Diferencia: ' + (miliRtaLM - miliEnviaLM));
			/*******************************************/
			system.debug('========> responseWs: ' + responseWs);

            response = new Ter_ConversionWsResponseDTO_cls();
            populateResponse(response, responseWs);

            return response;
            //Actualizar estado a ejecutado
        }
        catch (Exception e) {
            System.debug('Error =====>' + e.getStackTraceString());
            String responseCode = null;
            
            if(miliEnviaLM == null){
            	miliEnviaLM = 0;
            }
            
            /*******************************************/
			dtRtaLM =  Datetime.now();
			miliRtaLM = dtRtaLM.getTime();
			system.debug('[PostMilesConversion]*************>>>>>>> miliRtaLM Error: ' + miliRtaLM);
			system.debug('[PostMilesConversion]*************>>>>>>> Diferencia Error: ' + (miliRtaLM - miliEnviaLM));
			/*******************************************/

            if (responseWs != null && responseWs.body != null) {
                responseCode = responseWs.body.response_code;
            }
            updateStatusAuthFielo(Label.TER_STATUS_RETRY_CONVERSION_WS,
                    mapauthLifeMiles.get(request.getFieloAutorizacionLifeMilesId()), responseCode);
            throw e;

        }

    }
    
    public Ter_ConversionWsResponseDTO_cls invokeMilesConversion(Fielo_Autorizacion_LifeMiles__c objAutorizacionLifeMiles){
		Ter_ConversionWsRequestDTO_cls objRequest = new Ter_ConversionWsRequestDTO_cls();
		list<Fielo_Autorizacion_LifeMiles__c> lstAutorizacionLifeMilesPadre;
		map<String, Fielo_Autorizacion_LifeMiles__c> mapAutorizacionLifeMiles = new map<String, Fielo_Autorizacion_LifeMiles__c>();
		
		if(objAutorizacionLifeMiles.F_IdTransaccion__c == null){
			objAutorizacionLifeMiles.F_IdTransaccion__c = Ter_Utilidades_cls.obtenerTransaccionIdLifeMiles();
		}
		
		if(objAutorizacionLifeMiles.F_MillasBase__c == null){
			objAutorizacionLifeMiles.F_MillasBase__c = 0;
		}
		
		if(objAutorizacionLifeMiles.F_MillasPromocionales__c == null){
			objAutorizacionLifeMiles.F_MillasPromocionales__c = 0;
		}
		
		if(objAutorizacionLifeMiles.F_TipoTransaccion__c.equals('Crédito (C)')){
			objRequest.setTransactionType('C'); 
		} else if(objAutorizacionLifeMiles.F_TipoTransaccion__c.equals('Débito (D)')){
			objRequest.setTransactionType('D'); //Va a ser usado en fase 2 para la Redención
		} else if(objAutorizacionLifeMiles.F_TipoTransaccion__c.equals('Reversión (R)')){
			objRequest.setTransactionType('R'); 
		} else{
			throw new Ter_AcumulacionException('No se reconoce el tipo de transacción.');
		}
		
		if(objAutorizacionLifeMiles.F_AutorizacionLMPadre__c != null){
			lstAutorizacionLifeMilesPadre = [SELECT F_IdTransaccion__c FROM Fielo_Autorizacion_LifeMiles__c WHERE id = :objAutorizacionLifeMiles.F_AutorizacionLMPadre__c];
			objRequest.setTransactionIdSource(lstAutorizacionLifeMilesPadre.get(0).F_IdTransaccion__c);//Identificador de transaccion a reversar
		}
		
		objRequest.setTransactionId(objAutorizacionLifeMiles.F_IdTransaccion__c);
		objRequest.setMemberId(objAutorizacionLifeMiles.F_NumeroLifeMiles__c);//Numero Lifemiles
		objRequest.setConversionMiles(objAutorizacionLifeMiles.F_MillasBase__c + objAutorizacionLifeMiles.F_MillasPromocionales__c);
		objRequest.setPromotionalMiles(0);
		objRequest.setFieloAutorizacionLifeMilesId(objRequest.getTransactionId());
		
		
		system.debug('========> objRequest: ' + objRequest);
		
		mapAutorizacionLifeMiles.put(objRequest.getFieloAutorizacionLifeMilesId(), objAutorizacionLifeMiles);
		
		return invokeMilesConversion(objRequest, mapAutorizacionLifeMiles);
    }

    /**
     * Metodo encargado de llenar el request del servicio web.
     * @param request el dto con los datos del request.
     * @param requestWs el request como lo espera el servicio.
     */
    public void populateRequest(Ter_ConversionWsRequestDTO_cls request,
                    Ter_LifMilesConversionSchemas_cls.ReqEnvelope requestWs) {
        Ter_LifMilesConversionSchemas_cls.ReqHeader header =
                new Ter_LifMilesConversionSchemas_cls.ReqHeader();
        //Obtener directemente el Username, Password y Sender Code
        

        header.username = ter_utilEncriptacion_cls.encriptarAES256LifeMiles_B64
                                        (this.customSettingsLifeMiles.TER_USERNAME__c);
        header.password = ter_utilEncriptacion_cls.encriptarAES256LifeMiles_B64
                                        (this.customSettingsLifeMiles.TER_PASSWORD__c);
        requestWs.header = header;
        Ter_LifMilesConversionSchemas_cls.ReqBody body =
                new Ter_LifMilesConversionSchemas_cls.ReqBody();
        body.transaction_id = request.getTransactionId();
        body.transaction_id_source = request.getTransactionIdSource();
        body.member_id = request.getMemberId();
        body.transaction_type = request.getTransactionType();
        body.prepurchase_trans = request.getPrepurchaseTrans();
        body.conversion_miles = Integer.valueOf(request.getConversionMiles());
        if (request.getPromotionalMiles() != null) {
            body.promotional_miles = Integer.valueOf(request.getPromotionalMiles());
        }
        body.sender_code = this.customSettingsLifeMiles.TER_SENDER_CODE__c;
        requestWs.body = body;
    }

    /**
     * Metodo responsable de llenar los datos de respuesta.
     * @param response el dto con la respuesta que se desea llenar.
     * @param responseWs la respuesta del servicio.
     */
    public void populateResponse(Ter_ConversionWsResponseDTO_cls response,
            Ter_LifMilesConversionSchemas_cls.ResEnvelope responseWs) {
        Ter_LifMilesConversionSchemas_cls.ResBody resBody = responseWs.body;
        response.setTransactionId(resBody.transaction_id);
        response.setTransactionIdSource(resBody.transaction_id_source);
        response.setAuthoNum(resBody.autho_num);
        response.setMemberId(resBody.member_id);
        response.setLifeMilesNumber(resBody.lifemiles_number);
        response.setTransactionType(resBody.transaction_type);
        response.setPrepurchaseTrans(resBody.prepurchase_trans);
        response.setConversionMiles(resBody.conversion_miles);
        response.setPromotionalMiles(resBody.promotional_miles);
        response.setBonusMiles(resBody.bonus_miles);
        response.setResponseCode(resBody.response_code);
    }


    /**
     * Metodo encargado de actualizar el estado y los reintentos.
     * @param status el estado que desea actualizar.
     * @param la autorizacion que desea actualizar.
     * @param responseCode codigo de respuesta del servicio.
     */
    public  void updateStatusAuthFielo(String status,
            Fielo_Autorizacion_LifeMiles__c authorization, String responseCode) {
        String finalStatus = status;
        Integer maxRetries = Integer.valueOf(Label.TER_MAX_RETRY_CONVERSION_WS);

        if (authorization.F_ReintentosConexionLM__c == null) {
            authorization.F_ReintentosConexionLM__c = 0;
        }
        else {
            authorization.F_ReintentosConexionLM__c += 1;
        }

        if (authorization.F_ReintentosConexionLM__c >= maxRetries ) {
            finalStatus = Label.TER_STATUS_MAX_RETRY_CONVERSION_WS;
        }

        if (responseCode != null) {
            authorization.F_CodigoRespuestaLM__c = responseCode;
        }
        authorization.F_Estado__c = finalStatus ;

    }

    /**
     * Metodo encargado de validar los datos de la peticion.
     * @param los datos de la peticion.
     */
    public void validateInputData(Ter_ConversionWsRequestDTO_cls request) {
        /*if (String.isBlank(request.getUsername())) {
            throw new Ter_ValidationWsException(Label.TER_USERNAME_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getUsername(),
                Integer.valueOf(Label.TER_USERNAME_MAX_CHARACTERS))) {
            throw new Ter_ValidationWsException(Label.TER_USERNAME_EXCEDED_MAX_CHARS);
        }

        if (String.isBlank(request.getPassword())) {
            throw new Ter_ValidationWsException(Label.TER_PASSWORD_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getPassword(),
                Integer.valueOf(Label.TER_PASSWORD_MAX_CHARACTERS))) {
            throw new Ter_ValidationWsException(Label.TER_PASSWORD_EXCEDED_MAX_CHARS);
        }*/

        if (String.isBlank(request.getTransactionId())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionId(),
                Integer.valueOf(Label.TER_TRANSACTION_ID_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_EXCEDED_MAX_CHARS);
        }

        if (!Ter_FormatUtils.checkFormatByRegex(Label.TER_TRANSACTION_ID_REGEX_FORMAT,
                                                            request.getTransactionId())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_INVALID_FORMAT);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionIdSource(),
                Integer.valueOf(Label.TER_TRANSACTION_ID_SOURCE_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_SOURCE_EXCEDED_MAX_CHARS);
        }

        if (!Ter_FormatUtils.checkFormatByRegex(Label.TER_TRANSACTION_ID_REGEX_FORMAT,
                                                        request.getTransactionIdSource())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_ID_SOURCE_INVALID_FORMAT);
        }

        System.debug('###'+request.getMemberId());

        if (String.isBlank(request.getMemberId())) {
            throw new Ter_ValidationWsException(Label.TER_MEMBER_ID_IS_REQUIRED);
        }
        
        if (Ter_FormatUtils.excededMaxCharacters(request.getMemberId(),
                Integer.valueOf(Label.TER_MEMBER_ID_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_MEMBER_ID_EXCEDED_MAX_CHARS);
        }


        if (String.isBlank(request.getTransactionType())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_TYPE_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getTransactionType(),
                Integer.valueOf(Label.TER_TRANSACTION_TYPE_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_TYPE_EXCEDED_MAX_CHARS);
        }

        if (!Ter_FormatUtils.checkFormatByRegex(Label.TER_TRANSACTION_TYPE_REGEX_VALUE,
                                                                    request.getTransactionType())) {
            throw new Ter_ValidationWsException(Label.TER_TRANSACTION_TYPE_INVALID_VALUE);
        }

        /*if (Ter_FormatUtils.excededMaxCharacters(request.getPrepurchaseTrans(),
                Integer.valueOf(Label.TER_PURSHASE_TRANS_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_PURSHASE_TRANS_EXCEDED_MAX_CHARS);
        }*/

        if (request.getConversionMiles() == null) {
            throw new Ter_ValidationWsException(Label.TER_CONVERSION_MILES_IS_REQUIRED);
        }

        /*if (String.isBlank(request.getSenderCode())) {
            throw new Ter_ValidationWsException(Label.TER_SENDER_CODE_IS_REQUIRED);
        }

        if (Ter_FormatUtils.excededMaxCharacters(request.getSenderCode(),
                Integer.valueOf(Label.TER_SENDER_CODE_MAX_CHARS))) {
            throw new Ter_ValidationWsException(Label.TER_SENDER_CODE_EXCEDED_MAX_CHARS);
        }*/
    }
}